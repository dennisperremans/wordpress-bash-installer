
# Wordpress installer

This script allows you to install Wordpress very quickly. With a few commands you have a complete Wordpress installation, including a default theme and some plugins.

You can either install a default configuration or a multi-environment.

## Before

Be sure to have Xcode installed on your computer.


## Multi-environment

You don't have to mess around with the config file if you push to website to another environment. Our code will automatically check on which domain you are.
If you are on the staging domain, Wordpress will use the staging environment credentials, ... 
  

## How to start

1. git clone the repository
2. you can either clone it in the project folder of clone it on a general location on your computer.
3. open your terminal and go to the folder where the bash script is created
4. type `sh wp.sh` and press enter
5. simply follow the steps

a. if the bash script is in the folder where the Wordpress installation will be located, you have to enter `y` when `Do you want to install in current folder (y/n)` is asked.

b. If you enter `n`, you have to enter the **full path** where your project is located.

  
  

## What will be installed

1. Latest stable version of Wordpress

2. Wordpress default theme and node_modules // or you can choose another theme by copy/pasting the absolute path (must be online!)

3. Plugins: Yoast SEO, Ninja forms, WP Migrate DB, WP Mail SMTP, Duplicate Post, Autoptimize, Rocket-lazy-load, Redirection, Wordfence, Timber (optional)

  
  

## What's in the pipeline

1. automatically install a local database. But this can be a bit tricky because mysql can be located on any location.
2. Initial Wordpress database install. This also depends on the item above.
3. Create directory when it doesn't exist.
4. Always download latest version of all git plugins
5. Limit the input

  
  

## Good to know

This is tested on Mac OS 10.13.6 High Sierra
  

### Changelog

#### 2/9/19

1. New essential plugins added (autoptimize, lazy load, redirection, wordfence)

2. You can now create a multi-environment install

  

#### 7/2/19

1. You are now able to install another theme than the default theme

2. Remove the bash script other the installation is completed

3. Plugin path fix when choosing between default theme or not

4. Check if the current folder where you want to put your project exists.