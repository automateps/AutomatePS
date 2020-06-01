using module AutomatePS
Import-Module AutomatePS -Force
Add-Type -AssemblyName PresentationFramework

function Toggle-Connect {
    if ($connected) {
        Disconnect-AMServer
        $script:connected = $false
        $connectionControls["AMServerTextBox"].IsEnabled = $true
        $connectionControls["ToggleConnectButton"].Content = "Connect"
        foreach ($key in $connectedControls.Keys) {
            $connectedControls[$key].IsEnabled = $false
        }
    } else {
        $amServers = $connectionControls["AMServerTextBox"].Text -split "/"
        foreach ($amServer in $amServers) {
            if ($amServer -like "*:*") {
                $split = $amServer -split ":"
                $server = $split[0]
                $port = $split[1]
                $splat = @{ Server = $server; Port = $port; Verbose = $true }
            } else {
                $splat = @{ Server = $amServer; Verbose = $true }
            }
            $alreadyConnected = $false
            foreach ($connection in Get-AMConnection) {
                if ($connection.Server -eq $splat.Server) {
                    if ($null -eq $port) {
                        $alreadyConnected = $true
                    } else {
                        if ($connection.Port -eq $port) {
                            $alreadyConnected = $true
                        }
                    }
                }
            }
            if (-not $alreadyConnected) {
                Connect-AMServer @splat
            }
        }
        if ((Get-AMConnection).Count -gt 0) {
            $script:connected = $true
            $connectionControls["AMServerTextBox"].IsEnabled = $false
            $connectionControls["ToggleConnectButton"].Content = "Disconnect"
            $connectedControls["WorkflowNameLabel"].Content = ""
            $connectedControls["FieldStackView"].Children.Clear()
            $connectedControls["SaveValuesCheckBox"].Visibility = "Hidden"
            $connectedControls["ExecuteButton"].Visibility = "Hidden"
            Load-Repository
            foreach ($key in $connectedControls.Keys) {
                $connectedControls[$key].IsEnabled = $true
            }
        }
    }
}

function Load-Repository {
    $connectedControls["RepositoryTreeView"].Items.Clear()
    foreach ($connection in Get-AMConnection) {
        $rootFolders = @()
        $rootFolders += Get-AMFolderRoot -Type Workflow -Connection $connection.Alias
        
        $connectionTreeViewItem = New-Object System.Windows.Controls.TreeViewItem
        $connectionTreeViewItem.Header = $connection.Alias
        $connectionTreeViewItem.Tag    = $connection
        foreach ($rootFolder in $rootFolders) {
            $treeViewItem = New-Object System.Windows.Controls.TreeViewItem
            $treeViewItem.Header = $rootFolder.Name
            $treeViewItem.Tag    = $rootFolder
            $treeViewItem.Items.Add("Loading...")
            $treeViewItem.Add_Expanded({
                param($sender, $e)
                $treeViewItem = $e.Source
                if ($treeViewItem.Tag.Type -eq "Folder") {
                    $treeViewItem.Items.Clear()
                    foreach ($object in (Load-ChildItems -Parent $treeViewItem.Tag)) {
                        $childTreeViewItem = New-Object System.Windows.Controls.TreeViewItem
                        $childTreeViewItem.Header = $object.Name
                        $childTreeViewItem.Tag    = $object
                        if ($object.Type -eq "Folder") {
                            $childTreeViewItem.Items.Add("Loading...")
                        }
                        [System.Windows.RoutedEventHandler]$treeViewItemSelectedEvent = {
                            if ($_.OriginalSource -is [System.Windows.Controls.TreeViewItem]) {
                                if ($_.OriginalSource.Tag.Type -eq "Workflow") {
                                    Load-Variables -Workflow $_.OriginalSource.Tag
                                }
                            }
                        }
                        $childTreeViewItem.AddHandler([System.Windows.Controls.TreeViewItem]::SelectedEvent, $treeViewItemSelectedEvent)
                        $treeViewItem.Items.Add($childTreeViewItem)
                    }
                }
            })
            $connectionTreeViewItem.Items.Add($treeViewItem)
        }
        $connectedControls["RepositoryTreeView"].Items.Add($connectionTreeViewItem)
    }
}

