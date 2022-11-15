#!/bin/bash -e
clear

echo "db   db db    db d8888b. d8888b. d888888b d8888b.      /\ "
echo "88   88  8b  d8' 88   8D 88   8D    88'   88   8D     (  )"
echo "88ooo88   8bd8'  88oooY' 88oobY'    88    88   88     (  )"
echo "88   88    88    88   b. 88 8b      88    88   88    /|/\|\ "
echo "88   88    88    88   8D 88  88.   .88.   88  .8D   /_||||_\ "
echo "YP   YP    YP    Y8888P' 88   YD Y888888P Y8888D'  /-_|  |_-\ "
echo ""
echo "========================================================================================="


echo "This script installs the following:"
echo " - Latetest Wordpress version,"
echo " - Multi environment (optional)"
echo " - Plugins: Yoast SEO, Ninja Forms, Migrate DB, WP Mail SMTP, Duplicate post, Autoptimize, Lazy Loader, Redirection, Timber (optional)"
echo " - Theme: Our default Wordpress theme"
echo " - Node modules"
echo ""
echo "IMPORTANT NOTE:"
echo "You need xcode installed on your computer, otherwise you will encounter some issues"
echo "========================================================================================="
echo ""
echo ""
echo "======================================================="
echo "Do you want to install in current folder (y/n)"
echo "======================================================="
read -e currentinstallfolder
if [ "$currentinstallfolder" = "y" ]; then
    fullpath=$(pwd)
else
    echo ""
    echo "======================================================="
    echo "Full path where to install Wordpress: "
    echo "======================================================="
    read -e fullpath
fi
#check if the path exists
if [ ! -d "$fullpath" ]; then
echo ""
echo "======================================================="
echo "Sorry this directory doesn't exists on your computer"
echo "======================================================="
echo ""
exit
fi
echo ""
echo "======================================================="
echo "                  LOCAL ENVIRONMENT"
echo "======================================================="
echo ""
echo "======================================================="
echo "Local - URL: "
echo "======================================================="
read -e localurl
echo ""
echo "======================================================="
echo "Local - Host: "
echo "======================================================="
read -e localhost
echo ""
echo "======================================================="
echo "Local - Database Name: "
echo "======================================================="
read -e localdatabase
echo ""
echo "======================================================="
echo "Local - Database User: "
echo "======================================================="
read -e localusername
echo ""
echo "======================================================="
echo "Local - Database Password: "
echo "======================================================="
read -s localpassword
echo ""
echo "======================================================="
echo "Do you want to add a multi-environment? (y/n)"
echo "======================================================="
read -e multi
if [ "$multi" = "y" ]; then
    echo ""
    echo "======================================================="
    echo "                 STAGING ENVIRONMENT"
    echo "======================================================="
    echo ""
    echo "======================================================="
    echo "Staging - URL:"
    echo "======================================================="
    read -e stagingurl
    echo ""
    echo "======================================================="
    echo ""
    echo "Staing - Host:"
    echo "======================================================="
    read -e staginghost
    echo ""
    echo "======================================================="
    echo "Staging - Database Name:"
    echo "======================================================="
    read -e stagingdatabase
    echo ""
    echo "======================================================="
    echo "Staging - Database User:"
    echo "======================================================="
    read -e stagingusername
    echo ""
    echo "======================================================="
    echo "Staging Database Password:"
    echo "======================================================="
    read -s stagingpassword
    echo ""
    echo "======================================================="
    echo "               PRODUCTION ENVIRONMENT"
    echo "======================================================="
    echo ""
    echo "======================================================="
    echo "Production - URL:"
    echo "======================================================="
    read -e productionurl
    echo ""
    echo "======================================================="
    echo "Production - Host:"
    echo "======================================================="
    read -e productionhost
    echo ""
    echo "======================================================="
    echo "Production - Database Name:"
    echo "======================================================="
    read -e productiondatabase
    echo ""
    echo "======================================================="
    echo "Production - Database User:"
    echo "======================================================="
    read -e productionusername
    echo ""
    echo "======================================================="
    echo "Production - Database Password:"
    echo "======================================================="
    read -s productionpassword
else
    echo ""
    echo "No multi-environment is created."
    
fi

echo ""
echo "======================================================="
echo "Do you want to install the default theme ? (y/n)"
echo "======================================================="
read -e defaulttheme
if [ "$defaulttheme" = "y" ]; then
echo ""
echo "======================================================="
echo "Do you want to install timber plugin (y/n)"
echo "======================================================="
read -e timber
echo ""
echo "======================================================="
echo "Do you already want to add the GTM tag? (y/n)"
echo "======================================================="
read -e gtm
if [ "$gtm" = "y" ]; then
    echo ""
    echo "======================================================="
    echo "Enter your GTM tag here:"
    echo "======================================================="
    read -e gtmtag
