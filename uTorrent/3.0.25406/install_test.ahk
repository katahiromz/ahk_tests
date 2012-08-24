/*
 * Designed for uTorrent 3.0.25406
 * Copyright (C) 2012 Edijs Kolesnikovics
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */

ModuleExe = %A_WorkingDir%\Apps\uTorrent 3.0.25406 Setup.exe
bContinue := false
TestName = 1.install

TestsFailed := 0
TestsOK := 0
TestsTotal := 0

; Test if Setup file exists, if so, delete installed files, and run Setup
IfExist, %ModuleExe%
{
    ; Get rid of other versions
    RegRead, InstalledDir, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\uTorrent, InstallLocation
    if not ErrorLevel
    {
        Process, Close, uTorrent.exe ; Teminate process
        Sleep, 1500
        StringReplace, InstalledDir, InstalledDir, `",, All
        ; Delete everything just in case
        RegDelete, HKEY_LOCAL_MACHINE, SOFTWARE\MicroSoft\Windows\CurrentVersion\Uninstall\uTorrent
        FileRemoveDir, %InstalledDir%, 1
        FileRemoveDir, %A_AppData%\uTorrent, 1
        Sleep, 1000
        IfExist, %InstalledDir%
        {
            OutputDebug, %TestName%:%A_LineNumber%: Test failed: Failed to delete '%InstalledDir%'.`n
            bContinue := false
        }
        else
        {
            bContinue := true
        }
    }
    else
    {
        ; There was a problem (such as a nonexistent key or value). 
        ; That probably means we have not installed this app before.
        ; Check in default directory to be extra sure
        IfExist, %A_ProgramFiles%\uTorrent\uTorrent.exe
        {
            Process, Close, uTorrent.exe ; Teminate process
            Sleep, 1500
            FileRemoveDir, %A_ProgramFiles%\uTorrent, 1
            FileRemoveDir, %A_AppData%\uTorrent, 1
            Sleep, 1000
            IfExist, %A_ProgramFiles%\uTorrent
            {
                OutputDebug, %TestName%:%A_LineNumber%: Test failed: Previous version detected and failed to delete '%A_ProgramFiles%\uTorrent'.`n
                bContinue := false
            }
            else
            {
                bContinue := true
            }
        }
        else
        {
            ; No previous versions detected.
            bContinue := true
        }
    }
    if bContinue
    {
        Run %ModuleExe%
    }
}
else
{
    OutputDebug, %TestName%:%A_LineNumber%: Test failed: '%ModuleExe%' not found.`n
    bContinue := false
}


; Test if '�Torrent Setup (This wizard)' window appeared, if so, hit 'Next' button
TestsTotal++
if bContinue
{
    WinWaitActive, �Torrent Setup, This wizard, 10
    if not ErrorLevel
    {
        Sleep, 700
        ControlClick, Button2, �Torrent Setup, This wizard ; Hit 'Next' button
        if not ErrorLevel
        {
            TestsOK()
            OutputDebug, OK: %TestName%:%A_LineNumber%: '�Torrent Setup (This wizard)' window appeared and 'Next' button was clicked.`n
        }
        else
        {
            TestsFailed()
            WinGetTitle, title, A
            OutputDebug, %TestName%:%A_LineNumber%: Test failed: Unable to hit 'Next' button in '�Torrent Setup (This wizard)' window. Active window caption: '%title%'.`n
        }
    }
    else
    {
        TestsFailed()
        WinGetTitle, title, A
        OutputDebug, %TestName%:%A_LineNumber%: Test failed: '�Torrent Setup (This wizard)' window failed to appear. Active window caption: '%title%'.`n
    }
}


; Test if '�Torrent Setup (Beware)' window appeared, if so, hit 'Next' button
TestsTotal++
if bContinue
{
    WinWaitActive, �Torrent Setup, Beware, 5
    if not ErrorLevel
    {
        Sleep, 700
        ControlClick, Button2, �Torrent Setup, Beware ; Hit 'Next' button
        if not ErrorLevel
        {
            TestsOK()
            OutputDebug, OK: %TestName%:%A_LineNumber%: '�Torrent Setup (Beware)' window appeared and 'Next' button was clicked.`n
        }
        else
        {
            TestsFailed()
            WinGetTitle, title, A
            OutputDebug, %TestName%:%A_LineNumber%: Test failed: Unable to hit 'Next' button in '�Torrent Setup (Beware)' window. Active window caption: '%title%'.`n
        }
    }
    else
    {
        TestsFailed()
        WinGetTitle, title, A
        OutputDebug, %TestName%:%A_LineNumber%: Test failed: '�Torrent Setup (Beware)' window failed to appear. Active window caption: '%title%'.`n
    }
}


; Test if '�Torrent Setup (Scroll)' window appeared, if so, hit 'I Agree' button
TestsTotal++
if bContinue
{
    WinWaitActive, �Torrent Setup, Scroll, 5
    if not ErrorLevel
    {
        Sleep, 700
        ControlClick, Button2, �Torrent Setup, Scroll ; Hit 'I Agree' button
        if not ErrorLevel
        {
            TestsOK()
            OutputDebug, OK: %TestName%:%A_LineNumber%: '�Torrent Setup (Scroll)' window appeared and 'I Agree' button was clicked.`n
        }
        else
        {
            TestsFailed()
            WinGetTitle, title, A
            OutputDebug, %TestName%:%A_LineNumber%: Test failed: Unable to hit 'I Agree' button in '�Torrent Setup (Scroll)' window. Active window caption: '%title%'.`n
        }
    }
    else
    {
        TestsFailed()
        WinGetTitle, title, A
        OutputDebug, %TestName%:%A_LineNumber%: Test failed: '�Torrent Setup (Scroll)' window failed to appear. Active window caption: '%title%'.`n
    }
}


; Test if '�Torrent Setup (Program Location)' window appeared, if so, hit 'Next' button
TestsTotal++
if bContinue
{
    WinWaitActive, �Torrent Setup, Program Location, 5
    if not ErrorLevel
    {
        Sleep, 700
        ControlClick, Button9, �Torrent Setup, Program Location ; Hit 'Next' button
        if not ErrorLevel
        {
            TestsOK()
            OutputDebug, OK: %TestName%:%A_LineNumber%: '�Torrent Setup (Program Location)' window appeared and 'Next' button was clicked.`n
        }
        else
        {
            TestsFailed()
            WinGetTitle, title, A
            OutputDebug, %TestName%:%A_LineNumber%: Test failed: Unable to hit 'Next' button in '�Torrent Setup (Program Location)' window. Active window caption: '%title%'.`n
        }
    }
    else
    {
        TestsFailed()
        WinGetTitle, title, A
        OutputDebug, %TestName%:%A_LineNumber%: Test failed: '�Torrent Setup (Program Location)' window failed to appear. Active window caption: '%title%'.`n
    }
}


; Test if '�Torrent Setup (The following)' window appeared, if so, hit 'Next' button
TestsTotal++
if bContinue
{
    WinWaitActive, �Torrent Setup, The following, 5
    if not ErrorLevel
    {
        Sleep, 700
        ControlClick, Button16, �Torrent Setup, The following ; Hit 'Next' button
        if not ErrorLevel
        {
            TestsOK()
            OutputDebug, OK: %TestName%:%A_LineNumber%: '�Torrent Setup (The following)' window appeared and 'Next' button was clicked.`n
        }
        else
        {
            TestsFailed()
            WinGetTitle, title, A
            OutputDebug, %TestName%:%A_LineNumber%: Test failed: Unable to hit 'Next' button in '�Torrent Setup (The following)' window. Active window caption: '%title%'.`n
        }
    }
    else
    {
        TestsFailed()
        WinGetTitle, title, A
        OutputDebug, %TestName%:%A_LineNumber%: Test failed: '�Torrent Setup (The following)' window failed to appear. Active window caption: '%title%'.`n
    }
}


; Test if '�Torrent Setup (Check out)' window appeared, if so, uncheck 'Yes, Id love to check out this free download' checkbox and hit 'Next' button
TestsTotal++
if bContinue
{
    WinWaitActive, �Torrent Setup, Check out, 5
    if not ErrorLevel
    {
        Sleep, 700
        Control, Uncheck,, Button1, �Torrent Setup, Check out ; Uncheck 'Yes, Id love to check out this free download' checkbox
        if not ErrorLevel
        {
            Sleep, 500
            ControlClick, Button17, �Torrent Setup, Check out ; Hit 'Next' button
            if not ErrorLevel
            {
                TestsOK()
                OutputDebug, OK: %TestName%:%A_LineNumber%: '�Torrent Setup (Check out)' window appeared and 'Next' button was clicked.`n
            }
            else
            {
                TestsFailed()
                WinGetTitle, title, A
                OutputDebug, %TestName%:%A_LineNumber%: Test failed: Unable to hit 'Next' button in '�Torrent Setup (Check out)' window. Active window caption: '%title%'.`n
            }
        }
        else
        {
            TestsFailed()
            WinGetTitle, title, A
            OutputDebug, %TestName%:%A_LineNumber%: Test failed: Unable to uncheck 'Yes, Id love to check out this free download' checkbox in '�Torrent Setup (Check out)' window. Active window caption: '%title%'.`n
        }
    }
    else
    {
        TestsFailed()
        WinGetTitle, title, A
        OutputDebug, %TestName%:%A_LineNumber%: Test failed: '�Torrent Setup (Check out)' window failed to appear. Active window caption: '%title%'.`n
    }
}


; Test if '�Torrent Setup (&Install)' window appeared, if so, uncheck:
; 1. 'Set my homepage to �Torrent Web Search',
; 2. 'Make �Torrent Web Search my default search provider',
; 3. 'I accept...and want to install the �Torrent Browser Bar'
; hit 'Install' button, wait for window to close then terminate uTorrent.exe process
TestsTotal++
if bContinue
{
    WinWaitActive, �Torrent Setup, &Install, 5
    if not ErrorLevel
    {
        Sleep, 700
        Control, Uncheck,, Button1, �Torrent Setup, &Install ; Uncheck 'Set my homepage to �Torrent Web Search' checkbox
        if not ErrorLevel
        {
            Control, Uncheck,, Button3, �Torrent Setup, &Install ; Uncheck 'Make �Torrent Web Search my default search provider' checkbox
            if not ErrorLevel
            {
                Control, Uncheck,, Button2, �Torrent Setup, &Install ; Uncheck 'I accept...and want to install �Torrent Browser Bar' checkbox
                if not ErrorLevel
                {
                    Sleep, 500
                    ControlClick, Button20, �Torrent Setup, &Install ; Hit 'Install' button
                    if not ErrorLevel
                    {
                        WinWaitClose, �Torrent Setup, &Install, 25
                        if not ErrorLevel
                        {
                            TestsOK()
                            OutputDebug, OK: %TestName%:%A_LineNumber%: '�Torrent Setup (Install)' window appeared and 'Install' button was clicked.`n
                            Process, Close, uTorrent.exe ; Setup wants to start the app, just terminate it
                        }
                        else
                        {
                            TestsFailed()
                            WinGetTitle, title, A
                            OutputDebug, %TestName%:%A_LineNumber%: Test failed: '�Torrent Setup (Install)' window failed to close. Active window caption: '%title%'.`n
                        }
                    }
                    else
                    {
                        TestsFailed()
                        WinGetTitle, title, A
                        OutputDebug, %TestName%:%A_LineNumber%: Test failed: Unable to hit 'Install' button in '�Torrent Setup (Install)' window. Active window caption: '%title%'.`n
                    }
                }
                else
                {
                    TestsFailed()
                    WinGetTitle, title, A
                    OutputDebug, %TestName%:%A_LineNumber%: Test failed: Unable to uncheck 'I accept...and want to install �Torrent Browser Bar' checkbox in '�Torrent Setup (Install)' window. Active window caption: '%title%'.`n
                }
            }
            else
            {
                TestsFailed()
                WinGetTitle, title, A
                OutputDebug, %TestName%:%A_LineNumber%: Test failed: Unable to uncheck 'Make �Torrent Web Search my default search provider' checkbox in '�Torrent Setup (Install)' window. Active window caption: '%title%'.`n
            }
        }
        else
        {
            TestsFailed()
            WinGetTitle, title, A
            OutputDebug, %TestName%:%A_LineNumber%: Test failed: Unable to uncheck 'Set my homepage to �Torrent Web Search' checkbox in '�Torrent Setup (Install)' window. Active window caption: '%title%'.`n
        }
    }
    else
    {
        TestsFailed()
        WinGetTitle, title, A
        OutputDebug, %TestName%:%A_LineNumber%: Test failed: '�Torrent Setup (Install)' window failed to appear. Active window caption: '%title%'.`n
    }
}


;Check if program exists in program files
TestsTotal++
if bContinue
{
    Sleep, 2000
    RegRead, InstallLocation, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\uTorrent, InstallLocation
    if not ErrorLevel
    {
        StringReplace, InstallLocation, InstallLocation, `",, All
        InstallLocation = %InstallLocation%\uTorrent.exe
        IfExist, %InstallLocation%
        {
            TestsOK()
            OutputDebug, OK: %TestName%:%A_LineNumber%: The application has been installed, because '%InstallLocation%' was found.`n
        }
        else
        {
            TestsFailed()
            OutputDebug, %TestName%:%A_LineNumber%: Test failed: Something went wrong, can't find '%InstallLocation%'.`n
        }
    }
    else
    {
        TestsFailed()
        WinGetTitle, title, A
        OutputDebug, %TestName%:%A_LineNumber%: Test failed: Either we can't read from registry or data doesn't exist. Active window caption: '%title%'.`n
    }
}
