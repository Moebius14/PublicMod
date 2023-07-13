; #FUNCTION# ====================================================================================================================
; Name ..........: Laboratory
; Description ...:
; Syntax ........: Laboratory()
; Parameters ....:
; Return values .: None
; Author ........: summoner
; Modified ......: KnowJack (06/2015), Sardo (08/2015), Monkeyhunter(04/2016), MMHK(06/2018), Chilly-Chill (12/2019)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2023
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Local $iSlotWidth = 94, $iDistBetweenSlots = 12 ; use for logic to upgrade troops.. good for generic-ness
Local $iYMidPoint = 468 ;Space between rows in lab screen.  CHANGE ONLY WITH EXTREME CAUTION.
Local $iPicsPerPage = 12, $iPages = 4 ; used to know exactly which page the users choice is on
Local $sLabWindow = "99,122,760,616", $sLabTroopsSection = "115,363,750,577", $sLabTroopLastPage = "215,363,750,577"
;$sLabTroopLastPage for partial last page, currently 5 columns.
Local $sLabWindowDiam = GetDiamondFromRect($sLabWindow), $sLabTroopsSectionDiam = GetDiamondFromRect($sLabTroopsSection), $sLabTroopsLastPageDiam = GetDiamondFromRect($sLabTroopLastPage) ; easy to change search areas

Func TestLaboratory()
	Local $bWasRunState = $g_bRunState
	Local $sWasLabUpgradeTime = $g_sLabUpgradeTime
	Local $sWasLabUpgradeEnable = $g_bAutoLabUpgradeEnable
	$g_bRunState = True
	$g_bAutoLabUpgradeEnable = True
	$g_sLabUpgradeTime = ""
	$g_bSilentSetDebugLog = False
	Local $Result = Laboratory(True)
	$g_bRunState = $bWasRunState
	$g_sLabUpgradeTime = $sWasLabUpgradeTime
	$g_bAutoLabUpgradeEnable = $sWasLabUpgradeEnable
	Return $Result
EndFunc

