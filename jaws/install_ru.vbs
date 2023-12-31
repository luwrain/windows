' Copyright (C) 2023 Nikita Tseykovets <tseikovets@rambler.ru>
' SPDX-License-Identifier: MIT
' This software is distributed under the MIT License. See LICENSE.txt file.

' File encoding is UTF-16 Little Endian (with BOM)
' Translatable message strings for Russian localization
' Message: "JAWS Settings for LUWRAIN Application"
msgTitle = "Настройки JAWS для приложения LUWRAIN"
' Message: "Automatic installation script file not found at path"
msgInstallNotFound = "Файл скрипта автоматической установки не найден по пути"
' Message: "Application settings file not found at path"
msgSettingsNotFound = "Файл настроек приложения не найден по пути"
' Message: "Are you sure you want to add the application settings to all JAWS versions detected on the system and for all JAWS localization languages?"
msgConfirmationDialog = "Вы уверены, что хотите добавить настройки приложения во все обнаруженные в системе версии JAWS и для всех языков локализации JAWS?"
' Message: "Not a single JAWS profiles was found on the system."
msgProfilesNotFound = "В системе не обнаружено ни одного профиля JAWS."
' Message: "Application settings have been added to %1 JAWS profiles at the following paths:"
msgSettingsAdded = "Настройки для приложения добавлены в %1 профилей JAWS по следующим путям:"

' All following code does not need localization
' and can be used without modification to prepare other localization files.

RunInstallation

' Procedure runs main installation script.
Sub RunInstallation()
	Dim oFSO ' Standart FileSystemObject object of WSH
	Set oFSO = CreateObject("Scripting.FileSystemObject")
	Dim sInstall ' Path to automatic installation script file
	sInstall = oFSO.GetParentFolderName(WScript.ScriptFullName) & "\install.vbs"
	' Check integrity of script delivery package
	If oFSO.FileExists(sInstall) Then
		' Run main script file
		Include sInstall, oFSO
	Else
		If LCase(oFSO.GetFileName(WScript.FullName)) = "wscript.exe" Then
			MsgBox msgInstallNotFound & vbCrLf & sInstall, vbOKOnly + vbCritical, msgTitle
		Else
			WScript.StdErr.WriteLine msgInstallNotFound & vbCrLf & sInstall
		End If
		WScript.Quit
	End If
End Sub

' Procedure includes external script file.
Sub Include(sFile, oFSO)
	Dim oFile ' Object of included file
	Set oFile = oFSO.OpenTextFile(sFile)
	ExecuteGlobal oFile.ReadAll
	oFile.Close
End Sub
