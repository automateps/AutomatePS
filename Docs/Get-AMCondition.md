---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMCondition.md
schema: 2.0.0
---

# Get-AMCondition

## SYNOPSIS
Gets Automate conditions.

## SYNTAX

### All (Default)
```
Get-AMCondition [[-Name] <String>] [-FilterSet <Hashtable[]>] [-FilterSetMode <String>] [-Type <AMTriggerType>]
 [-SortProperty <String[]>] [-SortDescending] [-Connection <Object>] [<CommonParameters>]
```

### ByPipeline
```
Get-AMCondition [-InputObject <Object>] [[-Name] <String>] [-FilterSet <Hashtable[]>] [-FilterSetMode <String>]
 [-Type <AMTriggerType>] [-SortProperty <String[]>] [-SortDescending] [-Connection <Object>]
 [<CommonParameters>]
```

### ByID
```
Get-AMCondition [[-Name] <String>] [-ID <String>] [-FilterSet <Hashtable[]>] [-FilterSetMode <String>]
 [-Type <AMTriggerType>] [-SortProperty <String[]>] [-SortDescending] [-Connection <Object>]
 [<CommonParameters>]
```

## DESCRIPTION
Get-AMCondition gets condition objects from Automate. 
Get-AMCondition can receive items on the pipeline and return related objects.

## EXAMPLES

### EXAMPLE 1
```
Get-AMCondition "My Condition"
Get-AMWorkflow "My Workflow" | Get-AMCondition
```

### EXAMPLE 2
```
# Get conditions that have "Daily" in the name and are not enabled, using filter sets
Get-AMCondition -FilterSet @{ Property = "Name"; Operator = "contains"; Value = "Daily"},@{ Property = "Enabled"; Operator = "="; Value = "false"}
```

## PARAMETERS

### -InputObject
The object(s) use in search for conditions.

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
The name of the condition (case sensitive). 
Wildcard characters can be escaped using the \` character. 
If using escaped wildcards, the string
must be wrapped in single quotes. 
For example: Get-AMCondition -Name '\`\[Test\`\]'

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
The ID of the condition.

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

### -Type
The condition type:
    All
    Logon
    Window
    Schedule
    Keyboard
    Idle
    Performance
    EventLog
    FileSystem
    Process
    Service
    SNMPTrap
    WMI
    Database
    SharePoint

```yaml
Type: AMTriggerType
Parameter Sets: (All)
Aliases:
Accepted values: Undefined, Logon, Window, Schedule, Keyboard, Idle, Performance, EventLog, FileSystem, Process, Service, SNMPTrap, WMI, Time, Database, SharePoint, Email, All

Required: False
Position: Named
Default value: All
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

### Conditions related to the following objects can be retrieved by this function:
### Workflow
### Agent
### Folder
## OUTPUTS

### Condition
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMCondition.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMCondition.md)

