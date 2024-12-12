; #FUNCTION# ====================================================================================================================
; Name ..........: CheckOverviewFullArmy
; Description ...: Checks if the army is full on the training overview screen
; Syntax ........: CheckOverviewFullArmy([$bOpenArmyWindow = False])
; Parameters ....: $bOpenArmyWindow  = Bool value true if train overview window needs to be opened
;				 : $bCloseArmyWindow = Bool value, true if train overview window needs to be closed
; Return values .: None
; Author ........: KnowJack (07-2015)
; Modified ......: MonkeyHunter (03-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CheckOverviewFullArmy($bOpenArmyWindow = False, $bCloseArmyWindow = False)

	;;;;;; Checks for full army using the green sign in army overview window ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;; Will only get full army when the maximum capacity of your camps are reached regardless of the full army percentage you input in GUI ;;;;;;;;;
	;;;;;; Use this only in halt attack mode and if an error happened in reading army current number Or Max capacity ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	If $bOpenArmyWindow Then
		If _Sleep($DELAYCHECKFULLARMY1) Then Return
		Click($aArmyTrainButton[0], $aArmyTrainButton[1], 1, 120, "#0347") ; Click Button Army Overview
		If _Sleep($DELAYCHECKFULLARMY2) Then Return
		Local $j = 0
		While Not _ColorCheck(_GetPixelColor(180, 145 + $g_iMidOffsetY, True), Hex(0xECECE5, 6), 20) ; "ARMY tab"
			If $g_bDebugSetLogTrain Then SetLog("OverView TabColor=" & _GetPixelColor(180, 145 + $g_iMidOffsetY, True), $COLOR_DEBUG)
			If _Sleep($DELAYCHECKFULLARMY1) Then Return ; wait for Train Window to be ready.
			$j += 1
			If $j > 15 Then ExitLoop
		WEnd
		If $j > 15 Then
			SetLog("Army Window didn't open", $COLOR_ERROR)
			Return
		EndIf
	EndIf

	If _sleep($DELAYCHECKFULLARMY2) Then Return
	Local $Pixel = _CheckPixel($aIsCampFull, True) And _ColorCheck(_GetPixelColor(89, 179 + $g_iMidOffsetY, True), Hex(0x87BA26, 6), 20)
	If Not $Pixel Then
		If _sleep($DELAYCHECKFULLARMY2) Then Return
		$Pixel = _CheckPixel($aIsCampFull, True) And _ColorCheck(_GetPixelColor(89, 179 + $g_iMidOffsetY, True), Hex(0x87BA26, 6), 20)
	EndIf

	If $g_bDebugSetLogTrain Then SetLog("Checking Overview for full army [!] " & $Pixel & ", " & _GetPixelColor(40, 150 + $g_iMidOffsetY, True), $COLOR_DEBUG)
	If $Pixel Then
		$g_bFullArmy = True
	EndIf

	$g_bCanRequestCC = _ColorCheck(_GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1] + 10, True), Hex($aRequestTroopsAO[3], 6), $aRequestTroopsAO[5]) And _ColorCheck(_GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True), Hex($aRequestTroopsAO[4], 6), $aRequestTroopsAO[5])
	SetDebugLog("Can Request CC: " & $g_bCanRequestCC, $COLOR_DEBUG)

	If $bCloseArmyWindow Then
		CloseWindow()
		If _Sleep($DELAYCHECKFULLARMY3) Then Return
	EndIf

EndFunc   ;==>CheckOverviewFullArmy
