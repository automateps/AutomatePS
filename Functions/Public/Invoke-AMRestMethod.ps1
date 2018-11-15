function Invoke-AMRestMethod {
    <#
        .SYNOPSIS
            Invokes a command against the AutoMate Enterprise management API.

        .DESCRIPTION
            Invoke-AMRestMethod makes calls against the REST API and returns results.

        .PARAMETER Resource
            The REST resource to call.

        .PARAMETER RestMethod
            The REST method to use.

        .PARAMETER Body
            When using the POST method, the body to send to the API.

        .PARAMETER FilterScript
            Applies the specified filter to the results from the API prior to property addition and date conversion to improve performance.  When passing dates in the filter, they must be in UTC.

        .PARAMETER Connection
            The AutoMate Enterprise management server.

        .EXAMPLE
            # Call the API to get server information
            Invoke-AMRestMethod -Resource "info/get" -RestMethod Get

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 11/15/2018

        .LINK
            http://cloud.networkautomation.com/installs/AutoMate/v10/10.5.0.56/BPA_RESTful_API.html
    #>
    [CmdletBinding(DefaultParameterSetName="AllConnections")]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Resource,

        [ValidateSet("Get","Post","Put","Delete")]
        [string]$RestMethod = "Get",

        [ValidateNotNullOrEmpty()]
        [string]$Body = "",

        [ValidateNotNullOrEmpty()]
        [ScriptBlock]$FilterScript,

        [Parameter(ParameterSetName = "SpecificConnection")]
        [ValidateNotNullOrEmpty()]
        $Connection
    )
    Write-Verbose "$(Get-Date -f G) - Invoke-AMRestMethod started"
    $ProgressPreference = "SilentlyContinue"

    if ($PSCmdlet.ParameterSetName -eq "AllConnections") {
        if (-not (Get-AMConnection)) {
            throw "No servers are currently connected!"
        } else {
            $Connection = Get-AMConnection
        }
        if ($RestMethod -ne "Get") {
            throw "Server must be specified when performing updates!"
        }
    } else {
        $Connection = Get-AMConnection -Connection $Connection
    }

    foreach ($c in $Connection) {
        if ((Get-AMConnection).Name -notcontains $c.Name) {
            throw "No longer connected to $($c.Name)!  Please reconnect first."
        }
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $c.Credential.UserName,$c.Credential.GetNetworkCredential().Password)))
        $splat = @{
            Method = $RestMethod
            Uri = "http://$($c.Server):$($c.Port)/BPAManagement/$Resource"
            Headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}
			UseBasicParsing = $true
        }
        if ($Body) {
            Write-Debug $Body
            $splat += @{
                Body = $Body
                ContentType = "application/json"
            }
        }
        Write-Verbose "$(Get-Date -f G) - Calling API (server: $($c.Server))"
        $response = Invoke-WebRequest @splat
        if ($null -ne $response.Content) {
            Write-Verbose "$(Get-Date -f G) - Converting from JSON (server: $($c.Server))"
            $content = $response.Content.Replace('"__type":', '"___type":') # ConvertFrom-Json will discard the __type property, rename it so it is retained
            $tempResult = $content | ConvertFrom-Json
        }
        if ($tempResult.Result -ine "success") {
            throw "$($tempResult.Result) : $($tempResult.Info)"
        }
        if ($PSBoundParameters.ContainsKey("FilterScript")) {
            Write-Verbose "$(Get-Date -f G) - Filtering with filter script: $FilterScript (server: $($c.Server))"
            $objects = $tempResult.Data | Where-Object -FilterScript $FilterScript
        } else {
            $objects = $tempResult.Data
        }
        if ($objects -notin $null,@()) {
            Write-Verbose "$(Get-Date -f G) - Casting objects to correct type (server: $($c.Server))"
        }
        foreach ($object in $objects) {
            if ($null -ne $object) {
                $processUnrecognizedObject = $false
                # Format and return the object
                switch ($c.Version.Major) {
                    10 {
                        switch ($object.Type -as [AMConstructType]) {
                            "Agent"         { [AMAgentv10]::new($object,$c.Alias)  }
                            "AgentGroup"    { [AMAgentGroupv10]::new($object,$c.Alias) }
                            "AgentProperty" { [AMAgentPropertyv10]::new($object,$c.Alias) }
                            "AuditEvent"    { [AMAuditEventv10]::new($object,$c.Alias) }
                            "Condition" {
                                switch ($object.TriggerType -as [AMTriggerType]) {
                                    "Database"    { [AMDatabaseTriggerv10]::new($object,$c.Alias) }
                                    "EventLog"    { [AMEventLogTriggerv10]::new($object,$c.Alias) }
                                    "FileSystem"  { [AMFileSystemTriggerv10]::new($object,$c.Alias) }
                                    "Idle"        { [AMIdleTriggerv10]::new($object,$c.Alias) }
                                    "Keyboard"    { [AMKeyboardTriggerv10]::new($object,$c.Alias) }
                                    "Logon"       { [AMLogonTriggerv10]::new($object,$c.Alias) }
                                    "Performance" { [AMPerformanceTriggerv10]::new($object,$c.Alias) }
                                    "Process"     { [AMProcessTriggerv10]::new($object,$c.Alias) }
                                    "Schedule"    { [AMScheduleTriggerv10]::new($object,$c.Alias) }
                                    "Service"     { [AMServiceTriggerv10]::new($object,$c.Alias) }
                                    "SharePoint"  { [AMSharePointTriggerv10]::new($object,$c.Alias) }
                                    "SNMPTrap"    { [AMSNMPTriggerv10]::new($object,$c.Alias) }
                                    "Window"      { [AMWindowTriggerv10]::new($object,$c.Alias) }
                                    "WMI"         { [AMWMITriggerv10]::new($object,$c.Alias) }
                                    default       { $processUnrecognizedObject = $true }
                                }
                            }
                            "ExecutionEvent"   { [AMExecutionEventv10]::new($object,$c.Alias) }
                            "Folder"           { [AMFolderv10]::new($object,$c.Alias) }
                            "Instance"         { [AMInstancev10]::new($object,$c.Alias) }
                            "Permission"       { [AMPermissionv10]::new($object,$c.Alias) }
                            "Process"          { [AMProcessv10]::new($object,$c.Alias) }
                            "SystemPermission" { [AMSystemPermissionv10]::new($object,$c.Alias) }
                            "Task"             { [AMTaskv10]::new($object,$c.Alias) }
                            "TaskProperty"     { [AMTaskPropertyv10]::new($object,$c.Alias) }
                            "User"             { [AMUserv10]::new($object,$c.Alias) }
                            "UserGroup"        { [AMUserGroupv10]::new($object,$c.Alias) }
                            "Workflow"         { [AMWorkflowv10]::new($object,$c.Alias) }
                            "WorkflowProperty" { [AMWorkflowPropertyv10]::new($object,$c.Alias) }
                            default            { $processUnrecognizedObject = $true}
                        }
                    }
                    11 {
                        switch ($object.Type -as [AMConstructType]) {
                            "Agent"         { [AMAgentv11]::new($object,$c.Alias)  }
                            "AgentGroup"    { [AMAgentGroupv11]::new($object,$c.Alias) }
                            "AgentProperty" { [AMAgentPropertyv11]::new($object,$c.Alias) }
                            "AuditEvent"    { [AMAuditEventv11]::new($object,$c.Alias) }
                            "Condition" {
                                switch ($object.TriggerType -as [AMTriggerType]) {
                                    "Database"    { [AMDatabaseTriggerv11]::new($object,$c.Alias) }
                                    "Email"       { [AMEmailTriggerv11]::new($object,$c.Alias) }
                                    "EventLog"    { [AMEventLogTriggerv11]::new($object,$c.Alias) }
                                    "FileSystem"  { [AMFileSystemTriggerv11]::new($object,$c.Alias) }
                                    "Idle"        { [AMIdleTriggerv11]::new($object,$c.Alias) }
                                    "Keyboard"    { [AMKeyboardTriggerv11]::new($object,$c.Alias) }
                                    "Logon"       { [AMLogonTriggerv11]::new($object,$c.Alias) }
                                    "Performance" { [AMPerformanceTriggerv11]::new($object,$c.Alias) }
                                    "Process"     { [AMProcessTriggerv11]::new($object,$c.Alias) }
                                    "Schedule"    { [AMScheduleTriggerv11]::new($object,$c.Alias) }
                                    "Service"     { [AMServiceTriggerv11]::new($object,$c.Alias) }
                                    "SharePoint"  { [AMSharePointTriggerv11]::new($object,$c.Alias) }
                                    "SNMPTrap"    { [AMSNMPTriggerv11]::new($object,$c.Alias) }
                                    "Window"      { [AMWindowTriggerv11]::new($object,$c.Alias) }
                                    "WMI"         { [AMWMITriggerv11]::new($object,$c.Alias) }
                                    default       { $processUnrecognizedObject = $true }
                                }
                            }
                            "ExecutionEvent"   { [AMExecutionEventv11]::new($object,$c.Alias) }
                            "Folder"           { [AMFolderv11]::new($object,$c.Alias) }
                            "Instance"         { [AMInstancev11]::new($object,$c.Alias) }
                            "Permission"       { [AMPermissionv11]::new($object,$c.Alias) }
                            "Process"          { [AMProcessv11]::new($object,$c.Alias) }
                            "SystemPermission" { [AMSystemPermissionv11]::new($object,$c.Alias) }
                            "Task"             { [AMTaskv11]::new($object,$c.Alias) }
                            "TaskProperty"     { [AMTaskPropertyv11]::new($object,$c.Alias) }
                            "User"             { [AMUserv11]::new($object,$c.Alias) }
                            "UserGroup"        { [AMUserGroupv11]::new($object,$c.Alias) }
                            "Workflow"         { [AMWorkflowv11]::new($object,$c.Alias) }
                            "WorkflowProperty" { [AMWorkflowPropertyv11]::new($object,$c.Alias) }
                            default            { $processUnrecognizedObject = $true }
                        }
                    }
                    default { $processUnrecognizedObject = $true }
                }
                if ($processUnrecognizedObject) {
                    foreach ($property in $object | Get-Member -MemberType NoteProperty) {
                        if ($object."$($property.Name)" -is [DateTime]) {
                            # Convert UTC dates to local time
                            $object."$($property.Name)" = $object."$($property.Name)".ToLocalTime()
                        }
                    }
                    $object | Add-Member -MemberType NoteProperty -Name "ConnectionAlias" -Value $c.Alias
                    $object
                }
            }
        }
    }
    Write-Verbose "$(Get-Date -f G) - Invoke-AMRestMethod finished"
}
