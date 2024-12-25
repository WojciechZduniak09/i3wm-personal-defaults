#! /bin/bash

# i3wm-defaults, a set of files for Debian virtual machines used for the i3 window manager.
#
# Copyright (C) 2024 Wojciech Zduniak <githubinquiries.ladder140@passinbox.com>
#
# This file is part of i3wm-defaults
#
# i3wm-defaults is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# i3wm-defaults is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with i3wm-defaults. If not, see <https://www.gnu.org/licenses/>.

cat <<EOF >&1
i3wm-defaults, a set of files for Debian virtual machines used for the i3 window manager.

Copyright (C) 2024 Wojciech Zduniak <githubinquiries.ladder140@passinbox.com>

This file is part of i3wm-defaults

i3wm-defaults is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
i3wm-defaults is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with i3wm-defaults. If not, see <https://www.gnu.org/licenses/>.
EOF

read -r -p "Press enter to continue . . . "


while true; do
	if sudo echo "Root access granted to installer."; then
		break
	fi
done

INIT_DIR="$PWD"
mkdir "$HOME"/Programs 2> /dev/null

install_dev_dependencies() {
	{
		sudo apt update 2> /dev/null
		echo "16"
		
		sudo apt install shellcheck vim git gcc g++ make valgrind gdb openssl -y 2> /dev/null
		echo "32"
		if ! code --version; then
			local VSCODE_EXPECTED_CHECKSUM="fbc5026ea43b81e08f1526bd6a75629cad6dec6111049f967aa45a9e36737749"
			if ! "$(wget -q https://code.visualstudio.com/sha/download?build=stable\&os=linux-deb-x64)" && code --version; then
				echo "wget error or vscode is already installed"
				exit 1
			fi
			echo "48"
			
			local VSCODE_OBTAINED_CHECKSUM
			VSCODE_OBTAINED_CHECKSUM=$(sha256sum vscode.deb | sed "s/ .*//g")
			if ! sha256sum vscode.deb; then
				echo "sha256sum error"
				exit 1
			elif [ "$VSCODE_EXPECTED_CHECKSUM" != "$VSCODE_OBTAINED_CHECKSUM" ]; then
				echo "checksums don't match"
				exit 1
			fi
			echo "64"
			
			sudo dpkg -i vscode.deb 2> /dev/null 1> /dev/null
			echo "80"
			
			rm rf vscode.deb
		fi
		echo "100"
	} | whiptail --title "Dependency installer" --gauge "Installing dev dependencies..." 10 26 0
	
	if git --version; then
		return
	fi

	{
		echo "14"
		
		local GIT_SSH_PATH
		GIT_SSH_PATH="$HOME/.ssh/git_global_ssh"
		echo "28"
		
		local GIT_USERNAME
		GIT_USERNAME=$(whiptail --title "Git setup" --inputbox "Insert your username for Git" --nocancel 8 50 3>&1 1>&2 2>&3)
		if ! git config --global user.name "$GIT_USERNAME"; then
			echo "git error"
			exit 1
		fi
		echo "42"
		
		local GIT_EMAIL
		GIT_EMAIL=$(whiptail --title "Git setup" --inputbox "Insert your email for Git" --nocancel 8 50 3>&1 1>&2 2>&3)
		if ! git config --global user.email "$GIT_EMAIL"; then
			echo "git error"
			exit 1
		fi
		echo "56"
		
		local PASSPHRASE
		PASSPHRASE=$(whiptail --title "Git setup" --passwordbox "Insert your passphrase for Git SSH" --nocancel 8 50 3>&1 1>&2 2>&3)
		if ! ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$GIT_SSH_PATH" -P "$PASSPHRASE" -q; then
			echo "openssl error"
			exit 1
		fi
		echo "70"
		
		if ! eval "$(ssh-agent -s)" | cut -d " " -f 3; then
			echo "Start SSH agent and retry"
			exit 1
		fi
		ssh-add "$GIT_SSH_PATH"
		echo "80"
		
		whiptail --title "Git setup" --msgbox "In order for git to finish setting up, add this public key to github: $(cat "$GIT_SSH_PATH.pub")" 30 50
		whiptail --title "Git setup" --msgbox "In order for git to finish setting up, set a repo's remote as git@github.com:$GIT_USERNAME/REPOSITORY.git" 30 50
		echo "100"
} | whiptail --title "Git setup" --gauge "Setting up git SSH..." 10 26 0
}


