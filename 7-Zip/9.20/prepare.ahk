/*
 * Designed for 7-Zip 9.20
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

Process, Close, 7zFM.exe

RegRead, UninstallerPath, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\7-Zip, UninstallString
if ErrorLevel
{
    ModuleExe = %A_ProgramFiles%\7-Zip\7zFM.exe
    OutputDebug, %TestName%:%A_LineNumber%: Can NOT read data from registry. Key might not exist. Using hardcoded path.`n
}
else
{
    StringReplace, UninstallerPath, UninstallerPath, `",, All ; String contains quotes, replace em
    SplitPath, UninstallerPath,, InstalledDir
    ModuleExe = %InstalledDir%\7zFM.exe
}


; Test if can start application
RunApplication(PathToFile)
{
    global ModuleExe
    global TestName
    global bContinue
    global TestsTotal

    TestsTotal++
    RegDelete, HKEY_LOCAL_MACHINE, SOFTWARE\7-Zip
    RegDelete, HKEY_CURRENT_USER, SOFTWARE\7-Zip
    IfNotExist, %ModuleExe%
        TestsFailed("Can NOT find '" ModuleExe "'.")
    else
    {
        if PathToFile =
        {
            Run, %ModuleExe%,, Max ; Start maximized
            Sleep, 1000
            WinWaitActive, 7-Zip File Manager,,7
            if ErrorLevel
                TestsFailed("Window '7-Zip File Manager' failed to appear.")
            else
                TestsOK("")
        }
        else
        {
            Run, %ModuleExe% "%PathToFile%",, Max
            Sleep, 1000
            WinWaitActive, %PathToFile%\,,7
            if ErrorLevel
                TestsFailed("Window '" PathToFile "\' failed to appear.")
            else
                TestsOK("")
        }
    }
}
