#include <GuiConstantsEx.au3>
#include <GUIConstants.au3>
#include <WindowsConstants.au3>

HotKeySet("^q","CLOSEClicked")
HotKeySet("^p","Play")
HotKeySet("^s","Stop")

HotKeySet("^1","StoreLevelUp")
HotKeySet("^2","StoreLevelUpOk")
HotKeySet("^3","StorePZ")
HotKeySet("^4","StoreOpenRef")
HotKeySet("^5","StoreClickRef")
HotKeySet("^6","StoreClickRefOk")
HotKeySet("^7","StoreClickRefOkAck")
HotKeySet("^8","StoreIncrAbility")
HotKeySet("^9","StoreAbility")
HotKeySet("^0","StoreAbilityOk")

HotKeySet("^e","StoreEnoughPZ")
HotKeySet("^y","StoreNotEnoughPZ1")
HotKeySet("^x","StoreNotEnoughPZ2")
HotKeySet("^c","StoreNotEnoughPZ3")
HotKeySet("^v","StoreNotEnoughPZ4")
HotKeySet("^b","StoreNotEnoughPZ5")

Local $lvlUp[2] = [0,0]
Local $lvlUpPixMap[100]
Local $lvlUpOk[2] = [0,0]
Local $lvlUpOkPixMap[100]

Local $pzField[2] = [0,0]

Local $openRef[2] = [0,0]
Local $openRefPixMap[100]
Local $ref[2] = [0,0]
Local $refPixMap[100]
Local $refOk[2] = [0,0]
Local $refOkPixMap[100]
Local $refOkAck[2] = [0,0]
Local $refOkAckPixMap[100]
Local $incrAbility[2] = [0,0]
Local $incrAbilityPixMap[100]
Local $storeAbility[2] = [0,0]
Local $storeAbilityPixMap[100]
Local $storeAbilityOk[2] = [0,0]
Local $storeAbilityOkPixMap[100]

Local $pzFieldPixel[100]
Local $enoughPZPixel[100]
Local $notEnoughPZPixMap1[100]
Local $notEnoughPZPixMap2[100]
Local $notEnoughPZPixMap3[100]
Local $notEnoughPZPixMap4[100]
Local $notEnoughPZPixMap5[100]
Local $graphics[20]

Local $isPlaying = 0
Local $speed = 5

Local $file = FileOpen( @TempDir & "\reff_6_stats.csv", 1)

Opt("GUIOnEventMode", 1)
$mainwindow = GUICreate("Level legend", 220, 420 )
; GuiSetStyle($DS_SETFOREGROUND, $WS_EX_TOPMOST)

Local $currentLine = 10;
Func CurrentLine()
     $currentLine = $currentLine + 15
     Return $currentLine
EndFunc

GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")

GUICtrlCreateLabel("(Q)uit: Key q", 0, CurrentLine())
GUICtrlCreateLabel("(P)lay: Key p", 0, CurrentLine() )
GUICtrlCreateLabel("(S)top: Key s", 0, CurrentLine())
CurrentLine()
$label1 = GUICtrlCreateLabel("(1) lvl up", 0, CurrentLine())
$graphics[0] = GUICtrlCreateGraphic(160, $currentLine, 10, 10)
$label2 = GUICtrlCreateLabel("(2) lvl up ok", 0, CurrentLine())
$graphics[1] = GUICtrlCreateGraphic(160, $currentLine, 10, 10)
$label3 = GUICtrlCreateLabel("(3) PZ field check", 0, CurrentLine())
$graphics[2] = GUICtrlCreateGraphic(160, $currentLine, 10, 10)
$label4 = GUICtrlCreateLabel("(4) open ref", 0, CurrentLine())
$graphics[3] = GUICtrlCreateGraphic(160, $currentLine, 10, 10)
$label5 = GUICtrlCreateLabel("(5) ref", 0, CurrentLine())
$graphics[4] = GUICtrlCreateGraphic(160, $currentLine, 10, 10)
$label6 = GUICtrlCreateLabel("(6) ref ok", 0, CurrentLine())
$graphics[5] = GUICtrlCreateGraphic(160, $currentLine, 10, 10)
$label7 = GUICtrlCreateLabel("(7) ref ok acknowledge", 0, CurrentLine())
$graphics[6] = GUICtrlCreateGraphic(160, $currentLine, 10, 10)
$label8 = GUICtrlCreateLabel("(8) increments ability", 0, CurrentLine())
$graphics[7] = GUICtrlCreateGraphic(160, $currentLine, 10, 10)
$label9 = GUICtrlCreateLabel("(9) save ability", 0, CurrentLine())
$graphics[8] = GUICtrlCreateGraphic(160, $currentLine, 10, 10)
$label0 = GUICtrlCreateLabel("(0) save ability ok", 0, CurrentLine())
$graphics[9] = GUICtrlCreateGraphic(160, $currentLine, 10, 10)
CurrentLine()
$labelEnough = GUICtrlCreateLabel("(e) enough pz", 0, CurrentLine())
$graphics[10] = GUICtrlCreateGraphic(160, $currentLine, 10, 10)
$nepLabel1 = GUICtrlCreateLabel("(y) not enough pz 1 ", 0, CurrentLine())
$graphics[11] = GUICtrlCreateGraphic(160, $currentLine, 10, 10)
$nepLabel2 = GUICtrlCreateLabel("(x) not enough pz 2", 0, CurrentLine())
$graphics[12] = GUICtrlCreateGraphic(160, $currentLine, 10, 10)
$nepLabel3 = GUICtrlCreateLabel("(c) not enough pz 3", 0, CurrentLine())
$graphics[13] = GUICtrlCreateGraphic(160, $currentLine, 10, 10)
$nepLabel4 = GUICtrlCreateLabel("(v) not enough pz 4", 0, CurrentLine())
$graphics[14] = GUICtrlCreateGraphic(160, $currentLine, 10, 10)
$nepLabel5 = GUICtrlCreateLabel("(b) not enough pz 5", 0, CurrentLine())
$graphics[15] = GUICtrlCreateGraphic(160, $currentLine, 10, 10)
CurrentLine()
$clickTimeLabel = GUICtrlCreateLabel("Reff time: 00:00:00:000", 0, CurrentLine())


