#define MyAppName "DST CSRI CHAIR VITCC"
#define MyAppVersion "1.5"
#define MyAppPublisher "CHAIR VITCC"
#define MyAppURL "https://dstcsrichairvitccapp.web.app"
#define MyAppExeName "dstcsri_chair_vitcc_app.exe"  ; <-- CHANGE THIS

[Setup]
AppId={{D25FCD4C-453A-4BC4-B64B-19DFD9BADC4B}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
OutputBaseFilename=DSTCSRI_CHAIR_VITCC
Compression=lzma
SolidCompression=yes
WizardStyle=modern

ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "Create Desktop Icon"; Flags: unchecked

[Files]
; 👇 VERY IMPORTANT: Copy FULL Flutter build folder
Source: "C:\Users\Admin\dstcsri_chair_vitcc_app\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "Launch {#MyAppName}"; Flags: nowait postinstall skipifsilent