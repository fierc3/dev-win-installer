echo "Running Mike's Default installer"
# Web
# failed
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
