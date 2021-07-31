#/bin/sh MOD_PATH=./submodules
MOD_PATH="submodules"
YT_DLP_VERSION=2021.07.24

if [ -p "$MOD_PATH" ]; then
    echo "Please initialise git submodules"
    exit
fi

DOAS_PATH=$(which doas)
if [ -z "$DOAS_PATH" ]; then
    echo "Could not find doas executable, please install doas before continuing with the script!"
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

# Remove youtube-dl and replace its executable with yt-dlp one
doas apt remove -y youtube-dl
wget https://github.com/yt-dlp/yt-dlp/releases/download/$YT_DLP_VERSION/yt-dlp
wget https://github.com/yt-dlp/yt-dlp/releases/download/$YT_DLP_VERSION/SHA2-512SUMS

# Verify checksums
grep "yt-dlp$" SHA2-512SUMS > checksum
rm -rf SHA2-512SUMS

if [[ "$(sha512sum -c checksum)" != "yt-dlp: OK" ]]; then
    echo "Failed to verify yt-dlp checksum"
    exit
fi

echo "yt-dlp integrity verified"
chmod 0755 yt-dlp 
rm -rf checksum
doas mv yt-dlp /usr/local/bin/youtube-dl



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
