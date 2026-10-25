"""FL-55b: stdcall argument counts (in dwords) of the Win32 functions that GAME.EXE imports, from their documented signatures, for the import calls the lifter translates
(scripts/lift_fl41.py merges them into IMPORT_ARGS). wsprintfA is cdecl: the caller pops its arguments, so the callee pops none. The binkw32 imports carry their byte count in
the name (`_BinkOpen@8`)."""

EXTRA_IMPORT_ARGS = {
    # ADVAPI32
    'RegCloseKey': 1, 'RegCreateKeyExA': 9, 'RegDeleteKeyA': 2, 'RegDeleteValueA': 2, 'RegOpenKeyExA': 5, 'RegQueryValueExA': 6, 'RegSetValueExA': 6,
    # COMCTL32 / DDRAW / DSOUND (ordinals #17 InitCommonControls, #1 DirectSoundCreate, #2 DirectSoundEnumerateA)
    '#17': 0, 'CreatePropertySheetPageA': 1, 'DestroyPropertySheetPage': 1, 'PropertySheetA': 1,
    'DirectDrawCreateEx': 4, 'DirectDrawEnumerateExA': 3, '#1': 3, '#2': 2,
    # GDI32
    'CreateBitmap': 5, 'CreateSolidBrush': 1, 'DeleteDC': 1, 'DeleteObject': 1, 'Escape': 5, 'ExtTextOutA': 8, 'GetClipBox': 2, 'GetDeviceCaps': 2, 'GetObjectA': 3,
    'GetStockObject': 1, 'OffsetViewportOrgEx': 4, 'PtVisible': 3, 'RectVisible': 2, 'RestoreDC': 2, 'SaveDC': 1, 'ScaleViewportExtEx': 6, 'ScaleWindowExtEx': 6,
    'SelectObject': 2, 'SetBkColor': 2, 'SetMapMode': 2, 'SetTextColor': 2, 'SetViewportExtEx': 4, 'SetViewportOrgEx': 4, 'SetWindowExtEx': 4, 'TextOutA': 5,
    # KERNEL32
    'CompareStringA': 6, 'CompareStringW': 6, 'CreateEventA': 4, 'CreateFileMappingA': 6, 'CreateThread': 6, 'DeleteCriticalSection': 1, 'EnterCriticalSection': 1,
    'ExitProcess': 1, 'ExitThread': 1, 'FileTimeToSystemTime': 2, 'FindClose': 1, 'FindFirstFileA': 2, 'FindNextFileA': 2, 'FindResourceA': 3, 'FlushFileBuffers': 1,
    'FreeEnvironmentStringsA': 1, 'FreeEnvironmentStringsW': 1, 'FreeLibrary': 1, 'GetACP': 0, 'GetCPInfo': 2, 'GetCommandLineA': 0, 'GetCurrentDirectoryA': 2,
    'GetCurrentProcess': 0, 'GetCurrentThread': 0, 'GetEnvironmentStrings': 0, 'GetEnvironmentStringsW': 0, 'GetExitCodeThread': 2, 'GetFileType': 1,
    'GetFullPathNameA': 4, 'GetLocalTime': 1, 'GetModuleHandleA': 1, 'GetOEMCP': 0, 'GetProcAddress': 2, 'GetProcessVersion': 1, 'GetStartupInfoA': 1, 'GetStdHandle': 1,
    'GetStringTypeA': 5, 'GetStringTypeExA': 5, 'GetStringTypeW': 4, 'GetThreadLocale': 0, 'GetTimeZoneInformation': 1, 'GetVersion': 0, 'GetVolumeInformationA': 8,
    'GlobalAddAtomA': 1, 'GlobalAlloc': 2, 'GlobalDeleteAtom': 1, 'GlobalFindAtomA': 1, 'GlobalFlags': 1, 'GlobalFree': 1, 'GlobalGetAtomNameA': 3, 'GlobalHandle': 1,
    'GlobalLock': 1, 'GlobalReAlloc': 3, 'GlobalUnlock': 1, 'HeapAlloc': 3, 'HeapCreate': 3, 'HeapDestroy': 1, 'HeapFree': 3, 'HeapReAlloc': 4, 'HeapSize': 3,
    'InitializeCriticalSection': 1, 'InterlockedDecrement': 1, 'InterlockedIncrement': 1, 'IsBadCodePtr': 1, 'IsBadReadPtr': 2, 'IsBadWritePtr': 2, 'LCMapStringA': 6,
    'LCMapStringW': 6, 'LeaveCriticalSection': 1, 'LoadLibraryA': 1, 'LoadResource': 2, 'LocalAlloc': 2, 'LocalFree': 1, 'LocalReAlloc': 3, 'LockResource': 1,
    'MapViewOfFile': 5, 'MulDiv': 3, 'MultiByteToWideChar': 6, 'RaiseException': 4, 'ReadFile': 5, 'ResumeThread': 1, 'RtlUnwind': 4, 'SetEndOfFile': 1,
    'SetEnvironmentVariableA': 2, 'SetErrorMode': 1, 'SetEvent': 1, 'SetFilePointer': 4, 'SetHandleCount': 1, 'SetLastError': 1, 'SetStdHandle': 2,
    'SetUnhandledExceptionFilter': 1, 'TerminateProcess': 2, 'TlsAlloc': 0, 'TlsFree': 1, 'TlsGetValue': 1, 'TlsSetValue': 2, 'UnhandledExceptionFilter': 1,
    'UnmapViewOfFile': 1, 'VirtualAlloc': 4, 'VirtualFree': 3, 'WaitForMultipleObjects': 4, 'WaitForSingleObject': 2, 'WideCharToMultiByte': 8, 'WriteFile': 5,
    'lstrcatA': 2, 'lstrcmpA': 2, 'lstrcmpiA': 2, 'lstrcpyA': 2, 'lstrcpynA': 3, 'lstrlenA': 1,
    # SHELL32 / VERSION / WINSPOOL / comdlg32
    'DragFinish': 1, 'DragQueryFileA': 4, 'GetFileVersionInfoA': 4, 'GetFileVersionInfoSizeA': 2, 'VerQueryValueA': 4, 'ClosePrinter': 1, 'DocumentPropertiesA': 6,
    'OpenPrinterA': 3, 'CommDlgExtendedError': 0, 'GetFileTitleA': 3, 'PrintDlgA': 1,
    # USER32
    'AdjustWindowRectEx': 4, 'BeginDeferWindowPos': 1, 'BringWindowToTop': 1, 'CallNextHookEx': 4, 'CallWindowProcA': 5, 'CharUpperA': 1, 'CheckMenuItem': 3,
    'ClientToScreen': 2, 'ClipCursor': 1, 'CreateDialogIndirectParamA': 5, 'CreateWindowExA': 12, 'DefWindowProcA': 4, 'DeferWindowPos': 8, 'DeleteMenu': 3,
    'DestroyMenu': 1, 'DestroyWindow': 1, 'DispatchMessageA': 1, 'DrawTextA': 5, 'EnableMenuItem': 3, 'EndDeferWindowPos': 1, 'EndDialog': 2, 'FindWindowA': 2,
    'GetActiveWindow': 0, 'GetCapture': 0, 'GetClassInfoA': 3, 'GetClassLongA': 2, 'GetClassNameA': 3, 'GetClientRect': 2, 'GetCursorPos': 1, 'GetDC': 1,
    'GetDesktopWindow': 0, 'GetDlgCtrlID': 1, 'GetDlgItem': 2, 'GetFocus': 0, 'GetForegroundWindow': 0, 'GetLastActivePopup': 1, 'GetMenu': 1,
    'GetMenuCheckMarkDimensions': 0, 'GetMenuItemCount': 1, 'GetMenuItemID': 2, 'GetMenuState': 3, 'GetMenuStringA': 5, 'GetMessageA': 4, 'GetMessagePos': 0,
    'GetMessageTime': 0, 'GetNextDlgTabItem': 3, 'GetParent': 1, 'GetPropA': 2, 'GetSubMenu': 2, 'GetSysColor': 1, 'GetSysColorBrush': 1, 'GetSystemMetrics': 1,
    'GetTopWindow': 1, 'GetWindow': 2, 'GetWindowLongA': 2, 'GetWindowPlacement': 2, 'GetWindowRect': 2, 'GetWindowTextA': 3, 'GrayStringA': 9, 'InsertMenuA': 5,
    'InvalidateRect': 3, 'IsDialogMessageA': 2, 'IsIconic': 1, 'IsRectEmpty': 1, 'IsWindow': 1, 'IsWindowEnabled': 1, 'IsWindowVisible': 1, 'LoadAcceleratorsA': 2,
    'LoadBitmapA': 2, 'LoadCursorA': 2, 'LoadIconA': 2, 'LoadMenuA': 2, 'LoadStringA': 4, 'MapDialogRect': 2, 'MapWindowPoints': 4, 'MessageBeep': 1, 'MessageBoxA': 4,
    'ModifyMenuA': 5, 'PostMessageA': 4, 'PostQuitMessage': 1, 'PtInRect': 3, 'RegisterClassA': 1, 'RegisterWindowMessageA': 1, 'ReleaseCapture': 0, 'ReleaseDC': 2,
    'RemovePropA': 2, 'ReuseDDElParam': 5, 'ScreenToClient': 2, 'SendDlgItemMessageA': 5, 'SetActiveWindow': 1, 'SetClassLongA': 3, 'SetCursor': 1, 'SetCursorPos': 2,
    'SetDlgItemTextA': 3, 'SetFocus': 1, 'SetForegroundWindow': 1, 'SetMenu': 2, 'SetMenuItemBitmaps': 5, 'SetPropA': 3, 'SetRectEmpty': 1, 'SetWindowLongA': 3,
    'SetWindowPos': 7, 'SetWindowTextA': 2, 'SetWindowsHookExA': 4, 'ShowOwnedPopups': 2, 'ShowWindow': 2, 'TabbedTextOutA': 8, 'TranslateAcceleratorA': 3,
    'TranslateMessage': 1, 'UnhookWindowsHookEx': 1, 'UnpackDDElParam': 4, 'UnregisterClassA': 2, 'UpdateWindow': 1, 'ValidateRect': 2, 'WinHelpA': 4, 'wsprintfA': 0,
}


def import_args(name):
    """dwords the callee pops for the import `name` (None when unknown); a decorated name `_f@N` states N bytes"""
    import re
    m = re.search(r'@(\d+)$', name)
    if m:
        return int(m.group(1)) // 4
    return EXTRA_IMPORT_ARGS.get(name)
