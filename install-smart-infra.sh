#!/bin/bash
#
# Projeto: Smart-Infra é uma coleção de scripts em Bash para automação de infraestrutura de rede em linux.
# Hospedado:  https://github.com/sandrodias-sysadmin/smart-infra
# Autor: Sandro Dias
# E-mail: sandrodias@gmail.com
#
# Caminho Absoluto: /smart-infra/install-smart-infra.sh
# Função: Levantar informações cruciais sobre o sistema, rede e etc guardando-as em variáveis
# Atualizado em: 23/03/2022
# Versao: 0.4
#
#

#echo -e "                                  --- = ---\n\n"
clear
echo -e "\n\n     +-----------------------------------------------------------------+\n     │                                                                 │\n     │         S  M  A  R  T      --- = ---     I  N  F  R  A          │\n     │                                                                 │\n     +-----------------------------------------------------------------+\n                           Preparando ambiente...\n\n"
echo -e "         Assumindo Privilégios Administrativos         [ Concluído. ]"
echo -e "         Criando Árvore de Diretórios                  [ Concluído. ]"
echo -e "         Buscando Informações da rede                  [ Executando ]"
echo -e "\n\n                                  --- = ---\n\n"
#
echo -e "                              INFORMAÇÕES DA REDE\n     +-----------------------------------------------------------------+\n"
# ################### INFORMAÇÕES DA REDE ####################
# Captura a quantidade de interfaces de rede detectadas
#
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
ip_gateway=$(ip route | awk '/default/ { print $3 }')
#
# Captura a interface de rede usada como rota para acessar o gateway detectado
interface_gateway=$(ip route | awk '/default/ { print $5 }')
#
# Captura o IP do DNS primário
ip_dns=$(systemd-resolve --status | grep "Current DNS Server:" | sed "s/  Current DNS Server: //")
#
# Captura o IP Externo
ip_externo=$(dig @ns1-1.akamaitech.net ANY whoami.akamai.net +short)
#
# Captura a Interface usada na rede
interface_usada_narede=$(ip -4 addr show | grep "state UP" | awk '{ print $2 }' | sed 's/://')
#
# Captura o IP Interno
ip_interno=$(ip -4 addr show dev $interface_usada_narede | grep inet | tr -s " " | cut -d" " -f3 | head -n 1 | sed 's/\/24//')
#
# Define o site da Google para teste de conexão e navegação
checksite=www.google.com
#
hostname=$(hostname)
#
#
echo -e "                        Relatório geral da rede atual"
sleep 1
echo -e "     ┌─────────────────────────────┬────────────────────────────────────┐"
echo -e "         Nome do Computador        │     $hostname"
sleep 1
echo -e "         Placas Detectadas         │     $qtd_interfaces"
sleep 1
echo -e "         Interface 1               │     $interface1"
sleep 1
echo -e "         Interface 2               │     $interface2"
sleep 1
echo -e "         Interface Usada na rede   │     $interface_usada_narede"
sleep 1
echo -e "          └> usando IP Local       │     $ip_interno"
sleep 1
echo -e "          └> usando IP Externo     │     $ip_externo"
sleep 1
echo -e "          └> usando Gateway        │     $ip_gateway"
sleep 1
echo -e "          └> usando DNS            │     $ip_dns"
sleep 1
echo -e "     └─────────────────────────────┴────────────────────────────────────┘"
echo -e "            O relatório pode ser consultatdo nos arquivos de LOG."
echo -e "\n\n                                  --- = ---\n\n"
read -p "         Proximo passo é instalar os Pré-requisitos... Pressione ENTER"
clear
echo -e "\n\n     +-----------------------------------------------------------------+\n     │                                                                 │\n     │         S  M  A  R  T      --- = ---     I  N  F  R  A          │\n     │                                                                 │\n     +-----------------------------------------------------------------+\n                           Preparando ambiente...\n\n"
echo -e "         Assumindo Privilégios Administrativos         [ Concluído. ]"
echo -e "         Criando Árvore de Diretórios                  [ Concluído. ]"
echo -e "         Buscando Informações da rede                  [ Concluído. ]"
echo -e "         Atualizando Repositórios e Lista de pacotes   [ Executando ]\n"
sudo apt-get update
echo -e "\n\n                                  --- = ---\n\n"
read -p "         Processo concluído... Pressione ENTER"

