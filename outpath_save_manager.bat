@ECHO OFF
SETLOCAL

IF NOT EXIST "%APPDATA%/../LocalLow/DAVII PROJECTS/Outpath" (
    ECHO "Wasn't able to locate the game's directory. Have you installed and launched the game yet?"
    EXIT
)

CD "%APPDATA%/../LocalLow/DAVII PROJECTS/Outpath"

IF EXIST "./Backups/NUL" GOTO backupdirExist
MKDIR Backups
COPY "./SaveFile1.es3" "./Backups/default.es3"
ECHO "default" > "./Backups/.currentFile.txt"

SET ARGS=%*


:NEXT_ARG
    FOR /F "tokens=1*" %%A %%B in "%ARGS%" do SET ARGS=%%B
GOTO :EOF

SET PREFIX="%~f0"
REM this is the help section
IF "%DO_LOOP%" == "TRUE" (
    SET PREFIX="> "
)

IF %1 == "" (
    SET DO_LOOP = "TRUE"
    :LOOP_START
    SET /P "ARGS=Enter an instruction > "
)

FOR /F "tokens=1*" %%A %%B IN (%ARGS%) DO (
    CALL CASE_%%A %%B
    IF ERRORLEVEL 1 CALL DEFAULT_CASE
)

GOTO END_FILE

:CASE_
:CASE_-H
:CASE_HELP
:CASE_/?
    echo "Saving: s save"
    echo "%PREFIX% save Main_File"
    echo ""
    echo "This can create more than one backup at a time."
    echo "%PREFIX% save File_1 File_2"
    echo "----------"
    echo "Loading: l load"
    echo "%PREFIX% load Main_File"
    echo "Note that this will overwrite your current save."
    echo "Will fail if more than one file is specified."
    echo "----------"
    echo "Deleting saves: d del delete"
    echo "%PREFIX% del Main_File Extra_File"
    echo "Deleting all backups: %PREFIX% delete *"
    echo "----------"
    echo "Viewing backups: v view"
    echo "%PREFIX% view"
    IF "%DO_LOOP%" == "TRUE" (
        ECHO "----------"
        ECHO "Exiting the program: e exit"
    )
GOTO END_CASE

:CASE_D
:CASE_DEL
:CASE_DELETE
    REM deleting saves
    
    FOR /F "tokens=3" %%A IN ("%ARGS%") DO (
        IF %%A == "*" (
            DEL "%%D.es3"
            GOTO DELETE_LOOP_END
        )
    )
    REM lmao the check to see if wildcard is funny

    :DELETE_LOOP_START
    FOR /F "tokens=3"  %%A IN (%ARGS%) DO (
        DEL "%%A.es3"
    )
    CALL NEXT_ARG

    :DELETE_LOOP_END
GOTO END_CASE

:CASE_V
:CASE_VIEW
    REM viewing all saves
    DIR "./Backups/*.es3" /T:W /O:-D
GOTO END_CASE

:CASE_L
:CASE_LOAD
    GOTO CASE_LOAD_VALID_FILENAME %~1
        :CASE_LOAD_VALID_FILENAME
        IF "%~1" == "" (
            FOR /F "tokens=* USEBACKQ" %%F IN (` TYPE "./Backups/.currentFile.txt" `) DO (
                SET CURR_SAVE_FILE=%%F
            )
        ) ELSE (
            SET CURR_SAVE_FILE = %~1
        )
        IF EXIST "./Backups/%CURR_SAVE_FILE%.es3" (
            COPY "./Backups/%CURR_SAVE_FILE%.es3" "./SaveFile1.es3"
        ) ELSE (
            ECHO "Wasn't able to find a save with name (%CURR_SAVE_FILE%)."
            ECHO "Try using '%PREFIX% view' to see the saves currently available."
        )

GOTO END_CASE

:CASE_S
:CASE_SAVE
    SET CURR_SAVE_FILE = %~1
    SET LOOP_REQ = "FALSE"
    :SAVE_LOOP_1_START
    IF "%CURR_SAVE_FILE%" == "" (
        SET LOOP_REQ = "TRUE"
        SET /P "CURR_SAVE_FILE=Please enter a name to save under, or multiple names, separated by spaces. >"
    )
    IF [%CURR_SAVE_FILE%]==[] GOTO SAVE_LOOP_1_START
    IF "%LOOP_REQ" == "TRUE" (
        SETLOCAL ENABLEDELAYEDEXPANSION
        SET ARGS="%ARGS% %CURR_SAVE_FILE%"
    )

    :SAVE_LOOP_2_START
    FOR /F "tokens=2*" %%A %%B IN (%ARGS%) DO (
        IF "%%A" == "" GOTO SAVE_LOOP_2_END
        COPY "./SaveFile1.es3" "./Backups/%%A.es3"
    )
    CALL NEXT_ARG
    GOTO SAVE_LOOP_2_START
    :SAVE_LOOP_2_END
GOTO END_CASE
:CASE_E
:CASE_EXIT
:CASE_STOP
:CASE_END
    SET DO_LOOP = "FALSE"
GOTO END_CASE

:DEFAULT_CASE
    REM invalid argument
    echo "Didn't find a valid instruction."
GOTO END_CASE

:END_CASE
    VER > NUL
GOTO :EOF

:END_FILE
    IF %DO_LOOP% == "TRUE" GOTO LOOP_START
    ENDLOCAL
GOTO :EOF