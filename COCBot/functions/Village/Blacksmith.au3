; #FUNCTION# ====================================================================================================================
; Name ..........: Blacksmith
; Description ...: Equipment Upgrade V1
; Author ........: Moebius (2023-12)
; Modified ......: Moebius (2024-10)
; Remarks .......: This file is part of MyBot Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Returns True or False
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......:
; ===============================================================================================================================
Local $sSearchEquipmentDiamond = GetDiamondFromRect2(90, 375 + $g_iMidOffsetY, 480, 570 + $g_iMidOffsetY) ; Until 8 Equipment (4 columns)

Func Blacksmith($bTest = False)

	If $g_iTownHallLevel < 8 Then
		Return
	EndIf

	If Not $g_bChkCustomEquipmentOrderEnable Then Return

	If Not $g_bRunState Then Return

	Local Static $iLastTimeChecked[8]
	If $g_bFirstStart Or $IsOresJustCollected Then $iLastTimeChecked[$g_iCurAccount] = ""

	Local $BSTimeDiff ; time remaining for Blacksmith upgrade
	If $g_sBSmithUpgradeTime <> "" And _DateIsValid($g_sBSmithUpgradeTime) Then $BSTimeDiff = _DateDiff('n', _NowCalc(), $g_sBSmithUpgradeTime) ; what is difference between end time and now in minutes?

	; Check if is a valid date
	If _DateIsValid($iLastTimeChecked[$g_iCurAccount]) Then
		Local $iLastCheck = _DateDiff('n', $iLastTimeChecked[$g_iCurAccount], _NowCalc()) ; elapse time from last check (minutes)
		SetDebugLog("Blacksmith LastCheck: " & $iLastTimeChecked[$g_iCurAccount] & ", Check DateCalc: " & $iLastCheck)
		If $g_sBSmithUpgradeTime = "" Then
			; A check each 6 hours [6*60 = 360] Or when star Bonus Received (BS is not upgrading)
			If $iLastCheck <= 360 And Not $StarBonusReceived[0] Then Return
		Else
			If $BSTimeDiff > 0 Then ; (BS is upgrading)
				If $iLastCheck <= 360 And Not $StarBonusReceived[0] Then Return ; A check each 6 hours [6*60 = 360] Or when star Bonus Received. Will be Check when BS upgrade will be finished.
			EndIf
		EndIf
	EndIf

	For $i = 0 To $eEquipmentCount - 1
		If $g_aiCmbCustomEquipmentOrder[$i] = -1 Then
			SetLog("Check Hero Equipment Upgrade Settings!", $COLOR_ERROR)
			Return
		EndIf
	Next

	Local $bCheckChecked = 0
	For $i = 0 To $eEquipmentCount - 1
		If $g_bChkCustomEquipmentOrder[$i] = 0 Then $bCheckChecked += 1
	Next
	If $bCheckChecked = $eEquipmentCount Then
		SetLog("Check Hero Equipment Upgrade Settings!", $COLOR_ERROR)
		Return
	EndIf

	ZoomOut()

	If $g_aiBlacksmithPos[0] <= 0 Or $g_aiBlacksmithPos[1] <= 0 Then
		SetLog("Blacksmith Location unknown!", $COLOR_WARNING)
		LocateBlacksmith() ; Blacksmith location unknown, so find it.
		If $g_aiBlacksmithPos[0] = 0 Or $g_aiBlacksmithPos[1] = 0 Then
			SetLog("Problem locating Blacksmith, re-locate Blacksmith position before proceeding", $COLOR_ERROR)
			Return False
		EndIf
	EndIf

	SetLog("Starting Equipment Auto Upgrade", $COLOR_INFO)

	;Click Blacksmith
	BuildingClickP($g_aiBlacksmithPos, "#0197")

	If Not $g_bRunState Then Return
	If _Sleep(1500) Then Return ; Wait for buttons to appear

	Local $BuildingInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
	If IsArray($BuildingInfo) And UBound($BuildingInfo) > 0 Then
		SetLog("Blacksmith is level " & $BuildingInfo[2])
	EndIf

	If Not FindBSButton(False) Then
		ClearScreen()
		If _Sleep(1000) Then Return
		BuildingClickP($g_aiBlacksmithPos, "#0197") ; Click Blacksmith again. Case when new equipment is gained.
		If _Sleep(1500) Then Return ; Wait for window to open
		If Not FindBSButton() Then Return False ; cant start because we cannot find the Blacksmith button
	EndIf

	If Not IsBlacksmithPage() Then
		SetLog("Failed to open Blacksmith Window!", $COLOR_ERROR)
		Return
	EndIf

	$iLastTimeChecked[$g_iCurAccount] = _NowCalc()
	$StarBonusReceived[0] = 0
	$IsOresJustCollected = 0

	If $g_iTxtCurrentVillageName <> "" Then
		GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Blacksmith : Looking for Equipment upgrade", 1)
	Else
		GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Blacksmith : Looking for Equipment upgrade", 1)
	EndIf
	_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Blacksmith : Looking for Equipment upgrade")

	If Not $g_bRunState Then Return
	If _Sleep(500) Then Return

	OresReport()
	If _Sleep(3000) Then Return

	Local $GetOutNow = False

	For $i = 0 To $eEquipmentCount - 1

		If Not $g_bRunState Then ExitLoop

		If $g_bChkCustomEquipmentOrder[$i] = 0 Then ContinueLoop

		SetLog("Try to upgrade " & $g_asEquipmentOrderList[$g_aiCmbCustomEquipmentOrder[$i]][0], $COLOR_SUCCESS)
		If _Sleep(500) Then Return

		Switch $g_aiCmbCustomEquipmentOrder[$i]
			Case 3 ; Vampstache
				If $BuildingInfo[2] < 3 Then
					SetLog("BlackSmith level 3 needed, looking next", $COLOR_SUCCESS)
					ContinueLoop
				EndIf
			Case 7 ; Giant Arrow
				If $BuildingInfo[2] < 2 Then
					SetLog("BlackSmith level 2 needed, looking next", $COLOR_SUCCESS)
					ContinueLoop
				EndIf
			Case 8 ; Healer Puppet
				If $BuildingInfo[2] < 5 Then
					SetLog("BlackSmith level 5 needed, looking next", $COLOR_SUCCESS)
					ContinueLoop
				EndIf
			Case 12 ; Rage Gem
				If $BuildingInfo[2] < 4 Then
					SetLog("BlackSmith level 4 needed, looking next", $COLOR_SUCCESS)
					ContinueLoop
				EndIf
			Case 13 ; Healing Tome
				If $BuildingInfo[2] < 6 Then
					SetLog("BlackSmith level 6 needed, looking next", $COLOR_SUCCESS)
					ContinueLoop
				EndIf
			Case 17 ; Hog Rider Puppet
				If $BuildingInfo[2] < 7 Then
					SetLog("BlackSmith level 7 needed, looking next", $COLOR_SUCCESS)
					ContinueLoop
				EndIf
			Case 18 ; Haste Vial
				If $BuildingInfo[2] < 8 Then
					SetLog("BlackSmith level 8 needed, looking next", $COLOR_SUCCESS)
					ContinueLoop
				EndIf
		EndSwitch

		Local $ToClickOnHero = False
		If $i = 0 Then
			$ToClickOnHero = True
		Else
			If Not IsBlacksmithPage() Then
				SetLog("Blacksmith Window not found", $COLOR_ERROR)
				If $g_bDebugImageSave Then SaveDebugImage("Blacksmith_Window")
				ClickAway()
				If _Sleep(500) Then Return
				ClickAway()
				Return
			EndIf
			If QuickMIS("BC1", $g_sImgHeroEquipement, 100, 310 + $g_iMidOffsetY, 275, 360 + $g_iMidOffsetY) Then
				If $g_iQuickMISName <> $g_asEquipmentOrderList[$g_aiCmbCustomEquipmentOrder[$i]][2] Then $ToClickOnHero = True
			Else
				SetLog("No Hero head image found", $COLOR_ERROR)
				If $g_bDebugImageSave Then SaveDebugImage("Blacksmith_HeroHead")
				CloseWindow()
				Return
			EndIf
		EndIf

		If $ToClickOnHero Then
			SetDebugLog("Click On " & $g_asEquipmentOrderList[$g_aiCmbCustomEquipmentOrder[$i]][2] & " [" & $g_asEquipmentOrderList[$g_aiCmbCustomEquipmentOrder[$i]][3] & ",375]", $COLOR_DEBUG)
			Click($g_asEquipmentOrderList[$g_aiCmbCustomEquipmentOrder[$i]][3], 345 + $g_iMidOffsetY) ; Click on corresponding Hero
		EndIf

		If Not $g_bRunState Then ExitLoop
		If _Sleep(2000) Then Return

		Local $bLoopNew = 0
		While 1
			If Not $g_bRunState Then ExitLoop
			Local $asSearchResult = decodeSingleCoord(FindImageInPlace2("NewEquipment", $g_sImgEquipmentNew, 90, 375 + $g_iMidOffsetY, 390, 570 + $g_iMidOffsetY, True)) ; Looking for "New" on Equipment
			If IsArray($asSearchResult) And UBound($asSearchResult) = 2 Then
				Click($asSearchResult[0] + 20, $asSearchResult[1] + 40)
				If _Sleep(2000) Then ExitLoop
				Click(600, 380 + $g_iMidOffsetY)     ; Click somewhere to get rid of animation
				If _Sleep(2000) Then ExitLoop
				CloseWindow2()
				If _Sleep(2000) Then ExitLoop
			Else
				ExitLoop
			EndIf
			If _Sleep(150) Then ExitLoop
			$bLoopNew += 1
			If $bLoopNew = 10 Then ExitLoop ; Just in case
		WEnd

		Local $aEquipmentUpgrades = findMultiple($g_sImgEquipmentResearch, $sSearchEquipmentDiamond, $sSearchEquipmentDiamond, 0, 1000, 0, "objectname,objectpoints", True)
		If UBound($aEquipmentUpgrades, 1) >= 1 Then ; if we found any troops
			Local $Exitloop = False
			For $t = 0 To UBound($aEquipmentUpgrades, 1) - 1 ; Loop through found upgrades
				Local $aTempEquipmentArray = $aEquipmentUpgrades[$t] ; Declare Array to Temp Array
				If $aTempEquipmentArray[0] = $g_asEquipmentOrderList[$g_aiCmbCustomEquipmentOrder[$i]][1] Then ; if this is the file we want
					Local $aCoords = decodeSingleCoord($aTempEquipmentArray[1])
					Local $bLoop = 0, $Updated = False
					ClickP($aCoords) ; click equipment
					If Not $g_bRunState Then ExitLoop
					If _Sleep(2000) Then Return
					If Not _ColorCheck(_GetPixelColor(802, 118, True), Hex(0xF38E8D, 6), 20) Then
						SetDebugLog("Close Button of equipment upgrade not found!", $COLOR_DEBUG)
						If $g_bDebugImageSave Then SaveDebugImage("Blacksmith_EquipmentWindow")
						SetLog($g_asEquipmentOrderList[$g_aiCmbCustomEquipmentOrder[$i]][0] & " upgrade window not found", $COLOR_ERROR)
						If _Sleep(1500) Then Return
						ClickAway()
						If _Sleep(500) Then Return
						ContinueLoop 2
					EndIf
					If _ColorCheck(_GetPixelColor(690, 566 + $g_iMidOffsetY, True), Hex(0xABABAB, 6), 20) Then
						SetDebugLog("Grey Upgrade Button detected!", $COLOR_DEBUG)
						SetLog($g_asEquipmentOrderList[$g_aiCmbCustomEquipmentOrder[$i]][0] & " upgrade unavailable", $COLOR_DEBUG)
						If _Sleep(1500) Then Return
						CloseWindow2()
						ContinueLoop 2
					EndIf
					If _ColorCheck(_GetPixelColor(690, 566 + $g_iMidOffsetY, True), Hex(0x3F3A38, 6), 15) Then
						SetDebugLog("Dark Grey Upgrade Button detected!", $COLOR_DEBUG)
						SetLog($g_asEquipmentOrderList[$g_aiCmbCustomEquipmentOrder[$i]][0] & " has reached max level!", $COLOR_DEBUG)
						If _Sleep(1500) Then Return
						$g_bChkCustomEquipmentOrder[$i] = 0
						GUICtrlSetState($g_hChkCustomEquipmentOrder[$i], $GUI_UNCHECKED)
						CloseWindow2()
						ContinueLoop 2
					EndIf
					While 1
						If Not $g_bRunState Then ExitLoop
						If $bTest Then
							SetLog("Test only : Bot won't click on upgrade button", $COLOR_DEBUG)
							If _Sleep(2000) Then Return
							CloseWindow2()
							$Exitloop = True
							ExitLoop
						EndIf
						If _ColorCheck(_GetPixelColor(690, 566 + $g_iMidOffsetY, True), Hex(0xABABAB, 6), 20) Then
							SetDebugLog("Grey Upgrade Button detected!", $COLOR_DEBUG)
							SetLog($g_asEquipmentOrderList[$g_aiCmbCustomEquipmentOrder[$i]][0] & " upgrade unavailable", $COLOR_DEBUG)
							If _Sleep(1500) Then Return
							CloseWindow2()
							$Exitloop = True
							ExitLoop
						EndIf
						If _ColorCheck(_GetPixelColor(690, 566 + $g_iMidOffsetY, True), Hex(0x3F3A38, 6), 15) Then
							SetDebugLog("Dark Grey Upgrade Button detected!", $COLOR_DEBUG)
							SetLog($g_asEquipmentOrderList[$g_aiCmbCustomEquipmentOrder[$i]][0] & " has reached max level!", $COLOR_DEBUG)
							If _Sleep(1500) Then Return
							$g_bChkCustomEquipmentOrder[$i] = 0
							GUICtrlSetState($g_hChkCustomEquipmentOrder[$i], $GUI_UNCHECKED)
							CloseWindow2()
							$Exitloop = True
							ExitLoop
						EndIf
						If UBound(decodeSingleCoord(FindImageInPlace2("RedZero", $g_sImgRedZero, 585, 510 + $g_iMidOffsetY, 825, 570 + $g_iMidOffsetY, True))) > 1 Then
							SetDebugLog("Red zero found in upgrade button", $COLOR_DEBUG)
							SetLog("Not enough resource to upgrade " & $g_asEquipmentOrderList[$g_aiCmbCustomEquipmentOrder[$i]][0], $COLOR_DEBUG2)
							If _Sleep(1500) Then Return
							CloseWindow2()
							If $g_bChkFinishCurrentEquipmentFirst Then ; New : Try next equipment only when current one upgrade is impossible (Maxed or BS up needed).
								$GetOutNow = True
								ExitLoop 2
							Else
								$Exitloop = True
								ExitLoop
							EndIf
						EndIf
						Click(705, 545 + $g_iMidOffsetY, 1, 120, "#0299")     ; Click upgrade buttton
						If _Sleep(1500) Then Return
						If Not $g_bRunState Then ExitLoop
						If UBound(decodeSingleCoord(FindImageInPlace2("RedZero", $g_sImgRedZero, 585, 510 + $g_iMidOffsetY, 825, 570 + $g_iMidOffsetY, True))) > 1 Then
							SetDebugLog("Red zero found in confirm button", $COLOR_DEBUG)
							SetLog("Not enough resource to upgrade " & $g_asEquipmentOrderList[$g_aiCmbCustomEquipmentOrder[$i]][0], $COLOR_DEBUG2)
							If _Sleep(1500) Then Return
							CloseWindow2()
							$Exitloop = True
							ExitLoop
						EndIf
						Click(705, 545 + $g_iMidOffsetY, 1, 120, "#0299")     ; Click upgrade buttton (Confirm)
						If isGemOpen(True) Then
							SetDebugLog("Gem Window Detected", $COLOR_DEBUG)
							SetLog("Not enough resource to upgrade " & $g_asEquipmentOrderList[$g_aiCmbCustomEquipmentOrder[$i]][0], $COLOR_DEBUG2)
							If _Sleep(1500) Then Return
							CloseWindow2()
							$Exitloop = True
							ExitLoop
						EndIf
						SetLog("Equipment successfully upgraded", $COLOR_SUCCESS1)
						$Updated = True
						If $bLoop = 0 Then
							Local $ActionForModLog = $g_asEquipmentOrderList[$g_aiCmbCustomEquipmentOrder[$i]][0]
							If $g_iTxtCurrentVillageName <> "" Then
								GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Blacksmith : " & $ActionForModLog & " successfully upgraded", 1)
							Else
								GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Blacksmith : " & $ActionForModLog & " successfully upgraded", 1)
							EndIf
							_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Blacksmith : " & $ActionForModLog & " successfully upgraded")
						EndIf
						If _Sleep(2000) Then Return
						If _ColorCheck(_GetPixelColor(800, 385 + $g_iMidOffsetY, True), Hex(0x808080, 6), 15) Then
							SetDebugLog("Equipment animation detected", $COLOR_DEBUG)
							Click(600, 380 + $g_iMidOffsetY)     ; Click somewhere to get rid of animation
							If _Sleep(2000) Then Return
						EndIf
						If $bLoop = 10 Then
							SetDebugLog("Something wrong happened", $COLOR_DEBUG)
							$iLastTimeChecked[$g_iCurAccount] = ""
							CloseWindow2()
							If $g_bChkFinishCurrentEquipmentFirst Then ; New : Try next equipment only when current one upgrade is impossible (Maxed or BS up needed).
								$GetOutNow = True
								ExitLoop 2
							Else
								$Exitloop = True
								ExitLoop
							EndIf
						EndIf
						$bLoop += 1
					WEnd
					If Not $g_bRunState Then ExitLoop
					If $Exitloop Then
						If _Sleep(1500) Then Return
						If $Updated Then
							OresReport()
							If _Sleep(3000) Then Return
						EndIf
						ContinueLoop 2
					EndIf
				EndIf
				If _Sleep(500) Then Return
				If $t = UBound($aEquipmentUpgrades, 1) - 1 Then SetLog($g_asEquipmentOrderList[$g_aiCmbCustomEquipmentOrder[$i]][0] & " unavailable", $COLOR_WARNING)
			Next
			If $GetOutNow Then
				If $Updated Then OresReport()
				If _Sleep(1500) Then Return
				ExitLoop
			EndIf
		Else
			SetLog("No Equipment image found", $COLOR_WARNING)
			If $g_bDebugImageSave Then SaveDebugImage("Blacksmith_NoEquipmentFound")
		EndIf
	Next
	If Not $g_bRunState Then Return
	Local $IsinBlacksmith = False
	Local $TimeDiff
	If $g_sBSmithUpgradeTime <> "" Then
		$TimeDiff = _DateDiff('n', _NowCalc(), $g_sBSmithUpgradeTime)
		If $TimeDiff <= 0 Then $IsinBlacksmith = True
	Else
		If $g_sBSmithUpgradeTime = "" Or Not _DateIsValid($g_sBSmithUpgradeTime) Then $IsinBlacksmith = True
	EndIf
	If _Sleep(1000) Then Return
	CloseWindow($IsinBlacksmith)
	SetLog("Equipment Auto Upgrade finished", $COLOR_INFO)
	If _Sleep(500) Then Return
