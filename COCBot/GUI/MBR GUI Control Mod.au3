; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Moebius14 (2021)
; Modified ......: 2024
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;~ -------------------------------------------------------------
; Mod Tabs
;~ -------------------------------------------------------------
Func chkUseBotHumanization()
	If GUICtrlRead($g_hChkUseBotHumanization) = $GUI_CHECKED Then
		$g_bUseBotHumanization = True
		For $i = $g_IsRefusedFriends To $g_hChkWarSignUp
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		ChkForumRequestOnly()
		ChkWarSignUp()
		For $i = $g_HowManyinCWLabel To $g_HowManyinCWLCombo
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		$g_bUseBotHumanization = False
		For $i = $g_IsRefusedFriends To $g_acmbPriority[10]
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		For $i = $g_hChkWarSignUp To $hRefuseWar
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		For $i = $g_HowManyinCWLabel To $g_HowManyinCWLCombo
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>chkUseBotHumanization

Func ChkForumRequestOnly()
	If GUICtrlRead($g_hChkForumRequestOnly) = $GUI_CHECKED Then
		$g_bForumRequestOnly = True
		GUICtrlSetState($g_hBtnWelcomeMessage, $GUI_ENABLE)
		chkUseWelcomeMessage()
	Else
		$g_bForumRequestOnly = False
		GUICtrlSetState($g_hBtnWelcomeMessage, $GUI_DISABLE)
	EndIf
EndFunc   ;==>ChkForumRequestOnly

Func DisplayChkNoLabCheck()
	Switch _GUICtrlComboBox_GetCurSel($g_hChkNoLabCheck)
		Case 0
			$g_hChkNoLabCheckLabelTypo = "Never Check Laboratory"
		Case 1
			$g_hChkNoLabCheckLabelTypo = "Check Laboratory Just One Time"
		Case 2
			$g_hChkNoLabCheckLabelTypo = "Check Regulary (2->5 hours)"
	EndSwitch
	GUICtrlSetData($g_hChkNoLabCheckLabel, $g_hChkNoLabCheckLabelTypo)
EndFunc   ;==>DisplayChkNoLabCheck

Func DisplayChkNoPetHouseCheck()
	Switch _GUICtrlComboBox_GetCurSel($g_hChkNoPetHouseCheck)
		Case 0
			$g_hChkNoPetHouseCheckLabelTypo = "Never Check Pet House"
		Case 1
			$g_hChkNoPetHouseCheckLabelTypo = "Check Pet House Just One Time"
		Case 2
			$g_hChkNoPetHouseCheckLabelTypo = "Check Regulary (2->5 hours)"
	EndSwitch
	If $g_iTownHallLevel > 13 Then ; Must be TH14 to Have Pet House
		GUICtrlSetState($g_hChkNoPetHouseCheck, $GUI_ENABLE)
	ElseIf $g_iTownHallLevel > 0 And $g_iTownHallLevel < 14 Then
		GUICtrlSetData($g_hChkNoPetHouseCheck, "Never")
		_Ini_Add("Advanced", "NoPetHouseCheck", 0)
		GUICtrlSetState($g_hChkNoPetHouseCheck, $GUI_DISABLE)
		$g_hChkNoPetHouseCheckLabelTypo = "TownHall Is Not Level 14"
	ElseIf $g_iTownHallLevel = 0 Then
		GUICtrlSetData($g_hChkNoPetHouseCheck, "Never")
		_Ini_Add("Advanced", "NoPetHouseCheck", 0)
		GUICtrlSetState($g_hChkNoPetHouseCheck, $GUI_DISABLE)
		$g_hChkNoPetHouseCheckLabelTypo = "TH Level 14 Required, Please Locate TH"
	EndIf
	GUICtrlSetData($g_hChkNoPetHouseCheckLabel, $g_hChkNoPetHouseCheckLabelTypo)
EndFunc   ;==>DisplayChkNoPetHouseCheck

Func DisplayChkNoStarLabCheck()
	Switch _GUICtrlComboBox_GetCurSel($g_hChkNoStarLabCheck)
		Case 0
			$g_hChkNoStarLabCheckLabelTypo = "Never Check StarLab"
		Case 1
			$g_hChkNoStarLabCheckLabelTypo = "Check StarLab Just One Time"
		Case 2
			$g_hChkNoStarLabCheckLabelTypo = "Check Regulary (2->5 hours)"
	EndSwitch
	GUICtrlSetData($g_hChkNoStarLabCheckLabel, $g_hChkNoStarLabCheckLabelTypo)
EndFunc   ;==>DisplayChkNoStarLabCheck

Func BBaseFrequencyDatas()
	If _GUICtrlComboBox_GetCurSel($g_hCmbPriorityBBaseFrequency) = 0 Then
		GUICtrlSetState($g_hcmbAdvancedVariation, $GUI_DISABLE)
	Else
		If GUICtrlRead($g_hChkBBaseFrequency) = $GUI_CHECKED Then GUICtrlSetState($g_hcmbAdvancedVariation, $GUI_ENABLE)
	EndIf
EndFunc   ;==>BBaseFrequencyDatas

Func ChkBBaseFrequency()
	If GUICtrlRead($g_hChkBBaseFrequency) = $GUI_CHECKED Then
		$g_bChkBBaseFrequency = True
		For $i = $g_hChkBBaseFrequencyLabel To $g_hcmbAdvancedVariation
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		$g_bChkBBaseFrequency = False
		For $i = $g_hChkBBaseFrequencyLabel To $g_hcmbAdvancedVariation
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>ChkBBaseFrequency

Func ChkCollectRewards()
	If GUICtrlRead($g_hChkCollectRewards) = $GUI_CHECKED And GUICtrlRead($g_hChkEventCollect) = $GUI_CHECKED Then
		GUICtrlSetState($g_hChkSellRewards, $GUI_ENABLE)
	ElseIf GUICtrlRead($g_hChkCollectRewards) = $GUI_UNCHECKED And GUICtrlRead($g_hChkEventCollect) = $GUI_CHECKED Then
		GUICtrlSetState($g_hChkSellRewards, $GUI_ENABLE)
	ElseIf GUICtrlRead($g_hChkCollectRewards) = $GUI_CHECKED And GUICtrlRead($g_hChkEventCollect) = $GUI_UNCHECKED Then
		GUICtrlSetState($g_hChkSellRewards, $GUI_ENABLE)
	ElseIf GUICtrlRead($g_hChkCollectRewards) = $GUI_UNCHECKED And GUICtrlRead($g_hChkEventCollect) = $GUI_UNCHECKED Then
		GUICtrlSetState($g_hChkSellRewards, $GUI_DISABLE)
	EndIf
EndFunc   ;==>ChkCollectRewards

