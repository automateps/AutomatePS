---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMMetric.md
schema: 2.0.0
---

# Get-AMMetric

## SYNOPSIS
Gets metrics from Automate.

## SYNTAX

```
Get-AMMetric [[-Type] <Object>] [[-Folder] <Object>] [[-StartDate] <DateTime>] [[-EndDate] <DateTime>]
 [[-IntervalSeconds] <Int32>] [[-DeviationPercentage] <Int32>] [[-DeviationDirection] <String>]
 [[-Connection] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Get-AMMetric gets metrics from Automate.

## EXAMPLES

### EXAMPLE 1
```
# Get completed metrics over a 24 hour interval for the past week
Get-AMMetric -Type Completed -Interval 86400 -StartDate (Get-Date).AddDays(-7)
```

## PARAMETERS

### -Type
The type of metrics to query: Running, Completed, Queued, Deviations.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Running
Accept pipeline input: False
Accept wildcard characters: False
```

### -Folder
The folder containing objects to retrieve metrics for.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartDate
The first date of metrics to retrieve (Default: 1 day ago).

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: (Get-Date).AddDays(-1)
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
The last date of metrics to retrieve (Default: now).

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: (Get-Date)
Accept pipeline input: False
Accept wildcard characters: False
```

### -IntervalSeconds
The interval to use for Running, Queued and Completed metrics.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 3600
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviationPercentage
The deviation percentage when querying deviation metrics.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviationDirection
The deviation direction when querying deviation metrics.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
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
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Folder
## OUTPUTS

### Metrics
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMMetric.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMMetric.md)

