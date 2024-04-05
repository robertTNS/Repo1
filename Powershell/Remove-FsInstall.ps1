#Fresh Service Cleanup Script

#Logging
function Log-Message([String]$Message)
{
    Add-Content -Path C:\Temp\Remove-FsInstallLog.txt $Message
}

Log-Message "Log file created `n"



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
    $uninstallerVerification = "SOFTWARE\Wow6432Node\Freshdesk\FSAgent\UninstallVerification"
    $uninstallKeyPath64 = "SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
    $uninstallKeyPath = "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
    $fsAgent64 = "SOFTWARE\Wow6432Node\Freshdesk\FSAgent"
    $fsAgent= "SOFTWARE\Freshdesk\FSAgent"
    $installDir64= "SOFTWARE\Wow6432Node\Freshdesk\FSAgent\InstallDir"
    $installDir = "SOFTWARE\Freshdesk\FSAgent\InstallDir"
    $products64 = "SOFTWARE\Wow6432Node\Classes\Installer\Products"
    $products = "SOFTWARE\Classes\Installer\Products"
    

 
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
        
    Write-Host "An Error occured while adding keys to the dictionary."

    Log-Message "An Error occured while adding keys to the dictionary:"

    Log-Message "Error: $($_) `n" 

    Log-Message "StackTrace: $($_.ScriptStackTrace) `n"
    }

    

    # search keys and remove if  display name or product name is found 
    foreach ($key in $uninstallKeyDict.Keys) {
        try {
        $displayName = (Get-ItemProperty -Path "HKLM:\$key\$subKeys" -Name "DisplayName").DisplayName
        if ($displayName -like "Freshservice Discovery Agent") {
            Remove-RegistryKey -hive ([Microsoft.Win32.Registry]::LocalMachine) -key $key
            Log-Message "Key with Matching Display Name found! Found:: '$displayName'"
        }
        else{
            Log-Message "Key with Matching Display Name not found. Found '$displayName' instead."
        }
    }
        catch {
            Log-Message "An Error occured:"

            Log-Message "Error: $($_) `n" 
        
            Log-Message "StackTrace: $($_.ScriptStackTrace) `n"
        }

        try{
        $productName = (Get-ItemProperty -Path "HKLM:\$key\$subKeys" -Name "ProductName").ProductName
        if ($productName -like "Freshservice Discovery Agent"){
            Remove-RegistryKey -hive([Microsoft.Win32.Registry]::LocalMachine) -key $key
            Log-Message "Key with Matching Display Name found! Found:: '$productName'"
        }
        else{
            Log-Message "Key with Matching Product Name not found. Found '$productName'  instead."
        }
        }
    
        catch{
            Log-Message "An Error occured:"

            Log-Message "Error: $($_) `n" 
        
            Log-Message "StackTrace: $($_.ScriptStackTrace) `n"

    }
    try{
        $installDirectory = (Get-ItemProperty -Path "HKLM:\$key\" -Name "InstallDir").InstallDir
        if ($installDirectory -like "Freshservice Discovery Agent"){
            Remove-RegistryKey -hive([Microsoft.Win32.Registry]::LocalMachine) -key $key
            Log-Message "Key with Matching install directory found! Found:: '$installDirectory'"
        }
        else{
            Log-Message "Key with Matching install directory not found. Found '$installDirectory'  instead."
        }
        }
    
        catch{
            Log-Message "An Error occured:"

            Log-Message "Error: $($_) `n" 
        
            Log-Message "StackTrace: $($_.ScriptStackTrace) `n"

    }
    }
}

# Remove uninstall key
Remove-FsInstall