Func SwitchBetweenBasesMod()
	If Not $g_bFirstStartAccountSBB Then
		$IstoSwitchMod = 0
		$BBaseCheckTimer = 0
		$DelayReturnedtocheckBBaseMS = 0
		$g_bFirstStartAccountSBB = 1
	EndIf

	$g_iCmbPriorityBBaseFrequency = _GUICtrlComboBox_GetCurSel($g_hCmbPriorityBBaseFrequency) * 60 * 60 * 1000
	$g_icmbAdvancedVariation = _GUICtrlComboBox_GetCurSel($g_hcmbAdvancedVariation) / 10

	If Not $g_bChkCollectBuilderBase And Not $g_bChkStartClockTowerBoost And Not $g_iChkBBSuggestedUpgrades And Not $g_bChkEnableBBAttack And Not $g_bChkCleanBBYard Then
		If $g_bIsBBevent Then SetLog("Please Enable BB Attack To Complete Challenge !", $COLOR_ERROR)
		$IstoSwitchMod = 0
		Return
	EndIf

	If $g_bIsBBevent And Not $g_bChkEnableBBAttack Then
		SetLog("Please Enable BB Attack To Complete Challenge !", $COLOR_ERROR)
		$IstoSwitchMod = 0
		Return
	EndIf

	If $g_bChkUseBuilderJar Then
		If $g_IsBuilderJarAvl And $g_iCmbBuilderJar > 0 And Not $g_bIsBBevent Then

			SetLog("Time to Check Builder Base", $COLOR_OLIVE)
			SetLog("Let's Use Builder Star Jar", $COLOR_ACTION)

			If Not _DateIsValid($BBaseCheckTimer) And ($g_bChkBBaseFrequency And $g_iCmbPriorityBBaseFrequency > 0) Then $BBaseCheckTimer = _NowCalc()

			If $g_bChkBBaseFrequency And $g_iCmbPriorityBBaseFrequency > 0 Then

				Local $DelayReturnedtocheckBBaseInf = ($g_iCmbPriorityBBaseFrequency - ($g_iCmbPriorityBBaseFrequency * $g_icmbAdvancedVariation))
				Local $DelayReturnedtocheckBBaseSup = ($g_iCmbPriorityBBaseFrequency + ($g_iCmbPriorityBBaseFrequency * $g_icmbAdvancedVariation))
				$DelayReturnedtocheckBBaseMS = Random($DelayReturnedtocheckBBaseInf, $DelayReturnedtocheckBBaseSup, 1)

				Local $iWaitTime = $DelayReturnedtocheckBBaseMS
				Local $sWaitTime = ""
				Local $iMin, $iHour, $iWaitSec

				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
				SetLog("Next Regular Switch To Builder Base : " & $sWaitTime & "", $COLOR_OLIVE)

			EndIf

			$IstoSwitchMod = 1
			Return

		EndIf
	EndIf

	If $g_bIsBBevent Then
		If $g_bChkBBMaxEventsInARow And ProfileSwitchAccountEnabled() Then
			If Number($g_aiAttackedBBEventCount) > Number($g_aiLimitBBEventCount) And Number($g_aiLimitBBEventCount) > 0 Then
				$IstoSwitchMod = 0
				Return
			EndIf
		EndIf
	EndIf

	If Not $g_bChkBBaseFrequency Then ; Return True and End fonction Without Timing
		If ($g_bChkEnableForgeBBGold Or $g_bChkEnableForgeBBElix) And ($g_aiCurrentLootBB[$eLootGoldBB] = 0 Or $g_aiCurrentLootBB[$eLootElixirBB] = 0) Then
			$IstoSwitchMod = 1
			Return
		EndIf
		If Not $g_bIsBBevent Then IsBBDailyChallengeAvailable()
		$IstoSwitchMod = 1
		Return

	ElseIf $g_bChkBBaseFrequency Then ; Cases Check Frequency enable

		If $g_iCmbPriorityBBaseFrequency = 0 Then ; Case Everytime, Return True and End fonction Without Timing
			If Not $g_bIsBBevent Then IsBBDailyChallengeAvailable()
			$IstoSwitchMod = 1
			Return
		EndIf

		If Not _DateIsValid($BBaseCheckTimer) And Not $g_bIsBBevent Then ; First Time

			$BBaseCheckTimer = _NowCalc()

			Local $DelayReturnedtocheckBBaseInf = ($g_iCmbPriorityBBaseFrequency - ($g_iCmbPriorityBBaseFrequency * $g_icmbAdvancedVariation))
			Local $DelayReturnedtocheckBBaseSup = ($g_iCmbPriorityBBaseFrequency + ($g_iCmbPriorityBBaseFrequency * $g_icmbAdvancedVariation))
			$DelayReturnedtocheckBBaseMS = Random($DelayReturnedtocheckBBaseInf, $DelayReturnedtocheckBBaseSup, 1)

			Local $iWaitTime = $DelayReturnedtocheckBBaseMS
			Local $sWaitTime = ""
			Local $iMin, $iHour, $iWaitSec

			$iWaitSec = Round($iWaitTime / 1000)
			$iHour = Floor(Floor($iWaitSec / 60) / 60)
			$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
			If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
			If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
			SetLog("Time to Check Builder Base", $COLOR_OLIVE)
			SetLog("Next Builder Base Check : " & $sWaitTime & "", $COLOR_OLIVE)
			IsBBDailyChallengeAvailable()
			$IstoSwitchMod = 1
			Return
		EndIf

		If $g_bIsBBevent Then ; Case BB Event Detected
			SetLog("BB Event Detected : Time to Switch To Builder Base", $COLOR_OLIVE)
			$BBaseCheckTimer = _NowCalc()

			Local $DelayReturnedtocheckBBaseInf = ($g_iCmbPriorityBBaseFrequency - ($g_iCmbPriorityBBaseFrequency * $g_icmbAdvancedVariation))
			Local $DelayReturnedtocheckBBaseSup = ($g_iCmbPriorityBBaseFrequency + ($g_iCmbPriorityBBaseFrequency * $g_icmbAdvancedVariation))
			$DelayReturnedtocheckBBaseMS = Random($DelayReturnedtocheckBBaseInf, $DelayReturnedtocheckBBaseSup, 1)

			Local $iWaitTime = $DelayReturnedtocheckBBaseMS
			Local $sWaitTime = ""
			Local $iMin, $iHour, $iWaitSec

			$iWaitSec = Round($iWaitTime / 1000)
			$iHour = Floor(Floor($iWaitSec / 60) / 60)
			$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
			If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
			If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
			SetLog("Next Regular Switch To Builder Base : " & $sWaitTime & "", $COLOR_OLIVE)
			$IstoSwitchMod = 1
			Return
		EndIf

		If _DateIsValid($BBaseCheckTimer) Then
			Local $BBaseCheckTimerDiff = _DateDiff('s', $BBaseCheckTimer, _NowCalc()) * 1000 ; ms

			If $BBaseCheckTimerDiff < $DelayReturnedtocheckBBaseMS Then ;Delay not reached : return False

				Local $iWaitTime = ($DelayReturnedtocheckBBaseMS - $BBaseCheckTimerDiff)
				Local $sWaitTime = ""
				Local $iMin, $iHour, $iWaitSec

				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
				If $iWaitSec <= 60 Then $sWaitTime = "Imminent"

				SetLog("Next Builder Base Check : " & $sWaitTime & "", $COLOR_OLIVE)
				$IstoSwitchMod = 0
				Return
			EndIf

			If $BBaseCheckTimerDiff > $DelayReturnedtocheckBBaseMS Then ;Delay reached : reset chrono ans set new delay. Return True

				$BBaseCheckTimer = _NowCalc()

				Local $DelayReturnedtocheckBBaseInf = ($g_iCmbPriorityBBaseFrequency - ($g_iCmbPriorityBBaseFrequency * $g_icmbAdvancedVariation))
				Local $DelayReturnedtocheckBBaseSup = ($g_iCmbPriorityBBaseFrequency + ($g_iCmbPriorityBBaseFrequency * $g_icmbAdvancedVariation))
				$DelayReturnedtocheckBBaseMS = Random($DelayReturnedtocheckBBaseInf, $DelayReturnedtocheckBBaseSup, 1)

				Local $iWaitTime = $DelayReturnedtocheckBBaseMS
				Local $sWaitTime = ""
				Local $iMin, $iHour, $iWaitSec

				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

				SetLog("Time to Check Builder Base", $COLOR_OLIVE)
				SetLog("Next Builder Base Check : " & $sWaitTime & "", $COLOR_OLIVE)
				IsBBDailyChallengeAvailable()
				$IstoSwitchMod = 1
				Return
			EndIf

		EndIf

	EndIf
EndFunc   ;==>SwitchBetweenBasesMod

Func btnModLogClear()
	_GUICtrlRichEdit_SetText($g_hTxtModLog, "")
	GUICtrlSetData($g_hTxtModLog, "------------------------------------------------------ Log of Mod Events -------------------------------------------------")
EndFunc   ;==>btnModLogClear

Func CGLogClear()
	_GUICtrlRichEdit_SetText($g_hTxtClanGamesLog, "")
	GUICtrlSetData($g_hTxtClanGamesLog, "--------------------------------------------------------- Clan Games LOG ------------------------------------------------")
