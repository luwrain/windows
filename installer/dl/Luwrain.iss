
[Setup]
AppId={{org.luwrain.dl}}
AppName=Разметка данных
AppVersion=0.1.0
AppVerName=Разметка данных 0.1.0
AppPublisher=LUWRAIN
AppComments=Невизуальное приложение для разметки данных
AppCopyright=Copyright (C) 2022 LUWRAIN
AppPublisherURL=https://luwrain.org
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
DefaultGroupName=Разметка данных
;Optional License
LicenseFile=
;WinXP or above
MinVersion=0,5.1 
OutputBaseFilename=dl-0.1.0
Compression=lzma2/normal
SolidCompression=yes
PrivilegesRequired=lowest
SetupIconFile=Luwrain\dl.ico
UninstallDisplayIcon={app}\dl.ico
UninstallDisplayName=Разметка данных
WizardImageStretch=No
WizardSmallImageFile=setup-icon.bmp
ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[Files]
Source: "Luwrain\dl.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "Luwrain\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Разметка данных"; Filename: "%ComSpec%"; Parameters: "/c start {code:GetDefaultDir}\dl.exe"; IconFilename: "{app}\dl.ico"; Check: returnTrue()
Name: "{commondesktop}\Разметка данных"; Filename: "%ComSpec%"; Parameters: "/c start {code:GetDefaultDir}\dl.exe"; IconFilename: "{app}\dl.ico"; Check: returnTrue()

[Run]
Filename: "{code:GetDefaultDir}\dl.exe"; Parameters: "-Xappcds:generatecache"; Check: returnFalse()
Filename: "{code:GetDefaultDir}\dl.exe"; Description: "{cm:LaunchProgram,Luwrain}"; Flags: nowait postinstall skipifsilent; Check: returnTrue()
Filename: "{code:GetDefaultDir}\dl.exe"; Parameters: "-install -svcName ""LUWRAIN"" -svcDesc ""dl"" -mainExe ""dl.exe""  "; Check: returnFalse()

[UninstallRun]
;Filename: "{code:GetDefaultDir}\dl.exe "; Parameters: "-uninstall -svcName Luwrain -stopOnUninstall"; Check: returnFalse()

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
    // {localappdata}\DirectMedia
    Result := GetShortName(GetEnv('localappdata')+'\DataLabelling');
end;

function InitializeSetup(): Boolean;
begin
// Possible future improvements:
//   if version less or same => just launch app
//   if upgrade => check if same app is running and wait for it to exit
//   Add pack200/unpack200 support? 
  Result := True;
end;  
