@echo off

chcp 65001
echo.

net session >nul 2>&1
if %errorlevel% neq 0 (
  echo 以管理员身份运行
  powershell -Command "Start-Process '%~f0' -Verb runAs"
  exit /b
)

echo WPS 云文档相关注册表清理

for /f "tokens=2 delims==" %%i in ('wmic useraccount where name^="%username%" get sid /value ^| find "="') do set SID=%%i

:menu
echo.
echo [1] 删除“我的电脑”中的 WPS 云文档图标
echo [2] 删除资源管理器侧边栏中的 WPS 云文档
echo [3] 删除回收站中的 WPS 云盘回收站
echo [q] 退出
set /p choice=请输入：
if "%choice%"=="1" goto del_mycomputer
if "%choice%"=="2" goto del_sidebar
if "%choice%"=="3" goto del_recycle
if /i "%choice%"=="q" exit
goto menu

:del_mycomputer
echo.
echo 删除“我的电脑”中的 WPS 云文档图标...
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{5FCD4425-CA3A-48F4-A57C-B8A75C32ACB1}" /f
echo 完成
goto menu

:del_sidebar
echo.
echo 删除资源管理器侧边栏中的 WPS 云文档...
reg delete "HKEY_USERS\%SID%\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{7AE6DE87-C956-4B40-9C89-3D166C9841D3}" /f
echo 完成
goto menu

:del_recycle
echo.
echo 删除回收站中的 WPS 云盘回收站...
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SyncRootManager\WPSCloudProvider!%SID%!RecycleBinUrl" /f
echo 完成
goto menu