EndFunc   ;==>CGLogClear

Func HowManyinCWCombo()
	$g_HowManyPlayersInCW = ($g_iHowManyinCWCombo * 5) + 5
EndFunc   ;==>HowManyinCWCombo

Func HowManyinCWLCombo()
	$g_HowManyPlayersInCWL = ($g_iHowManyinCWLCombo * 5) + 5
EndFunc   ;==>HowManyinCWLCombo

Func LoadCurrentProfile()
	If $g_iTxtCurrentVillageName <> "" Then
		GUICtrlSetData($g_hTxtNotifyOrigin, $g_iTxtCurrentVillageName)
	ElseIf $g_iTxtCurrentVillageName = "" Then
		GUICtrlSetData($g_hTxtNotifyOrigin, $g_sProfileCurrentName)
	EndIf
	GUICtrlSetData($g_hGrpVillageName, GetTranslatedFileIni("MBR Main GUI", "Tab_07", "Profile") & ": " & $g_sProfileCurrentName)
	GUICtrlSetData($g_hGrpVillage, GetTranslatedFileIni("MBR Main GUI", "Tab_02", "Village") & "[TH" & $g_iTownHallLevel & "]" & " : " & $g_iTxtCurrentVillageName)
EndFunc   ;==>LoadCurrentProfile

Func LoadCurrentAlias()
	If $g_iTxtCurrentVillageName = "" Then
		GUICtrlSetData($g_iTxtCurrentVillageName, $g_sProfileCurrentName)
	EndIf
	GUICtrlSetData($g_hGrpVillage, GetTranslatedFileIni("MBR Main GUI", "Tab_02", "Village") & "[TH" & $g_iTownHallLevel & "]" & " : " & $g_iTxtCurrentVillageName)
EndFunc   ;==>LoadCurrentAlias

Func chkAttackCGPlannerEnable()
	If GUICtrlRead($g_hChkAttackCGPlannerEnable) = $GUI_CHECKED Then
		$g_bAttackCGPlannerEnable = True
		GUICtrlSetState($g_hChkAttackCGPlannerDayLimit, $GUI_ENABLE)
		GUICtrlSetState($g_hChkSTOPWhenCGPointsMax, $GUI_ENABLE)
		chkAttackCGPlannerDayLimit()
	Else
		$g_bAttackCGPlannerEnable = False
		For $i = $TitleDailyLimit To $g_hChkSTOPWhenCGPointsMax
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
	If GUICtrlRead($g_hChkClanGamesEnabled) = $GUI_UNCHECKED Then
		For $i = $g_hChkAttackCGPlannerEnable To $g_hChkSTOPWhenCGPointsMax
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>chkAttackCGPlannerEnable

Func chkAttackCGPlannerDayLimit()
	If GUICtrlRead($g_hChkAttackCGPlannerDayLimit) = $GUI_CHECKED Then
		$g_bAttackCGPlannerDayLimit = True
		GUICtrlSetState($g_hCmbAttackCGPlannerDayMin, $GUI_ENABLE)
		GUICtrlSetState($g_hLbAttackCGPlannerDayLimit, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbAttackCGPlannerDayMax, $GUI_ENABLE)
		GUICtrlSetState($g_hLbAttackCGPlannerThen, $GUI_ENABLE)
		GUICtrlSetState($hCGPlannerThenContinue, $GUI_ENABLE)
		GUICtrlSetState($hCGPlannerThenStopBot, $GUI_ENABLE)
		If $iRandomAttackCGCountToday = 0 Then
			GUICtrlSetData($MaxDailyLimit, "0")
			GUICtrlSetData($ActualNbrsAttacks, "0")
		EndIf
		For $i = $TitleDailyLimit To $MaxDailyLimit
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		$g_bAttackCGPlannerDayLimit = False
		GUICtrlSetState($g_hCmbAttackCGPlannerDayMin, $GUI_DISABLE)
		GUICtrlSetState($g_hLbAttackCGPlannerDayLimit, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbAttackCGPlannerDayMax, $GUI_DISABLE)
		GUICtrlSetState($g_hLbAttackCGPlannerThen, $GUI_DISABLE)
		GUICtrlSetState($hCGPlannerThenContinue, $GUI_DISABLE)
		GUICtrlSetState($hCGPlannerThenStopBot, $GUI_DISABLE)
		GUICtrlSetData($MaxDailyLimit, "X")
		GUICtrlSetData($ActualNbrsAttacks, "X")
		For $i = $TitleDailyLimit To $MaxDailyLimit
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
	_cmbAttackCGPlannerDayLimit()
EndFunc   ;==>chkAttackCGPlannerDayLimit

Func cmbAttackCGPlannerDayMin()
	If Int(GUICtrlRead($g_hCmbAttackCGPlannerDayMax)) < Int(GUICtrlRead($g_hCmbAttackCGPlannerDayMin)) Then
		GUICtrlSetData($g_hCmbAttackCGPlannerDayMin, GUICtrlRead($g_hCmbAttackCGPlannerDayMax))
	EndIf
	$g_iAttackCGPlannerDayMin = Int(GUICtrlRead($g_hCmbAttackCGPlannerDayMin))
	_cmbAttackCGPlannerDayLimit()
EndFunc   ;==>cmbAttackCGPlannerDayMin

Func cmbAttackCGPlannerDayMax()
	If Int(GUICtrlRead($g_hCmbAttackCGPlannerDayMax)) < Int(GUICtrlRead($g_hCmbAttackCGPlannerDayMin)) Then
		GUICtrlSetData($g_hCmbAttackCGPlannerDayMax, GUICtrlRead($g_hCmbAttackCGPlannerDayMin))
	EndIf
	$g_iAttackCGPlannerDayMax = Int(GUICtrlRead($g_hCmbAttackCGPlannerDayMax))
	_cmbAttackCGPlannerDayLimit()
EndFunc   ;==>cmbAttackCGPlannerDayMax

Func LiveDailyCount()
	If $g_bAttackCGPlannerEnable And $g_bAttackCGPlannerDayLimit And $iRandomAttackCGCountToday > 0 Then
		GUICtrlSetData($MaxDailyLimit, $iRandomAttackCGCountToday)
		GUICtrlSetData($ActualNbrsAttacks, $g_aiAttackedCGCount)
	EndIf
EndFunc   ;==>LiveDailyCount

Func _cmbAttackCGPlannerDayLimit()
	Switch Int(GUICtrlRead($g_hCmbAttackCGPlannerDayMin))
		Case 0 To 8
			GUICtrlSetBkColor($g_hCmbAttackCGPlannerDayMin, $COLOR_SUCCESS1)
		Case 9 To 12
			GUICtrlSetBkColor($g_hCmbAttackCGPlannerDayMin, $COLOR_YELLOW)
		Case 13 To 999
			GUICtrlSetBkColor($g_hCmbAttackCGPlannerDayMin, $COLOR_RED)
	EndSwitch
	Switch Int(GUICtrlRead($g_hCmbAttackCGPlannerDayMax))
		Case 0 To 8
			GUICtrlSetBkColor($g_hCmbAttackCGPlannerDayMax, $COLOR_SUCCESS1)
		Case 9 To 12
			GUICtrlSetBkColor($g_hCmbAttackCGPlannerDayMax, $COLOR_YELLOW)
		Case 13 To 999
			GUICtrlSetBkColor($g_hCmbAttackCGPlannerDayMax, $COLOR_RED)
	EndSwitch
EndFunc   ;==>_cmbAttackCGPlannerDayLimit

