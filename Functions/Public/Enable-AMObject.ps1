function Enable-AMObject {
    <#
        .SYNOPSIS
            Enables an AutoMate Enterprise object.

        .DESCRIPTION
            Enable-AMObject receives AutoMate Enterprise object(s) on the pipeline, or via the parameter $InputObject, and enables the object(s).

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

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 11/15/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding()]
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

New-Alias -Name Enable-AMAgent      -Value Enable-AMObject -Scope Global
New-Alias -Name Enable-AMAgentGroup -Value Enable-AMObject -Scope Global
New-Alias -Name Enable-AMCondition  -Value Enable-AMObject -Scope Global
New-Alias -Name Enable-AMProcess    -Value Enable-AMObject -Scope Global
New-Alias -Name Enable-AMTask       -Value Enable-AMObject -Scope Global
New-Alias -Name Enable-AMUser       -Value Enable-AMObject -Scope Global
New-Alias -Name Enable-AMUserGroup  -Value Enable-AMObject -Scope Global
New-Alias -Name Enable-AMWorkflow   -Value Enable-AMObject -Scope Global