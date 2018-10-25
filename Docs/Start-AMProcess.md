---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# Start-AMProcess

## SYNOPSIS
Starts AutoMate Enterprise processes.

## SYNTAX

### Agent
```
Start-AMProcess -InputObject <Object> [-Agent <Object>] [<CommonParameters>]
```

### AgentGroup
```
Start-AMProcess -InputObject <Object> [-AgentGroup <Object>] [<CommonParameters>]
```

## DESCRIPTION
Start-AMProcess starts processes.

## EXAMPLES

### EXAMPLE 1
```
# Starts process "My Process" on agent "agent01"
```

Get-AMProcess "My Process" | Start-AMProcess -Agent "agent01"

## PARAMETERS

### -InputObject
The processes to start.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Agent
The agent to run the process on.

```yaml
Type: Object
Parameter Sets: Agent
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AgentGroup
The agent group to run the process on.

```yaml
Type: Object
Parameter Sets: AgentGroup
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Processes can be supplied on the pipeline to this function.
## OUTPUTS

### System.Object[]
## NOTES
Author(s):     : David Seibel
Contributor(s) :
Date Created   : 07/26/2018
Date Modified  : 10/19/2018

## RELATED LINKS

[https://github.com/davidseibel/AutoMatePS](https://github.com/davidseibel/AutoMatePS)

