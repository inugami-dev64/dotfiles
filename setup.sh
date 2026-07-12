#!/bin/sh

# Ensure that sudo is installed on the system
if [ -z "$(command -v sudo 2>/dev/null)" ]; then
    echo "sudo is not installed on the system, please install it and rerun the script"
    exit 127
fi

# Read system metadata variables
source ./scripts/source/system-metadata.sh

# Computer manufacturer
export MANUFACTURER="$(sudo dmidecode | grep -A1 --color=none '^System Information' | grep --color=none 'Manufacturer' | sed -r 's/^\t+Manufacturer: ([a-z0-9A-Z ]+)$/\1/g')"


setup_install_base_pkgs() {
    # Should tlp package be installed
    local tlp_package=""
    if [ $HAS_BATTERY -eq 1 ]; then
        tlp_package="tlp"
        if [ -n "$(command -v git 2>/dev/null)" ] && [ -n "$(command -v dialog 2>/dev/null)" ] && \
            [ -n "$(command -v gpg 2>/dev/null)" ] && [ -n "$(command -v curl 2>/dev/null)" ] && [ -n "$(command -v $tlp_package 2>/dev/null)" ]; then
            return 0
        fi
    elif [ -n "$(command -v git 2>/dev/null)" ] && [ -n "$(command -v dialog 2>/dev/null)" ] && \
        [ -n "$(command -v gpg 2>/dev/null)" ] && [ -n "$(command -v curl 2>/dev/null)" ]; then
        return 0
    fi

    case $DISTRO in
        arch)
            echo "Detected distribution Arch Linux, installing packages: git dialog gnupg curl $tlp_package"
            sudo pacman -Sy --noconfirm git dialog gnupg curl $tlp_package
            ;;
        fedora)
            echo "Detected distribution Fedora Linux, installing packages: git dialog gnupg2 curl $tlp_package"
            sudo dnf install -y git dialog gnupg2 curl $tlp_package
            ;;
        debian|ubuntu)
            echo "Detected distribution Debian Linux, installing packages: git dialog gnupg gnupg-agent curl $tlp_package"
            sudo apt install -y git dialog gnupg gnupg-agent curl $tlp_package
            ;;
        *)
            printf "Unsupported distribution '%s'\n" "$DISTRO"
            exit 127
            ;;
    esac
}

setup_choose_pkgs() {
    local dstfile="$1"

    dialog --title "Package selector" --checklist "Select packages to install and configure:" 15 70 5 \
        firefox "Firefox with arkenfox/user.js configuration" on \
        alacritty "Alacritty with custom configuration" on \
        tmux "tmux with custom keybindings configuration" on \
        neovim "Neovim with custom configuration" on \
        vscodium "VSCodium with a custom set of extensions" on \
        eid "Estonian ID card software" on 2> "$dstfile"
    clear
}

setup_symlink_configuration() {
    local dst="$1"
    local src="$2"
    local pkg="$3"

    echo "Configuring $pkg..."
    mkdir -p "$(echo $dst | sed -r 's/^(.*\)/.*$/\1/g')"

    if [ -f "$dst" ]; then
        read -p "Configuration file for $pkg exists. Override? (y/N) " opt
        case "$opt" in
            y*|Y*)
                rm "$dst"
                ;;
            *)
                continue
                ;;
        esac
    fi

    ln -s "$(realpath "$src")" "$dst"
}

