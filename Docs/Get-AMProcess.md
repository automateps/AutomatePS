---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMProcess.md
schema: 2.0.0
---

# Get-AMProcess

## SYNOPSIS
Gets Automate processes.

## SYNTAX

### All (Default)
```
Get-AMProcess [[-Name] <String>] [-FilterSet <Hashtable[]>] [-FilterSetMode <String>]
 [-SortProperty <String[]>] [-SortDescending] [-Connection <Object>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### ByPipeline
```
Get-AMProcess [-InputObject <Object>] [[-Name] <String>] [-FilterSet <Hashtable[]>] [-FilterSetMode <String>]
 [-SortProperty <String[]>] [-SortDescending] [-Connection <Object>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### ByID
```
Get-AMProcess [[-Name] <String>] [-ID <String>] [-FilterSet <Hashtable[]>] [-FilterSetMode <String>]
 [-SortProperty <String[]>] [-SortDescending] [-Connection <Object>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Get-AMProccess gets process objects from Automate. 
Get-AMProcess can receive items on the pipeline and return related objects.

## EXAMPLES

### EXAMPLE 1
```
# Get process "My Process"
Get-AMProcess "My Process"
```

### EXAMPLE 2
```
# Get processes in folder "My Folder"
Get-AMFolder "My Folder" | Get-AMProcess
```

### EXAMPLE 3
```
# Get processes in workflow "My Workflow"
Get-AMWorkflow "My Workflow" | Get-AMProcess
```

### EXAMPLE 4
```
# Get processes using filter sets
Get-AMProcess -FilterSet @{ Property = "Name"; Operator = "contains"; Value = "CMD"},@{ Property = "Enabled"; Operator = "="; Value = "false"}
```

## PARAMETERS

### -InputObject
The object(s) to use in search for processes.

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
The name of the process (case sensitive). 
Wildcard characters can be escaped using the \` character. 
If using escaped wildcards, the string
must be wrapped in single quotes. 
For example: Get-AMProcess -Name '\`\[Test\`\]'

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
The ID of the process.

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

### -SortProperty
The object property to sort results on. 
Do not use ConnectionAlias, since it is a custom property added by this module, and not exposed in the API.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Name
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

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Processes related to the following objects can be retrieved by this function:
### Workflow
### Folder
## OUTPUTS

### Process
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMProcess.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMProcess.md)

