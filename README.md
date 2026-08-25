# automacao-triagem-rede
Script automatizado em Batch/PowerShell para triagem de redes corporativas em 3 camadas (LAN, Core e WAN). Otimiza o suporte técnico gerando logs automáticos e localizando falhas de conectividade sem ambiguidades.

# Triagem de Rede & Ferramenta de Diagnostico 

Ferramenta automatizada em Batch e PowerShell desenvolvida para otimizar o tempo de resposta do suporte técnico de Nível 1 e 2. 

O objetivo do script é eliminar ambiguidades na localização de falhas de rede. Ele realiza testes sequenciais em diferentes camadas lógicas e entrega ao técnico a exata localização do ponto de falha (física, roteamento interno ou link externo), gerando automaticamente um relatório de log para anexar aos chamados.

## Funcionalidades

- **Triagem em 3 Camadas:** Testa separadamente a conectividade LAN, o roteamento interno e a saída de internet.
- **Identificação Sem Ambiguidade:** Separa falhas de gateway local de falhas de regras em firewalls/SD-WAN.
- **Interface Visual:** Integração de Batch com PowerShell para exibir *outputs* coloridos e claros, facilitando a visualização rápida.
- **Geração Automática de Logs:** Em caso de falha, cria um arquivo `.txt` na Área de Trabalho do usuário com data, hora, IP, hostname e a etapa exata onde o erro ocorreu.

---

## Arquitetura de Rede e Topologia

Este script foi desenhado com base em uma **Topologia de Rede Corporativa (Enterprise)**. O diagnóstico segue o fluxo exato do pacote de dados, de dentro para fora:

1. **Camada de Acesso (LAN):** Testa a conectividade física do usuário até o switch de distribuição ou gateway da VLAN local.
2. **Camada Core / Distribuição:** Testa o roteamento interno até o coração da rede (Switch Core, Firewall ou equipamento SD-WAN).
3. **Camada de Borda (WAN / Edge):** Testa a saída da infraestrutura para a internet ou links dedicados externos.

---

## Como Instalar e Adaptar para a sua Rede

A infraestrutura varia de empresa para empresa. Você pode customizar este script facilmente para o seu ambiente de trabalho alterando apenas as três variáveis no topo do arquivo `diagnostico.bat`.

### 1. Configurando os IPs
Abra o arquivo `.bat` em qualquer editor de texto e localize este bloco no início do código:

```bat
rem ==========================================================
rem CONFIGURAÇÃO DOS ALVOS DA REDE (PREENCHA COM SEUS DADOS)
rem ==========================================================

rem IP do seu Gateway Local (ex: Switch da seção ou VLAN)
set IP_GATEWAY_LOCAL=192.168.1.1 

rem IP do seu Roteador Interno, Switch Core ou Firewall (ex: pfSense)
set IP_ROTEADOR_CORE=10.0.0.1 

rem IP de Saída Externa / Provedor (Pode usar 8.8.8.8 para testar internet)
set IP_SAIDA_WAN=8.8.8.8 
