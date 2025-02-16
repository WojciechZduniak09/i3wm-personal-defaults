#! /bin/bash

# i3wm-personal-defaults, a set of files for Debian systems which use the i3 window manager.
#
# Copyright (C) 2024, 2025 Wojciech Zduniak <githubinquiries.ladder140@passinbox.com>
#
# This file is part of i3wm-personal-defaults
#
# i3wm-personal-defaults is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# i3wm-personal-defaults is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with i3wm-personal-defaults. If not, see <https://www.gnu.org/licenses/>.

cat <<EOF >&1
i3wm-personal-defaults, a set of files for Debian systems which use the i3 window manager.

Copyright (C) 2024, 2025 Wojciech Zduniak <githubinquiries.ladder140@passinbox.com>

This file is part of i3wm-personal-defaults

i3wm-personal-defaults is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
i3wm-personal-defaults is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with i3wm-personal-defaults. If not, see <https://www.gnu.org/licenses/>.
EOF

read -r -p "Press enter to continue . . . "

trap "exit 1" SIGINT

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
		echo "50"
		
		sudo apt install shellcheck vim git gcc g++ make valgrind gdb openssl -y 2> /dev/null
		echo "100"
	} | whiptail --title "Dependency installer" --gauge "Installing dev dependencies..." 10 26 0
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
		local INTERFACE
		INTERFACE=$(ip addr show | grep "2:" | sed "s/2: //g" | cut -d : -f1 | head -n 1)
		sudo apt install xinit xterm alacritty htop i3 neofetch feh i3blocks picom pulseaudio fonts-roboto -y 2> /dev/null
		sudo cp root/etc/i3blocks.conf /etc/i3blocks.conf
		sudo sed -i "s/INTERFACE/$INTERFACE/g" /etc/i3blocks.conf
		sudo cp root/usr/share/i3blocks/volume /usr/share/i3blocks/volume
		sudo mkdir /usr/share 2> /dev/null
		cp root/home/USER/.config/i3/config "$HOME"/.config/i3/config
		local USERNAME
		USERNAME=$(whoami)
		sed -i "s/set \$USERNAME USERNAME/set \$USERNAME $USERNAME/g" "$HOME"/.config/i3/config
		i3-msg "restart" 2> /dev/null 1> /dev/null
		echo "100"
	} | whiptail --title "Dependency installer" --gauge "Installing i3 dependencies..." 10 26 0
}


install_reverse_engineering_packages() {
	sudo apt install wireshark tcpdump -y 2> /dev/null
	{
		sudo apt update 2> /dev/null
		sudo apt install ltrace strace -y 2> /dev/null
		echo "14"
		if java --version  2> /dev/null | grep -q -e "java 23" -e "java 22" -e "java 21"; then
			echo "56"
		else
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

			if ! sudo dpkg --install jdk-23_linux-x64_bin.deb; then
				echo "dpkg error"
				exit 1
			fi
			sudo rm -rf jdk-23_linux-x64_bin.deb
			echo "56"
		fi
		if stat "$HOME"/Programs/ghidra_11.3_PUBLIC 2> /dev/null; then
			echo 100
			return
		fi
		sudo apt install unzip -y 2> /dev/null
		rm -rf "$HOME"/Programs/ghidra_11.3_PUBLIC
		rm -rf "$HOME"/Programs/ghidra_11.3_PUBLIC_20250205.zip
		local GHIDRA_ZIP_PATH
		GHIDRA_ZIP_PATH="$HOME/Programs/ghidra_11.3_PUBLIC_20250205.zip"
		if ! wget -q https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.3_build/ghidra_11.3_PUBLIC_20250205.zip; then
			echo "wget error"
			exit 1
		fi
		echo "70"

		if ! unzip "$GHIDRA_ZIP_PATH"; then
			echo "unzip failure"
			exit 1
		fi
		rm -rf "$GHIDRA_ZIP_PATH"
		echo "100"
	} | whiptail --title "Dependency installer" --gauge "Installing reverse engineering dependencies..." 10 26 0
}


install_firefox() {
	if firefox --version 2> /dev/null; then
		return
	fi

	sudo rm -rf /etc/apt/sources.list.d/mozilla.list
	sudo install -d -m 0755 /etc/apt/keyrings

	sudo apt update
	sudo apt install gpg -y

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
		sudo systemctl restart autoUpdate.timer
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


install_bash_aliases() {
	{
		cp root/home/USER/.bash_aliases "$HOME"/.bash_aliases
		echo "100"
	} | whiptail --title "Dependency installer" --gauge "Installing .bash_aliases..." 10 26 0
	#shellcheck source=/dev/null
	source "$HOME"/.bashrc
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
	mkdir "$HOME"/.config 2> /dev/null
	mkdir "$HOME"/.config/i3 2> /dev/null
	touch "$HOME"/.config/i3/config 2> /dev/null
	install_firefox
	install_virtualbox
	install_reverse_engineering_packages
	cd "$INIT_DIR" || exit 1
	install_repack_command
	install_systemd_units
	install_dev_dependencies
	install_i3_dependencies
	install_bash_aliases
	echo "Done!"
	echo "Log in again with i3 to use all of the changes."
else
	echo "Installation aborted!"
	exit 0
fi
