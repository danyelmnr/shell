#!/bin/bash

# install_ansible_public_key.sh
# Author: Danyel Mendes
# Email: danyel.mendes.ramos@gmail.com
# Date: 10.08.24 
# Descrição:
# This script adds the Ansible public key to the authorized_keys file
# of the current user to allow Ansible to connect to the machine via SSH.
# If the public key is already present, the script makes no changes.

# Armazenar IPs em uma lista
ips="192.168.1.1 192.168.1.2 192.168.1.3"

# Iterar sobre os IPs
for ip in $ips; do
 
  # Verifica se o host está acessível usando o comando ping
  if ! ping -c 1 "$ip" &> /dev/null; then
    echo "Error: Host $ip is not reachable."
    continue
  else
    echo "Host $ip is reachable. Installing Ansible public key..."
    ssh-copy-id -i ~/.ssh/id_rsa.pub -p 4140 ansible@$ip    
    echo "Completed processing for IP: $ip"
  fi  
done