Func Laboratory($debug=False)

	If Not $g_bAutoLabUpgradeEnable Then Return ; Lab upgrade not enabled.
	
	$IsLabtoRecheck = False

	If $g_iTownHallLevel < 3 Then
		SetLog("Townhall Lvl " & $g_iTownHallLevel & " has no Lab.", $COLOR_ERROR)
		Return
	EndIf

	If $g_aiLaboratoryPos[0] = 0 Or $g_aiLaboratoryPos[1] = 0 Then
		SetLog("Laboratory Location unknown!", $COLOR_WARNING)
		LocateLab() ; Lab location unknown, so find it.
		If $g_aiLaboratoryPos[0] = 0 Or $g_aiLaboratoryPos[1] = 0 Then
			SetLog("Problem locating Laboratory, re-locate laboratory position before proceeding", $COLOR_ERROR)
			Return False
		EndIf
	EndIf

 	If ChkUpgradeInProgress() Then Return False ; see if we know about an upgrade in progress without checking the lab

	; Get updated village elixir and dark elixir values
	VillageReport()

	;Click Laboratory
	BuildingClickP($g_aiLaboratoryPos, "#0197")
	If _Sleep($DELAYLABORATORY3) Then Return ; Wait for window to open

	If Not FindResearchButton() Then Return False ; cant start because we cannot find the research button

	If ChkLabUpgradeInProgress() Then
		CloseWindow(False, True)
		Return False ; cant start if something upgrading
	EndIf

	; Lab upgrade is not in progress and not upgreading, so we need to start an upgrade.
	Local $iCurPage = 1
	Local $sCostResult

	; user made a specific choice of lab upgrade
	If $g_iCmbLaboratory > 0 Then
		SetDebugLog("User picked to upgrade " & $g_avLabTroops[$g_iCmbLaboratory][0])
		Local $iPage = Ceiling($g_iCmbLaboratory / $iPicsPerPage) ; page # of user choice
		If $g_iCmbLaboratory = 47 Then $iPage = 2
		If $g_iCmbLaboratory = 48 Then $iPage = 4
		While($iCurPage < $iPage) ; go directly to the needed page
			LabNextPage($iCurPage, $iPages, $iYMidPoint) ; go to next page of upgrades
			$iCurPage += 1 ; Next page
			If _Sleep(2000) Then Return
		WEnd
		SetDebugLog("On page " & $iCurPage & " of " & $iPages)
		; Get coords of upgrade the user wants
		If $iCurPage >= $iPages Then ;Use last partial page
		SetDebugLog("Finding on last page diamond")
			If $g_iCmbLaboratory = 48 Then
				Local $aPageUpgrades = findMultiple($g_sImgAnySiege, $sLabTroopsLastPageDiam, $sLabTroopsLastPageDiam, 0, 1000, 0, "objectname,objectpoints", True) ; Returns $aCurrentTroops[index] = $aArray[2] = ["TroopShortName", CordX,CordY]
			Else
				Local $aPageUpgrades = findMultiple($g_sImgLabResearch, $sLabTroopsLastPageDiam, $sLabTroopsLastPageDiam, 0, 1000, 0, "objectname,objectpoints", True)
			EndIf
		Else ;Use full page
			If $g_iCmbLaboratory = 47 Then
				Local $aPageUpgrades = findMultiple($g_sImgAnySpell, $sLabTroopsSectionDiam, $sLabTroopsSectionDiam, 0, 1000, 0, "objectname,objectpoints", True)
			Else
				local $aPageUpgrades = findMultiple($g_sImgLabResearch, $sLabTroopsSectionDiam, $sLabTroopsSectionDiam, 0, 1000, 0, "objectname,objectpoints", True) ; Returns $aCurrentTroops[index] = $aArray[2] = ["TroopShortName", CordX,CordY]
			EndIf
		EndIf
		Local $aCoords, $bUpgradeFound = False
		Local $AllSpellUnabled = 0
		Local $AllSiegeUnabled = 0
		If UBound($aPageUpgrades, 1) >= 1 Then ; if we found any troops

			If $g_iCmbLaboratory < 47 Then

				For $i = 0 To UBound($aPageUpgrades, 1) - 1 ; Loop through found upgrades
					Local $aTempTroopArray = $aPageUpgrades[$i] ; Declare Array to Temp Array

					If $aTempTroopArray[0] = $g_avLabTroops[$g_iCmbLaboratory][2] Then ; if this is the file we want
						$aCoords = decodeSingleCoord($aTempTroopArray[1])
						$bUpgradeFound = True
						ExitLoop
					EndIf
					If _Sleep($DELAYLABORATORY2) Then Return
				Next

			ElseIf $g_iCmbLaboratory = 47 Then

				For $i = 0 To UBound($aPageUpgrades, 1) - 1 ; Loop through found upgrades
					Local $aTempTroopArray = $aPageUpgrades[$i] ; Declare Array to Temp Array

					For $z = 17 To 24
						If $aTempTroopArray[0] = $g_avLabTroops[$z][2] Then ; if this is the file we want
							$aCoords = decodeSingleCoord($aTempTroopArray[1])
							$sCostResult = GetLabCostResult($aCoords)
							If $sCostResult = "" Then ; not enough resources or Lab Upgrade Required
								SetLog("Lab Upgrade " & $g_avLabTroops[$z][0] & " - Not enough Resources." & @CRLF & "Check Next Spell.", $COLOR_INFO)
								ContinueLoop
							EndIf
							$bUpgradeFound = True
							ExitLoop 2
						EndIf
						If _Sleep($DELAYLABORATORY2) Then Return
					Next
				Next

			ElseIf $g_iCmbLaboratory = 48 Then

				For $i = 0 To UBound($aPageUpgrades, 1) - 1 ; Loop through found upgrades
					Local $aTempTroopArray = $aPageUpgrades[$i] ; Declare Array to Temp Array

					For $z = 40 To 46
						If $aTempTroopArray[0] = $g_avLabTroops[$z][2] Then ; if this is the file we want
							$aCoords = decodeSingleCoord($aTempTroopArray[1])
							$sCostResult = GetLabCostResult($aCoords) ; get cost of the upgrade
							If $sCostResult = "" Then ; not enough resources or Lab Upgrade Required
								SetLog("Lab Upgrade " & $g_avLabTroops[$z][0] & " - Not enough Resources." & @CRLF & "Check Next Siege Machine.", $COLOR_INFO)
								ContinueLoop
							EndIf
							$bUpgradeFound = True
							ExitLoop 2
						EndIf
						If _Sleep($DELAYLABORATORY2) Then Return
					Next
				Next

			EndIf

		Else

			If $g_iCmbLaboratory = 47 Then
				For $t = 17 To 24
					Local $iRaw = Mod($t, 2)
					Local $iColumn = 0
					Local $XStart, $XEnd, $YStart, $YEnd
					Local $isLabUpRequired = False
					Local $isTroopMaxed = False

					$iColumn = Ceiling($t/2) - (($iCurPage-1)*6)
									
					$XStart = 120 + (($iColumn - 1) * ($iSlotWidth + $iDistBetweenSlots))
					$XEnd = $XStart + $iSlotWidth
					If $iRaw = 0 Then
						$YStart = 515 + $g_iMidOffsetY
						$YEnd = 532 + $g_iMidOffsetY
					Else
						$YStart = 409 + $g_iMidOffsetY
						$YEnd = 426 + $g_iMidOffsetY
					EndIf

					If $g_bDebugImageSaveMod Then
						SaveDebugRectImageCrop("Labo", $XStart & "," & $YStart & "," & $XEnd & "," & $YEnd)
						SetLog("Coords : " & $XStart & "," & $YStart & "," & $XEnd & "," & $YEnd, $COLOR_ACTION)
					EndIf

					If QuickMIS("BC1", $g_sImgLabUpRequiredOrLvlMax, $XStart, $YStart, $XEnd, $YEnd) Then
						If $g_iQuickMISName = "Required" Then
							$isLabUpRequired = True
						ElseIf $g_iQuickMISName = "MaxLevel" Then
							$isTroopMaxed = True
						EndIf
					EndIf

					If $isLabUpRequired Or $isTroopMaxed Then
						$AllSpellUnabled += 1
						If $isLabUpRequired Then SetLog("Lab Upgrade " & $g_avLabTroops[$t][0] & " - Lab Upgrade is Required.", $COLOR_INFO)
						If $isTroopMaxed Then SetLog("Lab Upgrade " & $g_avLabTroops[$t][0] & " - Already Max Level.", $COLOR_INFO)
					EndIf
				Next
			EndIf

		EndIf

		If Not $bUpgradeFound Then

			Local $CloseLab = True

			If $g_iCmbLaboratory < 47 Then

				SetLog("Lab Upgrade " & $g_avLabTroops[$g_iCmbLaboratory][0] & " - Not available.", $COLOR_INFO)

				Local $iRaw = Mod($g_iCmbLaboratory, 2)
				Local $iColumn = 0
				Local $XStart, $XEnd, $YStart, $YEnd
				Local $isLabUpRequired = False
				Local $isTroopMaxed = False

				If $iCurPage > 0 And $iCurPage < 4 Then
					$iColumn = Ceiling($g_iCmbLaboratory/2) - (($iCurPage-1)*6)
				ElseIf $iCurPage = 4 Then
					$iColumn = Ceiling($g_iCmbLaboratory/2) - (($iCurPage-1)*6) + 1
				EndIf

				$XStart = 120 + (($iColumn - 1) * ($iSlotWidth + $iDistBetweenSlots))
				$XEnd = $XStart + $iSlotWidth
				If $iRaw = 0 Then
					$YStart = 515 + $g_iMidOffsetY
					$YEnd = 532 + $g_iMidOffsetY
				Else
					$YStart = 409 + $g_iMidOffsetY
					$YEnd = 426 + $g_iMidOffsetY
				EndIf
			
				If $g_bDebugImageSaveMod Then
					SaveDebugRectImageCrop("Labo", $XStart & "," & $YStart & "," & $XEnd & "," & $YEnd)
					SetLog("Coords : " & $XStart & "," & $YStart & "," & $XEnd & "," & $YEnd, $COLOR_ACTION)
				EndIf
			
				If QuickMIS("BC1", $g_sImgLabUpRequiredOrLvlMax, $XStart, $YStart, $XEnd, $YEnd) Then
					If $g_iQuickMISName = "Required" Then
						$isLabUpRequired = True
					ElseIf $g_iQuickMISName = "MaxLevel" Then
						$isTroopMaxed = True
					EndIf
				EndIf

				Local $NewSelection = 0
				If $g_aCmbLabUpgradeOrder[0] = -1 Then 
					$NewSelection = $g_avLabTroops[0][0]
				Else
					$NewSelection = $g_avLabTroops[$g_aCmbLabUpgradeOrder[0]][0]
				EndIf

				If $g_iCmbLaboratory < 17 Or ($g_iCmbLaboratory > 29 And $g_iCmbLaboratory < 40) Then
					If $isLabUpRequired Then SetLog("Laboratory Upgrade is Required To Upgrade This Troop", $COLOR_ACTION)
					If $isTroopMaxed Then SetLog("This Troop Is Already Maxed", $COLOR_ACTION)
					If $isLabUpRequired Or $isTroopMaxed Then SetLog("Selected Troop Upgrade Changed To " & $NewSelection, $COLOR_NAVY)
				ElseIf $g_iCmbLaboratory > 16 And $g_iCmbLaboratory < 30 Then
					If $isLabUpRequired Then SetLog("Laboratory Upgrade is Required To Upgrade This Spell", $COLOR_ACTION)
					If $isTroopMaxed Then SetLog("This Spell Is Already Maxed", $COLOR_ACTION)
					If $isLabUpRequired Or $isTroopMaxed Then SetLog("Selected Spell Upgrade Changed To " & $NewSelection, $COLOR_NAVY)
				ElseIf $g_iCmbLaboratory > 39 Then
					If $isLabUpRequired Then SetLog("Laboratory Upgrade is Required To Upgrade This Siege Machine", $COLOR_ACTION)
					If $isTroopMaxed Then SetLog("This Siege Machine Is Already Maxed", $COLOR_ACTION)
					If $isLabUpRequired Or $isTroopMaxed Then SetLog("Selected Siege Machine Upgrade Changed To " & $NewSelection, $COLOR_NAVY)
				EndIf

				If $isLabUpRequired Or $isTroopMaxed Then
					$IsLabtoRecheck = True
					$g_iCmbLaboratory = $g_aCmbLabUpgradeOrder[0]
					If $g_iCmbLaboratory = -1 Then $g_iCmbLaboratory = 0
					_GUICtrlComboBox_SetCurSel($g_hCmbLaboratory, $g_iCmbLaboratory)
					If $g_iCmbLaboratory > 46 Then
						_GUICtrlSetImage($g_hPicLabUpgrade, $g_sLibModIconPath, $g_avLabTroops[$g_iCmbLaboratory][1])
					Else
						_GUICtrlSetImage($g_hPicLabUpgrade, $g_sLibIconPath, $g_avLabTroops[$g_iCmbLaboratory][1])
					EndIf

					For $i = 0 To UBound($g_aCmbLabUpgradeOrder) - 1

						If $i = UBound($g_aCmbLabUpgradeOrder) - 1 Then
							$g_aCmbLabUpgradeOrder[$i] = -1
						Else
							$g_aCmbLabUpgradeOrder[$i] = $g_aCmbLabUpgradeOrder[$i+1]
						EndIf

						If $g_aCmbLabUpgradeOrder[$i] = -1 Then
							_GUICtrlComboBox_SetCurSel($g_ahCmbLabUpgradeOrder[$i], $g_avLabTroops[0][0])
						Else
							_GUICtrlComboBox_SetCurSel($g_ahCmbLabUpgradeOrder[$i], $g_aCmbLabUpgradeOrder[$i])
						EndIf

					Next

					chkLab()
				EndIf

			ElseIf $g_iCmbLaboratory = 47 Then

				$iPage = 3
				While($iCurPage < $iPage) ; go directly to the needed page
					LabNextPage($iCurPage, $iPages, $iYMidPoint) ; go to next page of upgrades
					$iCurPage += 1 ; Next page
					If _Sleep(2000) Then Return
				WEnd
				$aPageUpgrades = findMultiple($g_sImgAnySpell, $sLabTroopsSectionDiam, $sLabTroopsSectionDiam, 0, 1000, 0, "objectname,objectpoints", True)

				For $t = 25 To 29

					Local $aCoords = False
					If UBound($aPageUpgrades, 1) >= 1 Then ; if we found any troops
						For $i = 0 To UBound($aPageUpgrades, 1) - 1 ; Loop through found upgrades
							Local $aTempTroopArray = $aPageUpgrades[$i] ; Declare Array to Temp Array
							If $aTempTroopArray[0] = $g_avLabTroops[$t][2] Then ; if this is the file we want
								$aCoords = decodeSingleCoord($aTempTroopArray[1])
								$sCostResult = GetLabCostResult($aCoords) ; get cost of the upgrade
								If $sCostResult = "" Then ; not enough resources or Lab Upgrade Required
									SetLog("Lab Upgrade " & $g_avLabTroops[$t][0] & " - Not enough Resources." & @CRLF & "Check Next Spell.", $COLOR_INFO)
									ContinueLoop
								EndIf	
								$CloseLab = False
								ExitLoop 2
							EndIf
							If _Sleep($DELAYLABORATORY2) Then Return
						Next
					EndIf

					Local $iRaw = Mod($t, 2)
					Local $iColumn = 0
					Local $XStart, $XEnd, $YStart, $YEnd
					Local $isLabUpRequired = False
					Local $isTroopMaxed = False

					$iColumn = Ceiling($t/2) - (($iCurPage-1)*6)

					$XStart = 120 + (($iColumn - 1) * ($iSlotWidth + $iDistBetweenSlots))
					$XEnd = $XStart + $iSlotWidth
					If $iRaw = 0 Then
						$YStart = 515 + $g_iMidOffsetY
						$YEnd = 532 + $g_iMidOffsetY
					Else
						$YStart = 409 + $g_iMidOffsetY
						$YEnd = 426 + $g_iMidOffsetY
					EndIf

					If $g_bDebugImageSaveMod Then
						SaveDebugRectImageCrop("Labo", $XStart & "," & $YStart & "," & $XEnd & "," & $YEnd)
						SetLog("Coords : " & $XStart & "," & $YStart & "," & $XEnd & "," & $YEnd, $COLOR_ACTION)
					EndIf

					If QuickMIS("BC1", $g_sImgLabUpRequiredOrLvlMax, $XStart, $YStart, $XEnd, $YEnd) Then
						If $g_iQuickMISName = "Required" Then
							$isLabUpRequired = True
						ElseIf $g_iQuickMISName = "MaxLevel" Then
							$isTroopMaxed = True
						EndIf
					EndIf

					If $isLabUpRequired Or $isTroopMaxed Then
						$AllSpellUnabled += 1
						If $isLabUpRequired Then SetLog("Lab Upgrade " & $g_avLabTroops[$t][0] & " - Lab Upgrade is Required.", $COLOR_INFO)
						If $isTroopMaxed Then SetLog("Lab Upgrade " & $g_avLabTroops[$t][0] & " - Already Max Level.", $COLOR_INFO)
					EndIf

					If $AllSpellUnabled = UBound($g_asSpellNames) Then
						SetLog("No Spell Upgrade Is Possible, Check Next Priority", $COLOR_SUCCESS1)
						$g_iCmbLaboratory = $g_aCmbLabUpgradeOrder[0]
						If $g_iCmbLaboratory = -1 Then $g_iCmbLaboratory = 0
						_GUICtrlComboBox_SetCurSel($g_hCmbLaboratory, $g_iCmbLaboratory)
						If $g_iCmbLaboratory > 46 Then
							_GUICtrlSetImage($g_hPicLabUpgrade, $g_sLibModIconPath, $g_avLabTroops[$g_iCmbLaboratory][1])
						Else
							_GUICtrlSetImage($g_hPicLabUpgrade, $g_sLibIconPath, $g_avLabTroops[$g_iCmbLaboratory][1])
						EndIf
						For $i = 0 To UBound($g_aCmbLabUpgradeOrder) - 1
							If $i = UBound($g_aCmbLabUpgradeOrder) - 1 Then
								$g_aCmbLabUpgradeOrder[$i] = -1
							Else
								$g_aCmbLabUpgradeOrder[$i] = $g_aCmbLabUpgradeOrder[$i+1]
							EndIf
							If $g_aCmbLabUpgradeOrder[$i] = -1 Then
								_GUICtrlComboBox_SetCurSel($g_ahCmbLabUpgradeOrder[$i], $g_avLabTroops[0][0])
							Else
								_GUICtrlComboBox_SetCurSel($g_ahCmbLabUpgradeOrder[$i], $g_aCmbLabUpgradeOrder[$i])
							EndIf
						Next
						$IsLabtoRecheck = True
						chkLab()
					EndIf

				Next

			ElseIf $g_iCmbLaboratory = 48 Then

				For $t = 40 To 46

					Local $iRaw = Mod($t, 2)
					Local $iColumn = 0
					Local $XStart, $XEnd, $YStart, $YEnd
					Local $isLabUpRequired = False
					Local $isTroopMaxed = False

					$iColumn = Ceiling($t/2) - 17

					$XStart = 120 + (($iColumn - 1) * ($iSlotWidth + $iDistBetweenSlots))
					$XEnd = $XStart + $iSlotWidth
					If $iRaw = 0 Then
						$YStart = 515 + $g_iMidOffsetY
						$YEnd = 532 + $g_iMidOffsetY
					Else
						$YStart = 409 + $g_iMidOffsetY
						$YEnd = 426 + $g_iMidOffsetY
					EndIf

					If $g_bDebugImageSaveMod Then
						SaveDebugRectImageCrop("Labo", $XStart & "," & $YStart & "," & $XEnd & "," & $YEnd)
						SetLog("Coords : " & $XStart & "," & $YStart & "," & $XEnd & "," & $YEnd, $COLOR_ACTION)
					EndIf

					If QuickMIS("BC1", $g_sImgLabUpRequiredOrLvlMax, $XStart, $YStart, $XEnd, $YEnd) Then
						If $g_iQuickMISName = "Required" Then
							$isLabUpRequired = True
						ElseIf $g_iQuickMISName = "MaxLevel" Then
							$isTroopMaxed = True
						EndIf
					EndIf

					If ($isLabUpRequired Or $isTroopMaxed) Then
						$AllSiegeUnabled += 1
						If $isLabUpRequired Then SetLog("Lab Upgrade " & $g_avLabTroops[$t][0] & " - Lab Upgrade is Required.", $COLOR_INFO)
						If $isTroopMaxed Then SetLog("Lab Upgrade " & $g_avLabTroops[$t][0] & " - Already Max Level.", $COLOR_INFO)
					EndIf

					If $AllSiegeUnabled = UBound($g_asSiegeMachineNames) Then
						SetLog("No Siege Machine Upgrade Is Possible, Check Next Priority", $COLOR_SUCCESS1)
						$g_iCmbLaboratory = $g_aCmbLabUpgradeOrder[0]
						If $g_iCmbLaboratory = -1 Then $g_iCmbLaboratory = 0
						_GUICtrlComboBox_SetCurSel($g_hCmbLaboratory, $g_iCmbLaboratory)
						If $g_iCmbLaboratory > 46 Then
							_GUICtrlSetImage($g_hPicLabUpgrade, $g_sLibModIconPath, $g_avLabTroops[$g_iCmbLaboratory][1])
						Else
							_GUICtrlSetImage($g_hPicLabUpgrade, $g_sLibIconPath, $g_avLabTroops[$g_iCmbLaboratory][1])
						EndIf
						For $i = 0 To UBound($g_aCmbLabUpgradeOrder) - 1
							If $i = UBound($g_aCmbLabUpgradeOrder) - 1 Then
								$g_aCmbLabUpgradeOrder[$i] = -1
							Else
								$g_aCmbLabUpgradeOrder[$i] = $g_aCmbLabUpgradeOrder[$i+1]
							EndIf
							If $g_aCmbLabUpgradeOrder[$i] = -1 Then
								_GUICtrlComboBox_SetCurSel($g_ahCmbLabUpgradeOrder[$i], $g_avLabTroops[0][0])
							Else
								_GUICtrlComboBox_SetCurSel($g_ahCmbLabUpgradeOrder[$i], $g_aCmbLabUpgradeOrder[$i])
							EndIf
						Next
						$IsLabtoRecheck = True
						chkLab()
					EndIf

				Next
			
			EndIf

			If $CloseLab Then CloseWindow()
			Return False
		EndIf

		If $g_iCmbLaboratory < 47 Then $sCostResult = GetLabCostResult($aCoords) ; get cost of the upgrade
		
		If $sCostResult = "" And $g_iCmbLaboratory < 47 Then ; not enough resources or Lab Upgrade Required
			SetLog("Lab Upgrade " & $g_avLabTroops[$g_iCmbLaboratory][0] & " - Not enough Resources." & @CRLF & "We will try again later.", $COLOR_INFO)
			SetDebugLog("Coords: (" & $aCoords[0] & "," & $aCoords[1] & ")")
		Else
			Return LaboratoryUpgrade($g_avLabTroops[$g_iCmbLaboratory][0], $aCoords, $sCostResult, $debug) ; return whether or not we successfully upgraded
		EndIf
		If _Sleep($DELAYLABORATORY2) Then Return
		CloseWindow()

	Else ; users choice is any upgrade
		While($iCurPage <= $iPages)
			SetDebugLog("User picked any upgrade.")
			If $iCurPage >= $iPages Then ;Use last partial page
				SetDebugLog("Finding on last page diamond")
				local $aPageUpgrades = findMultiple($g_sImgLabResearch, $sLabTroopsLastPageDiam, $sLabTroopsLastPageDiam, 0, 1000, 0, "objectname,objectpoints", True) ; Returns $aCurrentTroops[index] = $aArray[2] = ["TroopShortName", CordX,CordY]
			Else ;Use full page
				local $aPageUpgrades = findMultiple($g_sImgLabResearch, $sLabTroopsSectionDiam, $sLabTroopsSectionDiam, 0, 1000, 0, "objectname,objectpoints", True) ; Returns $aCurrentTroops[index] = $aArray[2] = ["TroopShortName", CordX,CordY]
			EndIf
			If UBound($aPageUpgrades, 1) >= 1 Then ; if we found any troops
				SetDebugLog("Found " & UBound($aPageUpgrades, 1) & " possible on this page #" & $iCurPage)
				For $i = 0 To UBound($aPageUpgrades, 1) - 1 ; Loop through found upgrades
					Local $aTempTroopArray = $aPageUpgrades[$i] ; Declare Array to Temp Array

					; find image slot that we found so that we can read the cost to see if we can upgrade it... slots read 1-12 top to bottom so barb = 1, arch = 2, giant = 3, etc...
					Local $aCoords = decodeSingleCoord($aTempTroopArray[1])
					$sCostResult = GetLabCostResult($aCoords) ; get cost of the current upgrade option

					If $sCostResult = "" Then ; not enough resources
						SetDebugLog("Lab Upgrade " & $aTempTroopArray[0] & " - Not enough Resources")
					Else
						Return LaboratoryUpgrade($aTempTroopArray[0], $aCoords, $sCostResult, $debug) ; return whether or not we successfully upgraded
					EndIf
					If _Sleep($DELAYLABORATORY2) Then Return
				Next
			EndIf

			LabNextPage($iCurPage, $iPages, $iYMidPoint) ; go to next page of upgrades
			$iCurPage += 1 ; Next page
			If _Sleep($DELAYLABORATORY2) Then Return
		WEnd

		; If We got to here without returning, then nothing available for upgrade
		SetLog("Nothing available for upgrade at the moment, try again later.")
		CloseWindow()
	EndIf

	Return False ; No upgrade started
