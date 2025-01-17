# Définir le répertoire de base
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Inclure les fonctions utilitaires
source "$BASE_DIR/src/utils.sh"

# Fonction d'aide pour interroger l'utilisateur et ajouter des logiciels aux listes
function prompt_and_add() {
    local prompt="$1"
    local type="$2"
    shift 2
    local software=("$@")

    if read_user "${prompt}"; then
        if [[ "${type}" == "package" ]]; then
            package_list+=("${software[@]}")
        elif [[ "${type}" == "flatpak" ]]; then
            flatpak_list+=("${software[@]}")
        fi
    fi
}

# Fonction pour installer des logiciels utiles en fonction de la saisie de l'utilisateur
function install_useful_software() {
    echo "Installation des logiciels utiles."
    local package_list=()   # Liste des paquets à installer
    local flatpak_list=()   # Liste des flatpaks à installer

    # Utiliser la fonction d'aide pour l'interrogation
    prompt_and_add "|- Voulez-vous installer Discord ?" "package" "discord"
    prompt_and_add "|- Voulez-vous installer Steam ?" "package" "steam"
    prompt_and_add "|- Voulez-vous installer Lutris ?" "package" "lutris-git" "wine-staging"
    prompt_and_add "|- Voulez-vous installer Heroic Games Launcher (Epic Games/GOG) ?" "package" "heroic-games-launcher-bin"
    prompt_and_add "|- Voulez-vous installer protonup-qt ?" "package" "protonup-qt-bin"
    prompt_and_add "|- Voulez-vous installer Spotify ?" "package" "spotify"
    prompt_and_add "|- Voulez-vous installer OBS Studio (flatpak) ?" "flatpak" "com.obsproject.Studio"
    prompt_and_add "|- Voulez-vous installer LibreOffice ?" "package" "libreoffice-fresh" "libreoffice-fresh-fr"
    prompt_and_add "|- Voulez-vous installer Gimp ?" "package" "gimp"
    prompt_and_add "|- Voulez-vous installer VLC ?" "package" "vlc"
    prompt_and_add "|- Voulez-vous installer Visual Studio Code ?" "package" "visual-studio-code-bin"
    prompt_and_add "|- Voulez-vous installer Open RGB ?" "package" "openrgb-bin"

    # Installer les paquets de la liste package_list
    echo -e "|- Installation des paquets ${RED}(peut être long)${RESET}"
    for package in "${package_list[@]}"; do
        echo "|- Installation de ${package}."
        if ! $AUR_HELPER -S --needed --noconfirm "${package}" >> /dev/null 2>&1; then
            echo -e "${RED}Erreur lors de l'installation de ${package}${RESET}"
            exit 1
        fi
    done

    # Installer les flatpaks de la liste flatpak_list
    echo "|- Installation des flatpaks."
    for flatpak in "${flatpak_list[@]}"; do
        echo "|- Installation de ${flatpak}"
        if ! flatpak install flathub -y "${flatpak}" >> /dev/null 2>&1; then
            echo -e "${RED}Erreur lors de l'installation de ${flatpak}${RESET}"
            exit 1
        fi
    done

    echo "--------------------------------------------------"
}
