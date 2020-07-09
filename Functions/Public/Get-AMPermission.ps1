function Get-AMPermission {
    <#
        .SYNOPSIS
            Gets Automate permissions.

        .DESCRIPTION
            Get-AMPermission gets permissions for objects.

        .PARAMETER InputObject
            The object(s) to retrieve permissions for.

        .PARAMETER ID
            The ID of the permission to retrieve.

        .INPUTS
            Permissions for the following objects can be retrieved by this function:
            Workflow
            Task
            Condition
            Process
            Agent
            AgentGroup
            User
            UserGroup
            Folder

        .OUTPUTS
            Permission

        .EXAMPLE
            # Get permissions for workflow "My Workflow"
            Get-AMWorkflow "My Workflow" | Get-AMPermission

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding()]
    [OutputType([AMPermissionv10],[AMPermissionv11])]
    param (
        [Parameter(Position = 0, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [ValidateNotNullOrEmpty()]
        $ID
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            Write-Verbose "Processing $($obj.Type) '$($obj.Name)'"
            if ($obj.Type -in @("Workflow","Task","Condition","Process","Folder","Agent","AgentGroup","User","UserGroup")) {
                $permissionIndex = Invoke-AMRestMethod -Resource "$([AMTypeDictionary]::($obj.Type).RestResource)/$($obj.ID)/permissions/index" -RestMethod Get -Connection $obj.ConnectionAlias
                foreach ($permissionID in $permissionIndex) {
                    if (($PSBoundParameters.ContainsKey("ID") -and $permissionID -eq $ID) -or -not $PSBoundParameters.ContainsKey("ID")) {
                        Invoke-AMRestMethod -Resource "$([AMTypeDictionary]::($obj.Type).RestResource)/$($obj.ID)/permissions/$permissionID/get" -RestMethod Get -Connection $obj.ConnectionAlias
                    }
                }
            } else {
                $unsupportedType = $obj.GetType().FullName
                if ($_) {
                    $unsupportedType = $_
                } elseif (-not [string]::IsNullOrEmpty($obj.Type)) {
                    $unsupportedType = $obj.Type
                }
                Write-Error -Message "Unsupported input type '$unsupportedType' encountered!" -TargetObject $obj
            }
        }
    }
}
