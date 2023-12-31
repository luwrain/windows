' Copyright (C) 2023 Nikita Tseykovets <tseikovets@rambler.ru>
' SPDX-License-Identifier: MIT
' This software is distributed under the MIT License. See LICENSE.txt file.

Option Explicit

' Message strings displayed to user
Dim msgTitle, msgSettingsNotFound, msgConfirmationDialog, _
	msgProfilesNotFound, msgSettingsAdded
InitializeMessageStrings

' Determine if script is running using windows based script host (WScript.exe)
Dim g_oFSO ' Standart FileSystemObject object of WSH
Set g_oFSO = CreateObject("Scripting.FileSystemObject")
Dim g_bWScript ' Script running indicator using WScript.exe
g_bWScript = LCase(g_oFSO.GetFileName(WScript.FullName)) = "wscript.exe"

' Check integrity of script delivery package
Dim g_sLuwrainJCF ' Path to main application settings file (*.jcf)
g_sLuwrainJCF = g_oFSO.GetParentFolderName(WScript.ScriptFullName) & "\luwrain.JCF"
If Not g_oFSO.FileExists(g_sLuwrainJCF) Then
	DisplayMessage msgSettingsNotFound & vbCrLf & g_sLuwrainJCF, 2
	WScript.Quit
End If

' Show confirmation dialog if script is run using windows based script host
If g_bWScript Then
	If MsgBox(msgConfirmationDialog, vbYesNoCancel + vbExclamation, msgTitle) _
		<> vbYes Then WScript.Quit
End If

' Get array of paths to all relevant user JAWS settings directories
Dim g_oShell ' Standart Shell object of WSH
Set g_oShell = CreateObject("WScript.Shell")
Dim g_asSharedJawsSettings ' Array of paths to shared JAWS settings directories
g_asSharedJawsSettings = SharedJawsSettings
If g_asSharedJawsSettings(0) = 0 Then
	DisplayMessage msgProfilesNotFound, 2
	WScript.Quit
End If
Dim g_asUserJawsSettings ' Array of paths to user JAWS settings directories
g_asUserJawsSettings = UserJawsSettings(g_asSharedJawsSettings)

' Add application settings file to all relevant user JAWS settings directories
Dim i ' Index of path item in paths array
Dim g_sPath ' Path string
Dim g_sList ' List of paths for report
Dim g_sLuwrainAll ' Path to all application settings files with wildcards
g_sLuwrainAll = g_oFSO.GetParentFolderName(WScript.ScriptFullName) & "\luwrain*.JCF"
For i = 1 To g_asUserJawsSettings(0)
	g_sPath = g_asUserJawsSettings(i)
	' Create folder at destination if it does not exist
	If Not g_oFSO.FolderExists(g_sPath) Then CreateFolder(g_sPath)
	g_sList = g_sList & vbCrLf & i & ") " & g_sPath
	' Folder path to destination for .CopyFile must end with backslash
	g_oFSO.CopyFile g_sLuwrainAll, g_sPath & "\", True
Next
DisplayMessage Replace(msgSettingsAdded, "%1", g_asUserJawsSettings(0)) & g_sList, 1

' Procedures and functions

' Procedure initializes message strings variables
' if they have not been initialized previously.
' This is necessary for script localization mechanism.
Sub InitializeMessageStrings()
	If IsEmpty(msgTitle) Then msgTitle = "JAWS Settings for LUWRAIN Application"
	If IsEmpty(msgSettingsNotFound) Then msgSettingsNotFound = "Application settings file not found at path"
	If IsEmpty(msgConfirmationDialog) Then msgConfirmationDialog = "Are you sure you want to add the application settings to all JAWS versions detected on the system and for all JAWS localization languages?"
	If IsEmpty(msgProfilesNotFound) Then msgProfilesNotFound = "Not a single JAWS profiles was found on the system."
	If IsEmpty(msgSettingsAdded) Then msgSettingsAdded = "Application settings have been added to %1 JAWS profiles at the following paths:"
End Sub