function Load-ChildItems {
    [CmdletBinding()]
    param (
        $Parent
    )
    $results = @()
    $results += $Parent | Get-AMFolder
    $results += Get-AMWorkflow -FilterSet @{ Property = "ParentID"; Operator = "="; Value = $Parent.ID } -Verbose

    return $results
}

function Load-Variables {
    [CmdletBinding()]
    param (
        $Workflow
    )

    $vars = $Workflow.Variables | Where-Object {$_.DataType -eq 1} | Sort-Object Name
    $connectedControls["WorkflowNameLabel"].Content = $Workflow.Name
    $connectedControls["SaveValuesCheckBox"].Visibility = "Visible"
    $connectedControls["ExecuteButton"].Visibility = "Visible"
    $connectedControls["FieldStackView"].Children.Clear()

    if (($vars | Measure-Object).Count -gt 0) {
        $grid = New-Object System.Windows.Controls.Grid
        # Create column definitions
        $gridCol1 = New-Object System.Windows.Controls.ColumnDefinition
        $gridCol2 = New-Object System.Windows.Controls.ColumnDefinition
        $gridCol1.Width = "auto"
        $gridCol2.Width = "*"
        $grid.ColumnDefinitions.Add($gridCol1)
        $grid.ColumnDefinitions.Add($gridCol2)

        # Create row definitions
        $gridRow = New-Object System.Windows.Controls.RowDefinition
        $grid.RowDefinitions.Add($gridRow)

        # Create header row
        $header1 = New-Object System.Windows.Controls.TextBlock
        $header1.Text = "Variable"
        $header1.FontWeight = "Bold"
        $header2 = New-Object System.Windows.Controls.TextBlock
        $header2.Text = "Initial Value"
        $header2.FontWeight = "Bold"
        [System.Windows.Controls.Grid]::SetColumn($header1, 0)
        [System.Windows.Controls.Grid]::SetRow($header1, 0)
        [System.Windows.Controls.Grid]::SetColumn($header2, 1)
        [System.Windows.Controls.Grid]::SetRow($header2, 0)
        $grid.AddChild($header1)
        $grid.AddChild($header2)

        $index = 1
        foreach ($var in $vars) {
            $textBlock = New-Object System.Windows.Controls.TextBlock
            $textBlock.Text = $var.Name
            $textBlock.Margin = "5,5,5,5"

            $textBox = New-Object System.Windows.Controls.TextBox
            $textBox.Tag = $var.Name
            $textBox.Text = $var.InitalValue
            $textBox.Margin = "5,5,5,5"

            $gridRow = New-Object System.Windows.Controls.RowDefinition
            $grid.RowDefinitions.Add($gridRow)
            [System.Windows.Controls.Grid]::SetColumn($textBlock, 0)
            [System.Windows.Controls.Grid]::SetRow($textBlock, $index)
            [System.Windows.Controls.Grid]::SetColumn($textBox, 1)
            [System.Windows.Controls.Grid]::SetRow($textBox, $index)

            $grid.AddChild($textBlock)
            $grid.AddChild($textBox)
            $index += 1
        }
        $connectedControls["FieldStackView"].AddChild($grid)
    }
}

function Execute-Workflow {
    [CmdletBinding()]
    param ()

    $workflow = $connectedControls["RepositoryTreeView"].SelectedItem.Tag
    $valueChanged = $false
    $originalVariables = @{}
    foreach ($textBox in ($connectedControls["FieldStackView"].Children.Children | Where-Object {$_ -is [System.Windows.Controls.TextBox]})) {
        $originalValue = ($workflow.Variables | Where-Object {$_.Name -eq $textBox.Tag}).InitalValue
        if ($originalValue -ne $textBox.Text) {
            $originalVariables.Add($textBox.Tag, $originalValue)
            ($workflow.Variables | Where-Object {$_.Name -eq $textBox.Tag}).InitalValue = $textBox.Text
            $valueChanged = $true
        }
    }
    if ($valueChanged) {
        # Save workflow with new variable values
        Set-AMWorkflow -Instance $workflow -Verbose
    }
    $workflow | Start-AMWorkflow -Verbose | Wait-AMInstance -Verbose
    Start-Sleep -Seconds 2
    if ($valueChanged -and $connectedControls["SaveValuesCheckBox"].IsChecked) {
        # Revert values back
        foreach ($key in $originalVariables.Keys) {
            ($Workflow.Variables | Where-Object {$_.Name -eq $key}).InitalValue = $originalVariables[$key]
        }
        Set-AMWorkflow -Instance $workflow -Verbose
    }
    Load-Variables -Workflow $workflow.Refresh()
}

