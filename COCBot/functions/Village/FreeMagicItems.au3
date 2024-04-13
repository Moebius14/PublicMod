; #FUNCTION# ====================================================================================================================
; Name ..........: Collect Free Magic Items from trader
; Description ...:
; Syntax ........: CollectFreeMagicItems()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (03-2018)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CollectFreeMagicItems($bTest = False)

	If Not $g_bChkCollectFreeMagicItems Or Not $g_bRunState Then Return

	If Not $g_bFirstStartAccountFMI Then
		$IstoRecheckTrader = 0
		$g_bFirstStartAccountFMI = 1
	EndIf

	Local Static $iLastTimeChecked[8] = [0, 0, 0, 0, 0, 0, 0, 0]
	If $iLastTimeChecked[$g_iCurAccount] = @MDAY And Not $bTest And Not $IstoRecheckTrader Then
		SetLog("Next Magic Items Check : Tomorrow", $COLOR_OLIVE)
		Return
	EndIf

	ClickAway()

	If Not IsMainPage() Then Return

	SetLog("Collecting Free Magic Items", $COLOR_INFO)
	If _Sleep($DELAYCOLLECT2) Then Return

	; Check Trader Icon on Main Village

	OpenTraderWindow()
	If $IstoRecheckTrader Then Return

	If Not $g_bRunState Then Return

	$iLastTimeChecked[$g_iCurAccount] = @MDAY

	Local $aOcrPositions[3][2] = [[275, 357], [480, 357], [685, 357]]
	Local $ItemPosition = ""
	Local $Collected = 0
	Local $aResults = GetFreeMagic()
	Local $aGem[3]

	For $t = 0 To UBound($aResults) - 1
		$aGem[$t] = $aResults[$t][0]
	Next

	For $i = 0 To UBound($aResults) - 1
		$ItemPosition = $i + 1
		If Not $bTest Then
			If $aResults[$i][0] = "FREE" Then
				Click($aResults[$i][1], $aResults[$i][2])
				If _Sleep(Random(3000, 4000, 1)) Then Return
				If isGemOpen(True) Then
					SetLog("Free Magic Item Collect Fail! Gem Window popped up!", $COLOR_ERROR)
				EndIf
				SetLog("Free Magic Item Detected On Slot #" & $ItemPosition & "", $COLOR_INFO)
				If WaitforPixel($aOcrPositions[$i][0] + 25, $aOcrPositions[$i][1] - 30, $aOcrPositions[$i][0] + 35, $aOcrPositions[$i][1] - 25, "AD590D", 15, 1) Then
					SetLog("Free Magic Item Collected On Slot #" & $ItemPosition & "", $COLOR_SUCCESS)
					$aGem[$i] = "Collected"
					$ActionForModLog = "Free Magic Item Collected"
					If $g_iTxtCurrentVillageName <> "" Then
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] " & $ActionForModLog, 1)
					Else
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] " & $ActionForModLog, 1)
					EndIf
					_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] " & $ActionForModLog)
					If _Sleep(Random(2000, 4000, 1)) Then Return
					$Collected += 1
				EndIf
			ElseIf $aResults[$i][0] = "FreeFull" Then
				SetLog("Free Magic Item Detected On Slot #" & $ItemPosition & "", $COLOR_INFO)
				SetLog("But Item Can't be Collected, Stock is Full", $COLOR_INFO)
				$aGem[$i] = "Full"
			ElseIf $aResults[$i][0] = "Full" Then
				$aGem[$i] = "Full"
			ElseIf $aResults[$i][0] = "SoldOut" Then
				SetLog("Free Magic Item Detected On Slot #" & $ItemPosition & "", $COLOR_INFO)
				SetLog("But Item Out Of Stock", $COLOR_INFO)
				$aGem[$i] = "Sold Out"
				If _Sleep(Random(2000, 4000, 1)) Then Return
			EndIf
		EndIf
		If Not $g_bRunState Then Return
	Next
	SetLog("Daily Discounts: " & $aGem[0] & " | " & $aGem[1] & " | " & $aGem[2])

	If _Sleep(1000) Then Return
	If $Collected = 0 Then
		SetLog("Nothing Free To Collect!", $COLOR_INFO)
		$ActionForModLog = "No Free Magic Item To Collect"
		If $g_iTxtCurrentVillageName <> "" Then
			GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] " & $ActionForModLog, 1)
		Else
			GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] " & $ActionForModLog, 1)
		EndIf
		_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] " & $ActionForModLog)
	EndIf
	ClickAway()
	If _Sleep(Random(2000, 3000, 1)) Then Return

EndFunc   ;==>CollectFreeMagicItems

Func GetFreeMagic()
	Local $aOcrPositions[3][2] = [[275, 357], [480, 357], [685, 357]]
	Local $aClickFreeItemPositions[3][2] = [[305, 280], [512, 280], [723, 280]]
	Local $aResults[0][3]

	For $i = 0 To UBound($aOcrPositions) - 1

		Local $Read = getOcrAndCapture("coc-freemagicitems", $aOcrPositions[$i][0], $aOcrPositions[$i][1], 60, 25, True)
		If $Read = "FREE" Then
			If WaitforPixel($aOcrPositions[$i][0] + 25, $aOcrPositions[$i][1] - 30, $aOcrPositions[$i][0] + 35, $aOcrPositions[$i][1] - 25, "AD590D", 15, 1) Then
				$Read = "SoldOut"
			EndIf
			If WaitforPixel($aOcrPositions[$i][0] + 33, $aOcrPositions[$i][1] + 30, $aOcrPositions[$i][0] + 35, $aOcrPositions[$i][1] + 31, "969696", 10, 1) Then
				$Read = "FreeFull"
			EndIf
		EndIf
		If $Read = "" Then $Read = "N/A"
		If Number($Read) > 10 Then
			$Read = $Read & " Gems"
			If WaitforPixel($aOcrPositions[$i][0] + 33, $aOcrPositions[$i][1] + 30, $aOcrPositions[$i][0] + 35, $aOcrPositions[$i][1] + 31, "b4b4b4", 10, 1) Then
				$Read = "Full"
			EndIf
		EndIf
		_ArrayAdd($aResults, $Read & "|" & $aClickFreeItemPositions[$i][0] & "|" & $aClickFreeItemPositions[$i][1])
	Next
	Return $aResults
