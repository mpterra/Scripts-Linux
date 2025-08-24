#!/bin/bash
# Script de limpeza para Linux Mint / Ubuntu

echo "🔄 Atualizando lista de pacotes..."
sudo apt update -y

echo "🛠 Corrigindo pacotes quebrados..."
sudo apt --fix-broken install -y

echo "🧹 Removendo pacotes inúteis..."
sudo apt autoremove -y

echo "🗑 Limpando cache de pacotes..."
sudo apt clean
sudo apt autoclean

echo "🧽 Limpando cache do usuário..."
rm -rf ~/.cache/*

echo "🌐 Limpando cache de navegadores (Chrome/Chromium/Brave/Firefox)..."
rm -rf ~/.cache/google-chrome/*
rm -rf ~/.cache/chromium/*
rm -rf ~/.cache/BraveSoftware/*
rm -rf ~/.cache/mozilla/firefox/*.default-release/cache2/*

echo "🔎 Verificando pacotes com problemas..."
sudo dpkg --configure -a

echo "✅ Limpeza concluída!"

# Mantém o terminal aberto até você apertar ENTER
read -p "Pressione ENTER para sair..."

