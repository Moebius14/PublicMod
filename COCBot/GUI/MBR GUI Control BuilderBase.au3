; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Misc
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: MyBot.run team
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2023
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func chkEnableBBAttack()
	If GUICtrlRead($g_hChkEnableBBAttack) = $GUI_CHECKED Then
		GUICtrlSetState($g_hChkBBTrophyRange, $GUI_ENABLE)
		GUICtrlSetState($g_hChkBBAttIfLootAvail, $GUI_ENABLE)
		GUICtrlSetState($g_hChkBBWaitForMachine, $GUI_ENABLE)
		GUICtrlSetState($g_hChkBBHaltOnResourcesFull, $GUI_ENABLE)
		GUICtrlSetState($g_hBtnBBDropOrder, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbBBSameTroopDelay, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbBBNextTroopDelay, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbBBAttackCount, $GUI_ENABLE)
		GUICtrlSetState($g_hChkForceBBAttackOnClanGames, $GUI_ENABLE)
		GUICtrlSetState($g_hChkBBAttackForDailyChallenge, $GUI_ENABLE)
		chkBBTrophyRange()
		cmbBBAttackCount()
	Else
		GUICtrlSetState($g_hChkBBTrophyRange, $GUI_DISABLE)
		GUICtrlSetState($g_hChkBBAttIfLootAvail, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtBBTrophyLowerLimit, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtBBTrophyUpperLimit, $GUI_DISABLE)
		GUICtrlSetState($g_hChkBBWaitForMachine, $GUI_DISABLE)
		GUICtrlSetState($g_hChkBBHaltOnResourcesFull, $GUI_DISABLE)
		GUICtrlSetState($g_hBtnBBDropOrder, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbBBSameTroopDelay, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbBBNextTroopDelay, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbBBAttackCount, $GUI_DISABLE)
		GUICtrlSetState($g_hChkForceBBAttackOnClanGames, $GUI_DISABLE)
		GUICtrlSetState($g_hChkBBAttackForDailyChallenge, $GUI_DISABLE)
	EndIf
EndFunc

Func ChkBBAttackForDailyChallenge()
	If GUICtrlRead($g_hChkBBAttackForDailyChallenge) = $GUI_CHECKED Then
		GUICtrlSetState($g_hChkBBAttIfLootAvail, $GUI_DISABLE)
		GUICtrlSetState($g_hChkBBHaltOnResourcesFull, $GUI_DISABLE)
		GUICtrlSetState($g_hChkBBWaitForMachine, $GUI_DISABLE)
	Else
		If GUICtrlRead($g_hChkEnableBBAttack) = $GUI_CHECKED Then
			GUICtrlSetState($g_hChkBBAttIfLootAvail, $GUI_ENABLE)
			GUICtrlSetState($g_hChkBBWaitForMachine, $GUI_ENABLE)
			GUICtrlSetState($g_hChkBBHaltOnResourcesFull, $GUI_ENABLE)
		EndIf
	EndIf
EndFunc

Func chkUpgradeDoubleCannon()

	If GUICtrlRead($g_hChkDoubleCannonUpgrade) = $GUI_CHECKED Then
		_GUICtrlTab_ClickTab($g_hTabMain, 0)

		SetLog("Please wait ......", $COLOR_OLIVE)
		SetLog("Checking for valid Coordinates of Double Cannon ......", $COLOR_OLIVE)

		$g_bDoubleCannonUpgrade = True
		LocateDoubleCannon()
	Else
		$g_bDoubleCannonUpgrade = False
		GUICtrlSetState($g_hChkDoubleCannonUpgrade, $GUI_UNCHECKED)
	EndIf

	Return
EndFunc   ;==>chkUpgradeDoubleCannon

Func chkUpgradeArcherTower()

	If GUICtrlRead($g_hChkArcherTowerUpgrade) = $GUI_CHECKED Then
		_GUICtrlTab_ClickTab($g_hTabMain, 0)

		SetLog("Please wait ......", $COLOR_OLIVE)
		SetLog("Checking for valid Coordinates of Archer Tower ......", $COLOR_OLIVE)

		$g_bArcherTowerUpgrade = True
		LocateArcherTower()
	Else
		$g_bArcherTowerUpgrade = False
	EndIf

	Return
EndFunc   ;==>chkUpgradeArcherTower

