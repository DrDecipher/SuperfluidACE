@echo off
REM Clean & revert all changes (keeps ignored files)
echo.
set /p CONFIRM=CLEAN; ARE YOU SURE? (type YES to continue): 
if /I not "%CONFIRM%"=="YES" (
    echo.
    echo Aborted by user. Press any key to exit.
    pause >nul
    exit /b
)

git reset --hard
git clean -fd

echo.
echo All changes reverted and untracked files removed.
echo.
git status

echo.
echo Done. Press any key to exit.
pause >nul
