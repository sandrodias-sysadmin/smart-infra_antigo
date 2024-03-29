#!/bin/bash
#
# Projeto: Smart-Infra é uma coleção de scripts em Shell Script para rodar em
#          Bash facilitando a implantação de infraestrutura de rede em linux.
# Hospedado:  https://github.com/sandrodias-sysadmin/smart-infra
# Autor: Sandro Dias
# E-mail: sandrodias.oficiall@gmail.com
#
# Caminho Absoluto: /smart-infra/deploy/smart.network
# Função: Exibe informações básicas da rede
# Atualizado em: 21/04/2022
# Versao: 0.1
#
##############################
#
# ################### INFORMAÇÕES DA REDE ####################
# Captura a quantidade de interfaces de rede detectadas
qtd_interfaces=$(ip -brief token | wc -l)
#
lista_interfaces=$(ip -brief token | awk '/token/ { print $4 }')
#
# Nome das interfaces de rede detectadas com reserva de até 8 interfaces
#
interface1=$(echo $lista_interfaces | awk '{ print $1 }')
interface2=$(echo $lista_interfaces | awk '{ print $2 }')
interface3=$(echo $lista_interfaces | awk '{ print $3 }')
interface4=$(echo $lista_interfaces | awk '{ print $4 }')
interface5=$(echo $lista_interfaces | awk '{ print $5 }')
interface6=$(echo $lista_interfaces | awk '{ print $6 }')
interface7=$(echo $lista_interfaces | awk '{ print $7 }')
interface8=$(echo $lista_interfaces | awk '{ print $8 }')
# Captura o IP do Gateway usado como rota de saída para WAN
# Caso vario o S.O. não consegue acessar o Gateway
ip_gateway=$(ip route | awk '/default/ { print $3 }' | sed ':loop;$!N;s/\n/ /g;tloop')
#
# Captura a interface de rede usada como rota para acessar o gateway detectado
interface_gateway=$(ip route | awk '/default/ { print $5 }')
#
# Captura o IP do DNS primário
ip_dns=$(resolvectl | grep "Current DNS Server:" | sed "s/       DNS Servers: //" | awk '{print $4}' | sed ':loop;$!N;s/\n/ /g;tloop')
#
# Captura o IP Externo
ip_externo=$(dig @ns1-1.akamaitech.net ANY whoami.akamai.net +short)
#
# Captura a Interface usada na rede
interface_usada_narede=$(ip -4 addr show | grep "state UP" | awk '{ print $2 }' | sed ':loop;$!N;s/\n/ /;s/://g;tloop')
#
# Captura o IP Interno
ip_interno=$(ip -4 addr show dev $interface_usada_narede | grep inet | tr -s " " | cut -d" " -f3 | head -n 1 | sed 's/\/24//')
#
# Define o site da Google para teste de conexão e navegação
checksite=www.google.com
#
hostname=$(hostname)
#
##############################
#
# Funções usadas nas Fases
#
function_HeaderDefault() {
	clear
	echo -e "${InverteCorPiscando}\n\n     +-----------------------------------------------------------------+\n     │░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│\n     │░░░░░░░ A  L  T  A        --- = ---     S  P  O  R  T  S ░░░░░░░░│\n     │░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│\n     +-----------------------------------------------------------------+\n                         S M A R T     I N F R A"
 	                         echo -e "                      INFORMAÇÕES ATUALIZADAS DA REDE\n" # Define o Título do Script
	
}

function_InfoConnections() {
	echo -e "     ┌─────────────────────────────┬───────────────────────────────────┐"
	echo -e "         Nome do Computador        │     $hostname"
	sleep 0.1
	echo -e "         Placas Detectadas         │     $qtd_interfaces"
	sleep 0.1
	echo -e "         Nome da Interface 1       │     $interface1"
	sleep 0.1
	echo -e "         Nome da Interface 2       │     $interface2"
	sleep 0.1
	echo -e "         Interface Usada na rede   │     $interface_usada_narede"
	sleep 0.1
	echo -e "          └> usando IP Local       │     $ip_interno"
	sleep 0.1
	echo -e "          └> usando IP Externo     │     $ip_externo"
	sleep 0.1
	echo -e "          └> usando Gateway        │     $ip_gateway"
	sleep 0.1
	echo -e "          └> usando DNS            │     $ip_dns"
	sleep 0.1
	echo -e "     └─────────────────────────────┴───────────────────────────────────┘"
	echo -e "            O relatório pode ser consultado nos arquivos de LOG."
	echo -e "\n\n                                  --- = ---\n\n"
}

function_HeaderDefault
function_InfoConnections