else
    echo "Remember to enter your GTM tag afterwards. You can find it in the header.php file"
fi
else
    echo "======================================================="
    echo "Enter the zip path of the theme"
    echo "======================================================="
    read -e themepath
fi #default theme endif
echo ""
echo "======================================================="
echo "Run the installation? (y/n)"
echo "======================================================="
read -e run
if [ "$run" == n ] ; then
exit
else
echo "======================================================="
echo "Wait a minute, we are now installing everything for you"
echo "======================================================="
echo ""
echo ""
#change dir to wordpress
cd 
cd $fullpath/


#download wordpress
curl -O https://wordpress.org/latest.tar.gz

#unzip wordpress
tar -zxvf latest.tar.gz

#go to the wordpress folder
cd wordpress

#create wp config
if [ "$multi" = "n" ]; then
    cp wp-config-sample.php wp-config.php
    rm wp-config-sample.php

    #set database details for development
    perl -pi -e "s/localhost/$localhost/g" wp-config.php
    perl -pi -e "s/database_name_here/$localdatabase/g" wp-config.php
    perl -pi -e "s/username_here/$localusername/g" wp-config.php
    perl -pi -e "s/password_here/$localpassword/g" wp-config.php

    #set WP salts
    perl -i -pe'
    BEGIN {
        @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
        push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";
        sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
    }
    s/put your unique phrase here/salt()/ge
    ' wp-config.php
else
    #git clone multi environment
    git clone git@bitbucket.org:hybrid_media/wp-multi-environment.git

    #move files out of folder into the root folder
    cp -rp wp-multi-environment/ ./

    #remove wp-multi-environment folder
    rm -rf wp-multi-environment
    
    #delete sample config
    rm wp-config-sample.php

    #set database details for development
    perl -pi -e "s/localhosthere/$localhost/g" wp-config/wp-config.development.php
    perl -pi -e "s/localdatabasehere/$localdatabase/g" wp-config/wp-config.development.php
    perl -pi -e "s/localusernamehere/$localusername/g" wp-config/wp-config.development.php
    perl -pi -e "s/localpasswordhere/$localpassword/g" wp-config/wp-config.development.php

    #set database details for staging
    perl -pi -e "s/staginghosthere/$staginghost/g" wp-config/wp-config.staging.php
    perl -pi -e "s/stagingdatabasehere/$stagingdatabase/g" wp-config/wp-config.staging.php
    perl -pi -e "s/stagingusernamehere/$stagingusername/g" wp-config/wp-config.staging.php
    perl -pi -e "s/stagingpasswordhere/$stagingpassword/g" wp-config/wp-config.staging.php

    #set database details for production
    perl -pi -e "s/productionhosthere/$productionhost/g" wp-config/wp-config.production.php
    perl -pi -e "s/productiondatabasehere/$productiondatabase/g" wp-config/wp-config.production.php
    perl -pi -e "s/productionusernamehere/$productionusername/g" wp-config/wp-config.production.php
    perl -pi -e "s/productionpasswordhere/$productionpassword/g" wp-config/wp-config.production.php

    #add urls to environment file
    perl -pi -e "s/productionurlhere/$productionurl/g" wp-config/wp-config.env.php
    perl -pi -e "s/stagingurlhere/$stagingurl/g" wp-config/wp-config.env.php
    perl -pi -e "s/localurlhere/$localurl/g" wp-config/wp-config.env.php

    #set WP salts
    perl -i -pe'
    BEGIN {
        @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
        push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";
        sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
    }
    s/put your unique phrase here/salt()/ge
    ' /wp-config/wp-config-default.php
fi


#create uploads folder and set permissions
mkdir wp-content/uploads
chmod 775 wp-content/uploads
echo "Cleaning..."

#remove zip file
cd ..
rm latest.tar.gz

#install theme
echo "======================================================="
echo "Installing the Wordpress theme"
echo "======================================================="

cd wordpress/wp-content/themes/

if [ "$defaulttheme" = "y" ]; then

git clone git@bitbucket.org:hybrid_media/framework_wp.git
cd framework_wp
echo "==================================================================="
echo "Installing the node modules for your theme, this could take a while"
echo "==================================================================="
npm install


#set GTM tag into the header
perl -pi -e "s/GTM-TAG-HERE/$gtmtag/g" header.php

else

#install other theme