[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    x:Name="Window" Title="Automate Parameterized Launcher" WindowStartupLocation="CenterScreen" Width="1020" Height="650" ShowInTaskbar="True">
    <Grid Margin="10,10,10,10">
        <Grid.RowDefinitions>
            <RowDefinition Height="auto" />
            <RowDefinition Height="auto" />
            <RowDefinition Height="*" />
            <RowDefinition Height="auto" />
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="75" />
            <ColumnDefinition Width="100" />
            <ColumnDefinition Width="80" />
            <ColumnDefinition Width="*" />
        </Grid.ColumnDefinitions>

        <Label x:Name="AMServerLabel" Content="Server:" Grid.Column="0" Grid.Row="0" Margin="0,5,5,5" IsEnabled="false" />
        <TextBox x:Name="AMServerTextBox" Grid.Column="1" Grid.Row="0" Margin="5,5,5,5" IsEnabled="false" ToolTip="Specify the server name, or server:port (for a non-standard port)" />
        <Button x:Name="ToggleConnectButton" Content="Connect" Grid.Column="2" Grid.Row="0" Margin="5,5,5,5" IsEnabled="false" />
         
        <Button x:Name="Poshv5PrerequisiteButton" Grid.Column="3" Grid.Row="0" Grid.ColumnSpan="2" Margin="5,5,0,5" Visibility="Hidden" IsEnabled="false" />
        <Label x:Name="Poshv5PrerequisiteLabel" Grid.Column="5" Grid.Row="0" Grid.ColumnSpan="6" Margin="5,5,0,5" Visibility="Hidden" IsEnabled="false" />
        <Button x:Name="AutomatePSPrerequisiteButton" Grid.Column="3" Grid.Row="0" Grid.ColumnSpan="2" Margin="5,5,0,5" Visibility="Hidden" IsEnabled="false" />
        <Label x:Name="AutomatePSPrerequisiteLabel" Grid.Column="5" Grid.Row="0" Grid.ColumnSpan="6" Margin="5,5,0,5" Visibility="Hidden" IsEnabled="false" />

        <Label x:Name="RepositoryLabel" Content="Repository:" Grid.Column="0" Grid.Row="1" IsEnabled="false" />
        <TreeView x:Name="RepositoryTreeView" Grid.Column="0" Grid.Row="2" Grid.ColumnSpan="3" Grid.RowSpan="2" HorizontalAlignment="Stretch" VerticalAlignment="Stretch" Margin="0,5,5,0" IsEnabled="false" />
               
        <ScrollViewer Grid.Column="3" Grid.Row="2" HorizontalScrollBarVisibility="Auto">
            <StackPanel>
                <Label x:Name="WorkflowNameLabel" />
                <StackPanel x:Name="FieldStackView" Grid.Column="3" Grid.Row="2" Margin="5,5,0,0">
                </StackPanel>
            </StackPanel>
        </ScrollViewer> 
        <DockPanel Grid.Column="3" Grid.Row="4">
            <CheckBox x:Name="SaveValuesCheckBox" Visibility="Hidden" IsChecked="true" IsEnabled="false" Margin="0,0,5,0">Save Original Values</CheckBox>
            <Button x:Name="ExecuteButton" Content="Execute" Visibility="Hidden" IsEnabled="false" />
        </DockPanel>
    </Grid>
</Window>
"@

$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

$script:connected = $false

$prerequisiteControls = @{}
$prerequisiteControls.Add("Poshv5PrerequisiteLabel"     ,$window.FindName("Poshv5PrerequisiteLabel"))
$prerequisiteControls.Add("Poshv5PrerequisiteButton"    ,$window.FindName("Poshv5PrerequisiteButton"))
$prerequisiteControls.Add("AutomatePSPrerequisiteLabel" ,$window.FindName("AutomatePSPrerequisiteLabel"))
$prerequisiteControls.Add("AutomatePSPrerequisiteButton",$window.FindName("AutomatePSPrerequisiteButton"))

$connectionControls = @{}
$connectionControls.Add("AMServerTextBox"    ,$window.FindName("AMServerTextBox"))
$connectionControls.Add("ToggleConnectButton",$window.FindName("ToggleConnectButton"))

$connectedControls = @{}
$connectedControls.Add("RepositoryLabel"   ,$window.FindName("RepositoryLabel"))
$connectedControls.Add("RepositoryTreeView",$window.FindName("RepositoryTreeView"))
$connectedControls.Add("WorkflowNameLabel" ,$window.FindName("WorkflowNameLabel"))
$connectedControls.Add("FieldStackView"    ,$window.FindName("FieldStackView"))
$connectedControls.Add("SaveValuesCheckBox",$window.FindName("SaveValuesCheckBox"))
$connectedControls.Add("ExecuteButton"     ,$window.FindName("ExecuteButton"))

$connectionControls["ToggleConnectButton"].Add_Click({ Toggle-Connect })
$connectionControls["AMServerTextBox"].Add_KeyUp({ param($sender, $e) if ($e.Key -eq "Return") { Toggle-Connect } })

$connectedControls["ExecuteButton"].Add_Click({ Execute-Workflow })

if ($PSVersionTable.PSVersion.Major -lt 5) {
    $prerequisiteControls["Poshv5PrerequisiteLabel"].Content = "PowerShell version 5 or greater is required!"
    $prerequisiteControls["Poshv5PrerequisiteButton"].Content = "Download"
    $prerequisiteControls["Poshv5PrerequisiteLabel"].Foreground = "Red"
    $prerequisiteControls["Poshv5PrerequisiteLabel"].Visibility = "Visible"
    $prerequisiteControls["Poshv5PrerequisiteButton"].Visibility = "Visible"
    $prerequisiteControls["Poshv5PrerequisiteButton"].Add_Click({ [Diagnostics.Process]::Start("https://www.microsoft.com/en-us/download/details.aspx?id=54616") })
} elseif ($null -eq (Get-Module AutomatePS -ListAvailable)) {
    $prerequisiteControls["AutomatePSPrerequisiteLabel"].Content = "AutomatePS is not installed!"
    $prerequisiteControls["AutomatePSPrerequisiteButton"].Content = "Install"
    $prerequisiteControls["AutomatePSPrerequisiteLabel"].Foreground = "Red"
    $prerequisiteControls["AutomatePSPrerequisiteLabel"].Visibility = "Visible"
    $prerequisiteControls["AutomatePSPrerequisiteButton"].Visibility = "Visible"
    $prerequisiteControls["AutomatePSPrerequisiteButton"].Add_Click({
        Write-Host "Installing AutomatePS..." -ForegroundColor Green -NoNewline
        Install-Module AutomatePS -Scope CurrentUser -Repository PSGallery -Force
        Write-Host " Done!" -ForegroundColor Green
        $prerequisiteControls["AutomatePSPrerequisiteLabel"].Content = "Please close and reopen!"
        $prerequisiteControls["AutomatePSPrerequisiteLabel"].Foreground = "Orange"
        $prerequisiteControls["AutomatePSPrerequisiteButton"].Visibility = "Hidden"
    })
} else {
	Import-Module AutomatePS
    foreach ($key in $connectionControls.Keys) {
        $connectionControls[$key].IsEnabled = $true
    }
}

$window.Add_Closing({ Disconnect-AMServer })
$window.ShowDialog() | Out-Null