Func chkUpgradeMultiMortar()

	If GUICtrlRead($g_hChkMultiMortarUpgrade) = $GUI_CHECKED Then
		_GUICtrlTab_ClickTab($g_hTabMain, 0)

		SetLog("Please wait ......", $COLOR_OLIVE)
		SetLog("Checking for valid Coordinates of Multi Mortar ......", $COLOR_OLIVE)

		$g_bMultiMortarUpgrade = True
		LocateMultiMortar()
	Else
		$g_bMultiMortarUpgrade = False
	EndIf

	Return
EndFunc   ;==>chkUpgradeMultiMortar

Func chkUpgradeMegaTesla()

	If GUICtrlRead($g_hChkMegaTeslaUpgrade) = $GUI_CHECKED Then
		_GUICtrlTab_ClickTab($g_hTabMain, 0)

		SetLog("Please wait ......", $COLOR_OLIVE)
		SetLog("Checking for valid Coordinates of Mega Tesla ......", $COLOR_OLIVE)

		$g_bMegaTeslaUpgrade = True
		LocateMegaTesla()
	Else
		$g_bMegaTeslaUpgrade = False
	EndIf

	Return
 EndFunc   ;==>chkUpgradeMegaTesla

Func cmbBBAttackCount()
	$g_iBBAttackCount = _GUICtrlComboBox_GetCurSel($g_hCmbBBAttackCount)
	SetDebugLog("BB Attack Count: " & $g_iBBAttackCount, $COLOR_DEBUG)
	If _GUICtrlComboBox_GetCurSel($g_hCmbBBAttackCount) = 0 Then
		SetDebugLog("Enabling Check Loot Available", $COLOR_DEBUG)
		GUICtrlSetState($g_hChkBBAttIfLootAvail, $GUI_CHECKED)
		GUICtrlSetState($g_hChkBBAttIfLootAvail, $GUI_DISABLE)
	Else
		GUICtrlSetState($g_hChkBBAttIfLootAvail, $GUI_ENABLE)
	EndIf
	ChkBBAttackForDailyChallenge()
EndFunc

Func cmbBBNextTroopDelay()
	$g_iBBNextTroopDelay = $g_iBBNextTroopDelayDefault + ((_GUICtrlComboBox_GetCurSel($g_hCmbBBNextTroopDelay) + 1) - 5) * $g_iBBNextTroopDelayIncrement ; +- n*increment
	SetDebugLog("Next Troop Delay: " & $g_iBBNextTroopDelay)
	SetDebugLog((_GUICtrlComboBox_GetCurSel($g_hCmbBBNextTroopDelay) + 1) - 5)
EndFunc   ;==>cmbBBNextTroopDelay

Func cmbBBSameTroopDelay()
	$g_iBBSameTroopDelay = $g_iBBSameTroopDelayDefault + ((_GUICtrlComboBox_GetCurSel($g_hCmbBBSameTroopDelay) + 1) - 5) * $g_iBBSameTroopDelayIncrement ; +- n*increment
	SetDebugLog("Same Troop Delay: " & $g_iBBSameTroopDelay)
	SetDebugLog((_GUICtrlComboBox_GetCurSel($g_hCmbBBSameTroopDelay) + 1) - 5)
EndFunc   ;==>cmbBBSameTroopDelay

Func chkBBTrophyRange()
	If GUICtrlRead($g_hChkBBTrophyRange) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtBBTrophyLowerLimit, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtBBTrophyUpperLimit, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hTxtBBTrophyLowerLimit, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtBBTrophyUpperLimit, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkBBTrophyRange

Func btnBBDropOrder()
	GUICtrlSetState($g_hBtnBBDropOrder, $GUI_DISABLE)
	GUICtrlSetState($g_hChkEnableBBAttack, $GUI_DISABLE)
	GUISetState(@SW_SHOW, $g_hGUI_BBDropOrder)
EndFunc   ;==>btnBBDropOrder