Func SwitchBetweenBasesMod2()

	If Not $g_bFirstStartAccountSBB2 Then
		$CCBaseCheckTimer = 0
		$DelayReturnedtocheckCCBaseMS = 0
		$g_bFirstStartAccountSBB2 = 1
		$iLastTimeCCRaidChecked = 0
	EndIf

	$g_iCmbPriorityCCBaseFrequency = _GUICtrlComboBox_GetCurSel($g_hCmbPriorityCCBaseFrequency) * 60 * 60 * 1000
	$g_icmbAdvancedVariationCC = _GUICtrlComboBox_GetCurSel($g_hcmbAdvancedVariationCC) / 10
	Local $DelayReturnedtocheckCCBaseInf = ($g_iCmbPriorityCCBaseFrequency - ($g_iCmbPriorityCCBaseFrequency * $g_icmbAdvancedVariationCC))
	Local $DelayReturnedtocheckCCBaseSup = ($g_iCmbPriorityCCBaseFrequency + ($g_iCmbPriorityCCBaseFrequency * $g_icmbAdvancedVariationCC))

	If _DateIsValid($iLastTimeCCRaidChecked) Then
		Local $iLastCheck = _DateDiff('n', $iLastTimeCCRaidChecked, _NowCalc()) ; elapse time from last check (minutes)
		; A check each from 2 to 2.5 hours [2*60 = 120 to 2.5*60 = 150]
		Local $iDelayToCheck = Random(120, 150, 1)
		If $iLastCheck > $iDelayToCheck Then
			If UTCRaidWarning() Then
				$iLastTimeCCRaidChecked = _NowCalc()
				$CCBaseCheckTimer = _NowCalc()
				$DelayReturnedtocheckCCBaseMS = Random($DelayReturnedtocheckCCBaseInf, $DelayReturnedtocheckCCBaseSup, 1)
				Local $iWaitTime = $DelayReturnedtocheckCCBaseMS
				Local $sWaitTime = ""
				Local $iMin, $iHour, $iWaitSec

				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
				SetLog("Time To Check Clan Capital Stuff", $COLOR_OLIVE)
				SetLog("Next Check For Clan Capital Stuff : " & $sWaitTime & "", $COLOR_OLIVE)
				Return True
			EndIf
		EndIf
	Else
		If UTCRaidWarning() Then
			$iLastTimeCCRaidChecked = _NowCalc()
			$CCBaseCheckTimer = _NowCalc()
			$DelayReturnedtocheckCCBaseMS = Random($DelayReturnedtocheckCCBaseInf, $DelayReturnedtocheckCCBaseSup, 1)
			Local $iWaitTime = $DelayReturnedtocheckCCBaseMS
			Local $sWaitTime = ""
			Local $iMin, $iHour, $iWaitSec

			$iWaitSec = Round($iWaitTime / 1000)
			$iHour = Floor(Floor($iWaitSec / 60) / 60)
			$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
			If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
			If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
			SetLog("Time To Check Clan Capital Stuff", $COLOR_OLIVE)
			SetLog("Next Check For Clan Capital Stuff : " & $sWaitTime & "", $COLOR_OLIVE)
			Return True
		EndIf
	EndIf

	Local $aForgeType[5] = [$g_bChkEnableForgeGold, $g_bChkEnableForgeElix, $g_bChkEnableForgeDE, $g_bChkEnableForgeBBGold, $g_bChkEnableForgeBBElix]
	Local $bForgeEnabled = False
	For $i In $aForgeType ;check for every option enabled
		If $i = True Then
			$bForgeEnabled = True
			ExitLoop
		EndIf
	Next
	If Not $bForgeEnabled And Not $g_bChkEnableAutoUpgradeCC Then Return False

	If $g_iCmbPriorityCCBaseFrequency = 0 Then ; Case Everytime, Return True and End fonction Without Timing
		Return True
	EndIf

	If Not _DateIsValid($CCBaseCheckTimer) Then ; First Time

		$CCBaseCheckTimer = _NowCalc()
		$DelayReturnedtocheckCCBaseMS = Random($DelayReturnedtocheckCCBaseInf, $DelayReturnedtocheckCCBaseSup, 1)

		Local $iWaitTime = $DelayReturnedtocheckCCBaseMS
		Local $sWaitTime = ""
		Local $iMin, $iHour, $iWaitSec

		$iWaitSec = Round($iWaitTime / 1000)
		$iHour = Floor(Floor($iWaitSec / 60) / 60)
		$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
		If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
		If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
		If $IsCCGoldJustCollected Or $IsCCGoldJustCollectedDChallenge Then
			SetLog("Time To Check Clan Capital Stuff, CC Gold Just Collected", $COLOR_OLIVE)
		ElseIf $IsAutoForgeSlotJustCollected Then
			SetLog("Time To Check Clan Capital Stuff, Auto Forge Slot Just Unlocked", $COLOR_OLIVE)
		Else
			SetLog("Time To Check Clan Capital Stuff", $COLOR_OLIVE)
		EndIf
		SetLog("Next Check For Clan Capital Stuff : " & $sWaitTime & "", $COLOR_OLIVE)
		Return True

	EndIf

	If _DateIsValid($CCBaseCheckTimer) Then

		Local $CCBaseCheckTimerDiff = _DateDiff('s', $CCBaseCheckTimer, _NowCalc()) * 1000

		If $CCBaseCheckTimerDiff < $DelayReturnedtocheckCCBaseMS And Not ($IsCCGoldJustCollected Or $IsCCGoldJustCollectedDChallenge) Then ;Delay not reached And no CCGold : Return False

			Local $iWaitTime = ($DelayReturnedtocheckCCBaseMS - $CCBaseCheckTimerDiff)
			Local $sWaitTime = ""
			Local $iMin, $iHour, $iWaitSec

			$iWaitSec = Round($iWaitTime / 1000)
			$iHour = Floor(Floor($iWaitSec / 60) / 60)
			$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
			If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
			If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
			If $iWaitSec <= 60 Then $sWaitTime = "Imminent"

			SetLog("Next Check For Clan Capital Stuff : " & $sWaitTime & "", $COLOR_OLIVE)
			Return False
		EndIf

		If $CCBaseCheckTimerDiff > $DelayReturnedtocheckCCBaseMS Or $IsCCGoldJustCollected Or $IsCCGoldJustCollectedDChallenge Or $IsAutoForgeSlotJustCollected Then ;Delay reached or CCgold: reset chrono ans set new delay. Return True

			$CCBaseCheckTimer = _NowCalc()

			$DelayReturnedtocheckCCBaseMS = Random($DelayReturnedtocheckCCBaseInf, $DelayReturnedtocheckCCBaseSup, 1)

			Local $iWaitTime = $DelayReturnedtocheckCCBaseMS
			Local $sWaitTime = ""
			Local $iMin, $iHour, $iWaitSec

			$iWaitSec = Round($iWaitTime / 1000)
			$iHour = Floor(Floor($iWaitSec / 60) / 60)
			$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
			If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
			If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

			If $IsCCGoldJustCollected Or $IsCCGoldJustCollectedDChallenge Then
				SetLog("Time To Check Clan Capital Stuff, CC Gold Just Collected", $COLOR_OLIVE)
			ElseIf $IsAutoForgeSlotJustCollected Then
				SetLog("Time To Check Clan Capital Stuff, Auto Forge Slot Just Unlocked", $COLOR_OLIVE)
			Else
				SetLog("Time To Check Clan Capital Stuff", $COLOR_OLIVE)
			EndIf
			SetLog("Next Check For Clan Capital Stuff : " & $sWaitTime & "", $COLOR_OLIVE)
			Return True
		EndIf

	EndIf
EndFunc   ;==>SwitchBetweenBasesMod2

Func CCBaseFrequencyDatas()
	If _GUICtrlComboBox_GetCurSel($g_hCmbPriorityCCBaseFrequency) = 0 Then
		GUICtrlSetState($g_hcmbAdvancedVariationCC, $GUI_DISABLE)
	Else
		GUICtrlSetState($g_hcmbAdvancedVariationCC, $GUI_ENABLE)
	EndIf
EndFunc   ;==>CCBaseFrequencyDatas

