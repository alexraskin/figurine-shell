# Figurine Shell

This was inspired by Alex's [Youtube Video](https://youtu.be/GPQ6k2GR17I?si=aThvA-4suKPz0HfJ) on how to create a custom greeting message for your terminal. He also wrote an ansible role to automate the process, check it out [here](https://github.com/ironicbadger/ansible-role-figurine)

The script installs the Figurine package, which displays ASCII art text in your terminal. The script downloads the Figurine package, installs it, and configures it to display a greeting message when you log in to your shell.

> [!NOTE]
> The script will install the `amd64` version of the Figurine package. If you are using a different architecture, you can change the download URL in the script to match your system.

## Prerequisites

- Linux OS: This script is designed for Linux operating systems.
- Root Access: The script requires root access to move files to system directories (`/usr/local/bin/` and `/etc/profile.d/`).
- wget and tar: These tools must be installed on your system to download and unpack the Figurine package.

## Screenshots

[![Image from Gyazo](https://i.gyazo.com/492f779e3391efda8f32f4521d89437f.png)](https://gyazo.com/492f779e3391efda8f32f4521d89437f)

## Installation

1. Download the installation script:

```bash
wget https://raw.githubusercontent.com/alexraskin/figurine-shell/main/install.sh
```

2. Make the script executable:

```bash
chmod +x install.sh
```

3. Run the script with root privileges:

```bash
sudo ./install.sh 
```

4. Restart your shell session to see the greeting message.

## Usage

After installation, your system host name will be displayed at login. You can customize the greeting message by editing the `/etc/profile.d/figurine.sh` script.

To display ASCII art text using Figurine, run the `figurine` command followed by the name of the art file. For example:

```bash

figurine -f "3d.flf" cat
```

This will display the ASCII text for the word cat. You can find more ASCII art files [here](https://github.com/arsham/figurine/tree/master/figurine/fonts).

## License

[MIT](https://choosealicense.com/licenses/mit/)

## Acknowledgements

[ironicbadger](https://github.com/ironicbadger)
[arsham](https://github.com/arsham/figurine)