EndFunc

; start a given upgrade
Func LaboratoryUpgrade($name, $aCoords, $sCostResult, $debug = False)
	SetLog("Selected upgrade: " & $name & " Cost: " & $sCostResult, $COLOR_INFO)
	ClickP($aCoords) ; click troop
	If _Sleep(2000) Then Return

	If Not(SetLabUpgradeTime($name)) Then
		SetDebugLog("Couldn't read upgrade time.  Continue anyway.", $COLOR_ERROR)
	EndIf
	If _Sleep($DELAYLABUPGRADE1) Then Return

	LabStatusGUIUpdate()
	If $debug = True Then ; if debugging, do not actually click it
		SetLog("[debug mode] - Start Upgrade, Click (" & 660 & "," & 520 + $g_iMidOffsetY & ")", $COLOR_ACTION)
		CloseWindow()
		Return True ; return true as if we really started an upgrade
	Else
		Click(660, 520 + $g_iMidOffsetY, 1, 0, "#0202") ; Everything is good - Click the upgrade button
		If isGemOpen(True) = False Then ; check for gem window
			; success
			SetLog("Upgrade " & $name & " in your laboratory started with success...", $COLOR_SUCCESS)
			PushMsg("LabSuccess")
			ChkLabUpgradeInProgress($name)
			If _Sleep($DELAYLABUPGRADE2) Then Return
			CloseWindow(False, True)
			Return True ; upgrade started
		Else
			SetLog("Oops, Gems required for " & $name & " Upgrade, try again.", $COLOR_ERROR)
			Return False
		EndIf
	EndIf