EndFunc   ;==>Blacksmith

Func FindBSButton($bSetLog = True)
	Local $aEquipmentButton = findButton("Equipment", Default, 1, True)
	If IsArray($aEquipmentButton) And UBound($aEquipmentButton, 1) = 2 Then
		ClickP($aEquipmentButton)
		If _Sleep(1000) Then Return ; Wait for window to open
		Return True
	Else
		SetLog("Cannot find Equipment Button" & ($bSetLog = True ? "" : " on first try") & "!", $COLOR_ERROR)
		If $g_bDebugImageSave Then SaveDebugImage("EquipmentButton") ; Debug Only
		ClearScreen()
		Return False
	EndIf
EndFunc   ;==>FindBSButton

Func OresReport()

	Local $ReadShiny = getOresValues(186, 600 + $g_iMidOffsetY)
	Local $aTempReadReadShiny = StringSplit($ReadShiny, "#")
	If IsArray($aTempReadReadShiny) And UBound($aTempReadReadShiny) = 3 Then
		Local $g_ReadCorrect = StringRight($aTempReadReadShiny[2], 3)
		If $aTempReadReadShiny[2] = 0 Or $aTempReadReadShiny[2] = "" Or $aTempReadReadShiny[2] < 10000 Or StringInStr($g_ReadCorrect, 1) Then
			$ReadShiny = getOresValues2(186, 600 + $g_iMidOffsetY)
			$aTempReadReadShiny = StringSplit($ReadShiny, "#")
		EndIf
	Else
		$ReadShiny = getOresValues2(186, 600 + $g_iMidOffsetY)
		$aTempReadReadShiny = StringSplit($ReadShiny, "#")
	EndIf
	Local $ShinyValueActal = 0, $ShinyValueCap = 0
	If IsArray($aTempReadReadShiny) And UBound($aTempReadReadShiny) = 3 Then
		If $aTempReadReadShiny[0] >= 2 Then
			$ShinyValueActal = $aTempReadReadShiny[1]
			$ShinyValueCap = $aTempReadReadShiny[2]
		EndIf
	EndIf

	Local $ReadGlowy = getOresValues(375, 600 + $g_iMidOffsetY)
	Local $aTempReadReadGlowy = StringSplit($ReadGlowy, "#")
	Local $GlowyValueActal = 0, $GlowyValueCap = 0
	If IsArray($aTempReadReadGlowy) And UBound($aTempReadReadGlowy) = 3 Then
		If $aTempReadReadGlowy[0] >= 2 Then
			$GlowyValueActal = $aTempReadReadGlowy[1]
			$GlowyValueCap = $aTempReadReadGlowy[2]
		EndIf
	EndIf

	Local $ReadStarry = getOresValues(567, 600 + $g_iMidOffsetY)
	Local $aTempReadReadStarry = StringSplit($ReadStarry, "#")
	Local $StarryValueActal = 0, $StarryValueCap = 0
	If IsArray($aTempReadReadStarry) And UBound($aTempReadReadStarry) = 3 Then
		If $aTempReadReadStarry[0] >= 2 Then
			$StarryValueActal = $aTempReadReadStarry[1]
			$StarryValueCap = $aTempReadReadStarry[2]
		EndIf
	EndIf

	SetLog("Ores Report")
	SetLog("[Shiny]: " & $ShinyValueActal & "/" & $ShinyValueCap, $COLOR_INFO)
	SetLog("[Glowy]: " & $GlowyValueActal & "/" & $GlowyValueCap, $COLOR_DEBUG)
	SetLog("[Starry]: " & $StarryValueActal & "/" & $StarryValueCap, $COLOR_ACTION)