' Procedure displays message to user in specified styles of GUI
' or in specified standard streams of CLI.
Sub DisplayMessage(sMessage, iType)
	' Options for running script using windows based or console based script host
	If g_bWScript Then
		' Possible values of iType: 1 - information; 2 - critical
		Select Case iType
			Case 1
				MsgBox sMessage, vbOKOnly + vbInformation, msgTitle
			Case 2
				MsgBox sMessage, vbOKOnly + vbCritical, msgTitle
			Case Else
				MsgBox sMessage, , msgTitle
		End Select
	Else
		' Possible values of iType: 1 - standard output; 2 - standard error
		Select Case iType
			Case 1
				WScript.StdOut.WriteLine sMessage
			Case 2
				WScript.StdErr.WriteLine sMessage
			Case Else
				WScript.Echo sMessage
		End Select
	End If
End Sub

' Function returns an array of paths to all shared JAWS settings directories.
' Array item at index 0 is the number of paths, paths start at item at index 1.
Function SharedJawsSettings()
	Dim asPaths ' Array of paths to shared JAWS settings directories
	asPaths = Array(0)
	Dim sData ' Path to folder with all shared JAWS data
	sData = g_oShell.ExpandEnvironmentStrings("%PROGRAMDATA%") & "\Freedom Scientific\JAWS"
	If g_oFSO.FolderExists(sData) Then
		Dim oData ' Object of folder with all shared JAWS data
		Set oData = g_oFSO.GetFolder(sData)
		Dim oDataSubfolders ' Subfolders collection of folder with all shared JAWS data
		Set oDataSubfolders = oData.SubFolders
		Dim oVersion ' Object of folder with shared JAWS data for specific version
		Dim sSettings ' Path to folder with shared JAWS settings for specific version
		Dim oSettings ' Object of folder with shared JAWS settings for specific version
		Dim oSettingsSubfolders ' Subfolders collection of folder with shared JAWS settings for specific version
		Dim oLang ' Object of potential folder with shared JAWS settings for specific language
		Dim sLang ' Path to potential folder with shared JAWS settings for specific language
		Dim iUBound ' Index of upper bound of paths array
		For Each oVersion In oDataSubfolders
			sSettings = sData & "\" & oVersion.Name & "\SETTINGS"
			If g_oFSO.FolderExists(sSettings) Then
				Set oSettings = g_oFSO.GetFolder(sSettings)
				Set oSettingsSubfolders = oSettings.SubFolders
				For Each oLang In oSettingsSubfolders
					sLang = oLang.Path
					' Folder with shared JAWS settings for specific language must contain Default.JCF file
					If g_oFSO.FileExists(sLang & "\Default.JCF") Then
						iUBound = iUBound + 1
						ReDim Preserve asPaths(iUBound)
						asPaths(iUBound) = sLang
						asPaths(0) = iUBound
					End If
				Next
			End If
		Next
	End If
	SharedJawsSettings = asPaths
End Function

' Function returns an array of paths to all relevant user JAWS settings directories.
' Array item at index 0 is the number of paths, paths start at item at index 1.
' Function takes a parameter as an array of paths
' to all relevant Shared JAWS settings directories (see SharedJawsSettings() function).
Function UserJawsSettings(ByVal asPaths)
	Dim i ' Index of path item in paths array
	Dim sPath ' Path string
	Dim sProgramData ' Path to %PROGRAMDATA% folder
	sProgramData = g_oShell.ExpandEnvironmentStrings("%PROGRAMDATA%")
	Dim sAppData ' Path to %APPDATA% folder
	sAppData = g_oShell.ExpandEnvironmentStrings("%APPDATA%")
	For i = 1 To asPaths(0)
		sPath = asPaths(i)
		' Replace paths to Shared JAWS settings with paths to user JAWS settings
		asPaths(i) = sAppData & Right(sPath, Len(sPath) - Len(sProgramData))
	Next
	UserJawsSettings = asPaths
End Function

' Procedure recursively creates subfolder structure based on path string
Sub CreateFolder(ByVal sPath)
	Dim asFolders ' Array of subfolders structure
	asFolders = Split(sPath, "\")
	' Recursive check and create of entire structure by subfolders
	sPath = asFolders(0)
	Dim i ' Index of subfolder item in subfolders structure array
	For i = 1 To UBound(asFolders)
		sPath = sPath & "\" & asFolders(i)
		If Not g_oFSO.FolderExists(sPath) Then g_oFSO.CreateFolder(sPath)
	Next
End Sub
