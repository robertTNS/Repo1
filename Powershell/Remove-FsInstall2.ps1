# Logging function
function Log-Message {
    param([String]$Message)
    Set-Content -Path "C:\Temp\Remove-FsInstallLog2.txt" -Value $Message
}

# Function to remove uninstall key
function Remove-FsInstall {
    # Define registry key paths for FS
    $uninstallKeyPaths = @(
        #32bit Installer path
        "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
        #64bit Installer path
        "SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
        #FSAgent 
        "SOFTWARE\Freshdesk\FSAgent",
        #64bit FS agent
        "SOFTWARE\Wow6432Node\Freshdesk\FSAgent",
        #64bit product name
        "SOFTWARE\Wow6432Node\Classes\Installer\Products",
        #32bit product name
        "SOFTWARE\Classes\Installer\Products", 
        #Image Path 
        "SYSTEM\ControlSet001\Services\FSDiscoveryAgent",
        #Install Properties path
        "SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\7B81CC377A3245C4F91B2BA3AE56075C\InstallProperties"
    )

    # Loop through each uninstall key path
    foreach ($uninstallKeyPath in $uninstallKeyPaths) {
        try {
            $uninstallKeys = Get-ChildItem "HKLM:\$uninstallKeyPath" | Where-Object { $_.Property -contains "DisplayName" -or $_.Property -contains "ProductName" -or $_.Property -contains "InstallDir" -or $_.Property -contains "ImagePath" }
            
            foreach ($key in $uninstallKeys) {
                $displayName = $key.GetValue("DisplayName")
                $productName = $key.GetValue("ProductName")
                $installDir = $key.GetValue("InstallDir")
                $imagePath = $key.GetValue("ImagePath")
                
                if ($displayName -eq "Freshservice Discovery Agent") {
                    Remove-Item -Path $key.PSPath -Recurse -Force
                    Log-Message "Key with Matching Display Name found! Found and removed: '$displayName'"
                }
                elseif ($productName -eq "Freshservice Discovery Agent") {
                    Remove-Item -Path $key.PSPath -Recurse -Force
                    Log-Message "Key with Matching Product Name found! Found and removed: '$productName'"
                }
                elseif ($installDir -like "*Freshservice Discovery Agent*") {
                    Remove-Item -Path $key.PSPath -Recurse -Force
                    Log-Message "Key with Matching install directory found! Found and removed: '$installDir'"
                }
                elseif ($imagePath -like "*Freshservice Discovery Agent*"){
                    Remove-Item -Path $key.PSPath -Recurse -Force
                    Log-Message "Key with matching image path found! Found and removed: '$imagePath'"
                }
                else {
                    Log-Message "Key does not match criteria. Display Name: '$displayName', Product Name: '$productName', InstallDir Name: '$installDir'"
                }
            }
        }
        catch {
            Log-Message "An error occurred while processing uninstall keys: $_"
            Write-Host " An error occurred while processing uninstall keys: $_"
        }
    }
}

# Remove uninstall key
Remove-FsInstall