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
        if ($connectionControls["AMServerTextBox"].Text -like "*:*") {
            $split = $connectionControls["AMServerTextBox"].Text -split ":"
            $server = $split[0]
            $port = $split[1]
            $splat = @{ Server = $server; Port = $port; Verbose = $true }
        } else {
            $splat = @{ Server = $connectionControls["AMServerTextBox"].Text; Verbose = $true }
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
    $rootFolder = Get-AMFolderRoot -Type Workflow
    $connectedControls["RepositoryTreeView"].Items.Clear()
    $treeViewItem = New-Object System.Windows.Controls.TreeViewItem
    $treeViewItem.Header = $rootFolder.Name
    $treeViewItem.Tag    = $rootFolder
    $treeViewItem.Items.Add("Loading...")
    $treeViewItem.Add_Expanded({
        param($sender, $e)
        $treeViewItem = $e.Source
        if ($treeViewItem.Tag.Type -eq "Folder") {
            $treeViewItem.Items.Clear()
            foreach ($object in (Load-ChildItems -Parent $treeViewItem.Tag -Debug)) {
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
    $connectedControls["RepositoryTreeView"].Items.Add($treeViewItem)
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

    $connectedControls["WorkflowNameLabel"].Content = $Workflow.Name
    $connectedControls["SaveValuesCheckBox"].Visibility = "Visible"
    $connectedControls["ExecuteButton"].Visibility = "Visible"
    $connectedControls["FieldStackView"].Children.Clear()
    foreach ($var in $Workflow.Variables | Where-Object {$_.DataType -eq 1} | Sort-Object Name) {
        $textBlock = New-Object System.Windows.Controls.TextBlock
        $textBlock.Text = $var.Name
        $textBlock.Margin = "5,5,5,5"

        $textBox = New-Object System.Windows.Controls.TextBox
        $textBox.Tag = $var.Name
        $textBox.Text = $var.InitalValue
        $textBox.Margin = "5,5,5,5"

        $dockPanel = New-Object System.Windows.Controls.DockPanel
        $dockPanel.LastChildFill = $true
        $dockPanel.AddChild($textBlock)
        $dockPanel.AddChild($textBox)

        $connectedControls["FieldStackView"].AddChild($dockPanel)
    }
}

function Execute-Workflow {
    [CmdletBinding()]
    param ()

    $workflow = $connectedControls["RepositoryTreeView"].SelectedItem.Tag
    $valueChanged = $false
    $originalVariables = @{}
    foreach ($dockPanel in $connectedControls["FieldStackView"].Children) {
        $textBox = $dockPanel.Children | Where-Object {$_ -is [System.Windows.Controls.TextBox]}
        $originalValue = ($workflow.Variables | Where-Object {$_.Name -eq $textBox.Tag}).InitalValue
        if ($originalValue -ne $textBox.Text) {
            $originalVariables.Add($textBox.Tag, $originalValue)
            ($workflow.Variables | Where-Object {$_.Name -eq $textBox.Tag}).InitalValue = $textBox.Text
            $valueChanged = $true
        }
    }
    if ($valueChanged) {
        # Save workflow with new variable values
        Set-AMWorkflow -Instance $Workflow -Verbose
    }
    $Workflow | Start-AMWorkflow -Verbose
    if ($valueChanged -and $connectedControls["SaveValuesCheckBox"].IsChecked) {
        # Revert values back
        foreach ($key in $originalVariables.Keys) {
            ($Workflow.Variables | Where-Object {$_.Name -eq $key}).InitalValue = $originalVariables[$key]
        }
        Set-AMWorkflow -Instance $Workflow -Verbose
    }
    Load-Variables -Workflow (Get-AMWorkflow -ID $Workflow.ID)
}

[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    x:Name="Window" Title="AutoMate Parameterized Launcher" WindowStartupLocation="CenterScreen" Width="1020" Height="650" ShowInTaskbar="True">
    <Grid Margin="10,10,10,10">
        <Grid.RowDefinitions>
            <RowDefinition Height="auto" />
            <RowDefinition Height="auto" />
            <RowDefinition Height="*" />
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="75" />
            <ColumnDefinition Width="100" />
            <ColumnDefinition Width="80" />
            <ColumnDefinition Width="*" />
        </Grid.ColumnDefinitions>

        <Label x:Name="AMServerLabel" Content="AM Server:" Grid.Column="0" Grid.Row="0" Margin="0,5,5,5" IsEnabled="false" />
        <TextBox x:Name="AMServerTextBox" Grid.Column="1" Grid.Row="0" Margin="5,5,5,5" IsEnabled="false" ToolTip="Specify the server name, or server:port (for a non-standard port)" />
        <Button x:Name="ToggleConnectButton" Content="Connect" Grid.Column="2" Grid.Row="0" Margin="5,5,5,5" IsEnabled="false" />
         
        <Button x:Name="Poshv5PrerequisiteButton" Grid.Column="3" Grid.Row="0" Grid.ColumnSpan="2" Margin="5,5,0,5" Visibility="Hidden" IsEnabled="false" />
        <Label x:Name="Poshv5PrerequisiteLabel" Grid.Column="5" Grid.Row="0" Grid.ColumnSpan="6" Margin="5,5,0,5" Visibility="Hidden" IsEnabled="false" />
        <Button x:Name="AutoMatePSPrerequisiteButton" Grid.Column="3" Grid.Row="0" Grid.ColumnSpan="2" Margin="5,5,0,5" Visibility="Hidden" IsEnabled="false" />
        <Label x:Name="AutoMatePSPrerequisiteLabel" Grid.Column="5" Grid.Row="0" Grid.ColumnSpan="6" Margin="5,5,0,5" Visibility="Hidden" IsEnabled="false" />

        <Label x:Name="RepositoryLabel" Content="Repository:" Grid.Column="0" Grid.Row="1" IsEnabled="false" />
        <TreeView x:Name="RepositoryTreeView" Grid.Column="0" Grid.Row="2" Grid.ColumnSpan="3" HorizontalAlignment="Stretch" VerticalAlignment="Stretch" Margin="0,5,5,0" IsEnabled="false" />
               
        <ScrollViewer Grid.Column="3" Grid.Row="2" HorizontalScrollBarVisibility="Auto">
            <StackPanel>
                <Label x:Name="WorkflowNameLabel" />
                <StackPanel x:Name="FieldStackView" Grid.Column="3" Grid.Row="2" Margin="5,5,0,0">
                </StackPanel>
                <DockPanel>
                    <CheckBox x:Name="SaveValuesCheckBox" Visibility="Hidden" IsChecked="true" IsEnabled="false" Margin="0,0,5,0">Save Original Values</CheckBox>
                    <Button x:Name="ExecuteButton" Content="Execute" Visibility="Hidden" IsEnabled="false" />
                </DockPanel>
            </StackPanel>
        </ScrollViewer> 
    </Grid>
</Window>
"@

$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

$script:connected = $false

$prerequisiteControls = @{}
$prerequisiteControls.Add("Poshv5PrerequisiteLabel"     ,$window.FindName("Poshv5PrerequisiteLabel"))
$prerequisiteControls.Add("Poshv5PrerequisiteButton"    ,$window.FindName("Poshv5PrerequisiteButton"))
$prerequisiteControls.Add("AutoMatePSPrerequisiteLabel" ,$window.FindName("AutoMatePSPrerequisiteLabel"))
$prerequisiteControls.Add("AutoMatePSPrerequisiteButton",$window.FindName("AutoMatePSPrerequisiteButton"))

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
} elseif ($null -eq (Get-Module AutoMatePS -ListAvailable)) {
    $prerequisiteControls["AutoMatePSPrerequisiteLabel"].Content = "AutoMatePS is not installed!"
    $prerequisiteControls["AutoMatePSPrerequisiteButton"].Content = "Install"
    $prerequisiteControls["AutoMatePSPrerequisiteLabel"].Foreground = "Red"
    $prerequisiteControls["AutoMatePSPrerequisiteLabel"].Visibility = "Visible"
    $prerequisiteControls["AutoMatePSPrerequisiteButton"].Visibility = "Visible"
    $prerequisiteControls["AutoMatePSPrerequisiteButton"].Add_Click({
        Write-Host "Installing AutoMatePS..." -ForegroundColor Green -NoNewline
        Install-Module AutoMatePS -Scope CurrentUser -Repository PSGallery -Force
        Write-Host " Done!" -ForegroundColor Green
        $prerequisiteControls["AutoMatePSPrerequisiteLabel"].Content = "Please close and reopen!"
        $prerequisiteControls["AutoMatePSPrerequisiteLabel"].Foreground = "Orange"
        $prerequisiteControls["AutoMatePSPrerequisiteButton"].Visibility = "Hidden"
    })
} else {
	Import-Module AutoMatePS
    foreach ($key in $connectionControls.Keys) {
        $connectionControls[$key].IsEnabled = $true
    }
}

$window.Add_Closing({ Disconnect-AMServer })
$window.ShowDialog() | Out-Null