# Nieuwe snelle wordpress server opzetten
Ubuntu + Nginx + Varnish + MySQL + PHP

Maak een nieuwe server aan:
Ubuntu 12.04 LTS

Log in op je nieuwe server:
ssh root@127.0.0.1
> voer wachtwoord in

Voeg een nieuwe gebruiker toe:
adduser reinier
> volg instructies op het scherm

Verander de shell van deze gebruiker:
chsh -s /bin/bash reinier

Voeg deze gebruik toe aan het sudo bestand:
echo "reinier ALL=(ALL) ALL" >> /etc/sudoers
exit

Log in als de niewuwe gebruiker:
ssh reinier@127.0.0.1

Update het OS:
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install build-essential

Installeer Nginx
sudo apt-get install nginx

Installeer PHP
sudo apt-get install php5-fpm php5 php-pear php5-suhosin php5-mysql


