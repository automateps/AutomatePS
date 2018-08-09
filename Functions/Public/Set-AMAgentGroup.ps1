function Set-AMAgentGroup {
    <#
        .SYNOPSIS
            Sets properties of an AutoMate Enterprise agent group.

        .DESCRIPTION
            Set-AMAgentGroup can change properties of an agent group object.

        .PARAMETER InputObject
            The agent group to modify.

        .PARAMETER Notes
            The new notes to set on the object.

        .INPUTS
            The following AutoMate object types can be modified by this function:
            AgentGroup

        .OUTPUTS
            None

        .EXAMPLE
            # Change notes for an agent group
            Get-AMAgentGroup "All Agents" | Set-AMUserGroup -Notes "Group containing all agents"

        .EXAMPLE
            # Empty notes for all agent groups
            Get-AMAgentGroup | Set-AMUserGroup -Notes ""

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 08/08/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $InputObject,

        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$Notes
    )
    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "AgentGroup") {
                $updateObject = Get-AMAgentGroup -ID $obj.ID -Connection $obj.ConnectionAlias
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
