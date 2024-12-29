i3wm-defaults archived development news
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

v1.0.0
""""""""""

(1) Added auto-setup file.
(2) Added *README.md* along wiht *NEWS.rst* and *ONEWS.rst*.
(3) Added GPL3 license to project.
(4) Added systemd package autoupdater.
(5) Added custom *i3* and *i3blocks* configuration files and scripts.
(6) Added *xinit* script which probably won't work but trust me bro.
(7) Fixed *autoUpdate.timer* description syntax error.
(8) Made *autoUpdate.timer* repeat every 30 minutes for real this time.

v1.1.0
""""""""""

(1) Made *USERNAME* variable in *install.sh* declared separately from its definition.
(2) Added *ssh-agent* notice for Git setup in *install.sh*.
(3) Shortened *repack* command wait time from 5 seconds to 3 seconds for GPLv3 declaration to be both legible and not too long.
(4) Redefined project purpose for it to be for all Debian systems.
(5) Added more explanations on how to install *i3wm-defaults*.

v1.2.0
""""""""""

(1) Made *firefox* command not show errors.
(2) Made *gpg* install before it's use in the firefox installation.
(3) Added *2> /dev/null* in the Java check.

v1.3.0
""""""""""

(1) Changed *2> /dev/null* location.
(2) Added *1> /dev/null 2> /dev/null* to VSCode version check.
(3) Made Git installation an option.
(4) Made *i3 config* file and respective directories be created if they don't exist prior to installation.
(5) Made *i3init* systemd unit with a shared script to replace xinit and it's installation function.
(6) Added a reminder at the end of *install.sh* to reboot the system.
(7) Made *SIGNINT* possible in installer.
(8) Added *Ghidra* installation verifier.
(9) Fixed *VSCode* installation.
(10) Added *unzip* verification for *Ghidra*.
(11) Added *ltrace* and  *strace* to the reverse engineering installation.
(12) Removed redundant *vscode --version* in dev installation.
(13) Added *unzip* to the apt installation in the *Ghidra* download as it is not a default, preinstalled, package on Debian.
(14) Added *xterm* to i3 installation.
(15) Fixed Java installation.

v1.3.1
""""""""""

(1) Made a desktop environment's prior installation required (installations fail if not for some reason).
(2) Made *i3blocks network interface* be adaptable.
(3) Removed *i3init* systemd unit and it's executable.

Legal and copying statement
""""""""""""""""""""""""""""""""""""""""""

i3wm-defaults, a set of files for Debian systems which use the i3 window manager.

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