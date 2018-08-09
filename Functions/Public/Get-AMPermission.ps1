function Get-AMPermission {
    <#
        .SYNOPSIS
            Gets AutoMate Enterprise permissions.

        .DESCRIPTION
            Get-AMPermission gets permissions for objects.

        .PARAMETER InputObject
            The object(s) to retrieve permissions for.

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

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 08/08/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(DefaultParameterSetName = "All")]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Position = 0, ParameterSetName = "ByPipeline", ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            Write-Verbose "Processing $($obj.Type) '$($obj.Name)'"
            if ($obj.Type -in @("Workflow","Task","Condition","Process","Folder","Agent","AgentGroup","User","UserGroup")) {
                $permissionIndex = Invoke-AMRestMethod -Resource "$([AMTypeDictionary]::($obj.Type).RestResource)/$($obj.ID)/permissions/index" -RestMethod Get -Connection $obj.Connection
                foreach ($permissionID in $permissionIndex) {
                    Invoke-AMRestMethod -Resource "$([AMTypeDictionary]::($obj.Type).RestResource)/$($obj.ID)/permissions/$permissionID/get" -RestMethod Get -Connection $obj.Connection
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
