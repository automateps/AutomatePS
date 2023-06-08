function Get-AMFolderRoot {
    <#
        .SYNOPSIS
            Gets Automate root folders.

        .DESCRIPTION
            Get-AMFolderRoot returns a list of root folders and their IDs.

        .PARAMETER Type
            The type of root folder to return.

        .PARAMETER FilterSet
            The parameters to filter the search on.  Supply hashtable(s) with the following properties: Property, Operator, Value.
            Valid values for the Operator are: =, !=, <, >, contains (default - no need to supply Operator when using 'contains')

        .PARAMETER FilterSetMode
            If multiple filter sets are provided, FilterSetMode determines if the filter sets should be evaluated with an AND or an OR

        .PARAMETER Connection
            The Automate management server.

        .EXAMPLE
            # Get the default system agent
            Get-AMFolderRoot -Type Task

        .EXAMPLE
            # Get workflows contained in the root of \WORKFLOWS
            Get-AMFolderRoot -Type Workflow | Get-AMWorkflow

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMFolderRoot.md
    #>
    [CmdletBinding()]
    [OutputType([AMFolderv10],[AMFolderv11])]
    param (
        [ValidateSet("AgentGroup","Condition","Process","ProcessAgent","Task","TaskAgent","User","UserGroup","Workflow")]
        [string]$Type,

        [ValidateNotNull()]
        [Hashtable[]]$FilterSet = @(),

        [ValidateSet("And","Or")]
        [string]$FilterSetMode = "And",

        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter([AMConnectionCompleter])]
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
                10             { $result = [AMFolderv10]::new($c.Alias) }
                {$_ -in 11,22} { $result = [AMFolderv11]::new($c.Alias) }
                default        { throw "Unsupported server major version: $_!" }
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
