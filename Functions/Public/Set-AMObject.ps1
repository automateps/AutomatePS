function Set-AMObject {
    <#
        .SYNOPSIS
            Modifies an Automate object.

        .DESCRIPTION
            Set-AMObject receives modified Automate object(s) on the pipeline, or via the parameter $InputObject, and applies the modifications.

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

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMObject.md
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
