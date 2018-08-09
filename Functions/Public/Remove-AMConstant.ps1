function Remove-AMConstant {
    <#
        .SYNOPSIS
            Removes constants from an AutoMate Enterprise agent property.

        .DESCRIPTION
            Remove-AMConstant removes constants from an agent property.

        .PARAMETER InputObject
            The agent property to modify.

        .PARAMETER Name
            The name of the constant.

        .INPUTS
            The following AutoMate object types can be modified by this function:
            AgentProperty

        .OUTPUTS
            None

        .EXAMPLE
            Get-AMAgent "agent01" | Get-AMObjectProperty | Remove-AMConstant -Name test

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 08/08/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $InputObject,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "AgentProperty") {
                $parent = Get-AMAgent -ID $obj.ParentID -Connection $obj.ConnectionAlias
                $updateObject = $parent | Get-AMObjectProperty
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
                    Invoke-AMRestMethod @splat | Out-Null
                    Write-Verbose "Modified $($obj.Type) for $($parent.Type): $(Join-Path -Path $parent.Path -ChildPath $parent.Name)."
                } else {
                    Write-Verbose "$($obj.Type) for $($parent.Type) '$($parent.Name)' already contains the specified values."
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
