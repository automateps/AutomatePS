---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# Get-AMFolderRoot

## SYNOPSIS
Gets AutoMate Enterprise root folders.

## SYNTAX

```
Get-AMFolderRoot [[-Type] <String>] [[-Connection] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Get-AMFolderRoot returns a list of root folders and their IDs.

## EXAMPLES

### EXAMPLE 1
```
# Get the default system agent
```

Get-AMFolderRoot -Type Task

### EXAMPLE 2
```
# Get workflows contained in the root of \WORKFLOWS
```

Get-AMFolderRoot -Type Workflow | Get-AMWorkflow

## PARAMETERS

### -Type
The type of root folder to return.

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

### -Connection
The AutoMate Enterprise management server.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Object[]

## NOTES
Author(s):     : David Seibel
Contributor(s) :
Date Created   : 07/26/2018
Date Modified  : 08/08/2018

## RELATED LINKS

[https://github.com/davidseibel/AutoMatePS](https://github.com/davidseibel/AutoMatePS)

