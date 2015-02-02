#include <GuiConstantsEx.au3>
#include <GUIConstants.au3>
#include <WindowsConstants.au3>


test
test

HotKeySet("^q","CLOSEClicked")
HotKeySet("^r","ResetTimer")
HotKeySet("^s","StopTimer")

Opt("GUIOnEventMode", 1)
$mainwindow = GUICreate("timer", 210, 150 )
; GuiSetStyle($DS_SETFOREGROUND, $WS_EX_TOPMOST)

Local $timerStart = 0;
Local $running = 0;

Local $currentLine = 0;
Func CurrentLine()
     $currentLine = $currentLine + 15
     Return $currentLine
EndFunc

GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")

CurrentLine()
GUICtrlCreateLabel("(Q)uit", 0, CurrentLine())
GUICtrlCreateLabel("(R)eset", 0, CurrentLine() )
GUICtrlCreateLabel("(S)top", 0, CurrentLine() )
$countLabel = GUICtrlCreateLabel("time: 0                       ", 0, CurrentLine())
CurrentLine()
CurrentLine()

$timerStart = TimerInit()

Func ResetTimer()
	$timerStart = TimerInit()
	$running = 1
EndFunc

GUISetState(@SW_SHOW)
; 3 <12> 5 1<12.5>4 3<12.3>4 1<12.6>5 4<12.3>6 4<12.1>4 2<12.3>2 3<12.4>6
;Ankkunf 22:33:14
;0 -> 3; 5; 4; 5; 3; 3
Func CLOSEClicked()
  Exit
EndFunc

While 1
    Sleep(10)
	If $running Then
		Local $Hour, $Mins, $Secs, $MSecs
		TicksToTime(Int(TimerDiff($timerStart)), $Hour, $Mins, $Secs, $MSecs)
		Local $time = StringFormat("%02i:%02i:%02i:%03i", $Hour, $Mins, $Secs, $MSecs)
		GUICtrlSetData($countLabel, "time: " & $time)
	EndIf
WEnd

; Func Play()
	; While 1
		; Sleep(100)
		; $time = TimerDiff($timerStart)
		; GUICtrlSetData($countLabel, "time: " & $time )
	; WEnd
; EndFunc

Func StopTimer()
	$running = 0
EndFunc

Func TicksToTime($iTicks, ByRef $iHours, ByRef $iMins, ByRef $iSecs, ByRef $iMSecs)
	If Number($iTicks) > 0 Then
		$iMSecs = Mod($iTicks, 1000)
		$iTicks = Int($iTicks / 1000)
		$iHours = Int($iTicks / 3600)
		$iTicks = Mod($iTicks, 3600)
		$iMins = Int($iTicks / 60)
		$iSecs = Mod($iTicks, 60)
		Return 1
	ElseIf Number($iTicks) = 0 Then
		$iHours = 0
		$iTicks = 0
		$iMins = 0
		$iSecs = 0
		$iMSecs = 0
		Return 1
	Else
		Return SetError(1, 0, 0)
	EndIf
EndFunc