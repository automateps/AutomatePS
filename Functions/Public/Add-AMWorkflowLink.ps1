function Add-AMWorkflowLink {
    <#
        .SYNOPSIS
            Adds a link between two objects in an AutoMate Enterprise workflow

        .DESCRIPTION
            Add-AMWorkflowLink can add a link between two objects in an AutoMate Enterprise workflow

        .PARAMETER InputObject
            The workflow to add the link to.

        .PARAMETER SourceConstruct
            The source repository object for the link.  Object can only exist once in the workflow.

        .PARAMETER DestinationConstruct
            The destination repository object for the link.  Object can only exist once in the workflow.

        .PARAMETER SourceItemID
            The source workflow item or trigger ID for the link.

        .PARAMETER DestinationItemID
            The destination workflow item or trigger ID for the link.

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
            Get-AMWorkflow "FTP Files" | Add-AMWorkflowLink -SourceConstruct (Get-AMTask "Copy Files") -DestinationConstruct (Get-AMTask "Move Files")

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 11/15/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [Parameter(Mandatory = $true, ParameterSetName = "ByConstruct")]
        [ValidateNotNullOrEmpty()]
        $SourceConstruct,

        [Parameter(Mandatory = $true, ParameterSetName = "ByConstruct")]
        [ValidateNotNullOrEmpty()]
        $DestinationConstruct,

        [Parameter(Mandatory = $true, ParameterSetName = "ByItem")]
        [ValidateNotNullOrEmpty()]
        $SourceItemID,

        [Parameter(Mandatory = $true, ParameterSetName = "ByItem")]
        [ValidateNotNullOrEmpty()]
        $DestinationItemID,

        [ValidateNotNullOrEmpty()]
        [AMLinkType]$Type = [AMLinkType]::Success,

        [ValidateNotNullOrEmpty()]
        [AMLinkResultType]$ResultType = [AMLinkResultType]::Default,

        [ValidateNotNullOrEmpty()]
        $Value = ""
    )

    BEGIN {
        if ($SourceConstruct.ConnectionAlias -ne $DestinationConstruct.ConnectionAlias) {
            throw "SourceConstruct and DestinationConstruct are not on the same AutoMate Enterprise server!"
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
                $updateObject = Get-AMWorkflow -ID $obj.ID -Connection $obj.ConnectionAlias
                $source = @()
                $destination = @()
                switch ($PSCmdlet.ParameterSetName) {
                    "ByConstruct" {
                        if ($obj.ConnectionAlias -ne $SourceConstruct.ConnectionAlias) {
                            Write-Warning "SourceConstruct '$($SourceConstruct.Name)' ($($SourceConstruct.ConnectionAlias)) is not on the same server as '$($obj.Name)' ($($obj.ConnectionAlias))!"
                            continue workflowloop
                        }
                        if ($obj.ConnectionAlias -ne $DestinationConstruct.ConnectionAlias) {
                            Write-Warning "DestinationConstruct '$($DestinationConstruct.Name)' ($($DestinationConstruct.ConnectionAlias)) is not on the same server as '$($obj.Name)' ($($obj.ConnectionAlias))!"
                            continue workflowloop
                        }
                        $source += $updateObject.Items | Where-Object {$_.ConstructID -eq $SourceConstruct.ID}
                        $source += $updateObject.Triggers | Where-Object {$_.ConstructID -eq $SourceConstruct.ID}
                        $destination += $updateObject.Items | Where-Object {$_.ConstructID -eq $DestinationConstruct.ID}
                        $destination += $updateObject.Triggers | Where-Object {$_.ConstructID -eq $DestinationConstruct.ID}
                    }
                    "ByItem" {
                        $source += $updateObject.Items | Where-Object {$_.ID -eq $SourceItemID}
                        $source += $updateObject.Triggers | Where-Object {$_.ID -eq $SourceItemID}
                        $destination += $updateObject.Items | Where-Object {$_.ID -eq $DestinationItemID}
                        $destination += $updateObject.Triggers | Where-Object {$_.ID -eq $DestinationItemID}
                    }
                }
                if ($source.Count -ne 1) {
                    Write-Warning "Unexpected number of source items found in workflow '$($updateObject.Name)'!"
                    continue workflowloop
                }
                if ($destination.Count -ne 1) {
                    Write-Warning "Unexpected number of destination items found in workflow '$($updateObject.Name)'!"
                    continue workflowloop
                }
                foreach ($link in $updateObject.Links) {
                    if (($link.SourceID -eq $source.ID) -and ($link.DestinationID -eq $destination.ID)) {
                        Write-Warning "Workflow $($obj.Name) already has a link between the specified items!"
                        continue workflowloop
                    }
                }

                switch ((Get-AMConnection -ConnectionAlias $obj.ConnectionAlias).Version.Major) {
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
                $updateObject.Links += $newLink
                Set-AMWorkflow -Instance $updateObject
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
