function Invoke-AMRestMethod {
    <#
        .SYNOPSIS
            Invokes a command against the Automate management API.

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
            The Automate management server.

        .EXAMPLE
            # Call the API to get server information
            Invoke-AMRestMethod -Resource "info/get" -RestMethod Get

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Invoke-AMRestMethod.md

        .LINK
            https://hstechdocs.helpsystems.com/manuals/automate/automate/api/index.html
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
        [ArgumentCompleter([AMConnectionCompleter])]
        $Connection
    )
    Write-Verbose "$(Get-Date -Format G) - Invoke-AMRestMethod started"
    $ProgressPreference = "SilentlyContinue"

    if ($PSCmdlet.ParameterSetName -eq "AllConnections") {
        if (-not (Get-AMConnection)) {
            throw "No servers are currently connected!"
        } else {
            $Connections = Get-AMConnection
        }
        if ($RestMethod -ne "Get") {
            throw "Server must be specified when performing updates!"
        }
    } else {
        $Connections = Get-AMConnection -Connection $Connection
        if (($Connections | Measure-Object).Count -eq 0) {
            throw "Connection not found!"
        }
    }

    foreach ($c in $Connections) {
        if ((Get-AMConnection).Name -notcontains $c.Name) {
            throw "No longer connected to $($c.Name)!  Please reconnect first."
        }
        $headers = @{}
        switch ($c.AuthenticationMethod) {
            "Basic" {
                $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $c.Credential.UserName,$c.Credential.GetNetworkCredential().Password)))
                $headers.Add("Authorization", "Basic $base64AuthInfo")
            }
            "Bearer" {
                $headers.Add("Authorization", "Bearer $($c.GetApiToken())")
            }
        }
        $splat = @{
            Method = $RestMethod
            Uri = "http://$($c.Server):$($c.Port)/BPAManagement/$Resource"
            Headers = $headers
			UseBasicParsing = $true
        }
        if ($Body) {
            $splat += @{
                Body = $Body
                ContentType = "application/json"
            }
            Write-Debug $Body
        }
        Write-Verbose "$(Get-Date -Format G) - Calling API (server: $($c.Server))"
        try {
            $response = Invoke-WebRequest @splat -ErrorAction Stop
        } catch {
            throw $_
        }
        if ($null -ne $response.Content) {
            Write-Verbose "$(Get-Date -Format G) - Converting from JSON (server: $($c.Server))"
            $content = $response.Content.Replace('"__type":', '"___type":') # ConvertFrom-Json will discard the __type property, rename it so it is retained
            $tempResult = $content | ConvertFrom-Json
        }
        if ($tempResult.Result -ine "success") {
            throw "$($tempResult.Result) : $($tempResult.Info)"
        }
        if ($PSBoundParameters.ContainsKey("FilterScript")) {
            Write-Verbose "$(Get-Date -Format G) - Filtering with filter script: $FilterScript (server: $($c.Server))"
            $objects = $tempResult.Data | Where-Object -FilterScript $FilterScript
        } else {
            $objects = $tempResult.Data
        }
        if ($objects -notin $null,@()) {
            Write-Verbose "$(Get-Date -Format G) - Casting objects to correct type (server: $($c.Server))"
            $lookupTable = $tempResult.LookupTable
        }
        foreach ($object in $objects) {
            if ($null -ne $object) {
                $processUnrecognizedObject = $false
                # Format and return the object
                switch ($c.Version.Major) {
                    10 {
                        switch ($object.Type -as [AMConstructType]) {
                            "Agent"         { [AMAgentv10]::new($object,$lookupTable,$c.Alias)  }
                            "AgentGroup"    { [AMAgentGroupv10]::new($object,$lookupTable,$c.Alias) }
                            "AgentProperty" { [AMAgentPropertyv10]::new($object,$lookupTable,$c.Alias) }
                            "AuditEvent"    { [AMAuditEventv10]::new($object,$lookupTable,$c.Alias) }
                            "Condition" {
                                switch ($object.TriggerType -as [AMTriggerType]) {
                                    "Database"    { [AMDatabaseTriggerv10]::new($object,$lookupTable,$c.Alias) }
                                    "EventLog"    { [AMEventLogTriggerv10]::new($object,$lookupTable,$c.Alias) }
                                    "FileSystem"  { [AMFileSystemTriggerv10]::new($object,$lookupTable,$c.Alias) }
                                    "Idle"        { [AMIdleTriggerv10]::new($object,$lookupTable,$c.Alias) }
                                    "Keyboard"    { [AMKeyboardTriggerv10]::new($object,$lookupTable,$c.Alias) }
                                    "Logon"       { [AMLogonTriggerv10]::new($object,$lookupTable,$c.Alias) }
                                    "Performance" { [AMPerformanceTriggerv10]::new($object,$lookupTable,$c.Alias) }
                                    "Process"     { [AMProcessTriggerv10]::new($object,$lookupTable,$c.Alias) }
                                    "Schedule"    { [AMScheduleTriggerv10]::new($object,$lookupTable,$c.Alias) }
                                    "Service"     { [AMServiceTriggerv10]::new($object,$lookupTable,$c.Alias) }
                                    "SharePoint"  { [AMSharePointTriggerv10]::new($object,$lookupTable,$c.Alias) }
                                    "SNMPTrap"    { [AMSNMPTriggerv10]::new($object,$lookupTable,$c.Alias) }
                                    "Window"      { [AMWindowTriggerv10]::new($object,$lookupTable,$c.Alias) }
                                    "WMI"         { [AMWMITriggerv10]::new($object,$lookupTable,$c.Alias) }
                                    default       { $processUnrecognizedObject = $true }
                                }
                            }
                            "ExecutionEvent"   { [AMExecutionEventv10]::new($object,$lookupTable,$c.Alias) }
                            "Folder"           { [AMFolderv10]::new($object,$lookupTable,$c.Alias) }
                            "Instance"         { [AMInstancev10]::new($object,$lookupTable,$c.Alias) }
                            "Permission"       { [AMPermissionv10]::new($object,$lookupTable,$c.Alias) }
                            "Process"          { [AMProcessv10]::new($object,$lookupTable,$c.Alias) }
                            "SystemPermission" { [AMSystemPermissionv10]::new($object,$lookupTable,$c.Alias) }
                            "Task"             { [AMTaskv10]::new($object,$lookupTable,$c.Alias) }
                            "TaskProperty"     { [AMTaskPropertyv10]::new($object,$lookupTable,$c.Alias) }
                            "User"             { [AMUserv10]::new($object,$lookupTable,$c.Alias) }
                            "UserGroup"        { [AMUserGroupv10]::new($object,$lookupTable,$c.Alias) }
                            "Workflow"         { [AMWorkflowv10]::new($object,$lookupTable,$c.Alias) }
                            "WorkflowProperty" { [AMWorkflowPropertyv10]::new($object,$lookupTable,$c.Alias) }
                            default            { $processUnrecognizedObject = $true}
                        }
                    }
                    {$_ -in 11,22,23,24} {
                        switch ($object.Type -as [AMConstructType]) {
                            "Agent"         { [AMAgentv11]::new($object,$lookupTable,$c.Alias)  }
                            "AgentGroup"    { [AMAgentGroupv11]::new($object,$lookupTable,$c.Alias) }
                            "AgentProperty" { [AMAgentPropertyv11]::new($object,$lookupTable,$c.Alias) }
                            "AuditEvent"    { [AMAuditEventv11]::new($object,$lookupTable,$c.Alias) }
                            "Condition" {
                                switch ($object.TriggerType -as [AMTriggerType]) {
                                    "Database"    { [AMDatabaseTriggerv11]::new($object,$lookupTable,$c.Alias) }
                                    "Email"       { [AMEmailTriggerv11]::new($object,$lookupTable,$c.Alias) }
                                    "EventLog"    { [AMEventLogTriggerv11]::new($object,$lookupTable,$c.Alias) }
                                    "FileSystem"  { [AMFileSystemTriggerv11]::new($object,$lookupTable,$c.Alias) }
                                    "Idle"        { [AMIdleTriggerv11]::new($object,$lookupTable,$c.Alias) }
                                    "Keyboard"    { [AMKeyboardTriggerv11]::new($object,$lookupTable,$c.Alias) }
                                    "Logon"       { [AMLogonTriggerv11]::new($object,$lookupTable,$c.Alias) }
                                    "Performance" { [AMPerformanceTriggerv11]::new($object,$lookupTable,$c.Alias) }
                                    "Process"     { [AMProcessTriggerv11]::new($object,$lookupTable,$c.Alias) }
                                    "Schedule"    { [AMScheduleTriggerv11]::new($object,$lookupTable,$c.Alias) }
                                    "Service"     { [AMServiceTriggerv11]::new($object,$lookupTable,$c.Alias) }
                                    "SharePoint"  { [AMSharePointTriggerv11]::new($object,$lookupTable,$c.Alias) }
                                    "SNMPTrap"    { [AMSNMPTriggerv11]::new($object,$lookupTable,$c.Alias) }
                                    "Window"      { [AMWindowTriggerv11]::new($object,$lookupTable,$c.Alias) }
                                    "WMI"         { [AMWMITriggerv11]::new($object,$lookupTable,$c.Alias) }
                                    default       { $processUnrecognizedObject = $true }
                                }
                            }
                            "ExecutionEvent"   { [AMExecutionEventv11]::new($object,$lookupTable,$c.Alias) }
                            "Folder"           { [AMFolderv11]::new($object,$lookupTable,$c.Alias) }
                            "Instance"         { [AMInstancev11]::new($object,$lookupTable,$c.Alias) }
                            "Permission"       { [AMPermissionv11]::new($object,$lookupTable,$c.Alias) }
                            "Process"          { [AMProcessv11]::new($object,$lookupTable,$c.Alias) }
                            "SystemPermission" { [AMSystemPermissionv11]::new($object,$lookupTable,$c.Alias) }
                            "Task"             { [AMTaskv11]::new($object,$lookupTable,$c.Alias) }
                            "TaskProperty"     { [AMTaskPropertyv11]::new($object,$lookupTable,$c.Alias) }
                            "User"             {
                                if ($c.Version.Major -ge 23) {
                                    [AMUserv1123]::new($object,$lookupTable,$c.Alias)
                                } else {
                                    [AMUserv11]::new($object,$lookupTable,$c.Alias)
                                }
                            }
                            "UserGroup"        { [AMUserGroupv11]::new($object,$lookupTable,$c.Alias) }
                            "Workflow"         { [AMWorkflowv11]::new($object,$lookupTable,$c.Alias) }
                            "WorkflowProperty" { [AMWorkflowPropertyv11]::new($object,$lookupTable,$c.Alias) }
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
    Write-Verbose "$(Get-Date -Format G) - Invoke-AMRestMethod finished"
}
