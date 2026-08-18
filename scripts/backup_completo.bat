@echo off
setlocal

title Backup completo do banco

set "MYSQL_BIN=C:\Program Files\MySQL\MySQL Server 8.0\bin"
set "BANCO=db_techestoque"
set "DESTINO=C:\teste\backups\completo"
set "LOG=C:\teste\logs\backup_completo.log"

for /f %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HH-mm-ss"') do set "DATAHORA=%%I"

set "ARQUIVO=%DESTINO%\%BANCO%_%DATAHORA%.sql"

if not exist "%DESTINO%" mkdir "%DESTINO%"

echo ================================================== >> "%LOG%"
echo Inicio: %date% %time% >> "%LOG%"
echo Banco: %BANCO% >> "%LOG%"
echo Arquivo: %ARQUIVO% >> "%LOG%"

"%MYSQL_BIN%\mysqldump.exe" --login-path=aula_backup --single-transaction --routines --events --triggers --databases "%BANCO%" > "%ARQUIVO%" 2>> "%LOG%"

if errorlevel 1 (
echo ERRO: Nao foi possivel gerar o backup.
pause
exit /b 1
)

for %%A in ("%ARQUIVO%") do set "TAMANHO=%%~zA"

if "%TAMANHO%"=="0" (
echo ERRO: O arquivo foi criado, mas esta vazio.
pause
exit /b 2
)

findstr /C:"CREATE TABLE" "%ARQUIVO%" >nul

if errorlevel 1 (
echo ALERTA: CREATE TABLE nao foi localizado.
pause
exit /b 3
)

echo Backup concluido com sucesso.
echo Tamanho: %TAMANHO% bytes
echo Sucesso. Tamanho: %TAMANHO% bytes >> "%LOG%"
pause
endlocal