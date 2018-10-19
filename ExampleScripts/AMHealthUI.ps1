using module AutoMatePS

Add-Type -AssemblyName PresentationFramework

function ConvertTo-Array {
    BEGIN   { $output = @()   }
    PROCESS { $output += $_   }
    END     { return ,$output }
}

function Load-HealthCheck {
    [CmdletBinding()] param()
    $connected = $false
    foreach ($key in $connectedControls.Keys) {
        $connectedControls[$key].IsEnabled = $true
    }
    $AMServers = $connectionControls["AMServerTextBox"].Text -split "/"
    $connections = @()
    foreach ($AMServer in $AMServers) {
        if ($AMServer -like "*:*") {
            $split = $AMServer -split ":"
            $server = $split[0]
            $port = $split[1]
            if ((Get-AMConnection).Server -notcontains $server) {
                $connections += Connect-AMServer -Server $server -Port $port -Verbose
            }
        } else {
            $server = $AMServer
            if ((Get-AMConnection).Server -notcontains $server) {
                $connections += Connect-AMServer -Server $server -Verbose
            }
        }
    }
    if ($connections.Count -gt 0) {
        $disabledRepoItems = @()
        $unusedRepoItems = @()
        $duplicateRepoItems = @()
        $emptyWorkflows = @()
        $duplicateVariables = @()
        $unbuiltItems = @()
        $invalidItemAgents = @()
        $disconnectedLinks = @()
        $recursiveWorkflows = @()
        $emptyTasks = @()
        $identicalTasks = @()
        $emptyProcesses = @()
        $identicalProcesses = @()
        $emptyConditions = @()
        $identicalConditions = @()
        $nullScheduleConditions = @()
        $usersWithoutAccess = @()
        $emptyUserGroups = @()
        $offlineAgents = @()
        $emptyAgentGroups = @()

        foreach ($connection in $connections) {
            $workflows   = Get-AMWorkflow -Connection $connection.Alias -Verbose
            $tasks       = Get-AMTask -Connection $connection.Alias -Verbose
            $conditions  = Get-AMCondition -Connection $connection.Alias -Verbose
            $processes   = Get-AMProcess -Connection $connection.Alias -Verbose
            $agents      = Get-AMAgent -Connection $connection.Alias -Verbose
            $agentGroups = Get-AMAgentGroup -Connection $connection.Alias -Verbose
            $users       = Get-AMUser -Connection $connection.Alias -Verbose
            $userGroups  = Get-AMUserGroup -Connection $connection.Alias -Verbose
            $allItems    = @($workflows) + @($tasks) + @($conditions) + @($processes)
            $allUsers    = @($users) + @($userGroups)
            $allAgents   = @($agents) + @($agentGroups) + (Get-AMSystemAgent)

            foreach ($workflow in $workflows) {
                if ($workflow.Items.Count -eq 0) {
                    $emptyWorkflows += $workflow
                }
                foreach ($varGroup in ($workflow.Variables | Group-Object Name | Where-Object {$_.Count -gt 1})) {
                    $duplicateVariables += [PSCustomObject]@{
                        Workflow = $workflow.Name
                        Enabled  = $workflow.Enabled
                        Variable = $varGroup.Name
                        Path     = $workflow.Path
                        AMServer = $workflow.AMServer                        
                    }
                }
                foreach ($trigger in $workflow.Triggers) {
                    # Unbuilt items
                    if ($trigger.ConstructID -notin $allItems.ID) {
                        $unbuiltItems += [PSCustomObject]@{
                            Workflow = $workflow.Name
                            Enabled  = $workflow.Enabled
                            ItemType = $trigger.ConstructType -as [AMConstructType]
                            Path     = $workflow.Path
                            AMServer = $workflow.AMServer
                        }
                    }
                    # Invalid item agents
                    if ($trigger.TriggerType -notin [AMTriggerType]::Schedule) {
                        if ($trigger.AgentID -notin $allAgents.ID) {
                            $invalidItemAgents += [PSCustomObject]@{
                                Workflow = $workflow.Name
                                Enabled  = $workflow.Enabled
                                Item     = ($allItems | Where-Object {$_.ID -eq $trigger.ConstructID}).Name
                                ItemType = ($allItems | Where-Object {$_.ID -eq $trigger.ConstructID}).Type
                                Path     = $workflow.Path
                                AMServer = $workflow.AMServer
                            }
                        }
                    }
                }
                foreach ($item in $workflow.Items) {                
                    if ($item.ConstructType -in [AMConstructType]::Workflow,[AMConstructType]::Task,[AMConstructType]::Condition,[AMConstructType]::Process) {
                        # Unbuilt items
                        if ($item.ConstructID -notin $allItems.ID) {
                            $unbuiltItems += [PSCustomObject]@{
                                Workflow = $workflow.Name
                                Enabled  = $workflow.Enabled
                                ItemType = $item.ConstructType -as [AMConstructType]
                                Path     = $workflow.Path
                                AMServer = $workflow.AMServer
                            }
                        }
                        # Invalid item agents
                        if ($item.AgentID -notin $allAgents.ID) {
                            if ($item.ConstructType -notin [AMConstructType]::Workflow) {
                                $invalidItemAgents += [PSCustomObject]@{
                                    Workflow = $workflow.Name
                                    Enabled  = $workflow.Enabled
                                    Item     = ($allItems | Where-Object {$_.ID -eq $item.ConstructID}).Name
                                    ItemType = ($allItems | Where-Object {$_.ID -eq $item.ConstructID}).Type
                                    Path     = $workflow.Path
                                    AMServer = $workflow.AMServer
                                }
                            }
                        }
                    }
                }
                # Disconnected links
                foreach ($link in $workflow.Links) {
                    if (($null -eq $link.SourceID) -or ($null -eq $link.DestinationID)) {
                        $disconnectedLinks += [PSCustomObject]@{
                            Workflow = $workflow.Name
                            Enabled  = $workflow.Enabled
                            Type = $link.LinkType -as [AMLinkType]
                            Path     = $workflow.Path
                            AMServer = $workflow.AMServer
                        }
                    } elseif (-not (($link.SourceID -in @($workflow.Triggers.ID) + @($workflow.Items.ID)) -and
                        ($link.DestinationID -in @($workflow.Triggers.ID) + @($workflow.Items.ID)))) {
                        $disconnectedLinks += [PSCustomObject]@{
                            Workflow = $workflow.Name
                            Enabled  = $workflow.Enabled
                            Type = $link.LinkType -as [AMLinkType]
                            Path     = $workflow.Path
                            AMServer = $workflow.AMServer
                        }
                    }
                }
                # Recursive workflows
                if ($workflow.Items.ConstructID -contains $workflow.ID) {
                    $recursiveWorkflows += $workflow
                }

            }

            $disabledRepoItems += $workflows | Where-Object {-not $_.Enabled}
            $disabledRepoItems += $tasks | Where-Object {-not $_.Enabled}
            $disabledRepoItems += $conditions | Where-Object {-not $_.Enabled}
            $disabledRepoItems += $processes | Where-Object {-not $_.Enabled}

            $unusedRepoItems += $tasks | Where-Object {$_.ID -notin @($workflows.Triggers.ConstructID) + @($workflows.Items.ConstructID)}
            $unusedRepoItems += $conditions | Where-Object {$_.ID -notin @($workflows.Triggers.ConstructID) + @($workflows.Items.ConstructID)}
            $unusedRepoItems += $processes | Where-Object {$_.ID -notin @($workflows.Triggers.ConstructID) + @($workflows.Items.ConstructID)}

            $duplicateRepoItems += ($workflows | Group-Object Name,AMServer | Where-Object {$_.Count -gt 1}).Group
            $duplicateRepoItems += ($tasks | Group-Object Name,AMServer | Where-Object {$_.Count -gt 1}).Group
            $duplicateRepoItems += ($conditions | Group-Object Name,AMServer | Where-Object {$_.Count -gt 1}).Group
            $duplicateRepoItems += ($processes | Group-Object Name,AMServer | Where-Object {$_.Count -gt 1}).Group

            $emptyTasks += $tasks | Where-Object {$_.AML -eq ""}
            $identicalTasks += ($tasks | Group-Object AML,AMServer | Where-Object {$_.Count -gt 1}).Group

            $emptyProcesses += $processes | Where-Object {$_.CommandLine -eq ""}
            $identicalProcesses += ($processes | Group-Object CommandLine,EnvironmentVariables,RunProcessAs,WorkingDirectory,AMServer | Where-Object {$_.Count -gt 1}).Group

            $emptyConditions += $conditions | Where-Object {$_.Empty} | Select-Object Name,Enabled,Type,@{Name="ConditionType";Expression={$_.TriggerType -as [AMTriggerType]}},Path,AMServer
            $nullScheduleConditions += $conditions | Where-Object {$_.TriggerType -eq [AMTriggerType]::Schedule.value -and $_.NextLaunchDate -eq ''}

            $excludedConditionProperties = @("___type","ID","Name","ParentID","Path","Type","CompletionState","CreatedBy","CreatedOn","Empty","Enabled","EndedOn","ExclusionSchedules","LockedBy","ModifiedOn","Notes","Removed","ResultCode","ResultText","StartedOn","Version","VersionDate","AssociatedTaskID","Description","InstanceID","Type")
            foreach ($triggerType in ($conditions | Group-Object TriggerType)) {
                $groupProperties = ($triggerType.Group[0] | Get-Member -MemberType NoteProperty | Where-Object {$_.Name -notin $excludedConditionProperties}).Name
                $identicalConditions += ($triggerType.Group | Group-Object $groupProperties | Where-Object {$_.Count -gt 1}).Group | Select-Object Name,Enabled,Type,@{Name="ConditionType";Expression={$_.TriggerType -as [AMTriggerType]}},Path,AMServer
            }

            $usersWithAccess = @()
            foreach ($perm in Get-AMSystemPermission -Connection $connection.Alias) {
                $object = $allUsers | Where-Object {$_.ID -eq $group.ID}
                if ($object.Type -eq "User") {
                    $usersWithAccess += $object
                } else {
                    $usersWithAccess += $allUsers | Where-Object {$_.ID -in ($allUsers | Where-Object {$_.Type -eq "UserGroup"}).UserIDs}
                }
            }
            $usersWithoutAccess += $allUsers | Where-Object {($_.Type -eq "User") -and ($_ -notin $usersWithAccess) -and ($_.Name -ne "Administrator")}

            $emptyUserGroups += $userGroups | Where-Object {$_.UserIDs.Count -eq 0}

            $offlineAgents += $agents | Where-Object {-not $_.Online}

            $emptyAgentGroups += $agentGroups | Where-Object {$_.AgentIDs.Count -eq 0}

            Write-Verbose "$($connection.Server):$($connection.Port) : Done!"
        }

        $uiData = @()
        $uiData += [PSCustomObject]@{ ItemsSourceVariable = "disabledRepoItems";      TabItem = "DisabledRepoItemsTabItem";      TabItemHeader = "Disabled Repository Items";    DataGrid = "DisabledRepoItemsDataGrid" }
        $uiData += [PSCustomObject]@{ ItemsSourceVariable = "unusedRepoItems";        TabItem = "UnusedRepoItemsTabItem";        TabItemHeader = "Unused Repository Items";      DataGrid = "UnusedRepoItemsDataGrid" }
        $uiData += [PSCustomObject]@{ ItemsSourceVariable = "duplicateRepoItems";     TabItem = "DuplicateRepoItemsTabItem";     TabItemHeader = "Duplicate Repository Items";   DataGrid = "DuplicateRepoItemsDataGrid" }
        $uiData += [PSCustomObject]@{ ItemsSourceVariable = "emptyWorkflows";         TabItem = "EmptyWorkflowsTabItem";         TabItemHeader = "Empty Workflows";              DataGrid = "EmptyWorkflowsDataGrid" }
        $uiData += [PSCustomObject]@{ ItemsSourceVariable = "duplicateVariables";     TabItem = "DuplicateVariablesTabItem";     TabItemHeader = "Duplicate Variable Names";     DataGrid = "DuplicateVariablesDataGrid" }
        $uiData += [PSCustomObject]@{ ItemsSourceVariable = "unbuiltItems";           TabItem = "UnbuiltItemsTabItem";           TabItemHeader = "Unbuilt Workflow Items";       DataGrid = "UnbuiltItemsDataGrid" }
        $uiData += [PSCustomObject]@{ ItemsSourceVariable = "invalidItemAgents";      TabItem = "InvalidAgentsTabItem";          TabItemHeader = "Invalid Workflow Item Agents"; DataGrid = "InvalidAgentsDataGrid" }
        $uiData += [PSCustomObject]@{ ItemsSourceVariable = "disconnectedLinks";      TabItem = "DisconnectedLinksTabItem";      TabItemHeader = "Disconnected Workflow Links";  DataGrid = "DisconnectedLinksDataGrid" }
        $uiData += [PSCustomObject]@{ ItemsSourceVariable = "recursiveWorkflows";     TabItem = "RecursiveWorkflowsTabItem";     TabItemHeader = "Recursive Workflows";          DataGrid = "RecursiveWorkflowsDataGrid" }
        $uiData += [PSCustomObject]@{ ItemsSourceVariable = "emptyTasks";             TabItem = "EmptyTasksTabItem";             TabItemHeader = "Empty Tasks";                  DataGrid = "EmptyTasksDataGrid" }
        $uiData += [PSCustomObject]@{ ItemsSourceVariable = "identicalTasks";         TabItem = "IdenticalTasksTabItem";         TabItemHeader = "Identical Tasks";              DataGrid = "IdenticalTasksDataGrid" }
        $uiData += [PSCustomObject]@{ ItemsSourceVariable = "emptyProcesses";         TabItem = "EmptyProcessesTabItem";         TabItemHeader = "Empty Processes";              DataGrid = "EmptyProcessesDataGrid" }
        $uiData += [PSCustomObject]@{ ItemsSourceVariable = "identicalProcesses";     TabItem = "IdenticalProcessesTabItem";     TabItemHeader = "Identical Processes";          DataGrid = "IdenticalProcessesDataGrid" }
        $uiData += [PSCustomObject]@{ ItemsSourceVariable = "emptyConditions";        TabItem = "EmptyConditionsTabItem";        TabItemHeader = "Empty Conditions";             DataGrid = "EmptyConditionsDataGrid" }
        $uiData += [PSCustomObject]@{ ItemsSourceVariable = "identicalConditions";    TabItem = "IdenticalConditionsTabItem";    TabItemHeader = "Identical Conditions";         DataGrid = "IdenticalConditionsDataGrid" }
        $uiData += [PSCustomObject]@{ ItemsSourceVariable = "nullScheduleConditions"; TabItem = "NullScheduleConditionsTabItem"; TabItemHeader = "Null Schedule Conditions";     DataGrid = "NullScheduleConditionsDataGrid" }
        $uiData += [PSCustomObject]@{ ItemsSourceVariable = "usersWithoutAccess";     TabItem = "UsersWithoutAccessTabItem";     TabItemHeader = "Users Without Access";         DataGrid = "UsersWithoutAccessDataGrid" }
        $uiData += [PSCustomObject]@{ ItemsSourceVariable = "emptyUserGroups";        TabItem = "EmptyUserGroupsTabItem";        TabItemHeader = "Empty User Groups";            DataGrid = "EmptyUserGroupsDataGrid" }
        $uiData += [PSCustomObject]@{ ItemsSourceVariable = "offlineAgents";          TabItem = "OfflineAgentsTabItem";          TabItemHeader = "Offline Agents";               DataGrid = "OfflineAgentsDataGrid" }
        $uiData += [PSCustomObject]@{ ItemsSourceVariable = "emptyAgentGroups";       TabItem = "EmptyAgentGroupsTabItem";       TabItemHeader = "Empty Agent Groups";           DataGrid = "EmptyAgentGroupsDataGrid" }

        foreach ($uid in $uiData) {
            $itemsSource = (Get-Variable $uid.ItemsSourceVariable).Value | Where-Object {$null -ne $_} | ConvertTo-Array
            $connectedControls[$uid.DataGrid].ItemsSource = $itemsSource
            $connectedControls[$uid.TabItem].Header = "$($uid.TabItemHeader) ($($itemsSource.Count))"
            if ($itemsSource.Count -eq 0) {
                $connectedControls[$uid.TabItem].Foreground = "Green"
            } else {
                $connectedControls[$uid.TabItem].Foreground = "Orange"
            }
        }
    }

    foreach ($key in $connectedControls.Keys) {
        $connectedControls[$key].IsEnabled = $true
    }
    Write-Verbose "Done!"
}

