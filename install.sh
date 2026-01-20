#!/usr/bin/env sh
#
# ============================================================= #
# Please report any issues in my attempts to make this script
# POSIX-compliant, thanks!
# -- Note: this does still rely on the GNU Coreutils. I will
#    be aiming to make this compatible with BusyBox and other
#    similar projects, but at the moment I do not have the
#    time to test this. I'm not sure whether or not DWM relies
#    on glibc or if it can be run with alternate C libraries.
#
echo "
# ============================================================= #
# Aur0rae's config of
#             ■■■■■■
#             ■    ■
#             ■    ■
#             ■    ■
#             ■    ■
#     ■■■■■■■■■    ■   ■■■■■   ■■■■■■■■■■■■■■■■■■■■■■■
#     ■            ■   ■   ■   ■                     ■
#     ■  ■■■■■■    ■■■■■   ■■■■■     ■■■■■   ■■■■■   ■
#     ■                              ■   ■   ■   ■   ■
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   ■■■■■   ■■■■■
#
# Thanks to Suckless Software, Chris Titus Tech, Glockenspiel,
# and all contributors to the DWM patches!
# ============================================================= #
"

# Check if this is running with root permissions - it should
# not be
if [ "$EUID" = 0 ]; then
	echo "Running this script as root may break things. Please run without superuser permissions."
	sleep 10
	exit 1
else
	# Set working directory
	TEMP_DIR=$(pwd)
fi

# Setup functions to make sure we have all deps met
deb_install() {
	# Refresh mirrors and update system
	sudo apt update
	sudo apt dist-upgrade

	# Install deps
	sudo apt install -y build-essential xorg libxft-dev libxinerama-dev xterm \
			pulseaudio feh bat eza fzf zoxide scrot
}

arch_install() {
	# Update system
	sudo pacman -Syu

	# Install deps
	sudo pacman -S --noconfirm base-devel xorg libx11 libxft libxinerama xterm \
			pulseaudio feh bat eza fzf zoxide scrot
}

void_install() {
	# Update system
	sudo xbps-install -Syu

	# Install deps
	sudo xbps-install -y base-devel xorg libX11-devel libXft-devel libXinerama-devel \
			xterm feh bat eza fzf zoxide scrot
}

# Function for user prompts
confirm() {
	while true; do
	        read -p "> Would you like to $1? (Y)es/(N)o: " var
	        case "$var" in
	                [yY][eE][sS]|[yY])
	                        $2
	                        break
	                ;;
			[nN][oO]|[nN])
				$3
				break
			;;
			*)
				echo "Error: unrecognized input."
			;;
		esac
	done
}

# Determine distribution
echo "Determining distribution and package manager."

if [ -f "/etc/os-release" ]; then
	. /etc/os-release
	case "$ID" in
		debian|*ubuntu*)
			echo "$ID detected. Using apt to update and install dependencies...\n"
			deb_install
			;;
		arch*|endeavour|manjaro|artix|cachyos)
			echo "$ID detected. Using pacman to update and install dependencies...\n"
			arch_install
			;;
		void)
			echo "$ID detected. Using xbps to update and install dependencies...\n"
			void_install
			;;
		*)
			# Catch exceptions for distros like Fedora, OpenSuSE, etc.
			echo "Sorry, package management on this distribution is not supported."
			confirm "continue" "break" "exit 1"
			;;
	esac
else
	# Catch exceptions if NO os-release is found
	echo "Error: /etc/os-release not found. Are you on Linux?\n"
	confirm "continue" "break" "exit 1"
fi

# Install DWM, Dmenu, and SLStatus
echo "Compiling DWM and other suckless software..."

for suckless in dwm dmenu slstatus; do
	if [ ! -d "$HOME/.${suckless}" ]; then
		cp -r $TEMP_DIR/src/${suckless} $HOME/.${suckless}
		cd $HOME/.${suckless}
 		make
		sudo make clean install
	else
		echo "${suckless} is already installed to ~/.${suckless}! Skipping."
	fi
done
echo "Finished Suckless Software installation!\n"

# Return to expected working directory
cd $TEMP_DIR

# Configure shell and graphical stuffs
echo "Configuring environment and Xorg..."

# Autostart DWM at login
echo "if [[ -z \$DISPLAY ]] && [[ \$(tty) = /dev/tty1 ]]; then\n\tstartx\nfi" > $HOME/.bash_profile
echo '#!/bin/sh\nexec dwm' > ~/.xinitrc;

# Make sure background is set
cp $TEMP_DIR/res/bg.jpg $HOME/.bg.jpg
echo "#!/bin/sh\nfeh --no-fehbg --bg-fill '$HOME/.bg.jpg'" > .fehbg

# XTerm dark theme
echo "XTerm*Background: black\nXTerm*foreground: white" > $HOME/.bash_profile

echo "Environment configured!\n"

# Notify user when script is done
echo "Installation completed successfully.\n\nRun 'startx' to launch DWM."
cd $HOME