EndFunc

; get the time for the selected upgrade
Func SetLabUpgradeTime($sTrooopName)
	Local $Result = getLabUpgradeTime(575, 465 + $g_iMidOffsetY) ; Try to read white text showing time for upgrade
	Local $iLabFinishTime = ConvertOCRTime("Lab Time", $Result, False)
	SetDebugLog($sTrooopName & " Upgrade OCR Time = " & $Result & ", $iLabFinishTime = " & $iLabFinishTime & " m", $COLOR_INFO)
	Local $StartTime = _NowCalc() ; what is date:time now
	SetDebugLog($sTrooopName & " Upgrade Started @ " & $StartTime, $COLOR_SUCCESS)
	If $iLabFinishTime > 0 Then
		$g_sLabUpgradeTime = _DateAdd('n', Ceiling($iLabFinishTime), $StartTime)
		SetLog($sTrooopName & " Upgrade Finishes @ " & $Result & " (" & $g_sLabUpgradeTime & ")", $COLOR_SUCCESS)
		$iLabFinishTimeMod = $iLabFinishTime
		$g_iLaboratoryElixirCost = 0
		$g_iLaboratoryDElixirCost = 0
	Else
		SetLog("Error processing upgrade time required, try again!", $COLOR_WARNING)
		Return False
	EndIf
	If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asLabUpgradeTime[$g_iCurAccount] = $g_sLabUpgradeTime for instantly displaying in multi-stats
	Return True ; success
