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

TestName = prepare

; Test if the app is installed
TestsTotal++
RegRead, UninstallerPath, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\The Off By One Web Browser, UninstallString
if ErrorLevel
    TestsFailed("Either registry key does not exist or we failed to read it.")
else
{
    UninstallerPath := ExeFilePathNoParam(UninstallerPath)
    SplitPath, UninstallerPath,, InstalledDir
    if (InstalledDir = "")
        TestsFailed("Either registry contains empty string or we failed to read it.")
    else
    {
        ModuleExe = %InstalledDir%\ob1.exe
        TestsOK("")
    }
}


; Terminate application
if bContinue
{
    SplitPath, ModuleExe, ProcessExe
    bTerminateProcess(ProcessExe)
}


; Test if connected to the Internet
TestsTotal++
if bContinue
{
    if not bIsConnectedToInternet()
        TestsFailed("No internet connection detected.")
    else
        TestsOK("Internet connection detected.")
}


; Delete settings
TestsTotal++
if bContinue
{
    szSettingsFile = %A_WinDir%\ob1.ini
    IfExist, %szSettingsFile%
    {
        FileDelete, %szSettingsFile%
        if ErrorLevel
            TestsFailed("Unable to delete '" szSettingsFile "'.")
        else
            TestsOK("'" szSettingsFile "' has been deleted successfuly.")
    }
    else
        TestsOK("'" szSettingsFile "' is not found.")
}


; Test if can start application
RunApplication(PathToFile)
{
    global ModuleExe
    global TestName
    global TestsTotal
    global bContinue
    global ProcessExe
    global szSettingsFile

    TestsTotal++
    if bContinue
    {
        IfNotExist, %ModuleExe%
            TestsFailed("RunApplication(): Can NOT find '" ModuleExe "'.")
        else
        {
            FileAppend, [Properties]`nStartPage=, %szSettingsFile% ; Write settings (open blank page on start)
            if ErrorLevel
                TestsFailed("RunApplication(): Unable to create '" szSettingsFile "'.")
            else
            {
                Run, %ModuleExe%,, Max ; Start maximized
                WinWaitActive, The OffByOne Browser,,7
                if ErrorLevel
                {
                    Process, Exist, %ProcessExe%
                    NewPID = %ErrorLevel%  ; Save the value immediately since ErrorLevel is often changed.
                    if NewPID = 0
                        TestsFailed("RunApplication(): Window 'The OffByOne Browser' failed to appear. No '" ProcessExe "' process detected.")
                    else
                        TestsFailed("RunApplication(): Window 'The OffByOne Browser' failed to appear. '" ProcessExe "' process detected.")
                }
                else
                    TestsOK("")
            }
        }
    }
}