Func ChkEnableForgeGold()
	If GUICtrlRead($g_hChkEnableForgeGold) = $GUI_CHECKED Then
		$g_bChkEnableForgeGold = True
		For $i = $g_hLbacmdGoldSaveMin To $g_acmdGoldSaveMin
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		$g_bChkEnableForgeGold = False
		For $i = $g_hLbacmdGoldSaveMin To $g_acmdGoldSaveMin
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>ChkEnableForgeGold

Func ChkEnableForgeElix()
	If GUICtrlRead($g_hChkEnableForgeElix) = $GUI_CHECKED Then
		$g_bChkEnableForgeElix = True
		For $i = $g_hLbacmdElixSaveMin To $g_acmdElixSaveMin
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		$g_bChkEnableForgeElix = False
		For $i = $g_hLbacmdElixSaveMin To $g_acmdElixSaveMin
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>ChkEnableForgeElix

Func ChkEnableForgeDE()
	If GUICtrlRead($g_hChkEnableForgeDE) = $GUI_CHECKED Then
		$g_bChkEnableForgeDE = True
		For $i = $g_hLbacmdDarkSaveMin To $g_acmdDarkSaveMin
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		$g_bChkEnableForgeDE = False
		For $i = $g_hLbacmdDarkSaveMin To $g_acmdDarkSaveMin
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>ChkEnableForgeDE

Func ChkEnableForgeBBGold()
	If GUICtrlRead($g_hChkEnableForgeBBGold) = $GUI_CHECKED Then
		$g_bChkEnableForgeBBGold = True
		For $i = $g_hLbacmdBBGoldSaveMin To $g_acmdBBGoldSaveMin
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		$g_bChkEnableForgeBBGold = False
		For $i = $g_hLbacmdBBGoldSaveMin To $g_acmdBBGoldSaveMin
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>ChkEnableForgeBBGold

Func ChkEnableForgeBBElix()
	If GUICtrlRead($g_hChkEnableForgeBBElix) = $GUI_CHECKED Then
		$g_bChkEnableForgeBBElix = True
		For $i = $g_hLbacmdBBElixSaveMin To $g_acmdBBElixSaveMin
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		$g_bChkEnableForgeBBElix = False
		For $i = $g_hLbacmdBBElixSaveMin To $g_acmdBBElixSaveMin
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>ChkEnableForgeBBElix

Func CmbForgeBuilder()
	$g_iCmbForgeBuilder = Int(_GUICtrlComboBox_GetCurSel($g_hCmbForgeBuilder))
	GUICtrlSetData($g_hLbCmbForgeBuilder, $g_iCmbForgeBuilder > 1 ? GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblForgeBuilder", "Builders for Forge") : _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblForgeBuilder", "Builder for Forge"))
EndFunc   ;==>CmbForgeBuilder

Func EnableAutoUpgradeCC()
	If GUICtrlRead($g_hChkEnableAutoUpgradeCC) = $GUI_CHECKED Then
		GUICtrlSetState($g_hChkStartWeekendRaid, $GUI_ENABLE)
		GUICtrlSetState($g_hBtnCCUpgradesSettingsOpen, $GUI_ENABLE)
		GUICtrlSetState($g_hChkEnableSmartSwitchCC, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtAutoUpgradeCCLog, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hChkStartWeekendRaid, $GUI_DISABLE)
		GUICtrlSetState($g_hBtnCCUpgradesSettingsOpen, $GUI_DISABLE)
		GUICtrlSetState($g_hChkEnableSmartSwitchCC, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtAutoUpgradeCCLog, $GUI_DISABLE)
	EndIf
EndFunc   ;==>EnableAutoUpgradeCC

Func EnablePurgeMedal()
	If GUICtrlRead($g_hChkEnablePurgeMedal) = $GUI_CHECKED Then
		GUICtrlSetState($g_acmdMedalsExpected, $GUI_ENABLE)
		GUICtrlSetState($g_hBtnForcePurgeMedals, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_acmdMedalsExpected, $GUI_DISABLE)
		GUICtrlSetState($g_hBtnForcePurgeMedals, $GUI_DISABLE)
	EndIf
EndFunc   ;==>EnablePurgeMedal

Func CheckDonateOften()
	If Not $g_bCheckDonateOften Or Not $g_bChkDonate Then Return

	If _ColorCheck(_GetPixelColor(54, 278 + $g_iMidOffsetY, True), Hex(0xE90914, 6), 20) Then
		SetLog("Check Donate Often", $COLOR_DEBUG1)
		checkArmyCamp(True, True)

		; if in "Halt/Donate" don't skip near full army
		If (Not SkipDonateNearFullTroops(True) Or $g_iCommandStop = 3 Or $g_iCommandStop = 0) And BalanceDonRec(True) Then DonateCC()
		Local $IsAnythingDonated = False
		If $IsTroopDonated Or $IsSpellDonated Or $IsSiegeDonated Then $IsAnythingDonated = True

		If Not _Sleep($DELAYRUNBOT1) Then checkMainScreen(False)
		If $g_bTrainEnabled And $IsAnythingDonated Then ; check for training enabled in halt mode
			If $g_iActualTrainSkip < $g_iMaxTrainSkip Then
				TrainSystem()
				_Sleep($DELAYRUNBOT1)
			Else
				SetLog("Humanize bot, prevent to delete and recreate troops " & $g_iActualTrainSkip + 1 & "/" & $g_iMaxTrainSkip, $color_blue)
				$g_iActualTrainSkip = $g_iActualTrainSkip + 1
				If $g_iActualTrainSkip >= $g_iMaxTrainSkip Then
					$g_iActualTrainSkip = 0
				EndIf
				CheckOverviewFullArmy(True, False) ; use true parameter to open train overview window
				If _Sleep($DELAYRESPOND) Then Return
				getArmySpells()
				If _Sleep($DELAYRESPOND) Then Return
				getArmyHeroCount(False, True)
			EndIf
		Else
			If $g_bDebugSetLogTrain Then SetLog("Halt mode - training disabled", $COLOR_DEBUG)
		EndIf
		$IsTroopDonated = False
		$IsSpellDonated = False
		$IsSiegeDonated = False
	EndIf
EndFunc   ;==>CheckDonateOften

Func StarBonusSearch()
	Local $bRet = False
	For $i = 1 To 10
		If WaitforPixel(84, 570 + $g_iBottomOffsetY, 97, 575 + $g_iBottomOffsetY, "AF5725", 20, 0.2) Then
			$bRet = True
			ExitLoop
		EndIf
		If _Sleep(400) Then Return
		If Not $g_bRunState Then Return
	Next
	Return $bRet
EndFunc   ;==>StarBonusSearch

