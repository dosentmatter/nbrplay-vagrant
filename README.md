# *nbrplay-vagrant*

**nbrplay-vagrant** uses Vagrant and VirtualBox to convert `.arf` files into
`.mp4` files.
It works by running a Windows VM with the Webex
Network Recording Player (nbrplay) installed, so it should work on all OSs.
I have tested on macOS High Sierra.
The batch conversion is done by
[ARF-Converter](https://github.com/elliot-labs/ARF-Converter).

The idea was taken from
[nbr2mp4-vagrant](https://github.com/prakashsurya/nbr2mp4-vagrant).
nbr2mp4-vagrant only supports `.mp3` and not `.mp4`. It uses the `nbr2mp4` and
`nbr2mp3` Linux tools created by Cisco that are no longer supported. The only
supported converter is on Windows. `nbr2mp4-vagrant` is still a useful tool if
you only want `mp3`s.

The download for `nbr2mp4` is still
[available in some countries](http://static.webex.co.in/support/downloads.html).
However, I have tested it on an Ubuntu 9.04 machine, and only `nbr2mp3` works,
not `nbr2mp4`. I chose Ubuntu 9.04 because it is part of their
system requirements. I think the format of `.arf` has changed so `nbr2mp4` can
no longer handle them. This is the reason why I created **nbrplay-vagrant**.

## Installation

In order for nbrplay to convert `.arf` to `.mp4`, it needs a one time setup to
download a plugin. You might have seen this if you have used nbrplay, opened an
`.arf`, and selected "File > Convert Format > MP4 (MPEG-4)". It asks for
credentials to Webex to download some files.

I monitored the changes to the nbrplay directory and determined that it needed
a DLL called `libfaac.dll`. I know that FAAC is an open source project and
`libfaac.dll` is available online, but I have tried `libfaac.dll` `v1.29.9.2`
32-bit and 64-bit and they both don't work.

The open source `libfaac.dll` is also smaller in size compared to the nbrplay
one. nbrplay `libfaac.dll` is 440KB and has a sha256 hash of
`f2693ceacc09231a3843b4bde53963190ef4b211a650f21fb66e0c75511da82e`. I think
it might be proprietary so I won't be distributing it. You will need to grab it
yourself after setting it up through the GUI at
`C:\ProgramData\WebEx\WebEx\500\plugin\libfaac.dll`.

Steps:

1. Install VirtualBox.
2. Install Vagrant.
3. Clone this repository.
4. If you have `libfaac.dll`, place it in the root of this repo. It will be
   placed in the nbrplay directory in step 5. If not, you can skip this step
   but need to set it up in step 6. through the VirtualBox GUI.
5. Run `vagrant up --provision-with bootstrap`. This starts up the VM and
   installs necessary files and programs. If you provided `libfaac.dll`, the
   bootstrap script will copy `libfaac.dll` into the nbrplay directory.
6. Skip this step if you already have `libfaac.dll`. Open up VirtualBox and run
   the **nbrplay-vagrant** VM. Run nbrplay open an `.arf`, and select
   "File > Convert Format > MP4 (MPEG-4)". Type in your credentials. You can
   now close the VM, but if you shut it down, you need to run
   `vagrant up --no-provision` to start up the VM again. No need to bootstrap
   anymore unless you want to update the bootstrapped programs. At this point,
   you can go grab the nbrplay `libfaac.dll` for easy installation on other
   machines (no need for GUI).

## Usage

1. Start the VM with `vagrant up --no-provision` if you haven't already.
2. Put your `.arf` files in the `input` directory.
3. Run `vagrant provision`. When the conversion completes, your files will be in
   the `output` directory. Running again will overwrite your
   `output/*.mp4` files. There is no progress bar because `ARF-Converter`
   doesn't provide one, so test out a small `.arf` first. I have tested with
   two files - 1.2MB and 37MB. It takes a while because nbrplay is slow. Make
   sure your computer doesn't go to sleep and just let it run in the background.
4. When you are done, turn off the VM with `vagrant halt`.

Note: A shortcut is to just use `vagrant up` and `vagrant halt` since
`vagrant up` provisions by default.

## Upgrade

If you want to upgrade the programs used by **nbrplay-vagrant**, you can just
bootstrap again with `vagrant up --provision-with bootstrap` or
`vagrant provision --provision-with bootstrap` if the VM is already up.