EndFunc

; get the cost of an upgrade based on its coords
; find image slot that we found so that we can read the cost to see if we can upgrade it... slots read 1-12 top to bottom so barb = 1, arch = 2, giant = 3, etc...
Func GetLabCostResult($aCoords)
	SetDebugLog("Getting lab cost.")
	SetDebugLog("$iYMidPoint=" & $iYMidPoint)
	Local $iCurSlotOnPage, $iCurSlotsToTheRight, $sCostResult
	$iCurSlotsToTheRight = Ceiling( ( Int($aCoords[0]) - Int(StringSplit($sLabTroopsSection, ",")[1]) ) / ($iSlotWidth + $iDistBetweenSlots) )
	If Int($aCoords[1]) < $iYMidPoint Then ; first row
		SetDebugLog("First row.")
		$iCurSlotOnPage = 2*$iCurSlotsToTheRight - 1
		SetDebugLog("$iCurSlotOnPage=" & $iCurSlotOnPage)
		$sCostResult = getLabUpgrdResourceWht(Int(StringSplit($sLabTroopsSection, ",")[1]) + 10 + ($iCurSlotsToTheRight-1)*($iSlotWidth + $iDistBetweenSlots), Int(StringSplit($sLabTroopsSection, ",")[2]) + 76)
		If $sCostResult = "" Then
			Local $XCoord = Int(StringSplit($sLabTroopsSection, ",")[1]) + 10 + ($iCurSlotsToTheRight-1)*($iSlotWidth + $iDistBetweenSlots) - 3
			Local $YCoord = Int(StringSplit($sLabTroopsSection, ",")[2]) + 76
			If QuickMIS("BC1", $g_sImgElixirDrop, $XCoord + 71, $YCoord, $XCoord + 87, $YCoord + 18) Then
				Local $g_iLaboratoryElixirCostOld = $g_iLaboratoryElixirCost
				Local $g_iLaboratoryElixirCostNew = getLabUpgrdResourceRed($XCoord, $YCoord + 2)
				If $g_iLaboratoryElixirCostNew <= $g_iLaboratoryElixirCostOld Or $g_iLaboratoryElixirCostOld = 0 Then $g_iLaboratoryElixirCost = $g_iLaboratoryElixirCostNew
			Else
				Local $g_iLaboratoryDElixirCostOld = $g_iLaboratoryDElixirCost
				Local $g_iLaboratoryDElixirCostNew = getLabUpgrdResourceRed($XCoord, $YCoord + 2)
				If $g_iLaboratoryDElixirCostNew <= $g_iLaboratoryDElixirCostOld Or $g_iLaboratoryDElixirCostOld = 0 Then $g_iLaboratoryDElixirCost = $g_iLaboratoryDElixirCostNew
			EndIf
		EndIf
	Else; second row
		SetDebugLog("Second row.")
		$iCurSlotOnPage = 2*$iCurSlotsToTheRight
		SetDebugLog("$iCurSlotOnPage=" & $iCurSlotOnPage)
		$sCostResult = getLabUpgrdResourceWht(Int(StringSplit($sLabTroopsSection, ",")[1]) + 10 + ($iCurSlotsToTheRight-1)*($iSlotWidth + $iDistBetweenSlots), $iYMidPoint + 76 + 2) ;was 76
		If $sCostResult = "" Then
			Local $XCoord = Int(StringSplit($sLabTroopsSection, ",")[1]) + 10 + ($iCurSlotsToTheRight-1)*($iSlotWidth + $iDistBetweenSlots) - 3
			Local $YCoord = $iYMidPoint + 76 + 2
			If QuickMIS("BC1", $g_sImgElixirDrop, $XCoord + 71, $YCoord, $XCoord + 87, $YCoord + 18) Then
				Local $g_iLaboratoryElixirCostOld = $g_iLaboratoryElixirCost
				Local $g_iLaboratoryElixirCostNew = getLabUpgrdResourceRed($XCoord, $YCoord + 2)
				If $g_iLaboratoryElixirCostNew <= $g_iLaboratoryElixirCostOld  Or $g_iLaboratoryElixirCostOld = 0 Then $g_iLaboratoryElixirCost = $g_iLaboratoryElixirCostNew
			Else
				Local $g_iLaboratoryDElixirCostOld = $g_iLaboratoryDElixirCost
				Local $g_iLaboratoryDElixirCostNew = getLabUpgrdResourceRed($XCoord, $YCoord + 2)
				If $g_iLaboratoryDElixirCostNew <= $g_iLaboratoryDElixirCostOld Or $g_iLaboratoryDElixirCostOld = 0 Then $g_iLaboratoryDElixirCost = $g_iLaboratoryDElixirCostNew
			EndIf
		EndIf
	EndIf
	SetDebugLog("Cost found is " & $sCostResult)
	Return $sCostResult
