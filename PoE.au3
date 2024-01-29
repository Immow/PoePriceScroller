;Version 1.0.0

#include <WinAPI.au3>
#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>

;~ Opt("TrayIconHide", 1) ;Prevent the AutoIt System Tray icon from appearing

If _Singleton(@ScriptName, 1) = 0 Then ;Prevent multiple instances
	MsgBox(0, "Warning", "Already running: " & @ScriptFullPath, 5)
	Exit
EndIf

$increment = 0.1

Func Sub()
	Send("{HOME}") ; simulates pressing the Home key
	Send("+{END}") ; simulates pressing the Shift+End keys
	Send("^c") ; simulates pressing the CTRL+c keys (copy)
	Local $sData = ClipGet()
	$sData = $sData -$increment
	ClipPut($sData)
	Send("^v") ; simulates pressing the CTRL+c keys
EndFunc

Func Add()
	Send("{HOME}") ; simulates pressing the Home key
	Send("+{END}") ; simulates pressing the Shift+End keys
	Send("^c") ; simulates pressing the CTRL+c keys (copy)
	Local $sData = ClipGet()
	$sData = $sData +$increment
	ClipPut($sData)
	Send("^v") ; simulates pressing the CTRL+c keys
EndFunc

;If Not IsDeclared('$WM_MOUSEWHEEL') Then Global Const $WM_MOUSEWHEEL = 0x020A  ; <----------- Commented out from original script
Global Const $tagMSLLHOOKSTRUCT = _
		$tagPOINT & _
		';uint mouseData;' & _
		'uint flags;' & _
		'uint time;' & _
		'ulong_ptr dwExtraInfo;'

Global $hFunc, $pFunc
Global $hHook, $hMod

$hFunc = DllCallbackRegister('_MouseProc', 'lresult', 'int;int;int')
$pFunc = DllCallbackGetPtr($hFunc)
$hMod = _WinAPI_GetModuleHandle(0)

$hHook = _WinAPI_SetWindowsHookEx($WH_MOUSE_LL, $pFunc, $hMod) ; $WH_MOUSE_LL - Installs a hook procedure that monitors low-level mouse input events

While 1
	Toggle()
WEnd

Func Toggle()
	If _IsPressed("10") And _IsPressed("12") And WinActive("Path of Exile") Then ;SHIFT + ALT
		ToolTip("")
		If $increment = 0.1 Then
			$increment = 1
		Else
			$increment = 0.1
		EndIf
		Local $aPos = MouseGetPos()
		ToolTip($increment, $aPos[0], $aPos[1] - 50)
		Sleep(500)
		ToolTip("")
	EndIf
	Sleep(20)
EndFunc

Func _MouseProc($iCode, $iwParam, $ilParam)
	Local $tMSLL, $iDelta
	If $iCode < 0 Then Return _WinAPI_CallNextHookEx($hHook, $iCode, $iwParam, $ilParam)
	$tMSLL = DllStructCreate($tagMSLLHOOKSTRUCT, $ilParam)
	if WinActive("Path of Exile") Then
		If $iwParam = $WM_MOUSEWHEEL Then
			$iDelta = BitShift(DllStructGetData($tMSLL, 'mouseData'), 16)
			If _IsPressed("10") And _IsPressed("11") Then
				If $iDelta < 0 Then
					Sub()
				Else
					Add()
				EndIf
			EndIf
		EndIf
	EndIf

	Return _WinAPI_CallNextHookEx($hHook, $iCode, $iwParam, $ilParam)
EndFunc