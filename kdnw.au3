#include <GuiConstantsEx.au3>
#include <GUIConstants.au3>
#include <WindowsConstants.au3>

HotKeySet("q","CLOSEClicked")
HotKeySet("a","AddMouseClick")
HotKeySet("c","Clear")
HotKeySet("p","Play")
HotKeySet("s","Stop")


Local $clicks[10][2] = [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]]
Local $pixel[10][25]
Local $clickCount = 0
Local $isPlaying = 0
Local $bruteForceClick = 0
Local $speed = 2

Opt("GUIOnEventMode", 1)
$mainwindow = GUICreate("KDNW", 200, 300 )
; GuiSetStyle($DS_SETFOREGROUND, $WS_EX_TOPMOST)

Local $currentLine = 10;
Func CurrentLine()
     $currentLine = $currentLine + 15
     Return $currentLine
EndFunc

GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")

GUICtrlCreateLabel("(Q)uit: Key q", 0, CurrentLine())
GUICtrlCreateLabel("(A)dd click: Key a", 0, CurrentLine() )
GUICtrlCreateLabel("(C)lear clicks: Key c", 0, CurrentLine() )
GUICtrlCreateLabel("(P)lay: Key p", 0, CurrentLine() )
GUICtrlCreateLabel("(S)top: Key s", 0, CurrentLine())
$bruteForceOmLabel = GUICtrlCreateCheckBox("Brute force mode", 0, CurrentLine())
CurrentLine()
GUICtrlSetOnEvent( $bruteForceOmLabel, "SetBruteForceOn" )
$countLabel = GUICtrlCreateLabel("Recorded clicks: 0", 0, CurrentLine())

GUISetState(@SW_SHOW)

Func SetBruteForceOn()
	$on = 0	
	$on = GUICtrlRead($bruteForceClick)
	If $on = $GUI_CHECKED Then
		; Msgbox(0,"AI is", " on");
		$bruteForceClick = 1
	Else
		; Msgbox(0,"AI is", " off");
		$bruteForceClick = 0
	EndIf
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
    Sleep(100)
WEnd

Func Stop()
	$isRecording = 0;
	$isPlaying = 0
EndFunc

Func CheckPixel($index)
	$i = 0
	For $y = -2 to 2 Step 1
		For $x = -2 to 2 Step 1
			If Not ( PixelGetColor($clicks[$index][0]+$x, $clicks[$index][1]+$y) = $pixel[$index][$i] ) Then
				Return 0
			EndIf
			$i = $i + 1
		Next
	Next
	Return 1
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
				Sleep(3)
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
	For $y = -2 to 2 Step 1
		For $x = -2 to 2 Step 1
			$pixel[$index][$i] = PixelGetColor($clicks[$index][0]+$x, $clicks[$index][1]+$y)
			$i = $i + 1
		Next
	Next
EndFunc

Func AddMouseClick()
	If $isPlaying = 1 Then
		Return
	Endif
	$mp = MouseGetPos()
	$clicks[$clickCount][0] = $mp[0]
	$clicks[$clickCount][1] = $mp[1]
	StorePixel($clickCount)	
	If $clickCount < 9 Then
		$clickCount = $clickCount + 1
		; Msgbox(0,"Info","Successfully added a click");
	EndIf
	GUICtrlSetData($countLabel, "Recorded clicks: " & $clickCount )
EndFunc