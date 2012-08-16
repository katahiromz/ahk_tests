/*
 * Designed for VLC 0.8.6i Setup
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

ModuleExe = %A_WorkingDir%\Apps\VLC 0.8.6i Setup.exe
bContinue := false
TestName = 1.install

TestsFailed := 0
TestsOK := 0
TestsTotal := 0

; Test if Setup file exists, if so, delete installed files, and run Setup
IfExist, %ModuleExe%
{
    ; Get rid of other versions
    RegRead, UninstallerPath, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\VLC media player, UninstallString
    if not ErrorLevel
    {
        Process, Close, vlc.exe ; Teminate process
        Sleep, 1500
        RegDelete, HKEY_LOCAL_MACHINE, SOFTWARE\VideoLAN
        StringReplace, UninstallerPath, UninstallerPath, `",, All
        SplitPath, UninstallerPath,, InstallLocation
        RunWait, %UninstallerPath% /S ; Silently uninstall it
        Sleep, 2500
        ; Delete everything just in case
        RegDelete, HKEY_LOCAL_MACHINE, SOFTWARE\MicroSoft\Windows\CurrentVersion\Uninstall\VLC media player
        FileRemoveDir, %InstallLocation%, 1
        Sleep, 1000
        IfExist, %InstallLocation%
        {
            OutputDebug, %TestName%:%A_LineNumber%: Test failed: Failed to delete '%InstallLocation%'.`n
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
        IfExist, %A_ProgramFiles%\VideoLAN\VLC\uninstall.exe
        {
            Process, Close, vlc.exe ; Teminate process
            Sleep, 1500
            RegDelete, HKEY_LOCAL_MACHINE, SOFTWARE\VideoLAN
            RunWait, %A_ProgramFiles%\VideoLAN\VLC\uninstall.exe /S ; Silently uninstall it
            Sleep, 2500
            FileRemoveDir, %A_ProgramFiles%\VideoLAN, 1
            Sleep, 1000
            IfExist, %A_ProgramFiles%\VideoLAN
            {
                OutputDebug, %TestName%:%A_LineNumber%: Test failed: Previous version detected and failed to delete '%A_ProgramFiles%\VideoLAN'.`n
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
        FileRemoveDir, %A_AppData%\vlc, 1
        Run %ModuleExe%
    }
}
else
{
    OutputDebug, %TestName%:%A_LineNumber%: Test failed: '%ModuleExe%' not found.`n
    bContinue := false
}


; Test if 'Installer Language' window appeared
TestsTotal++
if bContinue
{
    WinWaitActive, Installer Language, Please select, 15
    if not ErrorLevel
    {
        Sleep, 250
        ControlClick, Button1, Installer Language, Please select
        if not ErrorLevel
        {
            TestsOK++
            OutputDebug, OK: %TestName%:%A_LineNumber%: 'Installer Language (Please select)' window appeared and 'OK' was clicked.`n
            bContinue := true
        }
        else
        {
            TestsFailed++
            WinGetTitle, title, A
            OutputDebug, %TestName%:%A_LineNumber%: Test failed: Unable to hit 'OK' in 'Installer Language (Please select)' window. Active window caption: '%title%'.`n
            bContinue := false
        }
    }
    else
    {
        TestsFailed++
        WinGetTitle, title, A
        OutputDebug, %TestName%:%A_LineNumber%: Test failed: 'Installer Language (Please select)' window failed to appear. Active window caption: '%title%'.`n
        bContinue := false
    }
}


; Test if 'Welcome' window appeared
TestsTotal++
if bContinue
{
    WinWaitActive, VideoLAN VLC media player 0.8.6i Setup, Welcome, 7
    if not ErrorLevel
    {
        Sleep, 250
        ControlClick, Button2, VideoLAN VLC media player 0.8.6i Setup, Welcome ; Hit 'Next' button
        if not ErrorLevel
        {
            TestsOK()
            OutputDebug, OK: %TestName%:%A_LineNumber%: 'VideoLAN VLC media player 0.8.6i Setup (Welcome)' window appeared and 'Next' was clicked.`n
        }
        else
        {
            TestsFailed()
            WinGetTitle, title, A
            OutputDebug, %TestName%:%A_LineNumber%: Test failed: Unable to hit 'Next' button in 'VideoLAN VLC media player 0.8.6i Setup (Welcome)' window. Active window caption: '%title%'.`n
        }
    }
    else
    {
        TestsFailed()
        WinGetTitle, title, A
        OutputDebug, %TestName%:%A_LineNumber%: Test failed: 'VideoLAN VLC media player 0.8.6i Setup (Welcome)' window failed to appear. Active window caption: '%title%'.`n
    }
}


; Test if 'License Agreement' window appeared
TestsTotal++
if bContinue
{
    WinWaitActive, VideoLAN VLC media player 0.8.6i Setup, License Agreement, 7
    if not ErrorLevel
    {
        Sleep, 500
        ControlClick, Button2, VideoLAN VLC media player 0.8.6i Setup, License Agreement ; Hit 'I Agree' button
        if not ErrorLevel
        {
            TestsOK()
            OutputDebug, OK: %TestName%:%A_LineNumber%: 'VideoLAN VLC media player 0.8.6i Setup (License Agreement)' window appeared and 'I Agree' was clicked.`n
        }
        else
        {
            TestsFailed()
            WinGetTitle, title, A
            OutputDebug, %TestName%:%A_LineNumber%: Test failed: Unable to hit 'I Agree' button in 'VideoLAN VLC media player 0.8.6i Setup (License Agreement)' window. Active window caption: '%title%'.`n
        }
    }
    else
    {
        TestsFailed()
        WinGetTitle, title, A
        OutputDebug, %TestName%:%A_LineNumber%: Test failed: 'VideoLAN VLC media player 0.8.6i Setup (License Agreement)' window failed to appear. Active window caption: '%title%'.`n
    }
}


; Test if 'Choose Components' window appeared
TestsTotal++
if bContinue
{
    WinWaitActive, VideoLAN VLC media player 0.8.6i Setup, Choose Components, 7
    if not ErrorLevel
    {
        Sleep, 250
        ControlClick, Button2, VideoLAN VLC media player 0.8.6i Setup, Choose Components ; Hit 'Next' button
        if not ErrorLevel
        {
            TestsOK()
            OutputDebug, OK: %TestName%:%A_LineNumber%: 'VideoLAN VLC media player 0.8.6i Setup (Choose Components)' window appeared and 'Next' was clicked.`n
        }
        else
        {
            TestsFailed()
            WinGetTitle, title, A
            OutputDebug, %TestName%:%A_LineNumber%: Test failed: Unable to hit 'Next' button in 'VideoLAN VLC media player 0.8.6i Setup (Choose Components)' window. Active window caption: '%title%'.`n
        }
    }
    else
    {
        TestsFailed()
        WinGetTitle, title, A
        OutputDebug, %TestName%:%A_LineNumber%: Test failed: 'VideoLAN VLC media player 0.8.6i Setup (Choose Components)' window failed to appear. Active window caption: '%title%'.`n
    }
}


; Test if 'Choose Install Location' window appeared
TestsTotal++
if bContinue
{
    WinWaitActive, VideoLAN VLC media player 0.8.6i Setup, Choose Install Location, 7
    if not ErrorLevel
    {
        Sleep, 250
        ControlClick, Button2, VideoLAN VLC media player 0.8.6i Setup, Choose Install Location ; Hit 'Install' button
        if not ErrorLevel
        {
            TestsOK()
            OutputDebug, OK: %TestName%:%A_LineNumber%: 'VideoLAN VLC media player 0.8.6i Setup (Choose Install Location)' window appeared and 'Install' was clicked.`n
        }
        else
        {
            TestsFailed()
            WinGetTitle, title, A
            OutputDebug, %TestName%:%A_LineNumber%: Test failed: Unable to hit 'Install' button in 'VideoLAN VLC media player 0.8.6i Setup (Choose Install Location)' window. Active window caption: '%title%'.`n
        }
    }
    else
    {
        TestsFailed()
        WinGetTitle, title, A
        OutputDebug, %TestName%:%A_LineNumber%: Test failed: 'VideoLAN VLC media player 0.8.6i Setup (Choose Install Location)' window failed to appear. Active window caption: '%title%'.`n
    }
}


; Test if can get trhu 'Installing' window
TestsTotal++
if bContinue
{
    WinWaitActive, VideoLAN VLC media player 0.8.6i Setup, Installing, 7
    if not ErrorLevel
    {
        OutputDebug, OK: %TestName%:%A_LineNumber%: 'VideoLAN VLC media player 0.8.6i Setup (Installing)' window appeared, waiting for it to close.`n
        WinWaitClose, VideoLAN VLC media player 0.8.6i Setup, Installing, 60
        if not ErrorLevel
        {
            TestsOK()
            OutputDebug, OK: %TestName%:%A_LineNumber%: 'VideoLAN VLC media player 0.8.6i Setup (Installing)' window went away.`n
        }
        else
        {
            TestsFailed()
            WinGetTitle, title, A
            OutputDebug, %TestName%:%A_LineNumber%: Test failed: 'VideoLAN VLC media player 0.8.6i Setup (Installing)' window failed to close. Active window caption: '%title%'.`n
        }
    }
    else
    {
        TestsFailed()
        WinGetTitle, title, A
        OutputDebug, %TestName%:%A_LineNumber%: Test failed: 'VideoLAN VLC media player 0.8.6i Setup (Installing)' window failed to appear. Active window caption: '%title%'.`n
    }
}


; Test if 'Completing' window appeared
TestsTotal++
if bContinue
{
    WinWaitActive, VideoLAN VLC media player 0.8.6i Setup, Completing, 7
    if not ErrorLevel
    {
        Sleep, 250
        Control, Uncheck,,Button4, VideoLAN VLC media player 0.8.6i Setup
        if not ErrorLevel
        {
            ControlClick, Button2, VideoLAN VLC media player 0.8.6i Setup, Completing ; Hit 'Finish' button
            if not ErrorLevel
            {
                TestsOK()
                OutputDebug, OK: %TestName%:%A_LineNumber%: 'VideoLAN VLC media player 0.8.6i Setup (Completing)' window appeared, 'Run VLC' were unchecked and 'Finish' was clicked.`n
                Process, Close, vlc.exe ; Just in case
            }
            else
            {
                TestsFailed()
                WinGetTitle, title, A
                OutputDebug, %TestName%:%A_LineNumber%: Test failed: Unable to hit 'Finish' button in 'VideoLAN VLC media player 0.8.6i Setup (Completing)' window. Active window caption: '%title%'.`n
            }
        }
        else
        {
            TestsFailed()
            WinGetTitle, title, A
            OutputDebug, %TestName%:%A_LineNumber%: Test failed: Unable to uncheck 'Run VLC' checkbox in 'VideoLAN VLC media player 0.8.6i Setup (Completing)' window. Active window caption: '%title%'.`n
        }
    }
    else
    {
        TestsFailed()
        WinGetTitle, title, A
        OutputDebug, %TestName%:%A_LineNumber%: Test failed: 'VideoLAN VLC media player 0.8.6i Setup (Completing)' window failed to appear. Active window caption: '%title%'.`n
    }
}


;Check if program exists in program files
TestsTotal++
if bContinue
{
    Sleep, 2000
    RegRead, UninstallString, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\VLC media player, UninstallString
    if not ErrorLevel
    {
        StringReplace, UninstallString, UninstallString, `",, All
        IfExist, %UninstallString%
        {
            TestsOK()
            OutputDebug, OK: %TestName%:%A_LineNumber%: The application has been installed, because '%UninstallString%' was found.`n
        }
        else
        {
            TestsFailed()
            OutputDebug, %TestName%:%A_LineNumber%: Test failed: Something went wrong, can't find '%UninstallString%'.`n
        }
    }
    else
    {
        TestsFailed()
        WinGetTitle, title, A
        OutputDebug, %TestName%:%A_LineNumber%: Test failed: Either we can't read from registry or data doesn't exist. Active window caption: '%title%'.`n
    }
}