install_i3_dependencies() {
	{
		sudo apt update 2> /dev/null
		echo "50"
		# This if statement is specifically for Debian TTY interface-only systems
		if ! dpkg -l | grep -q -e "xinit"; then
			sudo apt install xinit -y 2> /dev/null
			sudo cp root/home/USER/.xinitrc "$HOME"/.xinitrc
		fi
		sudo apt install alacritty htop i3 neofetch feh i3blocks picom pulseaudio fonts-roboto -y 2> /dev/null
		sudo cp root/etc/i3blocks.conf /etc/i3blocks.conf
		sudo cp root/usr/share/i3blocks/volume /usr/share/i3blocks/volume
		cp root/home/USER/.config/i3/config "$HOME"/.config/i3/config
		local USERNAME=$(whoami)
		sed -i "s/set \$USERNAME USERNAME/set \$USERNAME $USERNAME/g" "$HOME"/.config/i3/config
		i3-msg "restart" 2> /dev/null 1> /dev/null
		echo "100"
	} | whiptail --title "Dependency installer" --gauge "Installing i3 dependencies..." 10 26 0
}


install_reverse_engineering_packages() {
	{
		sudo apt update 2> /dev/null
		echo "14"
		if ! java --version | grep -q -e "java 23" -e "java 22" -e "java 21" ; then
			# Java is required for Ghidra
			if ! wget -q https://download.oracle.com/java/23/latest/jdk-23_linux-x64_bin.deb; then
				echo "wget error!"
				exit 1
			fi
			echo "28"

			local JAVA_EXPECTED_SHA256_SUM
			JAVA_EXPECTED_SHA256_SUM="5ca258136aef3c82c40c30515cbe850a51a690887e31ba81ecfa9f96f978bd80"
			local JAVA_OBTAINED_SHA256_SUM
			JAVA_OBTAINED_SHA256_SUM=$(sha256sum jdk-23_linux-x64_bin.deb | sed "s/ .*//g")
			if ! sha256sum jdk-23_linux-x64_bin.deb; then
				echo "sha256sum error"
				exit 1
			elif [ "$JAVA_EXPECTED_SHA256_SUM" != "$JAVA_OBTAINED_SHA256_SUM" ]; then
				echo "checksums don't match"
				exit 1
			fi
			echo "42"

			if ! sudo dpkg -i jdk-23_linux-x64_bin.deb; then
				echo "dpkg error"
				exit 1
			fi
			sudo rm -rf jdk-23_linux-x64_bin.deb
		fi
		echo "56"
		
		rm -rf "$HOME"/Programs/ghidra_11.2.1_PUBLIC
		local GHIDRA_ZIP_PATH
		GHIDRA_ZIP_PATH="$HOME/Programs/ghidra_11.2.1_PUBLIC_20241105.zip"
		if ! wget -q https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.2.1_build/ghidra_11.2.1_PUBLIC_20241105.zip; then
			echo "wget error"
			exit 1
		fi
		echo "70"

		unzip "$GHIDRA_ZIP_PATH"
		rm -rf "$GHIDRA_ZIP_PATH"

		cp root/home/USER/.bash_aliases "$HOME"/.bash_aliases
		# shellcheck source=/dev/null
		source "$HOME/.bashrc"
		echo "100"
	} | whiptail --title "Dependency installer" --gauge "Installing reverse engineering dependencies..." 10 26 0
}


