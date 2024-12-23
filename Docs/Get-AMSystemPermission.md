---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMSystemPermission.md
schema: 2.0.0
---

# Get-AMSystemPermission

## SYNOPSIS
Gets Automate system permissions.

## SYNTAX

### All (Default)
```
Get-AMSystemPermission [-FilterSet <Hashtable[]>] [-FilterSetMode <String>] [-SortProperty <String[]>]
 [-SortDescending] [-Connection <Object>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ByPipeline
```
Get-AMSystemPermission [[-InputObject] <Object>] [-FilterSet <Hashtable[]>] [-FilterSetMode <String>]
 [-SortProperty <String[]>] [-SortDescending] [-Connection <Object>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### ByID
```
Get-AMSystemPermission [-ID <String>] [-FilterSet <Hashtable[]>] [-FilterSetMode <String>]
 [-SortProperty <String[]>] [-SortDescending] [-Connection <Object>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Get-AMSystemPermission gets system permissions.

## EXAMPLES

### EXAMPLE 1
```
# Get permissions for user "MyUsername"
Get-AMUser "MyUsername" | Get-AMSystemPermission
```

### EXAMPLE 2
```
# Get permissions using filter sets
Get-AMSystemPermission -FilterSet @{Property = 'EditDefaultPropertiesPermission'; Operator = '='; Value = 'true'}
```

## PARAMETERS

### -InputObject
The object(s) to retrieve permissions for.

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

### -ID
The ID of the system permission object.

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
Default value: GroupID
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

### Permissions for the following objects can be retrieved by this function:
### User
### UserGroup
## OUTPUTS

### SystemPermission
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMSystemPermission.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMSystemPermission.md)

