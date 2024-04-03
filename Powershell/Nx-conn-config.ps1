#region function remediation
function start-remediation {

    $LocalAppdataPathNetExtender = "$env:LOCALAPPDATA\SonicWall\NetExtender"

    if (Test-Path $LocalAppdataPathNetExtender){
        $PathDisconnectScript = $LocalAppdataPathNetExtender + "\NxDisconnect.bat"
        if (Test-Path ($PathDisconnectScript)){
            #Check if RegKey in DisconnectionScript is set
            $ContentDisconnectionScript = (Get-Content -Path $PathDisconnectScript | Where-Object { $_.Contains('reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections" /f /v "DefaultConnectionSettings" /t REG_BINARY /d "460000000400000009000000000000000000000026000000687474703A2F2F7777772E78787878782E636F6D3A313233342F73616D706C6553637269707400000000000000000000000000000000"')}).Length
            if ($ContentDisconnectionScript -eq 0) {
             #Edit DisconnectScript
             (Get-Content $PathDisconnectScript).Replace('ECHO OFF','ECHO OFF
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections" /f /v "DefaultConnectionSettings" /t REG_BINARY /d "460000000400000009000000000000000000000026000000687474703A2F2F7777772E78787878782E636F6D3A313233342F73616D706C6553637269707400000000000000000000000000000000"') | Set-Content $PathDisconnectScript
            Write-Host("NxDisconnect.bat script has been updated.")
            Exit 0
            }
            else{
            Write-Host("NXDisconnect.bat script was already updated.")
            Exit 0
            }
        }
    }
}
#endregion

#region main script
#Detect if DisconnectionScript of SonicWallNetExtender is already modified
$LocalAppdataPathNetExtender = "$env:LOCALAPPDATA\SonicWall\NetExtender"

if (Test-Path $LocalAppdataPathNetExtender){
    $PathDisconnectScript = $LocalAppdataPathNetExtender + "\NxDisconnect.bat"

    if (Test-Path ($PathDisconnectScript)){
        #Check if RegKey in DisconnectionScript is set
        $ContentDisconnectionScript = (Get-Content -Path $PathDisconnectScript | Where-Object { $_.Contains('reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections" /f /v "DefaultConnectionSettings" /t REG_BINARY /d "460000000400000009000000000000000000000026000000687474703A2F2F7777772E78787878782E636F6D3A313233342F73616D706C6553637269707400000000000000000000000000000000"')}).Length
        if ($ContentDisconnectionScript -eq 0) {
            #Start remediation Script
            Write-Host("NXDisconnect.bat script has not yet been modified. Start remediation.")
            start-remediation
        }
        else{
            Write-Host("NXDisconnect.bat script is already updated.")
            Exit 0
        }
    }
    else{
        Write-Host("NXDisconnect.bat script not available. Start remediation Script")
        start-remediation
    }
}
#endregion