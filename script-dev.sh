#!/bin/bash
# Script de instalação interativo do ambiente de desenvolvimento de Maurício no Linux Mint

# -----------------------------
# Função para criar atalhos na área de trabalho
# -----------------------------
create_desktop_entry() {
  local name="$1"
  local exec="$2"
  local icon="$3"
  local file="$HOME/Área de Trabalho/$name.desktop"

  cat > "$file" <<EOL
[Desktop Entry]
Name=$name
Comment=$name
Exec=$exec
Icon=$icon
Terminal=false
Type=Application
Categories=Development;
EOL

  chmod +x "$file"
  echo "Atalho para $name criado na Área de Trabalho."
}

# -----------------------------
# Atualizar repositórios
# -----------------------------
echo "Atualizando repositórios..."
sudo apt update && sudo apt upgrade -y

# -----------------------------
# Remover programas indesejados
# -----------------------------
echo "Removendo Firefox e Thunderbird..."
sudo apt purge -y firefox* thunderbird*
sudo apt autoremove --purge -y
sudo apt clean

# Opcional: remover perfis de usuário (cache/configurações pessoais)
rm -rf ~/.mozilla
rm -rf ~/.thunderbird
echo "Firefox e Thunderbird removidos com sucesso."

# -----------------------------
# Instalar Google Chrome
# -----------------------------
echo "Baixando e instalando Google Chrome..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P ~/Downloads
sudo apt install -y ~/Downloads/google-chrome-stable_current_amd64.deb

# -----------------------------
# Instalar MySQL Server
# -----------------------------
echo "Instalando MySQL Server..."
sudo apt install mysql-server -y

echo "Configurando segurança do MySQL..."
sudo mysql_secure_installation

# -----------------------------
# Configurar MySQL para Workbench
# -----------------------------
echo "Criando usuário 'admin' para o Workbench..."
sudo mysql -e "CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY 'admin123';"
sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION;"
sudo mysql -e "FLUSH PRIVILEGES;"

# -----------------------------
# Instalar OpenJDK 21
# -----------------------------
echo "Instalando OpenJDK 21..."
sudo apt install openjdk-21-jdk -y
java -version
javac -version

# -----------------------------
# Instalar Git
# -----------------------------
echo "Instalando Git..."
sudo apt install git -y
git --version

# Configurar Git
read -p "Digite seu nome para o Git (user.name): " git_name
git config --global user.name "$git_name"

read -p "Digite seu e-mail para o Git (user.email): " git_email
git config --global user.email "$git_email"

echo "Git configurado:"
git config --list

# -----------------------------
# Instalar VS Code
# -----------------------------
echo "Por favor, baixe o VS Code (.deb 64-bit) e coloque na pasta ~/Downloads."
read -p "Digite o nome exato do arquivo do VS Code (ex: code_1.103.2-1755710123_amd64.deb): " vscode_file
sudo apt install ~/Downloads/"$vscode_file" -y

# Criar atalho do VS Code
create_desktop_entry "VS Code" "/usr/bin/code" "/usr/share/pixmaps/com.visualstudio.code.png"

# -----------------------------
# Instalar Eclipse
# -----------------------------
echo "Por favor, baixe o Eclipse (eclipse-inst-jre-linux64.tar.gz) e coloque na pasta ~/Downloads."
read -p "Digite o nome exato do arquivo do Eclipse: " eclipse_file
mkdir -p ~/Programas
tar -xzf ~/Downloads/"$eclipse_file" -C ~/Programas/
cd ~/Programas/eclipse-installer
echo "O instalador do Eclipse será iniciado. Siga as instruções da GUI para escolher a pasta e instalar."
./eclipse-inst &

# Criar atalho do Eclipse (após instalação, você pode ajustar o caminho do exec se necessário)
read -p "Digite o caminho do executável final do Eclipse (ex: /home/seu_usuario/Programas/eclipse/eclipse): " eclipse_exec
create_desktop_entry "Eclipse IDE" "$eclipse_exec" "$HOME/Programas/eclipse/icon.xpm"

# -----------------------------
# Instalar Snap e MySQL Workbench
# -----------------------------
echo "Preparando Snap para instalar MySQL Workbench..."
sudo rm -f /etc/apt/preferences.d/nosnap.pref
sudo apt update
sudo apt install snapd -y
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap || true

echo "Instalando MySQL Workbench via Snap..."
sudo snap install mysql-workbench-community --classic

# Criar atalho do Workbench
create_desktop_entry "MySQL Workbench" "/snap/bin/mysql-workbench-community" "/snap/mysql-workbench-community/current/meta/gui/icon.png"

# -----------------------------
# Conclusão
# -----------------------------
echo "Instalação e configuração completa!"
echo "Usuário MySQL para Workbench: 'admin', senha: 'admin123'."
echo "VS Code, Eclipse e Workbench estão disponíveis na Área de Trabalho e no menu."