curl -O "$themepath"
FILE="$themepath"
basename "$FILE"
f="$(basename -- $FILE)"
tar -zxvf "$f"
rm -R "$f"

fi

#PLUGINS
echo "======================================================="
echo "Installing some necessary plugins"
echo "======================================================="
if [ "$defaulttheme" = "y" ]; then
    cd ../../plugins/
else
    cd ../plugins/
fi

curl -O https://downloads.wordpress.org/plugin/wordpress-seo.latest-stable.zip
tar -zxvf wordpress-seo.latest-stable.zip
rm wordpress-seo.latest-stable.zip

curl -O https://downloads.wordpress.org/plugin/ninja-forms.zip
tar -zxvf ninja-forms.zip
rm ninja-forms.zip

curl -O https://downloads.wordpress.org/plugin/wp-migrate-db.1.0.11.zip
tar -zxvf wp-migrate-db.1.0.11.zip
rm wp-migrate-db.1.0.11.zip

curl -O https://downloads.wordpress.org/plugin/wp-mail-smtp.1.5.2.zip
tar -zxvf wp-mail-smtp.1.5.2.zip
rm wp-mail-smtp.1.5.2.zip

curl -O https://downloads.wordpress.org/plugin/duplicate-post.3.2.3.zip
tar -zxvf duplicate-post.3.2.3.zip
rm duplicate-post.3.2.3.zip

curl -O https://downloads.wordpress.org/plugin/autoptimize.2.5.1.zip
tar -zxvf autoptimize.2.5.1.zip
rm autoptimize.2.5.1.zip

curl -O https://downloads.wordpress.org/plugin/rocket-lazy-load.2.2.3.zip
tar -zxvf rocket-lazy-load.2.2.3.zip
rm rocket-lazy-load.2.2.3.zip

curl -O https://downloads.wordpress.org/plugin/redirection.4.3.1.zip
tar -zxvf redirection.4.3.1.zip
rm redirection.4.3.1.zip

curl -O https://downloads.wordpress.org/plugin/wordfence.7.3.5.zip
tar -zxvf wordfence.7.3.5.zip
rm wordfence.7.3.5.zip

if [ "$timber" = "y" ]; then
curl -O https://downloads.wordpress.org/plugin/timber-library.1.9.2.zip
tar -zxvf timber-library.1.9.2.zip
rm timber-library.1.9.2.zip
fi


echo "======================================================="
echo "Installation is complete."
echo "======================================================="
echo ""
echo "░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░░░░░░░"
echo "░░░░░░░░░░░░▄████████████████▄░░░░░░░░░░"
echo "░░░░░░░░░░▄██▀░░░░░░░▀▀████████▄░░░░░░░░"
echo "░░░░░░░░░▄█▀░░░░░░░░░░░░░▀▀██████▄░░░░░░"
echo "░░░░░░░░░███▄░░░░░░░░░░░░░░░▀██████░░░░░"
echo "░░░░░░░░▄░░▀▀█░░░░░░░░░░░░░░░░██████░░░░"
echo "░░░░░░░█▄██▀▄░░░░░▄███▄▄░░░░░░███████░░░"
echo "░░░░░░▄▀▀▀██▀░░░░░▄▄▄░░▀█░░░░█████████░░"
echo "░░░░░▄▀░░░░▄▀░▄░░█▄██▀▄░░░░░██████████░░"
echo "░░░░░█░░░░▀░░░█░░░▀▀▀▀▀░░░░░██████████▄░"
echo "░░░░░░░▄█▄░░░░░▄░░░░░░░░░░░░██████████▀░"
echo "░░░░░░█▀░░░░▀▀░░░░░░░░░░░░░███▀███████░░"
echo "░░░▄▄░▀░▄░░░░░░░░░░░░░░░░░░▀░░░██████░░░"
echo "██████░░█▄█▀░▄░░██░░░░░░░░░░░█▄█████▀░░░"
echo "██████░░░▀████▀░▀░░░░░░░░░░░▄▀█████████▄"
echo "██████░░░░░░░░░░░░░░░░░░░░▀▄████████████"
echo "██████░░▄░░░░░░░░░░░░░▄░░░██████████████"
echo "██████░░░░░░░░░░░░░▄█▀░░▄███████████████"
echo "███████▄▄░░░░░░░░░▀░░░▄▀▄███████████████"



#remove bash
if [ "$currentinstallfolder" = "y" ]; then
cd ../../../
echo ""
echo ""
echo "======================================================="
echo "Bash file deleted"
echo "======================================================="
rm -R wp.sh

#copy files from wordpress folder to root and delete wordpress folder
cp -rp wordpress/ ./
rm -rf wordpress
fi

fi