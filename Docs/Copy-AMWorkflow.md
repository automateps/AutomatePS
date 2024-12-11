---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Copy-AMWorkflow.md
schema: 2.0.0
---

# Copy-AMWorkflow

## SYNOPSIS
Copies an Automate workflow.

## SYNTAX

```
Copy-AMWorkflow [-InputObject] <Object> [[-Name] <String>] [[-Folder] <Object>] [[-ConflictAction] <String>]
 [[-IdSubstitutions] <Hashtable>] [-IgnoreServerVersionDifference] [[-Connection] <Object>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Copy-AMWorkflow can copy a workflow within a server.

## EXAMPLES

### EXAMPLE 1
```
# Copy workflow "FTP Files to Company A" to "FTP Files to Company B"
Get-AMWorkflow "FTP Files to Company A" | Copy-AMWorkflow -Name "FTP Files to Company B" -Folder (Get-AMFolder WORKFLOWS)
```

## PARAMETERS

### -InputObject
The object to copy.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Name
The new name to set on the object.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConflictAction
The action to take if a conflicting object is found on the destination server.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IdSubstitutions
A hashtable containing ID mappings between the source and destination server. 
The ID from the source server object is the key, the destination server is the value.
Use this to define mappings of agents/agent groups/folders, or repository objects where the default mapping actions taken by this workflow are not sufficient.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: @{}
Accept pipeline input: False
Accept wildcard characters: False
```

### -IgnoreServerVersionDifference
Ignore server version differences when copying between servers. 
If a task needs to be copied from the source server to the destination server, Copy-AMTask will still fail.
This could result in an incomplete migration. 
To avoid this, first use the export/import options in the Server Management Console for any tasks in the workflow(s) to be copied.

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
The server to copy the object to.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
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

### The following Automate object types can be modified by this function:
### Workflow
## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Copy-AMWorkflow.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Copy-AMWorkflow.md)

