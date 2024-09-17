#!/bin/bash

# Autor: Danyel Mendes
# danyel.mendes@ifsertao-pe.edu.br
# Descricao: Script que insere um sistema debian no dominio ad.local
# Script: join-domain.sh

# remove o cliente e o servidor NTP nas máquinas que vão ingressar no domínio.
# O NTP.BR recomenda que somente o cliente NTP Chrony seja instalado nas máquinas administadas pelo DC
# Uma vez que o serviço NTP abre portas de servidor sem necessidade nas máquinas clientes NTP
echo -e "Removando o pacote NTP para evitar que o servidor seja instalado nos clientes NTP [...]\n"
apt-get -y remove ntp 

echo -e "Realizando a instalacao de pacotes necessarios para a  integracao do dominio [...] \n"
# Instalando pacotes essenciais
apt-get -y install krb5-user krb5-config winbind samba samba-common smbclient \
		cifs-utils libpam-krb5 libpam-winbind libnss-winbind chrony

echo -e "Criando o ponto de montagem para o volume do repositorio de arquivos [...] \n"
#cria o diretorio onde o servidor de arquivos sera montado
mkdir /mnt/nas-01

echo -e "Montando o volume do repostorio de arquivos de configuracao em NAS-01 [...] \n"
#montando o volume NAS-01 repositorio dos arquivos de configuracao
mount -t cifs //172.16.10x.x/Infra -o username=user,password=xxxxxxxx /mnt/nas-01

echo -e "Configura o arquivo de hosts de ${HOSTNAME} [...] \n"
#configura o arquivo /etc/hosts
echo "127.0.0.1       $HOSTNAME.ad.local   $HOSTNAME   localhost" > /etc/hosts
echo "172.16.107.22   bahia.ad.local" >> /etc/hosts

echo -e "Faz backup dos arquivos de configuracao originais [...] \n"
#faz backup dos arquivos de configuracao
cp /etc/chrony/chrony.conf /etc/chrony/chrony.conf.bkp
cp /etc/krb5.conf /etc/krb5.conf.bkp
cp /etc/samba/smb.conf /etc/samba/smb.conf.bkp
cp /etc/nsswitch.conf /etc/nsswitch.conf.bkp
cp /etc/pam.d/common-session /etc/pam.d/common-session.bkp
cp /etc/resolv.conf /etc/resolv.conf.bkp

echo -e "Obtem os arquivos de configuracao dos servicos em /mnr/NAS-01/Conf [...] \n"
#obtem arquivos no repositorio
cp /mnt/nas-01/conf/chrony.conf /etc/chrony/chrony.conf
cp /mnt/nas-01/conf/krb5.conf /etc/krb5.conf
cp /mnt/nas-01/conf/smb.conf /etc/samba/smb.conf
cp /mnt/nas-01/conf/nsswitch.conf /etc/nsswitch.conf
cp /mnt/nas-01/conf/common-session /etc/pam.d/common-session
cp /mnt/nas-01/conf/resolv.conf /etc/resolv.conf

echo -e "Configura o HOSTNAME do servidor $HOSTNAME corretamente no arquivo smb.conf [...] \n"
#re-configura o HOSTNAME no arquivo do samba com o hostname do sistema atual
sed -i "s/XXXXXXX/${HOSTNAME}/" /etc/samba/smb.conf

echo -e "Reiniciando servicos chrony, winbind e smbd [...] \n"
# reinicia chrony, winbind e smbd
function restart_services() {
	systemctl restart chrony.service 
	systemctl restart winbind.service
	systemctl restart smbd.service
}

echo -e "Integrando $HOSTNAME ao Dominio [AD.SERRATALHADA.IFSERTAO-PE.EDU.BR] ... \n"
#integrando a maquina ao dominio 
net ads join -UAdministrator%xxxxxxxxxxxxx

echo -e "Verificando integracao ao Dominio [AD.SERRATALHADA.IFSERTAO-PE.EDU.BR] ... \n"
#verificando se o dominio esta funcionando
net ads testjoin
wbinfo -t

echo -e "Reiniciando servicos chrony, winbind e smbd [...] \n"
#reinicia serviços
restart_services
# Exibe informacoes de nome de host, sistema e ip
echo -e "\nHost: $HOSTNAME \nIP: $(hostname -I) \nSistema: $(uname -a)";
