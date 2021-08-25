#/bin/sh MOD_PATH=./submodules
MOD_PATH="submodules"

DOAS_PATH=$(which doas)
if [ -z "$DOAS_PATH" ]; then
    echo "Could not find doas executable, please install doas before continuing with the script!"
    exit
fi

# Copy all .config files over
if [[ ! -d "~/.config" ]]; then
    echo "Creating configuration directory"
    mkdir -p "$(realpath ~/.config)"
fi

cp -r .config/* ~/.config
doas cp -r ~/.config/nvim/sysinit.vim /usr/share/nvim/
cp -r .bashrc ~/

# Change wallpaper path in xinitrc accordingly
CUR_PATH=$PWD/wallpapers
cat .xinitrc | sed "s|#WPP|$CUR_PATH|g" > ~/.xinitrc

echo "Done!"
