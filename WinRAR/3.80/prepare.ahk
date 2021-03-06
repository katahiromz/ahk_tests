/*
 * Designed for WinRAR 3.80
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

TestName = prepare

; Test if the app is installed
TestsTotal++
RegRead, UninstallerPath, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\WinRAR archiver, UninstallString
if ErrorLevel
    TestsFailed("Either registry key does not exist or we failed to read it.")
else
{
    SplitPath, UninstallerPath,, InstalledDir
    if (InstalledDir = "")
        TestsFailed("Either registry contains empty string or we failed to read it.")
    else
    {
        ModuleExe = %InstalledDir%\WinRAR.exe
        TestsOK("")
    }
}


; Terminate application
if bContinue
{
    SplitPath, ModuleExe, ProcessExe
    bTerminateProcess(ProcessExe)
}


; Delete settings separately from RunApplication() in case we want to write our own settings
TestsTotal++
if bContinue
{
    RegDelete, HKEY_CURRENT_USER, SOFTWARE\WinRAR
    RegDelete, HKEY_CURRENT_USER, SOFTWARE\WinRAR SFX
    IfExist, %A_AppData%\WinRAR
    {
        FileRemoveDir, %A_AppData%\WinRAR, 1
        if ErrorLevel
            TestsFailed("Unable to delete '" A_AppData "\WinRAR'.")
        else
            TestsOK("")
    }
    else
        TestsOK("")
}


; Test if can start application
RunApplication(PathToFile)
{
    global ModuleExe
    global TestName
    global bContinue
    global TestsTotal
    global ProcessExe
    global szStartingFolder

    TestsTotal++
    IfNotExist, %ModuleExe%
        TestsFailed("RunApplication(): Can NOT find '" ModuleExe "'.")
    else
    {
        if PathToFile =
        {
            SplitPath, A_WorkingDir, szStartingFolder
            Run, %ModuleExe%,, Max ; Start maximized
            ; WinRARIntegration()
            WinWaitActive, %szStartingFolder% - WinRAR (evaluation copy),,7
            if ErrorLevel
            {
                Process, Exist, %ProcessExe%
                NewPID = %ErrorLevel%  ; Save the value immediately since ErrorLevel is often changed.
                if NewPID = 0
                    TestsFailed("RunApplication(): Window '" szStartingFolder " - WinRAR (evaluation copy)' failed to appear. No '" ProcessExe "' process detected.")
                else
                    TestsFailed("RunApplication(): Window '" szStartingFolder " - WinRAR (evaluation copy)' failed to appear. '" ProcessExe "' process detected.")
            }
            else
                TestsOK("")
        }
        else
        {
            IfNotExist, %PathToFile%
                TestsFailed("RunApplication(): Can NOT find '" PathToFile "'.")
            else
            {
                Run, %ModuleExe% "%PathToFile%",, Max
                ; WinRARIntegration()
                SplitPath, PathToFile, NameExt
                WinWaitActive, %NameExt% - WinRAR (evaluation copy),,7
                if ErrorLevel
                {
                    Process, Exist, %ProcessExe%
                    NewPID = %ErrorLevel%  ; Save the value immediately since ErrorLevel is often changed.
                    if NewPID = 0
                        TestsFailed("RunApplication(): Window '%NameExt% - WinRAR (evaluation copy)' failed to appear. No '" ProcessExe "' process detected.")
                    else
                        TestsFailed("RunApplication(): Window '%NameExt% - WinRAR (evaluation copy)' failed to appear. '" ProcessExe "' process detected.")
                }
                else
                    TestsOK("")
            }
        }
    }
}


WinRARIntegration()
{
    global TestName
    global TestsTotal

    TestsTotal++
    WinWaitActive, Settings, Integration,7
    if ErrorLevel
        TestsFailed("WinRARIntegration(): Window 'Settings (Integration)' failed to appear.")
    else
    {
        ControlClick, Button27, Settings, Integration ; Hit 'OK' button
        if ErrorLevel
            TestsFailed("WinRARIntegration(): Unable to hit 'OK' button in 'Settings (Integration)' window.")
        else
            TestsOK("")
    }
}
