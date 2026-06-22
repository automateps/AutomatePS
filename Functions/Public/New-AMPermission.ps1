function New-AMPermission {
    <#
        .SYNOPSIS
            Assigns security to an Automate object.

        .DESCRIPTION
            New-AMPermission assigns security to an object.

        .PARAMETER InputObject
            The object to apply security to.

        .PARAMETER Principal
            The user or group to assign security to.

		.PARAMETER FullControl
			Allow or deny full control on the object.

		.PARAMETER Create
			Allow or deny creating the object.

		.PARAMETER Read
			Allow or deny permission to view the object's properties.

		.PARAMETER Edit
			Allow or deny permission to modify the object.

		.PARAMETER Delete
			Allow or deny permission to delete the object.

		.PARAMETER DeleteRevisionFromRecycleBin
			Allow or deny permission to delete from the Recycle Bin.

		.PARAMETER DeleteRevision
			Allow or deny permission to delete a revision.

		.PARAMETER RestoreRevisionFromRecycleBin
			Allow or deny permission to restore from the Recycle Bin.

		.PARAMETER RestoreRevision
			Allow or deny permission to restore a previous version of the object.

		.PARAMETER Move
			Allow or deny permission to move the object from its original folder to another folder.

		.PARAMETER ToggleEnable
			Allow or deny permission to enable this object if it is currently disabled.

		.PARAMETER ManualRun
			Allow or deny permission to manually run the object.

		.PARAMETER Stop
			Allow or deny permission to manually stop the object when it is running.

		.PARAMETER Import
			Allow or deny permission to import the object.

		.PARAMETER Export
			Allow or deny permission to export the object.

		.PARAMETER Staging
			Allow or deny staging for the object.

		.PARAMETER Assign
			Allow or deny permission to assign the object to a workflow.

		.PARAMETER ChangeSecurity
			Allow or deny permission to modify the security (permissions) settings of the object.

		.PARAMETER ManualResume
			Allow or deny the object to resume execution from where it last encountered an error.

		.PARAMETER ManualRunFromHere
			Allow or deny permission to manually run the object from the specified step or workflow location.

		.PARAMETER ToggleLock
			Allow or deny permission to lock an object.

		.PARAMETER UpdateRevision
			Allow or deny permission to update a revision.

		.PARAMETER Upgrade
			Allow or deny permission to upgrade an agent.

        .PARAMETER Resurrect
            Undocumented permission.

        .EXAMPLE
            # Denies user 'John' access to task 'Test'
            Get-AMTask -Name "Test" | New-AMPermission -Principal "John"

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/New-AMPermission.md
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Low")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $InputObject,

        [ValidateNotNullOrEmpty()]
        $Principal,

        [switch]$FullControl = $false,
        [switch]$Create = $false,
        [switch]$Read = $false,
        [switch]$Edit = $false,
        [switch]$Delete = $false,
        [switch]$DeleteRevisionFromRecycleBin = $false,
        [switch]$DeleteRevision = $false,
        [switch]$RestoreRevisionFromRecycleBin = $false,
        [switch]$RestoreRevision = $false,
        [switch]$Move = $false,
        [switch]$ToggleEnable = $false,
        [switch]$ManualRun = $false,
        [switch]$Stop = $false,
        [switch]$Import = $false,
        [switch]$Export = $false,
        [switch]$Staging = $false,
        [switch]$Assign = $false,
        [switch]$ChangeSecurity = $false,
        [switch]$ManualResume = $false,
        [switch]$ManualRunFromHere = $false,
        [switch]$ToggleLock = $false,
        [switch]$UpdateRevision = $false,
        [switch]$Upgrade = $false,
        [switch]$Resurrect = $false
    )

    BEGIN {
        $tempPrincipal = @()
        foreach ($obj in $Principal) {
            if ($obj.PSObject.Properties | Where-Object {$_.Name -eq "Type"}) {
                if ($obj.Type -notin @("User","UserGroup")) {
                    throw "Unsupported input type '$($obj.Type)' encountered!"
                }
                $tempPrincipal += $obj
            } elseif ($obj -is [string]) {
                $temp = Get-AMUserGroup -Name $obj
                if ($temp) {
                    $tempPrincipal += $temp
                } else {
                    $temp = Get-AMUser -Name $obj
                    if ($temp) {
                        $tempPrincipal += $temp
                    } else {
                        throw "Principal '$obj' not found!"
                    }
                }
            }
        }
        $Principal = $tempPrincipal

        if ($FullControl.IsPresent) {
            $Create = $true
            $Read = $true
            $Edit = $true
            $Delete = $true
            $DeleteRevisionFromRecycleBin = $true
            $DeleteRevision = $true
            $RestoreRevisionFromRecycleBin = $true
            $RestoreRevision = $true
            $Move = $true
            $ToggleEnable = $true
            $ManualRun = $true
            $Stop = $true
            $Import = $true
            $Export = $true
            $Staging = $true
            $Assign = $true
            $ChangeSecurity = $true
            $ManualResume = $true
            $ManualRunFromHere = $true
            $ToggleLock = $true
            $UpdateRevision = $true
            $Upgrade = $true
            $Resurrect = $true
        }
    }

    PROCESS {
        foreach ($obj in $InputObject) {
            $connection = Get-AMConnection -ConnectionAlias $obj.ConnectionAlias
            if ($obj.Type -in @("Folder","Workflow","Task","Condition","Process","Agent","AgentGroup","User","UserGroup")) {
                $currentPermissions = $obj | Get-AMPermission
                foreach ($p in $Principal) {
                    if ($null -eq ($currentPermissions | Where-Object {$_.GroupID -eq $p.ID})) {
                        switch ((Get-AMConnection -ConnectionAlias $obj.ConnectionAlias).GetCompatibility()) {
                            10 { $newObject = [AMPermissionv10]::new($obj, $p, $obj.ConnectionAlias) }
                            11 { $newObject = [AMPermissionv11]::new($obj, $p, $obj.ConnectionAlias) }
                        }
                        $newObject.AssignPermission      = $Assign.IsPresent
                        $newObject.CreatePermission      = $Create.IsPresent
                        $newObject.DeletePermission      = $Delete.IsPresent
                        $newObject.EditPermission        = $Edit.IsPresent
                        $newObject.EnablePermission      = $ToggleEnable.IsPresent
                        $newObject.ExportPermission      = $Export.IsPresent
                        $newObject.ImportPermission      = $Import.IsPresent
                        $newObject.LockPermission        = $ToggleLock.IsPresent
                        $newObject.MovePermission        = $Move.IsPresent
                        $newObject.ReadPermission        = $Read.IsPresent
                        $newObject.ResumePermission      = $ManualResume.IsPresent
                        $newObject.ResurrectPermission   = $Resurrect.IsPresent
                        $newObject.RunFromHerePermission = $ManualRunFromHere.IsPresent
                        $newObject.RunPermission         = $ManualRun.IsPresent
                        $newObject.SecurityPermission    = $ChangeSecurity.IsPresent
                        $newObject.StagingPermission     = $Staging.IsPresent
                        $newObject.StopPermission        = $Stop.IsPresent
                        $newObject.UpgradePermission     = $Upgrade.IsPresent
                        if (Test-AMFeatureSupport -Connection $connection -Feature RevisionManagement -Action Ignore) {
                            $newObject.DeleteRevisionFromRecycleBinPermission  = $DeleteRevisionFromRecycleBin.IsPresent
                            $newObject.DeleteRevisionPermission                = $DeleteRevision.IsPresent
                            $newObject.RestoreRevisionFromRecycleBinPermission = $RestoreRevisionFromRecycleBin.IsPresent
                            $newObject.RestoreRevisionPermission               = $RestoreRevision.IsPresent
                            $newObject.UpdateRevisionPermission                = $UpdateRevision.IsPresent
                        }

                        $splat += @{
                            Resource = "$(([AMTypeDictionary]::($obj.Type)).RestResource)/$($obj.ID)/permissions/create"
                            RestMethod = "Post"
                            Body = $newObject.ToJson()
                            Connection = $obj.ConnectionAlias
                        }
                        if ($PSCmdlet.ShouldProcess($connection.Name, "Creating permission for: $(Join-Path -Path $obj.Path -ChildPath $obj.Name)")) {
                            Invoke-AMRestMethod @splat | Out-Null
                            Write-Verbose "Assigned permissions to $($p.Type) '$($p.Name)' for $($obj.Type) '$($obj.Name)'!"
                            $obj | Get-AMPermission -ID $newObject.ID
                        }
                    } else {
                        Write-Warning "$($p.Type) '$($p.Name)' already has permissions for $($obj.Type) '$($obj.Name)'!"
                    }
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
