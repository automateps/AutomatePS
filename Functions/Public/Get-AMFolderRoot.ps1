function Get-AMFolderRoot {
    <#
        .SYNOPSIS
            Gets AutoMate Enterprise root folders.

        .DESCRIPTION
            Get-AMFolderRoot returns a list of root folders and their IDs.

        .PARAMETER Type
            The type of root folder to return.

        .PARAMETER Connection
            The AutoMate Enterprise management server.

        .EXAMPLE
            # Get the default system agent
            Get-AMFolderRoot -Type Task

        .EXAMPLE
            # Get workflows contained in the root of \WORKFLOWS
            Get-AMFolderRoot -Type Workflow | Get-AMWorkflow

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 01/28/2019

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param (
        [ValidateSet("AgentGroup","Condition","Process","ProcessAgent","Task","TaskAgent","User","UserGroup","Workflow")]
        [string]$Type,

        [ValidateNotNull()]
        [Hashtable[]]$FilterSet = @(),

        [ValidateSet("And","Or")]
        [string]$FilterSetMode = "And",

        [ValidateNotNullOrEmpty()]
        $Connection
    )
    if ($PSBoundParameters.ContainsKey("Connection")) {
        $Connection = Get-AMConnection -Connection $Connection
    } else {
        $Connection = Get-AMConnection
    }

    if ($PSBoundParameters.ContainsKey("Type")) {
        $Types = @($Type)
    } else {
        $Types = @("AgentGroup","Condition","Process","ProcessAgent","Task","TaskAgent","User","UserGroup","Workflow")
    }

    foreach ($Type in $Types) {
        foreach ($c in $Connection) {
            switch ($c.Version.Major) {
                10      { $result = [AMFolderv10]::new($c.Alias) }
                11      { $result = [AMFolderv11]::new($c.Alias) }
                default { throw "Unsupported server major version: $_!" }
            }
            $result.ID   = ([AMTypeDictionary]::$Type).RootFolderID
            $result.Name = ([AMTypeDictionary]::$Type).RootFolderName
            $result.Path = ([AMTypeDictionary]::$Type).RootFolderPath
            $result.Type = [AMConstructType]::Folder
            $result.CreatedOn   = (New-Object DateTime 1900, 1, 1, 0, 0, 0, ([DateTimeKind]::Utc))
            $result.ModifiedOn  = (New-Object DateTime 1900, 1, 1, 0, 0, 0, ([DateTimeKind]::Utc))
            $result.VersionDate = (New-Object DateTime 1900, 1, 1, 0, 0, 0, ([DateTimeKind]::Utc))
            $result | Invoke-AMFilterSet -FilterSet $FilterSet -FilterSetMode $FilterSetMode
        }
    }
}