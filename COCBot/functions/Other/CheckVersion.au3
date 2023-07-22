; #FUNCTION# ====================================================================================================================
; Name ..........: CheckVersion
; Description ...: Check if we have last version of program
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2015-06)
; Modified ......: CodeSlinger69 (2017), Moebius (07-2023)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2023
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func CheckVersion()

	If not $g_bCheckVersion Then Return

	; Get the last Version from API
	Local $g_sBotGitVersion = ""
	Local $sCorrectStdOut = InetRead("https://api.github.com/repos/MyBotRun/MyBot/releases/latest")
	
	If @error Or $sCorrectStdOut = "" Then Return
	Local $Temp = BinaryToString($sCorrectStdOut)
	
	If $Temp <> "" And Not @error Then
		Local $g_aBotVersionN = StringSplit($g_sBotVersion, " ", 2)
		If @error Then
			Local $g_iBotVersionN = StringReplace($g_sBotVersion, "v", "")
		Else
			Local $g_iBotVersionN = StringReplace($g_aBotVersionN[0], "v", "")
		EndIf
		Local $version = GetLastVersion($Temp)
		$g_sBotGitVersion = StringReplace($version[0], "MBR_v", "")
		SetDebugLog("Last GitHub version is " & $g_sBotGitVersion )
		SetDebugLog("Your version is " & $g_iBotVersionN )

		If _VersionCompare($g_iBotVersionN, $g_sBotGitVersion) = -1 Then
			SetLog("WARNING, YOUR VERSION (" & $g_iBotVersionN & ") IS OUT OF DATE.", $COLOR_INFO)
			Local $ChangelogTXT = GetLastChangeLog($Temp)
			Local $Changelog = StringSplit($ChangelogTXT[0], '\r\n', $STR_ENTIRESPLIT + $STR_NOCOUNT)
			For $i = 0 To UBound($Changelog) - 1
				SetLog($Changelog[$i] )
			Next
			PushMsg("Update")
		ElseIf _VersionCompare($g_iBotVersionN, $g_sBotGitVersion) = 0 Then
			SetLog("WELCOME MASTER, YOU HAVE THE LATEST MYBOT VERSION", $COLOR_SUCCESS)
		Else
			SetLog("YOU ARE USING A CONFIDENTIAL VERSION MASTER !", $COLOR_SUCCESS)
		EndIf
	Else
		SetDebugLog($Temp)
	EndIf

	Local $g_sBotModGitVersion = ""
	Local $sCorrectStdOutMod = InetRead("https://api.github.com/repos/Moebius14/AnuBisMod/releases/latest")
	Local $TempMod = BinaryToString($sCorrectStdOutMod)	

	If $TempMod <> "" And Not @error Then
		Local $g_aBotVersionNMod = StringSplit($g_sBotVersionMod, " ", 2)
		If @error Then
			Local $g_iBotVersionNMod = StringReplace($g_sBotVersionMod, "v", "")
		Else
			Local $g_iBotVersionNMod = StringReplace($g_aBotVersionNMod[0], "v", "")
		EndIf
		Local $versionMod = GetLastVersion($TempMod)
		$g_sBotModGitVersion = StringReplace($versionMod[0], "v", "")
		SetDebugLog("Last GitHub Mod version is " & $g_sBotModGitVersion)
		SetDebugLog("Your version is " & $g_iBotVersionNMod)

		If _VersionCompare($g_iBotVersionNMod, $g_sBotModGitVersion) = -1 Then
			SetLog("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", $COLOR_ERROR)
			SetLog("WARNING, YOUR MOD VERSION (" & $g_iBotVersionNMod & ") IS OUT OF DATE.", $COLOR_ERROR)
			SetLog("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", $COLOR_ERROR)
			Local $ChangelogTXT = GetLastChangeLog($TempMod)
			Local $Changelog = StringSplit($ChangelogTXT[0], '\r\n', $STR_ENTIRESPLIT + $STR_NOCOUNT)
			For $i = 0 To UBound($Changelog) - 1
				SetLog($Changelog[$i] )
			Next
			SetLog(" ", $COLOR_ERROR)
			SetLog("Click Cahaya~Fantasy To Find The Lastest Mod Version", $COLOR_ERROR)
			SetLog(" ", $COLOR_ERROR)
			GUICtrlSetState($g_hPicGreenMod, $GUI_HIDE)
			GUICtrlSetState($g_hPicRedMod, $GUI_SHOW)
			GUICtrlSetState($g_hPicGreyMod, $GUI_HIDE)
			GUICtrlSetData($g_hLblVersionStatusMod, "Out of Date")
			GUICtrlSetFont($g_hLblVersionStatusMod, 7, $FW_BOLD, $GUI_FONTITALIC, "comic sans ms")
			GUICtrlSetColor($g_hLblVersionStatusMod, 0xc70249)
			PushMsg("UpdateMod")
		ElseIf _VersionCompare($g_iBotVersionNMod, $g_sBotModGitVersion) = 0 Then
			SetLog("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", $COLOR_SUCCESS)
			SetLog("~~~~~~YOU HAVE THE LATEST MOD VERSION~~~~~", $COLOR_SUCCESS)
			SetLog("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", $COLOR_SUCCESS)
			SetLog(" ", $COLOR_SUCCESS)
			GUICtrlSetState($g_hPicGreenMod, $GUI_SHOW)
			GUICtrlSetState($g_hPicRedMod, $GUI_HIDE)
			GUICtrlSetState($g_hPicGreyMod, $GUI_HIDE)
			GUICtrlSetData($g_hLblVersionStatusMod, "Up to Date")
			GUICtrlSetFont($g_hLblVersionStatusMod, 7, $FW_BOLD, $GUI_FONTITALIC, "comic sans ms")
			GUICtrlSetColor($g_hLblVersionStatusMod, 0x29a075)
		Else
			GUICtrlSetState($g_hPicGreenMod, $GUI_SHOW)
			GUICtrlSetState($g_hPicRedMod, $GUI_HIDE)
			GUICtrlSetState($g_hPicGreyMod, $GUI_HIDE)
			GUICtrlSetData($g_hLblVersionStatusMod, "V Dev")
			GUICtrlSetFont($g_hLblVersionStatusMod, 7, $FW_BOLD, $GUI_FONTITALIC, "comic sans ms")
			GUICtrlSetColor($g_hLblVersionStatusMod, 0x29a075)
		EndIf
	Else
		GUICtrlSetState($g_hPicGreenMod, $GUI_HIDE)
		GUICtrlSetState($g_hPicRedMod, $GUI_HIDE)
		GUICtrlSetState($g_hPicGreyMod, $GUI_SHOW)
		GUICtrlSetData($g_hLblVersionStatusMod, "")
		SetDebugLog($TempMod)
	EndIf