setup_configure_software() {
    for pkg in $@; do
        case $pkg in
            firefox)
                echo "Configuring Firefox with arkenfox/user.js and custom overrides..."
                for ffprof in ~/.config/mozilla/firefox/*.default-release*; do
                    if [ -d "$ffprof" ]; then
                        curl -s https://raw.githubusercontent.com/arkenfox/user.js/refs/heads/master/prefsCleaner.sh -o "$ffprof/prefsCleaner.sh"
                        curl -s https://raw.githubusercontent.com/arkenfox/user.js/refs/heads/master/updater.sh -o "$ffprof/updater.sh"
                        chmod +x "$ffprof/prefsCleaner.sh" "$ffprof/updater.sh"
                        cp ./.config/firefox/user-overrides.js "$ffprof/user-overrides.js"

                        echo 1 | "$ffprof/prefsCleaner.sh"
                        echo Y | "$ffprof/updater.sh"
                    fi
                done
                ;;
            alacritty)
                setup_symlink_configuration ~/.config/alacritty/alacritty.toml ./.config/alacritty/alacritty.toml $pkg
                ;;
            tmux)
                setup_symlink_configuration ~/.config/tmux/tmux.conf ./.config/tmux/tmux.conf tmux
                ;;
            neovim)
                setup_symlink_configuration ~/.config/nvim/init.lua ./.config/nvim/init.lua $pkg
                read -p "Would you like to configure neovim for root user as well? (Y/n) " opt
                case $opt in
                    n*|N*)
                        continue
                        ;;
                esac
                sudo setup_symlink_configuration /root/.config/nvim/init.lua ./.config/nvim/init.lua $pkg
                ;;
            vscodium)
                ./.config/codium/install-ext.sh
                ;;
        esac
    done
}

setup_install_and_configure_arch() {
    local pacman_pkgs=""
    local aur_pkgs=""
    for pkg in $@; do
        case $pkg in
            firefox) pacman_pkgs="$pacman_pkgs firefox" ;;
            alacritty) pacman_pkgs="$pacman_pkgs alacritty" ;;
            tmux) pacman_pkgs="$pacman_pkgs tmux" ;;
            neovim) pacman_pkgs="$pacman_pkgs neovim" ;;
            vscodium) aur_pkgs="$aur_pkgs vscodium" ;;
            eid)
                pacman_pkgs="$pacman_pkgs ccid opensc"
                aur_pkgs="$aur_pkgs qdigidoc4 web-eid-native web-eid-firefox web-eid-chrome"
                ;;
        esac
    done

    echo "Installing pacman packages:$pacman_pkgs"
    sudo pacman -S --noconfirm $pacman_pkgs

    if [ -n "$aur_pkgs" ]; then
        # Install yay AUR helper if it's not present
        if [ -z "$(command -v yay 2>/dev/null)" ]; then
            echo "Installing yay AUR helper"
            sudo pacman -S --noconfirm base-devel
            local pwd="$(pwd)"
            cd /tmp
            git clone https://aur.archlinux.org/yay.git
            cd /tmp/yay
            makepkg -si
            cd "$pwd"
        fi

        # Install AUR packages
        yay -S $aur_pkgs
    fi

    setup_configure_software $@
}

setup_install_and_configure_fedora() {
    local dnf_pkgs=""
    for pkg in $@; do
        case $pkg in
            firefox) dnf_pkgs="$dnf_pkgs firefox" ;;
            alacritty) dnf_pkgs="$dnf_pkgs alacritty" ;;
            tmux) dnf_pkgs="$dnf_pkgs tmux" ;;
            neovim) dnf_pkgs="$dnf_pkgs neovim" ;;
            vscodium)
                sudo tee -a /etc/yum.repos.d/vscodium.repo << 'EOF'
[gitlab.com_paulcarroty_vscodium_repo]
name=gitlab.com_paulcarroty_vscodium_repo
baseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
metadata_expire=1h
EOF
                sudo dnf update
                dnf_pkgs="$dnf_pkgs codium"
                ;;
            eid)
                dnf_pkgs="$dnf_pkgs open-eid"
                ;;
        esac
    done

    sudo dnf install $dnf_pkgs
    setup_configure_software $@
}

setup_install_and_configure_debian() {
    local apt_pkgs=""
    for pkg in $@; do
        case $pkg in
            firefox) apt_pkgs="$apt_pkgs firefox-esr" ;;
            alacritty) apt_pkgs="$apt_pkgs alacritty" ;;
            tmux) apt_pkgs="$apt_pkgs tmux" ;;
            neovim) apt_pkgs="$apt_pkgs neovim" ;;
            vscodium)
                curl -s https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
                    | gpg --dearmor \
                    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg

                echo -e 'Types: deb\nURIs: https://download.vscodium.com/debs\nSuites: vscodium\nComponents: main\nArchitectures: amd64 arm64\nSigned-by: /usr/share/keyrings/vscodium-archive-keyring.gpg' \
                    | sudo tee /etc/apt/sources.list.d/vscodium.sources

                sudo apt update
                apt_pkgs="$apt_pkgs codium"
                ;;
            eid)
                curl -s https://installer.id.ee/media/install-scripts/install-open-eid.sh | sh
                ;;
        esac
    done

    sudo apt install $apt_pkgs
    setup_configure_software $@
}

setup_install_and_configure_ubuntu() {
    local apt_pkgs=""
    for pkg in $@; do
        case $pkg in
            firefox)
                sudo install -d -m 0755 /etc/apt/keyrings
                curl -s https://packages.mozilla.org/apt/repo-signing-key.gpg | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
                gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); if($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") print "\nThe key fingerprint matches ("$0").\n"; else print "\nVerification failed: the fingerprint ("$0") does not match the expected one.\n"}'
                sudo tee /etc/apt/sources.list.d/mozilla.sources > /dev/null << EOF
Types: deb
URIs: https://packages.mozilla.org/apt
Suites: mozilla
Components: main
Signed-By: /etc/apt/keyrings/packages.mozilla.org.asc
EOF
                sudo tee /etc/apt/preferences.d/mozilla > /dev/null << EOF
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
EOF
                sudo apt update
                apt_pkgs="$apt_pkgs firefox"
                ;;
            alacritty) apt_pkgs="$apt_pkgs alacritty" ;;
            tmux) apt_pkgs="$apt_pkgs tmux" ;;
            neovim) apt_pkgs="$apt_pkgs neovim" ;;
            vscodium)
                curl -s https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
                    | gpg --dearmor \
                    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg

                echo -e 'Types: deb\nURIs: https://download.vscodium.com/debs\nSuites: vscodium\nComponents: main\nArchitectures: amd64 arm64\nSigned-by: /usr/share/keyrings/vscodium-archive-keyring.gpg' \
                    | sudo tee /etc/apt/sources.list.d/vscodium.sources

                sudo apt update
                apt_pkgs="$apt_pkgs codium"
                ;;
            eid)
                curl -s https://installer.id.ee/media/install-scripts/install-open-eid.sh | sh
                ;;
        esac
    done

    sudo apt install $apt_pkgs
    setup_configure_software $@
}

setup_install_and_configure() {
    echo "Installing and configuring: $@"
    # Return early if no packages were selected
    echo "Distribution: $DISTRO"
    if [ $# -eq 0 ]; then
        return 0
    fi

    case $DISTRO in
        arch)
            setup_install_and_configure_arch $@
            ;;
        fedora)
            setup_install_and_configure_fedora $@
            ;;
        debian)
            setup_install_and_configure_debian $@
            ;;
        ubuntu)
            setup_install_and_configure_ubuntu $@
            ;;
        *)
            printf "Unsupported distribution '%s'\n" "$DISTRO"
            exit 127
            ;;
    esac
}

# Script entrypoint
setup_install_base_pkgs

# Ask the user for which packages to install
# and configure
TMP_FILE=$(mktemp)
trap "rm $TMP_FILE" EXIT
setup_choose_pkgs "$TMP_FILE"
mapfile -t SELECTED < "$TMP_FILE"

# Install and configure the packages
setup_install_and_configure ${SELECTED[*]}