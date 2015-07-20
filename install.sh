#!/usr/bin/env bash

# Aishee Developer

clear
sleep(2)
echo "
##############################################################
#              Aishee Script - Auto backup job               #
#							                                               #
#          GitHub: https://github.com/aishee                 #
#                   http://aishee.net                        #
#      Copyright (C) 2015                                    #
##############################################################
"
echo "Welcome!"
echo
echo "Please make sure that your server"
echo "is running a fresh and minimal OS Installation"
echo "This script may install additional software packages"

echo "Press [Enter] key to start the installation or CTRL+C to abort..."
read -s -n 1 readEnterKey

while [ "$readEnterKey" != "" ]
do
    echo "Press [Enter] key to start the installation or CTRL+C to abort..."
    read -s -n 1 readEnterKey
done

arch=$(uname -a)

function cmd_exists() {
    hash ${1} 2>/dev/null
    return $?
}

if cmd_exists 'apt-get'; then
    echo "Updating your system..."
    apt-get -qy update && apt-get -qy upgrade
    apt-get -qy install apache2 git php5 php5-cli php5-mcrypt php5-mysql sendmail sendmail-bin libapache2-mod-php5 wget curl
    cd /var
    git clone https://github.com/aishee/JobMo-Backup.git
    rm -rf www
    mv cdp www
    cd www
    mv htaccess.txt .htaccess
    sed -i "s|/var/www/html|/var/www|g" config.php
    mkdir files
    mkdir templates_c
    mkdir configs
    mkdir cache
    chmod -R 777 files templates_c configs cache
    chmod -R 777 db/*.json
    service sendmail start
    service apache2 restart
elif cmd_exists 'yum'; then

    echo "Installing EPEL..."
    if [[ $arch == *x86_64* ]]
    then
        wget -q http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
        rpm -ivh epel-release-6-8.noarch.rpm
    else
        wget -q http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
        rpm -ivh epel-release-6-8.noarch.rpm
    fi
    
    echo "Updating your system..."
    yum -y -q update

    echo "Installing required packages..."
    yum -y -q install git httpd php php-cli php-mcrypt php-mysql php-pdo sendmail wget curl

    echo "Downloading CDP.me main package..."
    cd /var/www/
    git clone https://github.com/aishee/JobMo-Backup.git
    rm -rf html
    mv cdp html
    cd html
    mv htaccess.txt .htaccess
    mkdir files
    mkdir templates_c
    mkdir configs
    mkdir cache
    chmod -R 777 files templates_c configs cache
    chmod -R 777 db/*.json
    service sendmail start
    service httpd restart
    
else
    echo "OS/Package manager not supported; exiting."
    exit
fi

publicip=$(wget --prefer-family=ipv4 -qO - api.petabyet.com/ip)

clear

echo "Successfully installed"
echo "The web interface can be accessed at"
echo "http://${publicip}/index.php"
echo "The default login detail is:"
echo "Username: admin"
echo "Password: password"
echo "You may update the username and password"
echo "by editing config.php located in your web"
echo "server's document root"
echo ""
echo "======================="
echo "!!IMPORTANT!!"
echo "Please ensure AllowOverride"
echo "directive is set to All"
echo "in <Directory> sections"
echo "of the Apache configuration file,"
echo "To allow .htaccess to work"
echo "======================="
echo ""
echo "Thank you for choosing CDP.me!"
echo ""
#curl -k http://aishee.net
#echo ""
