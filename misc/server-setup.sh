#!/bin/bash

# Copyright 2013 Ricardo Tubio-Pardavila (rtpardavila@gmail.com)

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

################################################################################
# Autor: rtpardavila[at]gmail.com
# Description: configures a Debian server for the SATNet project.
################################################################################

# mysql-server, admin password: _805Mysql
# phpmyadmin user:password for database: phpmyadmin:_805Phpmyadmin

install_packages()
{

    apt-get update
    apt-get dist-upgrade
    
    apt-get install mysql-server python apache2 phpmyadmin
    apt-get install python-django python-django-registration python-mysqldb
    
    apt-get clean

}

configure_mysql()
{

    echo "CREATE USER '$django_user'@'localhost' IDENTIFIED BY '$django_user_password';" \
        > $__mysql_batch
    echo "CREATE DATABASE $django_db;" \
        >> $__mysql_batch
    echo "GRANT all privileges ON $django_db.* TO '$django_user'@'localhost';" \
        >> $__mysql_batch

    mysql -h localhost -u root -p < $__mysql_batch
    
}

delete_mysql_db()
{

    echo "DROP USER '$django_user'@'localhost';" \
        > $__mysql_batch
    echo "DROP DATABASE IF EXISTS $django_db;" \
        >> $__mysql_batch

    mysql -h localhost -u root -p < $__mysql_batch

}

################################################################################
# ### Main variables and parameters

__mysql_batch='/tmp/__mysql_batch'

django_user='satnet_django'
django_user_password='_805Django'
django_db='satnet_db'

################################################################################
# ### Main execution loop

# check running as <root>
[[ $( whoami ) == 'root' ]] || \
	{ echo 'Need to be <root>, exiting...'; exit -1; }

echo 'This process is not unattended, user interaction is required.'

#install_packages
configure_mysql
# ### just in case the database needs to be restored:
#delete_mysql_db


