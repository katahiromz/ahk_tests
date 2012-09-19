/*
 * Designed for Off By One Browser 3.5.d
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

ModuleExe = %A_WorkingDir%\Apps\Off By One Browser 3.5.d Setup.exe
TestName = 1.install
MainAppFile = ob1.exe ; Mostly this is going to be process we need to look for

; Test if Setup file exists, if so, delete installed files, and run Setup
TestsTotal++
IfNotExist, %ModuleExe%
    TestsFailed("'" ModuleExe "' not found.")
else
{
    Process, Close, %MainAppFile% ; Teminate process
    Process, WaitClose, %MainAppFile%, 4
    if ErrorLevel ; The PID still exists.
        TestsFailed("Unable to terminate '" MainAppFile "' process.") ; So, process still exists
    else
    {
        RegRead, UninstallerPath, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\The Off By One Web Browser, UninstallString
        if ErrorLevel
        {
            ; There was a problem (such as a nonexistent key or value). 
            ; That probably means we have not installed this app before.
            ; Check in default directory to be extra sure
            bHardcoded := true ; To know if we got path from registry or not
            IfNotExist, %A_ProgramFiles%\HPSW\OffByOne
                bContinue := true ; No previous versions detected in hardcoded path
            else
            {
                IfExist, %A_ProgramFiles%\HPSW\OffByOne\UNWISE.exe
                {
                    szShortPath = %A_ProgramFiles%\HPSW\OffByOne\INSTALL.LOG
                    IfExist, %szShortPath%
                    {
                        Loop, %szShortPath% ; Make 8.3 path
                            szShortPath = %A_LoopFileShortPath%
                        RunWait, %A_ProgramFiles%\HPSW\OffByOne\UNWISE.exe /S %szShortPath% ; Silently uninstall it (uninstaller wants 8.3)
                        Sleep, 7000
                    }
                }

                IfNotExist, %A_ProgramFiles%\HPSW\OffByOne ; Uninstaller might delete the dir
                    bContinue := true
                {
                    FileRemoveDir, %A_ProgramFiles%\HPSW\OffByOne, 1
                    if ErrorLevel
                        TestsFailed("Unable to delete hardcoded path '" A_ProgramFiles "\HPSW\OffByOne' ('" MainAppFile "' process is reported as terminated).'")
                    else
                        bContinue := true
                }
            }
        }
        else
        {
            UninstallerPath := ExeFilePathNoParam(UninstallerPath)
            SplitPath, UninstallerPath,, InstalledDir
            IfNotExist, %InstalledDir%
                bContinue := true
            else
            {
                IfExist, %UninstallerPath%
                {
                    szShortPath = %InstalledDir%\INSTALL.LOG
                    IfExist, %szShortPath%
                    {
                        Loop, %szShortPath% ; Make 8.3 path
                            szShortPath = %A_LoopFileShortPath%
                        RunWait, %UninstallerPath% /S %szShortPath% ; Silently uninstall it
                        Sleep, 7000
                    }
                }

                IfNotExist, %InstalledDir%
                    bContinue := true
                else
                {
                    Msgbox, delete: %InstalledDir%
                    FileRemoveDir, %InstalledDir%, 1 ; Delete just in case
                    if ErrorLevel
                        TestsFailed("Unable to delete existing '" InstalledDir "' ('" MainAppFile "' process is reported as terminated).")
                    else
                        bContinue := true
                }
            }
        }
    }

    if bContinue
    {
        RegDelete, HKEY_LOCAL_MACHINE, SOFTWARE\MicroSoft\Windows\CurrentVersion\Uninstall\The Off By One Web Browser
        IfExist, %A_WinDir%\OB1.INI
        {
            FileDelete, %A_WinDir%\OB1.INI
            if ErrorLevel
                TestsFailed("Unable to delete '" A_WinDir "\OB1.INI'.")
        }

        if bContinue
        {
            if bHardcoded
                TestsOK("Either there was no previous versions or we succeeded removing it using hardcoded path.")
            else
                TestsOK("Either there was no previous versions or we succeeded removing it using data from registry.")
            Run %ModuleExe%
        }
    }
}


; Test if 'Welcome (Welcome to)' window appeared
TestsTotal++
if bContinue
{
    WinWaitActive, Welcome, Welcome to, 15
    if ErrorLevel
        TestsFailed("'Welcome (Welcome to)' window failed to appear.")
    else
    {
        Sleep, 700
        ControlClick, Button1, Welcome, Welcome to ; Hit 'Next' button
        if ErrorLevel
            TestsFailed("Unable to hit 'Next' button in 'Welcome (Welcome to)' window.")
        else
        {
            WinWaitClose, Welcome, Welcome to, 7
            if ErrorLevel
                TestsFailed("'Welcome (Welcome to)' window failed to close despite 'Next' button being clicked.")
            else
                TestsOK("'Welcome (Welcome to)' window appeared and 'Next' button was clicked.")
        }
    }
}


; Test if 'Choose Destination Location (Destination Folder)' window appeared
TestsTotal++
if bContinue
{
    WinWaitActive, Choose Destination Location, Destination Folder, 7
    if ErrorLevel
        TestsFailed("'Choose Destination Location (Destination Folder)' window failed to appear.")
    else
    {
        Sleep, 700
        ControlClick, Button1, Choose Destination Location, Destination Folder ; Hit 'Next' button
        if ErrorLevel
            TestsFailed("Unable to hit 'Next' button in 'Choose Destination Location (Destination Folder)' window.")
        else
            TestsOK("'Choose Destination Location (Destination Folder)' window appeared and 'Next' button was clicked.")
    }
}


; Test if 'Select Program Manager Group (Enter the name)' window appeared
TestsTotal++
if bContinue
{
    WinWaitActive, Select Program Manager Group, Enter the name, 7
    if ErrorLevel
        TestsFailed("'Select Program Manager Group (Enter the name)' window failed to appear.")
    else
    {
        Sleep, 700
        ControlClick, Button1, Select Program Manager Group, Enter the name ; Hit 'Next' button
        if ErrorLevel
            TestsFailed("Unable to hit 'Next' button in 'Select Program Manager Group (Enter the name)' window.")
        else
            TestsOK("'Select Program Manager Group (Enter the name)' window appeared and 'Next' button was clicked.")
    }
}


; Test if 'Start Installation (You are)' window appeared
TestsTotal++
if bContinue
{
    WinWaitActive, Start Installation, You are, 7
    if ErrorLevel
        TestsFailed("'Start Installation (You are)' window failed to appear.")
    else
    {
        Sleep, 700
        ControlClick, Button1, Start Installation, You are ; Hit 'Next' button
        if ErrorLevel
            TestsFailed("Unable to hit 'Next' button in 'Start Installation (You are)' window.")
        else
            TestsOK("'Start Installation (You are)' window appeared and 'Next' button was clicked.")
    }
}


; Test if can get trhu 'Installing' window
TestsTotal++
if bContinue
{
    WinWaitActive, Installing,, 7
    if ErrorLevel
        TestsFailed("'Installing' window failed to appear.")
    else
    {
        OutputDebug, %TestName%:%A_LineNumber%: 'Installing' window appeared, waiting for it to close.`n
        WinWaitClose, Installing,,20
        if ErrorLevel
            TestsFailed("'Installing' window failed to close.")
        else
        {
            SetTitleMatchMode, 2 ; A window's title can contain WinTitle anywhere inside it to be a match.
            ; Installer will open explorer window, close it
            WinWait, Home Page Software ahk_class CabinetWClass,, 22
            if ErrorLevel
                TestsFailed("Explorer window 'Home Page Software' (SetTitleMatchMode=2) failed to appear.")
            else
            {
                WinClose, Home Page Software ahk_class CabinetWClass
                WinWaitClose, Home Page Software ahk_class CabinetWClass,, 5
                if ErrorLevel
                    TestsFailed("Unable to close explorer window 'Home Page Software' (SetTitleMatchMode=2).")
                else
                    TestsOK("'Installing' window closed, 'Home Page Software' window appeared and we closed it.")
            }
        }
    }
}


; Test if 'Installation Complete (The Off)' window appeared
TestsTotal++
if bContinue
{
    SetTitleMatchMode, 3 ; A window's title must exactly match WinTitle to be a match.
    WinWait, Installation Complete, The Off, 7
    if ErrorLevel
        TestsFailed("'Installation Complete (The Off)' window failed to appear.")
    else
    {
        WinActivate, Installation Complete, The Off
        Sleep, 700
        ControlClick, Button1, Installation Complete, The Off ; Hit 'Finish' button
        if ErrorLevel
            TestsFailed("Unable to hit 'Finish' button in 'Installation Complete (The Off)' window.")
        else
        {
            WinWaitClose, Installation Complete, The Off, 5
            if ErrorLevel
                TestsFailed("'Installation Complete (The Off)' window failed to close despite 'Finish' button being clicked.")
            else
                TestsOK("'Installation Complete (The Off)' window appeared and 'Finish' button was clicked.")
        }
    }
}


; Check if program exists
TestsTotal++
if bContinue
{
    InstalledDir = %A_ProgramFiles%\HPSW\OffByOne ; Hardcode path since registry contains more information than just path to uninstaller
    IfNotExist, %InstalledDir%\%MainAppFile%
        TestsFailed("Something went wrong, can't find '" InstalledDir "\" MainAppFile "'.")
    else
        TestsOK("The application has been installed, because '" InstalledDir "\" MainAppFile "' was found.")
}
