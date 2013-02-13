#include <GuiConstantsEx.au3>
#include <GUIConstants.au3>
#include <WindowsConstants.au3>

HotKeySet("^q","CLOSEClicked")
HotKeySet("^a","AddMouseClick")
HotKeySet("^c","Clear")
HotKeySet("^p","Play")
HotKeySet("^s","Stop")

Local $MaxClicks = 20
Local $clicks[20][2] = [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]]
Local $pixel[20][100]
Local $graphics[20]

Local $clickCount = 0
Local $isPlaying = 0
Local $bruteForceClick = 0
Local $speed = 1

Opt("GUIOnEventMode", 1)
$mainwindow = GUICreate("KDNW", 220, 350 )
; GuiSetStyle($DS_SETFOREGROUND, $WS_EX_TOPMOST)

Local $currentLine = 0;
Func CurrentLine()
     $currentLine = $currentLine + 15
     Return $currentLine
EndFunc

GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")

GUICtrlCreateLabel("Hit Ctrl+Key", 0, CurrentLine())
CurrentLine()
GUICtrlCreateLabel("(Q)uit: Key q", 0, CurrentLine())
GUICtrlCreateLabel("(A)dd click: Key a", 0, CurrentLine() )
GUICtrlCreateLabel("(C)lear clicks: Key c", 0, CurrentLine() )
GUICtrlCreateLabel("(P)lay: Key p", 0, CurrentLine() )
GUICtrlCreateLabel("(S)top: Key s", 0, CurrentLine())
$bruteForceCheckBox = GUICtrlCreateCheckBox("Brute force mode", 0, CurrentLine())
CurrentLine()
$cl = CurrentLine()
GUICtrlCreateLabel("Move time", 0, $cl)
$speedInput = GUICtrlCreateInput("1", 70, $cl )
$speedSpinBox = GUICtrlCreateUpdown($speedInput)
GUICtrlSetLimit($speedSpinBox,100,0)
GUICtrlSetOnEvent( $speedInput, "SetSpeed" )

CurrentLine()
GUICtrlSetOnEvent( $bruteForceCheckBox, "SetBruteForceOn" )
$countLabel = GUICtrlCreateLabel("Recorded clicks: 0", 0, CurrentLine())
$debugLabel1 = GUICtrlCreateLabel("wrong pixel index: 0", 0, CurrentLine())
$debugLabel2 = GUICtrlCreateLabel("Scr: 00000000000000000", 0, CurrentLine())
$debugLabel3 = GUICtrlCreateLabel("Buf: 00000000000000000", 0, CurrentLine())
$debugLabel4 = GUICtrlCreateLabel("R: 0000000000000000000", 0, CurrentLine())
$debugLabel5 = GUICtrlCreateLabel("G: 0000000000000000000", 0, CurrentLine())
$debugLabel6 = GUICtrlCreateLabel("B: 0000000000000000000", 0, CurrentLine())
$debugLabel7 = GUICtrlCreateLabel("                          ", 0, CurrentLine())
CurrentLine()
CurrentLine()

for $gi = 0 to $MaxClicks-1 Step 1
	$graphics[$gi] = GUICtrlCreateGraphic($gi*11, $currentLine, 10, 10)
Next

GUISetState(@SW_SHOW)

Func DrawPixmap($index)
	$i = 0
	For $y = 0 to 9 Step 1
		For $x = 0 to 9 Step 1
			GUICtrlSetGraphic($graphics[$index], $GUI_GR_COLOR, $pixel[$index][$i])
			GUICtrlSetGraphic($graphics[$index], $GUI_GR_PIXEL, $x, $y)
			$i = $i + 1
		Next
	Next
	GUICtrlSetGraphic($graphics[$index],$GUI_GR_REFRESH)
EndFunc

Func SetBruteForceOn()
	$on = 0	
	$on = GUICtrlRead($bruteForceCheckBox)
	If $on = $GUI_CHECKED Then
		$bruteForceClick = 1
	Else
		$bruteForceClick = 0
	EndIf
EndFunc

Func SetSpeed()
	$speed = Number( GUICtrlRead($speedInput) )
EndFunc

Func Clear()
	If $isPlaying = 1 Then
		Return
	Endif
	$clickCount = 0
	GUICtrlSetData($countLabel, "Recorded clicks: " & $clickCount )
EndFunc

Func CLOSEClicked()
  Exit
EndFunc

While 1
    Sleep(50)
WEnd

Func Stop()
	$isRecording = 0;
	$isPlaying = 0
EndFunc

