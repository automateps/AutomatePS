function Remove-AMConstant {
    <#
        .SYNOPSIS
            Removes constants from an Automate agent property.

        .DESCRIPTION
            Remove-AMConstant removes constants from an agent property.

        .PARAMETER InputObject
            The agent property to modify.

        .PARAMETER Name
            The name of the constant.

        .INPUTS
            The following Automate object types can be modified by this function:
            AgentProperty

        .OUTPUTS
            None

        .EXAMPLE
            Get-AMAgent "agent01" | Get-AMObjectProperty | Remove-AMConstant -Name test

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Remove-AMConstant.md
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            $connection = Get-AMConnection -ConnectionAlias $obj.ConnectionAlias
            switch ($obj.Type) {
                "Agent" {
                    $parent = Get-AMAgent -ID $obj.ID -Connection $obj.ConnectionAlias
                }
                "AgentProperty" {
                    $parent = Get-AMAgent -ID $obj.ParentID -Connection $obj.ConnectionAlias
                }
                default {
                    Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
                }
            }
            $updateObject = $parent | Get-AMObjectProperty
            if (($updateObject | Measure-Object).Count -eq 1) {
                $shouldUpdate = $false
                if ($updateObject.Constants.Name -contains $Name) {
                    $newConstants = $updateObject.Constants | Where-Object {$_.Name -ne $Name}
                    switch (($newConstants | Measure-Object).Count) {
                        0 {
                            $updateObject.Constants = [System.Collections.ArrayList]::new()
                        }
                        1 {
                            $updateObject.Constants = [System.Collections.ArrayList]::new()
                            $updateObject.Constants.Add($newConstants) | Out-Null
                        }
                        default {
                            $updateObject.Constants = $newConstants
                        }
                    }
                    $shouldUpdate = $true
                }
                if ($shouldUpdate) {
                    $splat = @{
                        Resource = "agents/$($obj.ParentID)/properties/update"
                        RestMethod = "Post"
                        Body = $updateObject.ToJson()
                        Connection = $updateObject.ConnectionAlias
                    }
                    if ($PSCmdlet.ShouldProcess($connection.Name, "Removing constant '$Name' from agent: $($parent.Name)")) {
                        Invoke-AMRestMethod @splat | Out-Null
                        Write-Verbose "Modified $($obj.Type) for $($parent.Type): $(Join-Path -Path $parent.Path -ChildPath $parent.Name)."
                    }
                } else {
                    Write-Verbose "$($obj.Type) for $($parent.Type) '$($parent.Name)' already contains the specified values."
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}