install_firefox() {
	if firefox --version; then
		return
	fi

	sudo rm -rf /etc/apt/sources.list.d/mozilla.list
	sudo install -d -m 0755 /etc/apt/keyrings

	wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null

	if ! gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); if($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") print "\nThe key fingerprint matches ("$0").\n"; else print "\nVerification failed: the fingerprint ("$0") does not match the expected one.\n"}'; then
		echo "Fingerprint error"
		exit 1
	fi

	echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null

	echo '
	Package: *
	Pin: origin packages.mozilla.org
	Pin-Priority: 1000
	' | sudo tee /etc/apt/preferences.d/mozilla 2> /dev/null

	sudo apt update 2> /dev/null

	sudo apt install firefox 2> /dev/null
}


install_systemd_units() {
	{
		sudo systemtl stop autoUpdate.timer 2> /dev/null 1> /dev/null  # we dont care if this fails
		sudo systemctl stop autoupdate.service 2> /dev/null 1> /dev/null # or this
		sudo rm -rf /etc/systemd/system/autoUpdate.service /etc/systemd/system/autoUpdate.timer
		sudo cp root/etc/systemd/system/autoUpdate.service /etc/systemd/system/autoUpdate.service
		sudo chmod 0744 /etc/systemd/system/autoUpdate.service
		echo "50"

		sudo cp root/etc/systemd/system/autoUpdate.timer /etc/systemd/system/autoUpdate.timer
		sudo chmod 0744 /etc/systemd/system/autoUpdate.timer
		sudo systemctl daemon-reload
		sudo systemctl start autoUpdate.timer
		sudo systemctl enable autoUpdate.timer
		echo "100"
	} | whiptail --title "Dependency installer" --gauge "Installing systemd units..." 10 26 0
}


install_repack_command() {
	{
		sudo cp "$PWD"/root/usr/bin/repack /usr/bin/repack
		sudo chmod 0755 /usr/bin/repack
		echo "100"
	} | whiptail --title "Dependency installer" --gauge "Installing quality-of-life commands..." 10 26 0
}


install_virtualbox() {
	if sudo apt install virtualbox-7.1 -y ; then
		return
	fi
	{
		echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian bookworm contrib" | sudo tee -a /etc/apt/sources.list
		echo "25"

		sudo apt update 2> /dev/null
		sudo apt install gpg -y 2> /dev/null
		echo "50"

		wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc -q | sudo gpg --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg --dearmor
		sudo rm -rf oracle_vbox_2016.asc
		echo "75"

		if sudo apt update 2> /dev/null; then
			sudo apt install virtualbox-7.1 -y 2> /dev/null
		else
			sudo -s -H
			sudo apt clean 2> /dev/null
			sudo rm -rf /var/lib/apt/lists/* 2> /dev/null
			sudo rm -rf /var/lib/apt/lists/partial/* 2> /dev/null
			sudo apt clean 2> /dev/null
			sudo apt update 2> /dev/null
			sudo apt-key remove 5CDFA2F683C52980AECF 2> /dev/null
			sudo apt-key remove D9C954422A4B98AB5139 2> /dev/null
			echo "VirtualBox installation error"
			exit 1
		fi
		echo "100"
	} | whiptail --title "Dependency installer" --gauge "Installing VirtualBox..." 10 26 0
}


if whiptail --title "Dependency installer" --yesno "Are you sure you want to install and set up all dependencies?" --yes-button "Install" --no-button "Abort" 9 26; then
	cd "$HOME"/Programs || exit 1
	install_firefox
	install_virtualbox
	install_reverse_engineering_packages
	cd "$INIT_DIR" || exit 1
	install_repack_command
	install_systemd_units
	install_dev_dependencies
	install_i3_dependencies
	echo "Done!"
else
	echo "Installation aborted!"
	exit 0
fi