EndFunc

; if we are on last page, smaller clickdrag... for future dev: this is whatever is enough distance to move 6 off to the left and have the next page similarily aligned.  "-50" to avoid the white triangle.
Func LabNextPage($iCurPage, $iPages, $iYMidPoint)
	If $iCurPage >= $iPages Then Return ; nothing left to scroll
	If $iCurPage = $iPages - 1 Then ; last page
		;Last page has 5 columns of icons.  5*(94+12)= 5*106=530 . 720-530=190 . Offset To be Sure : 190-12=178
		SetDebugLog("Drag to last page to pixel 178")
		ClickDrag(720, $iYMidPoint - 50, 178, $iYMidPoint, 300)
	Else
		SetDebugLog("Drag to next full page.")
		ClickDrag(720, $iYMidPoint - 50, 85, $iYMidPoint, 300); ClickDrag(720, 418, 85, 468, 300)
	EndIf
EndFunc

; check the lab to see if something is upgrading in the lab already
Func ChkLabUpgradeInProgress($name = "")
	; check for upgrade in process - look for green in finish upgrade with gems button
	SetDebugLog("_GetPixelColor(730, 200): " & _GetPixelColor(730, 200, True) & ":A2CB6C", $COLOR_DEBUG)
	If _ColorCheck(_GetPixelColor(730, 200, True), Hex(0xA2CB6C, 6), 20) Then
		SetLog("Laboratory Upgrade in progress, waiting for completion", $COLOR_INFO)
		If _Sleep($DELAYLABORATORY2) Then Return
		; upgrade in process and time not recorded so update completion time!
		Local $sLabTimeOCR = getRemainTLaboratory(270, 227 + $g_iMidOffsetY)
		If $sLabTimeOCR = "" Then $sLabTimeOCR = getPetUpgradeTime(270, 227 + $g_iMidOffsetY)
		Local $iLabFinishTime = ConvertOCRTime("Lab Time", $sLabTimeOCR, False) + 1
		SetDebugLog("$sLabTimeOCR: " & $sLabTimeOCR & ", $iLabFinishTime = " & $iLabFinishTime & " m")
		If $iLabFinishTime > 0 Then
			$g_sLabUpgradeTime = _DateAdd('n', Ceiling($iLabFinishTime), _NowCalc())
			If @error Then _logErrorDateAdd(@error)
			SetLog("Research will finish in " & $sLabTimeOCR & " (" & $g_sLabUpgradeTime & ")")
			$iLabFinishTimeMod = $iLabFinishTime
			$g_iLaboratoryElixirCost = 0
			$g_iLaboratoryDElixirCost = 0
			LabStatusGUIUpdate() ; Update GUI flag
		ElseIf $g_bDebugSetlog Then
			SetLog("Invalid getRemainTLaboratory OCR", $COLOR_DEBUG)
		EndIf
		If _Sleep(500) Then Return

		Local $bUseBooks = False
		If $name <> "" Then
			Local $iLabFinishTimeDay = ConvertOCRTime("Lab Time (Day)", $sLabTimeOCR, False, "day")

			If Not $bUseBooks And $g_bUseBOE And $iLabFinishTimeDay >= $g_iUseBOETime Then
				SetLog("Use Book of Everything Enabled", $COLOR_INFO)
				SetLog("Lab Upgrade time > than " & $g_iUseBOETime & " day", $COLOR_INFO)
				If QuickMIS("BFI", $g_sImgBooks & "BOE*", 650, 230 + $g_iMidOffsetY, 730, 290 + $g_iMidOffsetY) Then
					Click($g_iQuickMISX, $g_iQuickMISY)
					If _Sleep(1000) Then Return
					If QuickMIS("BC1", $g_sImgBooks, 400, 360 + $g_iMidOffsetY, 500, 430 + $g_iMidOffsetY) Then
						Click($g_iQuickMISX, $g_iQuickMISY)
						SetLog("Successfully use Book of Everything", $COLOR_SUCCESS)
						$bUseBooks = True
						$ActionForModLog = "Use Book of Everything"
						If $g_iTxtCurrentVillageName <> "" Then
							GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Laboratory : " & $ActionForModLog, 1)
						Else
							GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Laboratory : " & $ActionForModLog, 1)
						EndIf
						_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Laboratory : " & $ActionForModLog & "")
						If _Sleep(1000) Then Return
					EndIf
				Else
					SetLog("Book of Everything Not Found", $COLOR_ERROR)
				EndIf
			EndIf

			If StringInStr($name, "Spell") Then 
				If Not $bUseBooks And $g_bUseBOS And $iLabFinishTimeDay >= $g_iUseBOSTime Then
					SetLog("Use Book of Spells Enabled", $COLOR_INFO)
					SetLog("Lab Upgrade time > than " & $g_iUseBOSTime & " day", $COLOR_INFO)
					If QuickMIS("BFI", $g_sImgBooks & "BOS*", 650, 230 + $g_iMidOffsetY, 730, 290 + $g_iMidOffsetY) Then
						Click($g_iQuickMISX, $g_iQuickMISY)
						If _Sleep(1000) Then Return
						If QuickMIS("BC1", $g_sImgBooks, 400, 360 + $g_iMidOffsetY, 500, 430 + $g_iMidOffsetY) Then
							Click($g_iQuickMISX, $g_iQuickMISY)
							SetLog("Successfully use Book of Spells", $COLOR_SUCCESS)
							$bUseBooks = True
							$ActionForModLog = "Use Book of Spells"
							If $g_iTxtCurrentVillageName <> "" Then
								GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Laboratory : " & $ActionForModLog, 1)
							Else
								GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Laboratory : " & $ActionForModLog, 1)
							EndIf
							_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Laboratory : " & $ActionForModLog & "")
							If _Sleep(1000) Then Return
						EndIf
					Else
						SetLog("Book of Spell Not Found", $COLOR_ERROR)
					EndIf
				EndIf
			Else
				If Not $bUseBooks And $g_bUseBOF And $iLabFinishTimeDay >= $g_iUseBOFTime Then
					SetLog("Use Book of Fighting Enabled", $COLOR_INFO)
					SetLog("Lab Upgrade time > than " & $g_iUseBOFTime & " day", $COLOR_INFO)
					If QuickMIS("BFI", $g_sImgBooks & "BOF*", 650, 230 + $g_iMidOffsetY, 730, 290 + $g_iMidOffsetY) Then
						Click($g_iQuickMISX, $g_iQuickMISY)
						If _Sleep(1000) Then Return
						If QuickMIS("BC1", $g_sImgBooks, 400, 360 + $g_iMidOffsetY, 500, 430 + $g_iMidOffsetY) Then
							Click($g_iQuickMISX, $g_iQuickMISY)
							SetLog("Successfully use Book of Fighting", $COLOR_SUCCESS)
							$bUseBooks = True
							$ActionForModLog = "Use Book of Fighting"
							If $g_iTxtCurrentVillageName <> "" Then
								GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Laboratory : " & $ActionForModLog, 1)
							Else
								GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Laboratory : " & $ActionForModLog, 1)
							EndIf
							_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Laboratory : " & $ActionForModLog & "")
							If _Sleep(1000) Then Return
						EndIf
					Else
						SetLog("Book of Fighting Not Found", $COLOR_ERROR)
					EndIf
				EndIf
			EndIf
			
		EndIf

		If $bUseBooks Then 
			$g_sLabUpgradeTime = "" ;reset lab upgrade time
			$iLabFinishTimeMod = 0
			;==========Show Red  Hide Green Hide Gray===
			GUICtrlSetState($g_hPicLabGray, $GUI_HIDE)
			GUICtrlSetState($g_hPicLabRed, $GUI_SHOW)
			GUICtrlSetState($g_hPicLabGreen, $GUI_HIDE)
			;===========================================
		Else
			;==========Hide Red  Show Green Hide Gray===
			GUICtrlSetState($g_hPicLabGray, $GUI_HIDE)
			GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicLabGreen, $GUI_SHOW)
			;===========================================
		EndIf

		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asLabUpgradeTime[$g_iCurAccount] = $g_sLabUpgradeTime for instantly displaying in multi-stats
		Return True
	EndIf
	Return False ; returns False if no upgrade in progress