clear
echo -e "\n\n     +-----------------------------------------------------------------+\n     │                                                                 │\n     │         S  M  A  R  T      --- = ---     I  N  F  R  A          │\n     │                                                                 │\n     +-----------------------------------------------------------------+\n                           Preparando ambiente...\n\n"
echo -e "         Assumindo Privilégios Administrativos         [ Concluído. ]"
echo -e "         Criando Árvore de Diretórios                  [ Concluído. ]"
echo -e "         Buscando Informações da rede                  [ Concluído. ]"
echo -e "         Atualizando Repositórios e Lista de pacotes   [ Concluído. ]"
echo -e "         Atualizando a Distribuição Inteira            [ Executando ]\n"
sudo apt-get dist-upgrade -y
if [ $? = 0 ]; then
sudo echo "$date_installed F2" > /smart-infra/logs/status/installed.log
else
echo -e " Falha na atualização do Sistema.\n\n  Verifique sua internet..."
sudo rm -rf /smart-infra/
read -p "         Processo de instalação foi desfeito... Pressione ENTER"
exit
fi

echo -e "\n\n                                  --- = ---\n\n"
read -p "     Processo de Atualização do Sistema foi concluído... Pressione ENTER"

clear
echo -e "\n\n     +-----------------------------------------------------------------+\n     │                                                                 │\n     │         S  M  A  R  T      --- = ---     I  N  F  R  A          │\n     │                                                                 │\n     +-----------------------------------------------------------------+\n                           Preparando ambiente...\n\n"
echo -e "         Assumindo Privilégios Administrativos         [ Concluído. ]"
echo -e "         Criando Árvore de Diretórios                  [ Concluído. ]"
echo -e "         Buscando Informações da rede                  [ Concluído. ]"
echo -e "         Atualizando Repositórios e Lista de pacotes   [ Concluído. ]"
echo -e "         Atualizando a Distribuição Inteira            [ Concluído. ]"
echo -e "         Instalando pacotes essenciais ao ambiente     [ Executando ]\n"

sudo apt install -y figtlet neofetch git wget curl
if [ $? = 0 ]; then
sudo echo "$date_installed F3" > /smart-infra/logs/status/installed.log
else
echo -e " Falha na atualização do Sistema.\n\n  Verifique sua internet..."
sudo rm -rf /smart-infra/
read -p "         Processo de instalação foi desfeito... Pressione ENTER"
exit
fi
echo -e "\n\n                                  --- = ---\n\n"
read -p " Agora vamos configurar GITHUB para baixar o Smart Infra... Pressione ENTER"

sudo mkdir /github
sudo chmod 777 /github
clear
echo -e "\n\n     +-----------------------------------------------------------------+\n     │                                                                 │\n     │         S  M  A  R  T      --- = ---     I  N  F  R  A          │\n     │                                                                 │\n     +-----------------------------------------------------------------+\n                           Preparando ambiente...\n\n"
echo -e "         Assumindo Privilégios Administrativos         [ Concluído. ]"
echo -e "         Criando Árvore de Diretórios                  [ Concluído. ]"
echo -e "         Buscando Informações da rede                  [ Concluído. ]"
echo -e "         Atualizando Repositórios e Lista de pacotes   [ Concluído. ]"
echo -e "         Atualizando a Distribuição Inteira            [ Concluído. ]"
echo -e "         Instalando pacotes essenciais ao ambiente     [ Concluído. ]"
echo -e "         Clonando Projeto Smart Infra do GitHub        [ Executando ]"

echo -e "\n\n                                  --- = ---\n\n"
read -p " Agora vamos configurar GITHUB para baixar o Smart Infra... Pressione ENTER"


exit 0