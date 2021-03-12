
[Setup]
AppId={{org.luwrain.books}}
AppName=LUWRAIN Books
AppVersion=LUWRAIN_VERSION
AppVerName=LUWRAIN Books LUWRAIN_VERSION
AppPublisher=LUWRAIN
AppComments=Невизуальное приложение для работы с сервисом для создания аудиокниг LUWRAIN Books
AppCopyright=Copyright (C) 2012-2021 LUWRAIN
AppPublisherURL=https://books.luwrain.org
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
DefaultGroupName=LUWRAIN Books
;Optional License
LicenseFile=
;WinXP or above
MinVersion=0,5.1 
OutputBaseFilename=Luwrain-books-LUWRAIN_VERSION
Compression=lzma2/normal
SolidCompression=yes
PrivilegesRequired=lowest
SetupIconFile=Luwrain\books.ico
UninstallDisplayIcon={app}\books.ico
UninstallDisplayName=LUWRAIN Books
WizardImageStretch=No
WizardSmallImageFile=setup-icon.bmp
ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[Files]
Source: "Luwrain\books.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "Luwrain\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\LUWRAIN Books"; Filename: "%ComSpec%"; Parameters: "/c start {code:GetDefaultDir}\books.exe"; IconFilename: "{app}\books.ico"; Check: returnTrue()
Name: "{commondesktop}\LUWRAIN Books"; Filename: "%ComSpec%"; Parameters: "/c start {code:GetDefaultDir}\books.exe"; IconFilename: "{app}\books.ico"; Check: returnTrue()

[Run]
Filename: "{code:GetDefaultDir}\books.exe"; Description: "{cm:LaunchProgram,Luwrain}"; Flags: nowait postinstall skipifsilent; Check: returnTrue()
Filename: "{code:GetDefaultDir}\books.exe"; Parameters: "-Xappcds:generatecache"; Check: returnFalse()
Filename: "{code:GetDefaultDir}\books.exe"; Parameters: "-install -svcName ""LUWRAIN"" -svcDesc ""books"" -mainExe ""books.exe""  "; Check: returnFalse()

[UninstallRun]
;Filename: "{code:GetDefaultDir}\books.exe "; Parameters: "-uninstall -svcName Luwrain -stopOnUninstall"; Check: returnFalse()

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
    // {localappdata}\LWRBooks
    Result := GetShortName(GetEnv('localappdata')+'\LWRBooks');
end;

function InitializeSetup(): Boolean;
begin
// Possible future improvements:
//   if version less or same => just launch app
//   if upgrade => check if same app is running and wait for it to exit
//   Add pack200/unpack200 support? 
  Result := True;
end;  
