---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS
schema: 2.0.0
---

# Remove-AMUserGroupMember

## SYNOPSIS
Removes users from an Automate user group.

## SYNTAX

```
Remove-AMUserGroupMember -InputObject <Object> [-User] <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Remove-AMUserGroupMember can remove users from a user group.

## EXAMPLES

### EXAMPLE 1
```
# Remove all users from a user group
Get-AMUserGroup "All Users" | Remove-AMUserGroupMember -User *
```

### EXAMPLE 2
```
# Remove a user from a user group (using user object)
Get-AMUserGroup | Remove-AMUserGroupMember -User (Get-AMUser "John")
```

## PARAMETERS

### -InputObject
The user group to modify.

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

### -User
The users(s) to remove from the user group.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### The following Automate object types can be modified by this function:
### UserGroup
## OUTPUTS

### None
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS](https://github.com/AutomatePS/AutomatePS)

