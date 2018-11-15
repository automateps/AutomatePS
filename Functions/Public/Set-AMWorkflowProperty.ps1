function Set-AMWorkflowProperty {
    <#
        .SYNOPSIS
            Sets the properties of an AutoMate Enterprise workflow.

        .DESCRIPTION
            Set-AMWorkflowProperty modifies workflow properties.

        .PARAMETER InputObject
            The workflow property to modify.

        .PARAMETER DefaultAgentPropertiesSpecified
            Override the default agent property inheritance.

        .PARAMETER DefaultAgent
            The default agent.

        .PARAMETER ErrorNotificationPropertiesSpecified
            Override the error property inheritance.

        .PARAMETER ErrorNotifyEmailFromAddress
            The error email sender.

        .PARAMETER ErrorNotifyEmailToAddress
            The error email recipient.

        .PARAMETER DisableOnFailure
            Whether the workflow should be automatically disabled on next failure.

        .PARAMETER ResumeFromFailure
            Whether the workflow should automatically resume from failure on next run.

        .PARAMETER TimeoutPropertiesSpecified
            Override the timeout property inheritance.

        .PARAMETER TimeoutEnabled
            Whether the timeout property is enabled.

        .PARAMETER Timeout
            The timeout duration.

        .PARAMETER TimeoutUnit
            The timeout unit.

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/27/2018
            Date Modified  : 11/15/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [ValidateNotNullOrEmpty()]
        [switch]$DefaultAgentPropertiesSpecified,

        [ValidateNotNullOrEmpty()]
        $DefaultAgent,

        [ValidateNotNullOrEmpty()]
        [switch]$ErrorNotificationPropertiesSpecified,

        [ValidateNotNull()]
        [string]$ErrorNotifyEmailFromAddress,

        [ValidateNotNull()]
        [string]$ErrorNotifyEmailToAddress,

        [ValidateNotNullOrEmpty()]
        [switch]$DisableOnFailure,

        [ValidateNotNullOrEmpty()]
        [switch]$ResumeFromFailure,

        [ValidateNotNullOrEmpty()]
        [switch]$TimeoutPropertiesSpecified,

        [ValidateNotNullOrEmpty()]
        [switch]$TimeoutEnabled,

        [ValidateNotNullOrEmpty()]
        [int]$Timeout,

        [ValidateNotNullOrEmpty()]
        [AMTimeMeasure]$TimeoutUnit
    )

    BEGIN {
        if ($PSBoundParameters.ContainsKey("DefaultAgent") -and ($DefaultAgent.Type -ne "Agent")) {
            # Lookup agent by name
            $agent = Get-AMAgent -Name $DefaultAgent
            if ($null -ne $agent) {
                $DefaultAgent = $agent
            } else {
                throw "Could not find agent with name '$DefaultAgent'!"
            }
        }
    }

    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "WorkflowProperty") {
                $connection = Get-AMConnection -ConnectionAlias $obj.ConnectionAlias
                $parent = Get-AMWorkflow -ID $obj.ParentID -Connection $obj.ConnectionAlias
                $updateObject = $parent | Get-AMObjectProperty
                $shouldUpdate = $false
                if ($PSBoundParameters.ContainsKey("DefaultAgent") -and ($updateObject.DefaultAgentID -ne $DefaultAgent.ID)) {
                    $updateObject.DefaultAgentID = $DefaultAgent.ID
                    $updateObject.DefaultAgentPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("DefaultAgentPropertiesSpecified") -and ($updateObject.DefaultAgentPropertiesSpecified -ne $DefaultAgentPropertiesSpecified)) {
                    $updateObject.DefaultAgentPropertiesSpecified = $DefaultAgentPropertiesSpecified.ToBool()
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("ErrorNotifyEmailFromAddress") -and ($updateObject.ErrorNotifyEmailFromAddress -ne $ErrorNotifyEmailFromAddress)) {
                    $updateObject.ErrorNotifyEmailFromAddress = $ErrorNotifyEmailFromAddress
                    if (-not [string]::IsNullOrEmpty($ErrorNotifyEmailFromAddress)) {
                        $updateObject.ErrorNotificationPropertiesSpecified = $true
                    }
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("ErrorNotifyEmailToAddress") -and ($updateObject.ErrorNotifyEmailToAddress -ne $ErrorNotifyEmailToAddress)) {
                    $updateObject.ErrorNotifyEmailToAddress = $ErrorNotifyEmailToAddress
                    if (-not [string]::IsNullOrEmpty($ErrorNotifyEmailToAddress)) {
                        $updateObject.ErrorNotificationPropertiesSpecified = $true
                    }
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("DisableOnFailure") -and ($updateObject.DisableOnFailure -ne $DisableOnFailure.ToBool())) {
                    $updateObject.DisableOnFailure = $DisableOnFailure.ToBool()
                    $updateObject.ErrorNotificationPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("ResumeFromFailure") -and ($updateObject.ResumeFromFailure -ne $ResumeFromFailure.ToBool())) {
                    $updateObject.ResumeFromFailure = $ResumeFromFailure.ToBool()
                    $updateObject.ErrorNotificationPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("ErrorNotificationPropertiesSpecified") -and ($updateObject.ErrorNotificationPropertiesSpecified -ne $ErrorNotificationPropertiesSpecified.ToBool())) {
                    $updateObject.ErrorNotificationPropertiesSpecified = $ErrorNotificationPropertiesSpecified.ToBool()
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("Timeout") -and ($updateObject.Timeout -ne $Timeout)) {
                    $updateObject.Timeout = $Timeout
                    $updateObject.TimeoutEnabled = $true
                    $updateObject.TimeoutPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("TimeoutUnit") -and ($updateObject.TimeoutUnit -ne $TimeoutUnit)) {
                    $updateObject.TimeoutUnit = $TimeoutUnit
                    $updateObject.TimeoutEnabled = $true
                    $updateObject.TimeoutPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("TimeoutEnabled") -and ($updateObject.TimeoutEnabled -ne $TimeoutEnabled.ToBool())) {
                    $updateObject.TimeoutEnabled = $TimeoutEnabled.ToBool()
                    $updateObject.TimeoutPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("TimeoutPropertiesSpecified") -and ($updateObject.TimeoutPropertiesSpecified -ne $TimeoutPropertiesSpecified.ToBool())) {
                    $updateObject.TimeoutPropertiesSpecified = $TimeoutPropertiesSpecified.ToBool()
                    $shouldUpdate = $true
                }
                if ($shouldUpdate) {
                    $splat = @{
                        Resource = "workflows/$($obj.ParentID)/properties/update"
                        RestMethod = "Post"
                        Body = $updateObject.ToJson()
                        Connection = $updateObject.ConnectionAlias
                    }
                    if ($PSCmdlet.ShouldProcess($connection.Name, "Modifying $($obj.Type) for $($parent.Type): $(Join-Path -Path $parent.Path -ChildPath $parent.Name)")) {
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
