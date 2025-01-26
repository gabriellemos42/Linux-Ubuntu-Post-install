#!/usr/bin/env bash
#
# linux-postinstall.sh - Instala programas em distro Linux baseadas em ubuntu
#
# Autor: Gabriel Lemos
# ------------------------------------------------------------------------ #
#
# COMO USAR?
# Acesse a pasta onde está o arquivo, clique com o botão direito e dê permissão para execução do arquivo
# Abra o terminar nessa mesma pasta onde está o arquivo e execute o comando abaixo: 
#   $ ./linux-postinstall.sh
#
# ----------------------------- VARIÁVEIS ------------------------------- #

# Caso algum comando apresente erro, o Script será interrompido
set -e

##URLS
URL_TEAM_VIEWER="https://download.teamviewer.com/download/linux/teamviewer_amd64.deb"

#DIRETÓRIOS
DIRETORIO_DOWNLOADS="$HOME/Downloads/programas"

#CORES DE EXIBIÇÃO NO TERMINAL

VERMELHO='\e[1;91m'
VERDE='\e[1;92m'
SEM_COR='\e[0m'

#FUNÇÕES

# Atualizaçõa do repositório e do sistema

apt_update(){
    sudo apt update && sudo apt dist-upgrade -y
}

# ------------------------------------------------------------------------ #
# -------------------------------TESTES E REQUISITOS----------------------------------------- #

# Conexão com a Internet?
testes_internet(){
    if ! ping -c 1 8.8.8.8 -q &> /dev/null; then
        echo -e "${VERMELHO}[ERROR] - Seu computador não está conectado a Internet. Verifique a conexão Wi-Fi ou Cabeada.${SEM_COR}"
        exit 1
    else
        echo -e "${VERDE}[INFO] - Seu computador está conectado a Internet.${SEM_COR}"
    fi
}

# ------------------------------------------------------------------------------------------ #
## Atualização do Repositório ##
just_apt_update () {
    sudo apt update -y
}

#PROGRAMAS DEB PARA INSTALAÇÃO

    PROGRAMAS_PARA_INSTALAR=(
        virtualbox
        git
        wget
        ubuntu-restricted-extras
    )

# ------------------------------------------------------------------------ #

## Download e instalação dos programas DEB ##

install_debs () {
    echo -e "${VERDE}[INFO] - Baixando pacotes .deb${SEM_COR}"

    mkdir -p "$DIRETORIO_DOWNLOADS"
    wget -c "$URL_TEAM_VIEWER"      -P "$DIRETORIO_DOWNLOADS"

    ## Instalação de pacotes .deb baixados acima ##
    echo -e "${VERDE}[INFO] - Instalando pacotes .deb baixados${SEM_COR}"
    sudo dpkg -i $DIRETORIO_DOWNLOADS/*.deb

    # Instalação de programas no apt
    echo -e "${VERDE}[INFO] - Instalando pacotes direto do Repositório${SEM_COR}"

    for nome_do_programa in ${PROGRAMAS_PARA_INSTALAR[@]}; do
        if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não tiver instalado
            sudo apt install "$nome_do_programa" -y
        else 
            echo "[INSTALADO] - $nome_do_programa"
        fi
    done
    
}

## Instalando pacotes do FlatHub ##
install_flatpaks (){
    echo -e "${VERDE}[INFO] - Instalando os pacotes flatpack${SEM_COR}"

flatpak install flathub org.videolan.VLC -y
flatpak install flathub com.bitwarden.desktop -y
flatpak install flathub com.spotify.Client -y
flatpak install flathub org.gimp.GIMP -y
flatpak install flathub org.telegram.desktop -y
flatpak install flathub org.qbittorrent.qBittorrent -y
flatpak install flathub com.discordapp.Discord -y
flatpak install flathub com.valvesoftware.Steam -y
flatpak install flathub com.stremio.Stremio -y
flatpak install flathub org.audacityteam.Audacity -y
flatpak install flathub fm.reaper.Reaper -y
flatpak install flathub org.musescore.MuseScore -y
flatpak install flathub com.anydesk.Anydesk -y
flatpak install flathub org.filezillaproject.Filezilla -y
flatpak install flathub io.github.thetumultuousunicornofdarkness.cpu-x -y
flatpak install flathub com.rafaelmardojai.Blanket -y
flatpak install flathub com.visualstudio.code -y
flatpak install flathub io.github.diegoivan.pdf_metadata_editor -y
flatpak install flathub org.gnome.gitlab.YaLTeR.VideoTrimmer -y
flatpak install flathub com.warlordsoftwares.formatlab -y
flatpak install flathub org.kde.kstars -y
flatpak install flathub io.gitlab.theevilskeleton.Upscaler -y

}
# ------------------------------------------------------------------------ #
# ----------------------------- PÓS-INSTALAÇÃO ----------------------------- #
system_clean(){

apt_update -y
flatpak update -y
sudo apt autoclean -y
sudo apt autoremove -y
}
# ------------------------------------------------------------------------ #

# -------------------------------EXECUÇÃO----------------------------------------- #
testes_internet
apt_update
just_apt_update
install_debs
install_flatpaks
apt_update
system_clean

## Finalização

    echo -e "${VERDE}[INFO] - Script finalizado, instalação concluída! :)${SEM_COR}"
    echo -e "${VERDE}[INFO] - Agora é só aproveitar! rsrs ${SEM_COR}"
