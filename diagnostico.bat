@echo off
chcp 65001 >nul
title Ferramenta de Diagnostico

rem ==========================================================
rem CONFIGURAÇÃO DOS ALVOS DA REDE (ALTERE PARA O SEU AMBIENTE)
rem ==========================================================
rem IP do seu Gateway Local (ex: Switch da Seção/Departamento ou VLAN)
set IP_GATEWAY_LOCAL=192.168.1.1

rem IP do seu Roteador Interno ou Firewall (ex: pfsense)
set IP_ROTEADOR_CORE=10.0.0.1

rem IP de Saída Externa / Provedor (pode usar o 8.8.8.8 para testar internet)
set IP_SAIDA_WAN=8.8.8.8

set ARQUIVO_LOG=%USERPROFILE%\Desktop\Diagnostico_Rede_LOG.txt

echo =========================================================
echo   FERRAMENTA AUTOMATIZADA DE TRIAGEM DE CONEXAO DE REDE
echo =========================================================
echo.
echo Iniciando testes de conectividade...
echo.

rem --- PASSO 1: LAN / GATEWAY ---
echo [1/3] Testando conexao local (Placa de rede / Switch / Gateway)...
ping %IP_GATEWAY_LOCAL% -n 2 | findstr /i "TTL" >nul
if %errorlevel% NEQ 0 goto ERR_LAN
powershell -Command "Write-Host '[OK]' -ForegroundColor Green -NoNewline; Write-Host ' Conexao LAN e Gateway local operacionais.'"
echo.

rem --- PASSO 2: ROTEAMENTO INTERNO ---
echo [2/3] Testando roteamento interno (Switch Core / Roteador)...
ping %IP_ROTEADOR_CORE% -n 2 | findstr /i "TTL" >nul
if %errorlevel% NEQ 0 goto ERR_ROTEADOR
powershell -Command "Write-Host '[OK]' -ForegroundColor Green -NoNewline; Write-Host ' Roteamento interno operacional.'"
echo.

rem --- PASSO 3: SAÍDA DE LINK (WAN / PROVEDOR) ---
echo [3/3] Testando conectividade com o Ponto de Saida (WAN)...
ping %IP_SAIDA_WAN% -n 2 | findstr /i "TTL" >nul
if %errorlevel% NEQ 0 goto ERR_WAN
powershell -Command "Write-Host '[OK]' -ForegroundColor Green -NoNewline; Write-Host ' Conectividade com a rede externa OK.'"
echo.

echo =========================================================
powershell -Command "Write-Host 'DIAGNÓSTICO CONCLUÍDO: NENHUMA FALHA DETECTADA NA INFRAESTRUTURA.' -ForegroundColor Green"
echo =========================================================
echo.
pause
exit

rem ==========================================================
rem TRATAMENTO DE ERROS E GERAÇÃO DE RELATÓRIO
rem ==========================================================

:ERR_LAN
echo.
powershell -Command "Write-Host '[FALHA DETECTADA NO PASSO 1/3 - REDE LOCAL]' -ForegroundColor Red"
echo --------------------------------------------------------
echo AÇÕES RECOMENDADAS PARA O TÉCNICO:
echo 1. Verificar cabo de rede (conectores e integridade).
echo 2. Validar porta do Switch da secao/sala.
echo 3. Reiniciar adaptador de rede da maquina.
echo --------------------------------------------------------
call :GERAR_LOG "Falha na Rede Local / Gateway (%IP_GATEWAY_LOCAL%)"
goto FIM_FALHA

:ERR_ROTEADOR
echo.
powershell -Command "Write-Host '[FALHA DETECTADA NO PASSO 2/3 - ROTEAMENTO INTERNO]' -ForegroundColor Red"
echo --------------------------------------------------------
echo AÇÕES RECOMENDADAS PARA O TÉCNICO:
echo 1. Verificar disponibilidade do Switch Core / SD-WAN.
echo 2. Validar regras de bloqueio no Firewall / PFsense.
echo 3. Encaminhar chamado para a Equipe de Infraestrutura de Redes.
echo --------------------------------------------------------
call :GERAR_LOG "Falha no Roteamento Interno / Core (%IP_ROTEADOR_CORE%)"
goto FIM_FALHA

:ERR_WAN
echo.
powershell -Command "Write-Host '[FALHA DETECTADA NO PASSO 3/3 - LINK EXTERNO / WAN]' -ForegroundColor Red"
echo --------------------------------------------------------
echo AÇÕES RECOMENDADAS PARA O TÉCNICO:
echo 1. Confirmar se o circuito / provedor externo esta ativo.
echo 2. Acionar a Central de Atendimento / Provedor Responsavel.
echo --------------------------------------------------------
call :GERAR_LOG "Falha na Saida de Link / WAN (%IP_SAIDA_WAN%)"
goto FIM_FALHA

:GERAR_LOG
echo ========================================= > "%ARQUIVO_LOG%"
echo RELATORIO DE DIAGNOSTICO DE REDE >> "%ARQUIVO_LOG%"
echo Data/Hora: %date% as %time% >> "%ARQUIVO_LOG%"
echo Computador: %computername% >> "%ARQUIVO_LOG%"
echo Usuario: %username% >> "%ARQUIVO_LOG%"
echo Erro Encontrado: %~1 >> "%ARQUIVO_LOG%"
echo ========================================= >> "%ARQUIVO_LOG%"
echo. >> "%ARQUIVO_LOG%"
echo CONFIGURACAO DE IP ATUAL: >> "%ARQUIVO_LOG%"
ipconfig /all >> "%ARQUIVO_LOG%"
echo.
powershell -Command "Write-Host 'Um relatorio detalhado foi salvo na sua Area de Trabalho (Diagnostico_Rede_LOG.txt).' -ForegroundColor Cyan"
exit /b

:FIM_FALHA
echo.
pause