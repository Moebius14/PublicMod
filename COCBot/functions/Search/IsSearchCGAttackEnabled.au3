; #FUNCTION# ====================================================================================================================
; Name ..........: IsSearchAttackEnabled
; Description ...: Determines if user has selected to not attack.  Uses GUI schedule, random time, or daily attack limit options to stop attacking
; Syntax ........: IsSearchAttackEnabled()
; Parameters ....:
; Return values .: True = attacking CG is enabled, False = if attacking CG is disabled
;					 .; Will return error code if problem determining random no attack time.
; Author ........: AnubiS (01-2022)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func IsSearchCGAttackEnabled()

	If $g_bChkClanGamesEnabled = False Then Return False ; To avoid to do more operation

	If $g_bAttackCGPlannerEnable = False Then Return True ; return true if attack planner is not enabled

	If Not $g_bFirstStartAccountCGRA Then
		$CGRACheckTimer = 0
		$DelayReturnedtocheckCGRA = 0
		$g_bFirstStartAccountCGRA = 1
		$IsStatusForCG = 0
		Return True
	EndIf

	If Not $IsStatusForCG Then $IsStatusForCG = 1

	If $g_bAttackCGPlannerDayLimit And _OverAttackCGLimit() Then         ; check daily attack limit before checking schedule
		SetLog("Daily Clan Games Challenges limit reached, skip attacks !", $COLOR_INFO)
		If $bCGPlannerThenStopBot Then
			SetLog("Bot Will Stop After Routines", $COLOR_DEBUG)
			Sleep(Random(3500, 5500, 1))
			ClickAway()
			Sleep(Random(3500, 5500, 1))
			If IsToFillCCWithMedalsOnly() Then
				Local $aRndFuncList = ['DonateCC,Train', 'CollectFreeMagicItems', 'Collect', 'DailyChallenge', 'UpgradeWall', 'Laboratory', 'UpgradeHeroes', 'UpgradeBuilding', 'PetHouse', 'CheckTombs', 'CleanYard']
			Else
				Local $aRndFuncList = ['DonateCC,Train', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'DailyChallenge', 'UpgradeWall', 'Laboratory', 'UpgradeHeroes', 'UpgradeBuilding', 'PetHouse', 'CheckTombs', 'CleanYard']
			EndIf
			For $Index In $aRndFuncList
				_RunFunction($Index)
			Next
			If $g_bNotifyStopBot Then
				Local $text = "Village : " & $g_sNotifyOrigin & "%0A"
				$text &= "Profile : " & $g_sProfileCurrentName & "%0A"
				If $g_bChkClanGamesEnabled And $g_bChkNotifyCGScore Then
					$text &= "CG Score : " & $g_sClanGamesScore & "%0A"
				EndIf
				If $g_bChkNotifyStarBonusAvail Then
					IsStarBonusAvail()
					$text &= "" & $StarBonusStatus & "%0A"
				EndIf
				$text &= "CG Limit Reached, Bot Stopped"
				NotifyPushToTelegram($text)
			EndIf
			Sleep(Random(3500, 5500, 1))
			CloseCoC(False)
			Sleep(Random(1500, 2500, 1))
			btnStop()
		ElseIf $bCGPlannerThenContinue And $g_bNotifyStopBot Then
			Local $text = "Village : " & $g_sNotifyOrigin & "%0A"
			$text &= "Profile : " & $g_sProfileCurrentName & "%0A"
			If $g_bChkClanGamesEnabled And $g_bChkNotifyCGScore Then
				$text &= "CG Score : " & $g_sClanGamesScore & "%0A"
			EndIf
			If $g_bChkNotifyStarBonusAvail Then
				IsStarBonusAvail()
				$text &= "" & $StarBonusStatus & "%0A"
			EndIf
			$text &= "CG Limit Reached"
			NotifyPushToTelegram($text)
		EndIf
		Return False
	ElseIf $g_bAttackCGPlannerDayLimit And Not _OverAttackCGLimit() Then
		Local $remainingCGattacks = $iRandomAttackCGCountToday - $g_aiAttackedCGCount
		SetLog("Max Clan Games Challenges Today : " & $iRandomAttackCGCountToday & "", $COLOR_ERROR)
		SetLog("Challenges Done in Clan Games Today : " & $g_aiAttackedCGCount & "", $COLOR_BLUE)
		If $remainingCGattacks > 1 Then
			SetLog("Remaining Challenges in Clan Games Today : " & $remainingCGattacks & "", $COLOR_SUCCESS1)
		ElseIf $remainingCGattacks = 1 Then
			SetLog("Last Challenge in Clan Games Today", $COLOR_ERROR)
		EndIf
		Return True
	EndIf

	Return True

EndFunc   ;==>IsSearchCGAttackEnabled

Func _OverAttackCGLimit()
	If $iRandomAttackCGCountToday <= $g_aiAttackedCGCount Then
		$IsReachedMaxCGDayAttack = 1
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>_OverAttackCGLimit
