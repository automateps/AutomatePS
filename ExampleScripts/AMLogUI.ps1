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
        $rootFolders += Get-AMFolderRoot -Type Task -Connection $connection.Alias
        $rootFolders += Get-AMFolderRoot -Type Process -Connection $connection.Alias
        $rootFolders += Get-AMFolderRoot -Type TaskAgent -Connection $connection.Alias
        $rootFolders += Get-AMFolderRoot -Type ProcessAgent -Connection $connection.Alias

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
    if ($Parent.Path -eq "\") {
        $type = $Parent.Name
    } else {
        if ($Parent.Path -like "\WORKFLOWS*") { $type = "WORKFLOWS" }
        elseif ($Parent.Path -like "\TASKS*") { $type = "TASKS" }
        elseif ($Parent.Path -like "\PROCESSES*") { $type = "PROCESSES" }
        elseif ($Parent.Path -like "\TASKAGENTS*") { $type = "TASKAGENTS" }
        elseif ($Parent.Path -like "\PROCESSAGENTS*") { $type = "PROCESSAGENTS" }
    }
    $results = @()
    $results += $Parent | Get-AMFolder -Connection $Parent.ConnectionAlias
    switch ($type) {
        "WORKFLOWS"     { $results += Get-AMWorkflow -FilterSet @{ Property = "ParentID"; Operator = "="; Value = $Parent.ID } -Connection $Parent.ConnectionAlias -Verbose }
        "TASKS"         { $results += Get-AMTask -FilterSet @{ Property = "ParentID"; Operator = "="; Value = $Parent.ID } -Connection $Parent.ConnectionAlias -Verbose     }
        "PROCESSES"     { $results += Get-AMProcess -FilterSet @{ Property = "ParentID"; Operator = "="; Value = $Parent.ID } -Connection $Parent.ConnectionAlias -Verbose  }
        "TASKAGENTS"    { $results += Get-AMAgent -FilterSet @{ Property = "ParentID"; Operator = "="; Value = $Parent.ID } -Connection $Parent.ConnectionAlias -Verbose    }
        "PROCESSAGENTS" { $results += Get-AMAgent -FilterSet @{ Property = "ParentID"; Operator = "="; Value = $Parent.ID } -Connection $Parent.ConnectionAlias -Verbose    }
        default         { throw "Unsupported type ($type) encountered!" }
    }
    return $results
}

