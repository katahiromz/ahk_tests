/*
 * Designed for UniversalViewer 5.7.2.0
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

TestName = 2.GoToPage
szDocument =  %A_WorkingDir%\Media\Book.pdf ; Case sensitive!

; Test if can open PDF document, go to page 29, close document, exit Universal Viewer.
TestsTotal++
RunApplication(szDocument)
SplitPath, szDocument, NameExt
if bContinue
{
    IfWinActive, %NameExt% - Universal Viewer (slister)
    {
        Sleep, 1000
        ControlSetText, Edit1, 29, %NameExt% - Universal Viewer (slister) ; Set page number to 29
        if not ErrorLevel
        {
            ControlClick, Edit1, %NameExt% - Universal Viewer (slister) ; We have to click on it before sending keystroke
            if not ErrorLevel
            {
                SendInput, {ENTER} ; Hit enter to actually go to page
                Sleep, 2000 ; Load page properly before searching for image on the screen
                ; FIXME: test will work only on 800x600 screen resolution on themeless system
                ; Need to find a way to show PDF in actual size
                SearchImg = %A_WorkingDir%\Media\BookPage29Img800x600.jpg

                IfExist, %SearchImg%
                {
                    ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *14 %SearchImg%
                    if ErrorLevel = 2
                        TestsFailed("Could not conduct the ImageSearch ('" SearchImg "' exist).")
                    else if ErrorLevel = 1
                        TestsFailed("The search image '" SearchImg "' could NOT be found on the screen (resolution not 800x600?).")
                    else
                    {
                        SendInput, {Alt}f ; Close document. WinMenuSelectItem doesn't work here. Don't use '!f' either, because it fails on Windows
                        Sleep, 500
                        SendInput, c
                        WinWaitActive, Universal Viewer, File not loaded, 5
                        if not ErrorLevel
                        {
                            Sleep, 2000
                            WinClose, Universal Viewer, File not loaded
                            WinWaitClose, Universal Viewer, File not loaded, 7
                            if not ErrorLevel
                                TestsOK("Found image on the screen, so, page 29 was displayed correctly. Document and application closed successfully.")
                            else
                                TestsFailed("Window 'Universal Viewer (File not loaded)' failed to close.")
                        }
                        else
                            TestsFailed("Window 'Universal Viewer (File not loaded)' failed to appear.")
                    }
                }
                else
                    TestsFailed("Can NOT find '" SearchImg "'.")
            }
            else
                TestsFailed("Unable to click 'Page' number in '" NameExt " - Universal Viewer (slister)' window.")
        }
        else
            TestsFailed("Unable to enter 'Page' number in '" NameExt " - Universal Viewer (slister)' window.")
    }
    else
        TestsFailed("Window '" NameExt " - Universal Viewer (slister)' failed to appear.")
}
else
    TestsFailed("We failed somewhere in prepare.ahk.")

if not bContinue
{
    ; If we failed, terminate SumatraPDF.exe
    Process, Close, SumatraPDF.exe
}