EndFunc   ;==>CheckVersion

Func CheckVersionStatus()
	Local Static $iLastTimeVersionChecked
	If $g_bFirstStart Then $iLastTimeVersionChecked = ""

	If _DateIsValid($iLastTimeVersionChecked) Then
		Local $iLastCheck =_DateDiff('n', $iLastTimeVersionChecked, _NowCalc()) ; elapse time from last check (minutes)
		SetDebugLog("Version Status LastCheck: " & $iLastTimeVersionChecked & ", Check DateCalc: " & $iLastCheck)
		If $iLastCheck <= 120 Then Return ; Check Every 120 Minutes
	EndIf

	SetDebugLog("Version Status Check", $COLOR_DEBUG2)

	Local $g_sBotModGitVersion = ""
	Local $sCorrectStdOutMod = InetRead("https://api.github.com/repos/Moebius14/AnuBisMod/releases/latest")
	Local $TempMod = BinaryToString($sCorrectStdOutMod)	

	If $TempMod <> "" And Not @error Then
		Local $g_aBotVersionNMod = StringSplit($g_sBotVersionMod, " ", 2)
		If @error Then
			Local $g_iBotVersionNMod = StringReplace($g_sBotVersionMod, "v", "")
		Else
			Local $g_iBotVersionNMod = StringReplace($g_aBotVersionNMod[0], "v", "")
		EndIf
		Local $versionMod = GetLastVersion($TempMod)
		$g_sBotModGitVersion = StringReplace($versionMod[0], "v", "")
		SetDebugLog("Last GitHub Mod version is " & $g_sBotModGitVersion)
		SetDebugLog("Your version is " & $g_iBotVersionNMod)

		If _VersionCompare($g_iBotVersionNMod, $g_sBotModGitVersion) = -1 Then
			GUICtrlSetState($g_hPicGreenMod, $GUI_HIDE)
			GUICtrlSetState($g_hPicRedMod, $GUI_SHOW)
			GUICtrlSetState($g_hPicGreyMod, $GUI_HIDE)
			$g_CheckModVersion = False
			GUICtrlSetData($g_hLblVersionStatusMod, "Out of Date")
			GUICtrlSetFont($g_hLblVersionStatusMod, 7, $FW_BOLD, $GUI_FONTITALIC, "comic sans ms")
			GUICtrlSetColor($g_hLblVersionStatusMod, 0xc70249)
			PushMsg("UpdateMod")
		ElseIf _VersionCompare($g_iBotVersionNMod, $g_sBotModGitVersion) = 0 Then
			GUICtrlSetState($g_hPicGreenMod, $GUI_SHOW)
			GUICtrlSetState($g_hPicRedMod, $GUI_HIDE)
			GUICtrlSetState($g_hPicGreyMod, $GUI_HIDE)
			GUICtrlSetData($g_hLblVersionStatusMod, "Up to Date")
			GUICtrlSetFont($g_hLblVersionStatusMod, 7, $FW_BOLD, $GUI_FONTITALIC, "comic sans ms")
			GUICtrlSetColor($g_hLblVersionStatusMod, 0x29a075)
		Else
			GUICtrlSetState($g_hPicGreenMod, $GUI_SHOW)
			GUICtrlSetState($g_hPicRedMod, $GUI_HIDE)
			GUICtrlSetState($g_hPicGreyMod, $GUI_HIDE)
			GUICtrlSetData($g_hLblVersionStatusMod, "V Dev")
			GUICtrlSetFont($g_hLblVersionStatusMod, 7, $FW_BOLD, $GUI_FONTITALIC, "comic sans ms")
			GUICtrlSetColor($g_hLblVersionStatusMod, 0x29a075)
		EndIf
	Else
		GUICtrlSetState($g_hPicGreenMod, $GUI_HIDE)
		GUICtrlSetState($g_hPicRedMod, $GUI_HIDE)
		GUICtrlSetState($g_hPicGreyMod, $GUI_SHOW)
		GUICtrlSetData($g_hLblVersionStatusMod, "")
		SetDebugLog($TempMod)
	EndIf
	$iLastTimeVersionChecked = _NowCalc()
EndFunc

Func GetLastVersion($txt)
	Return _StringBetween($txt, '"tag_name":"', '","')
EndFunc   ;==>GetLastVersion

Func GetLastChangeLog($txt)
	Local $sChangeLog = _StringBetween($txt, '"body":"', '"}')
	If @error Then $sChangeLog = _StringBetween($txt, '"body":"', '","')
	Return $sChangeLog
EndFunc   ;==>GetLastChangeLog

Func GetVersionNormalized($VersionString, $Chars = 5)
	If StringLeft($VersionString, 1) = "v" Then $VersionString = StringMid($VersionString, 2)
	Local $a = StringSplit($VersionString, ".", 2)
	Local $i
	For $i = 0 To UBound($a) - 1
		If StringLen($a[$i]) < $Chars Then $a[$i] = _StringRepeat("0", $Chars - StringLen($a[$i])) & $a[$i]
	Next
	Return _ArrayToString($a, ".")
EndFunc   ;==>GetVersionNormalized