[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    x:Name="Window" Title="Automate Log Viewer" WindowStartupLocation="CenterScreen" Width="1020" Height="650" ShowInTaskbar="True">
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
            <ColumnDefinition Width="50" />
            <ColumnDefinition Width="110" />
            <ColumnDefinition Width="100" />
            <ColumnDefinition Width="50" />
            <ColumnDefinition Width="110" />
            <ColumnDefinition Width="100" />
            <ColumnDefinition Width="100" />
            <ColumnDefinition Width="100" />
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
        <TreeView x:Name="RepositoryTreeView" Grid.Column="0" Grid.Row="2" Grid.ColumnSpan="3" HorizontalAlignment="Stretch" VerticalAlignment="Stretch" Margin="0,5,5,0" IsEnabled="false" />

        <Label x:Name="StartLabel" Content="Start:" HorizontalAlignment="Right" Grid.Column="3" Grid.Row="1" Margin="0,5,5,5" IsEnabled="false" />
        <DatePicker x:Name="StartDatePicker" Grid.Column="4" Grid.Row="1" Margin="5,5,5,5" IsEnabled="false" />
        <ComboBox x:Name="StartTimePicker" Grid.Column="5" Grid.Row="1" Margin="5,5,5,5" IsEditable="true" IsEnabled="false" />
        <Label x:Name="EndLabel" Content="End:" HorizontalAlignment="Right" Grid.Column="6" Grid.Row="1" Margin="0,5,5,5" IsEnabled="false" />
        <DatePicker x:Name="EndDatePicker" Grid.Column="7" Grid.Row="1" Margin="5,5,5,5" IsEnabled="false" />
        <ComboBox x:Name="EndTimePicker" Grid.Column="8" Grid.Row="1" Margin="5,5,5,5" IsEditable="true" IsEnabled="false" />
        <ComboBox x:Name="StatusComboBox" SelectedIndex="0" Grid.Column="9" Grid.Row="1" Margin="5,5,5,5" IsEnabled="false">
            <ComboBoxItem>All</ComboBoxItem>
            <ComboBoxItem>Completed</ComboBoxItem>
            <ComboBoxItem>Running</ComboBoxItem>
            <ComboBoxItem>Success</ComboBoxItem>
            <ComboBoxItem>Failed</ComboBoxItem>
            <ComboBoxItem>Stopped</ComboBoxItem>
            <ComboBoxItem>Paused</ComboBoxItem>
            <ComboBoxItem>Queued</ComboBoxItem>
            <ComboBoxItem>ResumedFromFailure</ComboBoxItem>
        </ComboBox>
        <Button x:Name="SearchButton" Content="Search" Grid.Column="10" Grid.Row="1" Margin="5,5,0,5" IsEnabled="false" />

        <DataGrid x:Name="EventDataGrid" IsReadOnly="true" ColumnWidth="SizeToCells" Grid.Column="3" Grid.Row="2" Grid.ColumnSpan="9" Margin="5,5,0,0" IsEnabled="false" />
    </Grid>
</Window>
"@

$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

$script:connected = $false

$prerequisiteControls = @{}
$prerequisiteControls.Add("Poshv5PrerequisiteLabel"  ,$window.FindName("Poshv5PrerequisiteLabel"))
$prerequisiteControls.Add("Poshv5PrerequisiteButton" ,$window.FindName("Poshv5PrerequisiteButton"))
$prerequisiteControls.Add("AutomatePSPrerequisiteLabel" ,$window.FindName("AutomatePSPrerequisiteLabel"))
$prerequisiteControls.Add("AutomatePSPrerequisiteButton",$window.FindName("AutomatePSPrerequisiteButton"))

$connectionControls = @{}
$connectionControls.Add("AMServerTextBox"   ,$window.FindName("AMServerTextBox"))
$connectionControls.Add("ToggleConnectButton",$window.FindName("ToggleConnectButton"))

$connectedControls = @{}
$connectedControls.Add("RepositoryLabel"   ,$window.FindName("RepositoryLabel"))
$connectedControls.Add("RepositoryTreeView",$window.FindName("RepositoryTreeView"))
$connectedControls.Add("StartDatePicker"   ,$window.FindName("StartDatePicker"))
$connectedControls.Add("StartTimePicker"   ,$window.FindName("StartTimePicker"))
$connectedControls.Add("EndDatePicker"     ,$window.FindName("EndDatePicker"))
$connectedControls.Add("EndTimePicker"     ,$window.FindName("EndTimePicker"))
$connectedControls.Add("StatusComboBox"    ,$window.FindName("StatusComboBox"))
$connectedControls.Add("SearchButton"      ,$window.FindName("SearchButton"))
$connectedControls.Add("EventDataGrid"     ,$window.FindName("EventDataGrid"))

$connectionControls["ToggleConnectButton"].Add_Click({ Toggle-Connect })
$connectionControls["AMServerTextBox"].Add_KeyUp({ param($sender, $e) if ($e.Key -eq "Return") { Toggle-Connect } })

$connectedControls["StartDatePicker"].SelectedDate = (Get-Date).AddDays(-1)
$connectedControls["EndDatePicker"].SelectedDate = Get-Date

$fillTime = Get-Date "12:00AM"
while ($fillTime -le (Get-Date "11:45PM")) {
    $formattedTime = Get-Date $fillTime -Format "hh:mm tt"
    $connectedControls["StartTimePicker"].Items.Add($formattedTime) | Out-Null
    $connectedControls["EndTimePicker"].Items.Add($formattedTime) | Out-Null
    $fillTime = $fillTime.AddMinutes(15)
}
$connectedControls["StartTimePicker"].SelectedIndex = 0
$connectedControls["EndTimePicker"].SelectedIndex = $connectedControls["EndTimePicker"].Items.Count - 1
$connectedControls["SearchButton"].Add_Click({
    if ($null -eq $connectedControls["RepositoryTreeView"].SelectedItem.Tag) {
        $connectedControls["EventDataGrid"].ItemsSource = @(Get-AMInstance -StartDate (Get-Date "$(Get-Date $connectedControls["StartDatePicker"].SelectedDate -Format "d") $($connectedControls["StartTimePicker"].Text)") -EndDate (Get-Date "$(Get-Date $connectedControls["EndDatePicker"].SelectedDate -Format "d") $($connectedControls["EndTimePicker"].Text)") -Status $connectedControls["StatusComboBox"].Text -Verbose | Select-Object StartDateTime,EndDateTime,ResultText,TransactionID,InstanceID)
    } else {
        $connectedControls["EventDataGrid"].ItemsSource = @($connectedControls["RepositoryTreeView"].SelectedItem.Tag | Get-AMInstance -StartDate (Get-Date "$(Get-Date $connectedControls["StartDatePicker"].SelectedDate -Format "d") $($connectedControls["StartTimePicker"].Text)") -EndDate (Get-Date "$(Get-Date $connectedControls["EndDatePicker"].SelectedDate -Format "d") $($connectedControls["EndTimePicker"].Text)") -Status $connectedControls["StatusComboBox"].Text -IncludeRelative -Verbose | Select-Object StartDateTime,EndDateTime,ResultText,TransactionID,InstanceID)
    }
})

if ($PSVersionTable.PSVersion.Major -lt 5) {
    $prerequisiteControls["Poshv5PrerequisiteLabel"].Content = "PowerShell version 5 or greater is required!"
    $prerequisiteControls["Poshv5PrerequisiteButton"].Content = "Download"
    $prerequisiteControls["Poshv5PrerequisiteLabel"].Foreground = "Red"
    $prerequisiteControls["Poshv5PrerequisiteLabel"].Visibility = "Visible"
    $prerequisiteControls["Poshv5PrerequisiteButton"].Visibility = "Visible"
    $prerequisiteControls["Poshv5PrerequisiteButton"].Add_Click({
        [Diagnostics.Process]::Start("https://www.microsoft.com/en-us/download/details.aspx?id=54616")
    })
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