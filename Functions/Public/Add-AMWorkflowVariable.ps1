function Add-AMWorkflowVariable {
    <#
        .SYNOPSIS
            Adds a shared variable to an AutoMate Enterprise workflow

        .DESCRIPTION
            Add-AMWorkflowVariable can add shared variables to a workflow object.

        .PARAMETER InputObject
            The object to add the variable to.

        .PARAMETER Name
            The name of the variable.

        .PARAMETER InitialValue
            The initial value of the variable.

        .PARAMETER Description
            The description of the variable.

        .PARAMETER VariableType
            The type of variable: Auto, Number or Text.

        .PARAMETER DataType
            The data type of the variable.

        .PARAMETER PassValueFromParent
            If specified, the variable will be configured to pass the value from the parent workflow to this workflow.

        .PARAMETER PassValueToParent
            If specified, the variable will be configured to pass the value from this workflow to the parent workflow.

        .INPUTS
            The following AutoMate object types can be modified by this function:
            Workflow

        .OUTPUTS
            None

        .EXAMPLE
            # Add variable 'emailAddress' to workflow 'Some Workflow'
            Get-AMWorkflow "Some Workflow" | Add-AMWorkflowVariable -Name "emailAddress" -InitialValue "person@example.com" -Description "Email this user when the job fails"

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 11/15/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [ValidateNotNull()]
        $InitialValue = "",

        [ValidateNotNull()]
        [string]$Description = "",

        [AMWorkflowVarDataType]$VariableType = [AMWorkflowVarDataType]::Variable,

        [ValidateNotNullOrEmpty()]
        [AMWorkflowVarType]$DataType = [AMWorkflowVarType]::Auto,

        [ValidateNotNullOrEmpty()]
        [switch]$PassValueFromParent = $false,

        [ValidateNotNullOrEmpty()]
        [switch]$PassValueToParent = $false
    )
    BEGIN {
        switch ($VariableType) {
            {($_ -in @("Array","Dataset"))} {
                # Ignore values that don't apply to arrays or datasets
                $InitialValue = ""
                $DataType = [AMWorkflowVarType]::Auto
                $PassValueFromParent = $false
                $PassValueToParent = $false
            }
        }
    }

    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "Workflow") {
                # Get the latest version of the object.  Get-AMWorkflow by ID also returns an object from workflows/<id>/get, which is in the correct format for updating.
                $updateObject = Get-AMWorkflow -ID $obj.ID -Connection $obj.ConnectionAlias
                $shouldUpdate = $false

                if ($updateObject.Variables.Name -notcontains $Name) {
                    switch ((Get-AMConnection -ConnectionAlias $obj.ConnectionAlias).Version.Major) {
                        10      { $newVariable = [AMWorkflowVariablev10]::new($obj.ConnectionAlias) }
                        11      { $newVariable = [AMWorkflowVariablev11]::new($obj.ConnectionAlias) }
                        default { throw "Unsupported server major version: $_!" }
                    }
                    $newVariable.Name         = $Name
                    $newVariable.ParentID     = $updateObject.ID
                    $newVariable.DataType     = $VariableType
                    $newVariable.Description  = $Description
                    $newVariable.InitalValue  = $InitialValue
                    $newVariable.Parameter    = $PassValueFromParent.ToBool()
                    $newVariable.Private      = $PassValueToParent.ToBool()
                    $newVariable.VariableType = $DataType
                    $updateObject.Variables += $newVariable
                    $shouldUpdate = $true
                }
                if ($shouldUpdate) {
                    Set-AMWorkflow -Instance $updateObject
                } else {
                    Write-Verbose "$($obj.Type) '$($obj.Name)' already contains the specified values."
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
