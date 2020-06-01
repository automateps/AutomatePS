function Get-AMWorkflowItem {
    <#
        .SYNOPSIS
            Gets a list of items within a workflow.

        .DESCRIPTION
            Get-AMWorkflowItem retrieves links for a workflow.

        .PARAMETER InputObject
            The object to retrieve links from.

        .PARAMETER LinkType
            Only retrieve variables of a specific link type.

        .INPUTS
            The following Automate object types can be queried by this function:
            Workflow

        .EXAMPLE
            # Get links in workflow "FTP Files"
            Get-AMWorkflow "FTP Files" | Get-AMWorkflowLink

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [ValidateNotNullOrEmpty()]
        [AMLinkType]$LinkType
    )

    BEGIN {
        $constructCache = @{}
        $agentCache = @{}
    }

    PROCESS {
        foreach ($obj in $InputObject) {
            Write-Verbose "Processing $($obj.Type) '$($obj.Name)'"
            if (-not $constructCache.ContainsKey($obj.ConnectionAlias)) {
                $constructCache.Add($obj.ConnectionAlias, @())
            }
            if (-not $agentCache.ContainsKey($obj.ConnectionAlias)) {
                $agentCache.Add($obj.ConnectionAlias, @())
            }
            if ($obj.Type -eq "Workflow") {
                $allItems = @($obj.Triggers) + @($obj.Items)
                foreach ($item in $allItems) {
                    if (($item | Get-Member -Name Construct | Measure-Object).Count -eq 0) {
                        if (-not [string]::IsNullOrEmpty($item.ConstructID)) {
                            if ($constructCache[$obj.ConnectionAlias].ID -notcontains $item.ConstructID) {
                                $constructCache[$obj.ConnectionAlias] += Get-AMObject -ID $item.ConstructID -Types $item.ConstructType -Connection $obj.ConnectionAlias
                            }
                            $construct = $constructCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $item.ConstructID}
                        }
                        $item | Add-Member -MemberType NoteProperty -Name Construct -Value $construct
                    }
                    if (($item | Get-Member -Name Agent | Measure-Object).Count -eq 0) {
                        if (-not [string]::IsNullOrEmpty($item.AgentID)) {
                            if ($agentCache[$obj.ConnectionAlias].ID -notcontains $item.AgentID) {
                                $agentCache[$obj.ConnectionAlias] += Get-AMObject -ID $item.AgentID -Types "Agent","AgentGroup","SystemAgent" -Connection $obj.ConnectionAlias
                            }
                            $agent = $agentCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $item.AgentID}
                        }
                        $item | Add-Member -MemberType NoteProperty -Name Agent -Value $agent
                    }
                    $item.PSObject.TypeNames.Insert(0, "CustomWorkflowItem")
                    $item
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
