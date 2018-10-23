function Get-AMWorkflowLink {
    <#
        .SYNOPSIS
            Gets a list of links within a workflow.

        .DESCRIPTION
            Get-AMWorkflowLink retrieves links for a workflow.

        .PARAMETER InputObject
            The object to retrieve links from.

        .PARAMETER LinkType
            Only retrieve variables of a specific link type.

        .INPUTS
            The following AutoMate object types can be queried by this function:
            Workflow

        .EXAMPLE
            # Get links in workflow "FTP Files"
            Get-AMWorkflow "FTP Files" | Get-AMWorkflowLink

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 10/23/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [AMLinkType]$LinkType
    )

    BEGIN {
        $constructCache = @{}
    }

    PROCESS {
        foreach ($obj in $InputObject) {
            Write-Verbose "Processing $($obj.Type) '$($obj.Name)'"
            if (-not $constructCache.ContainsKey($obj.ConnectionAlias)) {
                $constructCache.Add($obj.ConnectionAlias, @())
            }
            if ($obj.Type -eq "Workflow") {
                $links = $obj.Links | Sort-Object @{Expression={$_.SourcePoint.X}},@{Expression={$_.SourcePoint.Y}},@{Expression={$_.DestinationPoint.X}},@{Expression={$_.DestinationPoint.Y}}
                if ($PSBoundParameters.ContainsKey("LinkType")) {
                    $links = $links | Where-Object {$_.LinkType -eq $LinkType}
                }
                $allItems = $obj.Items + $obj.Triggers
                foreach ($link in $links) {
                    $sourceItem = $allItems | Where-Object {$_.ID -eq $link.SourceID}
                    $destItem   = $allItems | Where-Object {$_.ID -eq $link.DestinationID}
                    $sourceObj = $null
                    $destObj = $null
                    if (($link | Get-Member -Name SourceObject | Measure-Object).Count -eq 0) {
                        if (-not [string]::IsNullOrEmpty($sourceItem.ConstructID)) {
                            if ($constructCache[$obj.ConnectionAlias].ID -notcontains $sourceItem.ConstructID) {
                                $constructCache[$obj.ConnectionAlias] += Invoke-AMRestMethod -Resource "$(([AMTypeDictionary]::($sourceItem.ConstructType)).RestResource)/$($sourceItem.ConstructID)/get" -Connection $obj.ConnectionAlias
                            }
                            $sourceObj = $constructCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $sourceItem.ConstructID}
                        }
                        $link | Add-Member -MemberType NoteProperty -Name SourceObject -Value $sourceObj
                    }
                    if (($link | Get-Member -Name DestinationObject | Measure-Object).Count -eq 0) {
                        if (-not [string]::IsNullOrEmpty($destItem.ConstructID)) {
                            if ($constructCache[$obj.ConnectionAlias].ID -notcontains $destItem.ConstructID) {
                                $constructCache[$obj.ConnectionAlias] += Invoke-AMRestMethod -Resource "$(([AMTypeDictionary]::($destItem.ConstructType)).RestResource)/$($destItem.ConstructID)/get" -Connection $obj.ConnectionAlias
                            }
                            $destObj = $constructCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $destItem.ConstructID}
                        }
                        $link | Add-Member -MemberType NoteProperty -Name DestinationObject -Value $destObj
                    }
                    $link.PSObject.TypeNames.Insert(0, "CustomWorkflowLink")
                    $link
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
