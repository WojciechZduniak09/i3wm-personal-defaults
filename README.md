# i3wm-personal-defaults #

## Index ##

1. [Legal and copying statement](#legal-and-copying-statement)
2. [What is this?](#what-is-this?)
3. [Installation](#installation)
4. [Contributors and methods of contact](#contributors-and-methods-of-contact)

## Legal and copying statement ##

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

## What is this? ##

*i3wm-personal-defaults* is a set of configuration files and scripts that add
quality-of-life improvements to the i3 window manager on Debian
Linux virtual machines. Its target audience is *supposed to be*
developers and reverse engineers who want an **easy-to-configure** and efficient
workspace.

** !! NOTE THAT THIS IS FOR AMD64 SYSTEMS ONLY !!

## Installation ##

There is only one way to install *i3wm-personal-defaults*, and that is to
use it's handy *install.sh* script. If anything goes wrong, please
feel free to contact a contributor (only me for now) for help or
run the commands from the installation script manually.

Remember that a desktop environment **must** be installed before running any scripts to avoid potential
errors.

Feel free to change any of the configuration files beforehand

Run these commands from a terminal in *i3wm-personal-defaults*' root directory:

```
    chmod 0744 install.sh (only required if you installed the zipfile)
    ./install.sh
```

**i3wm initalisation**

If you are using a system that has already got a desktop environment,
just log out and select i3 as the session's window manager. If not, it should boot
automatically. If it does not, then log into a TTY terminal, run *sudo xinit* and then
*sudo i3*. Remember to **not install the configuration file**.


**Git setup**

Afterwards you should add the provided public SSH key to your git remote 
(presumed GitHub in this tutorial for the sake of convenience, please refer to your 
remote's documentation if you are unsure of what to do).

Later, you should add this to any of the repositories you want to connect to GitHub:
    * If a remote has already been set earlier
        * ```git remote set-url REMOTE_NAME git@github:GITHUB_USERNAME/REPOSITORY_NAME.git```
    * If a remote has not yet been set
        * ```git remote add MAKE_UP_A_REMOTE_NAME git@github:GITHUB_USERNAME/REPOSITORY_NAME.git```

## Contributors and methods of contact ##

* Wojciech Zduniak. Contact via email at *githubinquiries.ladder140@passinbox.com*
