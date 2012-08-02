#include <GuiConstantsEx.au3>
#include <GUIConstants.au3>
#include <WindowsConstants.au3>

HotKeySet("q","CLOSEClicked")
HotKeySet("p","Play")
HotKeySet("s","Stop")

HotKeySet("1","StoreLevelUp")
HotKeySet("2","StoreLevelUpOk")
HotKeySet("3","StorePZ")
HotKeySet("4","StoreOpenRef")
HotKeySet("5","StoreClickRef")
HotKeySet("6","StoreClickRefOk")
HotKeySet("7","StoreClickRefOkAck")
HotKeySet("8","StoreIncrAbility")
HotKeySet("9","StoreAbility")
HotKeySet("0","StoreAbilityOk")

HotKeySet("e","StoreEnoughPZ")
HotKeySet("y","StoreNotEnoughPZ1")
HotKeySet("x","StoreNotEnoughPZ2")
HotKeySet("c","StoreNotEnoughPZ3")
HotKeySet("v","StoreNotEnoughPZ4")

Local $lvlUp[2] = [0,0]
Local $lvlUpPixMap[25]
Local $lvlUpOk[2] = [0,0]
Local $lvlUpOkPixMap[25]

Local $pzField[2] = [0,0]

Local $openRef[2] = [0,0]
Local $openRefPixMap[25]
Local $ref[2] = [0,0]
Local $refPixMap[25]
Local $refOk[2] = [0,0]
Local $refOkPixMap[25]
Local $refOkAck[2] = [0,0]
Local $refOkAckPixMap[25]
Local $incrAbility[2] = [0,0]
Local $incrAbilityPixMap[25]
Local $storeAbility[2] = [0,0]
Local $storeAbilityPixMap[25]
Local $storeAbilityOk[2] = [0,0]
Local $storeAbilityOkPixMap[25]

Local $enoughPZPixel[25]
Local $notEnoughPZPixMap1[25]
Local $notEnoughPZPixMap2[25]
Local $notEnoughPZPixMap3[25]
Local $notEnoughPZPixMap4[25]

Local $isPlaying = 0
Local $speed = 5

Opt("GUIOnEventMode", 1)
$mainwindow = GUICreate("Level legend", 250, 350 )
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
$label1 = GUICtrlCreateLabel("(1) Store lvl up (invalid)", 0, CurrentLine())
$label2 = GUICtrlCreateLabel("(2) Store lvl up ok (invalid)", 0, CurrentLine())
$label3 = GUICtrlCreateLabel("(3) Store PZ field check (invalid)", 0, CurrentLine())
$label4 = GUICtrlCreateLabel("(4) Store open ref (invalid)", 0, CurrentLine())
$label5 = GUICtrlCreateLabel("(5) Store ref (invalid)", 0, CurrentLine())
$label6 = GUICtrlCreateLabel("(6) Store ref ok (invalid)", 0, CurrentLine())
$label7 = GUICtrlCreateLabel("(7) Store ref ok acknowledge (invalid)", 0, CurrentLine())
$label8 = GUICtrlCreateLabel("(8) Store increments ability (invalid)", 0, CurrentLine())
$label9 = GUICtrlCreateLabel("(9) Store save ability (invalid)", 0, CurrentLine())
$label0 = GUICtrlCreateLabel("(0) Store save ability ok (invalid)", 0, CurrentLine())
CurrentLine()
$labelEnough = GUICtrlCreateLabel("(e) Store enough pz (invalid)", 0, CurrentLine())
$nepLabel1 = GUICtrlCreateLabel("(y) Store not enough pz 1 (invalid) ", 0, CurrentLine())
$nepLabel2 = GUICtrlCreateLabel("(x) Store not enough pz 2 (invalid)", 0, CurrentLine())
$nepLabel3 = GUICtrlCreateLabel("(c) Store not enough pz 3 (invalid)", 0, CurrentLine())
$nepLabel4 = GUICtrlCreateLabel("(v) Store not enough pz 4 (invalid)", 0, CurrentLine())


GUISetState(@SW_SHOW)


Func CLOSEClicked()
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
	For $y = -2 to 2 Step 1
		For $x = -2 to 2 Step 1
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
		Sleep(3)
	WEnd
	MouseClick("left", $pos[0], $pos[1], 1, $speed)
	Return $isPlaying
EndFunc