EndFunc   ;==>OresReport

Func BlacksmithUpTime()
	Local $RemainingTimeMinutes = 0
	Local $BlackSmithUp = FindButton("FinishNow")
	If IsArray($BlackSmithUp) And UBound($BlackSmithUp) = 2 Then
		If ClickB("Info") Then
			If _Sleep(2000) Then Return ; Wait for info window to open
			If _ColorCheck(_GetPixelColor(802, 118, True), Hex(0xF38E8D, 6), 20) Then ; Info window found
				Local $RemainingTime = getBldgUpgradeTime(717, 544 + $g_iMidOffsetY) ; get duration
				$RemainingTimeMinutes = ConvertOCRTime("BSUpgrade", $RemainingTime, False)
				If $RemainingTimeMinutes = 0 Then
					$RemainingTime = getBldgUpgradeTime2(717, 544 + $g_iMidOffsetY) ; get duration
					$RemainingTimeMinutes = ConvertOCRTime("BSUpgrade", $RemainingTime, False)
				EndIf
				Local $StartTime = _NowCalc()
				If $RemainingTimeMinutes > 0 Then
					$g_sBSmithUpgradeTime = _DateAdd('n', Ceiling($RemainingTimeMinutes), $StartTime)
					SetLog("Blacksmith Upgrade Finishes in " & $RemainingTime & " (" & $g_sBSmithUpgradeTime & ")", $COLOR_SUCCESS)
				Else
					SetDebugLog("Remaining time read issue!", $COLOR_DEBUG)
					$g_sBSmithUpgradeTime = ""
				EndIf
				CloseWindow2()
				If _Sleep(1000) Then Return
			Else
				SetDebugLog("Close Button of Blacksmith window not found!", $COLOR_DEBUG)
				$g_sBSmithUpgradeTime = ""
			EndIf
		Else
			SetDebugLog("Info Button not found!", $COLOR_DEBUG)
			$g_sBSmithUpgradeTime = ""
		EndIf
	Else
		$g_sBSmithUpgradeTime = ""
	EndIf
	If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
EndFunc   ;==>BlacksmithUpTime
