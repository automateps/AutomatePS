function Add-AMWorkflowLink {
    <#
        .SYNOPSIS
            Adds a link between two objects in an AutoMate Enterprise workflow

        .DESCRIPTION
            Add-AMWorkflowLink can add a link between two objects in an AutoMate Enterprise workflow

        .PARAMETER InputObject
            The workflow to add the link to.

        .PARAMETER SourceItem
            The source object for the link.  Object can only exist once in the workflow.

        .PARAMETER DestinationItem
            The destination object for the link.  Object can only exist once in the workflow.

        .PARAMETER Type
            The type of link to add.

        .PARAMETER ResultType
            If a Result link type is used, the type of result (true/false/default/value).

        .PARAMETER Value
            If a Value result type is used, the value to set.

        .INPUTS
            The following AutoMate object types can be modified by this function:
            Workflow

        .OUTPUTS
            None

        .EXAMPLE
            # Add a link between "Copy Files" and "Move Files"
            Get-AMWorkflow "FTP Files" | Add-AMWorkflowLink -SourceItem (Get-AMTask "Copy Files") -DestinationItem (Get-AMTask "Move Files")

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
        $SourceItem,

        [Parameter(Mandatory = $true)]
        $DestinationItem,

        [AMLinkType]$Type = [AMLinkType]::Success,

        [AMLinkResultType]$ResultType = [AMLinkResultType]::Default,

        $Value = ""
    )

    BEGIN {
        if ($SourceItem.ConnectionAlias -ne $DestinationItem.ConnectionAlias) {
            throw "SourceItem and DestinationItem are not on the same AutoMate Enterprise server!"
        }
        # Don't set ResultType and Value unless the appropriate parameters are supplied
        if ($Type -ne [AMLinkType]::Result) {
            $ResultType = [AMLinkResultType]::Default
            $Value = ""
        } elseif ($ResultType -ne [AMLinkResultType]::Value) {
            $Value = ""
        }
    }

    PROCESS {
        :workflowloop foreach ($obj in $InputObject) {
            if ($obj.Type -eq "Workflow") {
                if ($obj.ConnectionAlias -ne $SourceItem.ConnectionAlias) {
                    Write-Warning "SourceItem '$($SourceItem.Name)' ($($SourceItem.ConnectionAlias)) is not on the same server as '$($obj.Name)' ($($obj.ConnectionAlias))!"
                    continue workflowloop
                }
                if ($obj.ConnectionAlias -ne $DestinationItem.ConnectionAlias) {
                    Write-Warning "DestinationItem '$($DestinationItem.Name)' ($($DestinationItem.ConnectionAlias)) is not on the same server as '$($obj.Name)' ($($obj.ConnectionAlias))!"
                    continue workflowloop
                }
                $updateObject = Get-AMWorkflow -ID $obj.ID -Connection $obj.ConnectionAlias
                $source = @()
                $source += $updateObject.Items | Where-Object {$_.ConstructID -eq $SourceItem.ID}
                $source += $updateObject.Triggers | Where-Object {$_.ConstructID -eq $SourceItem.ID}
                $destination = @()
                $destination += $updateObject.Items | Where-Object {$_.ConstructID -eq $DestinationItem.ID}
                $destination += $updateObject.Triggers | Where-Object {$_.ConstructID -eq $DestinationItem.ID}
                if ($source.Count -gt 1) {
                    Write-Warning "Found more than one instance of SourceItem '$($SourceItem.Name)' in workflow '$($updateObject.Name)'!"
                    continue workflowloop
                } elseif ($source.Count -eq 0) {
                    Write-Warning "Found no instances of SourceItem '$($SourceItem.Name)' in workflow '$($updateObject.Name)'!"
                    continue workflowloop
                }
                if ($destination.Count -gt 1) {
                    Write-Warning "Found more than one instance of DestinationItem '$($DestinationItem.Name)' in workflow '$($updateObject.Name)'!"
                    continue workflowloop
                } elseif ($destination.Count -eq 0) {
                    Write-Warning "Found no instances of DestinationItem '$($DestinationItem.Name)' in workflow '$($updateObject.Name)'!"
                    continue workflowloop
                }
                foreach ($link in $updateObject.Links) {
                    if (($link.SourceID -eq $source.ID) -and ($link.DestinationID -eq $destination.ID)) {
                        Write-Warning "Workflow $($obj.Name) already has a link between '$($SourceItem.Name)' and '$($DestinationItem.Name)'!"
                        continue workflowloop
                    }
                }

                switch ((Get-AMConnection $obj.ConnectionAlias).Version.Major) {
                    10      { $newLink = [AMWorkflowLinkv10]::new($obj.ConnectionAlias) }
                    11      { $newLink = [AMWorkflowLinkv11]::new($obj.ConnectionAlias) }
                    default { throw "Unsupported server major version: $_!" }
                }
                $newLink.ParentID           = $updateObject.ID
                $newLink.DestinationID      = $destination.ID
                $newLink.DestinationPoint   = [PSCustomObject]@{x = $destination.X; y = $destination.Y}
                $newLink.LinkType           = $Type
                $newLink.ResultType         = $ResultType
                $newLink.SourceID           = $source.ID
                $newLink.SourcePoint        = [PSCustomObject]@{x = $source.X; y = $source.Y}
                $newLink.Value              = $Value
                $newLink.WorkflowID         = $updateObject.ID
                if ($updateObject.Links.Count -gt 0) {
                    $updateObject.Links += $newLink
                } else {
                    $updateObject.Links = @($newLink)
                }
                Set-AMWorkflow -Instance $updateObject
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
