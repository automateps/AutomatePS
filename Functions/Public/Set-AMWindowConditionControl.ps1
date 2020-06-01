function Set-AMWindowConditionControl {
    <#
        .SYNOPSIS
            Modifies an Automate window condition control.

        .DESCRIPTION
            Set-AMWindowConditionControl modifies a control in an Automate window condition.

        .PARAMETER InputObject
            The window condition object to add the control to.

        .PARAMETER ID
            The ID of the window control.

        .PARAMETER Class
            The class of the control.

        .PARAMETER Name
            The name of the control.

        .PARAMETER Type
            The type of control.

        .PARAMETER Value
            The value of the control.

        .PARAMETER XPosition
            The X position of the control on screen.

        .PARAMETER YPosition
            The Y position of the control on screen.

        .EXAMPLE
            Get-AMCondition "window" | Set-AMWindowConditionControl -ID "{0cee39da-1f6c-424b-a9bd-eeaf17cbd1f2}" -Class ConsoleWindowClass -Name Close -Type PushButton

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding(DefaultParameterSetName="Default",SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [Parameter(Mandatory = $true)]
        $ID,
        $Class,
        $Name,
        $Type,
        $Value,
        $XPosition,
        $YPosition
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            if (($obj.Type -eq "Condition") -and ($obj.TriggerType -eq [AMTriggerType]::Window)) {
                $updateObject = Get-AMCondition -ID $obj.ID -Connection $obj.ConnectionAlias
                $shouldUpdate = $false
                foreach ($windowcontrol in $updateObject.WindowControl | Where-Object {$_.ID -eq $ID}) {
                    if ($PSBoundParameters.ContainsKey("Class") -and ($windowcontrol.Class -ne $Class)) {
                        $windowcontrol.Class = $Class
                        if ($Class -eq "") {
                            $windowcontrol.CheckClass = $false
                        } else {
                            $windowcontrol.CheckClass = $true
                        }
                        $shouldUpdate = $true
                    }
                    if ($PSBoundParameters.ContainsKey("Name") -and ($windowcontrol.Name -ne $Name)) {
                        $windowcontrol.Name = $Name
                        if ($Name -eq "") {
                            $windowcontrol.CheckName = $false
                        } else {
                            $windowcontrol.CheckName = $true
                        }
                        $shouldUpdate = $true
                    }
                    if ($PSBoundParameters.ContainsKey("Type") -and ($windowcontrol.Type -ne $Type)) {
                        $windowcontrol.Type = $Type
                        if ($Type -eq "") {
                            $windowcontrol.CheckType = $false
                        } else {
                            $windowcontrol.CheckType = $true
                        }
                        $shouldUpdate = $true
                    }
                    if ($PSBoundParameters.ContainsKey("Value") -and ($windowcontrol.Value -ne $Value)) {
                        $windowcontrol.Value = $Value
                        if ($Value -eq "") {
                            $windowcontrol.CheckValue = $false
                        } else {
                            $windowcontrol.CheckValue = $true
                        }
                        $shouldUpdate = $true
                    }
                    if ($PSBoundParameters.ContainsKey("XPosition") -and ($windowcontrol.Xpos -ne $XPosition)) {
                        $windowcontrol.Xpos = $XPosition
                        if ($XPosition -eq "") {
                            $windowcontrol.CheckPosition = $false
                        } else {
                            $windowcontrol.CheckPosition = $true
                        }
                        $shouldUpdate = $true
                    }
                    if ($PSBoundParameters.ContainsKey("YPosition") -and ($windowcontrol.Ypos -ne $YPosition)) {
                        $windowcontrol.Ypos = $YPosition
                        if ($YPosition -eq "") {
                            $windowcontrol.CheckPosition = $false
                        } else {
                            $windowcontrol.CheckPosition = $true
                        }
                        $shouldUpdate = $true
                    }
                }
                if ($shouldUpdate) {
                    $updateObject | Set-AMObject
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' and trigger type '$($obj.TriggerType)' encountered!" -TargetObject $obj
            }
        }
    }
}
