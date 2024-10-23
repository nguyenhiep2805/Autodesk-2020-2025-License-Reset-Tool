::This command script helps to automate the process of resetting Autodesk 2020-2025 licensing.
::Written by Travis Nave - Expert Elite, H&C © 2019-2024
::v2024.5.1

@ECHO OFF
SETLOCAL enabledelayedexpansion
:TOP
CLS
COLOR 0F
@TITLE Autodesk 2020-2025 License Reset Tool

ECHO.
ECHO               [1m [91m [4mPLEASE READ AND UNDERSTAND BEFORE CONTINUING![0m
ECHO.
ECHO This tool is designed to help automate the process of [1mresetting the default
ECHO licensing[0m of the[1m [93mAutodesk 2020-2025[0m product line.  Since the process is more
ECHO involved than in previous releases, this tool will help reset the licensing
ECHO using the command switches necessary to do so.  You do not have to bother
ECHO with memorization of commands or the location of the executable.  If you would
ECHO rather use the Autodesk License Reset Tool instead, then Press [34mH[0m at the menu.
ECHO.
ECHO This script is a work in progress and may need to be updated as new products
ECHO or service packs are released. [1m [91mPlease use at your own risk.[0m
ECHO.
OPENFILES >nul 2>&1
IF %ErrorLevel% EQU 0 ( ECHO [92mYou are running v2024.5.1 with Admin privileges.[0m ) ELSE ( ECHO [91mPlease close and run as Administrator.[0m )
TIMEOUT /T 1 >NUL
:LIST
@TITLE Autodesk 2020-2025 License Reset Tool
ECHO.
ECHO [4m                                                                             [0m
ECHO.
ECHO [1m%USERNAME%[0m, Please choose a selection to make changes on [1m%COMPUTERNAME%[0m:
ECHO.
ECHO  	  [1m[4mMAIN[0m				[1m[4mOTHER TOOLS[0m
ECHO  [1m1.[0m LIST Licensed Products	[1m3.[0m Set ADSKFLEX_LICENSE_FILE [90m(NLM Only)[0m
ECHO  [1m2.[0m RESET Licensing LGS		[1m4.[0m Set FLEXLM_TIMEOUT [90m(NLM Only)[0m
ECHO					[1m5.[0m Open adskflex*.data file location
ECHO 	 			[1m6.[0m Start the Licensing Service
ECHO [1m [34mH. Help [90m(Get Autodesk Tool)[0m	[1m7.[0m Open Account Management [90m(Browser)[0m
ECHO [1m [31mQ. Quit[0m			[1m8.[0m Enable/Disable Digital Signature Icons[0m
ECHO.

SET /P CHOICE=Please choose option [[1m1-8[0m, [34m[1mH[0m, [31m[1mQ[0m]: %
IF "%CHOICE%"=="1" (
	@TITLE Autodesk 2020-2025 License Reset Tool - Listing Installed Products
IF EXIST "%CommonProgramFiles(x86)%\Autodesk Shared\AdskLicensing\Current\helper\AdskLicensingInstHelper.exe" (
	"%CommonProgramFiles(x86)%\Autodesk Shared\AdskLicensing\Current\helper\AdskLicensingInstHelper.exe" list
	"%CommonProgramFiles(x86)%\Autodesk Shared\AdskLicensing\Current\helper\AdskLicensingInstHelper.exe" list > list.rtf
	start list.rtf
) ELSE (
	ECHO.
	ECHO There are no Autodesk products installed on %COMPUTERNAME%.
	)
	GOTO CHOICE
)

IF "%CHOICE%"=="2" (
	@TITLE Autodesk 2020-2025 License Reset Tool - Use the values from Option 1
	ECHO.
	ECHO Note:  Hit [1m^<ENTER^>[0m to accept the default value given in the example.
	ECHO.
	SET /P PRODKEY=Input the Product Key [[90mDefault: 001Q1[0m]: %
	SET /P PRODVER=Input the Product Version [[90mDefault: 2025.0.0.F[0m]: %
	ECHO.
	IF "!PRODKEY!"=="" SET PRODKEY=001Q1
	IF "!PRODVER!"=="" SET PRODVER=2025.0.0.F
	ECHO You entered product key [1m!PRODKEY![0m and Version [1m!PRODVER![0m
	ECHO.
	SET /P VERIFY=[1m[41mWARNING, THIS WILL RESET YOUR LICENSE?[0m [[92mY[0m or [91mN[0m] %
	IF /I "!VERIFY!"=="y" GOTO COMMIT
	IF %ERRORLEVEL% NEQ 0 GOTO LIST
	ECHO.
	ECHO [1mOperation canceled.[0m
	TIMEOUT /T 2 >NUL
	GOTO LIST
)

IF "%CHOICE%"=="3" (
	@TITLE Autodesk 2020-2025 License Reset Tool - For NLM use only
	ECHO.
	ECHO.
	ECHO [93mNote:  You only need to set this variable if you are using the Network License
	ECHO Manager.  You must include the @ symbol in front of the servername.  If you are
	ECHO using a port that is not default, then you must also include the port number.[0m
	ECHO.
	ECHO [90mThe current value is: %ADSKFLEX_LICENSE_FILE% [0m
	SET /P ADSKFLEX=Input Server Hostname [Example: @SERVERNAME or 27000@SERVERNAME]: %
	IF "!ADSKFLEX!"=="" (
		ECHO [1m - No changes made - [0m
		GOTO CHOICE
	)
	setx ADSKFLEX_LICENSE_FILE "!ADSKFLEX!" /M
	GOTO CHOICE
)

IF "%CHOICE%"=="4" (
	@TITLE Autodesk 2020-2025 License Reset Tool - For NLM use only
	ECHO.
	ECHO.
	ECHO [93mNote:  You only need to set this variable if you are using the Network License
	ECHO Manager.  You should use multiples of one-million.  1 second = 1000000.
	ECHO You can simply press ^<ENTER^> to accept the default value.[0m
	ECHO.
	ECHO [90mThe current value is: %FLEXLM_TIMEOUT% [0m
	SET /P FLEXLM=Input Timeout value [[90mDefault: 1000000[0m]: %
	IF "!FLEXLM!"=="" SET FLEXLM=1000000
	setx FLEXLM_TIMEOUT "!FLEXLM!" /M
	GOTO CHOICE
)

IF "%CHOICE%"=="5" (
	IF EXIST "%PROGRAMDATA%\Flexnet" (
	START %PROGRAMDATA%\Flexnet
	) ELSE (
  	ECHO.
	ECHO Folder location %PROGRAMDATA%\Flexnet does not exist.
	)
	GOTO CHOICE
)

IF "%CHOICE%"=="6" (
	@TITLE Autodesk 2020-2025 License Reset Tool - Start License Service
	ECHO.
	NET START AdskLicensingService
	GOTO CHOICE
)

IF "%CHOICE%"=="7" (
	@TITLE Autodesk 2020-2025 License Reset Tool - Open Account Manager
	ECHO.
	rundll32 url.dll,FileProtocolHandler https://manage.autodesk.com/
	GOTO CHOICE
)

IF "%CHOICE%"=="8" (
	IF EXIST "%SystemRoot%\System32\ACSIGNOPT.exe" (
	START ACSIGNOPT
	) ELSE (
  	ECHO.
	ECHO This option is not available.  Try right-clicking your Autodesk icon.
	)
	GOTO CHOICE
)

IF /I "%CHOICE%"=="C" (
	CLS
	GOTO LIST
)

IF /I "%CHOICE%"=="H" (
	TITLE Autodesk 2020-2025 License Reset Tool - Help
	ECHO.
	ECHO.[1m[4mMAIN[0m
	ECHO.
	ECHO [96m1. LIST Licensed Products - This will list the Autodesk 2020-2025 products
	ECHO    that are currently installed on %COMPUTERNAME%.  Use this to determine the
	ECHO    "def_prod_key" and the "def_prod_version" that will be used for option 2.[0m
	ECHO.
	ECHO [92m2. RESET Licensing LGS - This will ask you for the Product key and the Product
	ECHO    version found by using the Option 1 list.  Default values are for AutoCAD 2025.
	ECHO    If you make a typo here, it will error out when trying to reset the license.
	ECHO    This will also open the LICPATH.LIC file location if you are using NLM.[0m
	ECHO.
	ECHO.[1m[4mOTHER TOOLS[0m
	ECHO.
	ECHO [94m3. Set ADSKFLEX_LICENSE_FILE - This will allow you to set the System
	ECHO    Environment Variable for your Autodesk Network License Manager Server.[0m
	ECHO.
	ECHO [95m4. Set FLEXLM_TIMEOUT - This will allow you to set the System Environment
	ECHO    Variable for the amount of time to poll the NLM.  1000000 = 1 second.[0m
	ECHO.
	ECHO [90m5. Open Adskflex*.data file location - This will open the location for the
	ECHO    stand-alone registered license files, if it exists.[0m
	ECHO.
	ECHO [33m6. Start the Licensing Service - Start the service if it is not running.[0m
	ECHO.
	ECHO [96m7. Open Account Management - Launches Account Manager in your default browser.[0m
	ECHO.
	ECHO [92m8. Enable/Disable Digital Signatures - Speed up File ^> Open over the Network.
	ECHO    This requires a reboot when disabled.  It may re-enable on new installations. [0m

	TIMEOUT /T 2 >NUL
	START https://www.autodesk.com/support/technical/article/caas/sfdcarticles/sfdcarticles/How-to-change-or-reset-licensing-on-your-Autodesk-software.html#2020
	GOTO CHOICE
)

IF /I "%CHOICE%"=="Q" GOTO END
IF %ERRORLEVEL% NEQ 0 GOTO LIST
ECHO That is not a valid choice.  Returning to Menu...
TIMEOUT /T 1 >NUL
GOTO LIST

:CHOICE
ECHO.
SET /P NOWWHAT=You can choose to go Back [[92mB[0m] or Quit [[91mQ[0m]: %
IF /I "%NOWWHAT%"=="B" GOTO LIST
IF /I "%NOWWHAT%"=="Q" GOTO END
IF %ERRORLEVEL% NEQ 0 GOTO LIST
ECHO That is not a valid choice.  Returning to Menu...
TIMEOUT /T 1 >NUL
GOTO LIST

:COMMIT
@TITLE Autodesk 2020-2025 License Reset Tool - Backing-up and Resetting License...
ECHO.
tasklist /FI "IMAGENAME eq AdSSO.exe" 2>NUL | find /I /N "AdSSO.exe">NUL
if "%ERRORLEVEL%"=="0" taskkill /f /im AdSSO.exe

tasklist /FI "IMAGENAME eq AdAppMgrSvc.exe" 2>NUL | find /I /N "AdAppMgrSvc.exe">NUL
if "%ERRORLEVEL%"=="0" taskkill /f /im AdAppMgrSvc.exe

tasklist /FI "IMAGENAME eq AutodeskDesktopApp.exe" 2>NUL | find /I /N "AutodeskDesktopApp.exe">NUL
if "%ERRORLEVEL%"=="0" taskkill /f /im AutodeskDesktopApp.exe

tasklist /FI "IMAGENAME eq AdskLicensingAgent.exe" 2>NUL | find /I /N "AdskLicensingAgent.exe">NUL
if "%ERRORLEVEL%"=="0" taskkill /f /im AdskLicensingAgent.exe

tasklist /FI "IMAGENAME eq ADPClientService.exe" 2>NUL | find /I /N "ADPClientService.exe">NUL
if "%ERRORLEVEL%"=="0" taskkill /f /im ADPClientService.exe

::tasklist /FI "IMAGENAME eq AdskAccessCore.exe" 2>NUL | find /I /N "AdskAccessCore.exe">NUL
::if "%ERRORLEVEL%"=="0" taskkill /f /im AdskAccessCore.exe

tasklist /FI "IMAGENAME eq AdskIdentityManager.exe" 2>NUL | find /I /N "AdskIdentityManager.exe">NUL
if "%ERRORLEVEL%"=="0" taskkill /f /im AdskIdentityManager.exe
ECHO.
ECHO If there is no error between the brackets, then the process was successful:
ECHO [[91m
IF EXIST "%LOCALAPPDATA%\Autodesk\Web Services\LoginState.xml" (
ren "%LOCALAPPDATA%\Autodesk\Web Services\LoginState.xml" "LoginState-%date:~10,4%%date:~4,2%%date:~7,2%-%time:~0,2%%time:~3,2%.xml"
)
IF EXIST "%LOCALAPPDATA%\Autodesk\Identity Services\idservices.db" (
TIMEOUT /T 1 >NUL
ren "%LOCALAPPDATA%\Autodesk\Identity Services\idservices.db" "idservices-%date:~10,4%%date:~4,2%%date:~7,2%-%time:~0,2%%time:~3,2%.db"
)
"%CommonProgramFiles(x86)%\Autodesk Shared\AdskLicensing\Current\helper\AdskLicensingInstHelper.exe" change --prod_key %PRODKEY% --prod_ver %PRODVER% --lic_method "" --lic_server_type "" --lic_servers ""
ECHO [0m]
ECHO.

IF EXIST "%PROGRAMDATA%\Autodesk\AdskLicensingService\!PRODKEY!_!PRODVER!" (
	START %PROGRAMDATA%\Autodesk\AdskLicensingService\!PRODKEY!_!PRODVER!
)
@TITLE Autodesk 2020-2025 License Reset Tool - Backing-up and Resetting License Complete!
SET /P REPEAT=Would you like to reset another licensed product? [[92mY[0m or [91mQ[0m] %
IF /I "%REPEAT%"=="Y" GOTO LIST
IF %ERRORLEVEL% NEQ 0 GOTO LIST

:END
@TITLE Thank you for using the Autodesk 2020-2025 License Reset Tool
ECHO.
ECHO [4m                                                                             [0m
ECHO.
ECHO                            [92mPROCESS HAS COMPLETED. [0m
ECHO [4m                                                                             [0m
ECHO.
ECHO To exit please
PAUSE
ENDLOCAL
eventcreate /t information /id 25 /L application /so "Autodesk Licensing Reset" /d "The Autodesk Licensing Reset Tool Was Run."
EXIT
@EXIT
