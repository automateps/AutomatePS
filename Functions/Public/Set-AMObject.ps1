function Set-AMObject {
    <#
        .SYNOPSIS
            Modifies an AutoMate Enterprise object.

        .DESCRIPTION
            Set-AMObject receives modified AutoMate Enterprise object(s) on the pipeline, or via the parameter $InputObject, and applies the modifications.

        .PARAMETER InputObject
            The object(s) to be modified.

        .INPUTS
            The following objects can be modified by this function:
            Workflow
            Task
            Process
            TaskAgent
            ProcessAgent
            AgentGroup
            User
            UserGroup

        .EXAMPLE
            $obj = Get-AMWorkflow "My Workflow"
            $obj.Notes = "New Notes"
            $obj | Set-AMObject

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 11/15/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            if ($PSCmdlet.ShouldProcess($obj.ConnectionAlias, "Modifying $($obj.Type): $(Join-Path -Path $obj.Path -ChildPath $obj.Name)")) {
                $splat = @{
                    Resource = "$(([AMTypeDictionary]::($obj.Type)).RestResource)/$($obj.ID)/update"
                    RestMethod = "Post"
                    Body = $obj.ToJson()
                    Connection = $obj.ConnectionAlias
                }
                Invoke-AMRestMethod @splat | Out-Null
                Write-Verbose "Modified $($obj.Type): $(Join-Path -Path $obj.Path -ChildPath $obj.Name)."
            }
        }
    }
}
