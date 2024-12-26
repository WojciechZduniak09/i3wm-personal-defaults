# i3wm-defaults #

## Index ##

1. [Legal and copying statement](#legal-and-copying-statement)
2. [What is this?](#what-is-this?)
3. [Installation](#installation)
4. [Contributors and methods of contact](#contributors-and-methods-of-contact)

## Legal and copying statement ##

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

## What is this? ##

*i3wm-defaults* is a set of configuration files and scripts that add
quality-of-life improvements to the i3 window manager on Debian
Linux virtual machines. It's target audience is *supposed to be*
developers and reverse engineers who want an **easy-to-configure**
and **lightweight** Linux system.

## Installation ##

There is only one way to install *i3wm-defaults*, and that is to
use it's handy *install.sh* script. If anything goes wrong, please
feel free to contact a contributor (only me for now) for help or
run the commands from the installation script manually.

Run these commands from a terminal in *i3wm-defaults*' root directory:

```
    chmod 0744 install.sh
    ./install.sh
```

Afterwards you should add the provided public SSH key to your git remote 
(presumed GitHub in this tutorial for the sake of convenience, please refer to your 
remote's documentation if you are unsure of what to do).

Later, you should add this to any of the repositories you want to connect to GitHub:


**If a remote has already been set earlier**
```
    git remote set-url REMOTE_NAME git@github:GITHUB_USERNAME/REPOSITORY_NAME.git
```


**If no remote has yet been set**
```
    git remote add MAKE_UP_A_REMOTE_NAME git@github:GITHUB_USERNAME/REPOSITORY_NAME.git
```


## Contributors and methods of contact ##


* Wojciech Zduniak. Contact via email at *githubinquiries.ladder140@passinbox.com*
