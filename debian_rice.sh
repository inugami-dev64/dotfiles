#/bin/sh
MOD_PATH=./submodules

if [ -p "$MOD_PATH" ]; then
    echo "Please initialise git submodules"
    exit
fi

# Install all used programs
doas apt install -y \
    firefox-esr \
    imagemagick \
    libvulkan-dev \
    vulkan-validationlayers \
    autoconf \
    automake \
    clang \
    gcc \
    cmake \
    feh \
    ffmpeg \
    mpv \
    gdb \
    gimp \
    xserver-xorg-core \
    xfce4-screenshooter \
    pulseaudio \
    syncthing \
    vifm \
    neovim \
    htop \
    neofetch \
    libx11-dev \
    libxft-dev \
    libxinerama-dev \
    mupdf \
    nodejs \
    tor \
    thunderbird \
    transmission-cli \
    vagrant \
    barrier \
    libreoffice \
    python3 \
    python2 \
    xinit

# Copy all .config files over
if [[ -d "~/.config" ]]; then
    echo "Creating configuration directory"
    mkdir -p "$(realpath ~/.config)"
fi

cp -r .config/* ~/.config
doas cp -r ~/.config/nvim/sysinit.vim /usr/share/nvim/
cp -r .bashrc ~/

# Change wallpaper path in xinitrc accordingly
CUR_PATH=$PWD/wallpapers
cat .xinitrc | sed "s|#WPP|$CUR_PATH|g" > ~/.xinitrc

# Compile and install dwm, st and dmenu
cd $MOD_PATH/dwm
doas make clean install
cd ../st
doas make clean install
cd ../dmenu
doas make clean install

echo "Rice done!"
