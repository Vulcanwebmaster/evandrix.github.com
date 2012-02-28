; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "Metasploit Framework"
!define PRODUCT_VERSION "3.3-RC2"
!define PRODUCT_PUBLISHER "Rapid7 LLC"
!define PRODUCT_WEB_SITE "http://www.metasploit.com/framework/support/"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_STARTMENU_REGVAL "NSIS:StartMenuDir"


VIProductVersion "3.3.0.2"
VIAddVersionKey /LANG=1033 "ProductName" "Metasploit Framework"
VIAddVersionKey /LANG=1033 "Comments" "This is the official installer for Metasploit 3"
VIAddVersionKey /LANG=1033 "CompanyName" "Rapid7 LLC"
VIAddVersionKey /LANG=1033 "LegalTrademarks" "Metasploit is a registered trademark of Rapid7 LLC"
VIAddVersionKey /LANG=1033 "LegalCopyright" " Copyright (C) 2003-2009 Rapid7 LLC"
VIAddVersionKey /LANG=1033 "FileDescription" "Metasploit 3 Windows Installer"
VIAddVersionKey /LANG=1033 "FileVersion" "3.3.0.2"

SetCompressor /SOLID lzma

Function LaunchMetasploit
    Exec '"$INSTDIR\msfconsole.bat"'
FunctionEnd


!include "MUI2.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "metasploit.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "Launch the Metasploit Framework"
!define MUI_FINISHPAGE_RUN_FUNCTION "LaunchMetasploit"

; Welcome page
!insertmacro MUI_PAGE_WELCOME

; License page
!insertmacro MUI_PAGE_LICENSE "msf3\README"

; Directory page
!insertmacro MUI_PAGE_DIRECTORY

; Start menu page
var ICONS_GROUP
!define MUI_STARTMENUPAGE_NODISABLE
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "Metasploit 3"
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "${PRODUCT_STARTMENU_REGVAL}"
!insertmacro MUI_PAGE_STARTMENU Application $ICONS_GROUP

; Instfiles page
!insertmacro MUI_PAGE_INSTFILES

; Finish page
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------



RequestExecutionLevel "admin"

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "framework-3.3.exe"
InstallDir "$PROGRAMFILES\Metasploit\Framework3"
ShowInstDetails show
ShowUnInstDetails show

Section "MainSection" SecCore
        SetOutPath $INSTDIR
       File /r "C:\metasploit-33\*.*"
SectionEnd

Section "Nmap" SecNmap
	MessageBox MB_YESNO \
		"Would you like to install the Nmap Security Scanner v5.00? Nmap is a free and open source \
		utility for network exploration and security auditing. The Metasploit \
		Framework is able to work with Nmap to provide exploit automation features. \
		Nmap is copyright (C) 1996-2009 Insecure.Com LLC. Nmap is a registered \
		trademark of Insecure.Com LLC. Nmap is included in this installer with \
		the permission of the Nmap Project. Nmap is provided under the GNU Public License, \
		not the BSD license which covers most of the Metasploit Framework" /SD IDYES IDNO endNmap

	ExecWait '"$INSTDIR\tmp\nmap-5.00-setup.exe"'
	endNmap:
	Delete "$INSTDIR\tmp\nmap-5.00-setup.exe"
SectionEnd

Section "Registry" SecReg
	Exec 'regedt32 /S "$INSTDIR\tmp\nmap_performance.reg"'
	Delete "$INSTDIR\tmp\nmap_performance.reg"
SectionEnd


Section -AdditionalIcons
  SetShellVarContext all
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateDirectory "$SMPROGRAMS\$ICONS_GROUP"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Metasploit Console.lnk" "$INSTDIR\msfconsole.bat" '' "$INSTDIR\metasploit.ico" 0
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Metasploit Web.lnk" "$INSTDIR\msfweb.bat" '' "$INSTDIR\metasploit.ico" 0
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Metasploit Update.lnk" "$INSTDIR\msfupdate.bat" '' "$INSTDIR\metasploit.ico" 0
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Cygwin Shell.lnk" "$INSTDIR\shell.bat" ''
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\NASM Shell.lnk" "$INSTDIR\nasm.bat" ''
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\RUBY Shell.lnk" "$INSTDIR\msfirb.bat" '' "$INSTDIR\ruby.ico" 0
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Uninstall.lnk" "$INSTDIR\uninst.exe"

  CreateDirectory "$SMPROGRAMS\$ICONS_GROUP\Support"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Support\Metasploit Online.lnk" "$INSTDIR\${PRODUCT_NAME}.url"

  CreateDirectory "$SMPROGRAMS\$ICONS_GROUP\Tools"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Tools\VNCViewer.lnk" "$INSTDIR\bin\vncviewer.exe"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Tools\WinVI.lnk" "$INSTDIR\bin\winvi32.exe"

  CreateShortCut "$DESKTOP\Metasploit Console.lnk" "$INSTDIR\msfconsole.bat" '' "$INSTDIR\metasploit.ico" 0
  CreateShortCut "$DESKTOP\Metasploit Update.lnk" "$INSTDIR\msfupdate.bat" '' "$INSTDIR\metasploit.ico" 0

SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "${PRODUCT_STARTMENU_REGVAL}" "$ICONS_GROUP"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

Function un.onUninstSuccess
  ;HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  SetShellVarContext all
  ReadRegStr $ICONS_GROUP ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "${PRODUCT_STARTMENU_REGVAL}"

  RMDir /r "$INSTDIR"
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"

  RMDir /r "$SMPROGRAMS\$ICONS_GROUP"
  Delete "$DESKTOP\Metasploit Console.lnk"
  Delete "$DESKTOP\Metasploit Update.lnk"
  System::Call 'Shell32::SHChangeNotify(i 0x8000000, i 0, i 0, i 0)'
  SetAutoClose true
SectionEnd

