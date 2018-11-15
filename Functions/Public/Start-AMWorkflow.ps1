function Start-AMWorkflow {
    <#
        .SYNOPSIS
            Starts AutoMate Enterprise workflows.

        .DESCRIPTION
            Start-AMWorkflow starts workflows.

        .PARAMETER InputObject
            The workflows to start.

        .INPUTS
            Workflows can be supplied on the pipeline to this function.

        .EXAMPLE
            # Starts workflow "My Workflow"
            Get-AMWorkflow "My Workflow" | Start-AMWorkflow

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 11/15/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    [OutputType([System.Object[]])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            $connection = Get-AMConnection -ConnectionAlias $obj.ConnectionAlias
            if ($obj.Type -eq "Workflow") {
                if ($PSCmdlet.ShouldProcess($connection.Name, "Starting workflow: $(Join-Path -Path $obj.Path -ChildPath $obj.Name)")) {
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