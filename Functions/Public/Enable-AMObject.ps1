function Enable-AMObject {
    <#
        .SYNOPSIS
            Enables an Automate object.

        .DESCRIPTION
            Enable-AMObject receives Automate object(s) on the pipeline, or via the parameter $InputObject, and enables the object(s).

        .PARAMETER InputObject
            The object(s) to be disabled.

        .INPUTS
            The following objects can be disabled by this function:
            Workflow
            Task
            Condition
            Process
            TaskAgent
            ProcessAgent
            AgentGroup
            User
            UserGroup

        .OUTPUTS
            None

        .EXAMPLE
            Get-AMAgent "agent01" | Enable-AMObject

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Enable-AMObject.md
    #>
    [CmdletBinding()]
    [Alias("Enable-AMAgent")]
    [Alias("Enable-AMAgentGroup")]
    [Alias("Enable-AMCondition")]
    [Alias("Enable-AMProcess")]
    [Alias("Enable-AMTask")]
    [Alias("Enable-AMUser")]
    [Alias("Enable-AMUserGroup")]
    [Alias("Enable-AMWorkflow")]
    param (
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject
    )

    PROCESS {
        # Loop through all objects on the pipeline
        foreach ($obj in $InputObject) {
            if ($obj.Type -in @("Workflow","Task","Condition","Process","Agent","AgentGroup","User","UserGroup")) {
                # If object isn't already enabled, enable it
                if (-not $obj.Enabled) {
                    Write-Verbose "Enabling $($obj.Type) '$($obj.Name)'"
                    Invoke-AMRestMethod -Resource "$([AMTypeDictionary]::($obj.Type).RestResource)/$($obj.ID)/enable" -RestMethod Post -Connection $obj.ConnectionAlias | Out-Null
                } else {
                    Write-Verbose "$($obj.Type) '$($obj.Name)' already enabled"
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
