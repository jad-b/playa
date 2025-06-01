Ansible playbook for setting up an Ubuntu machine.
Supports roles for home server and dev laptop.

**Ubuntu version** = 25.04

## how it works.

`./bootstrap.sh` installs Ansible and dependencies, and calls `./run.sh`

Use `./run.sh` to wrap the `ansible-playbook` command with required/good options in place.

Expected bootstrap flow:
1. Install OS
2. Copy this repo to machine with USB
3. Run `./bootstrap.sh <role>`

## roles.
system 
: Makes `sudo`-required changes, such as installing system packages and system-level configuration. 
Needs `-K` as a CLI flag.

user
: Sets up the user role for comfortable access.
Sets up SSH, symlinks in dotfiles, configures terminal profile & tools, etc. 
Makes changes at the `$HOME/` and below-level, thus it should _not_ need `sudo`. 

proglang
: Install programming languages.

homeserver
: Prepares the machine for a homeserver role.

laptop
: Prepares the machine for a personal laptop.

## notes.
The default user is `ansible_user`, which should be the user who's running `ansible-playbooks` (or `run.sh`).

## todo.
### homeserver
- `GRUB_CMDLINE_LINUX_DEFAULT=pcie_aspm=off`
### general
- Set gnome-terminal profile preferences using gconftool-2
- Install systemd service for [powertop](https://wiki.archlinux.org/index.php/Powertop#Apply_settings)
- Switch to 'intel' gfx card: `sudo prime-select intel`
- Run tpm/install_plugins
- Setup cron jobs for updating vim & tmux plugins.
- Setup cron job for running this playbook (monthly?)
- Setup Apt [unattended-upgrades]
- Fix touchpad area through startup script
  - http://pappanyn.me/blog/2017/05/03/ubuntu-and-the-dell-xps-9560-touchpad/
- Add startup scripts

[unattended-upgrades]: https://linoxide.com/ubuntu-how-to/enable-disable-unattended-upgrades-ubuntu-16-04/
