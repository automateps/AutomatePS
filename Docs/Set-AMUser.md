---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMUser.md
schema: 2.0.0
---

# Set-AMUser

## SYNOPSIS
Sets properties of an Automate user.

## SYNTAX

### AutomateAuth (Default)
```
Set-AMUser -InputObject <Object> [-Password <SecureString>] [-ForceReset] [-Notes <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ADAuth
```
Set-AMUser -InputObject <Object> [-Domain <String>] [-UseSecureConnection] [-Notes <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Set-AMUser can change properties of a user object.

## EXAMPLES

### EXAMPLE 1
```
# Change password for a user that authenticates against Automate
Get-AMUser -Name John | Set-AMUser -Password (Read-Host -Prompt "Enter password" -AsSecureString)
```

## PARAMETERS

### -InputObject
The object to modify.

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

### -Password
The password for the user.

```yaml
Type: SecureString
Parameter Sets: AutomateAuth
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Domain
The domain the user will authenticate against if running Automate version 23.1 or later. 
On earlier versions specifying this parameter will enable AD authentication, but the domain passed in is ignored and the machine domain is used instead.

```yaml
Type: String
Parameter Sets: ADAuth
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ForceReset
Force the user to reset their password on login.

```yaml
Type: SwitchParameter
Parameter Sets: AutomateAuth
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseSecureConnection
Use encryption when authenticating against Active Directory.

```yaml
Type: SwitchParameter
Parameter Sets: ADAuth
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Notes
The new notes to set on the object.

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

## OUTPUTS

## NOTES
The API requires that the password be passed in on every update call. 
Therefore, it is required to either specify the -Password parameter or -UseActiveDirectory whenever calling this function, even if only updating the Notes property for the user.

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMUser.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMUser.md)