Func CheckPZ()
	$ready = 0
	While Not $ready
		If CheckPixel($enoughPZPixel, $pzField) Then 
			Return 1 
		EndIf

		If CheckPixel($notEnoughPZPixMap1, $pzField) Then 
			Return 0 
		EndIf
		If CheckPixel($notEnoughPZPixMap2, $pzField) Then 
			Return 0 
		EndIf
		If CheckPixel($notEnoughPZPixMap3, $pzField) Then 
			Return 0 
		EndIf
		If CheckPixel($notEnoughPZPixMap4, $pzField) Then 
			Return 0 
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
		iF Not Click($lvlUpPixMap, $lvlUp) Then 
			Return 
		EndIf
		iF Not Click($lvlUpOkPixMap, $lvlUpOk) Then 
			Return 
		EndIf
		If CheckPZ() Then
			For $i = 0 to 10 Step 1
				Sleep(5)
				iF Not Click($incrAbilityPixMap, $incrAbility) Then 
					Return 
				EndIf
			Next
			iF Not Click($storeAbilityPixMap, $storeAbility) Then 
				Return 
			EndIf
			iF Not Click($storeAbilityOkPixMap, $storeAbilityOk) Then 
				Return 
			EndIf
		Else
			iF Not Click($openRefPixMap, $openRef) Then 
				Return 
			EndIf
			iF Not Click($refPixMap, $ref) Then 
				Return 
			EndIf
			iF Not Click($refOkPixMap, $refOk) Then 
				Return 
			EndIf
			iF Not Click($refOkAckPixMap, $refOkAck) Then 
				Return 
			EndIf
		EndIf		
	WEnd
EndFunc

Func StorePixMap(ByRef $pixMap, $pos)
	$i = 0
	For $y = -2 to 2 Step 1
		For $x = -2 to 2 Step 1
			$pixMap[$i] = PixelGetColor($pos[0]+$x, $pos[1]+$y)
			$i = $i + 1
		Next
	Next
EndFunc

Func StoreMouseClick( ByRef $pos)
	If $isPlaying = 1 Then
		Return
	Endif
	$mp = MouseGetPos()
	$pos[0] = $mp[0]
	$pos[1] = $mp[1]
EndFunc

Func StoreLevelUp()
	StoreMouseClick($lvlUp)
	StorePixMap($lvlUpPixMap, $lvlUp)
	GUICtrlSetData($label1, "(1) Store lvl up (ok)" )
EndFunc

Func StoreLevelUpOk()
	StoreMouseClick($lvlUpOk)
	StorePixMap($lvlUpOkPixMap, $lvlUpOk)
	GUICtrlSetData($label2, "(2) Store lvl up ok (ok) " )
EndFunc

Func StorePZ()
	StoreMouseClick($pzField)
	GUICtrlSetData($label3, "(3) Store PZ field check (ok) " )
EndFunc

Func StoreOpenRef()
	StoreMouseClick($openRef)
	StorePixMap($openRefPixMap, $openRef)
	GUICtrlSetData($label4, "(4) Store open ref (ok) " )
EndFunc
Func StoreClickRef()
	StoreMouseClick($ref)
	StorePixMap($refPixMap, $ref)
	GUICtrlSetData($label5, "(5) Store ref (ok) " )
EndFunc
Func StoreClickRefOk()
	StoreMouseClick($refOk)
	StorePixMap($refOkPixMap, $refOk)
	GUICtrlSetData($label6, "(6) Store ref ok (ok) " )
EndFunc
Func StoreClickRefOkAck()
	StoreMouseClick($refOkAck)
	StorePixMap($refOkAckPixMap, $refOkAck)
	GUICtrlSetData($label7, "(7) Store ref ok acknowledge (ok) " )
EndFunc
Func StoreEnoughPZ()
	StorePixMap($enoughPZPixel, $pzField)
	GUICtrlSetData($labelEnough, "(e) Store enough pz (ok) " )
EndFunc
Func StoreNotEnoughPZ1()
	StorePixMap($notEnoughPZPixMap1, $pzField)
	GUICtrlSetData($nepLabel1, "(y) Store not enough pz 1 (ok) ")
EndFunc
Func StoreNotEnoughPZ2()
	StorePixMap($notEnoughPZPixMap2, $pzField)
	GUICtrlSetData($nepLabel2, "(x) Store not enough pz 2 (ok) ")
EndFunc
Func StoreNotEnoughPZ3()
	StorePixMap($notEnoughPZPixMap3, $pzField)
	GUICtrlSetData($nepLabel3, "(c) Store not enough pz 3 (ok)" )
EndFunc
Func StoreNotEnoughPZ4()
	StorePixMap($notEnoughPZPixMap4, $pzField)
	GUICtrlSetData($nepLabel4, "(c) Store not enough pz 4 (ok)" )
EndFunc
Func StoreIncrAbility()
	StoreMouseClick($incrAbility)
	StorePixMap($incrAbilityPixMap, $incrAbility)
	GUICtrlSetData($label8, "(8) Store increments ability (ok) " )
EndFunc
Func StoreAbility()
	StoreMouseClick($storeAbility)
	StorePixMap($storeAbilityPixMap, $storeAbility)
	GUICtrlSetData($label9, "(9) Store save ablity (ok) " )
EndFunc
Func StoreAbilityOk()
	StoreMouseClick($storeAbilityOk)
	StorePixMap($storeAbilityOkPixMap, $storeAbilityOk)
	GUICtrlSetData($label0, "(0) Store save ablity ok (ok) " )
EndFunc
