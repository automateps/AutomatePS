function Set-AMWorkflowLink {
    <#
        .SYNOPSIS
            Sets a link in a AutoMate Enterprise workflow

        .DESCRIPTION
            Set-AMWorkflowLink can modify a link in a workflow object.

        .PARAMETER InputObject
            The object to modify - a workflow or a workflow link.

        .PARAMETER ID
            The ID of the link to modify (if passing in a workflow).

        .PARAMETER LinkType
            The type of link to add.

        .PARAMETER ResultType
            If a Result link type is used, the type of result (true/false/default/value).

        .PARAMETER Value
            If a Value result type is used, the value to set.

        .INPUTS
            The following AutoMate object types can be modified by this function:
            Workflow
            WorkflowLink

        .EXAMPLE
            # Change the label on an item in a workflow
            Get-AMWorkflow "Some Workflow" | Set-AMWorkflowLink -ID "{1103992f-cbbd-44fd-9177-9de31b1070ab}" -Value "123"

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$ID,

        [ValidateNotNullOrEmpty()]
        [AMLinkType]$LinkType = [AMLinkType]::Success,

        [ValidateNotNullOrEmpty()]
        [AMLinkResultType]$ResultType = [AMLinkResultType]::Default,

        [ValidateNotNull()]
        $Value = ""
    )

    PROCESS {
        :objectloop foreach ($obj in $InputObject) {
            switch ($obj.Type) {
                "Workflow" {
                    $updateObject = Get-AMWorkflow -ID $obj.ID -Connection $obj.ConnectionAlias
                    $item = $updateObject.Items | Where-Object {$_.ID -eq $ID}
                    if ($null -eq $item) {
                        $item = $updateObject.Triggers | Where-Object {$_.ID -eq $ID}
                    }
                }
                "WorkflowLink" {
                    $updateObject = Get-AMObject -ID $obj.WorkflowID -Types Workflow
                    if (($updateObject | Measure-Object).Count -eq 1) {
                        $link = $updateObject.Links | Where-Object {$_.ID -eq $obj.ID}
                    } else {
                        Write-Warning "Multiple workflows found for ID $($obj.WorkflowID)! No action will be taken."
                        continue objectloop
                    }
                }
                default {
                    Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
                }
            }
            if ($null -eq $link) {
                throw "Unable to find workflow link with the specified ID!"
                break
            }
            $shouldUpdate = $false
            if ($PSBoundParameters.ContainsKey("LinkType") -and ($link.LinkType -ne $LinkType)) {
                $link.LinkType = $LinkType
                if ($LinkType -ne [AMLinkType]::Result) {
                    $link.ResultType = [AMLinkResultType]::Default
                    $link.Value = ""
                }
                $shouldUpdate = $true
            }
            if ($PSBoundParameters.ContainsKey("Value") -and ($link.Value -ne $Value)) {
                $link.Value = $Value
                $shouldUpdate = $true
            }
            if ($PSBoundParameters.ContainsKey("ResultType") -and ($link.ResultType -ne $ResultType)) {
                $link.ResultType = $ResultType
                if ($ResultType -ne [AMLinkResultType]::Value) {
                    $link.Value = $ResultType.ToString()
                }
                $shouldUpdate = $true
            }
            if ($shouldUpdate) {
                $updateObject | Set-AMObject
            } else {
                Write-Verbose "No changes will be made to link '$($link.ID)' in $($updateObject.Type) '$($updateObject.Name)'."
            }
        }
    }
}