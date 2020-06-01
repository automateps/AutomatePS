---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS
schema: 2.0.0
---

# Get-AMExecutionEvent

## SYNOPSIS
Gets Automate execution events.

## SYNTAX

### All (Default)
```
Get-AMExecutionEvent [-StartDate <DateTime>] [-EndDate <DateTime>] [-FilterSet <Hashtable[]>]
 [-FilterSetMode <String>] [-SortProperty <String[]>] [-SortDescending] [-Connection <Object>]
 [<CommonParameters>]
```

### ByPipeline
```
Get-AMExecutionEvent [[-InputObject] <Object>] [-StartDate <DateTime>] [-EndDate <DateTime>]
 [-FilterSet <Hashtable[]>] [-FilterSetMode <String>] [-SortProperty <String[]>] [-SortDescending]
 [-Connection <Object>] [<CommonParameters>]
```

## DESCRIPTION
Get-AMExecutionEvent gets execution events for workflows and tasks.

## EXAMPLES

### EXAMPLE 1
```
# Get events for workflow "My Workflow"
Get-AMWorkflow "My Workflow" | Get-AMExecutionEvent
```

### EXAMPLE 2
```
# Get events using filter sets
Get-AMExecutionEvent -Connection AMprd -FilterSet @{Property = 'ResultText'; Operator = 'contains'; Value = 'Agent01'}
```

## PARAMETERS

### -InputObject
The object(s) to retrieve execution events for.

```yaml
Type: Object
Parameter Sets: ByPipeline
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -StartDate
The first date of events to retrieve (Default: 1 hour ago).

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-Date).AddHours(-1)
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
The last date of events to retrieve (Default: now).

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-Date)
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
Default value: @("StartDateTime","EndDateTime")
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

### Execution events for the following objects can be retrieved by this function:
### Workflow
### Task
### Condition
### Process
### TaskAgent
### ProcessAgent
## OUTPUTS

### ExecutionEvent
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS](https://github.com/AutomatePS/AutomatePS)

