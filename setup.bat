@echo off

cd %~dp0

set SETTINGS_JSON_PATH=%APPDATA%\Code\User\settings.json
set BK_SETTINGS_JSON_PATH=%SETTINGS_JSON_PATH%.bk

if exist "%SETTINGS_JSON_PATH%" (
    move %SETTINGS_JSON_PATH% %BK_SETTING_JSON_PATH%
    echo Back up %SETTINGS_JSON_PATH% "->" %BK_SETTINGS_JSON_PATH%
)

mklink %SETTINGS_JSON_PATH% %~dp0\vscode\settings.json