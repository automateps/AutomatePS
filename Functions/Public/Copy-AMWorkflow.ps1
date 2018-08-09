function Copy-AMWorkflow {
    <#
        .SYNOPSIS
            Copies an AutoMate Enterprise workflow.

        .DESCRIPTION
            Copy-AMWorkflow can copy a workflow within a server.

        .PARAMETER InputObject
            The object to copy.

        .PARAMETER Name
            The new name to set on the object.

        .PARAMETER Folder
            The folder to place the object in.

        .INPUTS
            The following AutoMate object types can be modified by this function:
            Workflow

        .EXAMPLE
            # Copy workflow "FTP Files to Company A" to "FTP Files to Company B"
            Get-AMWorkflow "FTP Files to Company A" | Copy-AMWorkflow -Name "FTP Files to Company B" -Folder (Get-AMFolder WORKFLOWS)

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
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $InputObject,

        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [ValidateScript({$_.Type -eq "Folder"})]
        $Folder
    )

    BEGIN {
        $currentDate = Get-Date
        $nullDate = Get-Date "12/31/1899 7:00:00 PM"
    }

    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "Workflow") {
                $guid = "{$((New-Guid).Guid)}"
                $user = Get-AMUser -Connection $obj.ConnectionAlias | Where-Object {$_.Name -ieq ($global:AMConnections | Where-Object {$_.Alias -eq $obj.ConnectionAlias}).Credential.UserName}                
                $copy = Get-AMWorkflow -ID $obj.ID -Connection $obj.ConnectionAlias
                $copy.ID              = $guid
                $copy.CompletionState = 0
                $copy.CreatedBy       = $user.ID
                $copy.CreatedOn       = $currentDate
                $copy.EndedOn         = $nullDate
                $copy.ResultCode      = 0
                $copy.ResultText      = ""
                $copy.ModifiedOn      = $currentDate
                $copy.StartedOn       = $nullDate
                $copy.Version         = 1
                $copy.VersionDate     = $currentDate

                # Update GUIDs
                foreach ($link in $copy.Links) {
                    $link.ID = "{$((New-Guid).Guid)}"
                    $link.WorkflowID = $guid
                }
                foreach ($item in $copy.Items) {
                    # Update item ID and any link references
                    $newGuid = "{$((New-Guid).Guid)}"
                    $copy.Links | Where-Object {$_.SourceID -eq $item.ID} | ForEach-Object { $_.SourceID = $newGuid }
                    $copy.Links | Where-Object {$_.DestinationID -eq $item.ID} | ForEach-Object { $_.DestinationID = $newGuid }
                    $item.ID = $newGuid
                    $item.WorkflowID = $guid
                }
                foreach ($trigger in $copy.Triggers) {
                    # Update trigger ID and any link references
                    $newGuid = "{$((New-Guid).Guid)}"
                    $copy.Links | Where-Object {$_.SourceID -eq $trigger.ID} | ForEach-Object { $_.SourceID = $newGuid }
                    $copy.Links | Where-Object {$_.DestinationID -eq $trigger.ID} | ForEach-Object { $_.DestinationID = $newGuid }
                    $trigger.ID = $newGuid
                    $trigger.WorkflowID = $guid
                }
                foreach ($variable in $copy.Variables) {
                    $variable.ID = "{$((New-Guid).Guid)}"
                    $variable.ParentID = $guid
                }
                if ($Name)   { $copy.Name = $Name }
                if ($Folder) { $copy.ParentID = $Folder.ID }
                $copy | New-AMObject -Connection $obj.ConnectionAlias
                Get-AMWorkflow -ID $guid -Connection $obj.ConnectionAlias
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
