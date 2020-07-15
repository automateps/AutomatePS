function Start-AMWorkflow {
    <#
        .SYNOPSIS
            Starts Automate workflows.

        .DESCRIPTION
            Start-AMWorkflow starts workflows.

        .PARAMETER InputObject
            The workflows to start.

        .PARAMETER Parameters
            A hashtable containing shared variable name/value pairs to update the workflow with prior to execution.

        .INPUTS
            Workflows can be supplied on the pipeline to this function.

        .EXAMPLE
            # Starts workflow "My Workflow"
            Get-AMWorkflow "My Workflow" | Start-AMWorkflow

        .EXAMPLE
            # Starts workflow "My Workflow" with parameters
            $parameters = @{ varName = "test" }
            Get-AMWorkflow "My Workflow" | Start-AMWorkflow -Parameters $parameters

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
        [Hashtable]$Parameters
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            $connection = Get-AMConnection -ConnectionAlias $obj.ConnectionAlias
            if ($obj.Type -eq "Workflow") {
                if ($PSCmdlet.ShouldProcess($connection.Name, "Starting workflow: $(Join-Path -Path $obj.Path -ChildPath $obj.Name)")) {
                    if ($PSBoundParameters.ContainsKey("Parameters")) {
                        $variableChanged = $false
                        foreach ($key in $Parameters.Keys) {
                            $variable = $obj.Variables | Where-Object {$_.Name -eq $key}
                            if (($variable | Measure-Object).Count -eq 1) {
                                if ($variable.DataType -eq "Variable") {
                                    if ($variable.InitalValue -ne $Parameters[$key]) {
                                        $variable.InitalValue = $Parameters[$key]
                                        $variableChanged = $true
                                    }
                                } else {
                                    throw "Variable '$key' is a $($variable.DataType), which is not supported!"
                                }
                            } else {
                                throw "Could not find variable '$key' in workflow $($obj.Name)!"
                            }
                        }
                        if ($variableChanged) {
                            Write-Verbose "Passing parameters into workflow $($obj.Name)."
                            Set-AMWorkflow -Instance $obj
                        }
                    }
                    Write-Verbose "Running workflow $($obj.Name)."
                    $instanceID = Invoke-AMRestMethod -Resource "workflows/$($obj.ID)/run" -RestMethod Post -Connection $obj.ConnectionAlias
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