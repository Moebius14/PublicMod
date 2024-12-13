; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyHeroCount
; Description ...: Obtains count of heroes available from Training - Army Overview window
; Syntax ........: getArmyHeroCount()
; Parameters ....: $bOpenArmyWindow  = Bool value true if train overview window needs to be opened
;				 : $bCloseArmyWindow = Bool value, true if train overview window needs to be closed
; Return values .: None
; Author ........:
; Modified ......: MonkeyHunter (06-2016), MR.ViPER (10-2016), Fliegerfaust (03-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getArmyHeroCount($bOpenArmyWindow = False, $bCloseArmyWindow = False, $CheckWindow = True, $bSetLog = True)

	If $g_bDebugSetLogTrain Or $g_bDebugSetLog Then SetLog("Begin getArmyHeroCount:", $COLOR_DEBUG)

	If $CheckWindow Then
		If Not $bOpenArmyWindow And Not IsTrainPage() Then ; check for train page
			SetError(1)
			Return ; not open, not requested to be open - error.
		ElseIf $bOpenArmyWindow Then
			If Not OpenArmyOverview(True, "getArmyHeroCount()") Then
				SetError(2)
				Return ; not open, requested to be open - error.
			EndIf
			If _Sleep($DELAYCHECKARMYCAMP5) Then Return
		EndIf
	EndIf

	$g_iHeroAvailable = $eHeroNone ; Reset hero available data
	Local $iDebugArmyHeroCount = 0 ; local debug flag

	; Detection by OCR
	Local $sResult
	Local $sMessage = ""

	For $i = 0 To $eHeroSlots - 1
		$sResult = ArmyHeroStatus($i)
		If $sResult <> "" Then ; we found something, figure out what?
			Select
				Case StringInStr($sResult, "king", $STR_NOCASESENSEBASIC)
					If $bSetLog Then SetLog(" - Barbarian King Available", $COLOR_SUCCESS)
					If $bSetLog Then $IsKingReadyForDropTrophies = 1
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroKing)
					; unset King upgrading
					$g_iHeroUpgrading[0] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroQueen, $eHeroPrince, $eHeroWarden, $eHeroChampion))
				Case StringInStr($sResult, "queen", $STR_NOCASESENSEBASIC)
					If $bSetLog Then SetLog(" - Archer Queen Available", $COLOR_SUCCESS)
					If $bSetLog Then $IsQueenReadyForDropTrophies = 1
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroQueen)
					; unset Queen upgrading
					$g_iHeroUpgrading[1] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroPrince, $eHeroWarden, $eHeroChampion))
				Case StringInStr($sResult, "prince", $STR_NOCASESENSEBASIC)
					If $bSetLog Then SetLog(" - Minion Prince Available", $COLOR_SUCCESS)
					If $bSetLog Then $IsPrinceReadyForDropTrophies = 1
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroPrince)
					; unset Queen upgrading
					$g_iHeroUpgrading[2] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroWarden, $eHeroChampion))
				Case StringInStr($sResult, "warden", $STR_NOCASESENSEBASIC)
					If $bSetLog Then SetLog(" - Grand Warden Available", $COLOR_SUCCESS)
					If $bSetLog Then $IsWardenReadyForDropTrophies = 1
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroWarden)
					; unset Warden upgrading
					$g_iHeroUpgrading[3] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroPrince, $eHeroQueen, $eHeroChampion))
				Case StringInStr($sResult, "champion", $STR_NOCASESENSEBASIC)
					If $bSetLog Then SetLog(" - Royal Champion Available", $COLOR_SUCCESS)
					If $bSetLog Then $IsChampionReadyForDropTrophies = 1
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroChampion)
					; unset Champion upgrading
					$g_iHeroUpgrading[4] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroPrince, $eHeroQueen, $eHeroWarden))
				Case StringInStr($sResult, "heal", $STR_NOCASESENSEBASIC)
					If $g_bDebugSetLogTrain Or $iDebugArmyHeroCount = 1 Then
						Switch $i
							Case 0
								Switch $g_aiCmbCustomHeroOrder[$i]
									Case 0
										$sMessage = "-Barbarian King"
										; unset King upgrading
										$g_iHeroUpgrading[0] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroQueen, $eHeroPrince, $eHeroWarden, $eHeroChampion))
										$IsKingReadyForDropTrophies = 0
									Case 1
										$sMessage = "-Archer Queen"
										; unset Queen upgrading
										$g_iHeroUpgrading[1] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroPrince, $eHeroWarden, $eHeroChampion))
										$IsQueenReadyForDropTrophies = 0
									Case 2
										$sMessage = "-Minion Prince"
										; unset Prince upgrading
										$g_iHeroUpgrading[2] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroWarden, $eHeroChampion))
										$IsPrinceReadyForDropTrophies = 0
									Case 3
										$sMessage = "-Grand Warden"
										; unset Warden upgrading
										$g_iHeroUpgrading[3] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroChampion))
										$IsWardenReadyForDropTrophies = 0
									Case 4
										$sMessage = "-Royal Champion"
										; unset Champion upgrading
										$g_iHeroUpgrading[4] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroWarden))
										$IsChampionReadyForDropTrophies = 0
								EndSwitch
							Case 1
								Switch $g_aiCmbCustomHeroOrder[$i]
									Case 0
										$sMessage = "-Barbarian King"
										; unset King upgrading
										$g_iHeroUpgrading[0] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroQueen, $eHeroPrince, $eHeroWarden, $eHeroChampion))
										$IsKingReadyForDropTrophies = 0
									Case 1
										$sMessage = "-Archer Queen"
										; unset Queen upgrading
										$g_iHeroUpgrading[1] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroPrince, $eHeroWarden, $eHeroChampion))
										$IsQueenReadyForDropTrophies = 0
									Case 2
										$sMessage = "-Minion Prince"
										; unset Prince upgrading
										$g_iHeroUpgrading[2] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroWarden, $eHeroChampion))
										$IsPrinceReadyForDropTrophies = 0
									Case 3
										$sMessage = "-Grand Warden"
										; unset Warden upgrading
										$g_iHeroUpgrading[3] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroChampion))
										$IsWardenReadyForDropTrophies = 0
									Case 4
										$sMessage = "-Royal Champion"
										; unset Champion upgrading
										$g_iHeroUpgrading[4] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroWarden))
										$IsChampionReadyForDropTrophies = 0
								EndSwitch
							Case 2
								Switch $g_aiCmbCustomHeroOrder[$i]
									Case 0
										$sMessage = "-Barbarian King"
										; unset King upgrading
										$g_iHeroUpgrading[0] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroQueen, $eHeroPrince, $eHeroWarden, $eHeroChampion))
										$IsKingReadyForDropTrophies = 0
									Case 1
										$sMessage = "-Archer Queen"
										; unset Queen upgrading
										$g_iHeroUpgrading[1] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroPrince, $eHeroWarden, $eHeroChampion))
										$IsQueenReadyForDropTrophies = 0
									Case 2
										$sMessage = "-Minion Prince"
										; unset Prince upgrading
										$g_iHeroUpgrading[2] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroWarden, $eHeroChampion))
										$IsPrinceReadyForDropTrophies = 0
									Case 3
										$sMessage = "-Grand Warden"
										; unset Warden upgrading
										$g_iHeroUpgrading[3] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroChampion))
										$IsWardenReadyForDropTrophies = 0
									Case 4
										$sMessage = "-Royal Champion"
										; unset Champion upgrading
										$g_iHeroUpgrading[4] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroWarden))
										$IsChampionReadyForDropTrophies = 0
								EndSwitch
							Case 3
								Switch $g_aiCmbCustomHeroOrder[$i]
									Case 0
										$sMessage = "-Barbarian King"
										; unset King upgrading
										$g_iHeroUpgrading[0] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroQueen, $eHeroPrince, $eHeroWarden, $eHeroChampion))
										$IsKingReadyForDropTrophies = 0
									Case 1
										$sMessage = "-Archer Queen"
										; unset Queen upgrading
										$g_iHeroUpgrading[1] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroPrince, $eHeroWarden, $eHeroChampion))
										$IsQueenReadyForDropTrophies = 0
									Case 2
										$sMessage = "-Minion Prince"
										; unset Prince upgrading
										$g_iHeroUpgrading[2] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroWarden, $eHeroChampion))
										$IsPrinceReadyForDropTrophies = 0
									Case 3
										$sMessage = "-Grand Warden"
										; unset Warden upgrading
										$g_iHeroUpgrading[3] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroChampion))
										$IsWardenReadyForDropTrophies = 0
									Case 4
										$sMessage = "-Royal Champion"
										; unset Champion upgrading
										$g_iHeroUpgrading[4] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroWarden))
										$IsChampionReadyForDropTrophies = 0
								EndSwitch
							Case 4
								Switch $g_aiCmbCustomHeroOrder[$i]
									Case 0
										$sMessage = "-Barbarian King"
										; unset King upgrading
										$g_iHeroUpgrading[0] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroQueen, $eHeroPrince, $eHeroWarden, $eHeroChampion))
										$IsKingReadyForDropTrophies = 0
									Case 1
										$sMessage = "-Archer Queen"
										; unset Queen upgrading
										$g_iHeroUpgrading[1] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroPrince, $eHeroWarden, $eHeroChampion))
										$IsQueenReadyForDropTrophies = 0
									Case 2
										$sMessage = "-Minion Prince"
										; unset Prince upgrading
										$g_iHeroUpgrading[2] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroWarden, $eHeroChampion))
										$IsPrinceReadyForDropTrophies = 0
									Case 3
										$sMessage = "-Grand Warden"
										; unset Warden upgrading
										$g_iHeroUpgrading[3] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroChampion))
										$IsWardenReadyForDropTrophies = 0
									Case 4
										$sMessage = "-Royal Champion"
										; unset Champion upgrading
										$g_iHeroUpgrading[4] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroWarden))
										$IsChampionReadyForDropTrophies = 0
									Case Else
										$sMessage = "-Very Bad Monkey Needs"
								EndSwitch
						EndSwitch
						SetLog("Hero slot#" & $i + 1 & $sMessage & " Healing", $COLOR_DEBUG)
					EndIf
				Case StringInStr($sResult, "upgrade", $STR_NOCASESENSEBASIC)
					Switch $i
						Case 0
							Switch $g_aiCmbCustomHeroOrder[$i]
								Case 0
									$sMessage = "-Barbarian King"
									; set King upgrading
									$g_iHeroUpgrading[0] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroKing)
									$IsKingReadyForDropTrophies = 0
									; safety code to warn user when wait for hero found while being upgraded to reduce stupid user posts for not attacking
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroKing) = $eHeroKing) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroKing) = $eHeroKing) Then     ; check wait for hero status
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroKing)
										Else
											SetLog("Warning: King Upgrading & Wait enabled, Disable Wait for King or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupKingSleeping)     ; Show king sleeping icon
									EndIf
								Case 1
									$sMessage = "-Archer Queen"
									; set Queen upgrading
									$g_iHeroUpgrading[1] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroQueen)
									$IsQueenReadyForDropTrophies = 0
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroQueen) = $eHeroQueen) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroQueen) = $eHeroQueen) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroQueen)
										Else
											SetLog("Warning: Queen Upgrading & Wait enabled, Disable Wait for Queen or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupQueenSleeping) ; Show Queen sleeping icon
									EndIf
								Case 2
									$sMessage = "-Minion Prince"
									; set Prince upgrading
									$g_iHeroUpgrading[2] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroPrince)
									$IsPrinceReadyForDropTrophies = 0
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroPrince) = $eHeroPrince) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroPrince) = $eHeroPrince) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroPrince)
										Else
											SetLog("Warning: Prince Upgrading & Wait enabled, Disable Wait for Prince or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupPrinceSleeping) ; Show Prince sleeping icon
									EndIf
								Case 3
									$sMessage = "-Grand Warden"
									; set Warden upgrading
									$g_iHeroUpgrading[3] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroWarden)
									$IsWardenReadyForDropTrophies = 0
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroWarden) = $eHeroWarden) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroWarden) = $eHeroWarden) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroWarden)
										Else
											SetLog("Warning: Warden Upgrading & Wait enabled, Disable Wait for Warden or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupWardenSleeping) ; Show Warden sleeping icon
									EndIf
								Case 4
									$sMessage = "-Royal Champion"
									; set Champion upgrading
									$g_iHeroUpgrading[4] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroChampion)
									$IsChampionReadyForDropTrophies = 0
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroChampion) = $eHeroChampion) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroChampion) = $eHeroChampion) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroChampion)
										Else
											SetLog("Warning: Royal Champion Upgrading & Wait enabled, Disable Wait for Royal Champion or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupChampionSleeping) ; Show Champion sleeping icon
									EndIf
							EndSwitch
						Case 1
							Switch $g_aiCmbCustomHeroOrder[$i]
								Case 0
									$sMessage = "-Barbarian King"
									; set King upgrading
									$g_iHeroUpgrading[0] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroKing)
									$IsKingReadyForDropTrophies = 0
									; safety code to warn user when wait for hero found while being upgraded to reduce stupid user posts for not attacking
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroKing) = $eHeroKing) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroKing) = $eHeroKing) Then     ; check wait for hero status
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroKing)
										Else
											SetLog("Warning: King Upgrading & Wait enabled, Disable Wait for King or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupKingSleeping)     ; Show king sleeping icon
									EndIf
								Case 1
									$sMessage = "-Archer Queen"
									; set Queen upgrading
									$g_iHeroUpgrading[1] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroQueen)
									$IsQueenReadyForDropTrophies = 0
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroQueen) = $eHeroQueen) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroQueen) = $eHeroQueen) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroQueen)
										Else
											SetLog("Warning: Queen Upgrading & Wait enabled, Disable Wait for Queen or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupQueenSleeping) ; Show Queen sleeping icon
									EndIf
								Case 2
									$sMessage = "-Minion Prince"
									; set Prince upgrading
									$g_iHeroUpgrading[2] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroPrince)
									$IsPrinceReadyForDropTrophies = 0
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroPrince) = $eHeroPrince) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroPrince) = $eHeroPrince) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroPrince)
										Else
											SetLog("Warning: Prince Upgrading & Wait enabled, Disable Wait for Prince or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupPrinceSleeping) ; Show Prince sleeping icon
									EndIf
								Case 3
									$sMessage = "-Grand Warden"
									; set Warden upgrading
									$g_iHeroUpgrading[3] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroWarden)
									$IsWardenReadyForDropTrophies = 0
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroWarden) = $eHeroWarden) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroWarden) = $eHeroWarden) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroWarden)
										Else
											SetLog("Warning: Warden Upgrading & Wait enabled, Disable Wait for Warden or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupWardenSleeping) ; Show Warden sleeping icon
									EndIf
								Case 4
									$sMessage = "-Royal Champion"
									; set Champion upgrading
									$g_iHeroUpgrading[4] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroChampion)
									$IsChampionReadyForDropTrophies = 0
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroChampion) = $eHeroChampion) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroChampion) = $eHeroChampion) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroChampion)
										Else
											SetLog("Warning: Royal Champion Upgrading & Wait enabled, Disable Wait for Royal Champion or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupChampionSleeping) ; Show Champion sleeping icon
									EndIf
							EndSwitch
						Case 2
							Switch $g_aiCmbCustomHeroOrder[$i]
								Case 0
									$sMessage = "-Barbarian King"
									; set King upgrading
									$g_iHeroUpgrading[0] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroKing)
									$IsKingReadyForDropTrophies = 0
									; safety code to warn user when wait for hero found while being upgraded to reduce stupid user posts for not attacking
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroKing) = $eHeroKing) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroKing) = $eHeroKing) Then     ; check wait for hero status
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroKing)
										Else
											SetLog("Warning: King Upgrading & Wait enabled, Disable Wait for King or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupKingSleeping)     ; Show king sleeping icon
									EndIf
								Case 1
									$sMessage = "-Archer Queen"
									; set Queen upgrading
									$g_iHeroUpgrading[1] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroQueen)
									$IsQueenReadyForDropTrophies = 0
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroQueen) = $eHeroQueen) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroQueen) = $eHeroQueen) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroQueen)
										Else
											SetLog("Warning: Queen Upgrading & Wait enabled, Disable Wait for Queen or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupQueenSleeping) ; Show Queen sleeping icon
									EndIf
								Case 2
									$sMessage = "-Minion Prince"
									; set Prince upgrading
									$g_iHeroUpgrading[2] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroPrince)
									$IsPrinceReadyForDropTrophies = 0
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroPrince) = $eHeroPrince) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroPrince) = $eHeroPrince) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroPrince)
										Else
											SetLog("Warning: Prince Upgrading & Wait enabled, Disable Wait for Prince or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupPrinceSleeping) ; Show Prince sleeping icon
									EndIf
								Case 3
									$sMessage = "-Grand Warden"
									; set Warden upgrading
									$g_iHeroUpgrading[3] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroWarden)
									$IsWardenReadyForDropTrophies = 0
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroWarden) = $eHeroWarden) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroWarden) = $eHeroWarden) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroWarden)
										Else
											SetLog("Warning: Warden Upgrading & Wait enabled, Disable Wait for Warden or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupWardenSleeping) ; Show Warden sleeping icon
									EndIf
								Case 4
									$sMessage = "-Royal Champion"
									; set Champion upgrading
									$g_iHeroUpgrading[4] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroChampion)
									$IsChampionReadyForDropTrophies = 0
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroChampion) = $eHeroChampion) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroChampion) = $eHeroChampion) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroChampion)
										Else
											SetLog("Warning: Royal Champion Upgrading & Wait enabled, Disable Wait for Royal Champion or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupChampionSleeping) ; Show Champion sleeping icon
									EndIf
							EndSwitch
						Case 3
							Switch $g_aiCmbCustomHeroOrder[$i]
								Case 0
									$sMessage = "-Barbarian King"
									; set King upgrading
									$g_iHeroUpgrading[0] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroKing)
									$IsKingReadyForDropTrophies = 0
									; safety code to warn user when wait for hero found while being upgraded to reduce stupid user posts for not attacking
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroKing) = $eHeroKing) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroKing) = $eHeroKing) Then     ; check wait for hero status
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroKing)
										Else
											SetLog("Warning: King Upgrading & Wait enabled, Disable Wait for King or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupKingSleeping)     ; Show king sleeping icon
									EndIf
								Case 1
									$sMessage = "-Archer Queen"
									; set Queen upgrading
									$g_iHeroUpgrading[1] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroQueen)
									$IsQueenReadyForDropTrophies = 0
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroQueen) = $eHeroQueen) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroQueen) = $eHeroQueen) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroQueen)
										Else
											SetLog("Warning: Queen Upgrading & Wait enabled, Disable Wait for Queen or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupQueenSleeping) ; Show Queen sleeping icon
									EndIf
								Case 2
									$sMessage = "-Minion Prince"
									; set Prince upgrading
									$g_iHeroUpgrading[2] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroPrince)
									$IsPrinceReadyForDropTrophies = 0
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroPrince) = $eHeroPrince) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroPrince) = $eHeroPrince) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroPrince)
										Else
											SetLog("Warning: Prince Upgrading & Wait enabled, Disable Wait for Prince or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupPrinceSleeping) ; Show Prince sleeping icon
									EndIf
								Case 3
									$sMessage = "-Grand Warden"
									; set Warden upgrading
									$g_iHeroUpgrading[3] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroWarden)
									$IsWardenReadyForDropTrophies = 0
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroWarden) = $eHeroWarden) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroWarden) = $eHeroWarden) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroWarden)
										Else
											SetLog("Warning: Warden Upgrading & Wait enabled, Disable Wait for Warden or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupWardenSleeping) ; Show Warden sleeping icon
									EndIf
								Case 4
									$sMessage = "-Royal Champion"
									; set Champion upgrading
									$g_iHeroUpgrading[4] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroChampion)
									$IsChampionReadyForDropTrophies = 0
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroChampion) = $eHeroChampion) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroChampion) = $eHeroChampion) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroChampion)
										Else
											SetLog("Warning: Royal Champion Upgrading & Wait enabled, Disable Wait for Royal Champion or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupChampionSleeping) ; Show Champion sleeping icon
									EndIf
							EndSwitch
						Case 4
							Switch $g_aiCmbCustomHeroOrder[$i]
								Case 0
									$sMessage = "-Barbarian King"
									; set King upgrading
									$g_iHeroUpgrading[0] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroKing)
									$IsKingReadyForDropTrophies = 0
									; safety code to warn user when wait for hero found while being upgraded to reduce stupid user posts for not attacking
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroKing) = $eHeroKing) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroKing) = $eHeroKing) Then     ; check wait for hero status
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroKing)
										Else
											SetLog("Warning: King Upgrading & Wait enabled, Disable Wait for King or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupKingSleeping)     ; Show king sleeping icon
									EndIf
								Case 1
									$sMessage = "-Archer Queen"
									; set Queen upgrading
									$g_iHeroUpgrading[1] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroQueen)
									$IsQueenReadyForDropTrophies = 0
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroQueen) = $eHeroQueen) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroQueen) = $eHeroQueen) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroQueen)
										Else
											SetLog("Warning: Queen Upgrading & Wait enabled, Disable Wait for Queen or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupQueenSleeping) ; Show Queen sleeping icon
									EndIf
								Case 2
									$sMessage = "-Minion Prince"
									; set Prince upgrading
									$g_iHeroUpgrading[2] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroPrince)
									$IsPrinceReadyForDropTrophies = 0
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroPrince) = $eHeroPrince) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroPrince) = $eHeroPrince) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroPrince)
										Else
											SetLog("Warning: Prince Upgrading & Wait enabled, Disable Wait for Prince or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupPrinceSleeping) ; Show Prince sleeping icon
									EndIf
								Case 3
									$sMessage = "-Grand Warden"
									; set Warden upgrading
									$g_iHeroUpgrading[3] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroWarden)
									$IsWardenReadyForDropTrophies = 0
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroWarden) = $eHeroWarden) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroWarden) = $eHeroWarden) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroWarden)
										Else
											SetLog("Warning: Warden Upgrading & Wait enabled, Disable Wait for Warden or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupWardenSleeping) ; Show Warden sleeping icon
									EndIf
								Case 4
									$sMessage = "-Royal Champion"
									; set Champion upgrading
									$g_iHeroUpgrading[4] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroChampion)
									$IsChampionReadyForDropTrophies = 0
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroChampion) = $eHeroChampion) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroChampion) = $eHeroChampion) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroChampion)
										Else
											SetLog("Warning: Royal Champion Upgrading & Wait enabled, Disable Wait for Royal Champion or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupChampionSleeping) ; Show Champion sleeping icon
									EndIf
								Case Else
									$sMessage = "-Need to Feed Code Monkey some bananas"
							EndSwitch
					EndSwitch
					If $g_bDebugSetLogTrain Or $iDebugArmyHeroCount = 1 Then SetLog("Hero slot#" & $i + 1 & $sMessage & " Upgrade in Process", $COLOR_DEBUG)
				Case StringInStr($sResult, "none", $STR_NOCASESENSEBASIC)
					If $g_bDebugSetLogTrain Or $iDebugArmyHeroCount = 1 Then SetLog("Hero slot#" & $i + 1 & " Empty, stop count", $COLOR_DEBUG)
					ExitLoop ; when we find empty slots, done looking for heroes
				Case Else
					If $bSetLog Then SetLog("Hero slot#" & $i + 1 & " bad OCR string returned!", $COLOR_ERROR)
			EndSelect
		Else
			If $bSetLog Then SetLog("Hero slot#" & $i + 1 & " status read problem!", $COLOR_ERROR)
		EndIf
	Next

	If $g_bDebugSetLogTrain Or $iDebugArmyHeroCount = 1 Then SetLog("Hero Status  K|Q|P|W|C : " & BitAND($g_iHeroAvailable, $eHeroKing) & "|" & BitAND($g_iHeroAvailable, $eHeroQueen) & "|" & BitAND($g_iHeroAvailable, $eHeroPrince) & "|" & BitAND($g_iHeroAvailable, $eHeroWarden) & "|" & BitAND($g_iHeroAvailable, $eHeroChampion), $COLOR_DEBUG)
	If $g_bDebugSetLogTrain Or $iDebugArmyHeroCount = 1 Then SetLog("Hero Upgrade K|Q|P|W|C : " & BitAND($g_iHeroUpgradingBit, $eHeroKing) & "|" & BitAND($g_iHeroUpgradingBit, $eHeroQueen) & "|" & BitAND($g_iHeroUpgradingBit, $eHeroPrince) & "|" & BitAND($g_iHeroUpgradingBit, $eHeroWarden) & "|" & BitAND($g_iHeroUpgradingBit, $eHeroChampion), $COLOR_DEBUG)

	If $bCloseArmyWindow Then CloseWindow()

EndFunc   ;==>getArmyHeroCount

Func ArmyHeroStatus($i)
	If $g_bFirstStartForHiddenHero Then
		Switch $g_aiCmbCustomHeroOrder[4]
			Case 0
				GUICtrlSetState($g_hPicKingGray, $GUI_SHOW)
				GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
			Case 1
				GUICtrlSetState($g_hPicQueenGray, $GUI_SHOW)
				GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
			Case 2
				GUICtrlSetState($g_hPicPrinceGray, $GUI_SHOW)
				GUICtrlSetState($g_hPicPrinceRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
			Case 3
				GUICtrlSetState($g_hPicWardenGray, $GUI_SHOW)
				GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
			Case 4
				GUICtrlSetState($g_hPicChampionGray, $GUI_SHOW)
				GUICtrlSetState($g_hPicChampionRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
		EndSwitch
	EndIf
	Local $sResult = ""
	Local Const $aHeroesRect[$eHeroSlots][4] = [[525, 315 + $g_iMidOffsetY, 589, 375 + $g_iMidOffsetY], _
			[590, 315 + $g_iMidOffsetY, 653, 375 + $g_iMidOffsetY], _
			[654, 315 + $g_iMidOffsetY, 717, 375 + $g_iMidOffsetY], _
			[718, 315 + $g_iMidOffsetY, 780, 375 + $g_iMidOffsetY]]                                     ; Review

	; Perform the search
	_CaptureRegion2($aHeroesRect[$i][0], $aHeroesRect[$i][1], $aHeroesRect[$i][2], $aHeroesRect[$i][3])
	Local $res = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $g_sImgArmyOverviewHeroes, "str", "FV", "Int", 0, "str", "FV", "Int", 0, "Int", 1000)
	If $res[0] <> "" Then
		Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT)
		If StringInStr($aKeys[0], "xml", $STR_NOCASESENSEBASIC) Then
			Local $aResult = StringSplit($aKeys[0], "_", $STR_NOCOUNT)
			$sResult = $aResult[0]
			Select
				Case $g_aiCmbCustomHeroOrder[$i] = 0
					Switch $sResult
						Case "heal" ; Blue
							GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
							GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
							GUICtrlSetState($g_hPicKingBlue, $GUI_SHOW)
						Case "upgrade" ; Red
							GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
							GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
							GUICtrlSetState($g_hPicKingRed, $GUI_SHOW)
						Case "king" ; Green
							GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
							GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
							GUICtrlSetState($g_hPicKingGreen, $GUI_SHOW)
					EndSwitch
				Case $g_aiCmbCustomHeroOrder[$i] = 1
					Switch $sResult
						Case "heal" ; Blue
							GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
							GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
							GUICtrlSetState($g_hPicQueenBlue, $GUI_SHOW)
						Case "upgrade" ; Red
							GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
							GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
							GUICtrlSetState($g_hPicQueenRed, $GUI_SHOW)
						Case "queen" ; Green
							GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
							GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
							GUICtrlSetState($g_hPicQueenGreen, $GUI_SHOW)
					EndSwitch
				Case $g_aiCmbCustomHeroOrder[$i] = 2
					Switch $sResult
						Case "heal" ; Blue
							GUICtrlSetState($g_hPicPrinceGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
							GUICtrlSetState($g_hPicPrinceRed, $GUI_HIDE)
							GUICtrlSetState($g_hPicPrinceBlue, $GUI_SHOW)
						Case "upgrade" ; Red
							GUICtrlSetState($g_hPicPrinceGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
							GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
							GUICtrlSetState($g_hPicPrinceRed, $GUI_SHOW)
						Case "Prince" ; Green
							GUICtrlSetState($g_hPicPrinceGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicPrinceRed, $GUI_HIDE)
							GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
							GUICtrlSetState($g_hPicPrinceGreen, $GUI_SHOW)
					EndSwitch
				Case $g_aiCmbCustomHeroOrder[$i] = 3
					Switch $sResult
						Case "heal" ; Blue
							GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
							GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
							GUICtrlSetState($g_hPicWardenBlue, $GUI_SHOW)
						Case "upgrade" ; Red
							GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
							GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
							GUICtrlSetState($g_hPicWardenRed, $GUI_SHOW)
						Case "warden" ; Green
							GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
							GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
							GUICtrlSetState($g_hPicWardenGreen, $GUI_SHOW)
					EndSwitch
				Case $g_aiCmbCustomHeroOrder[$i] = 4
					Switch $sResult
						Case "heal" ; Blue
							GUICtrlSetState($g_hPicChampionGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
							GUICtrlSetState($g_hPicChampionRed, $GUI_HIDE)
							GUICtrlSetState($g_hPicChampionBlue, $GUI_SHOW)
						Case "upgrade" ; Red
							GUICtrlSetState($g_hPicChampionGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
							GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
							GUICtrlSetState($g_hPicChampionRed, $GUI_SHOW)
						Case "Champion" ; Green
							GUICtrlSetState($g_hPicChampionGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicChampionRed, $GUI_HIDE)
							GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
							GUICtrlSetState($g_hPicChampionGreen, $GUI_SHOW)
					EndSwitch
			EndSelect
			Return $sResult
		EndIf
	EndIf

	;return 'none' if there was a problem with the search ; or no Hero slot
	Switch $i
		Case $g_aiCmbCustomHeroOrder[$i] = 0
			GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
			GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicKingGray, $GUI_SHOW)
			Return "none"
		Case $g_aiCmbCustomHeroOrder[$i] = 1
			GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
			GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicQueenGray, $GUI_SHOW)
			Return "none"
		Case $g_aiCmbCustomHeroOrder[$i] = 2
			GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
			GUICtrlSetState($g_hPicPrinceRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicPrinceGray, $GUI_SHOW)
			Return "none"
		Case $g_aiCmbCustomHeroOrder[$i] = 3
			GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
			GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicWardenGray, $GUI_SHOW)
			Return "none"
		Case $g_aiCmbCustomHeroOrder[$i] = 4
			GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
			GUICtrlSetState($g_hPicChampionRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicChampionGray, $GUI_SHOW)
			Return "none"
	EndSwitch

EndFunc   ;==>ArmyHeroStatus

Func HiddenSlotstatus()
	If $g_iTownHallLevel < 13 Then
		Switch $g_aiCmbCustomHeroOrder[4]
			Case 0
				GUICtrlSetState($g_hPicKingGray, $GUI_SHOW)
				GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
			Case 1
				GUICtrlSetState($g_hPicQueenGray, $GUI_SHOW)
				GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
			Case 2
				GUICtrlSetState($g_hPicPrinceGray, $GUI_SHOW)
				GUICtrlSetState($g_hPicPrinceRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
			Case 3
				GUICtrlSetState($g_hPicWardenGray, $GUI_SHOW)
				GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
			Case 4
				GUICtrlSetState($g_hPicChampionGray, $GUI_SHOW)
				GUICtrlSetState($g_hPicChampionRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
		EndSwitch
		Return
	Else
		Local Static $iLastTimeCheckedHidden[8]
		If $g_bFirstStartForHiddenHero Then $iLastTimeCheckedHidden[$g_iCurAccount] = ""

		; Check if is a valid date
		If _DateIsValid($iLastTimeCheckedHidden[$g_iCurAccount]) Then
			Local $iLastCheck = _DateDiff('s', $iLastTimeCheckedHidden[$g_iCurAccount], _NowCalc()) ; elapse time from last check (minutes)
			SetDebugLog("Hero Hall LastCheck: " & $iLastTimeCheckedHidden[$g_iCurAccount] & ", Check DateCalc: " & $iLastCheck)
			; A check each from 1.5 to 2 hours [1.5*60 = 90 to 2*60 = 120]
			Local $iDelayToCheck = Random(90, 120, 1) * 60 ; Convert in seconds
			If $iLastCheck < $iDelayToCheck Then
				If _Sleep(1000) Then Return
				Return
			EndIf
		EndIf

		ClearScreen()
		If _Sleep(1500) Then Return ; Delay AFTER the click Away Prevents lots of coc restarts

		SetLog("Checking " & $g_asHeroNames[$g_aiCmbCustomHeroOrder[4]] & " Status", $COLOR_INFO)

		BuildingClick($g_aiHeroHallPos[0], $g_aiHeroHallPos[1])
		If _Sleep($DELAYBUILDINGINFO1) Then Return
		Local $sHeroHallInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
		If StringInStr($sHeroHallInfo[1], "Hero") Then
			If $g_aiHeroHallPos[2] <> $sHeroHallInfo[2] Then
				$g_aiHeroHallPos[2] = $sHeroHallInfo[2]
				HeroSlotLock()
			EndIf
			Local $HeroHallButton = FindButton("HeroHallButton")
			If IsArray($HeroHallButton) And UBound($HeroHallButton) = 2 Then
				ClickP($HeroHallButton)
				If _Sleep(Random(1500, 2000, 1)) Then Return
			Else
				SetLog("Hero Hall Button not found", $COLOR_ERROR)
				ClearScreen()
				Switch $g_aiCmbCustomHeroOrder[4]
					Case 0
						GUICtrlSetState($g_hPicKingGray, $GUI_SHOW)
						GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
						GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
						GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
						$g_aiHiddenHeroStatus[0] = 0
					Case 1
						GUICtrlSetState($g_hPicQueenGray, $GUI_SHOW)
						GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
						GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
						GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
						$g_aiHiddenHeroStatus[1] = 0
					Case 2
						GUICtrlSetState($g_hPicPrinceGray, $GUI_SHOW)
						GUICtrlSetState($g_hPicPrinceRed, $GUI_HIDE)
						GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
						GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
						$g_aiHiddenHeroStatus[2] = 0
					Case 3
						GUICtrlSetState($g_hPicWardenGray, $GUI_SHOW)
						GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
						GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
						GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
						$g_aiHiddenHeroStatus[3] = 0
					Case 4
						GUICtrlSetState($g_hPicChampionGray, $GUI_SHOW)
						GUICtrlSetState($g_hPicChampionRed, $GUI_HIDE)
						GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
						GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
						$g_aiHiddenHeroStatus[4] = 0
				EndSwitch
			EndIf
		EndIf

		If Not QuickMIS("BC1", $g_sImgGeneralCloseButton, 780, 145 + $g_iMidOffsetY, 815, 175 + $g_iMidOffsetY) Then
			SetLog("Hero Hall Window Didn't Open", $COLOR_DEBUG1)
			CloseWindow2()
			If _Sleep(1000) Then Return
			ClearScreen()
			Switch $g_aiCmbCustomHeroOrder[4]
				Case 0
					GUICtrlSetState($g_hPicKingGray, $GUI_SHOW)
					GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
					$g_aiHiddenHeroStatus[0] = 0
				Case 1
					GUICtrlSetState($g_hPicQueenGray, $GUI_SHOW)
					GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
					$g_aiHiddenHeroStatus[1] = 0
				Case 2
					GUICtrlSetState($g_hPicPrinceGray, $GUI_SHOW)
					GUICtrlSetState($g_hPicPrinceRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
					$g_aiHiddenHeroStatus[2] = 0
				Case 3
					GUICtrlSetState($g_hPicWardenGray, $GUI_SHOW)
					GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
					$g_aiHiddenHeroStatus[3] = 0
				Case 4
					GUICtrlSetState($g_hPicChampionGray, $GUI_SHOW)
					GUICtrlSetState($g_hPicChampionRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
					$g_aiHiddenHeroStatus[4] = 0
			EndSwitch
		EndIf

		$iLastTimeCheckedHidden[$g_iCurAccount] = _NowCalc()
		$g_bFirstStartForHiddenHero = 0

		Local $bInitalXcoord = 67
		Local $bDistanceSlot = 153
		Local $bXcoords[5] = [$bInitalXcoord, $bInitalXcoord + $bDistanceSlot, $bInitalXcoord + $bDistanceSlot * 2, $bInitalXcoord + $bDistanceSlot * 3, $bInitalXcoord + $bDistanceSlot * 4]

		Switch $g_aiCmbCustomHeroOrder[4]
			Case 0
				Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $bXcoords[0] + 20, 420 + $g_iMidOffsetY, $bXcoords[0] + 65, 445 + $g_iMidOffsetY, True))
				If IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2 Then
					GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingGreen, $GUI_SHOW)
					$g_aiHiddenHeroStatus[0] = 1
					$g_iHeroUpgrading[0] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroQueen, $eHeroPrince, $eHeroWarden, $eHeroChampion))
					SetLog($g_asHeroNames[0] & " is ready to fight", $COLOR_SUCCESS1)
					CloseWindow()
					Return
				EndIf
				If _ColorCheck(_GetPixelColor($bXcoords[0], 438 + $g_iMidOffsetY, True), Hex(0x6D6D6D, 6), 15) Then
					GUICtrlSetState($g_hPicKingGray, $GUI_SHOW)
					GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
					$g_aiHiddenHeroStatus[0] = 0
					SetLog($g_asHeroNames[0] & " is not available", $COLOR_DEBUG2)
				ElseIf _ColorCheck(_GetPixelColor($bXcoords[0], 438 + $g_iMidOffsetY, True), Hex(0xADADAD, 6), 15) Or _ColorCheck(_GetPixelColor($bXcoords[0], 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 15) Then
					GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingGreen, $GUI_SHOW)
					$g_aiHiddenHeroStatus[0] = 1
					$g_iHeroUpgrading[0] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroQueen, $eHeroPrince, $eHeroWarden, $eHeroChampion))
					SetLog($g_asHeroNames[0] & " is ready to fight", $COLOR_SUCCESS1)
				ElseIf IsArray(_PixelSearch($bXcoords[0] - 6, 438 + $g_iMidOffsetY, $bXcoords[0] + 10, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
					GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingRed, $GUI_SHOW)
					GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
					SetLog($g_asHeroNames[0] & " is being upgraded", $COLOR_DEBUG)
					;Set Status Variable
					$g_aiHiddenHeroStatus[0] = 2
					$g_iHeroUpgrading[0] = 1
					$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroKing)
				EndIf
				CloseWindow()
				Return
			Case 1
				Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $bXcoords[1] + 20, 420 + $g_iMidOffsetY, $bXcoords[1] + 65, 445 + $g_iMidOffsetY, True))
				If IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2 Then
					GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenGreen, $GUI_SHOW)
					$g_aiHiddenHeroStatus[1] = 1
					$g_iHeroUpgrading[1] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroPrince, $eHeroWarden, $eHeroChampion))
					SetLog($g_asHeroNames[1] & " is ready to fight", $COLOR_SUCCESS1)
					CloseWindow()
					Return
				EndIf
				If _ColorCheck(_GetPixelColor($bXcoords[1], 438 + $g_iMidOffsetY, True), Hex(0x6D6D6D, 6), 15) Then
					GUICtrlSetState($g_hPicQueenGray, $GUI_SHOW)
					GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
					$g_aiHiddenHeroStatus[1] = 0
					SetLog($g_asHeroNames[1] & " is not available", $COLOR_DEBUG2)
				ElseIf _ColorCheck(_GetPixelColor($bXcoords[1], 438 + $g_iMidOffsetY, True), Hex(0xADADAD, 6), 15) Or _ColorCheck(_GetPixelColor($bXcoords[1], 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 15) Then
					GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenGreen, $GUI_SHOW)
					$g_aiHiddenHeroStatus[1] = 1
					$g_iHeroUpgrading[1] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroPrince, $eHeroWarden, $eHeroChampion))
					SetLog($g_asHeroNames[1] & " is ready to fight", $COLOR_SUCCESS1)
				ElseIf IsArray(_PixelSearch($bXcoords[1] - 6, 438 + $g_iMidOffsetY, $bXcoords[1] + 10, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
					GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenRed, $GUI_SHOW)
					GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
					SetLog($g_asHeroNames[1] & " is being upgraded", $COLOR_DEBUG)
					;Set Status Variable
					$g_aiHiddenHeroStatus[1] = 2
					$g_iHeroUpgrading[1] = 1
					$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroQueen)
				EndIf
				CloseWindow()
				Return
			Case 2
				Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $bXcoords[2] + 20, 420 + $g_iMidOffsetY, $bXcoords[2] + 65, 445 + $g_iMidOffsetY, True))
				If IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2 Then
					GUICtrlSetState($g_hPicPrinceGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceGreen, $GUI_SHOW)
					$g_aiHiddenHeroStatus[2] = 1
					$g_iHeroUpgrading[2] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroWarden, $eHeroChampion))
					SetLog($g_asHeroNames[2] & " is ready to fight", $COLOR_SUCCESS1)
					CloseWindow()
					Return
				EndIf
				If _ColorCheck(_GetPixelColor($bXcoords[2], 438 + $g_iMidOffsetY, True), Hex(0x6D6D6D, 6), 15) Then
					GUICtrlSetState($g_hPicPrinceGray, $GUI_SHOW)
					GUICtrlSetState($g_hPicPrinceRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
					$g_aiHiddenHeroStatus[2] = 0
					SetLog($g_asHeroNames[2] & " is not available", $COLOR_DEBUG2)
				ElseIf _ColorCheck(_GetPixelColor($bXcoords[2], 438 + $g_iMidOffsetY, True), Hex(0xADADAD, 6), 15) Or _ColorCheck(_GetPixelColor($bXcoords[2], 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 15) Then
					GUICtrlSetState($g_hPicPrinceGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceGreen, $GUI_SHOW)
					$g_aiHiddenHeroStatus[2] = 1
					$g_iHeroUpgrading[2] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroWarden, $eHeroChampion))
					SetLog($g_asHeroNames[2] & " is ready to fight", $COLOR_SUCCESS1)
				ElseIf IsArray(_PixelSearch($bXcoords[2] - 6, 438 + $g_iMidOffsetY, $bXcoords[2] + 10, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
					GUICtrlSetState($g_hPicPrinceGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceRed, $GUI_SHOW)
					GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
					SetLog($g_asHeroNames[2] & " is being upgraded", $COLOR_DEBUG)
					;Set Status Variable
					$g_aiHiddenHeroStatus[2] = 2
					$g_iHeroUpgrading[2] = 1
					$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroPrince)
				EndIf
				CloseWindow()
				Return
			Case 3
				Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $bXcoords[3] + 20, 420 + $g_iMidOffsetY, $bXcoords[3] + 65, 445 + $g_iMidOffsetY, True))
				If IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2 Then
					GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenGreen, $GUI_SHOW)
					$g_aiHiddenHeroStatus[3] = 1
					$g_iHeroUpgrading[3] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroChampion))
					SetLog($g_asHeroNames[3] & " is ready to fight", $COLOR_SUCCESS1)
					CloseWindow()
					Return
				EndIf
				If _ColorCheck(_GetPixelColor($bXcoords[3], 438 + $g_iMidOffsetY, True), Hex(0x6D6D6D, 6), 15) Then
					GUICtrlSetState($g_hPicWardenGray, $GUI_SHOW)
					GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
					$g_aiHiddenHeroStatus[3] = 0
					SetLog($g_asHeroNames[3] & " is not available", $COLOR_DEBUG2)
				ElseIf _ColorCheck(_GetPixelColor($bXcoords[3], 438 + $g_iMidOffsetY, True), Hex(0xADADAD, 6), 15) Or _ColorCheck(_GetPixelColor($bXcoords[3], 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 15) Then
					GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenGreen, $GUI_SHOW)
					$g_aiHiddenHeroStatus[3] = 1
					$g_iHeroUpgrading[3] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroChampion))
					SetLog($g_asHeroNames[3] & " is ready to fight", $COLOR_SUCCESS1)
				ElseIf IsArray(_PixelSearch($bXcoords[3] - 6, 438 + $g_iMidOffsetY, $bXcoords[3] + 10, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
					GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenRed, $GUI_SHOW)
					GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
					SetLog($g_asHeroNames[3] & " is being upgraded", $COLOR_DEBUG)
					;Set Status Variable
					$g_aiHiddenHeroStatus[3] = 2
					$g_iHeroUpgrading[3] = 1
					$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroWarden)
				EndIf
				CloseWindow()
				Return
			Case 4
				Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $bXcoords[4] + 20, 420 + $g_iMidOffsetY, $bXcoords[4] + 65, 445 + $g_iMidOffsetY, True))
				If IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2 Then
					GUICtrlSetState($g_hPicChampionGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionGreen, $GUI_SHOW)
					$g_aiHiddenHeroStatus[4] = 1
					$g_iHeroUpgrading[4] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroWarden))
					SetLog($g_asHeroNames[4] & " is ready to fight", $COLOR_SUCCESS1)
					CloseWindow()
					Return
				EndIf
				If _ColorCheck(_GetPixelColor($bXcoords[4], 438 + $g_iMidOffsetY, True), Hex(0x6D6D6D, 6), 15) Then
					GUICtrlSetState($g_hPicChampionGray, $GUI_SHOW)
					GUICtrlSetState($g_hPicChampionRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
					$g_aiHiddenHeroStatus[4] = 0
					SetLog($g_asHeroNames[4] & " is not available", $COLOR_DEBUG2)
				ElseIf _ColorCheck(_GetPixelColor($bXcoords[4], 438 + $g_iMidOffsetY, True), Hex(0xADADAD, 6), 15) Or _ColorCheck(_GetPixelColor($bXcoords[4], 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 15) Then
					GUICtrlSetState($g_hPicChampionGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionGreen, $GUI_SHOW)
					$g_aiHiddenHeroStatus[4] = 1
					$g_iHeroUpgrading[4] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroWarden))
					SetLog($g_asHeroNames[4] & " is ready to fight", $COLOR_SUCCESS1)
				ElseIf IsArray(_PixelSearch($bXcoords[4] - 6, 438 + $g_iMidOffsetY, $bXcoords[4] + 10, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
					GUICtrlSetState($g_hPicChampionGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionRed, $GUI_SHOW)
					GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
					SetLog($g_asHeroNames[4] & " is being upgraded", $COLOR_DEBUG)
					;Set Status Variable
					$g_aiHiddenHeroStatus[4] = 2
					$g_iHeroUpgrading[4] = 1
					$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroChampion)
				EndIf
				CloseWindow()
				Return
		EndSwitch

	EndIf
EndFunc   ;==>HiddenSlotstatus

Func LabGuiDisplay() ; called from main loop to get an early status for indictors in bot bottom

	If ($g_bNoLabCheck = 0 Or $g_bNoLabCheck = 1) And $g_bFirstStartForLab Then Return

	If $g_bNoLabCheck = 0 And Not $g_bFirstStartForLab Then
		SetLog("Lab Won't Be Checked !", $COLOR_BLUE)
		$g_bFirstStartForLab = 1
		Return
	EndIf

	If $g_bNoLabCheck = 1 And Not $g_bFirstStartForLab Then
		SetLog("Lab Will Be Checked Just One Time !", $COLOR_BLUE)
		$g_bFirstStartForLab = 1
	EndIf

	Local Static $iLastTimeChecked[8]
	If $g_bFirstStart Then $iLastTimeChecked[$g_iCurAccount] = ""

	If ($g_bUseBOF And $IsBOFJustCollected) Or ($g_bUseBOS And $IsBOSJustCollected) Or ($g_bUseLabPotion And $IsResPotJustCollected) Then $iLastTimeChecked[$g_iCurAccount] = ""

	; Check if is a valid date and Calculated the number of minutes from remain time Lab and now
	If _DateIsValid($g_sLabUpgradeTime) And _DateIsValid($iLastTimeChecked[$g_iCurAccount]) Then
		Local $iLabTime = _DateDiff('n', _NowCalc(), $g_sLabUpgradeTime)
		Local $iLastCheck = _DateDiff('n', $iLastTimeChecked[$g_iCurAccount], _NowCalc()) ; elapse time from last check (minutes)
		SetDebugLog("Lab LabUpgradeTime: " & $g_sLabUpgradeTime & ", Lab DateCalc: " & $iLabTime)
		SetDebugLog("Lab LastCheck: " & $iLastTimeChecked[$g_iCurAccount] & ", Check DateCalc: " & $iLastCheck)
		; A check each from 2 to 5 hours [2*60 = 120 to 5*60 = 300] or when Lab research time finishes
		Local $iDelayToCheck = Random(120, 300, 1)
		Local $iLabFinishTime = _DateDiff('n', _NowCalc(), $g_sLabUpgradeTime)
		If $IsResearchPotInStock And $g_bUseLabPotion And $iLabFinishTime > 1440 Then $iDelayToCheck = 60 ; Check Again 60 min later
		If _DateIsValid($bLabAssistantUsedTime) Then
			Local $DiffLabAssistantUsedTime = _DateDiff('n', $bLabAssistantUsedTime, _NowCalc())
			If $DiffLabAssistantUsedTime > 60 Then ; One Hour after using Lab Assistant (Because I cant' find the formula !)
				$iDelayToCheck = 0 ; Check Right Now
				$bLabAssistantUsedTime = 0
			EndIf
		EndIf
		If $iLabTime > 0 And $iLastCheck <= $iDelayToCheck Then Return
	EndIf

	; not enough Resource for upgrade -
	If Number($g_aiCurrentLoot[$eLootDarkElixir]) < Number($g_iLaboratoryDElixirCost) And Not _DateIsValid($g_sLabUpgradeTime) Then
		If Number($g_iLaboratoryDElixirCost) > 0 Then
			SetLog("Minimum DE for Lab upgrade: " & _NumberFormat($g_iLaboratoryDElixirCost, True))
			If Not _DateIsValid($bLabAssistantUsedTime) Then Return
		EndIf
	EndIf
	If Number($g_aiCurrentLoot[$eLootElixir]) < Number($g_iLaboratoryElixirCost) And Not _DateIsValid($g_sLabUpgradeTime) Then
		If Number($g_iLaboratoryElixirCost) > 0 Then
			SetLog("Minimum Elixir for Lab upgrade: " & _NumberFormat($g_iLaboratoryElixirCost, True))
			If Not _DateIsValid($bLabAssistantUsedTime) Then Return
		EndIf
	EndIf

	ClearScreen()

	If $g_iTownHallLevel < 3 Then
		SetDebugLog("TH reads as Lvl " & $g_iTownHallLevel & ", has no Lab.")
		;============Hide Red  Hide Green  Show Gray==
		GUICtrlSetState($g_hPicLabGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabGray, $GUI_SHOW)
		GUICtrlSetData($g_hLbLLabTime, "")
		;============================================
		Return
	EndIf

	SetLog("Checking Lab Status", $COLOR_INFO)

	;=================Section 2 Lab Gui

	; If $g_bAutoLabUpgradeEnable = True Then  ====>>>> TODO : or use this or make a checkbox on GUI
	; make sure lab is located, if not locate lab
	If $g_aiLaboratoryPos[0] <= 0 Or $g_aiLaboratoryPos[1] <= 0 Then
		SetLog("Laboratory Location is unknown!", $COLOR_ERROR)
		;============Hide Red  Hide Green  Show Gray==
		GUICtrlSetState($g_hPicLabGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabGray, $GUI_SHOW)
		GUICtrlSetData($g_hLbLLabTime, "")
		;============================================
		Return
	EndIf

	If UBound(decodeSingleCoord(FindImageInPlace2("GobBuilder", $g_sImgGobBuilder, 240, 0, 450, 60, True))) > 1 Then
		$GobBuilderPresent = True
		$GobBuilderOffsetRunning = 355
		$GobBuilderOffsetRunningBooks = 435
	Else
		$GobBuilderPresent = False
		$GobBuilderOffsetRunning = 0
		$GobBuilderOffsetRunningBooks = 0
	EndIf

	BuildingClickP($g_aiLaboratoryPos, "#0197") ;Click Laboratory
	If _Sleep(1500) Then Return ; Wait for window to open
	; Find Research Button

	$iLastTimeChecked[$g_iCurAccount] = _NowCalc()

	Local $aResearchButton = findButton("Research", Default, 1, True)
	If IsArray($aResearchButton) And UBound($aResearchButton, 1) = 2 Then
		If $g_bDebugImageSave Then SaveDebugImage("LabUpgrade") ; Debug Only
		ClickP($aResearchButton)
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for window to open
		$IsBOFJustCollected = 0
		$IsBOSJustCollected = 0
		$IsResPotJustCollected = 0
		If Not $GobBuilderPresent Then ; Just in case
			If UBound(decodeSingleCoord(FindImageInPlace2("GobBuilder", $g_sImgGobBuilderLab, 510, 140 + $g_iMidOffsetY, 575, 195 + $g_iMidOffsetY, True))) > 1 Or _
					UBound(decodeSingleCoord(FindImageInPlace2("GobBuilder", $g_sImgGobBuilder, 420, 115 + $g_iMidOffsetY, 490, 160 + $g_iMidOffsetY, True))) > 1 Then
				$GobBuilderPresent = True
				$GobBuilderOffsetRunning = 355
				$GobBuilderOffsetRunningBooks = 435
			EndIf
		EndIf
	Else
		SetLog("Cannot find the Laboratory Research Button!", $COLOR_ERROR)
		ClearScreen()
		;===========Hide Red  Hide Green  Show Gray==
		GUICtrlSetState($g_hPicLabGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabGray, $GUI_SHOW)
		GUICtrlSetData($g_hLbLLabTime, "")
		;===========================================
		If $g_bNoLabCheck Then $g_bFirstStartForLab = 0
		Return
	EndIf

	; check for upgrade in process - look for green in finish upgrade with gems button
	If _ColorCheck(_GetPixelColor(775 - $GobBuilderOffsetRunning, 135 + $g_iMidOffsetY, True), Hex(0xA1CA6B, 6), 20) Then ; Look for light green in upper right corner of lab window.
		SetLog("Laboratory is Running", $COLOR_INFO)
		;==========Hide Red  Show Green Hide Gray===
		GUICtrlSetState($g_hPicLabGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabGreen, $GUI_SHOW)
		;===========================================
		If _Sleep($DELAYLABORATORY2) Then Return
		If $GobBuilderPresent Then
			Local $sLabTimeOCR = getRemainTLaboratoryGob(210, 190 + $g_iMidOffsetY)
		Else
			Local $sLabTimeOCR = getRemainTLaboratory2(250, 210 + $g_iMidOffsetY)
		EndIf
		Local $iLabFinishTime = ConvertOCRTime("Lab Time", $sLabTimeOCR, False) + 1
		SetDebugLog("$sLabTimeOCR: " & $sLabTimeOCR & ", $iLabFinishTime = " & $iLabFinishTime & " m")
		If $iLabFinishTime > 0 Then
			$g_sLabUpgradeTime = _DateAdd('n', Ceiling($iLabFinishTime), _NowCalc())
			SetLog("Research will finish in " & $sLabTimeOCR & " (" & $g_sLabUpgradeTime & ")")
		EndIf

		Local $bUseBooks = False
		Local $iLabFinishTimeDay = ConvertOCRTime("Lab Time (Day)", $sLabTimeOCR, False, "day")

		If Not $bUseBooks And $g_bUseBOE And $iLabFinishTimeDay >= $g_iUseBOETime Then
			SetLog("Use Book of Everything Enabled", $COLOR_INFO)
			SetLog("Lab Upgrade time > than " & $g_iUseBOETime & " day" & ($g_iUseBOETime > 1 ? "s" : ""), $COLOR_INFO)
			If QuickMIS("BFI", $g_sImgBooks & "BOE*", 720 - $GobBuilderOffsetRunningBooks, 225 + $g_iMidOffsetY, 770 - $GobBuilderOffsetRunningBooks, 275 + $g_iMidOffsetY) Then
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(1000) Then Return
				If QuickMIS("BC1", $g_sImgBooks, 400, 360 + $g_iMidOffsetY, 515, 450 + $g_iMidOffsetY) Then
					Click($g_iQuickMISX, $g_iQuickMISY)
					SetLog("Successfully use Book of Everything", $COLOR_SUCCESS)
					$bUseBooks = True
					$ActionForModLog = "Use Book of Everything"
					If $g_iTxtCurrentVillageName <> "" Then
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Laboratory : " & $ActionForModLog, 1)
					Else
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Laboratory : " & $ActionForModLog, 1)
					EndIf
					_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Laboratory : " & $ActionForModLog)
					If _Sleep(1000) Then Return
				EndIf
			Else
				SetLog("Book of Everything Not Found", $COLOR_ERROR)
			EndIf
		EndIf

		If Not $bUseBooks And $g_bUseBOS And $iLabFinishTimeDay >= $g_iUseBOSTime Then
			SetLog("Use Book of Spells Enabled", $COLOR_INFO)
			SetLog("Lab Upgrade time > than " & $g_iUseBOSTime & " day" & ($g_iUseBOETime > 1 ? "s" : ""), $COLOR_INFO)
			If QuickMIS("BFI", $g_sImgBooks & "BOS*", 720 - $GobBuilderOffsetRunningBooks, 225 + $g_iMidOffsetY, 770 - $GobBuilderOffsetRunningBooks, 275 + $g_iMidOffsetY) Then
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(1000) Then Return
				If QuickMIS("BC1", $g_sImgBooks, 400, 360 + $g_iMidOffsetY, 515, 450 + $g_iMidOffsetY) Then
					Click($g_iQuickMISX, $g_iQuickMISY)
					SetLog("Successfully use Book of Spells", $COLOR_SUCCESS)
					$bUseBooks = True
					$ActionForModLog = "Use Book of Spells"
					If $g_iTxtCurrentVillageName <> "" Then
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Laboratory : " & $ActionForModLog, 1)
					Else
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Laboratory : " & $ActionForModLog, 1)
					EndIf
					_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Laboratory : " & $ActionForModLog)
					If _Sleep(1000) Then Return
				EndIf
			Else
				SetLog("Book of Spell Not Found", $COLOR_ERROR)
			EndIf
		EndIf

		If Not $bUseBooks And $g_bUseBOF And $iLabFinishTimeDay >= $g_iUseBOFTime Then
			SetLog("Use Book of Fighting Enabled", $COLOR_INFO)
			SetLog("Lab Upgrade time > than " & $g_iUseBOFTime & " day" & ($g_iUseBOETime > 1 ? "s" : ""), $COLOR_INFO)
			If QuickMIS("BFI", $g_sImgBooks & "BOF*", 720 - $GobBuilderOffsetRunningBooks, 225 + $g_iMidOffsetY, 770 - $GobBuilderOffsetRunningBooks, 275 + $g_iMidOffsetY) Then
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(1000) Then Return
				If QuickMIS("BC1", $g_sImgBooks, 400, 360 + $g_iMidOffsetY, 515, 450 + $g_iMidOffsetY) Then
					Click($g_iQuickMISX, $g_iQuickMISY)
					SetLog("Successfully use Book of Fighting", $COLOR_SUCCESS)
					$bUseBooks = True
					$ActionForModLog = "Use Book of Fighting"
					If $g_iTxtCurrentVillageName <> "" Then
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Laboratory : " & $ActionForModLog, 1)
					Else
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Laboratory : " & $ActionForModLog, 1)
					EndIf
					_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Laboratory : " & $ActionForModLog)
					If _Sleep(1000) Then Return
				EndIf
			Else
				SetLog("Book of Fighting Not Found", $COLOR_ERROR)
			EndIf
		EndIf

		If $bUseBooks Then
			$g_sLabUpgradeTime = "" ;reset lab upgrade time
			;==========Hide Red  Show Green Hide Gray===
			GUICtrlSetState($g_hPicLabGray, $GUI_HIDE)
			GUICtrlSetState($g_hPicLabRed, $GUI_SHOW)
			GUICtrlSetState($g_hPicLabGreen, $GUI_HIDE)
			;===========================================
		EndIf

		If _Sleep(500) Then Return
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asLabUpgradeTime[$g_iCurAccount] = $g_sLabUpgradeTime for instantly displaying in multi-stats
		CloseWindow(False, False, True)
		Return True
	ElseIf _ColorCheck(_GetPixelColor(775 - $GobBuilderOffsetRunning, 170 + $g_iMidOffsetY, True), Hex(0x8089AF, 6), 20) Then ; Look for light purple in upper right corner of lab window.
		SetLog("Laboratory has Stopped", $COLOR_INFO)
		If $g_bNotifyTGEnable And $g_bNotifyAlertLaboratoryIdle Then NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Laboratory-Idle_Info_01", "Laboratory Idle") & "%0A" & GetTranslatedFileIni("MBR Func_Notify", "Laboratory-Idle_Info_02", "Laboratory has Stopped"))
		CloseWindow()
		;========Show Red  Hide Green  Hide Gray=====
		GUICtrlSetState($g_hPicLabGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabRed, $GUI_SHOW)
		GUICtrlSetData($g_hLbLLabTime, "")
		;============================================
		ClearScreen()
		$g_sLabUpgradeTime = ""
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asLabUpgradeTime[$g_iCurAccount] = $g_sLabUpgradeTime for instantly displaying in multi-stats
		Return
	Else
		SetLog("Unable to determine Lab Status", $COLOR_INFO)
		;========Hide Red  Hide Green  Show Gray======
		GUICtrlSetState($g_hPicLabGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabGray, $GUI_SHOW)
		GUICtrlSetData($g_hLbLLabTime, "")
		;=============================================
		CloseWindow()
		$iLastTimeChecked[$g_iCurAccount] = ""
		If $g_bNoLabCheck Then $g_bFirstStartForLab = 0
		Return
	EndIf

EndFunc   ;==>LabGuiDisplay

Func HideShields($bHide = False)
	Local Static $ShieldState[30]
	Local $counter
	If $bHide = True Then
		$counter = 0
		For $i = $g_hPicKingGray To $g_hLbLLabTime
			$ShieldState[$counter] = GUICtrlGetState($i)
			GUICtrlSetState($i, $GUI_HIDE)
			$counter += 1
		Next
	Else
		$counter = 0
		For $i = $g_hPicKingGray To $g_hLbLLabTime
			If $ShieldState[$counter] = 80 Then
				GUICtrlSetState($i, $GUI_SHOW)
			EndIf
			$counter += 1
		Next
	EndIf
EndFunc   ;==>HideShields
