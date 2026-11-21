; VALE for Windows - per-user installer (no admin rights). build.py compiles it with:
;   iscc /DAppVersion=1.0.0 /DSourceDir=<dist\VALE> /DOutputDir=<dist> /DIconFile=<build\vale.ico> vale.iss
; Installs to %LOCALAPPDATA%\Programs\VALE, adds VALE to the Start menu (and optionally the desktop) and lists it
; in Settings > Apps. The window keeps its data (the shards you found and where you were) in %LOCALAPPDATA%\VALE, which
; uninstalling leaves in place so a reinstall finds it again.

#ifndef AppVersion
  #define AppVersion "1.0.0"
#endif
#ifndef SourceDir
  #define SourceDir "dist\VALE"
#endif
#ifndef OutputDir
  #define OutputDir "dist"
#endif
#ifndef IconFile
  #define IconFile "build\vale.ico"
#endif

[Setup]
AppId={{E81247BA-698B-569E-A6DE-E1E1C366EEFB}
AppName=VALE
AppVersion={#AppVersion}
AppVerName=VALE {#AppVersion}
AppPublisher=Juwen Lie
AppPublisherURL=https://juw12.github.io/vale/
AppSupportURL=https://github.com/juw12/vale
DefaultDirName={autopf}\VALE
DisableDirPage=yes
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
OutputDir={#OutputDir}
OutputBaseFilename=VALE-Windows-Setup
SetupIconFile={#IconFile}
UninstallDisplayIcon={app}\VALE.exe
UninstallDisplayName=VALE
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
CloseApplications=no
SetupLogging=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "{#SourceDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{userprograms}\VALE"; Filename: "{app}\VALE.exe"; Comment: "A first-person fairy explorer"
Name: "{userdesktop}\VALE"; Filename: "{app}\VALE.exe"; Comment: "A first-person fairy explorer"; Tasks: desktopicon

[Run]
Filename: "{app}\VALE.exe"; Description: "{cm:LaunchProgram,VALE}"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "{app}\VALE.exe"; Parameters: "--stop"; Flags: runhidden waituntilterminated; RunOnceId: "StopVALE"

[Code]
function PrepareToInstall(var NeedsRestart: Boolean): String;
var
  ResultCode: Integer;
begin
  Result := '';
  { Updating: close an open VALE window first so its files can be replaced. }
  if FileExists(ExpandConstant('{app}\VALE.exe')) then
    Exec(ExpandConstant('{app}\VALE.exe'), '--stop', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
end;