GUISetState(@SW_SHOW)

Func DrawPixmap($index, ByRef $pixMap)
	$i = 0
	For $y = 0 to 9 Step 1
		For $x = 0 to 9 Step 1
			; GUICtrlSetGraphic($a, $GUI_GR_MOVE, 0, 0)
			GUICtrlSetGraphic($graphics[$index], $GUI_GR_COLOR, $pixMap[$i])
			GUICtrlSetGraphic($graphics[$index], $GUI_GR_PIXEL, $x, $y)
			$i = $i + 1
		Next
	Next
	GUICtrlSetGraphic($graphics[$index],$GUI_GR_REFRESH)
EndFunc

Func CLOSEClicked()
  FileClose($file)
  Exit
EndFunc

While 1
    Sleep(100)
WEnd

Func Stop()
	$isRecording = 0;
	$isPlaying = 0
EndFunc

Func CheckPixel($pixMap, $pos)
	$i = 0
	For $y = -5 to 4 Step 1
		For $x = -5 to 4 Step 1
			If Not ( PixelGetColor($pos[0]+$x, $pos[1]+$y) = $pixMap[$i] ) Then
				Return 0
			EndIf
			$i = $i + 1
		Next
	Next
	Return 1
EndFunc

Func Click($pixMap, $pos)
	MouseMove($pos[0], $pos[1], $speed)
	While Not CheckPixel($pixMap, $pos) 
		If $isPlaying = 0 Then
			Return 0
		Endif
		MouseMove($pos[0], $pos[1], 0)
		Sleep(1)
	WEnd
	MouseClick("left", $pos[0], $pos[1], 1, 0)
	Return $isPlaying
EndFunc

Func CheckPZ()
	$ready = 0
	While Not $ready
		If CheckPixel($enoughPZPixel, $pzField) Then 
			Return 6 
		EndIf

		If CheckPixel($notEnoughPZPixMap1, $pzField) Then 
			Return 1 
		EndIf
		If CheckPixel($notEnoughPZPixMap2, $pzField) Then 
			Return 2 
		EndIf
		If CheckPixel($notEnoughPZPixMap3, $pzField) Then 
			Return 3 
		EndIf
		If CheckPixel($notEnoughPZPixMap4, $pzField) Then 
			Return 4
		EndIf
		If CheckPixel($notEnoughPZPixMap5, $pzField) Then 
			Return 5
		EndIf
	WEnd
	Return 0
EndFunc

