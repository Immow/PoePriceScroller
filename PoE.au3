#include <GUIConstantsEx.au3>

HotKeySet("{NUMPADSUB}", "Example")

While 1
		;~ Switch GUIGetMsg()
		;~ 		Case $GUI_EVENT_CLOSE
		;~ 				ExitLoop
		;~ EndSwitch
WEnd

Func Example()
	Local $aPos = MouseGetPos()
	ToolTip("50", $aPos[0], $aPos[1])
	;~ GUICreate("My GUI") ; will create a dialog box that when displayed is centered
	;~ GUICtrlCreateLabel("1000", 10, 30, 50) ; first cell 70 width
	;~ GUISetState(@SW_SHOW) ; will display an empty dialog box

	; Loop until the user exits.

	;~ $iOldOpt = Opt("GUICoordMode", $iOldOpt)
EndFunc   ;==>Example