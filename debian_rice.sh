#/bin/sh
MOD_PATH=./submodules

# Check if the script is executed as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as a root"
    exit
fi

if [ ! -p $submodules ]; then
    echo "Please initialise git submodules"
    exit
fi

# Install all used programs
apt install -y \
    firefox-esr \
    imagemagick \
    libvulkan-dev \ 
    vulkan-validationLayers \
    autoconf \
    automake \
    c++-compiler \
    cmake \
    ctags \
    ffmpeg \
    mpv \
    gdb \
    gimp \
    xorg \
    xrandr \
    xsetroot \
    xfce4-screenshooter \
    nvidia \
    pulseaudio \
    syncthing \
    vifm \
    neovim \
    htop \
    neofetch \
    texlive-full \
    mupdf \
    nodejs \
    tor \
    thunderbird \
    transmission-cli \
    vagrant \
    barrier \
    libreoffice \
    python3 \
    python2 

# Copy all .config files over
if [[ ! -d "~/.config" ]]; then
    mkdir "~/.config"
fi

cp -r .config/* ~/.config
cp -r ~/.config/nvim/sysinit.vim /usr/share/nvim/
cp -r .bashrc ~/
cp -r .xinitrc ~/

# Compile and install dwm, st and dmenu
cd $MOD_PATH/dwm
make clean install
cd ../st
make clean install
cd $MOD_PATH/dmenu
make clean install

echo "Rice done!"
