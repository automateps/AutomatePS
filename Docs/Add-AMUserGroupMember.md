---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS
schema: 2.0.0
---

# Add-AMUserGroupMember

## SYNOPSIS
Adds users to an AutoMate Enterprise user group.

## SYNTAX

```
Add-AMUserGroupMember -InputObject <Object> [-User] <Object> [<CommonParameters>]
```

## DESCRIPTION
Add-AMUserGroupMember can add users to a user group.

## EXAMPLES

### EXAMPLE 1
```
# Add all users to a user group
```

Get-AMUserGroup "All Users" | Add-AMUserGroupMember -User *

### EXAMPLE 2
```
# Add a user to a user group (using user object)
```

Get-AMUserGroup | Add-AMUserGroupMember -User (Get-AMUser "John")

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
The user name(s), or object(s) to add to the user group.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### The following AutoMate object types can be modified by this function:
### UserGroup
## OUTPUTS

### None
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS](https://github.com/AutomatePS/AutomatePS)

