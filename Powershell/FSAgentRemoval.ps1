# Remove old versions of "FreshService Discovery Agent" from a workstation that is failing to install latest version. Run script as admin for full effect.

# Remove 2.16.0 regkeys if they exist
if (Test-Path -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{070940BC-E4CA-458C-AEE3-F4227EFE6B19}") {
    Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{070940BC-E4CA-458C-AEE3-F4227EFE6B19}" -Recurse
}
else {
    Write-host "The Specified Registry Key doesn't exists!"
}

# Remove 3.0.0 regkeys if they exist
if (Test-Path -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{F8D829C0-B7C7-4563-8C54-BE38625B7C7B}") {
    Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{F8D829C0-B7C7-4563-8C54-BE38625B7C7B}" -Recurse
}
else {
    Write-host "The Specified Registry Key doesn't exists!"
}

# Remove 3.1.0 regkeys if they exist
if (Test-Path -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{A5527CC2-73E3-4817-B195-7FA76D34AC3F}") {
    Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{A5527CC2-73E3-4817-B195-7FA76D34AC3F}" -Recurse
}
else {
    Write-host "The Specified Registry Key doesn't exists!"
}

# Remove 3.2.0 regkeys if they exist
if (Test-Path -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{2419DC21-A703-400A-AB2D-7176880F30DB}") {
    Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{2419DC21-A703-400A-AB2D-7176880F30DB}" -Recurse
}
else {
    Write-host "The Specified Registry Key doesn't exists!"
}

# Kill Discovery Agent Task
taskkill /f /fi "SERVICES eq FSDiscoveryAgent"

# Delete service if exists
sc.exe delete FSDiscoveryAgent

# Remove files/folders for Discovery
$path =  "C:\Program Files (x86)\Freshdesk"
foreach($filePath in $path)
{
    if (Test-Path $filePath) {
        Remove-Item $filePath -verbose -recurse
    } else {
        Write-Host "Path doesn't exits"
    }
}

# Remove all other related regkeys
Remove-Item -Path "Registry::HKEY_CLASSES_ROOT\Installer\Assemblies\C:|Program Files (x86)|Freshdesk|Freshservice Discovery Agent|bin|AgentInstaller.dll" -Recurse
Remove-Item -Path "Registry::HKEY_CLASSES_ROOT\Installer\Assemblies\C:|Program Files (x86)|Freshdesk|Freshservice Discovery Agent|bin|FSAgentAutoUpdate.exe" -Recurse
Remove-Item -Path "Registry::HKEY_CLASSES_ROOT\Installer\Assemblies\C:|Program Files (x86)|Freshdesk|Freshservice Discovery Agent|bin|FSAgentCrashStatusUpdater.exe" -Recurse
Remove-Item -Path "Registry::HKEY_CLASSES_ROOT\Installer\Assemblies\C:|Program Files (x86)|Freshdesk|Freshservice Discovery Agent|bin|FSAgentService.exe" -Recurse
Remove-Item -Path "Registry::HKEY_CLASSES_ROOT\Installer\Assemblies\C:|Program Files (x86)|Freshdesk|Freshservice Discovery Agent|bin|FSAgentStatusUpdater.exe" -Recurse
Remove-Item -Path "Registry::HKEY_CLASSES_ROOT\Installer\Assemblies\C:|Program Files (x86)|Freshdesk|Freshservice Discovery Agent|bin|FSUtil.dll" -Recurse
Remove-Item -Path "Registry::HKEY_CLASSES_ROOT\Installer\Assemblies\C:|Program Files (x86)|Freshdesk|Freshservice Discovery Agent|bin|FSWmiScanner.exe" -Recurse
Remove-Item -Path "Registry::HKEY_CLASSES_ROOT\Installer\Assemblies\C:|Program Files (x86)|Freshdesk|Freshservice Discovery Agent|bin|Microsoft.Win32.TaskScheduler.dll" -Recurse
Remove-Item -Path "Registry::HKEY_CLASSES_ROOT\Installer\Assemblies\C:|Program Files (x86)|Freshdesk|Freshservice Discovery Agent|bin|Newtonsoft.Json.dll" -Recurse
Remove-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" -Name "C:\Temp\FSAgent\FSStrip.bat.FriendlyAppName"
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Assemblies\C:|Program Files (x86)|Freshdesk|Freshservice Discovery Agent|bin|AgentInstaller.dll" -Recurse
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Assemblies\C:|Program Files (x86)|Freshdesk|Freshservice Discovery Agent|bin|FSAgentAutoUpdate.exe" -Recurse
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Assemblies\C:|Program Files (x86)|Freshdesk|Freshservice Discovery Agent|bin|FSAgentCrashStatusUpdater.exe" -Recurse
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Assemblies\C:|Program Files (x86)|Freshdesk|Freshservice Discovery Agent|bin|FSAgentService.exe" -Recurse
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Assemblies\C:|Program Files (x86)|Freshdesk|Freshservice Discovery Agent|bin|FSAgentStatusUpdater.exe" -Recurse
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Assemblies\C:|Program Files (x86)|Freshdesk|Freshservice Discovery Agent|bin|FSUtil.dll" -Recurse
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Assemblies\C:|Program Files (x86)|Freshdesk|Freshservice Discovery Agent|bin|FSWmiScanner.exe" -Recurse
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Assemblies\C:|Program Files (x86)|Freshdesk|Freshservice Discovery Agent|bin|log4net.dll" -Recurse
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Assemblies\C:|Program Files (x86)|Freshdesk|Freshservice Discovery Agent|bin|Microsoft.Win32.TaskScheduler.dll" -Recurse
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Assemblies\C:|Program Files (x86)|Freshdesk|Freshservice Discovery Agent|bin|Newtonsoft.Json.dll" -Recurse
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MATS\WindowsInstaller\{070940BC-E4CA-458C-AEE3-F4227EFE6B19}" -Recurse
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{47A2F266-843C-42EA-9B5C-DF6F55186CDE}" -Recurse
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\FreshserviceAgentUpdater" -Recurse
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Freshdesk\FSAgent" -Recurse
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\Setup\FirstBoot\Services\FSDiscoveryAgent" -Recurse
Remove-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\Folders" -Name "C:\Program Files (x86)\Freshdesk\"
Remove-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\Folders" -Name "C:\Program Files (x86)\Freshdesk\Freshservice Discovery Agent\"
Remove-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\Folders" -Name "C:\Program Files (x86)\Freshdesk\Freshservice Discovery Agent\bin\"
Remove-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\Folders" -Name "C:\Program Files (x86)\Freshdesk\Freshservice Discovery Agent\conf\"
Remove-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\Folders" -Name "C:\Program Files (x86)\Freshdesk\Freshservice Discovery Agent\images\"
Remove-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\Folders" -Name "C:\Program Files (x86)\Freshdesk\Freshservice Discovery Agent\Third Party Licenses\"


# Copy clean install from SVC01 and Execute
Copy-Item -Path "\\AZRE-SVC01\FreshService\fs-windows-agent-3.3.0.msi" -Destination "C:\Windows\Temp" -Recurse
Start-Sleep -Seconds 15
cd C:\Windows\Temp\
msiexec -i "fs-windows-agent-3.3.0.msi" /qn