echo "Running Mike's Default installer"

# Choco
echo "Installing chocolatey"
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Web
choco install googlechrome
# Game Dev
choco install unity-hub
choco install epicgameslauncher
# Using winget for steam instead of choco because choco package maintainers are lazy :(
winget install -e --id Valve.Steam
# General IDEs
choco install vscode
choco install visualstudio2022community
# Various
choco install git-fork
choco install git
choco install microsoft-teams-new-bootstrapper
choco install vlc
choco install python

#missing: Metalink

# Windows Settings
# Fix time zone
Set-TimeZone -Id "W. Europe Standard Time"
# Set dark mode
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0

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

Write-Output "+++++Script Finished+++++++"