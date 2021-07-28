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
xbps-install -Sy \
    firefox-esr \
    ImageMagick \
    Vulkan-Headers \ 
    Vulkan-Tools \
    Vulkan-ValidationLayers \
    autoconf \
    automake \
    clang \
    cmake \
    ctags \
    ffmpeg \
    mpv \
    gcc \
    gdb \
    gimp \
    xorg-minimal \
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
    texlive \
    mupdf \
    nodejs \
    tor \
    thunderbird \
    transmission \
    vagrant \
    autoconf \
    automake \
    barrier \
    libreoffice \
    python3

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
