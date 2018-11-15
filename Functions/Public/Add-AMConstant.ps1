function Add-AMConstant {
    <#
        .SYNOPSIS
            Adds constants to an AutoMate Enterprise agent property.

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
            The following AutoMate object types can be modified by this function:
            AgentProperty

        .OUTPUTS
            None

        .EXAMPLE
            Get-AMAgent "agent01" | Get-AMObjectProperty | Add-AMConstant -Name test -Value 123 -Comment "Test adding a constant"

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 11/15/2018

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

        [string]$Comment
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "AgentProperty") {
                $parent = Get-AMAgent -ID $obj.ParentID -Connection $obj.ConnectionAlias
                $updateObject = $parent | Get-AMObjectProperty
                $shouldUpdate = $false
                if ($updateObject.Constants.Name -notcontains $Name) {
                    switch ((Get-AMConnection -ConnectionAlias $obj.ConnectionAlias).Version.Major) {
                        10      { $newConstant = [AMConstantv10]::new($obj.ConnectionAlias) }
                        11      { $newConstant = [AMConstantv11]::new($obj.ConnectionAlias) }
                        default { throw "Unsupported server major version: $_!" }
                    }
                    $newConstant.ParentID      = $updateObject.ID
                    $newConstant.Name          = $Name
                    $newConstant.Value         = $Value
                    $newConstant.Comment       = $Comment
                    $newConstant.ConstantUsage = [AMConstantType]::Constant
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
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
