#/bin/bash

# All available themes
WALLPAPERS=("Yui" "Asuka" "Remu" "Felix" "Landscape" "None")

# This script assumes that two monitors are used
YUI_PAPERS=("yui1.png" "yui2.png")
ASUKA_PAPERS=("eva1.png" "eva2.png")
REMU_PAPERS=("remu1.png" "remu2.png")
FELIX_PAPERS=("ferris1.png" "ferris2.png")
LANDSCAPE_PAPERS=("landscape1.png" "landscape2.png")

# Change wallpaper path in xinitrc accordingly
CUR_PATH=$PWD/wallpapers
cat .xinitrc_template | sed -e "s|#WPP|$CUR_PATH|g" > .xinitrc

RED="\033[1;31m"
NO_COLOR="\033[0m"

# Warn the user about two monitor only support 
warn_prompt() {
    printf "\033[1;31mWARNING! THIS SCRIPT ASSUMES THAT YOU HAVE TWO MONITORS!\033[0m\n"
    read -p 'Proceed? (Y/n): ' confirm

    if [[ "${confirm}" == "N" ]] || [[ "${confirm}" == "n" ]]; then
        exit
    fi
}


# Check if doas is present
doas_check() {
    DOAS_PATH=$(command -v doas)
    if [ -z "$DOAS_PATH" ]; then
        echo "Could not find doas executable, please install doas before continuing with the script!"
        exit
    fi
}


# Link configuration files
link() {
    # Check if configs exist and delete them if needed
    if [ -e ~/.config ]; then
        printf "${RED}Removing pre-existing ~/.config${NO_COLOR}\n"
        rm -rf ~/.config
    fi
    
    if [ -e /usr/share/nvim/sysinit.vim ]; then
        printf "${RED}Removing pre-existing /usr/share/nvim/sysinit.vim${NO_COLOR}\n"
        doas rm /usr/share/nvim/sysinit.vim
    fi

    if [ -e ~/.bashrc ]; then
        printf "${RED}Removing pre-existing ~/.bashrc${NO_COLOR}\n"
        rm ~/.bashrc
    fi

    if [ -e ~/.xinitrc ]; then
        printf "${RED}Removing pre-existing ~/.xinitrc${NO_COLOR}\n"
        rm ~/.xinitrc
    fi


    ln -s $(realpath .config) $(realpath ~/.config)
    doas ln -s $(realpath .config/nvim/sysinit.vim) /usr/share/nvim/
    ln -s $(realpath .bashrc) $(realpath ~/)
    ln -s $(realpath .xinitrc) $(realpath ~/)
}


# Display all avaliable wallpapers to the user
display_wallpapers() {
    echo "Available wallpapers are following: "
    for i in "${WALLPAPERS[@]}"; do
        echo $i
    done
}


prompt_wallpaper() {
    while true; do
        read -p "Select your wallpaper: " user_wp
        
        found=0
        for i in "${WALLPAPERS[@]}"; do
            if [ "${i,,}" = "${user_wp,,}" ]; then
                found=1
                break
            fi
        done

        if [ ${found} = 0 ]; then
            echo "Invalid wallpaper, try again"
        else 
            break
        fi
    done
}


set_wallpaper() {
    case ${1,,} in
        "yui") 
            sed -i -e "s|#PIC1|${YUI_PAPERS[0]}|g" -e "s|#PIC2|${YUI_PAPERS[1]}|g" .xinitrc
            ;;

        "asuka")
            sed -i -e "s|#PIC1|${ASUKA_PAPERS[0]}|g" -e "s|#PIC2|${ASUKA_PAPERS[1]}|g" .xinitrc
            ;;

        "remu")
            sed -i -e "s|#PIC1|${REMU_PAPERS[0]}|g" -e "s|#PIC2|${REMU_PAPERS[1]}|g" .xinitrc
            ;;

        "felix")
            sed -i -e "s|#PIC1|${FELIX_PAPERS[0]}|g" -e "s|#PIC2|${FELIX_PAPERS[1]}|g" .xinitrc
            ;;

        "landscape")
            sed -i -e "s|#PIC1|${LANDSCAPE_PAPERS[0]}|g" -e "s|#PIC2|${LANDSCAPE_PAPERS[1]}|g" .xinitrc
            ;;
    esac
}

warn_prompt
doas_check
display_wallpapers
prompt_wallpaper
set_wallpaper $user_wp
link

echo "Done!"
