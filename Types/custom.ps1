class AMConnection {
    [string]$Name
    [string]$Alias
    [string]$Server
    [int]$Port
    [System.Management.Automation.PSCredential]$Credential
    [Version]$Version
    AMConnection([string]$Server, [int]$Port, [System.Management.Automation.PSCredential]$Credential) {
        $this.Server = $Server
        $this.Port = $Port
        $this.Credential = $Credential
        $this.Name = "$($Server):$($Port)"
        $this.Alias = "$($Server):$($Port)"
    }
    AMConnection([string]$Alias, [string]$Server, [int]$Port, [System.Management.Automation.PSCredential]$Credential) {
        $this.Server = $Server
        $this.Port = $Port
        $this.Credential = $Credential
        $this.Name = "$($Server):$($Port)"
        $this.Alias = $Alias
    }
    [bool]Authenticate() {
        $success = $false
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $this.Credential.UserName,$this.Credential.GetNetworkCredential().Password)))
        $headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}
        try {
            $authTest = Invoke-RestMethod "http://$($this.Server):$($this.Port)/BPAManagement/users/authenticate" -Method Get -Headers $headers -UseBasicParsing -ErrorAction Stop
        } catch {
            throw "Failed to authenticate to server $($this.Server):$($this.Port) as $($this.Credential.UserName)!"
        }
        if ($authTest.Data -eq "success") {
            $success = $true
            $serverInfo = Invoke-RestMethod "http://$($this.Server):$($this.Port)/BPAManagement/info/get" -Method Get -Headers $headers -UseBasicParsing
            $this.Version = [Version]$serverInfo.Data.Version
        } else {
            throw "Failed to authenticate to server $($this.Server):$($this.Port) as $($this.Credential.UserName)!"
        }
        return $success
    }
}

class AMMatchedProperty {
    $Property
    $Value
    $Result
    AMMatchedProperty($Property,$Value) {
        $this.Property = $Property
        $this.Value = $Value
        $this.Result = "$Property = $Value"
    }
}

class AMRepositoryMapDetail {
    $SourceConnection
    $SourceID
    $SourceName
    $SourceType
    $DestinationConnection
    $DestinationID
    $DestinationName
    $DestinationType
    AMRepositoryMapDetail($Mapping) {
        $this.SourceConnection = $Mapping.SourceConnection
        $this.SourceID = $Mapping.SourceID
        $this.SourceName = $Mapping.SourceName
        $this.SourceType = $Mapping.SourceType
        $this.DestinationConnection = $Mapping.DestinationConnection
        $this.DestinationID = $Mapping.DestinationID
        $this.DestinationName = $Mapping.DestinationName
        $this.DestinationType = $Mapping.DestinationType
    }
    AMRepositoryMapDetail($Source, $Destination) {
        $this.SourceConnection = $Source.ConnectionAlias
        $this.SourceID = $Source.ID
        $this.SourceName = $Source.Name
        $this.SourceType = $Source.Type
        $this.DestinationConnection = $Destination.ConnectionAlias
        $this.DestinationID = $Destination.ID
        $this.DestinationName = $Destination.Name
        $this.DestinationType = $Destination.Type
    }
}

# AutoMate Enterprise creates some system level objects that have a static ID defined (not stored in the DB).
# These should remain the same across installations on different servers.
class AMSystemAgent {
    static [string] $Condition = "{2C046FDD-97A9-4a79-B34F-0C7A97E9CE69}"
    static [string] $Default   = "{CC3AD52F-C1DC-4d24-B6BE-32467159C86C}"
    static [string] $Previous  = "{AC557F76-ABFF-4860-9ED4-259CC8758C76}"
    static [string] $Triggered = "{C1E0C335-CF54-42f0-AA90-BB2854E37E8A}"
    static [string] $Variable  = "{EEF25965-316C-4a47-98F7-8D113F76333D}"
    [string]GetByID($ID) {
        $result = $null
        switch ($ID) {
            "{2C046FDD-97A9-4a79-B34F-0C7A97E9CE69}" { $result = "Condition" }
            "{CC3AD52F-C1DC-4d24-B6BE-32467159C86C}" { $result = "Default" }
            "{AC557F76-ABFF-4860-9ED4-259CC8758C76}" { $result = "Previous" }
            "{C1E0C335-CF54-42f0-AA90-BB2854E37E8A}" { $result = "Triggered" }
            "{EEF25965-316C-4a47-98F7-8D113F76333D}" { $result = "Variable" }
        }
        return $result
    }
}

class AMTypeDictionary {
    static [PSCustomObject]$AgentGroup   = [PSCustomObject]@{ RestResource = "agent_groups"; RootFolderPath = "\" ; RootFolderName = "AGENTGROUPS"  ; RootFolderID = "{65B26C46-C286-45d8-88AE-2E16774F0DAB}" }
    static [PSCustomObject]$Agent        = [PSCustomObject]@{ RestResource = "agents"      ; RootFolderPath = "\" ; RootFolderName = "TASKAGENTS"   ; RootFolderID = "{A5B6AF52-5DAC-45a0-8B26-602E3E3BBC59}" }  # Only used for agent creation to look up the rest resource
    static [PSCustomObject]$Condition    = [PSCustomObject]@{ RestResource = "conditions"  ; RootFolderPath = "\" ; RootFolderName = "CONDITIONS"   ; RootFolderID = "{5B00CA35-3EFB-41ea-95C0-D8B50B9BFA9F}" }
    static [PSCustomObject]$Process      = [PSCustomObject]@{ RestResource = "processes"   ; RootFolderPath = "\" ; RootFolderName = "PROCESSES"    ; RootFolderID = "{8E19BEB0-9625-4810-AF6E-5EAD7069E83C}" }
    static [PSCustomObject]$ProcessAgent = [PSCustomObject]@{ RestResource = "agents"      ; RootFolderPath = "\" ; RootFolderName = "PROCESSAGENTS"; RootFolderID = "{84334DCF-3643-4988-83CA-79019097AA7D}" }
    static [PSCustomObject]$Task         = [PSCustomObject]@{ RestResource = "tasks"       ; RootFolderPath = "\" ; RootFolderName = "TASKS"        ; RootFolderID = "{E893A7FD-2758-4315-9181-93F8728332E5}" }
    static [PSCustomObject]$TaskAgent    = [PSCustomObject]@{ RestResource = "agents"      ; RootFolderPath = "\" ; RootFolderName = "TASKAGENTS"   ; RootFolderID = "{A5B6AF52-5DAC-45a0-8B26-602E3E3BBC59}" }
    static [PSCustomObject]$User         = [PSCustomObject]@{ RestResource = "users"       ; RootFolderPath = "\" ; RootFolderName = "USERS"        ; RootFolderID = "{CF0A8EFD-08A7-47b1-9A2A-335B743D284A}" }
    static [PSCustomObject]$UserGroup    = [PSCustomObject]@{ RestResource = "user_groups" ; RootFolderPath = "\" ; RootFolderName = "USERGROUPS"   ; RootFolderID = "{E6B6C664-3B87-43a1-AD19-4B60191B8F3C}" }
    static [PSCustomObject]$Workflow     = [PSCustomObject]@{ RestResource = "workflows"   ; RootFolderPath = "\" ; RootFolderName = "WORKFLOWS"    ; RootFolderID = "{589D12C2-1282-4466-B7E3-FE547509AF31}" }
    static [PSCustomObject]$Folder       = [PSCustomObject]@{ RestResource = "folders"     ; RootFolderPath = ""  ; RootFolderName = ""             ; RootFolderID = ""                                       }
}