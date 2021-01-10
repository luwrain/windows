
[Setup]
AppId={{ru.tsu.lib.app}}
AppName=Научная библиотека ТГУ
AppVersion=LUWRAIN_VERSION
AppVerName=Научная библиотека ТГУ LUWRAIN_VERSION
AppPublisher=Национальный исследовательский Томский государственный университет
AppComments=Невизуальное приложение для работы с каталогом научной библиотеки ТГУ
AppCopyright=Copyright (C) 2018-2021 Национальный исследовательский Томский государственный университет
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
DefaultGroupName=Томский государственный университет
;Optional License
LicenseFile=
;WinXP or above
MinVersion=0,5.1 
OutputBaseFilename=tsulib-LUWRAIN_VERSION
Compression=lzma2/normal
SolidCompression=yes
PrivilegesRequired=lowest
SetupIconFile=Luwrain\tsulib.ico
UninstallDisplayIcon={app}\tsulib.ico
UninstallDisplayName=Научная библиотека ТГУ
WizardImageStretch=No
WizardSmallImageFile=setup-icon.bmp
ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[Files]
Source: "Luwrain\tsulib.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "Luwrain\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Научная библиотека ТГУ"; Filename: "%ComSpec%"; Parameters: "/c start {code:GetDefaultDir}\tsulib.exe"; IconFilename: "{app}\tsulib.ico"; Check: returnTrue()
Name: "{commondesktop}\Научная библиотека ТГУ"; Filename: "%ComSpec%"; Parameters: "/c start {code:GetDefaultDir}\tsulib.exe"; IconFilename: "{app}\tsulib.ico"; Check: returnFalse()

[Run]
Filename: "{code:GetDefaultDir}\tsulib.exe"; Parameters: "-Xappcds:generatecache"; Check: returnFalse()
Filename: "{code:GetDefaultDir}\tsulib.exe"; Description: "{cm:LaunchProgram,Luwrain}"; Flags: nowait postinstall skipifsilent; Check: returnTrue()
Filename: "{code:GetDefaultDir}\tsulib.exe"; Parameters: "-install -svcName ""LUWRAIN"" -svcDesc ""tsulib"" -mainExe ""tsulib.exe""  "; Check: returnFalse()

[UninstallRun]
;Filename: "{code:GetDefaultDir}\tsulib.exe "; Parameters: "-uninstall -svcName Luwrain -stopOnUninstall"; Check: returnFalse()

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
    // {localappdata}\TsuLib
    Result := GetShortName(GetEnv('localappdata')+'\TsuLib');
end;

function InitializeSetup(): Boolean;
begin
// Possible future improvements:
//   if version less or same => just launch app
//   if upgrade => check if same app is running and wait for it to exit
//   Add pack200/unpack200 support? 
  Result := True;
end;  
