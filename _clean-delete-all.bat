@echo off
REM Clean & delete all changes, including ignored files
echo.
set /p CONFIRM=CLEAN & DELETE; ARE YOU SURE? (type YES to continue): 
if /I not "%CONFIRM%"=="YES" (
    echo.
    echo Aborted by user. Press any key to exit.
    pause >nul
    exit /b
)

git reset --hard
git clean -fdx

echo.
echo All changes reverted, untracked and ignored files removed.
echo.
git status

echo.
echo Done. Press any key to exit.
pause >nul
