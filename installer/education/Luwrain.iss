
[Setup]
AppId={{org.luwrain.education}}
AppName=LUWRAIN для образования
AppVersion=LUWRAIN_VERSION
AppVerName=LUWRAIN для образования LUWRAIN_VERSION
AppPublisher=LUWRAIN
AppComments=Комплект невизуальных образовательных приложений
AppCopyright=Copyright (C) 2021 LUWRAIN
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
DefaultGroupName=LUWRAIN для образования
;Optional License
LicenseFile=
;WinXP or above
MinVersion=0,5.1 
OutputBaseFilename=luwrain-education-LUWRAIN_VERSION
Compression=lzma2/normal
SolidCompression=yes
PrivilegesRequired=lowest
SetupIconFile=Luwrain\education.ico
UninstallDisplayIcon={app}\education.ico
UninstallDisplayName=LUWRAIN для образования
WizardImageStretch=No
WizardSmallImageFile=setup-icon.bmp
ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[Files]
Source: "Luwrain\education.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "Luwrain\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\LUWRAIN для образования"; Filename: "%ComSpec%"; Parameters: "/c start {code:GetDefaultDir}\education.exe"; IconFilename: "{app}\education.ico"; Check: returnTrue()
Name: "{commondesktop}\LUWRAIN для образования"; Filename: "%ComSpec%"; Parameters: "/c start {code:GetDefaultDir}\education.exe"; IconFilename: "{app}\education.ico"; Check: returnTrue()

[Run]
Filename: "{code:GetDefaultDir}\education.exe"; Parameters: "-Xappcds:generatecache"; Check: returnFalse()
Filename: "{code:GetDefaultDir}\education.exe"; Description: "{cm:LaunchProgram,Luwrain}"; Flags: nowait postinstall skipifsilent; Check: returnTrue()
Filename: "{code:GetDefaultDir}\education.exe"; Parameters: "-install -svcName ""LUWRAIN"" -svcDesc ""education"" -mainExe ""education.exe""  "; Check: returnFalse()

[UninstallRun]
;Filename: "{code:GetDefaultDir}\education.exe "; Parameters: "-uninstall -svcName Luwrain -stopOnUninstall"; Check: returnFalse()

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
    // {localappdata}\LwrEducation
    Result := GetShortName(GetEnv('localappdata')+'\LwrEducation');
end;

function InitializeSetup(): Boolean;
begin
// Possible future improvements:
//   if version less or same => just launch app
//   if upgrade => check if same app is running and wait for it to exit
//   Add pack200/unpack200 support? 
  Result := True;
end;  
