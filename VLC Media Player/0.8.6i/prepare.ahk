/*
 * Designed for VLC 0.8.6i
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
RegRead, UninstallerPath, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\VLC media player, UninstallString
if ErrorLevel
    TestsFailed("Either registry key does not exist or we failed to read it.")
else
{
    SplitPath, UninstallerPath,, InstalledDir
    if (InstalledDir = "")
        TestsFailed("Either registry contains empty string or we failed to read it.")
    else
    {
        ModuleExe = %InstalledDir%\vlc.exe
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
    IfExist, %A_AppData%\vlc
    {
        FileRemoveDir, %A_AppData%\vlc, 1
        if ErrorLevel
            TestsFailed("Unable to delete '" A_AppData "\vlc'.")
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
    
    TestsTotal++
    IfNotExist, %ModuleExe%
        TestsFailed("RunApplication(): Can NOT find '" ModuleExe "'.")
    else
    {
        if PathToFile =
        {
            Run, %ModuleExe% ; Don't run it maximized
            WinWaitActive, VLC media player,,9
            if ErrorLevel
            {
                Process, Exist, %ProcessExe%
                NewPID = %ErrorLevel%  ; Save the value immediately since ErrorLevel is often changed.
                if NewPID = 0
                    TestsFailed("RunApplication(): Window 'VLC media player' failed to appear. No '" ProcessExe "' process detected.")
                else
                    TestsFailed("RunApplication(): Window 'VLC media player' failed to appear. '" ProcessExe "' process detected.")
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
                Run, %ModuleExe% "%PathToFile%" ; Don't run it maximized
                WinWaitActive, VLC media player,,9 ; FIXME: is there a way to show filename in titlebar?
                if ErrorLevel
                {
                    Process, Exist, %ProcessExe%
                    NewPID = %ErrorLevel%  ; Save the value immediately since ErrorLevel is often changed.
                    if NewPID = 0
                        TestsFailed("RunApplication(): Window 'VLC media player' failed to appear when opening '" PathToFile "'. No '" ProcessExe "' process detected.")
                    else
                        TestsFailed("RunApplication(): Window 'VLC media player' failed to appear when opening '" PathToFile "'. '" ProcessExe "' process detected.")
                }
                else
                    TestsOK("")
            }
        }
    }
}
