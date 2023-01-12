@SETLOCAL
@ECHO OFF
SETLOCAL ENABLEEXTENSIONS
SET LAST_PATH=%CD%

SETLOCAL ENABLEDELAYEDEXPANSION

TITLE Outpath Save Manager

SET CURR_PATH="%APPDATA%/../LocalLow/Breakfast Studio/Himno"
SET ARGS=%*
SET DO_LOOP="FALSE"
SET PREFIX=%0

CD %CURR_PATH% 2>NUL || (
    ECHO Wasn't able to locate the game's directory. Have you installed and launched the game yet?
    PAUSE
    EXIT
)

CD Backups 2>NUL && GOTO :ScriptStart
    MKDIR %CURR_PATH%
    CD %CURR_PATH%
    COPY "..\SaveFile1.es3" "default.es3"
    ECHO default > ".currentFile.txt"

GOTO :ScriptStart

:NEXT_ARG
    FOR /F "tokens=1* delims= " %%A IN ("!ARGS!") DO SET ARGS=%%B
GOTO :EOF

:ScriptStart

IF [%1] == [] (
    SET DO_LOOP="TRUE"
    SET PREFIX=..
    :LOOP_START
    ECHO --------
    SET /P "ARGS=Enter an instruction > "
)

FOR /F "tokens=1* delims= " %%A IN ("!ARGS!") DO ( REM [RESOLVED] Bug here: %B was unexpected at this time
    rem echo "Test"
    CALL :NEXT_ARG
    CALL :CASE_%%A %%B
    IF ERRORLEVEL 1 CALL :DEFAULT_CASE
)

GOTO :END_FILE

:CASE_
:CASE_HELP
:CASE_H
:CASE_h
:CASE_help
:CASE_/?
    echo Saving: s save
    echo %PREFIX% save Main_File

    echo ---- This can create more than one backup at a time.
    echo %PREFIX% save File_1 File_2
    echo ----------
    echo Loading: l load
    echo %PREFIX% load Main_File
    echo Note that this will overwrite your current save.
    echo Will fail if more than one file is specified.
    echo ----------
    echo Deleting saves: d del delete
    echo %PREFIX% del Main_File Extra_File
    echo Deleting all backups: %PREFIX% delete *
    echo ----------
    echo Viewing backups: v view
    echo %PREFIX% view
    IF "%DO_LOOP%" == "TRUE" (
        ECHO ----------
        ECHO Exiting the program: e exit
    )
    GOTO :END_CASE

:CASE_D
:CASE_d
:CASE_DEL
:CASE_del
:CASE_DELETE
:CASE_delete
    REM deleting saves
    ECHO --------
    IF ["!ARGS!"] == [""] (
        ECHO No arguments provdided. There must be at least one file to delete.
        GOTO :END_CASE
    )
    IF ["!ARGS!"] == ["*"] (
        DEL "*.es3"
        GOTO :DELETE_LOOP_END
    )

    REM echo hi
    REM FOR /F "tokens=1" %%A IN ("!ARGS!") DO (
    REM     IF "%%A" == "*" 
    REM )

    :DELETE_LOOP_START
    IF ["!ARGS!"] == [""] GOTO :DELETE_LOOP_END
    FOR /F "tokens=1" %%A IN ("!ARGS!") DO (
        DEL "%%A.es3"
    )
    CALL :NEXT_ARG
    GOTO :DELETE_LOOP_START

    :DELETE_LOOP_END
GOTO :END_CASE

:CASE_V
:CASE_v
:CASE_VIEW
:CASE_view
    ECHO --------
    REM viewing all saves

    DIR "*.es3" /T:W /O:-D
GOTO :END_CASE

:CASE_L
:CASE_l
:CASE_LOAD
:CASE_load
    ECHO --------
    GOTO :CASE_LOAD_VALID_FILENAME %~1
        :CASE_LOAD_VALID_FILENAME
        rem TYPE ".currentFile.txt"
        IF "%~1" == "" (
            FOR /F "tokens=*" %%A IN ( TYPE ".currentFile.txt") DO (
                if [%%A] == [] GOTO :CASE_LOAD_HAS_CURR_SAVE_FILE

                SET CURR_SAVE_FILE=%%A
            )
        ) ELSE (
            FOR /F "tokens=1" %%A IN ("!ARGS!") DO (
                SET CURR_SAVE_FILE=%%A
            )
        )
        :CASE_LOAD_HAS_CURR_SAVE_FILE
        REM echo %CURR_SAVE_FILE%
        DIR "%CURR_SAVE_FILE%.es3" > NUL && (
            TYPE "%CURR_SAVE_FILE%.es3" > "..\SaveFile1.es3"
        ) || (
            ECHO Wasn't able to find a save with name "!CURR_SAVE_FILE!"
            ECHO Try using "%PREFIX% view" to see the saves currently available
        )
GOTO :END_CASE

:CASE_S
:CASE_s
:CASE_SAVE
:CASE_save
    ECHO --------
    SET CURR_SAVE_FILE=%ARGS%
    SET LOOP_REQ="FALSE"
    :SAVE_LOOP_1_START
    REM ECHO ("!CURR_SAVE_FILE!")
    IF ("!CURR_SAVE_FILE!") == "" (
        SET LOOP_REQ="TRUE"
        SET /P "CURR_SAVE_FILE=Please enter a name to save under, or multiple names, separated by spaces. > "
    )
    REM echo "test"
    IF ("!CURR_SAVE_FILE!") == "" GOTO :SAVE_LOOP_1_START
    IF ("!LOOP_REQ!") == "TRUE" (
        SET ARGS=("!CURR_SAVE_FILE!")
    )
    FOR /F "tokens=1" %%A in ("!CURR_SAVE_FILE!") DO (
        SET CURR_SAVE_FILE=%%A
    )
    rem echo "hi"
    :SAVE_LOOP_2_START
    IF ("!ARGS!") == ("") GOTO :SAVE_LOOP_2_END
    echo ("!ARGS!")
    FOR /F "tokens=1" %%A IN ("!ARGS!") DO (
        REM IF "%%A" == "" GOTO :SAVE_LOOP_2_END
        ( TYPE "..\SaveFile1.es3") > "%%A.es3"
    )
    CALL :NEXT_ARG
    GOTO :SAVE_LOOP_2_START
    :SAVE_LOOP_2_END
GOTO :END_CASE

:CASE_E
:CASE_e
:CASE_EXIT
:CASE_exit
:CASE_STOP
:CASE_stop
:CASE_END
:CASE_end
    SET DO_LOOP="FALSE"
GOTO :END_CASE

:DEFAULT_CASE
    ECHO --------
    REM invalid argument
    ECHO Didn't find a valid instruction.
GOTO :END_CASE

:END_CASE
    VER > NUL
GOTO :EOF

:END_FILE
    IF %DO_LOOP% == "TRUE" GOTO :LOOP_START
    SETLOCAL DISABLEDELAYEDEXPANSION
    CD %LAST_PATH%
    ECHO Exiting
    PAUSE
GOTO :EOF