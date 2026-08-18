@echo off
setlocal

title Backup dos arquivos do projeto

set "ORIGEM=C:\teste\dados"
set "DESTINO=C:\teste\backups\arquivos"
set "LOG=C:\teste\logs\backup_arquivos.log"

for /f %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HH-mm-ss"') do set "DATAHORA=%%I"

set "PASTA_BACKUP=%DESTINO%\backup_%DATAHORA%"

echo ================================================== >> "%LOG%"
echo Inicio: %date% %time% >> "%LOG%"
echo Origem: %ORIGEM% >> "%LOG%"
echo Destino: %PASTA_BACKUP% >> "%LOG%"

if not exist "%ORIGEM%" (
echo ERRO: A pasta de origem nao existe.
echo ERRO: Pasta de origem inexistente. >> "%LOG%"
pause
exit /b 1
)

mkdir "%PASTA_BACKUP%" 2>nul

robocopy "%ORIGEM%" "%PASTA_BACKUP%" *.* /E /COPY:DAT /R:2 /W:2 /LOG+:"%LOG%"

set "RESULTADO=%ERRORLEVEL%"

if %RESULTADO% LEQ 7 (
echo Backup concluido com sucesso.
echo Resultado: sucesso. Codigo %RESULTADO% >> "%LOG%"
) else (
echo O backup apresentou erro. Consulte o arquivo de log.
echo Resultado: erro. Codigo %RESULTADO% >> "%LOG%"
)

echo Termino: %date% %time% >> "%LOG%"
echo ================================================== >> "%LOG%"

pause
endlocal