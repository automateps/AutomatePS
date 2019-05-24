---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS
schema: 2.0.0
---

# Get-AMCalendar

## SYNOPSIS
Gets AutoMate Enterprise calendar events.

## SYNTAX

### All (Default)
```
Get-AMCalendar [-StartDate <DateTime>] [-EndDate <DateTime>] [-Type <String>] [-FilterSet <Hashtable[]>]
 [-FilterSetMode <String>] [-SortProperty <String[]>] [-SortDescending] [-Connection <Object>]
 [<CommonParameters>]
```

### ByPipeline
```
Get-AMCalendar [[-InputObject] <Object>] [-StartDate <DateTime>] [-EndDate <DateTime>] [-Type <String>]
 [-FilterSet <Hashtable[]>] [-FilterSetMode <String>] [-SortProperty <String[]>] [-SortDescending]
 [-Connection <Object>] [<CommonParameters>]
```

## DESCRIPTION
Get-AMCalendar gets events from the calendar.

## EXAMPLES

### EXAMPLE 1
```
# Get calendar events for the next 7 days
```

Get-AMCalendar -EndDate (Get-Date).AddDays(7)

### EXAMPLE 2
```
# Get calendar events for workflow "My Workflow"
```

Get-AMWorkflow "My Workflow" | Get-AMCalendar

### EXAMPLE 3
```
# Get calendar events using filter sets
```

Get-AMCalendar -FilterSet @{Property = 'ScheduleDescription'; Operator = 'contains'; Value = 'hour(s)'}

## PARAMETERS

### -InputObject
The object(s) to search the calendar for.

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
The first date of events to retrieve (Default: now - must be equal or greater than the current time).

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

### -EndDate
The last date of events to retrieve (Default: 24 hours from now).

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-Date).AddDays(1)
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
The schedule types to retrieve:
Specific     - The schedule defines specific dates and times.
Weekly       - The schedule reoccurs on a weekly basis.
Monthly      - The schedule reoccurs on a monthly basis.
Holidays     - The schedule occurs on a holiday.
Non-Interval - ???

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
Default value: NextRunTime
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
The AutoMate Enterprise management server.

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

### Calendar events related to the following objects can be retrieved by this function:
### Workflow
### Condition
### Folder
## OUTPUTS

### Calendar
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS](https://github.com/AutomatePS/AutomatePS)