Func IsBBDailyChallengeAvailable()

	$g_IsBBDailyChallengeAvailable = True ; Reset
	If Not $g_bChkBBAttackForDailyChallenge Or Not $g_bChkEnableBBAttack Then Return

	Local $iWaitTime = 0
	Local $sWaitTime = ""
	Local $iMin, $iHour, $iWaitSec

	If _DateIsValid($g_sNewChallengeTime) Then
		Local $TimeDiffBBChallenge = _DateDiff('n', _NowCalc(), $g_sNewChallengeTime)
		If $TimeDiffBBChallenge > 0 Then

			$iWaitTime = $TimeDiffBBChallenge * 60 * 1000
			$sWaitTime = ""

			$iWaitSec = Round($iWaitTime / 1000)
			$iHour = Floor(Floor($iWaitSec / 60) / 60)
			$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
			If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
			If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

			SetLog("Daily BB Challenge Unavailable", $COLOR_DEBUG1)
			SetLog("New Challenge in " & $sWaitTime, $COLOR_ACTION)

			$g_IsBBDailyChallengeAvailable = False
			Return
		EndIf
	EndIf

	ClearScreen()
	If _Sleep($DELAYRUNBOT1) Then Return

	Local $bRet = False
	For $i = 0 To 9
		If _CheckPixel($aPersonalChallengeOpenButton1, $g_bCapturePixel) Then
			ClickP($aPersonalChallengeOpenButton1, 1, 120, "#0666")
			$bRet = True
			ExitLoop
		ElseIf _CheckPixel($aPersonalChallengeOpenButton2, $g_bCapturePixel) Then
			ClickP($aPersonalChallengeOpenButton2, 1, 120, "#0666")
			$bRet = True
			ExitLoop
		EndIf
		If _Sleep(200) Then Return
	Next
	If $bRet = False Then
		SetLog("Can't find button", $COLOR_ERROR)
		ClearScreen()
		$g_IsBBDailyChallengeAvailable = False
		Return
	EndIf

	Local $counter = 0
	While Not _CheckPixel($aPersonalChallengeCloseButton, $g_bCapturePixel) ; test for Personal Challenge Close Button
		SetDebugLog("Wait for Personal Challenge Close Button to appear #" & $counter)
		If _Sleep($DELAYRUNBOT6) Then Return
		$counter += 1
		If $counter > 40 Then
			$g_IsBBDailyChallengeAvailable = False
			Return
		EndIf
	WEnd

	If _Sleep(5000) Then Return

	If QuickMIS("BC1", $g_sImgBBDailyAvail, 50, 350 + $g_iMidOffsetY, 120, 430 + $g_iMidOffsetY) Then
		SetLog("Daily Challenge Available", $COLOR_SUCCESS1)
		$g_IsBBDailyChallengeAvailable = True
		CloseWindow()
		Return
	Else
		SetLog("Daily BB Challenge Unavailable", $COLOR_DEBUG1)
		Local $Result = getOcrAndCapture("coc-forgetime", 210, 558 + $g_iMidOffsetY, 95, 18, True)
		Local $iBBDailyNewChalTime = ConvertOCRTime("Challenge Time", $Result, False)

		SetDebugLog("New Challenge OCR Time = " & $Result & ", $iBBDailyNewChalTime = " & $iBBDailyNewChalTime & " m", $COLOR_INFO)
		Local $StartTime = _NowCalc() ; what is date:time now
		If $iBBDailyNewChalTime > 0 Then
			$g_sNewChallengeTime = _DateAdd('n', Ceiling($iBBDailyNewChalTime), $StartTime)
			SetLog("New Challenge @ " & $g_sNewChallengeTime, $COLOR_DEBUG1)
			Local $TimeDiffBBChallenge = _DateDiff('n', _NowCalc(), $g_sNewChallengeTime) ; what is difference between end time and now in minutes?
			If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
			If $TimeDiffBBChallenge > 0 Then

				$iWaitTime = $TimeDiffBBChallenge * 60 * 1000
				$sWaitTime = ""

				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

				SetLog("New Challenge in " & $sWaitTime, $COLOR_ACTION)

				$g_IsBBDailyChallengeAvailable = False
				CloseWindow()
				Return
			EndIf
		Else
			SetLog("Error processing New Challenge time required, try again!", $COLOR_WARNING)
			$g_IsBBDailyChallengeAvailable = False
			CloseWindow()
			Return
		EndIf
	EndIf

EndFunc   ;==>IsBBDailyChallengeAvailable

Func IsBBDailyChallengeStillAvailable()

	$g_IsBBDailyChallengeAvailable = True ; Reset
	If Not $g_bChkBBAttackForDailyChallenge Then Return

	ClearScreen("Right", False)
	If _Sleep($DELAYRUNBOT1) Then Return
	Local $bRet = False
	For $i = 0 To 9
		If _CheckPixel($aPersonalChallengeOpenButton1, $g_bCapturePixel) Then
			ClickP($aPersonalChallengeOpenButton1, 1, 120, "#0666")
			$bRet = True
			ExitLoop
		ElseIf _CheckPixel($aPersonalChallengeOpenButton2, $g_bCapturePixel) Then
			ClickP($aPersonalChallengeOpenButton2, 1, 120, "#0666")
			$bRet = True
			ExitLoop
		EndIf
		If _Sleep(200) Then Return
	Next
	If $bRet = False Then
		SetLog("Can't find button", $COLOR_ERROR)
		ClearScreen("Right", False)
		$g_IsBBDailyChallengeAvailable = False
		Return
	EndIf

	Local $counter = 0
	While Not _CheckPixel($aPersonalChallengeCloseButton, $g_bCapturePixel) ; test for Personal Challenge Close Button
		SetDebugLog("Wait for Personal Challenge Close Button to appear #" & $counter)
		If _Sleep($DELAYRUNBOT6) Then Return
		$counter += 1
		If $counter > 40 Then
			$g_IsBBDailyChallengeAvailable = False
			Return
		EndIf
	WEnd

	If _Sleep(5000) Then Return

	If QuickMIS("BC1", $g_sImgBBDailyAvail, 50, 350 + $g_iMidOffsetY, 120, 430 + $g_iMidOffsetY) Then
		SetLog("Builder Base Daily Challenge Available", $COLOR_SUCCESS1)
		$g_IsBBDailyChallengeAvailable = True
		CloseWindow()
		Return
	Else
		SetLog("Builder Base Daily Challenge Unavailable", $COLOR_DEBUG1)
		$g_IsBBDailyChallengeAvailable = False
		CloseWindow()
		Return
	EndIf

EndFunc   ;==>IsBBDailyChallengeStillAvailable

