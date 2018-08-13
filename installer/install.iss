; Uncomment the line below to be able to compile the script from within the IDE.
;#define COMPILE_FROM_IDE

#include "config.iss"

#if !defined(APP_VERSION) || !defined(BITNESS)
#error "config.iss should define APP_VERSION and BITNESS"
#endif

#define APP_NAME      'Git'
#ifdef COMPILE_FROM_IDE
#undef APP_VERSION
#define APP_VERSION   'Snapshot'
#endif
#define MINGW_BITNESS 'mingw'+BITNESS
#define APP_CONTACT_URL 'https://github.com/git-for-windows/git/wiki/Contact'
#define APP_URL       'https://gitforwindows.org/'
#define APP_BUILTINS  'share\git\builtins.txt'

#define PLINK_PATH_ERROR_MSG 'Please enter a valid path to a Plink executable.'

#define DROP_HANDLER_GUID '{{60254CA5-953B-11CF-8C96-00AA00B8708C}'

[Setup]
; Compiler-related
Compression=lzma2/ultra64
LZMAUseSeparateProcess=yes
#ifdef OUTPUT_TO_TEMP
OutputBaseFilename={#FILENAME_VERSION}
OutputDir={#GetEnv('TEMP')}
#else
OutputBaseFilename={#APP_NAME+'-'+FILENAME_VERSION}-{#BITNESS}-bit
#ifdef OUTPUT_DIRECTORY
OutputDir={#OUTPUT_DIRECTORY}
#else
OutputDir={#GetEnv('USERPROFILE')}
#endif
#endif
SolidCompression=yes
#ifdef SOURCE_DIR
SourceDir={#SOURCE_DIR}
#else
SourceDir={#SourcePath}\..\..\..\..
#endif
#if BITNESS=='64'
ArchitecturesInstallIn64BitMode=x64
#endif
#ifdef SIGNTOOL
SignTool=signtool
#endif

; Installer-related
AllowNoIcons=yes
AppName={#APP_NAME}
AppPublisher=The Git Development Community
AppPublisherURL={#APP_URL}
AppSupportURL={#APP_CONTACT_URL}
AppVersion={#APP_VERSION}
ChangesAssociations=yes
ChangesEnvironment=yes
CloseApplications=no
DefaultDirName={pf}\{#APP_NAME}
DisableDirPage=auto
DefaultGroupName={#APP_NAME}
DisableProgramGroupPage=auto
DisableReadyPage=yes
InfoBeforeFile={#SourcePath}\..\gpl-2.0.rtf
#ifdef OUTPUT_TO_TEMP
PrivilegesRequired=lowest
#else
PrivilegesRequired=none
#endif
UninstallDisplayIcon={app}\{#MINGW_BITNESS}\share\git\git-for-windows.ico
#ifndef COMPILE_FROM_IDE
#if Pos('-',APP_VERSION)>0
VersionInfoVersion={#Copy(APP_VERSION,1,Pos('-',APP_VERSION)-1)}
#else
VersionInfoVersion={#APP_VERSION}
#endif
#endif

; Cosmetic
SetupIconFile={#SourcePath}\..\git.ico
WizardImageBackColor=clWhite
WizardImageStretch=no
WizardImageFile={#SourcePath}\git.bmp
WizardSmallImageFile={#SourcePath}\gitsmall.bmp
MinVersion=0,5.01sp3

[Types]
; Define a custom type to avoid getting the three default types.
Name: default; Description: Default installation; Flags: iscustom

[Components]
Name: icons; Description: Additional icons
Name: icons\quicklaunch; Description: In the Quick Launch; Check: not IsAdminLoggedOn
Name: icons\desktop; Description: On the Desktop
Name: ext; Description: Windows Explorer integration; Types: default
Name: ext\shellhere; Description: Git Bash Here; Types: default
Name: ext\guihere; Description: Git GUI Here; Types: default
Name: gitlfs; Description: Git LFS (Large File Support); Types: default; Flags: disablenouninstallwarning
Name: assoc; Description: Associate .git* configuration files with the default text editor; Types: default
Name: assoc_sh; Description: Associate .sh files to be run with Bash; Types: default
Name: consolefont; Description: Use a TrueType font in all console windows
Name: autoupdate; Description: Check daily for Git for Windows updates

[Run]
Filename: {app}\git-bash.exe; Parameters: --cd-to-home; Description: Launch Git Bash; Flags: nowait postinstall skipifsilent runasoriginaluser unchecked
Filename: {app}\ReleaseNotes.html; Description: View Release Notes; Flags: shellexec skipifdoesntexist postinstall skipifsilent

[Files]
; Install files that might be in use during setup under a different name.
#include "file-list.iss"
#include "pcp_files.iss"
Source: {#SourcePath}\path.bat; DestDir: {app}; Flags: replacesameversion; AfterInstall: DeleteFromVirtualStore
Source: {#SourcePath}\ReleaseNotes.html; DestDir: {app}; Flags: replacesameversion; AfterInstall: DeleteFromVirtualStore
Source: {#SourcePath}\..\LICENSE.txt; DestDir: {app}; Flags: replacesameversion; AfterInstall: DeleteFromVirtualStore
Source: {#SourcePath}\NOTICE.txt; DestDir: {app}; Flags: replacesameversion; AfterInstall: DeleteFromVirtualStore;
Source: {#SourcePath}\..\edit-git-bash.exe; Flags: dontcopy

[Dirs]
Name: "{app}\tmp"

[Messages]
BeveledLabel={#APP_URL}
#ifdef WINDOW_TITLE_VERSION
SetupAppTitle={#APP_NAME} {#WINDOW_TITLE_VERSION} Setup
SetupWindowTitle={#APP_NAME} {#WINDOW_TITLE_VERSION} Setup
#else
SetupAppTitle={#APP_NAME} {#APP_VERSION} Setup
SetupWindowTitle={#APP_NAME} {#APP_VERSION} Setup
#endif

[Registry]
; PCP Specific
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; ValueType: expandsz; ValueName: "Path"; ValueData: "{olddata};{app}\mingw64\lib"
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; ValueType: expandsz; ValueName: "Path"; ValueData: "{olddata};{app}\mingw64\bin"
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; ValueType: string; ValueName: "PCP_DIR"; ValueData: "{app}\mingw64"
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "pmcd"; ValueData: "{app}\mingw64\libexec\pcp\bin\pmcd.exe"

; Aides installing third-party (credential, remote, etc) helpers
Root: HKLM; Subkey: Software\GitForWindows; ValueType: string; ValueName: CurrentVersion; ValueData: {#APP_VERSION}; Flags: uninsdeletevalue uninsdeletekeyifempty; Check: IsAdminLoggedOn
Root: HKLM; Subkey: Software\GitForWindows; ValueType: string; ValueName: InstallPath; ValueData: {app}; Flags: uninsdeletevalue uninsdeletekeyifempty; Check: IsAdminLoggedOn
Root: HKLM; Subkey: Software\GitForWindows; ValueType: string; ValueName: LibexecPath; ValueData: {app}\{#MINGW_BITNESS}\libexec\git-core; Flags: uninsdeletevalue uninsdeletekeyifempty; Check: IsAdminLoggedOn
Root: HKCU; Subkey: Software\GitForWindows; ValueType: string; ValueName: CurrentVersion; ValueData: {#APP_VERSION}; Flags: uninsdeletevalue uninsdeletekeyifempty; Check: not IsAdminLoggedOn
Root: HKCU; Subkey: Software\GitForWindows; ValueType: string; ValueName: InstallPath; ValueData: {app}; Flags: uninsdeletevalue uninsdeletekeyifempty; Check: not IsAdminLoggedOn
Root: HKCU; Subkey: Software\GitForWindows; ValueType: string; ValueName: LibexecPath; ValueData: {app}\{#MINGW_BITNESS}\libexec\git-core; Flags: uninsdeletevalue uninsdeletekeyifempty; Check: not IsAdminLoggedOn

; There is no "Console" key in HKLM.
Root: HKCU; Subkey: Console; ValueType: string; ValueName: FaceName; ValueData: Lucida Console; Flags: uninsclearvalue; Components: consolefont
Root: HKCU; Subkey: Console; ValueType: dword; ValueName: FontFamily; ValueData: $00000036; Components: consolefont
Root: HKCU; Subkey: Console; ValueType: dword; ValueName: FontSize; ValueData: $000e0000; Components: consolefont
Root: HKCU; Subkey: Console; ValueType: dword; ValueName: FontWeight; ValueData: $00000190; Components: consolefont

Root: HKCU; Subkey: Console\Git Bash; ValueType: string; ValueName: FaceName; ValueData: Lucida Console; Flags: createvalueifdoesntexist uninsdeletevalue uninsdeletekeyifempty
Root: HKCU; Subkey: Console\Git Bash; ValueType: dword; ValueName: FontFamily; ValueData: $00000036; Flags: createvalueifdoesntexist uninsdeletevalue uninsdeletekeyifempty
Root: HKCU; Subkey: Console\Git Bash; ValueType: dword; ValueName: FontSize; ValueData: $000e0000; Flags: createvalueifdoesntexist uninsdeletevalue uninsdeletekeyifempty
Root: HKCU; Subkey: Console\Git Bash; ValueType: dword; ValueName: FontWeight; ValueData: $00000190; Flags: createvalueifdoesntexist uninsdeletevalue uninsdeletekeyifempty

Root: HKCU; Subkey: Console\Git CMD; ValueType: string; ValueName: FaceName; ValueData: Lucida Console; Flags: createvalueifdoesntexist uninsdeletevalue uninsdeletekeyifempty
Root: HKCU; Subkey: Console\Git CMD; ValueType: dword; ValueName: FontFamily; ValueData: $00000036; Flags: createvalueifdoesntexist uninsdeletevalue uninsdeletekeyifempty
Root: HKCU; Subkey: Console\Git CMD; ValueType: dword; ValueName: FontSize; ValueData: $000e0000; Flags: createvalueifdoesntexist uninsdeletevalue uninsdeletekeyifempty
Root: HKCU; Subkey: Console\Git CMD; ValueType: dword; ValueName: FontWeight; ValueData: $00000190; Flags: createvalueifdoesntexist uninsdeletevalue uninsdeletekeyifempty

; Note that we write the Registry values below either to HKLM or to HKCU depending on whether the user running the installer
; is a member of the local Administrators group or not (see the "Check" argument).

; File associations for configuration files that may be contained in a repository (so this does not include ".gitconfig").
Root: HKLM; Subkey: Software\Classes\.gitattributes; ValueType: string; ValueData: txtfile; Flags: createvalueifdoesntexist uninsdeletevalue uninsdeletekeyifempty; Check: IsAdminLoggedOn; Components: assoc
Root: HKLM; Subkey: Software\Classes\.gitattributes; ValueType: string; ValueName: Content Type; ValueData: text/plain; Flags: createvalueifdoesntexist uninsdeletevalue uninsdeletekeyifempty; Check: IsAdminLoggedOn; Components: assoc
Root: HKLM; Subkey: Software\Classes\.gitattributes; ValueType: string; ValueName: PerceivedType; ValueData: text; Flags: createvalueifdoesntexist uninsdeletevalue uninsdeletekeyifempty; Check: IsAdminLoggedOn; Components: assoc
Root: HKCU; Subkey: Software\Classes\.gitattributes; ValueType: string; ValueData: txtfile; Flags: createvalueifdoesntexist uninsdeletevalue uninsdeletekeyifempty; Check: not IsAdminLoggedOn; Components: assoc
Root: HKCU; Subkey: Software\Classes\.gitattributes; ValueType: string; ValueName: Content Type; ValueData: text/plain; Flags: createvalueifdoesntexist uninsdeletevalue uninsdeletekeyifempty; Check: not IsAdminLoggedOn; Components: assoc
Root: HKCU; Subkey: Software\Classes\.gitattributes; ValueType: string; ValueName: PerceivedType; ValueData: text; Flags: createvalueifdoesntexist uninsdeletevalue uninsdeletekeyifempty; Check: not IsAdminLoggedOn; Components: assoc

Root: HKLM; Subkey: Software\Classes\.gitignore; ValueType: string; ValueData: txtfile; Flags: createvalueifdoesntexist uninsdeletevalue uninsdeletekeyifempty; Check: IsAdminLoggedOn; Components: assoc
Root: HKLM; Subkey: Software\Classes\.gitignore; ValueType: string; ValueName: Content Type; ValueData: text/plain; Flags: createvalueifdoesntexist uninsdeletevalue uninsdeletekeyifempty; Check: IsAdminLoggedOn; Components: assoc
Root: HKLM; Subkey: Software\Classes\.gitignore; ValueType: string; ValueName: PerceivedType; ValueData: text; Flags: createvalueifdoesntexist uninsdeletevalue uninsdeletekeyifempty; Check: IsAdminLoggedOn; Components: assoc
Root: HKCU; Subkey: Software\Classes\.gitignore; ValueType: string; ValueData: txtfile; Flags: createvalueifdoesntexist uninsdeletevalue uninsdeletekeyifempty; Check: not IsAdminLoggedOn; Components: assoc
Root: HKCU; Subkey: Software\Classes\.gitignore; ValueType: string; ValueName: Content Type; ValueData: text/plain; Flags: createvalueifdoesntexist uninsdeletevalue uninsdeletekeyifempty; Check: not IsAdminLoggedOn; Components: assoc
Root: HKCU; Subkey: Software\Classes\.gitignore; ValueType: string; ValueName: PerceivedType; ValueData: text; Flags: createvalueifdoesntexist uninsdeletevalue uninsdeletekeyifempty; Check: not IsAdminLoggedOn; Components: assoc

Root: HKLM; Subkey: Software\Classes\.gitmodules; ValueType: string; ValueData: txtfile; Flags: createvalueifdoesntexist uninsdeletevalue uninsdeletekeyifempty; Check: IsAdminLoggedOn; Components: assoc
Root: HKLM; Subkey: Software\Classes\.gitmodules; ValueType: string; ValueName: Content Type; ValueData: text/plain; Flags: createvalueifdoesntexist uninsdeletevalue uninsdeletekeyifempty; Check: IsAdminLoggedOn; Components: assoc
Root: HKLM; Subkey: Software\Classes\.gitmodules; ValueType: string; ValueName: PerceivedType; ValueData: text; Flags: createvalueifdoesntexist uninsdeletevalue uninsdeletekeyifempty; Check: IsAdminLoggedOn; Components: assoc
Root: HKCU; Subkey: Software\Classes\.gitmodules; ValueType: string; ValueData: txtfile; Flags: createvalueifdoesntexist uninsdeletevalue uninsdeletekeyifempty; Check: not IsAdminLoggedOn; Components: assoc
Root: HKCU; Subkey: Software\Classes\.gitmodules; ValueType: string; ValueName: Content Type; ValueData: text/plain; Flags: createvalueifdoesntexist uninsdeletevalue uninsdeletekeyifempty; Check: not IsAdminLoggedOn; Components: assoc
Root: HKCU; Subkey: Software\Classes\.gitmodules; ValueType: string; ValueName: PerceivedType; ValueData: text; Flags: createvalueifdoesntexist uninsdeletevalue uninsdeletekeyifempty; Check: not IsAdminLoggedOn; Components: assoc

; Associate .sh extension with sh.exe so those files are double-clickable,
; startable from cmd.exe, and when files are dropped on them they are passed
; as arguments to the script.

; Install under HKEY_LOCAL_MACHINE if an administrator is installing.
Root: HKLM; Subkey: Software\Classes\.sh; ValueType: string; ValueData: sh_auto_file; Flags: createvalueifdoesntexist uninsdeletekeyifempty uninsdeletevalue; Check: IsAdminLoggedOn; Components: assoc_sh
Root: HKLM; Subkey: Software\Classes\sh_auto_file; ValueType: string; ValueData: "Shell Script"; Flags: createvalueifdoesntexist uninsdeletekeyifempty uninsdeletevalue; Check: IsAdminLoggedOn; Components: assoc_sh
Root: HKLM; Subkey: Software\Classes\sh_auto_file\shell\open\command; ValueType: string; ValueData: """{app}\git-bash.exe"" --no-cd ""%L"" %*"; Flags: uninsdeletekeyifempty uninsdeletevalue; Check: IsAdminLoggedOn; Components: assoc_sh
Root: HKLM; Subkey: Software\Classes\sh_auto_file\DefaultIcon; ValueType: string; ValueData: "%SystemRoot%\System32\shell32.dll,-153"; Flags: createvalueifdoesntexist uninsdeletekeyifempty uninsdeletevalue; Check: IsAdminLoggedOn; Components: assoc_sh
Root: HKLM; Subkey: Software\Classes\sh_auto_file\ShellEx\DropHandler; ValueType: string; ValueData: {#DROP_HANDLER_GUID}; Flags: uninsdeletekeyifempty uninsdeletevalue; Check: IsAdminLoggedOn; Components: assoc_sh

; Install under HKEY_CURRENT_USER if a non-administrator is installing.
Root: HKCU; Subkey: Software\Classes\.sh; ValueType: string; ValueData: sh_auto_file; Flags: createvalueifdoesntexist uninsdeletekeyifempty uninsdeletevalue; Check: not IsAdminLoggedOn; Components: assoc_sh
Root: HKCU; Subkey: Software\Classes\sh_auto_file; ValueType: string; ValueData: "Shell Script"; Flags: createvalueifdoesntexist uninsdeletekeyifempty uninsdeletevalue; Check: not IsAdminLoggedOn; Components: assoc_sh
Root: HKCU; Subkey: Software\Classes\sh_auto_file\shell\open\command; ValueType: string; ValueData: """{app}\git-bash.exe"" --no-cd ""%L"" %*"; Flags: uninsdeletekeyifempty uninsdeletevalue; Check: not IsAdminLoggedOn; Components: assoc_sh
Root: HKCU; Subkey: Software\Classes\sh_auto_file\DefaultIcon; ValueType: string; ValueData: "%SystemRoot%\System32\shell32.dll,-153"; Flags: createvalueifdoesntexist uninsdeletekeyifempty uninsdeletevalue; Check: not IsAdminLoggedOn; Components: assoc_sh
Root: HKCU; Subkey: Software\Classes\sh_auto_file\ShellEx\DropHandler; ValueType: string; ValueData: {#DROP_HANDLER_GUID}; Flags: uninsdeletekeyifempty uninsdeletevalue; Check: not IsAdminLoggedOn; Components: assoc_sh

[UninstallDelete]
; Delete the built-ins.
Type: files; Name: {app}\{#MINGW_BITNESS}\bin\git-*.exe
Type: files; Name: {app}\{#MINGW_BITNESS}\libexec\git-core\git-*.exe
Type: files; Name: {app}\{#MINGW_BITNESS}\libexec\git-core\git.exe

; Delete git-lfs wrapper
Type: files; Name: {app}\cmd\git-lfs.exe

; Delete copied *.dll files
Type: files; Name: {app}\{#MINGW_BITNESS}\libexec\git-core\*.dll

; Delete the dynamical generated MSYS2 files
Type: files; Name: {app}\etc\hosts
Type: files; Name: {app}\etc\mtab
Type: files; Name: {app}\etc\networks
Type: files; Name: {app}\etc\protocols
Type: files; Name: {app}\etc\services
Type: files; Name: {app}\dev\fd
Type: files; Name: {app}\dev\stderr
Type: files; Name: {app}\dev\stdin
Type: files; Name: {app}\dev\stdout
Type: dirifempty; Name: {app}\dev\mqueue
Type: dirifempty; Name: {app}\dev\shm
Type: dirifempty; Name: {app}\dev

; Delete any manually created shortcuts.
Type: files; Name: {userappdata}\Microsoft\Internet Explorer\Quick Launch\Git Bash.lnk
Type: files; Name: {code:GetShellFolder|desktop}\Git Bash.lnk
Type: files; Name: {app}\Git Bash.lnk

; Delete a home directory inside the Git for Windows directory.
Type: dirifempty; Name: {app}\home\{username}
Type: dirifempty; Name: {app}\home

#if BITNESS=='32'
; Delete the files required for rebaseall
Type: files; Name: {app}\bin\msys-2.0.dll
Type: files; Name: {app}\bin\rebase.exe
Type: dirifempty; Name: {app}\bin
Type: files; Name: {app}\etc\rebase.db.i386
Type: dirifempty; Name: {app}\etc
#endif

; Delete recorded install options
Type: files; Name: {app}\etc\install-options.txt
Type: dirifempty; Name: {app}\etc
Type: dirifempty; Name: {app}\{#MINGW_BITNESS}\libexec\git-core
Type: dirifempty; Name: {app}\{#MINGW_BITNESS}\libexec
Type: dirifempty; Name: {app}\{#MINGW_BITNESS}
Type: dirifempty; Name: {app}

[Code]
#include "helpers.inc.iss"
#include "environment.inc.iss"
#include "putty.inc.iss"
#include "modules.inc.iss"