EndFunc

; checks our global variable to see if we know of something already upgrading
Func ChkUpgradeInProgress()
	Local $TimeDiff ; time remaining on lab upgrade
	If $g_sLabUpgradeTime <> "" Then $TimeDiff = _DateDiff("n", _NowCalc(), $g_sLabUpgradeTime) ; what is difference between end time and now in minutes?
	If @error Then _logErrorDateDiff(@error)
	SetDebugLog($g_avLabTroops[$g_iCmbLaboratory][0] & " Lab end time: " & $g_sLabUpgradeTime & ", DIFF= " & $TimeDiff, $COLOR_DEBUG)

	If Not $g_bRunState Then Return
	If $TimeDiff <= 0 Then
		SetLog("Checking Troop Upgrade in Laboratory ...", $COLOR_INFO)
	Else
		SetLog("Laboratory Upgrade in progress, waiting for completion", $COLOR_INFO)
		$g_iLaboratoryElixirCost = 0
		$g_iLaboratoryDElixirCost = 0
		Return True
	EndIf
	Return False ; we currently do not know of any upgrades in progress
EndFunc

; Find Research Button
Func FindResearchButton()
	Local $aResearchButton = findButton("Research", Default, 1, True)
	If IsArray($aResearchButton) And UBound($aResearchButton, 1) = 2 Then
		If $g_bDebugImageSave Then SaveDebugImage("LabUpgrade") ; Debug Only
		ClickP($aResearchButton)
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for window to open
		Return True
	Else
		SetLog("Cannot find the Laboratory Research Button!", $COLOR_ERROR)
		ClickAway()
		Return False
	EndIf
