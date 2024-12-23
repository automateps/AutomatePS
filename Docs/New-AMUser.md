---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/New-AMUser.md
schema: 2.0.0
---

# New-AMUser

## SYNOPSIS
Creates a new Automate user.

## SYNTAX

### AutomateAuth (Default)
```
New-AMUser [-Name] <String> -Password <SecureString> [-ForceReset] [-Notes <String>] [-Folder <Object>]
 [-Connection <Object>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ADAuth
```
New-AMUser [-Name] <String> -Domain <String> [-UseSecureConnection] [-Notes <String>] [-Folder <Object>]
 [-Connection <Object>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
New-AMUser creates a new user object.

## EXAMPLES

### EXAMPLE 1
```
# Create new user that authenticates against Active Directory
New-AMUser -Name John -UseActiveDirectory
```

### EXAMPLE 2
```
# Create new user that authenticates against Automate (prompts for password)
New-AMUser -Name John -Password (Read-Host -Prompt "Enter password" -AsSecureString)
```

## PARAMETERS

### -Name
The name/username of the new object.

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

### -Password
The password for the user.

```yaml
Type: SecureString
Parameter Sets: AutomateAuth
Aliases:

Required: True
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

Required: True
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

### -Folder
The folder to place the object in.

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

### -Connection
The server to create the object on.

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

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/New-AMUser.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/New-AMUser.md)

