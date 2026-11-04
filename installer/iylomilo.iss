; Windows installer for iylomilo (Inno Setup 7). Built by tools/make_installer_win.ps1, which passes
; the version and the staging folder; the user picks the formats on the Components page.
#ifndef AppVersion
  #define AppVersion "1.0"
#endif
#ifndef Stage
  #define Stage "..\build-win\stage"
#endif
#ifndef BuildAssets
  #define BuildAssets "installer-assets"
#endif
#ifndef BuildOutput
  #define BuildOutput "dist"
#endif

[Setup]
AppId={{A844B75A-12C7-4E47-8C33-9B6207C15531}
AppName=iylomilo
AppVersion={#AppVersion}
AppVerName=iylomilo {#AppVersion}
AppPublisher=thefadlyma
AppCopyright=Copyright (C) 2026 thefadlyma
AppComments=Octave pitch effect plugin for Windows DAWs
DefaultDirName={commoncf64}\thefadlyma\iylomilo
DisableDirPage=yes
DisableProgramGroupPage=yes
OutputDir={#BuildOutput}
OutputBaseFilename=iylomilo-{#AppVersion}-Windows-Setup
Compression=lzma2/max
SolidCompression=yes
; x64 plugins also run on Windows on ARM in x64 and ARM64EC hosts (e.g. REAPER for ARM).
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=admin
WizardStyle=modern
SetupIconFile={#BuildAssets}\iylomilo.ico
WizardImageFile={#BuildAssets}\iylomilo-wizard.png
WizardSmallImageFile={#BuildAssets}\iylomilo-small.png
UninstallDisplayName=iylomilo {#AppVersion} by thefadlyma

[Types]
Name: "full"; Description: "Recommended - VST3 and CLAP"
Name: "custom"; Description: "Custom - choose formats"; Flags: iscustom

[Components]
Name: "vst3"; Description: "VST3 plugin (recommended for most DAWs)"; Types: full custom
Name: "clap"; Description: "CLAP plugin (for CLAP-compatible DAWs)"; Types: full custom

[Messages]
SelectComponentsDesc=Choose the plugin formats to install. Both formats are recommended if you use more than one DAW.

[Files]
Source: "{#Stage}\VST3\iylomilo.vst3\*"; DestDir: "{commoncf64}\VST3\iylomilo.vst3"; Components: vst3; Flags: recursesubdirs ignoreversion
Source: "{#Stage}\CLAP\iylomilo.clap"; DestDir: "{commoncf64}\CLAP"; Components: clap; Flags: ignoreversion
