#!/bin/bash

# ioncube_loader_installation_for_all_php_versions

# PHP versions supported by ionCube
SUPPORTED_VERSIONS=(7.2 7.3 7.4 8.1 8.2)

cd /usr/local/

# Download ionCube loaders
wget -q https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
tar -xf ioncube_loaders_lin_x86-64.tar.gz -C /usr/local

# Detect OS
DISTRO=$(grep "^ID=" /etc/os-release | cut -d"=" -f2 | tr -d '"')
echo "------------------------------------------------------"
echo " Operating System detected: $DISTRO"
echo "------------------------------------------------------"

# Search for installed PHP versions
for PHP_PATH in /usr/local/lsws/lsphp*/; do
    PHP_BIN="${PHP_PATH}bin/php"
    if [ -x "$PHP_BIN" ]; then
        CURRENT=$($PHP_BIN -v | head -n 1 | cut -d " " -f 2 | cut -f1-2 -d".")
        echo ">> Detected PHP $CURRENT at $PHP_BIN"

        # Check if supported
        if [[ " ${SUPPORTED_VERSIONS[*]} " =~ " ${CURRENT} " ]]; then
            echo ">> Supported: Installing ionCube for PHP $CURRENT"

            if [ "$DISTRO" = "ubuntu" ]; then
                cp ioncube/ioncube_loader_lin_${CURRENT}.so ${PHP_PATH}lib/php/$(ls ${PHP_PATH}lib/php/)
                echo "zend_extension=ioncube_loader_lin_${CURRENT}.so" >> ${PHP_PATH}etc/php/${CURRENT}/mods-available/01-ioncube.ini
            elif [ "$DISTRO" = "centos" ] || [ "$DISTRO" = "almalinux" ]; then
                cp ioncube/ioncube_loader_lin_${CURRENT}.so ${PHP_PATH}lib64/php/modules/
                echo "zend_extension=/usr/local/ioncube/ioncube_loader_lin_${CURRENT}.so" > ${PHP_PATH}etc/php.d/00-ioncube.ini
            else
                echo "OS $DISTRO is not supported for PHP $CURRENT"
                continue
            fi

            echo "ionCube installed for PHP $CURRENT"
        else
            echo "ionCube is not available for PHP $CURRENT. Skipping..."
        fi
    fi
done

# Restart LiteSpeed once at the end
systemctl restart lsws

# Clean up
rm -f ioncube_loaders_lin_x86-64.tar.gz

echo "------------------------------------------------------"
echo " ionCube installation for all supported PHP versions completed!"
echo "------------------------------------------------------"
