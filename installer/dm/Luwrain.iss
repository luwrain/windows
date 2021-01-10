
[Setup]
AppId={{org.luwrain.dm}}
AppName=Директ-Медиа Чтение вслух
AppVersion=0.1.0
AppVerName=Директ-Медиа Чтение вслух 0.1.0
AppPublisher=Директ-Медиа
AppComments=Невизуальное приложение для работы с ЭБС ДИрект-Медиа
AppCopyright=Copyright (C) 2021 Direct-Media
AppPublisherURL=http://directmedia.ru
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
DefaultGroupName=директ-Медиа
;Optional License
LicenseFile=
;WinXP or above
MinVersion=0,5.1 
OutputBaseFilename=dm-0.1.0
Compression=lzma2/normal
SolidCompression=yes
PrivilegesRequired=lowest
SetupIconFile=Luwrain\dm.ico
UninstallDisplayIcon={app}\dm.ico
UninstallDisplayName=Директ-Медиа
WizardImageStretch=No
WizardSmallImageFile=setup-icon.bmp
ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[Files]
Source: "Luwrain\dm.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "Luwrain\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Чтение вслух"; Filename: "%ComSpec%"; Parameters: "/c start {code:GetDefaultDir}\dm.exe"; IconFilename: "{app}\dm.ico"; Check: returnTrue()
Name: "{commondesktop}\директ-Медиа"; Filename: "%ComSpec%"; Parameters: "/c start {code:GetDefaultDir}\dm.exe"; IconFilename: "{app}\dm.ico"; Check: returnFalse()

[Run]
Filename: "{code:GetDefaultDir}\dm.exe"; Parameters: "-Xappcds:generatecache"; Check: returnFalse()
Filename: "{code:GetDefaultDir}\dm.exe"; Description: "{cm:LaunchProgram,Luwrain}"; Flags: nowait postinstall skipifsilent; Check: returnTrue()
Filename: "{code:GetDefaultDir}\dm.exe"; Parameters: "-install -svcName ""LUWRAIN"" -svcDesc ""dm"" -mainExe ""dm.exe""  "; Check: returnFalse()

[UninstallRun]
;Filename: "{code:GetDefaultDir}\dm.exe "; Parameters: "-uninstall -svcName Luwrain -stopOnUninstall"; Check: returnFalse()

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
    Result := GetShortName(GetEnv('localappdata')+'\DirectMedia');
end;

function InitializeSetup(): Boolean;
begin
// Possible future improvements:
//   if version less or same => just launch app
//   if upgrade => check if same app is running and wait for it to exit
//   Add pack200/unpack200 support? 
  Result := True;
end;  
