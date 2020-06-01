---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS
schema: 2.0.0
---

# Get-AMFolder

## SYNOPSIS
Gets Automate folders.

## SYNTAX

### All (Default)
```
Get-AMFolder [[-Name] <String>] [-FilterSet <Hashtable[]>] [-FilterSetMode <String>] [-Path <String>]
 [-Recurse] [-RecurseCache <Hashtable>] [-Type <String>] [-SortProperty <String[]>] [-SortDescending]
 [-Connection <Object>] [<CommonParameters>]
```

### ByPipeline
```
Get-AMFolder [-InputObject <Object>] [[-Name] <String>] [-FilterSet <Hashtable[]>] [-FilterSetMode <String>]
 [-Path <String>] [-Parent] [-Recurse] [-RecurseCache <Hashtable>] [-Type <String>] [-SortProperty <String[]>]
 [-SortDescending] [-Connection <Object>] [<CommonParameters>]
```

### ByID
```
Get-AMFolder [[-Name] <String>] [-ID <String>] [-FilterSet <Hashtable[]>] [-FilterSetMode <String>]
 [-Path <String>] [-Recurse] [-RecurseCache <Hashtable>] [-Type <String>] [-SortProperty <String[]>]
 [-SortDescending] [-Connection <Object>] [<CommonParameters>]
```

## DESCRIPTION
Get-AMFolder gets folders objects from Automate. 
Get-AMFolder can receive items on the pipeline and return related objects.

## EXAMPLES

### EXAMPLE 1
```
# Get folder "My Folder"
Get-AMFolder "My Folder"
```

### EXAMPLE 2
```
# Get folder containing workflow "My Workflow"
Get-AMWorkflow "My Workflow" | Get-AMFolder
```

### EXAMPLE 3
```
# Get workflows in "My Folder"
Get-AMFolder "My Folder" -Type WORKFLOWS | Get-AMWorkflow
```

### EXAMPLE 4
```
# Get folder "My Folder" by path
Get-AMFolder -Path "\PROCESSES" -Name "My Folder"
```

### EXAMPLE 5
```
# Get subfolders of "My Folder"
Get-AMFolder "My Folder" -Type PROCESSES | Get-AMFolder
```

### EXAMPLE 6
```
# Get folders using filter sets
Get-AMFolder -FilterSet @{ Property = "Path"; Operator = "contains"; Value = "WORKFLOWS"}
```

## PARAMETERS

### -InputObject
The object(s) to use in search for folders.

```yaml
Type: Object
Parameter Sets: ByPipeline
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Name
The name of the folder (case sensitive). 
Wildcard characters can be escaped using the \` character. 
If using escaped wildcards, the string
must be wrapped in single quotes. 
For example: Get-AMFolder -Name '\`\[Test\`\]'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID
The ID of the folder.

```yaml
Type: String
Parameter Sets: ByID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterSet
The parameters to filter the search on. 
Supply hashtable(s) with the following properties: Property, Operator, Value.
Valid values for the Operator are: =, !=, \<, \>, contains (default - no need to supply Operator when using 'contains')

```yaml
Type: Hashtable[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: @()
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterSetMode
If multiple filter sets are provided, FilterSetMode determines if the filter sets should be evaluated with an AND or an OR

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: And
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
The path containing the folder.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Parent
Get folders that contain the specified folders. 
This parameter is only used when a folder is piped in.

```yaml
Type: SwitchParameter
Parameter Sets: ByPipeline
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Recurse
If specified, searches recursively for subfolders.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RecurseCache
-RecurseCache is a private parameter used only within this function, and should not be used externally.
 This parameter allows the folder cache to be passed to subsequent, recursive calls

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: @{}
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
The folder type: AGENTGROUPS, CONDITIONS, PROCESSAGENTS, PROCESSES, TASKAGENTS, TASKS, USERGROUPS, USERS, WORKFLOWS

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SortProperty
The object property to sort results on. 
Do not use ConnectionAlias, since it is a custom property added by this module, and not exposed in the API.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: @("Path","Name")
Accept pipeline input: False
Accept wildcard characters: False
```

### -SortDescending
If specified, this will sort the output on the specified SortProperty in descending order. 
Otherwise, ascending order is assumed.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Connection
The Automate management server.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Agents related to the following objects can be retrieved by this function:
### Folder
### Workflow
### Task
### Process
### Condition
### Agent
### AgentGroup
### User
### UserGroup
## OUTPUTS

### Folder
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS](https://github.com/AutomatePS/AutomatePS)

