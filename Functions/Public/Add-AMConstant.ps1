function Add-AMConstant {
    <#
        .SYNOPSIS
            Adds constants to an Automate agent property.

        .DESCRIPTION
            Add-AMConstant adds constants to an agent property.

        .PARAMETER InputObject
            The agent property to modify.

        .PARAMETER Name
            The name for the new constant.

        .PARAMETER Value
            The value for the new constant.

        .PARAMETER Comment
            The comment for the new constant.

        .INPUTS
            The following Automate object types can be modified by this function:
            AgentProperty

        .OUTPUTS
            None

        .EXAMPLE
            Get-AMAgent "agent01" | Get-AMObjectProperty | Add-AMConstant -Name test -Value 123 -Comment "Test adding a constant"

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Add-AMConstant.md
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
                if ($updateObject.Constants.Name -notcontains $Name) {
                    switch ((Get-AMConnection -ConnectionAlias $obj.ConnectionAlias).Version.Major) {
                        10             { $newConstant = [AMConstantv10]::new($obj.ConnectionAlias) }
                        {$_ -in 11,22} { $newConstant = [AMConstantv11]::new($obj.ConnectionAlias) }
                        default        { throw "Unsupported server major version: $_!" }
                    }
                    $newConstant.ParentID       = $updateObject.ID
                    $newConstant.Name           = $Name
                    $newConstant.Value          = $Value
                    $newConstant.ClearTextValue = $Value
                    $newConstant.Comment        = $Comment
                    $newConstant.ConstantUsage  = [AMConstantType]::Constant
                    $updateObject.Constants += $newConstant
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