Func ForumAccept()

	If Not $g_bForumRequestOnly Then Return

	SetLog("Checking Joining Requests", $COLOR_ACTION)

	Local $Scroll, $bRet, $Accepted = 0
	Local $aForumWrite = StringSplit($g_sRequestMessage, "|")
	_ArrayDelete($aForumWrite, 0)

	If _Sleep(1000) Then Return
	If Not ClickB("ClanChat") Then
		SetLog("Error finding the Clan Tab Button", $COLOR_ERROR)
		Return
	EndIf
	If Not $g_bRunState Then Return
	If _Sleep(1500) Then Return

	While 1
		ForceCaptureRegion()
		Local $offColors[3][3] = [[0xFFFFFF, 7, 0], [0x0D0D0D, 11, 0], [0x99D012, 14, 0]] ; 2nd pixel white Color, 3rd pixel black Bottom color, 4th pixel green edge of button
		Local $Scroll = _MultiPixelSearch(329, 68, 348, 70, 1, 1, Hex(0x8ECC26, 6), $offColors, 40) ; first green pixel on side of button
		SetDebugLog("Pixel Color #1: " & _GetPixelColor(332, 68, True) & ", #2: " & _GetPixelColor(339, 68, True) & ", #3: " & _GetPixelColor(343, 68, True) & ", #4: " & _GetPixelColor(346, 68, True), $COLOR_DEBUG)
		If IsArray($Scroll) Then
			Click($Scroll[0] + 8, $Scroll[1])
			If _Sleep(350) Then ExitLoop
			ContinueLoop
		EndIf
		ExitLoop
	WEnd

	While 1
		Local $aTmpCoord = QuickMIS("CNX", $g_sImgACCEPT, 200, 115, 300, 615 + $g_iBottomOffsetY)
		If _Sleep(1000) Then ExitLoop
		If IsArray($aTmpCoord) And UBound($aTmpCoord) > 0 Then
			_ArraySort($aTmpCoord, 0, 0, 0, 2)
			SetLog("Joining Request Detected", $COLOR_SUCCESS1)
			$bRet = False
			If _Sleep(500) Then ExitLoop
			If $g_bChkAcceptAllRequests Then
				SetLog("Accept Any Request", $COLOR_FUCHSIA)
				$bRet = True
			Else
				Local $bForumWordFound = 0
				Local $Result = getOcrAndCapture("coc-latinA", 45, $aTmpCoord[0][2] - 49, 285, 16)
				Local $Result2 = getOcrAndCapture("coc-latinA", 45, $aTmpCoord[0][2] - 62, 285, 16)
				If _Sleep(500) Then ExitLoop
				If IsArray($aForumWrite) And $aForumWrite[0] <> "" Then
					For $i = 0 To UBound($aForumWrite) - 1
						If StringInStr($Result, $aForumWrite[$i]) Or StringInStr($Result2, $aForumWrite[$i]) Then
							SetLog("Request With Keyword Detected (" & $aForumWrite[$i] & ")", $COLOR_FUCHSIA)
							$bRet = True
							$bForumWordFound += 1
							ExitLoop
						EndIf
					Next
				Else
					SetLog("No Keyword Saved In Settings", $COLOR_ERROR)
					ExitLoop
				EndIf
				If $bForumWordFound = 0 Then SetLog("But No Keyword Detected", $COLOR_WARNING)
			EndIf
			If Not $g_bRunState Then ExitLoop
			If $bRet Then
				SetLog("Click Accept", $COLOR_SUCCESS1)
				Click($aTmpCoord[0][1], $aTmpCoord[0][2] + 5)
				$Accepted += 1
				$ActionForModLog = "Accept Joining Request"
				If $g_iTxtCurrentVillageName <> "" Then
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Humanization : " & $ActionForModLog, 1)
				Else
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Humanization : " & $ActionForModLog, 1)
				EndIf
				_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Humanization : " & $ActionForModLog)
				If _Sleep(2000) Then ExitLoop
				ContinueLoop
			Else
				ForceCaptureRegion()
				Local $offColors[3][3] = [[0xFFFFFF, 7, 0], [0x0D0D0D, 11, 0], [0x99D012, 14, 0]] ; 2nd pixel white Color, 3rd pixel black Bottom color, 4th pixel green edge of button
				Local $Scroll = _MultiPixelSearch(329, 651, 348, 653, 1, 1, Hex(0x92D028, 6), $offColors, 40) ; first green pixel on side of button
				SetDebugLog("Pixel Color #1: " & _GetPixelColor(332, 651, True) & ", #2: " & _GetPixelColor(339, 651, True) & ", #3: " & _GetPixelColor(343, 651, True) & ", #4: " & _GetPixelColor(346, 651, True), $COLOR_DEBUG)
				If IsArray($Scroll) Then
					Click($Scroll[0] + 8, $Scroll[1])
					If _Sleep(250) Then ExitLoop
					ContinueLoop
				EndIf
			EndIf
		Else
			ForceCaptureRegion()
			Local $offColors[3][3] = [[0xFFFFFF, 7, 0], [0x0D0D0D, 11, 0], [0x99D012, 14, 0]] ; 2nd pixel white Color, 3rd pixel black Bottom color, 4th pixel green edge of button
			Local $Scroll = _MultiPixelSearch(329, 651, 348, 653, 1, 1, Hex(0x92D028, 6), $offColors, 40) ; first green pixel on side of button
			SetDebugLog("Pixel Color #1: " & _GetPixelColor(332, 651, True) & ", #2: " & _GetPixelColor(339, 651, True) & ", #3: " & _GetPixelColor(343, 651, True) & ", #4: " & _GetPixelColor(346, 651, True), $COLOR_DEBUG)
			If IsArray($Scroll) Then
				Click($Scroll[0] + 8, $Scroll[1])
				If _Sleep(250) Then ExitLoop
				ContinueLoop
			Else
				If ClickB("ChatDown") Then ContinueLoop
			EndIf
		EndIf
		ExitLoop
	WEnd

	If $Accepted > 0 Then
		If $g_bUseWelcomeMessage And $g_aWelcomeMessage <> "" Then
			SetLog("Sending Welcome Message", $COLOR_ACTION)
			If Not SelectChatInput() Then Return False
			If Not ChatTextInput($g_aWelcomeMessage) Then Return False
			If Not SendTextChat() Then Return False
		EndIf
	EndIf

	If _Sleep(1000) Then Return
	If Not ClickB("ClanChat") Then
		SetLog("Error finding the Clan Tab Button", $COLOR_ERROR)
		Return
	EndIf

	If Not $g_bRunState Then Return

EndFunc   ;==>ForumAccept

Func SelectChatInput() ; select the textbox for Global chat or Clan Chat

	Click($aChatSelectTextBox[0], $aChatSelectTextBox[1], 1, 120, "SelectTextBoxBtn")
	If _Sleep(2000) Then Return

	If _WaitForCheckPixel($aOpenedChatSelectTextBox, $g_bCapturePixel, Default, "Wait for Chat Select Text Box:") Then
		SetDebugLog("Chat TextBox Appeared.", $COLOR_INFO)
		Return True
	Else
		SetDebugLog("Not find $aOpenedChatSelectTextBox | Pixel was:" & _GetPixelColor($aOpenedChatSelectTextBox[0], $aOpenedChatSelectTextBox[1], True), $COLOR_ERROR)
		Return False
	EndIf

EndFunc   ;==>SelectChatInput

Func ChatTextInput($g_sMessage)

	Click($aOpenedChatSelectTextBox[0], $aOpenedChatSelectTextBox[1], 1, 120, "ChatInput")
	If _Sleep(1500) Then Return

	SendText($g_sMessage)
	If _Sleep(1000) Then Return
	Return True

EndFunc   ;==>ChatTextInput

Func SendTextChat() ; click send for clan chat

	If _CheckPixel($aChatSendBtn, $g_bCapturePixel, Default, "Chat Send Btn:") Then
		Click($aChatSendBtn[0], $aChatSendBtn[1] + 12, 1, 0, "ChatSendBtn") ; send
		If _Sleep(1500) Then Return
		Return True
	Else
		SetDebugLog("Not find $aChatSendBtn | Pixel was:" & _GetPixelColor($aChatSendBtn[0], $aChatSendBtn[1], True), $COLOR_ERROR)
		Return False
	EndIf

EndFunc   ;==>SendTextChat

