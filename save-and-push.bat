@echo off
REM Save and push script for current branch

REM Get current branch name
FOR /F "delims=" %%b IN ('git rev-parse --abbrev-ref HEAD') DO SET BRANCH=%%b

echo.
echo You are on branch: %BRANCH%
echo.

REM Prompt for commit message
set /p MSG=Enter commit message: 

REM Add and commit all changes
git add .
git commit -m "%MSG%"

REM Push to current branch on origin
git push origin %BRANCH%

echo.
echo --------------------------------------------------------
git status
echo.
git log --oneline -5

echo.
echo Script complete. Press any key to exit.
pause >nul
