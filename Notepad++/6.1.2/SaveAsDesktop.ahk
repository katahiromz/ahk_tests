/*
 * Designed for Notepad++ 6.1.2
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

; Type some text and test if 'Save As' dialog can appear
TestsTotal++
TestName = 2.SaveAsDesktop
szDocument =  ; Case sensitive! [No file to open]

RunNotepad(szDocument)
if not bContinue
    TestsFailed("We failed somewhere in prepare.ahk.")
else
{
    IfWinNotActive, new  1 - Notepad++
        TestsFailed("Window 'new  1 - Notepad++' is not active.")
    else
    {
        SendInput, Line 1{ENTER}Line two with @{ENTER}Line 3 with question mark?{ENTER}{ENTER}This is line 5. Line 4 was empty.
        Sleep, 1500
        IfWinNotActive, *new  1 - Notepad++
            TestsFailed("The '*new  1 - Notepad++' window is not active anymore.")
        else
        {
            SendInput, {CTRLDOWN}s{CTRLUP}
            Sleep, 1500 ; It can appear and fail, so sleep
            WinWaitActive, Save As,, 15
            if ErrorLevel
                TestsFailed("'Save As' dialog failed to appear.")
            else
            {
                OutputDebug, OK: %TestName%:%A_LineNumber%: 'Save As' dialog appeared.`n
                bContinue := true
            }
        }
    }   


    ; Test if we can save file to desktop
    if bContinue
    {
        IfWinNotActive, Save As
            TestsFailed("For some reason 'Save As' dialog is not active anymore.")
        else
        {
            ControlSend, Edit1, %A_Desktop%\new  1.txt, Save As ; Give full path to 'File Name'
            if ErrorLevel
                TestsFailed("Unable to enter '" A_Desktop "\new  1.txt' in 'File name' field in 'Save As' window.")
            else
            {
                Sleep, 3500
                FileDelete, %A_Desktop%\new  1.txt ; Delete file before saving
                Sleep, 1500
                SendInput, !s ; Hit 'Save' in 'Save As' dialog
                Sleep, 1500 ; Let file to appear
                szDocumentPath = %A_Desktop%\new  1.txt
                IfNotExist, %szDocumentPath%
                    TestsFailed("File '" szDocumentPath "' does not exist, but it should.")
                else
                {
                    OutputDebug, OK: %TestName%:%A_LineNumber%: '%szDocumentPath%' exist as it should.`n
                    bContinue := true
                }
            }
        }
    }


    ; Test if we can close program
    if bContinue
    {
        bContinue := false
        WinClose, %szDocumentPath% - Notepad++
        WinWaitClose, %szDocumentPath% - Notepad++,,10
        if ErrorLevel
            TestsFailed("Failed to close '" szDocumentPath " - Notepad++' window.")
        else
            TestsOK("Window '" szDocumentPath " - Notepad++' was closed successfully.")
    }
}