Func chkUseWelcomeMessage()
	If GUICtrlRead($g_hChkUseWelcomeMessage) = $GUI_CHECKED Then
		$g_bUseWelcomeMessage = True
		GUICtrlSetState($g_hTxtRequestMessage, $GUI_ENABLE)
		GUICtrlSetState($g_hChkAcceptAllRequests, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtWelcomeMessage, $GUI_ENABLE)
		chkAcceptAllRequests()
	Else
		$g_bUseWelcomeMessage = False
		GUICtrlSetState($g_hTxtRequestMessage, $GUI_DISABLE)
		GUICtrlSetState($g_hChkAcceptAllRequests, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtWelcomeMessage, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkUseWelcomeMessage

Func chkAcceptAllRequests()
	If GUICtrlRead($g_hChkAcceptAllRequests) = $GUI_CHECKED Then
		$g_bChkAcceptAllRequests = True
		GUICtrlSetState($g_hTxtRequestMessage, $GUI_DISABLE)
	Else
		$g_bChkAcceptAllRequests = False
		GUICtrlSetState($g_hTxtRequestMessage, $GUI_ENABLE)
	EndIf
EndFunc   ;==>chkAcceptAllRequests

Func BtnWelcomeMessage()
	GUISetState(@SW_SHOW, $g_hGUI_WelcomeMessage)
EndFunc   ;==>BtnWelcomeMessage

Func CloseWelcomeMessage()
	GUISetState(@SW_HIDE, $g_hGUI_WelcomeMessage)
EndFunc   ;==>CloseWelcomeMessage

Func SignUpWar()

	If Not $g_bChkWarSignUp Then Return

	Local Static $iLastTimeChecked[8]
	If $g_bFirstStart Then
		$iLastTimeChecked[$g_iCurAccount] = ""
		$bAlreadyWarSigned[$g_iCurAccount] = False
	EndIf

	If $bAlreadyWarSigned Then Return

	If _DateIsValid($iLastTimeChecked[$g_iCurAccount]) Then
		Local $iLastCheck = _DateDiff('n', $iLastTimeChecked[$g_iCurAccount], _NowCalc()) ; elapse time from last check (minutes)
		Local $iDelayToCheck = Random(120, 180, 1) ; Check every 2 to 3 hours
		If $iLastCheck <= $iDelayToCheck Then Return
	EndIf

	SetLog("Checking War Sign-Up", $COLOR_ACTION)

	If _Sleep(1000) Then Return
	If Not ClickB("ClanChat") Then
		SetLog("Error finding the Clan Tab Button", $COLOR_ERROR)
		Return
	EndIf
	If Not $g_bRunState Then Return
	If _Sleep(1500) Then Return

	Local $bLoop = 0, $bGreenArrow = False
	While 1
		ForceCaptureRegion()
		Local $offColors[3][3] = [[0xFFFFFF, 10, 0], [0x0D0D0D, 11, 0], [0x99D012, 14, 0]] ; 2nd pixel white Color, 3rd pixel black Bottom color, 4th pixel green edge of button
		Local $Scroll = _MultiPixelSearch(329, 68, 348, 70, 1, 1, Hex(0x8ECC26, 6), $offColors, 40) ; first green pixel on side of button
		SetDebugLog("Pixel Color #1: " & _GetPixelColor(332, 68, True) & ", #2: " & _GetPixelColor(339, 68, True) & ", #3: " & _GetPixelColor(343, 68, True) & ", #4: " & _GetPixelColor(346, 68, True), $COLOR_DEBUG)
		Local $offColors2[3][3] = [[0xFFFFFE, 10, 0], [0x463F33, 13, 0], [0xEB9910, 17, 0]] ; 2nd pixel white Color, 3rd pixel black color, 4th pixel orange edge of button
		Local $Scroll2 = _MultiPixelSearch(329, 71, 351, 73, 1, 1, Hex(0xEB9910, 6), $offColors2, 40) ; first orange pixel on side of button
		SetDebugLog("Pixel Color #1: " & _GetPixelColor(332, 71, True) & ", #2: " & _GetPixelColor(342, 71, True) & ", #3: " & _GetPixelColor(345, 71, True) & ", #4: " & _GetPixelColor(349, 71, True), $COLOR_DEBUG)
		If IsArray($Scroll) Then
			Click($Scroll[0] + 8, $Scroll[1])
			If _Sleep(250) Then ExitLoop
			$bGreenArrow = True
			ContinueLoop
		EndIf
		If IsArray($Scroll2) Then
			Click($Scroll2[0] + 9, $Scroll2[1])
			If _Sleep(250) Then ExitLoop
			ContinueLoop
		Else
			If $bLoop = 0 And $bGreenArrow Then
				If _Sleep(1500) Then ExitLoop
				$bLoop += 1
				ContinueLoop
			EndIf
		EndIf
		ExitLoop
	WEnd

	; Reset ------------
	$bLoop = 0
	$bGreenArrow = False
	;-------------------
	While 1
		If QuickMIS("BC1", $g_sImgSignUp, 70, 45, 250, 530 + $g_iBottomOffsetY) Then
			SetLog("War/Clan War Sign-Up Detected", $COLOR_SUCCESS1)
			If _Sleep(500) Then ExitLoop
			If IsArray(_PixelSearch(72, $g_iQuickMISY + 15, 120, $g_iQuickMISY + 25, Hex(0xFBFBFB, 6), 30, True)) Then
				If $bAllowWar Then
					If QuickMIS("BC1", $g_sImgSignUpGreen, 80, $g_iQuickMISY + 40, 290, $g_iQuickMISY + 90) Then Click($g_iQuickMISX, $g_iQuickMISY + 8)
					SetLog("Sign-Up Accepted", $COLOR_SUCCESS1)
				ElseIf $bRefuseWar Then
					If QuickMIS("BC1", $g_sImgSignUpRed, 80, $g_iQuickMISY + 40, 290, $g_iQuickMISY + 90) Then Click($g_iQuickMISX, $g_iQuickMISY)
					SetLog("Sign-Up Refused", $COLOR_ERROR)
				EndIf
				$bAlreadyWarSigned = True
				If _Sleep(1500) Then ExitLoop
				ExitLoop
			Else
				SetLog("Sign-Up Already Done", $COLOR_INFO)
				$bAlreadyWarSigned = True
				If _Sleep(1500) Then ExitLoop
				ExitLoop
			EndIf
		Else
			ForceCaptureRegion()
			Local $offColors[3][3] = [[0xFFFFFF, 7, 0], [0x0D0D0D, 11, 0], [0x99D012, 14, 0]] ; 2nd pixel white Color, 3rd pixel black Bottom color, 4th pixel green edge of button
			Local $Scroll = _MultiPixelSearch(329, 651, 348, 653, 1, 1, Hex(0x92D028, 6), $offColors, 40) ; first green pixel on side of button
			SetDebugLog("Pixel Color #1: " & _GetPixelColor(332, 651, True) & ", #2: " & _GetPixelColor(339, 651, True) & ", #3: " & _GetPixelColor(343, 651, True) & ", #4: " & _GetPixelColor(346, 651, True), $COLOR_DEBUG)
			Local $offColors2[3][3] = [[0xFFFFFF, 10, 0], [0x10100F, 13, 1], [0xEC990F, 17, 1]] ; 2nd pixel white Color, 3rd pixel black color, 4th pixel orange edge of button
			Local $Scroll2 = _MultiPixelSearch(329, 651, 351, 653, 1, 1, Hex(0xF19B10, 6), $offColors2, 40) ; first orange pixel on side of button
			SetDebugLog("Pixel Color #1: " & _GetPixelColor(332, 651, True) & ", #2: " & _GetPixelColor(342, 651, True) & ", #3: " & _GetPixelColor(345, 652, True) & ", #4: " & _GetPixelColor(349, 652, True), $COLOR_DEBUG)
			If IsArray($Scroll) Then
				Click($Scroll[0] + 8, $Scroll[1])
				If _Sleep(2500) Then ExitLoop
				$bGreenArrow = True
				ContinueLoop
			EndIf
			If IsArray($Scroll2) Then
				Click($Scroll2[0] + 9, $Scroll2[1])
				If _Sleep(250) Then ExitLoop
				ContinueLoop
			Else
				If $bLoop = 0 And $bGreenArrow Then
					If _Sleep(1500) Then ExitLoop
					$bLoop += 1
					ContinueLoop
				EndIf
				If ClickB("ChatDown") Then ContinueLoop
			EndIf
		EndIf
		ExitLoop
	WEnd

	$iLastTimeChecked[$g_iCurAccount] = _NowCalc()

	If $bAlreadyWarSigned Then ClickB("ChatDown")

	If _Sleep(1000) Then Return
	If Not ClickB("ClanChat") Then
		SetLog("Error finding the Clan Tab Button", $COLOR_ERROR)
		Return
	EndIf

	If Not $g_bRunState Then Return

EndFunc   ;==>SignUpWar

Func ChkWarSignUp()
	If GUICtrlRead($g_hChkWarSignUp) = $GUI_CHECKED Then
		For $i = $hAllowWar To $hRefuseWar
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		For $i = $hAllowWar To $hRefuseWar
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>ChkWarSignUp

Func UTCTimeEvent()
	Local $UTCTime, $UTCString, $Date, $Time, $Day, $TimeHour
	If _Sleep(100) Then Return
	$UTCTime = _Date_Time_GetSystemTime()
	$UTCString = _Date_Time_SystemTimeToDateTimeStr($UTCTime)
	;Day UTC
	$Date = StringLeft($UTCString, 10)
	$Day = StringSplit($Date, "/", $STR_NOCOUNT)
	;Time UTC
	$Time = StringRight($UTCString, 8)
	$TimeHour = StringSplit($Time, ":", $STR_NOCOUNT)

	; End Of Event (Hammer Jam until 25th of November 2024)
	Local $EventYear = 2024
	Local $EventMonth = 11
	Local $EventDay = 25
	Local $EventHour = 8
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	If $Day[2] > $EventYear Then
		Return False
	Else
		If $Day[0] > $EventMonth Then Return False
		If $Day[0] = $EventMonth Then
			If $Day[1] > $EventDay Then Return False
			If $Day[1] = $EventDay Then
				If $TimeHour[0] > $EventHour Then Return False
			EndIf
		EndIf
	EndIf
	Return True

EndFunc   ;==>UTCTimeEvent
