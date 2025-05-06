# CyberPanel ionCube Loader Installer

This script automates the installation and configuration of the **ionCube Loader** for PHP on **CyberPanel** environments running **LiteSpeed** or **OpenLiteSpeed**.

## Features

- Detects your **PHP version** and **operating system** automatically (supports **CentOS**, **AlmaLinux**, and **Ubuntu**).
- Supports **ionCube Loader** for the following PHP versions:
  - **PHP 7.2, 7.3, 7.4, 8.1, 8.2**
- Automatically:
  - Downloads the correct **ionCube Loader**.
  - Installs and configures it for your LiteSpeed PHP instance.
  - Restarts **LiteSpeed** after installation.
- Detects **unsupported PHP versions** (e.g., **PHP 8.0**) and skips the installation with a friendly message.
- Removes invalid ionCube references for unsupported versions to prevent PHP errors.

## Usage

```bash
bash <(wget -qO- https://raw.githubusercontent.com/jesussuarz/cyberpanel-php-ioncube-installer/refs/heads/main/php_ioncube_install.sh)
```
## The script will:

- Detect your PHP version and OS.
- Check if ionCube Loader supports your PHP version.
- Install and configure ionCube Loader if supported.
- Clean up unnecessary files after installation.

## Notes

- **ionCube Loader does NOT support PHP 8.0.**  
  If PHP 8.0 is detected, the script will skip the installation and notify you.

## License

This project is licensed under the **MIT License**.

## Author

Developed by **Jesus Suarez**.  
Feel free to contribute or report issues!
