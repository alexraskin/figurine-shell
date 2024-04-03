# Figurine Shell

This was inspired by Alex's [Youtube Video](https://youtu.be/GPQ6k2GR17I?si=aThvA-4suKPz0HfJ) on how to create a custom greeting message for your terminal. He also wrote an ansible role to automate the process, check it out [here](https://github.com/ironicbadger/ansible-role-figurine)

This script just takes what he did and makes it easier to install and use.

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
sudo ./install.sh <your custom text>
```

4. Restart your shell session to see the greeting message.

## Usage

After installation, a greeting message will be displayed whenever you start a new shell session. You can customize the greeting message by editing the `/etc/profile.d/figurine.sh` script.

To display ASCII art using Figurine, run the `figurine` command followed by the name of the art file. For example:

```bash

figurine penguin
```

This will display the ASCII text for the word penguin. You can find more ASCII art files in the `/usr/local/share/figurine` directory.

## License

[MIT](https://choosealicense.com/licenses/mit/)

## Acknowledgements

[ironicbadger](https://github.com/ironicbadger)