$xamlDataGrid = @"
<DataGrid x:Name="{0}" AutoGenerateColumns="False" IsReadOnly="true" ColumnWidth="Auto" Grid.Row="1" IsEnabled="false">
    <DataGrid.Columns>
        <DataGridTextColumn Width="Auto" Header="Name" Binding="{{Binding Name}}"/>
        <DataGridTextColumn Width="Auto" Header="Enabled" Binding="{{Binding Enabled}}"/>
        <DataGridTextColumn Width="Auto" Header="Type" Binding="{{Binding Type}}"/>
        <DataGridTextColumn Width="Auto" Header="Path" Binding="{{Binding Path}}"/>
        <DataGridTextColumn Width="Auto" Header="Connection" Binding="{{Binding ConnectionAlias}}"/>
    </DataGrid.Columns>
</DataGrid>
"@

[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    x:Name="Window" Title="AutoMate Health Check" WindowStartupLocation="CenterScreen" Width="1000" Height="750" ShowInTaskbar="True">
    <Grid Margin="10,10,10,10">
        <Grid.RowDefinitions>
            <RowDefinition Height="auto" />
            <RowDefinition Height="*" />
        </Grid.RowDefinitions>

        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="75" />
            <ColumnDefinition Width="250" />
            <ColumnDefinition Width="100" />
            <ColumnDefinition Width="100" />
            <ColumnDefinition Width="*" />
        </Grid.ColumnDefinitions>

        <Label Content="AM Server:" Grid.Column="0" Grid.Row="0" Margin="0,5,5,5" />
        <TextBox x:Name="AMServerTextBox" Grid.Column="1" Grid.Row="0" Margin="5,5,5,5" ToolTip="Specify the server name, or server:port (for a non-standard port).  Multiple servers can be separated by a /, for example: server01/server02." IsEnabled="false" />
        <Button x:Name="CheckHealthButton" Content="Check Health" Grid.Column="2" Grid.Row="0" Margin="5,5,5,5" IsEnabled="false" />
                
        <Button x:Name="Poshv5PrerequisiteButton" Grid.Column="3" Grid.Row="0" Margin="5,5,0,5" Visibility="Hidden" />
        <Label x:Name="Poshv5PrerequisiteLabel" Grid.Column="4" Grid.Row="0" Margin="5,5,0,5" Visibility="Hidden" />
        <Button x:Name="AutoMatePSPrerequisiteButton" Grid.Column="3" Grid.Row="0" Margin="5,5,0,5" Visibility="Hidden" />
        <Label x:Name="AutoMatePSPrerequisiteLabel" Grid.Column="4" Grid.Row="0" Margin="5,5,0,5" Visibility="Hidden" />

        <TabControl x:Name="NavTabControl" Grid.Column="0" Grid.Row="1" Grid.ColumnSpan="5">
            <TabItem x:Name="AllTabItem" Header="All">
                <TabControl x:Name="AllTabControl">
                    <TabItem x:Name="DisabledRepoItemsTabItem" Header="Disabled Repository Items">
                        <Grid>
                            <Grid.RowDefinitions><RowDefinition Height="Auto" /><RowDefinition Height="*" /></Grid.RowDefinitions>
                            <Grid.ColumnDefinitions><ColumnDefinition Width="*" /></Grid.ColumnDefinitions>

                            <Label Content="All disabled objects in the repository." Grid.Row="0" />
                            $($xamlDataGrid -f "DisabledRepoItemsDataGrid")
                        </Grid>
                    </TabItem>
                    <TabItem x:Name="UnusedRepoItemsTabItem" Header="Unused Repository Items">
                        <Grid>
                            <Grid.RowDefinitions><RowDefinition Height="Auto" /><RowDefinition Height="*" /><RowDefinition Height="Auto" /></Grid.RowDefinitions>
                            <Grid.ColumnDefinitions><ColumnDefinition Width="*" /></Grid.ColumnDefinitions>

                            <Label Content="All objects in the repository not used in a workflow." Grid.Row="0" />
                            $($xamlDataGrid -f "UnusedRepoItemsDataGrid")
                            <Button x:Name="DeleteUnusedRepoItemsButton" Content="Delete Selected Items" Grid.Row="2" Margin="5,5,0,5" IsEnabled="false" />
                        </Grid>
                    </TabItem>
                    <TabItem x:Name="DuplicateRepoItemsTabItem" Header="Duplicate Repository Items">
                        <Grid>
                            <Grid.RowDefinitions><RowDefinition Height="Auto" /><RowDefinition Height="*" /></Grid.RowDefinitions>
                            <Grid.ColumnDefinitions><ColumnDefinition Width="*" /></Grid.ColumnDefinitions>

                            <Label Content="Any objects in the repository that share the same name as another object of the same type." Grid.Row="0" />
                            $($xamlDataGrid -f "DuplicateRepoItemsDataGrid")
                        </Grid>
                    </TabItem>
                </TabControl>
            </TabItem>
            <TabItem x:Name="WorkflowsTabItem" Header="Workflows">
                <TabControl x:Name="WorkflowsTabControl">
                    <TabItem x:Name="EmptyWorkflowsTabItem" Header="Empty Workflows">
                        <Grid>
                            <Grid.RowDefinitions><RowDefinition Height="Auto" /><RowDefinition Height="*" /></Grid.RowDefinitions>
                            <Grid.ColumnDefinitions><ColumnDefinition Width="*" /></Grid.ColumnDefinitions>
                                                     
                            <Label Content="Any workflows that contain no items." Grid.Row="0" />
                            $($xamlDataGrid -f "EmptyWorkflowsDataGrid")
                        </Grid>
                    </TabItem>
                    <TabItem x:Name="DuplicateVariablesTabItem" Header="Duplicate Variable Names">
                        <Grid>
                            <Grid.RowDefinitions><RowDefinition Height="Auto" /><RowDefinition Height="*" /></Grid.RowDefinitions>
                            <Grid.ColumnDefinitions><ColumnDefinition Width="*" /></Grid.ColumnDefinitions>
                                                     
                            <Label Content="Any workflows containing multiple variables with the same name." Grid.Row="0" />
                            <DataGrid x:Name="DuplicateVariablesDataGrid" IsReadOnly="true" ColumnWidth="Auto" Grid.Row="1" IsEnabled="false" />
                        </Grid>
                    </TabItem>
                    <TabItem x:Name="UnbuiltItemsTabItem" Header="Unbuilt Workflow Items">
                        <Grid>
                            <Grid.RowDefinitions><RowDefinition Height="Auto" /><RowDefinition Height="*" /></Grid.RowDefinitions>
                            <Grid.ColumnDefinitions><ColumnDefinition Width="*" /></Grid.ColumnDefinitions>
                                                     
                            <Label Content="Any workflows containing an unbuilt item." Grid.Row="0" />
                            <DataGrid x:Name="UnbuiltItemsDataGrid" IsReadOnly="true" ColumnWidth="Auto" Grid.Row="1" IsEnabled="false" />
                        </Grid>
                    </TabItem>
                    <TabItem x:Name="InvalidAgentsTabItem" Header="Invalid Workflow Item Agents">
                        <Grid>
                            <Grid.RowDefinitions><RowDefinition Height="Auto" /><RowDefinition Height="*" /></Grid.RowDefinitions>
                            <Grid.ColumnDefinitions><ColumnDefinition Width="*" /></Grid.ColumnDefinitions>
                                                     
                            <Label Content="Any workflow items assigned to an agent that does not exist (appears as '???' in the Workflow Designer)." Grid.Row="0" />
                            <DataGrid x:Name="InvalidAgentsDataGrid" IsReadOnly="true" ColumnWidth="Auto" Grid.Row="1" IsEnabled="false" />
                        </Grid>
                    </TabItem>
                    <TabItem x:Name="DisconnectedLinksTabItem" Header="Disconnected Workflow Links">
                        <Grid>
                            <Grid.RowDefinitions><RowDefinition Height="Auto" /><RowDefinition Height="*" /></Grid.RowDefinitions>
                            <Grid.ColumnDefinitions><ColumnDefinition Width="*" /></Grid.ColumnDefinitions>
                                                     
                            <Label Content="Any workflows containing a disconnected link." Grid.Row="0" />
                            <DataGrid x:Name="DisconnectedLinksDataGrid" IsReadOnly="true" ColumnWidth="Auto" Grid.Row="1" IsEnabled="false" />
                        </Grid>
                    </TabItem>
                    <TabItem x:Name="RecursiveWorkflowsTabItem" Header="Disconnected Workflow Links">
                        <Grid>
                            <Grid.RowDefinitions><RowDefinition Height="Auto" /><RowDefinition Height="*" /></Grid.RowDefinitions>
                            <Grid.ColumnDefinitions><ColumnDefinition Width="*" /></Grid.ColumnDefinitions>
                                                     
                            <Label Content="Any workflow that contains itself as an item.  If these aren't designed carefully, an infinite loop could occur." Grid.Row="0" />                            
                            $($xamlDataGrid -f "RecursiveWorkflowsDataGrid")
                        </Grid>
                    </TabItem>
                </TabControl>
            </TabItem>
            <TabItem x:Name="TasksTabItem" Header="Tasks">
                <TabControl x:Name="TasksTabControl">
                    <TabItem x:Name="EmptyTasksTabItem" Header="Empty Tasks">
                        <Grid>
                            <Grid.RowDefinitions><RowDefinition Height="Auto" /><RowDefinition Height="*" /></Grid.RowDefinitions>
                            <Grid.ColumnDefinitions><ColumnDefinition Width="*" /></Grid.ColumnDefinitions>
                                                     
                            <Label Content="Any tasks that are empty." Grid.Row="0" />
                            $($xamlDataGrid -f "EmptyTasksDataGrid")
                        </Grid>
                    </TabItem>
                    <TabItem x:Name="IdenticalTasksTabItem" Header="Identical Tasks">
                        <Grid>
                            <Grid.RowDefinitions><RowDefinition Height="Auto" /><RowDefinition Height="*" /></Grid.RowDefinitions>
                            <Grid.ColumnDefinitions><ColumnDefinition Width="*" /></Grid.ColumnDefinitions>
                                                     
                            <Label Content="Any tasks that have identical AML code." Grid.Row="0" />
                            $($xamlDataGrid -f "IdenticalTasksDataGrid")
                        </Grid>
                    </TabItem>
                </TabControl>
            </TabItem>
            <TabItem x:Name="ProcessesTabItem" Header="Processes">
                <TabControl x:Name="ProcessesTabControl">
                    <TabItem x:Name="EmptyProcessesTabItem" Header="Empty Processes">
                        <Grid>
                            <Grid.RowDefinitions><RowDefinition Height="Auto" /><RowDefinition Height="*" /></Grid.RowDefinitions>
                            <Grid.ColumnDefinitions><ColumnDefinition Width="*" /></Grid.ColumnDefinitions>
                                                     
                            <Label Content="Any processes that do not have a command." Grid.Row="0" />
                            $($xamlDataGrid -f "EmptyProcessesDataGrid")
                        </Grid>
                    </TabItem>
                    <TabItem x:Name="IdenticalProcessesTabItem" Header="Identical Processes">
                        <Grid>
                            <Grid.RowDefinitions><RowDefinition Height="Auto" /><RowDefinition Height="*" /></Grid.RowDefinitions>
                            <Grid.ColumnDefinitions><ColumnDefinition Width="*" /></Grid.ColumnDefinitions>
                                                     
                            <Label Content="Any processes that have the same command, environment variables, context and working directory." Grid.Row="0" />
                            $($xamlDataGrid -f "IdenticalProcessesDataGrid")
                        </Grid>
                    </TabItem>
                </TabControl>
            </TabItem>
            <TabItem x:Name="ConditionsTabItem" Header="Conditions">
                <TabControl x:Name="ConditionsTabControl">
                    <TabItem x:Name="EmptyConditionsTabItem" Header="Empty Conditions">
                        <Grid>
                            <Grid.RowDefinitions><RowDefinition Height="Auto" /><RowDefinition Height="*" /></Grid.RowDefinitions>
                            <Grid.ColumnDefinitions><ColumnDefinition Width="*" /></Grid.ColumnDefinitions>
                                                     
                            <Label Content="Any conditions that are empty." Grid.Row="0" />
                            $($xamlDataGrid -f "EmptyConditionsDataGrid")
                        </Grid>
                    </TabItem>
                    <TabItem x:Name="IdenticalConditionsTabItem" Header="Identical Conditions">
                        <Grid>
                            <Grid.RowDefinitions><RowDefinition Height="Auto" /><RowDefinition Height="*" /></Grid.RowDefinitions>
                            <Grid.ColumnDefinitions><ColumnDefinition Width="*" /></Grid.ColumnDefinitions>
                                                     
                            <Label Content="Any conditions that have identical settings (NOTE: this is a work in progress and could produce false positives)." Grid.Row="0" />
                            $($xamlDataGrid -f "IdenticalConditionsDataGrid")
                        </Grid>
                    </TabItem>
                    <TabItem x:Name="NullScheduleConditionsTabItem" Header="Null Schedule Conditions">
                        <Grid>
                            <Grid.RowDefinitions><RowDefinition Height="Auto" /><RowDefinition Height="*" /></Grid.RowDefinitions>
                            <Grid.ColumnDefinitions><ColumnDefinition Width="*" /></Grid.ColumnDefinitions>
                                                     
                            <Label Content="Any schedule conditions that don't have the 'Next Launch Date' configured." Grid.Row="0" />
                            $($xamlDataGrid -f "NullScheduleConditionsDataGrid")
                        </Grid>
                    </TabItem>
                </TabControl>
            </TabItem>
            <TabItem x:Name="UsersTabItem" Header="Users">
                <TabControl x:Name="UsersTabControl">
                    <TabItem x:Name="UsersWithoutAccessTabItem" Header="Users Without Access">
                        <Grid>
                            <Grid.RowDefinitions><RowDefinition Height="Auto" /><RowDefinition Height="*" /></Grid.RowDefinitions>
                            <Grid.ColumnDefinitions><ColumnDefinition Width="*" /></Grid.ColumnDefinitions>
                                                     
                            <Label Content="Any users that aren't granted access to the system." Grid.Row="0" />
                            $($xamlDataGrid -f "UsersWithoutAccessDataGrid")
                        </Grid>
                    </TabItem>
                </TabControl>
            </TabItem>
            <TabItem x:Name="UserGroupsTabItem" Header="User Groups">
                <TabControl x:Name="UserGroupsTabControl">
                    <TabItem x:Name="EmptyUserGroupsTabItem" Header="Empty User Groups">
                        <Grid>
                            <Grid.RowDefinitions><RowDefinition Height="Auto" /><RowDefinition Height="*" /></Grid.RowDefinitions>
                            <Grid.ColumnDefinitions><ColumnDefinition Width="*" /></Grid.ColumnDefinitions>
                                                     
                            <Label Content="Any user groups that contain no users." Grid.Row="0" />
                            $($xamlDataGrid -f "EmptyUserGroupsDataGrid")
                        </Grid>
                    </TabItem>
                </TabControl>
            </TabItem>
            <TabItem x:Name="AgentsTabItem" Header="Agents">
                <TabControl x:Name="AgentsTabControl">
                    <TabItem x:Name="OfflineAgentsTabItem" Header="Offline Agents">
                        <Grid>
                            <Grid.RowDefinitions><RowDefinition Height="Auto" /><RowDefinition Height="*" /></Grid.RowDefinitions>
                            <Grid.ColumnDefinitions><ColumnDefinition Width="*" /></Grid.ColumnDefinitions>
                                                     
                            <Label Content="Any agents that are currently offline." Grid.Row="0" />
                            $($xamlDataGrid -f "OfflineAgentsDataGrid")
                        </Grid>
                    </TabItem>
                </TabControl>
            </TabItem>
            <TabItem x:Name="AgentGroupsTabItem" Header="Agent Groups">
                <TabControl x:Name="AgentGroupsTabControl">
                    <TabItem x:Name="EmptyAgentGroupsTabItem" Header="Empty Agent Groups">
                        <Grid>
                            <Grid.RowDefinitions><RowDefinition Height="Auto" /><RowDefinition Height="*" /></Grid.RowDefinitions>
                            <Grid.ColumnDefinitions><ColumnDefinition Width="*" /></Grid.ColumnDefinitions>
                                                     
                            <Label Content="Any agent groups that contain no agents." Grid.Row="0" />
                            $($xamlDataGrid -f "EmptyAgentGroupsDataGrid")
                        </Grid>
                    </TabItem>
                </TabControl>
            </TabItem>
        </TabControl>
    </Grid>
</Window>
"@

$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

$script:connected = $false

$prerequisiteControls = @{}
$prerequisiteControls.Add("Poshv5PrerequisiteLabel"  ,$window.FindName("Poshv5PrerequisiteLabel"))
$prerequisiteControls.Add("Poshv5PrerequisiteButton" ,$window.FindName("Poshv5PrerequisiteButton"))
$prerequisiteControls.Add("AutoMatePSPrerequisiteLabel" ,$window.FindName("AutoMatePSPrerequisiteLabel"))
$prerequisiteControls.Add("AutoMatePSPrerequisiteButton",$window.FindName("AutoMatePSPrerequisiteButton"))

$connectionControls = @{}
$connectionControls.Add("AMServerTextBox"  ,$window.FindName("AMServerTextBox"))
$connectionControls.Add("CheckHealthButton" ,$window.FindName("CheckHealthButton"))

$connectedControls = @{}
$connectedControls.Add("AllTabControl"             ,$window.FindName("AllTabControl"))
$connectedControls.Add("WorkflowsTabControl"       ,$window.FindName("WorkflowsTabControl"))
$connectedControls.Add("TasksTabControl"           ,$window.FindName("TasksTabControl"))
$connectedControls.Add("ProcessesTabControl"       ,$window.FindName("ProcessesTabControl"))
$connectedControls.Add("ConditionsTabControl"      ,$window.FindName("ConditionsTabControl"))
$connectedControls.Add("UsersTabControl"           ,$window.FindName("UsersTabControl"))
$connectedControls.Add("UserGroupsTabControl"      ,$window.FindName("UserGroupsTabControl"))
$connectedControls.Add("AgentsTabControl"          ,$window.FindName("AgentsTabControl"))
$connectedControls.Add("AgentGroupsTabControl"     ,$window.FindName("AgentGroupsTabControl"))

$connectedControls.Add("DisabledRepoItemsTabItem"      ,$window.FindName("DisabledRepoItemsTabItem"))
$connectedControls.Add("UnusedRepoItemsTabItem"        ,$window.FindName("UnusedRepoItemsTabItem"))
$connectedControls.Add("DeleteUnusedRepoItemsButton"   ,$window.FindName("DeleteUnusedRepoItemsButton"))
$connectedControls.Add("DuplicateRepoItemsTabItem"     ,$window.FindName("DuplicateRepoItemsTabItem"))
$connectedControls.Add("EmptyWorkflowsTabItem"         ,$window.FindName("EmptyWorkflowsTabItem"))
$connectedControls.Add("DuplicateVariablesTabItem"     ,$window.FindName("DuplicateVariablesTabItem"))
$connectedControls.Add("UnbuiltItemsTabItem"           ,$window.FindName("UnbuiltItemsTabItem"))
$connectedControls.Add("InvalidAgentsTabItem"          ,$window.FindName("InvalidAgentsTabItem"))
$connectedControls.Add("DisconnectedLinksTabItem"      ,$window.FindName("DisconnectedLinksTabItem"))
$connectedControls.Add("RecursiveWorkflowsTabItem"     ,$window.FindName("RecursiveWorkflowsTabItem"))
$connectedControls.Add("EmptyTasksTabItem"             ,$window.FindName("EmptyTasksTabItem"))
$connectedControls.Add("IdenticalTasksTabItem"         ,$window.FindName("IdenticalTasksTabItem"))
$connectedControls.Add("EmptyProcessesTabItem"         ,$window.FindName("EmptyProcessesTabItem"))
$connectedControls.Add("IdenticalProcessesTabItem"     ,$window.FindName("IdenticalProcessesTabItem"))
$connectedControls.Add("EmptyConditionsTabItem"        ,$window.FindName("EmptyConditionsTabItem"))
$connectedControls.Add("IdenticalConditionsTabItem"    ,$window.FindName("IdenticalConditionsTabItem"))
$connectedControls.Add("NullScheduleConditionsTabItem" ,$window.FindName("NullScheduleConditionsTabItem"))
$connectedControls.Add("UsersWithoutAccessTabItem"     ,$window.FindName("UsersWithoutAccessTabItem"))
$connectedControls.Add("EmptyUserGroupsTabItem"        ,$window.FindName("EmptyUserGroupsTabItem"))
$connectedControls.Add("OfflineAgentsTabItem"          ,$window.FindName("OfflineAgentsTabItem"))
$connectedControls.Add("EmptyAgentGroupsTabItem"       ,$window.FindName("EmptyAgentGroupsTabItem"))

$connectedControls.Add("DisabledRepoItemsDataGrid"     ,$window.FindName("DisabledRepoItemsDataGrid"))
$connectedControls.Add("UnusedRepoItemsDataGrid"       ,$window.FindName("UnusedRepoItemsDataGrid"))
$connectedControls.Add("DuplicateRepoItemsDataGrid"    ,$window.FindName("DuplicateRepoItemsDataGrid"))
$connectedControls.Add("EmptyWorkflowsDataGrid"        ,$window.FindName("EmptyWorkflowsDataGrid"))
$connectedControls.Add("DuplicateVariablesDataGrid"    ,$window.FindName("DuplicateVariablesDataGrid"))
$connectedControls.Add("UnbuiltItemsDataGrid"          ,$window.FindName("UnbuiltItemsDataGrid"))
$connectedControls.Add("InvalidAgentsDataGrid"         ,$window.FindName("InvalidAgentsDataGrid"))
$connectedControls.Add("DisconnectedLinksDataGrid"     ,$window.FindName("DisconnectedLinksDataGrid"))
$connectedControls.Add("RecursiveWorkflowsDataGrid"    ,$window.FindName("RecursiveWorkflowsDataGrid"))
$connectedControls.Add("EmptyTasksDataGrid"            ,$window.FindName("EmptyTasksDataGrid"))
$connectedControls.Add("IdenticalTasksDataGrid"        ,$window.FindName("IdenticalTasksDataGrid"))
$connectedControls.Add("EmptyProcessesDataGrid"        ,$window.FindName("EmptyProcessesDataGrid"))
$connectedControls.Add("IdenticalProcessesDataGrid"    ,$window.FindName("IdenticalProcessesDataGrid"))
$connectedControls.Add("EmptyConditionsDataGrid"       ,$window.FindName("EmptyConditionsDataGrid"))
$connectedControls.Add("IdenticalConditionsDataGrid"   ,$window.FindName("IdenticalConditionsDataGrid"))
$connectedControls.Add("NullScheduleConditionsDataGrid",$window.FindName("NullScheduleConditionsDataGrid"))
$connectedControls.Add("UsersWithoutAccessDataGrid"    ,$window.FindName("UsersWithoutAccessDataGrid"))
$connectedControls.Add("EmptyUserGroupsDataGrid"       ,$window.FindName("EmptyUserGroupsDataGrid"))
$connectedControls.Add("OfflineAgentsDataGrid"         ,$window.FindName("OfflineAgentsDataGrid"))
$connectedControls.Add("EmptyAgentGroupsDataGrid"      ,$window.FindName("EmptyAgentGroupsDataGrid"))

$connectionControls["CheckHealthButton"].Add_Click({ Load-HealthCheck -Verbose })
$connectionControls["AMServerTextBox"].Add_KeyUp({ param($sender, $e) if ($e.Key -eq "Return") { Load-HealthCheck -Verbose } })
$connectedControls["DeleteUnusedRepoItemsButton"].Add_Click({
    $messageBoxInput = [System.Windows.MessageBox]::Show("Would you like to delete $($connectedControls["UnusedRepoItemsDataGrid"].SelectedItems.Count) items?","Confirm Deletion","YesNo","Question")
    if ($messageBoxInput -eq "Yes") {
        $connectedControls["UnusedRepoItemsDataGrid"].SelectedItems | Remove-AMObject -Confirm:$false -Verbose
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

if ($global:AMConnectionInfo.Count -gt 0) {
    $connectionControls["AMServerTextBox"].Text = @(@($global:AMConnectionInfo) | ForEach-Object {
        "$($_.Server):$($_.Port)"
    }) -join "/"
}

$window.ShowDialog() | Out-Null