#!/bin/bash

# ioncube_loader_installation

# PHP versions supported by ionCube
a=7.2
b=7.3
c=7.4
d=8.1
e=8.2

cd /usr/local/

# Download ionCube loaders
wget -q https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
tar -xf ioncube_loaders_lin_x86-64.tar.gz -C /usr/local

# Detect PHP version and OS
CURRENT=$(php -v | head -n 1 | cut -d " " -f 2 | cut -f1-2 -d"." )
DISTRO=$(grep "^ID=" /etc/os-release | cut -d"=" -f2 | tr -d '"')

echo "------------------------------------------------------"
echo " PHP version detected: $CURRENT"
echo " Operating System detected: $DISTRO"
echo "------------------------------------------------------"

# Validate PHP version support
SUPPORTED_VERSIONS=($a $b $c $d $e)

if [[ " ${SUPPORTED_VERSIONS[*]} " =~ " ${CURRENT} " ]]; then
    echo "Great! ionCube Loader is available for PHP $CURRENT."
else
    echo "⚠️ ionCube Loader is NOT available for PHP $CURRENT."
    echo "Skipping installation. Please upgrade PHP to 8.1, 8.2 or downgrade to 7.x."
    # Remove any existing invalid loader references
    INI_PATH="/usr/local/lsws/lsphp${CURRENT//./}/etc/php.d/00-ioncube.ini"
    if [ -f "$INI_PATH" ]; then
        rm -f "$INI_PATH"
        echo "Removed invalid ionCube configuration for PHP $CURRENT."
    fi
    exit 0
fi

# Function to install ionCube
install_ioncube () {
    PHP_VERSION=$1
    PHP_PATH="/usr/local/lsws/lsphp${PHP_VERSION//./}/"

    if [ "$DISTRO" = "ubuntu" ]; then
        cp ioncube/ioncube_loader_lin_${PHP_VERSION}.so ${PHP_PATH}lib/php/$(ls ${PHP_PATH}lib/php/)
        echo "zend_extension=ioncube_loader_lin_${PHP_VERSION}.so" >> ${PHP_PATH}etc/php/${PHP_VERSION}/mods-available/01-ioncube.ini
    elif [ "$DISTRO" = "centos" ] || [ "$DISTRO" = "almalinux" ]; then
        cp ioncube/ioncube_loader_lin_${PHP_VERSION}.so ${PHP_PATH}lib64/php/modules/
        echo "zend_extension=/usr/local/ioncube/ioncube_loader_lin_${PHP_VERSION}.so" > ${PHP_PATH}etc/php.d/00-ioncube.ini
    else
        echo "⚠️ Sorry, your OS ($DISTRO) is not supported by this script."
        exit 1
    fi

    systemctl restart lsws
    echo "✅ ionCube Loader for PHP $PHP_VERSION installed and LiteSpeed restarted successfully!"
}

# Install ionCube for the detected PHP version
install_ioncube $CURRENT

# Clean up
rm -f ioncube_loaders_lin_x86-64.tar.gz

echo "------------------------------------------------------"
echo " ionCube installation process completed!"
echo "------------------------------------------------------"
