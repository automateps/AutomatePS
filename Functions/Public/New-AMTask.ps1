function New-AMTask {
    <#
        .SYNOPSIS
            Creates a new AutoMate Enterprise task.

        .DESCRIPTION
            New-AMTask creates a new task object.

        .PARAMETER Name
            The name of the new object.

        .PARAMETER AML
            The AutoMate Markup Language (AML) to set on the object.

        .PARAMETER Notes
            The notes to set on the object.

        .PARAMETER Folder
            The folder to place the object in.

        .PARAMETER Connection
            The server to create the object on.

        .EXAMPLE
            # Create a new task
            New-AMTask -Name "Test Task"

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 08/14/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Low")]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [string]$AML = "",

        [string]$Notes = "",

        [ValidateScript({$_.Type -eq "Folder"})]
        $Folder,

        $Connection
    )

    if ($PSBoundParameters.ContainsKey("Connection")) {
        $Connection = Get-AMConnection -Connection $Connection
    } else {
        $Connection = Get-AMConnection
    }
    if (($Connection | Measure-Object).Count -gt 1) {
        throw "Multiple AutoMate Servers are connected, please specify which server to create the new task on!"
    }

    $user = Get-AMUser -Connection $Connection | Where-Object {$_.Name -ieq $Connection.Credential.UserName}
    if (-not $Folder) {
        # Place the task in the users task folder
        $Folder = $user | Get-AMFolder -Type TASKS
    }

    if ($PSBoundParameters.ContainsKey("AML")) {
        # Validate AML
        if ($AML -is [string]) {
            $convertSuccess = $false
            try {
                $xml = [xml]$AML
                $convertSuccess = $true
            } catch {
                Write-Warning "Failed to convert AML to XML, this may be normal since AML does not always conform to XML syntax.  Validation will be skipped."
            }
            if ($convertSuccess) {
                $amlVersion = [version]$xml.SelectSingleNode("//*[@TaskVersion|@TASKVERSION]").TaskVersion
                if ($amlVersion.Major -ne $Connection.Version.Major) {
                    throw "AML version ($($amlVersion.Major)) does not match server version ($($Connection.Version.Major))!"
                }
            }
        } else {
            throw "AML is not a string!"
        }
    }

    switch ($Connection.Version.Major) {
        10      { $newObject = [AMTaskv10]::new($Name, $Folder, $Connection.Alias) }
        11      { $newObject = [AMTaskv11]::new($Name, $Folder, $Connection.Alias) }
        default { throw "Unsupported server major version: $_!" }
    }
    $newObject.CreatedBy       = $user.ID
    $newObject.Notes           = $Notes
    $newObject.AML             = $AML
    $newObject | New-AMObject -Connection $Connection
    Get-AMTask -ID $newObject.ID -Connection $Connection
}