EndFunc

Func UseLabPotion()
If $g_bUseLabPotion And $iLabFinishTimeMod > 1440 Then ; only use potion if lab upgrade time is more than 1 day
	If _Sleep(1000) Then Return
	Local $LabPotion = FindButton("LabPotion")
	If IsArray($LabPotion) And UBound($LabPotion) = 2 Then
		$IsResearchPotInStock = 1
		SetLog("Use Laboratory Potion", $COLOR_INFO)
		Local $LabBoosted = FindButton("LabBoosted")
		If IsArray($LabBoosted) And UBound($LabBoosted) = 2 Then ; Lab already boosted skip using potion
			SetLog("Detected Laboratory already boosted", $COLOR_INFO)
			If _Sleep(1000) Then Return
			ClickAway()
			Return
		EndIf
		Click($LabPotion[0], $LabPotion[1])
		If _Sleep(1000) Then Return
		If Not $g_bRunState Then Return
		If ClickB("BoostConfirm") Then
			SetLog("Laboratory Boosted With Research Potion", $COLOR_SUCCESS)
			$g_sLabUpgradeTime = _DateAdd('n', Ceiling($iLabFinishTimeMod - 1380), _NowCalc())
			SetLog("Recalculate Research time, using potion (" & $g_sLabUpgradeTime & ")")
			LabStatusGUIUpdate()
			$ActionForModLog = "Boosting Research"
			If $g_iTxtCurrentVillageName <> "" Then
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Laboratory : " & $ActionForModLog & " Using Potion", 1)
			Else
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Laboratory : " & $ActionForModLog & " Using Potion", 1)
			EndIf
			_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Laboratory : " & $ActionForModLog & "")
		EndIf
		If _Sleep(1000) Then Return
	Else
		SetLog("No Research Potion Found", $COLOR_DEBUG)
		$IsResearchPotInStock = 0
		If _Sleep(1000) Then Return
	EndIf
EndIf
EndFunc