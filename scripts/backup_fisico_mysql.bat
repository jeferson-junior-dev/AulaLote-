@echo off
setlocal

title Backup fisico controlado do MySQL

set "SERVICO=MySQL80"
set "ORIGEM=C:\ProgramData\MySQL\MySQL Server 8.0\Data"
set "DESTINO=C:\teste\backups\fisico"
set "LOG=C:\teste\logs\backup_fisico_mysql.log"

for /f %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HH-mm-ss"') do set "DATAHORA=%%I"

set "PASTA_BACKUP=%DESTINO%\mysql_fisico_%DATAHORA%"

echo ================================================== >> "%LOG%"
echo Inicio: %date% %time% >> "%LOG%"
echo Servico: %SERVICO% >> "%LOG%"

if not exist "%ORIGEM%" (
echo ERRO: Diretorio de dados nao encontrado.
echo Diretorio inexistente: %ORIGEM% >> "%LOG%"
pause
exit /b 1
)

mkdir "%PASTA_BACKUP%" 2>nul

echo Interrompendo o servico MySQL...
net stop "%SERVICO%" >> "%LOG%" 2>&1

if errorlevel 1 (
echo Nao foi possivel interromper o MySQL.
echo Execute este arquivo como administrador.
pause
exit /b 2
)

echo Copiando os arquivos fisicos...
robocopy "%ORIGEM%" "%PASTA_BACKUP%" *.* /E /COPY:DAT /R:2 /W:2 /LOG+:"%LOG%"

set "RESULTADO=%ERRORLEVEL%"

echo Reiniciando o MySQL...
net start "%SERVICO%" >> "%LOG%" 2>&1

if %RESULTADO% LEQ 7 (
echo Backup fisico concluido.
echo Resultado da copia: sucesso. Codigo %RESULTADO% >> "%LOG%"
) else (
echo A copia apresentou erro. Consulte o log.
echo Resultado da copia: erro. Codigo %RESULTADO% >> "%LOG%"
)

echo Termino: %date% %time% >> "%LOG%"
echo ================================================== >> "%LOG%"

pause
endlocal