Func IsValueSimilar($v1, $v2, $eps)
	If $v1 > $v2  Then
		If ( $v1 - $v2 ) <= $eps Then
			Return true
		Endif
	Else
		If ( $v2 - $v1 ) <= $eps Then
			Return true
		Endif
	Endif
	Return false		
EndFunc

Func IsColorSimilar($color1, $color2, $eps)
	$red1 = BitShift($color1, 16)
	$green1 = BitAnd(BitShift($color1, 8),0x0000FF)
	$blue1 = BitAnd($color1,0x0000FF)

	$red2 = BitShift($color2, 16)
	$green2 = BitAnd(BitShift($color2, 8),0x0000FF)
	$blue2 = BitAnd($color2,0x0000FF)
	
	if Not IsValueSimilar($red1, $red2, $eps) Then
		Return false
	Endif
	If Not IsValueSimilar($green1, $green2, $eps) Then
		Return false
	Endif
	If Not IsValueSimilar($blue1, $blue2, $eps) Then
		Return false
	EndIf
	Return true
EndFunc

Func CompareScreenPixel($index, $offsetX, $offsetY)
	$i = 0
	For $y = -5 to 4 Step 1
		For $x = -5 to 4 Step 1
			$screenPixel = PixelGetColor($clicks[$index][0]+$x+$offsetX, $clicks[$index][1]+$y+$offsetY)
			$storedPixel = $pixel[$index][$i]
			If Not ( IsColorSimilar($screenPixel, $storedPixel, 0x05) ) Then
			; If Not ( $screenPixel = $storedPixel ) Then
				; $red = BitShift($storedPixel, 16)
				; $green = BitAnd(BitShift($storedPixel, 8),0x0000FF)
				; $blue = BitAnd($storedPixel,0x0000FF)
				; GUICtrlSetData($debugLabel1, "Pixel at: [" & $x & "," & $y & "]")
				; GUICtrlSetData($debugLabel2, "Scr:" & Hex($screenPixel, 6) )
				; GUICtrlSetData($debugLabel3, "Buf: " & Hex($storedPixel, 6) )
				; GUICtrlSetData($debugLabel4, "R: " & Hex($red, 6) )
				; GUICtrlSetData($debugLabel5, "G: " & Hex($green, 6) )
				; GUICtrlSetData($debugLabel6, "B: " & Hex($blue, 6) )
				; GUICtrlSetData($debugLabel7, "           " )
				Return 0
			EndIf
			$i = $i + 1
		Next
	Next
	Return 1
EndFunc

Func CheckPixel($index)
	Return CompareScreenPixel($index, 0, 0)
	; For $offsetX = 0 to 5 Step 1
		; For $offsetY = 0 to 5 Step 1
			; If CompareScreenPixel($index, $offsetX, $offsetY) = 1 Then
				; Return 1
			; EndIf
		; Next
	; Next
	; For $offsetX = -1 to -5 Step -1
		; For $offsetY = -1 to -5 Step -1
			; If CompareScreenPixel($index, $offsetX, $offsetY) = 1 Then
				; Return 1
			; EndIf
		; Next
	; Next
	; Return 0
EndFunc

Func Play()
	If $clickCount = 0 Then
		Return
	EndIf
    $isPlaying = 1
	$i = 0
	While $isPlaying = 1
		If $i >= $clickCount Then
			$i = 0
		Endif
		MouseMove($clicks[$i][0], $clicks[$i][1], $speed)
		If $bruteForceClick = 0 Then
			While Not CheckPixel($i) 
				If Not $isPlaying Then
					Return
				EndIf
				Sleep(1)
				MouseMove($clicks[$i][0], $clicks[$i][1], 0)
			WEnd
		Else
			Sleep($speed)
		Endif
		MouseClick("left", $clicks[$i][0], $clicks[$i][1], 1, $speed)
		$i = $i + 1
	WEnd
EndFunc

Func StorePixel($index)
	$i = 0
	For $y = -5 to 4 Step 1
		For $x = -5 to 4 Step 1
			$pixel[$index][$i] = PixelGetColor($clicks[$index][0]+$x, $clicks[$index][1]+$y)
			$i = $i + 1
		Next
	Next
	DrawPixmap($index)
EndFunc

Func AddMouseClick()
	If $isPlaying = 1 Then
		Return
	Endif
	$mp = MouseGetPos()
	$clicks[$clickCount][0] = $mp[0]
	$clicks[$clickCount][1] = $mp[1]
	StorePixel($clickCount)	
	If $clickCount < $MaxClicks Then
		$clickCount = $clickCount + 1
		; Msgbox(0,"Info","Successfully added a click");
	EndIf
	GUICtrlSetData($countLabel, "Recorded clicks: " & $clickCount )
EndFunc