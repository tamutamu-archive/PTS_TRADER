@REM pts_trader launcher script
@REM
@REM Envioronment:
@REM JAVA_HOME - location of a JDK home dir (optional if java on path)
@REM CFG_OPTS  - JVM options (optional)
@REM Configuration:
@REM PTS_TRADER_config.txt found in the PTS_TRADER_HOME.
@setlocal enabledelayedexpansion

@echo off
if "%PTS_TRADER_HOME%"=="" set "PTS_TRADER_HOME=%~dp0\\.."
set ERROR_CODE=0

set "APP_LIB_DIR=%PTS_TRADER_HOME%\lib\"

rem Detect if we were double clicked, although theoretically A user could
rem manually run cmd /c
for %%x in (%cmdcmdline%) do if %%~x==/c set DOUBLECLICKED=1

rem FIRST we load the config file of extra options.
set "CFG_FILE=%PTS_TRADER_HOME%\PTS_TRADER_config.txt"
set CFG_OPTS=
if exist %CFG_FILE% (
  FOR /F "tokens=* eol=# usebackq delims=" %%i IN ("%CFG_FILE%") DO (
    set DO_NOT_REUSE_ME=%%i
    rem ZOMG (Part #2) WE use !! here to delay the expansion of
    rem CFG_OPTS, otherwise it remains "" for this loop.
    set CFG_OPTS=!CFG_OPTS! !DO_NOT_REUSE_ME!
  )
)

rem We use the value of the JAVACMD environment variable if defined
set _JAVACMD=%JAVACMD%

if "%_JAVACMD%"=="" (
  if not "%JAVA_HOME%"=="" (
    if exist "%JAVA_HOME%\bin\java.exe" set "_JAVACMD=%JAVA_HOME%\bin\java.exe"
  )
)

if "%_JAVACMD%"=="" set _JAVACMD=java

rem Detect if this java is ok to use.
for /F %%j in ('"%_JAVACMD%" -version  2^>^&1') do (
  if %%~j==Java set JAVAINSTALLED=1
)

rem Detect the same thing about javac
if "%_JAVACCMD%"=="" (
  if not "%JAVA_HOME%"=="" (
    if exist "%JAVA_HOME%\bin\javac.exe" set "_JAVACCMD=%JAVA_HOME%\bin\javac.exe"
  )
)
if "%_JAVACCMD%"=="" set _JAVACCMD=javac
for /F %%j in ('"%_JAVACCMD%" -version 2^>^&1') do (
  if %%~j==javac set JAVACINSTALLED=1
)

rem BAT has no logical or, so we do it OLD SCHOOL! Oppan Redmond Style
set JAVAOK=true
if not defined JAVAINSTALLED set JAVAOK=false
rem TODO - JAVAC is an optional requirement.
if not defined JAVACINSTALLED set JAVAOK=false

if "%JAVAOK%"=="false" (
  echo.
  echo A Java JDK is not installed or can't be found.
  if not "%JAVA_HOME%"=="" (
    echo JAVA_HOME = "%JAVA_HOME%"
  )
  echo.
  echo Please go to
  echo   http://www.oracle.com/technetwork/java/javase/downloads/index.html
  echo and download a valid Java JDK and install before running pts_trader.
  echo.
  echo If you think this message is in error, please check
  echo your environment variables to see if "java.exe" and "javac.exe" are
  echo available via JAVA_HOME or PATH.
  echo.
  if defined DOUBLECLICKED pause
  exit /B 1
)


rem We use the value of the JAVA_OPTS environment variable if defined, rather than the config.
set _JAVA_OPTS=%JAVA_OPTS%
if "%_JAVA_OPTS%"=="" set _JAVA_OPTS=%CFG_OPTS%

:run
 
set "APP_CLASSPATH=%APP_LIB_DIR%\pts_trader.pts_trader-0.1.0.jar;%APP_LIB_DIR%\org.scala-lang.scala-library-2.10.0.jar;%APP_LIB_DIR%\org.seleniumhq.webdriver.webdriver-htmlunit-0.9.7376.jar;%APP_LIB_DIR%\org.seleniumhq.webdriver.webdriver-common-0.9.7376.jar;%APP_LIB_DIR%\net.sourceforge.htmlunit.htmlunit-2.6.jar;%APP_LIB_DIR%\xalan.xalan-2.7.1.jar;%APP_LIB_DIR%\xalan.serializer-2.7.1.jar;%APP_LIB_DIR%\xml-apis.xml-apis-1.3.04.jar;%APP_LIB_DIR%\commons-collections.commons-collections-3.2.1.jar;%APP_LIB_DIR%\commons-lang.commons-lang-2.4.jar;%APP_LIB_DIR%\commons-httpclient.commons-httpclient-3.1.jar;%APP_LIB_DIR%\commons-logging.commons-logging-1.1.1.jar;%APP_LIB_DIR%\commons-codec.commons-codec-1.4.jar;%APP_LIB_DIR%\net.sourceforge.htmlunit.htmlunit-core-js-2.6.jar;%APP_LIB_DIR%\xerces.xercesImpl-2.9.1.jar;%APP_LIB_DIR%\net.sourceforge.nekohtml.nekohtml-1.9.13.jar;%APP_LIB_DIR%\net.sourceforge.cssparser.cssparser-0.9.5.jar;%APP_LIB_DIR%\org.w3c.css.sac-1.3.jar;%APP_LIB_DIR%\commons-io.commons-io-1.4.jar;%APP_LIB_DIR%\com.twitter.util-eval-1.12.13.jar;%APP_LIB_DIR%\org.scala-lang.scala-compiler-2.8.1.jar;%APP_LIB_DIR%\com.twitter.util-core-1.12.13.jar"
set "APP_MAIN_CLASS=Main"

rem TODO - figure out how to pass arguments....
"%_JAVACMD%" %_JAVA_OPTS% %PTS_TRADER_OPTS% -cp "%APP_CLASSPATH%" %APP_MAIN_CLASS% %CMDS%
if ERRORLEVEL 1 goto error
goto end

:error
set ERROR_CODE=1

:end

@endlocal

exit /B %ERROR_CODE%
