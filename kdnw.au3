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
Local $posLabels[20]
Local $graphic
Local $wrongPixel[100]

Local $clickCount = 0
Local $isPlaying = 0
Local $bruteForceClick = 0
Local $speed = 1
Local $lastWrongIndex = -1
Opt("GUIOnEventMode", 1)
$mainwindow = GUICreate("KDNW", 190, 550 )
; GuiSetStyle($DS_SETFOREGROUND, $WS_EX_TOPMOST)

Global $currentLine = 0;
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
CurrentLine()
GUICtrlCreateLabel("Move time", 0, $currentLine)
$speedInput = GUICtrlCreateInput("1", 70, $currentLine )
$speedSpinBox = GUICtrlCreateUpdown($speedInput)
GUICtrlSetLimit($speedSpinBox,100,0)
GUICtrlSetOnEvent( $speedInput, "SetSpeed" )

CurrentLine()
GUICtrlSetOnEvent( $bruteForceCheckBox, "SetBruteForceOn" )
$countLabel = GUICtrlCreateLabel("Recorded clicks: 0", 0, CurrentLine())
CurrentLine()

$graphic = GUICtrlCreateGraphic(0, CurrentLine(), 24, ($MaxClicks+1)*15)
for $gi = 0 to $MaxClicks-1 Step 1
	$posLabels[$gi] = GUICtrlCreateLabel("[0,0]                      ", 24, $currentLine )
	GUICtrlSetTip( $posLabels[$gi], "" )
	CurrentLine()
Next

Clear()

GUISetState(@SW_SHOW)

Func DrawRect($x, $y, $width, $height, $color, $size = 1, $backColor = $GUI_GR_NOBKCOLOR)
	GUICtrlSetGraphic($graphic, $GUI_GR_PENSIZE, $size)
	GUICtrlSetGraphic($graphic, $GUI_GR_COLOR, $color, $backColor)
	GUICtrlSetGraphic($graphic, $GUI_GR_RECT, $x, $y, $width, $height)
	GUICtrlSetGraphic($graphic, $GUI_GR_CLOSE)
	GUICtrlSetGraphic($graphic,$GUI_GR_REFRESH)
EndFunc

Func DrawPoint($x, $y, $color, $backColor = $GUI_GR_NOBKCOLOR)
	GUICtrlSetGraphic($graphic, $GUI_GR_COLOR, $color, $backColor)
	GUICtrlSetGraphic($graphic, $GUI_GR_PIXEL, $x, $y)
	GUICtrlSetGraphic($graphic, $GUI_GR_CLOSE)
EndFunc

Func DrawPixmap($index)
	$i = 0
	For $y = 0 to 9 Step 1
		For $x = 0 to 9 Step 1
			DrawPoint($x+1, ($index*15)+1+$y, $pixel[$index][$i], $pixel[$index][$i])
			; GUICtrlSetGraphic($graphic, $GUI_GR_COLOR, $pixel[$index][$i])
			; GUICtrlSetGraphic($graphic, $GUI_GR_PIXEL, $x+1, ($index*15)+1+$y)
			; GUICtrlSetGraphic($graphic, $GUI_GR_CLOSE)
			$i = $i + 1
		Next
	Next
	; GUICtrlSetGraphic($graphic, $GUI_GR_CLOSE)
	GUICtrlSetGraphic($graphic,$GUI_GR_REFRESH)
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
	DrawRect( 0, 0, 24, $MaxClicks*15, 0xCFCFCF, 1, 0xCFCFCF )
	; DrawRect( 2, 5, 12, 15, 0xff0000 )
	for $gi = 0 to $MaxClicks-1 Step 1
		GUICtrlSetData($posLabels[$gi], "[0,0]                      " )
	Next
	; GUICtrlSetGraphic($graphic,$GUI_GR_REFRESH)
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
	$i = 0
	If $lastWrongIndex > -1 Then
		For $y = 0 to 9 Step 1
			For $x = 0 to 9 Step 1
				DrawPoint($x+12, ($lastWrongIndex*15)+1+$y, $wrongPixel[$i], $wrongPixel[$i])
				; GUICtrlSetGraphic($graphic, $GUI_GR_COLOR, $pixel[$index][$i])
				; GUICtrlSetGraphic($graphic, $GUI_GR_PIXEL, $x+1, ($index*15)+1+$y)
				; GUICtrlSetGraphic($graphic, $GUI_GR_CLOSE)
				$i = $i + 1
			Next
		Next
		; GUICtrlSetGraphic($graphic, $GUI_GR_CLOSE)
		GUICtrlSetGraphic($graphic,$GUI_GR_REFRESH)
	EndIf
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
	$isColorSimilar = 1
	$i = 0
	$tipText = ""
	For $y = -5 to 4 Step 1
		For $x = -5 to 4 Step 1
			$screenX = $clicks[$index][0]+$x+$offsetX
			$screenY = $clicks[$index][1]+$y+$offsetY
			$screenPixel = PixelGetColor($screenX, $screenY)
			$wrongPixel[$i] = $screenPixel
			$storedPixel = $pixel[$index][$i]
			If $isColorSimilar Then
				If Not ( IsColorSimilar($screenPixel, $storedPixel, 0x26) ) Then
					; $red = BitShift($storedPixel, 16)
					; $green = BitAnd(BitShift($storedPixel, 8),0x0000FF)
					; $blue = BitAnd($storedPixel,0x0000FF)
					$tipText = "Pos [" & $screenX & "," & $screenY & "]"
					$tipText = $tipText & @LF & "Pixel [" & $x+5 & "," & $y+5 & "]"
					$tipText = $tipText & @LF & "Scr:0x" & Hex($screenPixel, 6) 
					$tipText = $tipText & @LF & "Buf:0x" & Hex($storedPixel, 6)
					$isColorSimilar = 0
				EndIf
			EndIf
			$i = $i + 1
		Next
	Next
	GUICtrlSetTip( $posLabels[$index], $tipText )
	If Not $isColorSimilar Then
		DrawRect(0, (15*$index), 12, 12, 0xff0000)
		$lastWrongIndex = $index
		; DrawPixmap($index)
	Else
		If $lastWrongIndex > -1 Then
			DrawRect(0, (15*$lastWrongIndex), 12, 12, 0xCFCFCF)
			$lastWrongIndex = -1
		EndIf
		; GUICtrlSetGraphic($graphic, $GUI_GR_NOBKCOLOR )
		; GUICtrlSetGraphic($graphic, $GUI_GR_COLOR, 0xCFCFCF )
		; GUICtrlSetGraphic($graphic, $GUI_GR_RECT, 0, (15*$index), 12, 12)
		; DrawPixmap($index)
		; GUICtrlSetGraphic($graphic,$GUI_GR_REFRESH)
	Endif
	; GUICtrlSetGraphic($graphic,$GUI_GR_REFRESH)
	Return $isColorSimilar
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
	GUICtrlSetData($posLabels[$clickCount], "[" &  $clicks[$clickCount][0] & ", " & $clicks[$clickCount][1] &"]" )
	If $clickCount < $MaxClicks Then
		$clickCount = $clickCount + 1
		; Msgbox(0,"Info","Successfully added a click");
	EndIf
	GUICtrlSetData($countLabel, "Recorded clicks: " & $clickCount )
EndFunc