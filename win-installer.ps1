Write-Host ""
Write-Host ">>> Running Mike's Dev Setup Installer <<<" -ForegroundColor Yellow
Write-Host ""
Start-Sleep -Seconds 1
Write-Host "[=     ] Checking Permissions..." -ForegroundColor DarkGray
Start-Sleep -Seconds 1
# Check if running as Administrator
$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $IsAdmin) {
    Write-Host "ERROR: Please run this script in an elevated (Administrator) PowerShell!" -ForegroundColor Red
    exit 1
}

Write-Host "[==    ] Downloading Chocolatey..." -ForegroundColor DarkGray
# Choco
echo "Installing chocolatey"
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

Write-Host "[===  ] Downloading Choco & Winget packages..." -ForegroundColor DarkGray
# Web
choco install googlechrome -y
# Game Dev
choco install unity-hub -y
choco install epicgameslauncher -y
# Using winget for steam instead of choco because choco package maintainers are lazy :(
winget install -e --id Valve.Steam --silent --accept-package-agreements --accept-source-agreements
# General IDEs
choco install vscode -y
choco install visualstudio2022community -y
# Various
choco install git-fork -y
choco install git -y
# Winget seems more consistent here
winget install -e --id Microsoft.Teams --force --silent --accept-package-agreements --accept-source-agreements
choco install vlc -y
# Keepass might already be installed on Admin account, which means I have to force it to install for this user too
winget install -e --id KeePassXCTeam.KeePassXC --force --silent --accept-package-agreements --accept-source-agreements
winget install -e --id OBSProject.OBSStudio --silent --accept-package-agreements --accept-source-agreements
winget install -e --id OpenJS.NodeJS --silent --accept-package-agreements --accept-source-agreements
winget install -e --id RARLab.WinRAR --silent --accept-package-agreements --accept-source-agreements

# FIRST Remove Microsoft Store Python Stub: Go to Settings > Apps > Advanced app settings > App execution aliases
winget install --id Python.Python.3.11 --source winget --silent --accept-package-agreements --accept-source-agreements


Write-Host "[==== ] Setting defualt windows settings..." -ForegroundColor DarkGray
# Windows Settings
# Fix time zone
Set-TimeZone -Id "W. Europe Standard Time"
# Set dark mode
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0

Write-Host "[=====] Debloating & Setting Theme" -ForegroundColor DarkGray
# Debloat
& ([scriptblock]::Create((irm "https://win11debloat.raphi.re/")))

# Wallpaper
# Link: https://amaruq.ch/wp-content/uploads/2024/10/wp5299018.jpg

$setwallpapersrc = @"
using System.Runtime.InteropServices;
using Microsoft.Win32;


public class Wallpaper
{
  public const int SetDesktopWallpaper = 20;
  public const int UpdateIniFile = 0x01;
  public const int SendWinIniChange = 0x02;
  [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
  private static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
public static void SetWallpaper(string path, string style)
{
    SystemParametersInfo(SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange);

    // Set the wallpaper style in the registry
    RegistryKey key = Registry.CurrentUser.OpenSubKey(@"Control Panel\Desktop", true);
    if (key != null)
    {
        key.SetValue(@"WallpaperStyle", style == "Fit" ? "6" : "10"); // 6 for Fit, 10 for Fill
        key.SetValue(@"TileWallpaper", "0");
        key.Close();
    }
}
}
"@
Add-Type -TypeDefinition $setwallpapersrc

mkdir "$env:APPDATA/fierc3"
Invoke-WebRequest -Uri "https://amaruq.ch/wp-content/uploads/2024/10/wp5299018.jpg" -OutFile "$env:APPDATA/fierc3/wallpaper.jpg"
[Wallpaper]::SetWallpaper("$env:APPDATA/fierc3/wallpaper.jpg", "Fit")

# Fix color accent for wallpaper
$registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
Set-ItemProperty -Path $registryPath -Name "ColorPrevalence" -Value 1
Set-ItemProperty -Path $registryPath -Name "AutoColorization" -Value 1
Stop-Process -Name explorer -Force
Start-Process explorer
Write-Output "Accent color set to automatic."

Write-Host "[=====] Script finished!" -ForegroundColor Green