Func Play()
	; If Not $notEnoughPZPixelIndex = 0 Then
		; Return
	; EndIf
    $isPlaying = 1
	While $isPlaying = 1
		; Msgbox(0,"Info","Click level up");
		If Not Click($lvlUpPixMap, $lvlUp) Then 
			Return 
		EndIf
		Local $hour = @HOUR
		Local $min = @MIN
		Local $sec = @SEC
		Local $msec = @MSEC
		Local $time = StringFormat("%02i:%02i:%02i:%03i", $hour, $min, $sec, $msec)
		GUICtrlSetData($clickTimeLabel, "Reff time: " & $time)

		If Not Click($lvlUpOkPixMap, $lvlUpOk) Then 
			Return 
		EndIf

		Local $pzCount = CheckPZ()
		FileWriteLine($file, StringFormat("%02i;%02i;%02i;%03i;%i", $hour, $min, $sec, $msec, $pzCount) )
		If $pzCount = 6 Then
			For $i = 0 to 10 Step 1
				Sleep(5)
				If Not Click($incrAbilityPixMap, $incrAbility) Then 
					Return 
				EndIf
			Next
			If Not Click($storeAbilityPixMap, $storeAbility) Then 
				Return 
			EndIf
			If Not Click($storeAbilityOkPixMap, $storeAbilityOk) Then 
				Return 
			EndIf
		Else
			If Not Click($openRefPixMap, $openRef) Then 
				Return 
			EndIf
			If Not Click($refPixMap, $ref) Then 
				Return 
			EndIf
			If Not Click($refOkPixMap, $refOk) Then 
				Return 
			EndIf
			If Not Click($refOkAckPixMap, $refOkAck) Then 
				Return 
			EndIf
		EndIf
	WEnd
EndFunc

Func StorePixMap(ByRef $pixMap, $pos)
	$i = 0
	For $y = -5 to 4 Step 1
		For $x = -5 to 4 Step 1
			$pixMap[$i] = PixelGetColor($pos[0]+$x, $pos[1]+$y)
			$i = $i + 1
		Next
	Next
EndFunc

Func StoreMouseClick( ByRef $pos)
	$mp = MouseGetPos()
	$pos[0] = $mp[0]
	$pos[1] = $mp[1]
EndFunc

Func StoreLevelUp()
	StoreMouseClick($lvlUp)
	StorePixMap($lvlUpPixMap, $lvlUp)
	DrawPixmap(0, $lvlUpPixMap)
EndFunc

Func StoreLevelUpOk()
	StoreMouseClick($lvlUpOk)
	StorePixMap($lvlUpOkPixMap, $lvlUpOk)
	DrawPixmap(1, $lvlUpOkPixMap)
EndFunc

Func StorePZ()
	StoreMouseClick($pzField)
	StorePixMap($pzFieldPixel, $pzField)
	DrawPixmap(2, $pzFieldPixel)
EndFunc

Func StoreOpenRef()
	StoreMouseClick($openRef)
	StorePixMap($openRefPixMap, $openRef)
	DrawPixmap(3, $openRefPixMap)
EndFunc
Func StoreClickRef()
	StoreMouseClick($ref)
	StorePixMap($refPixMap, $ref)
	DrawPixmap(4, $refPixMap)
EndFunc
Func StoreClickRefOk()
	StoreMouseClick($refOk)
	StorePixMap($refOkPixMap, $refOk)
	DrawPixmap(5, $refOkPixMap)
EndFunc
Func StoreClickRefOkAck()
	StoreMouseClick($refOkAck)
	StorePixMap($refOkAckPixMap, $refOkAck)
	DrawPixmap(6, $refOkAckPixMap)
EndFunc
Func StoreIncrAbility()
	StoreMouseClick($incrAbility)
	StorePixMap($incrAbilityPixMap, $incrAbility)
	DrawPixmap(7, $incrAbilityPixMap)
EndFunc
Func StoreAbility()
	StoreMouseClick($storeAbility)
	StorePixMap($storeAbilityPixMap, $storeAbility)
	DrawPixmap(8, $storeAbilityPixMap)
EndFunc
Func StoreAbilityOk()
	StoreMouseClick($storeAbilityOk)
	StorePixMap($storeAbilityOkPixMap, $storeAbilityOk)
	DrawPixmap(9, $storeAbilityOkPixMap)
EndFunc
Func StoreEnoughPZ()
	StorePixMap($enoughPZPixel, $pzField)
	DrawPixmap(10, $enoughPZPixel)
EndFunc
Func StoreNotEnoughPZ1()
	StorePixMap($notEnoughPZPixMap1, $pzField)
	DrawPixmap(11, $notEnoughPZPixMap1)
EndFunc
Func StoreNotEnoughPZ2()
	StorePixMap($notEnoughPZPixMap2, $pzField)
	DrawPixmap(12, $notEnoughPZPixMap2)
EndFunc
Func StoreNotEnoughPZ3()
	StorePixMap($notEnoughPZPixMap3, $pzField)
	DrawPixmap(13, $notEnoughPZPixMap3)
EndFunc
Func StoreNotEnoughPZ4()
	StorePixMap($notEnoughPZPixMap4, $pzField)
	DrawPixmap(14, $notEnoughPZPixMap4)
EndFunc
Func StoreNotEnoughPZ5()
	StorePixMap($notEnoughPZPixMap5, $pzField)
	DrawPixmap(15, $notEnoughPZPixMap5)
EndFunc

FileClose($file)

