@echo off

chcp 65001 > nul
setlocal enabledelayedexpansion

net session >nul 2>&1
if %errorlevel% neq 0 (
  echo 以管理员身份运行
  powershell -Command "Start-Process '%~f0' -Verb runAs"
  exit /b
)

echo 文件和目录区分大小写

:status
echo.
set /p path=请输入文件或目录路径：
echo 当前大小写敏感性：
fsutil.exe file queryCaseSensitiveInfo %path%

:menu
echo.
echo [1] 改为不区分大小写（默认）
echo [2] 改为区分大小写
echo [q] 退出
set /p choice=请输入：
if "%choice%"=="1" goto set1
if "%choice%"=="2" goto set2
if /i "%choice%"=="q" exit
goto menu

:set1
echo.
echo 改为不区分大小写（默认）...
set foundFailed=0
for /f "delims=" %%A in ('fsutil.exe file setCaseSensitiveInfo "%path%" disable 2^>^&1') do (
  echo %%A
  echo %%A | findstr /I "^Failed" >nul && set foundFailed=1
)
if !foundFailed! equ 1 (
  echo 失败
  ) else (
  echo 完成
)
goto status

:set2
echo.
echo 改为区分大小写...
set foundFailed=0
for /f "delims=" %%A in ('fsutil.exe file setCaseSensitiveInfo "%path%" enable 2^>^&1') do (
  echo %%A
  echo %%A | findstr /I "^Failed" >nul && set foundFailed=1
)
if !foundFailed! equ 1 (
  echo 失败
  ) else (
  echo 完成
)
goto status
