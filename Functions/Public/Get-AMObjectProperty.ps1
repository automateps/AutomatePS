function Get-AMObjectProperty {
    <#
        .SYNOPSIS
            Gets Automate workflow/task/agent properties if non-inherited values are used.  If the inherited values are used, nothing will be returned.

        .DESCRIPTION
            Get-AMObjectProperty gets properties for objects.

        .PARAMETER InputObject
            The object(s) to retrieve properties for.

        .INPUTS
            Properties for the following objects can be retrieved by this function:
            Workflow
            Task
            Agent

        .OUTPUTS
            WorkflowProperty, TaskProperty, AgentProperty

        .EXAMPLE
            # Get permissions for workflow "My Workflow"
            Get-AMWorkflow "My Workflow" | Get-AMObjectProperty

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding()]
    [Alias("Get-AMAgentProperty")]
    [Alias("Get-AMTaskProperty")]
    [Alias("Get-AMWorkflowProperty")]
    param (
        [Parameter(Position = 0, ParameterSetName = "ByPipeline", ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            Write-Verbose "Processing $($obj.Type) '$($obj.Name)'"
            if ($obj.Type -in @("Workflow","Task","Agent")) {
                Invoke-AMRestMethod -Resource "$([AMTypeDictionary]::($obj.Type).RestResource)/$($obj.ID)/properties/get" -RestMethod Get -Connection $obj.ConnectionAlias
            } else {
                $unsupportedType = $obj.GetType().FullName
                if ($obj.Type) {
                    $unsupportedType = $obj.Type
                } elseif (-not [string]::IsNullOrEmpty($obj.Type)) {
                    $unsupportedType = $obj.Type
                }
                Write-Error -Message "Unsupported input type '$unsupportedType' encountered!" -TargetObject $obj
            }
        }
    }
}