function Start-AMWorkflow {
    <#
        .SYNOPSIS
            Starts Automate workflows.

        .DESCRIPTION
            Start-AMWorkflow starts workflows.

        .PARAMETER InputObject
            The workflows to start.

        .PARAMETER Variables
            The variables to pass into a workflow or task at runtime.

        .INPUTS
            Workflows can be supplied on the pipeline to this function.

        .EXAMPLE
            # Starts workflow "My Workflow"
            Get-AMWorkflow "My Workflow" | Start-AMWorkflow

        .EXAMPLE
            # Starts workflow "My Workflow" with variables
            Get-AMWorkflow "My Workflow" | Start-AMWorkflow -Variables @{ varName = "test" }

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Start-AMWorkflow.md
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    [OutputType([AMInstancev10],[AMInstancev11])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [ValidateNotNullOrEmpty()]
        [Hashtable]$Variables
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            $connection = Get-AMConnection -ConnectionAlias $obj.ConnectionAlias
            if ($obj.Type -eq "Workflow") {
                if ($PSBoundParameters.ContainsKey("Variables")) {
                    if (-not (Test-AMFeatureSupport -Connection $obj.ConnectionAlias -Feature ApiRuntimeVariables -Action Throw)) {
                        break
                    }
                }
                if ($PSCmdlet.ShouldProcess($connection.Name, "Starting workflow: $(Join-Path -Path $obj.Path -ChildPath $obj.Name)")) {
                    Write-Verbose "Running workflow $($obj.Name)."
                    $runUri = Format-AMUri -Path "workflows/$($obj.ID)/run" -Variables $Variables
                    $instanceID = Invoke-AMRestMethod -Resource $runUri -RestMethod Post -Connection $obj.ConnectionAlias
                    Start-Sleep -Seconds 1   # The instance can't be retrieved right away, have to pause briefly
                    $uri = Format-AMUri -Path "instances/list" -FilterSet @{Property = "ID"; Operator = "="; Value = $instanceID}
                    Invoke-AMRestMethod -Resource $uri -RestMethod Get -Connection $obj.ConnectionAlias
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}