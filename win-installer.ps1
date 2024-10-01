echo "Running Mike's Default installer"

# Choco
echo "Installing chocolatey"
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Web
choco install googlechrome
# Game Dev
choco install unity-hub
choco install epicgameslauncher
# failed
choco install steam
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

# Debloat
& ([scriptblock]::Create((irm "https://win11debloat.raphi.re/")))

# Wallpaper
# Link: https://amaruq.ch/wp-content/uploads/2024/10/wp5299018.jpg