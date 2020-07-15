---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMInstance.md
schema: 2.0.0
---

# Get-AMInstance

## SYNOPSIS
Gets Automate workflow and task instances.

## SYNTAX

### All (Default)
```
Get-AMInstance [-StartDate <DateTime>] [-EndDate <DateTime>] [-Status <AMInstanceStatus>]
 [-FilterSet <Hashtable[]>] [-FilterSetMode <String>] [-IncludeRelative] [-SortProperty <String[]>]
 [-SortDescending] [-Connection <Object>] [<CommonParameters>]
```

### ByPipeline
```
Get-AMInstance [-InputObject <Object>] [-StartDate <DateTime>] [-EndDate <DateTime>]
 [-Status <AMInstanceStatus>] [-FilterSet <Hashtable[]>] [-FilterSetMode <String>] [-IncludeRelative]
 [-SortProperty <String[]>] [-SortDescending] [-Connection <Object>] [<CommonParameters>]
```

### ByID
```
Get-AMInstance [[-ID] <String>] [-StartDate <DateTime>] [-EndDate <DateTime>] [-Status <AMInstanceStatus>]
 [-FilterSet <Hashtable[]>] [-FilterSetMode <String>] [-IncludeRelative] [-SortProperty <String[]>]
 [-SortDescending] [-Connection <Object>] [<CommonParameters>]
```

### ByTransactionID
```
Get-AMInstance [-TransactionID <String>] [-StartDate <DateTime>] [-EndDate <DateTime>]
 [-Status <AMInstanceStatus>] [-FilterSet <Hashtable[]>] [-FilterSetMode <String>] [-IncludeRelative]
 [-SortProperty <String[]>] [-SortDescending] [-Connection <Object>] [<CommonParameters>]
```

## DESCRIPTION
Get-AMInstance gets instance objects from Automate. 
Get-AMInstance can receive items on the pipeline and return related objects.

## EXAMPLES

### EXAMPLE 1
```
# Get currently running instances
Get-AMInstance -Status Running
```

### EXAMPLE 2
```
# Get failed instances of workflow "My Workflow"
Get-AMWorkflow "My Workflow" | Get-AMInstance -Status Failed
```

### EXAMPLE 3
```
# Get instances using filter sets
Get-AMInstance -FilterSet @{ Property = "ResultText"; Operator = "contains"; Value = "FTP Workflow"}
```

## PARAMETERS

### -InputObject
The object(s) to use in search for instances.

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

### -ID
The ID of the instance.

```yaml
Type: String
Parameter Sets: ByID
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TransactionID
The transaction ID of the instance.

```yaml
Type: String
Parameter Sets: ByTransactionID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartDate
The first date of events to retrieve (Default: 1 day ago).

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-Date).AddDays(-1)
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

### -Status
The status of the instance:
    All
    Completed
    Running
    Success
    Failed
    Stopped
    Paused
    Aborted
    Queued
    ResumedFromFailure

```yaml
Type: AMInstanceStatus
Parameter Sets: (All)
Aliases:
Accepted values: Success, Failed, Aborted, Stopped, TimedOut, Paused, Queued, Running, ResumedFromFailure, Completed, All

Required: False
Position: Named
Default value: All
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

### -IncludeRelative
If instance is searched for using the -ID parameter, or when a workflow, task or process is piped in, related instances are also returned.

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

### -SortProperty
The object property to sort results on. 
Do not use ConnectionAlias, since it is a custom property added by this module, and not exposed in the API.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: StartDateTime
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

### Instances of the following objects can be retrieved by this function:
### Workflow
### Task
### Folder
### TaskAgent
### ProcessAgent
## OUTPUTS

### Instance
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMInstance.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMInstance.md)

