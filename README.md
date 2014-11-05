# Puppet module for installing chef server 

Installs chef server

# Installation

## Using GIT

git clone git://github.com/theforeman/puppet-chef.git

# Requirements

Only really tested on RedHat and Debian. Patches welcome for other OSes :)

# Setup

This is a parameterized class, but the defaults should get you going:

Standalone agent with defaults:

    echo include chef | puppet --modulepath /path_to/extracted_tarball

# Contributing

* Fork the project
* Commit and push until you are happy with your contribution

# More info

See http://theforeman.org or at #theforeman irc channel on freenode

Copyright (c) 2010-2012 Ohad Levy

This program and entire repository is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
