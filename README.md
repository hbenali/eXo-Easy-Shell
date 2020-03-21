# eXo-Easy-Shell
eXo Basic Shell Commands 
--- By Houssem Ben Ali - eXo Support Team

HOW TO INSTALL: 

1- Clone the repository

2- Run ./install.sh

3- Open new Terminal Tab or run source ~/.exocmd/custom.sh

4- You can run exohelp to show available commands.

5- You can run exoupdate to install updates and checkout what's new.

### Help Page: 
------------
``

    -- exoget:
           Usage:      exoget <tomcat|jboss> <version|latest> [--noclean] : Download eXo platform Instance.
                       exoget <--reset> : Reset eXo Nexus repository stored credentials.
           Note :      <latest> argument  is only available for eXo Tomcat Server Instance
    -- exostart:
           Usage:      exostart: Run eXo platform instance.
           Note :      [Optional] Set LOGFILTER value to filter server log : INFO, WARN, or ERROR before running exostart (Ex LOGFILTER=WARN)
    -- exostop:
           Usage:      exostop [--force]: Stop eXo platform instance.
    -- exochangedb:
           Usage:      exochangedb <mysql|oracle|hsqldb|...> [-v|--version ADDON_VERSION]: Change eXo platform DBMS.
    -- exodataclear:
           Usage:      exodataclear: Clear eXo platform Data and log file.
    -- exodump:
           Usage:      exodump: Backup and Clear eXo platform Data and log file.
    -- exodumprestore:
           Usage:      exodatarestore: Restore Dumpped eXo platform Data and log file.
    -- exodevstart:
           Usage:      exodevstart: Run eXo Platform Developement Instance.
           Note :      [Mandatory] Set SRVDIR value containing the server Path
    -- exodevstop:
           Usage:      exodevstop Stop eXo Platform Developement Instance.
           Note :      [Mandatory] Set SRVDIR value containing the server Path
    -- exodevinject:
           Usage:      exodevinject: Inject war & jar file into eXo platform.
           Note :      [Mandatory] Set SRVDIR value containing the server Path
    -- exodevsync:
           Usage:      exodevsync: Print eXo Platform Log
           Note :      [Mandatory] Set SRVDIR value containing the server Path
                       [Optional] Set LOGFILTER value to filter server log : INFO, WARN, or ERROR before running exodevsync (Ex LOGFILTER=WARN)
    -- exoidldap:
           Usage:      exoidldap: Apply LDAP/AD integration on eXo platform.
                       exoidldap <undo> : Remove ldap integration from eXo platform.
    -- exossocas:
           Usage:      exossocas: Apply cas integration on eXo platform.
                       exossocas <undo>: Remove cas integration from eXo platform.
    -- exoldapinject:
           Usage:      exoldapinject [<name_length:4>]: Inject Random users to OpenLDAP Server [ou=users,dc=exosupport,dc=com].
    -- exoinjectusers:
           Usage:      exoinjectusers -c <nb_of_users>.
                       exoinjectusers -h for more details
    -- exoinjectspaces:
           Usage:      exoinjectspaces -c <nb_of_spaces>.
                       exoinjectspaces -h for more details
    -- exocldev:
           Usage:      exocldev <repo_name>: Clone eXodev Github Repository.
    -- exoclplf:
           Usage:      exoclplf <repo_name>: Clone eXoplatform Github Repository.
    -- exocladd:
           Usage:      exocladd <repo_name>: Clone eXo-addons Github Repository.
    -- exoupdate:
           Usage:      exoupdate: Update eXo-Easy-Shell
    -- exogettribelog:
           Usage:      exogettribelog: Download eXo Tribe log file.
                       exogettribelog <--reset> : Reset eXo Nexus repository stored credentials.
                       exogettribelog <--dev|--preprod|--qa> : Select eXo Tribe Instance.
    -- exosynctribelog:
           Usage:      exosynctribelog [-l <line_numbers>]: Synchronize eXo Tribe log file.
                       exosynctribelog <--dev|--preprod|--qa> : Select eXo Tribe Instance.
           Note :      [Optional] Set LOGFILTER value to filter server log : INFO, WARN, or ERROR before running exosynctribelog (Ex LOGFILTER=WARN)
    -- exogetaddonversion:
           Usage:      exogetaddonversion <ADDON_NAME> [-v|--version PLF_VERSION]: Get CompatAible eXo Shell Addon versions
    -- exojconsole:
           Usage:      exojconsole: Open JMX Console for eXo Platform Server
    -- exoupgrade:
           Usage:      exoupgrade: Perform the eXo Upgrade Process to a selected version
    -- exojrebel:
           Usage:      exojrebel: Integrate JRebel Remote hot deployment with eXo Platform Server
    -- exogitfetch:
           Usage:      exogitfetch: Download all local git repositories updates``
