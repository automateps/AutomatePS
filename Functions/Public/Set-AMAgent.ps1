function Set-AMAgent {
    <#
        .SYNOPSIS
            Sets properties of an Automate agent.

        .DESCRIPTION
            Set-AMAgent can change properties of an agent object.

        .PARAMETER InputObject
            The object to modify.

        .PARAMETER Notes
            The new notes to set on the object.

        .INPUTS
            The following Automate object types can be modified by this function:
            TaskAgent
            ProcessAgent

        .OUTPUTS
            None

        .EXAMPLE
            # Change notes for an agent
            Get-AMAgent "Agent1" | Set-AMAgent -Notes "Site 1 Agent"

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMAgent.md
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$Notes
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "Agent") {
                $updateObject = Get-AMAgent -ID $obj.ID -Connection $obj.ConnectionAlias
                $shouldUpdate = $false
                if ($PSBoundParameters.ContainsKey("Notes")) {
                    if ($updateObject.Notes -ne $Notes) {
                        $updateObject.Notes = $Notes
                        $shouldUpdate = $true
                    }
                }
                if ($shouldUpdate) {
                    $updateObject | Set-AMObject
                } else {
                    Write-Verbose "$($obj.Type) '$($obj.Name)' already contains the specified values."
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
