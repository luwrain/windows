
[Setup]
AppId={{org.luwrain.reader}}
AppName=LUWRAIN Reader
AppVersion=LUWRAIN_VERSION
AppVerName=LUWRAIN Reader LUWRAIN_VERSION
AppPublisher=The LUWRAIN Project
AppComments=A books reader for the blind supporting DAISY and other formats
AppCopyright=Copyright (C) 2012-2020 LUWRAIN developers
AppPublisherURL=http://luwrain.org
;AppSupportURL=http://java.com/
;AppUpdatesURL=http://java.com/
;{localappdata}\Luwrain
DefaultDirName={code:GetDefaultDir}
DisableStartupPrompt=Yes
DisableDirPage=Yes
DisableProgramGroupPage=Yes
DisableReadyPage=Yes
DisableFinishedPage=Yes
DisableWelcomePage=Yes
DefaultGroupName=LUWRAIN Reader
;Optional License
LicenseFile=
;WinXP or above
MinVersion=0,5.1 
OutputBaseFilename=Luwrain-LUWRAIN_VERSION
Compression=lzma2/normal
SolidCompression=yes
PrivilegesRequired=lowest
SetupIconFile=Luwrain\reader.ico
UninstallDisplayIcon={app}\Luwrain.ico
UninstallDisplayName=LUWRAIN Reader
WizardImageStretch=No
WizardSmallImageFile=Luwrain-setup-icon.bmp
ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "Luwrain\reader.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "Luwrain\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\LUWRAIN Reader"; Filename: "%ComSpec%"; Parameters: "/c start {code:GetDefaultDir}\reader.exe"; IconFilename: "{app}\reader.ico"; Check: returnTrue()
Name: "{commondesktop}\LUWRAIN Reader"; Filename: "%ComSpec%"; Parameters: "/c start {code:GetDefaultDir}\reader.exe"; IconFilename: "{app}\reader.ico"; Check: returnFalse()

[Run]
Filename: "{code:GetDefaultDir}\reader.exe"; Parameters: "-Xappcds:generatecache"; Check: returnFalse()
;Filename: "{code:GetDefaultDir}\reader.exe"; Description: "{cm:LaunchProgram,Luwrain}"; Flags: nowait postinstall skipifsilent; Check: returnTrue()
;Filename: "{code:GetDefaultDir}\reader.exe"; Parameters: "-install -svcName ""LUWRAIN"" -svcDesc ""reader"" -mainExe ""reader.exe""  "; Check: returnFalse()

[UninstallRun]
;Filename: "{code:GetDefaultDir}\reader.exe "; Parameters: "-uninstall -svcName Luwrain -stopOnUninstall"; Check: returnFalse()

[Code]
const
  BN_CLICKED = 0;
  WM_COMMAND = $0111;
  CN_BASE = $BC00;
  CN_COMMAND = CN_BASE + WM_COMMAND;

procedure CurPageChanged(CurPageID: Integer);
var
  Param: Longint;
begin
  // if we are on the ready page, then...
  if CurPageID = wpReady then
  begin
    // the result of this is 0, just to be precise...
    Param := 0 or BN_CLICKED shl 16;
    // post the click notification message to the next button
    PostMessage(WizardForm.NextButton.Handle, CN_COMMAND, Param, 0);
  end;
end;

function returnTrue(): Boolean;
begin
  Result := True;
end;

function returnFalse(): Boolean;
begin
  Result := False;
end;

function GetDefaultDir(def: string): string;
begin
    // {localappdata}\LuwrainReader
    Result := GetShortName(GetEnv('localappdata')+'\LuwrainReader');
end;

function InitializeSetup(): Boolean;
begin
// Possible future improvements:
//   if version less or same => just launch app
//   if upgrade => check if same app is running and wait for it to exit
//   Add pack200/unpack200 support? 
  Result := True;
end;  
