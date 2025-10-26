@echo off

chcp 65001 > nul

net session >nul 2>&1
if %errorlevel% neq 0 (
  echo 以管理员身份运行
  powershell -Command "Start-Process '%~f0' -Verb runAs"
  exit /b
)

echo WebDav 安全等级设置

set KEY=HKLM\SYSTEM\CurrentControlSet\Services\WebClient\Parameters
set VALUE=BasicAuthLevel

:status
echo.
echo 当前 BasicAuthLevel 值：
reg query "%KEY%" /v %VALUE%

:menu
echo.
echo [1] 设置为 1 - 仅允许 HTTPS 下使用 Basic Auth（默认，安全）
echo [2] 设置为 2 - 允许 HTTP 和 HTTPS 下使用 Basic Auth（不安全）
echo [0] 设置为 0 - 禁用 Basic Auth（最安全）
echo [r] 重启 WebClient 服务
echo [q] 退出
set /p choice=请输入：
if "%choice%"=="1" goto set1
if "%choice%"=="2" goto set2
if "%choice%"=="0" goto set0
if /i "%choice%"=="r" goto restart
if /i "%choice%"=="q" exit
goto menu

:set1
echo.
echo 设置为 1 - 仅允许 HTTPS 下使用 Basic Auth（默认，安全）...
reg add "%KEY%" /v %VALUE% /t REG_DWORD /d 1 /f
echo 完成
goto restart

:set2
echo.
echo 设置为 2 - 允许 HTTP 和 HTTPS 下使用 Basic Auth（不安全）...
reg add "%KEY%" /v %VALUE% /t REG_DWORD /d 2 /f
echo 完成
goto restart

:set0
echo.
echo 设置为 0 - 禁用 Basic Auth（最安全）...
reg add "%KEY%" /v %VALUE% /t REG_DWORD /d 0 /f
echo 完成
goto restart

:restart
echo.
echo 重启 WebClient 服务...
net stop WebClient >nul 2>&1
net start WebClient >nul 2>&1
echo 完成
goto status
