/*
 * Designed for Universal Viewer 5.7.2.0
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

ModuleExe = %A_WorkingDir%\Apps\UniversalViewer 5.7.2.0 Setup.exe
bContinue := false
TestName = 1.install

TestsFailed := 0
TestsOK := 0
TestsTotal := 0

; Test if Setup file exists, if so, delete installed files, and run Setup
IfExist, %ModuleExe%
{
    ; Get rid of other versions
    RegRead, UninstallerPath, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Universal Viewer Free_is1, UninstallString
    if not ErrorLevel
    {
        Process, Close, Viewer.exe ; Teminate process
        Sleep, 1500
        StringReplace, UninstallerPath, UninstallerPath, `",, All
        SplitPath, UninstallerPath,, InstallLocation
        RunWait, %UninstallerPath% /SILENT ; Silently uninstall it
        Sleep, 2500
        ; Delete everything just in case
        RegDelete, HKEY_LOCAL_MACHINE, SOFTWARE\MicroSoft\Windows\CurrentVersion\Uninstall\Universal Viewer Free_is1
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
        IfExist, %A_ProgramFiles%\Universal Viewer\unins000.exe
        {
            Process, Close, Viewer.exe ; Teminate process
            Sleep, 1500
            RunWait, %A_ProgramFiles%\Universal Viewer\unins000.exe /SILENT ; Silently uninstall it
            Sleep, 2500
            FileRemoveDir, %A_ProgramFiles%\Universal Viewer, 1
            Sleep, 1000
            IfExist, %A_ProgramFiles%\Universal Viewer
            {
                OutputDebug, %TestName%:%A_LineNumber%: Test failed: Previous version detected and failed to delete '%A_ProgramFiles%\Universal Viewer'.`n
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
        ; Delete saved settings
        FileRemoveDir, %A_AppData%\SumatraPDF, 1
        FileRemoveDir, %A_AppData%\ATViewer, 1
        FileRemoveDir, %A_AppData%\Adobe, 1
        Run %ModuleExe%
    }
}
else
{
    OutputDebug, %TestName%:%A_LineNumber%: Test failed: '%ModuleExe%' not found.`n
    bContinue := false
}


; Test if 'Select Setup Language' window appeared
TestsTotal++
if bContinue
{
    WinWaitActive, Select Setup Language, Select the language, 15
    if not ErrorLevel
    {
        Sleep, 250
        ControlClick, TNewButton1, Select Setup Language, Select the language
        if not ErrorLevel
            TestsOK("'Select Setup Language (Select the language)' window appeared and 'OK' was clicked.")
        else
            TestsFailed("Unable to hit 'OK' in 'Select Setup Language (Select the language)' window.")
    }
    else
        TestsFailed("'Select Setup Language (Select the language)' window failed to appear.")
}


; Test if 'Welcome' window appeared
TestsTotal++
if bContinue
{
    WinWaitActive, Setup - Universal Viewer Free, Welcome, 7
    if not ErrorLevel
    {
        Sleep, 250
        ControlClick, TNewButton1, Setup - Universal Viewer Free, Welcome ; Hit 'Next' button
        if not ErrorLevel
            TestsOK("'Setup - Universal Viewer Free (Welcome)' window appeared and 'Next' was clicked.")
        else
            TestsFailed("Unable to hit 'Next' button in 'Setup - Universal Viewer Free (Welcome)' window.")
    }
    else
        TestsFailed("'Setup - Universal Viewer Free (Welcome)' window failed to appear.")
}


; Test if 'Select Destination Location' window appeared
TestsTotal++
if bContinue
{
    WinWaitActive, Setup - Universal Viewer Free, Select Destination Location, 7
    if not ErrorLevel
    {
        Sleep, 250
        ControlClick, TNewButton3, Setup - Universal Viewer Free, Select Destination Location ; Hit 'Next' button
        if not ErrorLevel
            TestsOK("'Setup - Universal Viewer Free (Select Destination Location)' window appeared and 'Next' was clicked.")
        else
            TestsFailed("Unable to hit 'Next' button in 'Setup - Universal Viewer Free (Select Destination Location)' window.")
    }
    else
        TestsFailed("'Setup - Universal Viewer Free (Select Destination Location)' window failed to appear.")
}


; Test if 'Select Additional Tasks' window appeared
TestsTotal++
if bContinue
{
    WinWaitActive, Setup - Universal Viewer Free, Select Additional Tasks, 7
    if not ErrorLevel
    {
        Sleep, 250
        ControlClick, TNewButton3, Setup - Universal Viewer Free, Select Additional Tasks ; Hit 'Next' button
        if not ErrorLevel
            TestsOK("'Setup - Universal Viewer Free (Select Additional Tasks)' window appeared and 'Next' was clicked.")
        else
            TestsFailed("Unable to hit 'Next' button in 'Setup - Universal Viewer Free (Select Additional Tasks)' window.")
    }
    else
        TestsFailed("'Setup - Universal Viewer Free (Select Additional Tasks)' window failed to appear.")
}


; Test if 'Ready to Install' window appeared
TestsTotal++
if bContinue
{
    WinWaitActive, Setup - Universal Viewer Free, Ready to Install, 7
    if not ErrorLevel
    {
        Sleep, 250
        ControlClick, TNewButton3, Setup - Universal Viewer Free, Ready to Install ; Hit 'Install' button
        if not ErrorLevel
            TestsOK("'Setup - Universal Viewer Free (Ready to Install)' window appeared and 'Install' was clicked.")
        else
            TestsFailed("Unable to hit 'Install' button in 'Setup - Universal Viewer Free (Ready to Install)' window.")
    }
    else
        TestsFailed("'Setup - Universal Viewer Free (Ready to Install)' window failed to appear.")
}


; Test if can get trhu 'Installing' window
TestsTotal++
if bContinue
{
    WinWaitActive, Setup - Universal Viewer Free, Installing, 7
    if not ErrorLevel
    {
        OutputDebug, OK: %TestName%:%A_LineNumber%: 'Setup - Universal Viewer Free (Installing)' window appeared, waiting for it to close.`n
        WinWaitClose, Setup - Universal Viewer Free, Installing, 20
        if not ErrorLevel
            TestsOK("'Setup - Universal Viewer Free (Installing)' window went away.")
        else
            TestsFailed("'Setup - Universal Viewer Free (Installing)' window failed to close.")
    }
    else
        TestsFailed("'Setup - Universal Viewer Free (Installing)' window failed to appear.")
}


; Test if 'Completing' window appeared
TestsTotal++
if bContinue
{
    WinWaitActive, Setup - Universal Viewer Free, Completing, 7
    if not ErrorLevel
    {
        Sleep, 250
        SendInput, {SPACE}{DOWN}{SPACE} ; Uncheck 'Launch Universal Viewer' and 'View version history'. Control, Uncheck won't work here
        Sleep, 1000
        ControlClick, TNewButton3, Setup - Universal Viewer Free, Completing ; Hit 'Finish' button
        if not ErrorLevel
        {
            Process, wait, Viewer.exe, 5.5
            NewPID = %ErrorLevel%  ; Save the value immediately since ErrorLevel is often changed.
            if NewPID = 0
                TestsOK("'Setup - Universal Viewer Free (Completing)' window appeared, 'Launch Universal Viewer', 'View version history' were unchecked and 'Finish' was clicked.")
            else
            {
                TestsFailed("Unable to uncheck 'Launch Universal Viewer' in 'Setup - Universal Viewer Free (Completing)' window, because process 'Viewer.exe' was detected.")
                Process, Close, Viewer.exe
            }
        }
        else
            TestsFailed("Unable to hit 'Finish' button in 'Setup - Universal Viewer Free (Completing)' window.")
    }
    else
        TestsFailed("'Setup - Universal Viewer Free (Completing)' window failed to appear.")
}


; Check if program exists
TestsTotal++
if bContinue
{
    Sleep, 2000
    RegRead, UninstallString, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Universal Viewer Free_is1, UninstallString
    if not ErrorLevel
    {
        StringReplace, UninstallString, UninstallString, `",, All
        IfExist, %UninstallString%
            TestsOK("The application has been installed, because '" UninstallString "' was found.")
        else
            TestsFailed("Something went wrong, can't find '" UninstallString "'.")
    }
    else
        TestsFailed("Either we can't read from registry or data doesn't exist.")
}
