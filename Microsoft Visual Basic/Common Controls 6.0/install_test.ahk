/*
 * Designed for Microsoft Visual Basic 6.0 Common Controls
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

ModuleExe = %A_WorkingDir%\Apps\Microsoft Visual Basic 6.0 Common Controls Setup.exe
TestName = 1.install
MainAppFile = advpack.dll

; Test if Setup file exists, if so run Setup
TestsTotal++
IfNotExist, %ModuleExe%
    TestsFailed("'" ModuleExe "' not found.")
else
{
    szAppFile = %A_WinDir%\System32\%MainAppFile% ; Clean Win2k3 SP2 already comes with the file
    IfExist, %szAppFile%
        bExist := true
    else
        bExist := false

    TestsOK("")
    Run %ModuleExe%
}


; Test if 'VB6.0 Common Controls (Are you sure)' window appeared
TestsTotal++
if bContinue
{
    WinWaitActive, VB6.0 Common Controls, Are you sure, 5
    if ErrorLevel
        TestsFailed("'VB6.0 Common Controls (Are you sure)' window failed to appear.")
    else
    {
        ControlClick, Button1, VB6.0 Common Controls, Are you sure ; Hit 'Yes' button
        if ErrorLevel
            TestsFailed("Unable to hit 'Yes' button in 'VB6.0 Common Controls (Are you sure)' window.")
        else
        {
            WinWaitClose, VB6.0 Common Controls, Are you sure, 3
            if ErrorLevel
                TestsFailed("'VB6.0 Common Controls (Are you sure)' window failed to close despite 'Yes' button being clicked.")
            else
                TestsOK("'VB6.0 Common Controls (Are you sure)' window appeared, 'Yes' button clicked and window closed.")
        }
    }
}


; Test if 'VB6.0 Common Controls (Please read)' window appeared
TestsTotal++
if bContinue
{
    WinWaitActive, VB6.0 Common Controls, Please read, 5
    if ErrorLevel
        TestsFailed("'VB6.0 Common Controls (Please read)' window failed to appear.")
    else
    {
        ControlClick, Button1, VB6.0 Common Controls, Please read ; Hit 'Yes' button
        if ErrorLevel
            TestsFailed("Unable to hit 'Yes' button in 'VB6.0 Common Controls (Please read)' window.")
        else
        {
            WinWaitClose, VB6.0 Common Controls, Please read, 3
            if ErrorLevel
                TestsFailed("'VB6.0 Common Controls (Please read)' window failed to close despite 'Yes' button being clicked.")
            else
                TestsOK("'VB6.0 Common Controls (Please read)' window appeared, 'Yes' button clicked and window closed.")
        }
    }
}


; Test if 'VB6.0 Common Controls (The VB6.0 Common Controls were successfully)' window appeared
TestsTotal++
if bContinue
{
    WinWaitActive, VB6.0 Common Controls, The VB6.0 Common Controls were successfully, 7
    if ErrorLevel
        TestsFailed("'VB6.0 Common Controls (The VB6.0 Common Controls were successfully)' window failed to appear.")
    else
    {
        ControlClick, Button1, VB6.0 Common Controls, The VB6.0 Common Controls were successfully ; Hit 'OK' button
        if ErrorLevel
            TestsFailed("Unable to hit 'OK' button in 'VB6.0 Common Controls (The VB6.0 Common Controls were successfully)' window.")
        else
        {
            WinWaitClose, VB6.0 Common Controls, The VB6.0 Common Controls were successfully, 3
            if ErrorLevel
                TestsFailed("'VB6.0 Common Controls (The VB6.0 Common Controls were successfully)' window failed to close despite 'OK' button being clicked.")
            else
                TestsOK("'VB6.0 Common Controls (The VB6.0 Common Controls were successfully)' window appeared, 'OK' button clicked and window closed.")
        }
    }
}


; Check if file exists
TestsTotal++
if bContinue
{
    If bExist
    {
        IfNotExist, %szAppFile%
            TestsFailed("Something went wrong, can't find '" szAppFile "', but it was there before.")
        else
            TestsOK("The application has been installed, because '" szAppFile "' was found (it was there before too).")
    }
    else
    {
        IfNotExist, %szAppFile%
            TestsFailed("Something went wrong, can't find '" szAppFile "' and it was NOT there before.")
        else
            TestsOK("The application has been installed, because '" szAppFile "' was found (it was NOT there before).")
    }
}