EndFunc   ;==>GetFreeMagic

Func OpenTraderWindow()
	Local $Found = False
	Local $Area[4] = [90, 100 + $g_iMidOffsetY, 210, 210 + $g_iMidOffsetY]
	If $g_iTree = $eTreeMS Or $g_iTree = $eTreeEG Then
		$Area[0] = 120
		$Area[1] = 150 + $g_iMidOffsetY
		$Area[2] = 240
		$Area[3] = 230 + $g_iMidOffsetY
	EndIf
	For $i = 1 To 5
		If QuickMIS("BC1", $g_sImgTrader, $Area[0], $Area[1], $Area[2], $Area[3]) Then
			Click($g_iQuickMISX, $g_iQuickMISY)
			If _Sleep(1500) Then Return
			$IstoRecheckTrader = 0
			$Found = True
			ExitLoop
		EndIf
		If _Sleep(1000) Then Return
	Next
	If Not $Found Then
		SetLog("Trader unavailable", $COLOR_INFO)
		SetLog("Bot will recheck next loop", $COLOR_OLIVE)
		$IstoRecheckTrader = 1
	Else
		Local $aIsWeekyDealsOpen[4] = [40, 0, 0x8DC11D, 20]
		WaitForClanMessage("WeeklyDeals")
		Local $aTabButton = findButton("WeeklyDeals", Default, 1, True)
		If IsArray($aTabButton) And UBound($aTabButton, 1) = 2 Then
			$aIsWeekyDealsOpen[1] = $aTabButton[1]
			If Not _CheckPixel($aIsWeekyDealsOpen, True) Then
				ClickP($aTabButton)
				If Not _WaitForCheckPixel($aIsWeekyDealsOpen, True) Then
					SetLog("Error : Cannot open Gems Menu. Pixel to check did not appear", $COLOR_ERROR)
					CloseWindow()
					Return FuncReturn(SetError(1, 0, False), $g_bDebugSetlog)
				EndIf
			EndIf
		Else
			SetDebugLog("Error when opening Gems Menu: $aTabButton is no valid Array", $COLOR_ERROR)
			CloseWindow()
			Return FuncReturn(SetError(1, 0, False), $g_bDebugSetlog)
		EndIf
	EndIf

	Local $aiDailyDiscount = decodeSingleCoord(findImage("DailyDiscount", $g_sImgDailyDiscountWindow, GetDiamondFromRect("420,105,510,155"), 1, True, Default))
	If Not IsArray($aiDailyDiscount) Or UBound($aiDailyDiscount, 1) < 1 Then
		CloseWindow()
		$IstoRecheckTrader = 1
	EndIf
EndFunc   ;==>OpenTraderWindow

Func OpenMagicItemWindow()
	Local $bRet = False
	Local $bLocateTH = False
	BuildingClick($g_aiTownHallPos[0], $g_aiTownHallPos[1])
	If _Sleep($DELAYBUILDINGINFO1) Then Return

	Local $BuildingInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY)

	If $BuildingInfo[1] = "Town Hall" Then
		SetDebugLog("Opening Magic Item Window")
		If ClickB("MagicItems") Then
			$bRet = True
		EndIf
	Else
		$bLocateTH = True
	EndIf

	If $bLocateTH Then
		SetLog("Town Hall Windows Didn't Open", $COLOR_DEBUG1)
		SetLog("New Try...", $COLOR_DEBUG1)
		ClickAway()
		If _Sleep(Random(1000, 1500, 1)) Then Return
		imglocTHSearch(False, True, True) ;Sets $g_iTownHallLevel
		If _Sleep(Random(1000, 1500, 1)) Then Return
		BuildingClick($g_aiTownHallPos[0], $g_aiTownHallPos[1])
		If _Sleep($DELAYBUILDINGINFO1) Then Return
		Local $BuildingInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY)
		If $BuildingInfo[1] = "Town Hall" Then
			If ClickB("MagicItems") Then
				$bRet = True
			EndIf
		EndIf
	EndIf
	If Not IsMagicItemWindowOpen() Then $bRet = False
	Return $bRet
EndFunc   ;==>OpenMagicItemWindow

Func IsMagicItemWindowOpen()
	Local $bRet = False
	For $i = 1 To 10
		If _ColorCheck(_GetPixelColor(690, 150 + $g_iMidOffsetY, True), "FFFFFF", 20) Then
			$bRet = True
			ExitLoop
		Else
			SetDebugLog("Waiting for FreeMagicWindowOpen #" & $i, $COLOR_ACTION)
		EndIf
		If _Sleep(500) Then Return
	Next
	Return $bRet
EndFunc   ;==>IsMagicItemWindowOpen
