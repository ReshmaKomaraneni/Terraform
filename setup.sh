#!/bin/bash
sudo apt update -y
sudo apt install nginx -y
sudo rm -rf /var/www/html/*
sudo git clone https://github.com/ReshmaKomaraneni/ecomm.git /var/www/html