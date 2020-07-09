---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS
schema: 2.0.0
---

# Get-AMWorkflow

## SYNOPSIS
Gets Automate workflows.

## SYNTAX

### All (Default)
```
Get-AMWorkflow [[-Name] <String>] [-FilterSet <Hashtable[]>] [-FilterSetMode <String>]
 [-SortProperty <String[]>] [-SortDescending] [-Connection <Object>] [<CommonParameters>]
```

### ByPipeline
```
Get-AMWorkflow [-InputObject <Object>] [[-Name] <String>] [-FilterSet <Hashtable[]>] [-FilterSetMode <String>]
 [-Parent] [-SortProperty <String[]>] [-SortDescending] [-Connection <Object>] [<CommonParameters>]
```

### ByID
```
Get-AMWorkflow [[-Name] <String>] [-ID <String>] [-FilterSet <Hashtable[]>] [-FilterSetMode <String>]
 [-SortProperty <String[]>] [-SortDescending] [-Connection <Object>] [<CommonParameters>]
```

## DESCRIPTION
Get-AMWorkflow gets workflow objects from Automate. 
Get-AMWorkflow can receive items on the pipeline and return related objects.

## EXAMPLES

### EXAMPLE 1
```
# Get workflow "My Workflow"
Get-AMWorkflow "My Workflow"
```

### EXAMPLE 2
```
# Get sub-workflows in workflow "My Workflow"
Get-AMWorkflow "My Workflow" | Get-AMWorkflow
```

### EXAMPLE 3
```
# Get workflows in folder "My Folder"
Get-AMFolder "My Folder" -Type TASKS | Get-AMWorkflow
```

### EXAMPLE 4
```
# Get workflows using a filter set
Get-AMWorkflow -FilterSet @{ Property = "Name"; Value = "FTP"}
```

### EXAMPLE 5
```
# Get workflows that have started in the last hour
Get-AMWorkflow -FilterSet @{Property = "StartedOn"; Operator = ">"; Value = (Get-Date).AddHours(-1)}
```

## PARAMETERS

### -InputObject
The object(s) use in search for workflows.

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
The name of the workflow (case sensitive). 
Wildcard characters can be escaped using the \` character. 
If using escaped wildcards, the string
must be wrapped in single quotes. 
For example: Get-AMWorkflow -Name '\`\[Test\`\]'

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
The ID of the workflow.

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

### -Parent
Get workflows that contain the specified workflow. 
This parameter is only used when a workflow is piped in.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Workflows related to the following objects can be retrieved by this function:
### Workflow
### Task
### Process
### Condition
### Folder
### Agent
### AgentGroup
## OUTPUTS

### Workflow
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS](https://github.com/AutomatePS/AutomatePS)

