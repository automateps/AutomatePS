---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# Find-AMObject

## SYNOPSIS
Finds objects in AutoMate Enterprise.

## SYNTAX

```
Find-AMObject [-Pattern] <String> [-Regex] [-Type <String[]>] [-SearchDepth <Int32>] [-Connection <Object>]
 [<CommonParameters>]
```

## DESCRIPTION
Find-AMObject searches AutoMate Enterprise for objects based on a search query.

## EXAMPLES

### EXAMPLE 1
```
# Find all tasks that have FTP activities
```

Find-AMObject -Pattern "AMFTP" -Type Task

## PARAMETERS

### -Pattern
The pattern to use when searching. 
Regular expressions are supported.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Regex
Specify if the -Pattern parameter is a regular expression. 
Otherwise, normal wildcards are used.

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

### -Type
The object type(s) to perform search against.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: @("Workflow","Task","Condition","Process","TaskAgent","ProcessAgent","AgentGroup","User","UserGroup")
Accept pipeline input: False
Accept wildcard characters: False
```

### -SearchDepth
The number of layers (sub-objects/properties) in every object to search. 
Using a search depth that is too deep can significantly increase search time.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 3
Accept pipeline input: False
Accept wildcard characters: False
```

### -Connection
The server to perform search against.

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author(s):     : David Seibel
Contributor(s) :
Date Created   : 07/26/2018
Date Modified  : 08/08/2018

## RELATED LINKS

[https://github.com/davidseibel/AutoMatePS](https://github.com/davidseibel/AutoMatePS)