Func chkBBDropOrder()
	If GUICtrlRead($g_hChkBBCustomDropOrderEnable) = $GUI_CHECKED Then
		GUICtrlSetState($g_hBtnBBDropOrderSet, $GUI_ENABLE)
		GUICtrlSetState($g_hBtnBBRemoveDropOrder, $GUI_ENABLE)
		For $i = 0 To $g_iBBTroopCount - 1
			GUICtrlSetState($g_ahCmbBBDropOrder[$i], $GUI_ENABLE)
		Next
	Else
		GUICtrlSetState($g_hBtnBBDropOrderSet, $GUI_DISABLE)
		GUICtrlSetState($g_hBtnBBRemoveDropOrder, $GUI_DISABLE)
		For $i = 0 To $g_iBBTroopCount - 1
			GUICtrlSetState($g_ahCmbBBDropOrder[$i], $GUI_DISABLE)
		Next
		GUICtrlSetBkColor($g_hBtnBBDropOrder, $COLOR_RED)
		$g_bBBDropOrderSet = False
	EndIf
EndFunc   ;==>chkBBDropOrder

Func GUIBBDropOrder()
	Local $iGUI_CtrlId = @GUI_CtrlId
	Local $iDropIndex = _GUICtrlComboBox_GetCurSel($iGUI_CtrlId)

	For $i = 0 To $g_iBBTroopCount - 1
		If $iGUI_CtrlId = $g_ahCmbBBDropOrder[$i] Then ContinueLoop
		If $iDropIndex = _GUICtrlComboBox_GetCurSel($g_ahCmbBBDropOrder[$i]) Then
			_GUICtrlComboBox_SetCurSel($g_ahCmbBBDropOrder[$i], -1)
			GUISetState()
		EndIf
	Next
EndFunc   ;==>GUIBBDropOrder

Func BtnBBDropOrderSet()
	$g_sBBDropOrder = ""
	; loop through reading and disabling all combo boxes
	For $i = 0 To $g_iBBTroopCount - 1
		GUICtrlSetState($g_ahCmbBBDropOrder[$i], $GUI_DISABLE)
		If GUICtrlRead($g_ahCmbBBDropOrder[$i]) = "" Then ; if not picked assign from default list in order
			Local $asDefaultOrderSplit = StringSplit($g_sBBDropOrderDefault, "|")
			Local $bFound = False, $bSet = False
			Local $j = 0
			While $j < $g_iBBTroopCount And Not $bSet ; loop through troops
				Local $k = 0
				While $k < $g_iBBTroopCount And Not $bFound ; loop through handles
					If $g_ahCmbBBDropOrder[$i] <> $g_ahCmbBBDropOrder[$k] Then
						SetDebugLog("Word: " & $asDefaultOrderSplit[$j + 1] & " " & " Word in slot: " & GUICtrlRead($g_ahCmbBBDropOrder[$k]))
						If $asDefaultOrderSplit[$j + 1] = GUICtrlRead($g_ahCmbBBDropOrder[$k]) Then $bFound = True
					EndIf
					$k += 1
				WEnd
				If Not $bFound Then
					_GUICtrlComboBox_SetCurSel($g_ahCmbBBDropOrder[$i], $j)
					$bSet = True
				Else
					$j += 1
					$bFound = False
				EndIf
			WEnd
		EndIf
		$g_sBBDropOrder &= (GUICtrlRead($g_ahCmbBBDropOrder[$i]) & "|")
		SetDebugLog("DropOrder: " & $g_sBBDropOrder)
	Next
	$g_sBBDropOrder = StringTrimRight($g_sBBDropOrder, 1) ; Remove last '|'
	GUICtrlSetBkColor($g_hBtnBBDropOrder, $COLOR_GREEN)
	$g_bBBDropOrderSet = True
EndFunc   ;==>BtnBBDropOrderSet

Func BtnBBRemoveDropOrder()
	For $i = 0 To $g_iBBTroopCount - 1
		_GUICtrlComboBox_SetCurSel($g_ahCmbBBDropOrder[$i], -1)
		GUICtrlSetState($g_ahCmbBBDropOrder[$i], $GUI_ENABLE)
	Next
	GUICtrlSetBkColor($g_hBtnBBDropOrder, $COLOR_RED)
	$g_bBBDropOrderSet = False
EndFunc   ;==>BtnBBRemoveDropOrder

Func CloseCustomBBDropOrder()
	GUISetState(@SW_HIDE, $g_hGUI_BBDropOrder)
	GUICtrlSetState($g_hBtnBBDropOrder, $GUI_ENABLE)
	GUICtrlSetState($g_hChkEnableBBAttack, $GUI_ENABLE)
EndFunc   ;==>CloseCustomBBDropOrder