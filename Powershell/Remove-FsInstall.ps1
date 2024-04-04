#Fresh Service Cleanup Script

#Logging
$logFilePath =[System.Environment]::GetEnvironmentVariable('TEMP','Machine')

$logFileStream = [System.IO.File]::Open($logFilePath, 'Append', 'Write', 'Read')

$logFileWriter = [System.IO.StreamWriter]::new($logFileStream)





# Define function to recursively enumerate registry keys
function Find-RegistryKeys {
    param (
        [Microsoft.Win32.RegistryKey]$hive,
        [string]$key,
        [System.Collections.Generic.Dictionary[string, string]]$dict
    )
    # Add current key to dictionary
    $dict.Add($key, "")

    # Get subkeys
    $subKeys = $hive.OpenSubKey($key).GetSubKeyNames()

    # Enumerate subkeys recursively
    foreach ($subKey in $subKeys) {
        Find-RegistryKeys -hive $hive -key "$key\$subKey" -dict $dict
    }
}

# Define function to delete registry key
function Remove-RegistryKey {
    param (
        [Microsoft.Win32.RegistryKey]$hive,
        [string]$key
    )

    # Delete registry key
    $hive.DeleteSubKeyTree($key)
}

# Define function to remove uninstall key
function Remove-FsInstall  {
    # Create dictionary object
    $uninstallKeyDict = New-Object "System.Collections.Generic.Dictionary[string,string]"

    # Define registry key paths for FS
    $uninstallKeyPath = "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
    $uninstallKeyPath64 = "SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
    $fsAgent64 = "SOFTWARE\Wow6432Node\Freshdesk\FSAgent\"
    $fsAgent= "SOFTWARE\Freshdesk\FSAgent\"
    $uninstallerVerification = "SOFTWARE\Wow6432Node\Freshdesk\FSAgent\UninstallVerification"
    $installDir = "SOFTWARE\Freshdesk\FSAgent\InstallDir"
    $installDir64= "SOFTWARE\Wow6432Node\Freshdesk\FSAgent\InstallDir"
    $products = "SOFTWARE\Classes\Installer\Products"
    $products64 = "SOFTWARE\Wow6432Node\Classes\Installer\Products"

 
    # Enumerate through keys and add them to the dictionary. 
    try {    
    Find-RegistryKeys -hive ([Microsoft.Win32.Registry]::LocalMachine) -key $uninstallKeyPath -dict $uninstallKeyDict
    Find-RegistryKeys -hive ([Microsoft.Win32.Registry]::LocalMachine) -key $uninstallKeyPath64 -dict $uninstallKeyDict
    Find-RegistryKeys -hive ([Microsoft.Win32.Registry]::LocalMachine) -key $fsAgent64 -dict $uninstallKeyDict
    Find-RegistryKeys -hive ([Microsoft.Win32.Registry]::LocalMachine) -key $fsAgent -dict $uninstallKeyDict
    Find-RegistryKeys -hive ([Microsoft.Win32.Registry]::LocalMachine) -key $uninstallerVerification -dict $uninstallKeyDict
    Find-RegistryKeys -hive ([Microsoft.Win32.Registry]::LocalMachine) -key $installDir -dict $uninstallKeyDict
    Find-RegistryKeys -hive ([Microsoft.Win32.Registry]::LocalMachine) -key $installDir64 -dict $uninstallKeyDict
    Find-RegistryKeys -hive ([Microsoft.Win32.Registry]::LocalMachine) -key $products -dict $uninstallKeyDict
    Find-RegistryKeys -hive ([Microsoft.Win32.Registry]::LocalMachine) -key $products64 -dict $uninstallKeyDict
    }
     catch{
        
    Write-Host "An Error occured."

    $logFileWriter.WriteLine("Error occured:")

    $logFileWriter.WriteLine($_)

    $logFileWriter.WriteLine($_.ScriptStackTrace)
    }

    

    # Iterate through keys and remove if DisplayName matches
    foreach ($key in $uninstallKeyDict.Keys) {
        $displayName = (Get-ItemProperty -Path "HKLM:\$key" -Name "DisplayName").DisplayName
        if ($displayName -eq "Freshservice Discovery Agent") {
            Remove-RegistryKey -hive ([Microsoft.Win32.Registry]::LocalMachine) -key $key
        }
        $productName = (Get-ItemProperty -Path "HKLM:\$key" -Name "ProductName").ProductName
        if ($productName -eq "Freshservice Discovery Agent"){
            Remove-RegistryKey -hive([Microsoft.Win32.Registry]::LocalMachine) -key $key
        }
    }
}

# Remove uninstall key
Remove-FsInstall


$logFileWriter.Close()

