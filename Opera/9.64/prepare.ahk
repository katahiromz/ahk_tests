/*
 * Designed for Opera v9.64
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
RegRead, InstallLocation, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{E1BBBAC5-2857-4155-82A6-54492CE88620}, InstallLocation
if ErrorLevel
    TestsFailed("Either registry key does not exist or we failed to read it.")
else
{
    if (InstallLocation = "")
        TestsFailed("Either registry contains empty string or we failed to read it.")
    else
    {
        ModuleExe = %InstallLocation%Opera.exe ; InstallLocation already contains backslash
        TestsOK("")
    }
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


; Terminate application
if bContinue
{
    SplitPath, ModuleExe, ProcessExe
    bTerminateProcess(ProcessExe)
}


; Delete settings separately
TestsTotal++
if bContinue
{
    IfExist, %A_AppData%\Opera
    {
        FileRemoveDir, %A_AppData%\Opera, 1
        if ErrorLevel
            TestsFailed("Unable to delete '" A_AppData "\Opera'.")
        else
            TestsOK("")
    }
    else
        TestsOK("")
}

TestsTotal++
if bContinue
{
    RegRead, A_LocData, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders, Local AppData
    if ErrorLevel
        TestsFailed("Unable to read registry: HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders, Local AppData")
    else
    {
        IfExist, %A_LocData%\Opera
        {
            FileRemoveDir, %A_LocData%\Opera, 1
            if ErrorLevel
                TestsFailed("Unable to delete '" A_LocData "\Opera'.")
            else
                TestsOK("")
        }
        else
            TestsOK("")
    }
}


; Tests if can write settings
TestsTotal++
if bContinue
{
    FileCreateDir, %A_AppData%\Opera\Opera\profile\sessions
    if ErrorLevel
        TestsFailed("Unable to create dir tree '" A_AppData "\Opera\Opera\profile\sessions'.")
    else
    {
        IfNotExist, %A_WorkingDir%\Media\opera6.ini
            TestsFailed("Can NOT find '" A_WorkingDir "\Media\opera6.ini'.")
        else
        {
            FileCopy, %A_WorkingDir%\Media\opera6.ini, %A_AppData%\Opera\Opera\profile\opera6.ini
            if ErrorLevel
                TestsFailed("Can NOT copy existing '" A_WorkingDir "\Media\opera6.ini' to '" A_AppData "\Opera\Opera\profile\opera6.ini'")
            else
            {
                IfNotExist, %A_WorkingDir%\Media\autosave.win
                    TestsFailed("Can NOT find '" A_WorkingDir "\Media\autosave.win'.")
                else
                {
                    FileCopy, %A_WorkingDir%\Media\autosave.win, %A_AppData%\Opera\Opera\profile\sessions\autosave.win
                    if ErrorLevel
                        TestsFailed("Can NOT copy existing '" A_WorkingDir "\Media\autosave.win' to '" A_AppData "\Opera\Opera\profile\sessions\autosave.win'")
                    else
                    {
                        IfNotExist, %A_WorkingDir%\Media\optrust.dat
                            TestsFailed("Can NOT find '" A_WorkingDir "\Media\optrust.dat'.")
                        else
                        {
                            FileCopy, %A_WorkingDir%\Media\optrust.dat, %A_AppData%\Opera\Opera\profile\optrust.dat
                            if ErrorLevel
                                TestsFailed("Can NOT copy existing '" A_WorkingDir "\Media\optrust.dat' to '" A_AppData "\Opera\Opera\profile\optrust.dat'")
                            else
                                TestsOK("")
                        }
                    }
                }
            }
        }
    }
}


; Test if can start application
RunApplication(PathToFile, AppWndCaption)
{
    global ModuleExe
    global TestName
    global TestsTotal
    global bContinue
    global ProcessExe

    TestsTotal++
    if bContinue
    {
        IfNotExist, %ModuleExe%
            TestsFailed("RunApplication(): Can NOT find '" ModuleExe "'.")
        else
        {
            ; AppWndCaption is ignored here
            if PathToFile =
            {
                Run, %ModuleExe%,, Max ; Setup/install registers Opera as default browser
                WinWaitActive, Speed Dial - Opera,,7
                if ErrorLevel
                {
                    Process, Exist, %ProcessExe%
                    NewPID = %ErrorLevel%  ; Save the value immediately since ErrorLevel is often changed.
                    if NewPID = 0
                        TestsFailed("RunApplication(): Window 'Speed Dial - Opera' failed to appear. No '" ProcessExe "' process detected.")
                    else
                        TestsFailed("RunApplication(): Window 'Speed Dial - Opera' failed to appear. '" ProcessExe "' process detected.")
                }
                else
                    TestsOK("")
            }
            else
            {
                IfNotExist, %PathToFile%
                    TestsInfo("RunApplication(): Can NOT find '" PathToFile "'.") ; Just in case we are using local file
                Run, %ModuleExe% "%PathToFile%",, Max ; Setup/install registers Opera as default browser
                WinWaitActive, %AppWndCaption%,,7
                if ErrorLevel
                {
                    Process, Exist, %ProcessExe%
                    NewPID = %ErrorLevel%  ; Save the value immediately since ErrorLevel is often changed.
                    if NewPID = 0
                        TestsFailed("RunApplication(): Window '" AppWndCaption "' failed to appear. No '" ProcessExe "' process detected.")
                    else
                        TestsFailed("RunApplication(): Window '" AppWndCaption "' failed to appear. '" ProcessExe "' process detected.")
                }
                else
                    TestsOK("")
            }
        }
    }
}
