function Set-AMConstant {
    <#
        .SYNOPSIS
            Sets constants on an AutoMate Enterprise agent property.

        .DESCRIPTION
            Set-AMConstant sets constants for an agent.

        .PARAMETER InputObject
            The agent property to modify.

        .PARAMETER Name
            The name of the constant to modify.

        .PARAMETER Value
            The value to set for the constant.

        .PARAMETER Comment
            The comment to set for the constant.

        .INPUTS
            The following AutoMate object types can be modified by this function:
            AgentProperty

        .OUTPUTS
            None

        .EXAMPLE
            Get-AMAgent "agent01" | Get-AMObjectProperty | Set-AMConstant -Name test -Value 123 -Comment "Test modifying a constant"

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 02/06/2019
            Date Modified  : 02/06/2019

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $InputObject,

        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$Value,

        [AllowEmptyString()]
        [string]$Comment
    )

    PROCESS {
        foreach ($obj in $InputObject) {
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
                $constant = $updateObject.Constants | Where-Object {$_.Name -eq $Name}
                if ($PSBoundParameters.ContainsKey("Value") -and $constant.Value -ne $Value) {
                    $constant.Value = $Value
                    $constant.ClearTextValue = $Value
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("Comment") -and $constant.Comment -ne $Comment) {
                    $constant.Comment = $Comment
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
                Write-Error -Message "AgentProperty not specified!" -TargetObject $obj
            }
        }
    }
}
