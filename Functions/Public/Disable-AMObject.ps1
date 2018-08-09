function Disable-AMObject {
    <#
        .SYNOPSIS
            Disables an AutoMate Enterprise object.

        .DESCRIPTION
            Disable-AMObject receives AutoMate Enterprise object(s) on the pipeline, or via the parameter $InputObject, and disables the object(s).

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
            Get-AMWorkflow "My Workflow" | Disable-AMObject

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 08/08/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]        
        [ValidateNotNullOrEmpty()]
        $InputObject
    )

    PROCESS {
        # Loop through all objects on the pipeline
        foreach ($obj in $InputObject) {
            if ($obj.Type -notin @("Workflow","Task","Condition","Process","Agent","AgentGroup","User","UserGroup")) {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
            # If object isn't already disabled, disable it
            if ($obj.Enabled) {
                Write-Verbose "Disabling $($obj.Type) '$($obj.Name)'"
                Invoke-AMRestMethod -Resource "$([AMTypeDictionary]::($obj.Type).RestResource)/$($obj.ID)/disable" -RestMethod Post -Connection $obj.ConnectionAlias | Out-Null
            } else {
                Write-Verbose "$($obj.Type) '$($obj.Name)' already disabled"
            }
        }
    }
}
