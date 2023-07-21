; #FUNCTION# ====================================================================================================================
; Name ..........: GetAttackBarBB
; Description ...: Gets the troops and there quantities for the current attack
; Syntax ........:
; Parameters ....: None
; Return values .: array attackBar
; Author ........: xbebenk
; Modified ......: Moebius14
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2023
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

#comments-start
	$aAttackBar[n][8]
	[n][0] = Name of the found Troop/Spell/Hero/Siege
	[n][1] = The X Coordinate of the Troop
	[n][2] = The Y Coordinate of the Troop/Spell/Hero/Siege
	[n][3] = The Slot Number (Starts with 0)
	[n][4] = The Amount
#comments-end

Func GetAttackBarBB($bRemaining = False, $bSecondAttack = False)
	Local $iTroopBanners = 590 + $g_iBottomOffsetY ; y location of where to find troop quantities
	Local $iSelectTroopY = 620 + $g_iBottomOffsetY; y location to select troop on attackbar
	Local $aBBAttackBar[0][5]
	Local $aEmpty[0][2]
	Local $BMFound = 0
	If Not $bRemaining Then 
		$g_bBomberOnAttackBar = False
		$g_aBomberOnAttackBar = $aEmpty
	EndIf

	Local $iMaxSlot = 9, $iSlotOffset = 71
	Local $aSlotX[$iMaxSlot], $iStartSlot = 118
	
	Local $aBMPosInit = GetMachinePos()
	If $aBMPosInit = 0 Then
		If $g_DeployedMachine Then
			SetDebugLog("Machine Already Deployed", $COLOR_DEBUG)
			$BMFound += 1
		Else
			$iStartSlot = 35
		EndIf
		For $i = 0 To UBound($aSlotX) - 1
			$aSlotX[$i] = $iStartSlot + ($i * $iSlotOffset)
		Next
	Else
		If Not StringInStr($aBMPosInit[2], "Dead") And Not $g_DeployedMachine Then
			Local $aTempElement[1][5] = [["BattleMachine", 35, 620 + $g_iBottomOffsetY, 0, 1]] ; element to add to attack bar list
			_ArrayAdd($aBBAttackBar, $aTempElement)
			SetDebugLog("Found Machine Ready to be deployed", $COLOR_DEBUG)
		Else
			SetDebugLog("Found Machine Dead Or Deployed", $COLOR_DEBUG)
		EndIf
		$BMFound += 1
		For $i = 0 To UBound($aSlotX) - 1
			$aSlotX[$i] = $iStartSlot + ($i * $iSlotOffset)
		Next
	EndIf

	If Not $g_bRunState Then Return ; Stop Button

	Local $iCount = 1, $isBlueBanner = False, $isVioletBanner = False, $isVioletBannerSelected = False, $isGreyBanner = False, $isVioletBannerDeployed = False
	Local $aBBAttackBarResult, $Troop = "", $Troopx = 0, $Troopy = 0, $ColorPickBannerX = 0
	Local $bReadTroop = False

	For $k = 0 To UBound($aSlotX) - 1
		If Not $g_bRunState Then Return

		$Troopx = $aSlotX[$k]
		$ColorPickBannerX = $aSlotX[$k] + 35 ; location to pick color from TroopSlot banner

		If $bRemaining Then 
			If QuickMIS("BC1", $g_sImgDirBBTroops, $Troopx, $iTroopBanners, $Troopx + 73, 670 + $g_iBottomOffsetY) Then 
				If $g_bDebugSetLog Then SetLog("Slot [" & $k + $BMFound & "]: TroopBanner ColorpickX=" & $ColorPickBannerX, $COLOR_DEBUG2)
				$isGreyBanner = _ColorCheck(_GetPixelColor($ColorPickBannerX, $iTroopBanners, True), Hex(0x808080, 6), 10, Default) ;Grey Banner on TroopSlot = Troop Die
				If $isGreyBanner Then
					If Number(getOcrAndCapture("coc-tbb", $ColorPickBannerX, $iTroopBanners - 12, 35, 28, True)) > 0 Then $isGreyBanner = False ;Just in case but should not happens
				EndIf
				$isVioletBannerDeployed = _ColorCheck(_GetPixelColor($ColorPickBannerX, $iTroopBanners - 15, True), Hex(0xCF5CFF, 6), 30, Default) ;Violet Banner on Big TroopSlot = Troop Deployed
				If $g_bDebugSetLog Then SetLog("Slot [" & $k + $BMFound & "]: isGreyBanner=" & String($isGreyBanner) & " isVioletBannerDeployed=" & String($isVioletBannerDeployed), $COLOR_DEBUG2)
				If $isGreyBanner Or $isVioletBannerDeployed Then ContinueLoop

				$isVioletBanner = _ColorCheck(_GetPixelColor($ColorPickBannerX, $iTroopBanners, True), Hex(0xCF5CFF, 6), 30, Default) ; Violet Banner on TroopSlot = TroopSlot Quantity = 1
				$isVioletBannerSelected = _ColorCheck(_GetPixelColor($ColorPickBannerX, $iTroopBanners, True), Hex(0xDC91FF, 6), 30, Default) ; Violet Banner on TroopSlot = TroopSlot Quantity = 1, Selected But Not Dropped
				$isBlueBanner = _ColorCheck(_GetPixelColor($ColorPickBannerX, $iTroopBanners, True), Hex(0x407CFF, 6), 30, Default) ; Blue Banner on TroopSlot = TroopSlot Quantity > 1
				If $g_bDebugSetLog Then SetLog("Slot [" & $k + $BMFound & "]: isBlueBanner=" & String($isBlueBanner) & " isVioletBanner=" & String($isVioletBanner) & " isVioletBannerSelected=" & String($isVioletBannerSelected), $COLOR_DEBUG2)

				If $isBlueBanner Or $isVioletBanner Or $isVioletBannerSelected Then
					$Troop =  $g_iQuickMISName
					$Troopy = $iSelectTroopY
					If $isBlueBanner Then
						$iCount = Number(getOcrAndCapture("coc-tbb", $ColorPickBannerX, $iTroopBanners - 12, 35, 28, True))
						If $iCount = "" Then $iCount = Number(getOcrAndCapture("coc-tbb", $ColorPickBannerX, $iTroopBanners - 17, 35, 28, True)) ;Maybe this Troop is Selected ? => $y-5
					EndIf
					If $isVioletBanner Or $isVioletBannerSelected Then $iCount = 1

					Local $aTempElement[1][5] = [[$Troop, $Troopx, $Troopy, $k + $BMFound, $iCount]] ; element to add to attack bar list
					_ArrayAdd($aBBAttackBar, $aTempElement)
				EndIf
			EndIf
		Else
			If QuickMIS("BC1", $g_sImgDirBBTroops, $Troopx, $iTroopBanners, $Troopx + 73, 670 + $g_iBottomOffsetY) Then 
				If $g_bDebugSetLog Then SetLog("Slot [" & $k + $BMFound & "]: TroopBanner ColorpickX=" & $ColorPickBannerX, $COLOR_DEBUG2)
				$isVioletBanner = _ColorCheck(_GetPixelColor($ColorPickBannerX, $iTroopBanners, True), Hex(0xCF5CFF, 6), 30, Default) ; Violet Banner on TroopSlot = TroopSlot Quantity = 1 
				$isBlueBanner = _ColorCheck(_GetPixelColor($ColorPickBannerX, $iTroopBanners, True), Hex(0x407CFF, 6), 30, Default) ; Blue Banner on TroopSlot = TroopSlot Quantity > 1 
				If Not $isVioletBanner And $bSecondAttack Then $isVioletBanner = _ColorCheck(_GetPixelColor($ColorPickBannerX, $iTroopBanners, True), Hex(0x13244B, 6), 30, Default) ; Violet Banner on TroopSlot = TroopSlot Quantity = 1 
				If $g_bDebugSetLog Then SetLog("Slot [" & $k + $BMFound & "]: isBlueBanner=" & String($isBlueBanner) & " isVioletBanner=" & String($isVioletBanner), $COLOR_DEBUG2)

				$bReadTroop = $isBlueBanner Or $isVioletBanner
				If $bReadTroop Then
					$Troop =  $g_iQuickMISName
					$Troopy = $iSelectTroopY
					If $isBlueBanner Then $iCount = Number(getOcrAndCapture("coc-tbb", $ColorPickBannerX, $iTroopBanners - 12, 35, 28, True))
					If $isVioletBanner Then $iCount = 1

					Local $aTempElement[1][5] = [[$Troop, $Troopx, $Troopy, $k + $BMFound, $iCount]] ; element to add to attack bar list
					_ArrayAdd($aBBAttackBar, $aTempElement)
				EndIf
			EndIf
		EndIf
	Next

	If UBound($aBBAttackBar) = 0 Then Return ""

	_ArraySort($aBBAttackBar, 0, 0, 0, 3)
	For $i = 0 To UBound($aBBAttackBar) - 1
		If $aBBAttackBar[$i][0] = "BattleMachine" Then
			Local $aBMPos = GetMachinePos()
			If IsArray($aBMPos) And $aBMPos <> 0 Then
				If StringInStr($aBMPos[2], "Copter") Then
					SetLog("Slot[" & $aBBAttackBar[$i][3] & "] Battle Copter, (" & $aBBAttackBar[$i][1] & "," & $aBBAttackBar[$i][2] & ")", $COLOR_SUCCESS)
				Else
					SetLog("Slot[" & $aBBAttackBar[$i][3] & "] Battle Machine, (" & $aBBAttackBar[$i][1] & "," & $aBBAttackBar[$i][2] & ")", $COLOR_SUCCESS)
				EndIf
			Else
				SetLog("Slot[" & $aBBAttackBar[$i][3] & "] " & $aBBAttackBar[$i][0] & ", (" & $aBBAttackBar[$i][1] & "," & $aBBAttackBar[$i][2] & "), Count: " & $aBBAttackBar[$i][4], $COLOR_SUCCESS)
			EndIf
		Else
			SetLog("Slot[" & $aBBAttackBar[$i][3] & "] " & $aBBAttackBar[$i][0] & ", (" & $aBBAttackBar[$i][1] & "," & $aBBAttackBar[$i][2] & "), Count: " & $aBBAttackBar[$i][4], $COLOR_SUCCESS)
		EndIf
		If Not $bRemaining And $aBBAttackBar[$i][0] = "Bomber" Then
			$g_bBomberOnAttackBar = True
			_ArrayAdd($g_aBomberOnAttackBar, $aBBAttackBar[$i][1] & "|" & $aBBAttackBar[$i][2])
		EndIf
	Next
	Return $aBBAttackBar
EndFunc