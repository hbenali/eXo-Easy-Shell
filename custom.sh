#!/bin/bash
# eXo Basic Shell Commands
# Released by Houssem B. Ali - eXo Support 2019
# eXo-Easy-Shell. Functions definitions

# @Public: Clear DATA FOR eXo TOMCAT & JBOSS
# <--------------------------GLOBAL VARs ------------------------------------>
[ -z ${EXOCOMMUNITYDN} ] && readonly EXOCOMMUNITYDN="community.exoplatform.com"
[ -z ${EXOCOMMUNITYLOGURL} ] && readonly EXOCOMMUNITYLOGURL="$EXOCOMMUNITYDN/logs/platform.log"
# <-------------------------------------------------------------------------->

exodataclear() {
	if ! isTomcat && ! isJBoss; then
		exoprint_err "Please check you are working on eXo Platform server instance!"
		return
	fi

	if isTomcat; then
		tomcatdataclear
		return
	fi

	if isJBoss; then
		jbossdataclear
		return
	fi
}

# @Public: Dump DATA FOR TOMCAT & JBOSS
exodump() {
	if ! isTomcat && ! isJBoss; then
		exoprint_err "Please check you are working on eXo Platform server instance!"
		return
	fi

	if isTomcat; then
		tomcatdatadump
		return
	fi

	if isJBoss; then
		jbossdatadump
		return
	fi
}

# @Public: Dump DATA FOR TOMCAT & JBOSS
exodumprestore() {
	if ! isTomcat && ! isJBoss; then
		exoprint_err "Please check you are working on eXo Platform server instance!"
		return
	fi

	if isTomcat; then
		tomcatdatadumprestore
		return
	fi

	if isJBoss; then
		jbossdatadumprestore
		return
	fi
}

# @Public: Change Database FOR TOMCAT & JBOSS
exochangedb() {
	if ! isTomcat && ! isJBoss; then
		exoprint_err "Please check you are working on eXo Platform server instance!"
		return
	fi

	if isTomcat; then
		tomcatchangedb $*
		return
	fi

	if isJBoss; then
		#jbosschangedb $*
		exoprint_warn "AMT: JBoss DataBase Switch is not yet supported!"
		echo "Tip:"
		echo "   1- Download Suitable JDBC Driver and place it under Standalone/Deployments/ (You may need to remove hsqldb*.jar)"
		echo "   2- Make Changes on Standalone/Configuration/standalone-exo.xml"
		echo "   3- You may need to create a text file name as follow <JDBC_JAR_FILE>.DODEPLOY containing as a text JDBC_JAR_FILE"
		echo "--> This Feature will be implemented ASAP :-)"
		return
	fi
}

# @Private: Tomcat Server Check
isTomcat() {
	[ -f "./bin/tomcat-juli.jar" ]
}

# @Private: JBoss Server Check
isJBoss() {
	[ -f "./bin/launcher.jar" ]
}

# @Private: Tomcat Data Clear
tomcatdataclear() {
	local GATEIN_DIR="./gatein"
	local LOGS_DIR="./logs"
	local TMP_DIRECTORY="./tmp"
	rm -rf "$LOGS_DIR/*" &>/dev/null
	rm -rf "$GATEIN_DIR/data" &>/dev/null
	rm -rf "$TMP_DIRECTORY/*" &>/dev/null
	exoprint_suc "eXo Tomcat Server Data has been cleared !"
}

# @Private: JBoss Data Clear
jbossdataclear() {
	local GATEIN_DIR="./standalone/data"
	local LOGS_DIR="./standalone/log"
	local TMP_DIRECTORY="./standalone/tmp"
	rm -rf "$LOGS_DIR/*" &>/dev/null
	rm -rf "$GATEIN_DIR/data" &>/dev/null
	rm -rf "$TMP_DIRECTORY/*" &>/dev/null
	exoprint_suc "eXo JBoss Server Data has been cleared !"
}

# @Private: Tomcat Data Dump
tomcatdatadump() {
	local GATEINDATA_DIR="./gatein/data"
	local LOGS_DIR="./logs"
	local TMP_DIRECTORY="./tmp"
	rm -rf "DATABACKUP" &>/dev/null
	mkdir -p "DATABACKUP/gatein/data/" &>/dev/null
	mkdir -p "DATABACKUP/logs" &>/dev/null
	mkdir -p "DATABACKUP/tmp" &>/dev/null
	mv "$LOGS_DIR/*" "DATABACKUP/logs/" &>/dev/null
	mv "$GATEINDATA_DIR/*" "DATABACKUP/gatein/data/" &>/dev/null
	mv "$TMP_DIRECTORY/*" "DATABACKUP/tmp/" &>/dev/null
	exoprint_suc "eXo Tomcat Server Data has been dumped !"
}

# @Private: Tomcat Data Dump

# @Private: Tomcat Data Restore
tomcatdatarestore() {
	local GATEINDATA_DIR="./gatein/data"
	local LOGS_DIR="./logs"
	local TMP_DIRECTORY="./tmp"
	rm -rf "$GATEINDATA_DIR/" &>/dev/null
	rm -rf "$LOGS_DIR" &>/dev/null
	rm -rf "$TMP_DIRECTORY" &>/dev/null
	mv "DATABACKUP/logs/*" "$LOGS_DIR/" &>/dev/null
	mv "DATABACKUP/gatein/data/*" "$GATEINDATA_DIR/" &>/dev/null
	mv "DATABACKUP/tmp/*" "$TMP_DIRECTORY/" &>/dev/null
	rm -rf "DATABACKUP" &>/dev/null
	exoprint_suc "eXo Tomcat Server Data has been restored !"
}

# @Private: JBoss Data Restore
jbossdatarestore() {
	local GATEINDATA_DIR="./standalone/data"
	local LOGS_DIR="./standalone/log"
	local TMP_DIRECTORY="./standalone/tmp"
	rm -rf "$GATEINDATA_DIR/" &>/dev/null
	rm -rf "$LOGS_DIR" &>/dev/null
	rm -rf "$TMP_DIRECTORY" &>/dev/null
	mv "DATABACKUP/logs/*" "$LOGS_DIR/" &>/dev/null
	mv "DATABACKUP/gatein/data/*" "$GATEINDATA_DIR/" &>/dev/null
	mv "DATABACKUP/tmp/*" "$TMP_DIRECTORY/" &>/dev/null
	rm -rf "DATABACKUP" &>/dev/null
	exoprint_suc "eXo JBoss Server Data has been restored !"
}

# @Private: JBoss Data Dump
jbossdatadump() {
	local GATEINDATA_DIR="./standalone/data"
	local LOGS_DIR="./standalone/log"
	local TMP_DIRECTORY="./standalone/tmp"
	rm -rf "DATABACKUP" &>/dev/null
	mkdir -p "DATABACKUP/gatein/data/" &>/dev/null
	mkdir -p "DATABACKUP/logs" &>/dev/null
	mkdir -p "DATABACKUP/tmp" &>/dev/null
	mv "$LOGS_DIR/*" "DATABACKUP/logs/" &>/dev/null
	mv "$GATEINDATA_DIR/*" "DATABACKUP/gatein/data/" &>/dev/null
	mv "$TMP_DIRECTORY/*" "DATABACKUP/tmp/" &>/dev/null
	exoprint_suc "eXo JBoss Server Data has been dumped !"
}

# @Private: [Generic] Switch Server DB
switchdb() {
	local PLUGIN=""
	local ADDON_NAME=""
	local SOURCE_CONF=""
	case "$1" in
	"mysql")
		ADDON_NAME="exo-jdbc-driver-mysql"
		SOURCE_CONF="$CONF_DIR/server-mysql.xml"
		exoprint_suc "MySQL DB has been selected"
		;;
	"oracle")
		ADDON_NAME="exo-jdbc-driver-oracle"
		SOURCE_CONF="$CONF_DIR/server-oracle.xml"
		exoprint_suc "Oracle DB has been selected"
		;;
	"mssql")
		ADDON_NAME="exo-jdbc-driver-mssql"
		SOURCE_CONF="$CONF_DIR/server-mssql.xml"
		echo "MS SQL Server DB has been selected"

		;;
	"postgres")
		ADDON_NAME="exo-jdbc-driver-postgresql"
		SOURCE_CONF="$CONF_DIR/server-postgres.xml"
		exoprint_suc "MS SQL Server DB has been selected"
		;;
	"postgresplus")
		ADDON_NAME="exo-jdbc-driver-postgresql"
		SOURCE_CONF="$CONF_DIR/server-postgresplus.xml"
		exoprint_suc "MS SQL Server DB has been selected"
		;;
	"sybase")
		# ADDON_NAME="exo-jdbc-driver-sybase" [[ No Plugin ]]
		SOURCE_CONF="$CONF_DIR/server-sybase.xml"
		exoprint_suc "Sybase DB is selected"
		;;
	"hsqldb")
		SOURCE_CONF="$CONF_DIR/server-hsqldb.xml"
		exoprint_suc "hsqldb is selected"
		;;
	esac
	if [ ! -z $ADDON_NAME ]; then
		if [[ "$2" == "-v" ]] || [[ "$2" == "--version" ]]; then
			if [ ! -z "$3" ]; then
				ADDON_NAME="$ADDON_NAME:$3"
			else
				exoprint_warn "Addon version is ignored"
			fi
		fi
	fi
	cp -rf "$SOURCE_CONF" "$CONF_DIR/server.xml" &>/dev/null
	if [ ! -z "$ADDON_NAME" ]; then
		./addon install $ADDON_NAME
	fi
}

# @Private: Tomcat Change Database
tomcatchangedb() {
	local CONF_DIR="./conf"
	cp -rf "$CONF_DIR/server.xml" "$CONF_DIR/server.old.xml" &>/dev/null
	local SOURCE_CONF="$CONF_DIR/server.xml"
	switchdb $*
}

# @Private: JBoss Change Database
jbosschangedb() {
	local CONF_DIR="./conf"
	cp -rf "$CONF_DIR/server.xml" "$CONF_DIR/server.old.xml" &>/dev/null
	local SOURCE_CONF="$CONF_DIR/server.xml"
	switchdb $*
}

# @Public: Get eXo Platform Server instance From Repository
exoget() {
	if [[ $@ =~ "--reset" ]]; then
		rm -rf "$HOME/.plfcred.exo" &>/dev/null
		exoprint_suc "Repository credentials has been cleared!"
		return
	fi
	if [[ $@ =~ "--silent" ]]; then silentmode=true; else silentmode=false; fi
	if [[ $@ =~ "--nocd" ]]; then nocd=true; else nocd=false; fi
	assert_command wget || return
	store_credentials
	local dntype=""
	local dnversion=""
	local cred=$(read_credentials)
	[ $? -eq 1 ] && return
	if [[ $1 == "tomcat" ]]; then
		dntype="tomcat"
	elif [[ $1 == "jboss" ]] || [[ $1 == "jbossep" ]] || [[ $1 == "jbosseap" ]]; then
		dntype="jbosseap"
	else
		exoprint_err "There is not server type called $1 !"
		return
	fi
	local SNAPSHOTPLFVERSION="6.0.x-SNAPSHOT"
	if [[ $2 == "latest" ]]; then
		if [[ $dntype == "jbosseap" ]]; then
			exoprint_err "There is no SNAPSHOT versions for JBoss Server !"
			return
		fi
		dnversion=$SNAPSHOTPLFVERSION
	else
		dnversion="$2"
	fi
	local SRVURI="repository.exoplatform.org/content/groups/private/com/exoplatform/platform/distributions/plf-enterprise-$dntype-standalone/$dnversion"
	local ZIPFILENAME="plf-enterprise-$dntype-standalone-$dnversion.zip"
	local SRVFULLURI="https://$cred@$SRVURI"
	local pglisl=""
	local pgoutput=""
	if [[ $dnversion == $SNAPSHOTPLFVERSION ]]; then
		pglist=($(wget -qO- "$SRVFULLURI/" | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*" | sort | uniq | grep '\.zip$'))
		pgoutput=${pglist[${#pglist[@]} - 1]}
		ZIPFILENAME=$(echo "${pgoutput##*/}")
	fi
	SRVFULLURI="$SRVFULLURI/$ZIPFILENAME"
	wget "$SRVFULLURI" -O "$ZIPFILENAME" --progress=bar:force 2>&1 | progressfilt
	if [ $? -ne 0 ]; then
		exoprint_err "Could not download $ZIPFILENAME !"
		return
	fi
	local SRVFOLDERNAME=$(unzip -Z -1 $ZIPFILENAME | head -1 | cut -d "/" -f1)
	/usr/bin/unzip -o $ZIPFILENAME &>/dev/null
	if [[ ! $@ =~ "--noclean" ]]; then
		rm -rf $ZIPFILENAME &>/dev/null
	fi
	local SRVFOLDERPATH="$(realpath "$SRVFOLDERNAME")"
	$silentmode || exoprint_suc "\e]8;;file://$SRVFOLDERPATH\a$SRVFOLDERNAME\e]8;;\a has been created !"
	$nocd || cd $SRVFOLDERPATH
}

# @Private: [UI] Hide wget Useless Informations
progressfilt() {
	local flag=false c count cr=$'\r' nl=$'\n'
	while IFS='' read -d '' -rn 1 c; do
		if $flag; then
			printf '%s' "$c"
		else
			if [[ $c != $cr && $c != $nl ]]; then
				count=0
			else
				((count++))
				if ((count > 1)); then
					flag=true
				fi
			fi
		fi
	done
}

# @Public: Run eXo Platform Server Instance
exostart() {
	if ! isTomcat && ! isJBoss; then
		exoprint_err "Please check you are working on eXo Platform server instance!"
		return
	fi

	if [ ! -z "$LOGFILTER" ]; then
		if [[ "$LOGFILTER" == "INFO" ]] || [[ "$LOGFILTER" == "WARN" ]] || [[ "$LOGFILTER" == "ERROR" ]]; then
			exoprint_op "Running eXo Platform with \"$LOGFILTER\" logging filter..."
		else
			exoprint_warn "Invalid LOGFILTER value. Please choose one of these values INFO, WARN, or ERROR. Otherwise leave it empty"
			unset LOGFILTER
		fi
	fi
	if isTomcat; then
		if check_command fgrep && [ ! -z "$LOGFILTER" ]; then
			./start_eXo.sh $* | fgrep "$LOGFILTER" --color=never
		else
			./start_eXo.sh $*
		fi
		return
	fi

	if isJBoss; then
		if check_command fgrep && [ ! -z "$LOGFILTER" ]; then
			./bin/standalone.sh $* | fgrep "$LOGFILTER" --color=never
		else
			./bin/standalone.sh $*
		fi
		return
	fi
}

# @Public: Stop eXo Platform Server Instance
exostop() {
	if [[ $1 == "--force" ]] || [[ $1 == "-f" ]]; then
		exec_exo_pid "kill -9" && exoprint_suc "Server process has been killed!"
	elif isTomcat; then
		if [ ! -f temp/catalina.pid ]; then
			exoprint_err "Server is not started!"
			return
		fi
		kill -15 $(cat temp/catalina.pid) 2>/dev/null || exoprint_err "Error while stopping eXo Tomcat Server, You can call $0 --force to kill its process ID"
	else
		exoprint_err "Please make sure you are working on eXo Tomcat Server Folder!"
	fi
}

# @Public: Open eXo Platform Server JConsole
exojconsole() {
	assert_command jconsole || return
	exec_exo_pid jconsole
}

# @Public: Add CAS SSO to eXo Platform Server Instance
exossocas() {
	if ! isTomcat && ! isJBoss; then
		exoprint_err "Please check you are working on eXo Platform server instance!"
		return
	fi
	if isJBoss; then
		exoprint_warn "Not yet supported For JBoss Server!"
		return
	fi
	assert_command wget || return
	assert_command sed || return
	assert_command tr || return
	assert_command grep || return

	local TOMCAT7VER=$(wget -qO- https://www-eu.apache.org/dist/tomcat/tomcat-7/ | grep -oP "v([0-9]+.[0-9]+)+.[0-9]+" | tr -d "v" | uniq)
	local TOMCAT8VER=$(wget -qO- https://www-eu.apache.org/dist/tomcat/tomcat-8/ | grep -oP "v([0-9]+.[0-9]+)+.[0-9]+" | tr -d "v" | uniq)
	local CASVER1="3.5.0"
	local CASVER2="4.0.0"
	local tomcatopt=""
	echo "Please select Tomcat version for CAS:"
	echo "   1/ $TOMCAT7VER [Default]"
	echo "   2/ $TOMCAT8VER"
	printf "** Option: "
	read tomcatopt
	if [ -z "$tomcatopt" ]; then tomcatopt="1"; fi
	local tomcatv=""
	if [ $tomcatopt != "1" ] && [ $tomcatopt != "2" ]; then
		exoprint_err "Invalid Option !"
		return
	elif [[ "$tomcatopt" == "1" ]]; then
		tomcatv=$TOMCAT7VER
	else
		tomcatv=$TOMCAT8VER
	fi
	local casopt=""
	echo "Please select CAS version:"
	echo "   1/ $CASVER1 [Default]"
	echo "   2/ $CASVER2"
	printf "** Option: "
	read casopt
	if [ -z "$casopt" ]; then casopt="1"; fi
	local casv=""
	if [ $casopt != "1" ] && [ $casopt != "2" ]; then
		exoprint_err "Invalid Option !"
		return
	elif [[ "$casopt" == "1" ]]; then
		casv=$CASVER1
	else
		casv=$CASVER2
	fi
	local srvport
	printf "Input CAS Tomcat Server Port[Default: 8888]: "
	read srvport
	if [ -z "$srvport" ]; then srvport="8888"; fi
	clear
	echo "You have selected:"
	echo " -- Tomcat Server version : $tomcatv"
	echo " -- Tomcat Server port    : $srvport"
	echo " -- CAS version           : $casv"
	read -p "Press enter to continue" && clear
	local TOMCATDNURL="https://www-us.apache.org/dist/tomcat/tomcat-$(echo ${tomcatv%%.*})/v$tomcatv/bin/apache-tomcat-$tomcatv.tar.gz"
	local TOMCATFILEPATH="/tmp/apache-tomcat-$tomcatv.tar.gz"
	local TOMCATDIRPATH="/tmp/apache-tomcat-$tomcatv"
	if [[ $1 == "--undo" ]]; then
		./addon uninstall exo-cas
	else
		if [ ! -f cas-plugin.zip ]; then
			exoprint_op "Installing exo-cas addon"
			./addon install exo-cas
		fi
	fi
	clear
	exoprint_op "Getting Tomcat Server $tomcatv..."
	if ! wget $TOMCATDNURL -O $TOMCATFILEPATH --progress=bar:force 2>&1 | progressfilt; then
		exoprint_err "Could not download Tomcat Server !"
		return
	fi
	if ! tar -xvf $TOMCATFILEPATH -C /tmp/ &>/dev/null; then
		exoprint_err "Could not extract Tomcat Server Archive !"
		return
	fi
	if ! rm -rf $TOMCATDIRPATH/webapps/* &>/dev/null; then
		exoprint_err "Could not cleanup Tomcat Server webapps !"
		return
	fi
	if ! eval "sed -i 's/8080/$(echo $srvport)/g' '$TOMCATDIRPATH/conf/server.xml'" &>/dev/null; then
		exoprint_err "Could not change port 8080 for Tomcat Server !"
		return
	fi
	if ! eval "sed -i 's/8443/$(echo ${srvport:0:2}43)/g' '$TOMCATDIRPATH/conf/server.xml'" &>/dev/null; then
		exoprint_err "Could not change port 8443 for Tomcat Server !"
		return
	fi
	if ! eval "sed -i 's/8009/$(echo ${srvport:0:2}09)/g' '$TOMCATDIRPATH/conf/server.xml'" &>/dev/null; then
		exoprint_err "Could not change port 8009 for Tomcat Server !"
		return
	fi
	if ! eval "sed -i 's/8005/$(echo ${srvport:0:2}05)/g' '$TOMCATDIRPATH/conf/server.xml'" &>/dev/null; then
		exoprint_err "Could not change port 8005 for Tomcat Server !"
		return
	fi
	local CASDNURL="https://repo1.maven.org/maven2/org/jasig/cas/cas-server-webapp/$casv/cas-server-webapp-$casv.war"
	local CASFILEPATH="/tmp/cas.war"
	clear
	exoprint_op "Getting CAS Webapp $casv..."
	if ! wget $CASDNURL -O $CASFILEPATH --progress=bar:force 2>&1 | progressfilt; then
		exoprint_err "Could not download CAS WAR Package !"
		return
	fi
	local TMPWORKDIR="/tmp/cas_wk"
	if ! rm -rf $TMPWORKDIR && mkdir -p $TMPWORKDIR &>/dev/null; then
		exoprint_err "Could not create CAS Temp Directory !"
		return
	fi
	if ! unzip $CASFILEPATH WEB-INF/deployerConfigContext.xml -d $TMPWORKDIR &>/dev/null; then
		exoprint_err "Could not extract CAS webapp to Temp Directory !"
		return
	fi
	if ! unzip cas-plugin.zip -d $TMPWORKDIR/WEB-INF/lib/ &>/dev/null; then
		exoprint_err "Could not extract Lib Files to Temp Directory !"
		return
	fi
	sed -i 's/class="org.jasig.cas.authentication.handler.support.SimpleTestUsernamePasswordAuthenticationHandler" \/>/class="org.gatein.sso.cas.plugin.AuthenticationPlugin"><property name="gateInProtocol"><value>http<\/value><\/property><property name="gateInHost"><value>localhost<\/value><\/property><property name="gateInPort"><value>8080<\/value><\/property><property name="gateInContext"><value>portal<\/value><\/property><property name="httpMethod"><value>POST<\/value><\/property><\/bean>/g' $TMPWORKDIR/WEB-INF/deployerConfigContext.xml
	sed -i '/<bean id="primaryAuthenticationHandler"/{:a;N;/<\/bean>/!ba;N;s/.*\n/<bean id="primaryAuthenticationHandler" class="org.gatein.sso.cas.plugin.CAS40AuthenticationPlugin"><property name="gateInProtocol"><value>http<\/value><\/property><property name="gateInHost"><value>localhost<\/value><\/property><property name="gateInPort"><value>8080<\/value><\/property>        <property name="gateInContext"><value>portal<\/value><\/property><property name="httpMethod"><value>POST<\/value><\/property><\/bean>\n/};' $TMPWORKDIR/WEB-INF/deployerConfigContext.xml
	check_command xmllint && xmllint --format $TMPWORKDIR/WEB-INF/deployerConfigContext.xml &>/dev/null
	cd $TMPWORKDIR
	zip -ur ../cas.war WEB-INF &>/dev/null
	cd -
	rm -rf $TMPWORKDIR #! Optimization neede + Error Handling
	if ! mv -uf $CASFILEPATH $TOMCATDIRPATH/webapps/ &>/dev/null; then
		exoprint_err "Could not copy CAS WAR Package to the server !"
		return
	fi
	if ! mv -uf $TOMCATDIRPATH ../cas-server-$casv &>/dev/null; then
		exoprint_err "Could not copy CAS Tomcat server beside eXo Platform Server!"
		return
	fi
	clear
	if [ ! -f "gatein/conf/exo.properties" ]; then touch "gatein/conf/exo.properties" || (
		exoprint_err "Could not create exo.properties file!"
		return
	); fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^gatein.sso.enabled')" ]; then echo "gatein.sso.enabled=true" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^gatein.sso.callback.enabled')" ]; then echo "gatein.sso.callback.enabled=\${gatein.sso.enabled}" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^gatein.sso.login.module.enabled')" ]; then echo "gatein.sso.login.module.enabled=\${gatein.sso.enabled}" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^gatein.sso.login.module.class')" ]; then echo "gatein.sso.login.module.class=org.gatein.sso.agent.login.SSOLoginModule" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^gatein.sso.cas.server.url')" ]; then echo "gatein.sso.cas.server.url=http://localhost:$srvport/cas" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^gatein.sso.portal.url')" ]; then echo "gatein.sso.portal.url=http://localhost:8080" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^gatein.sso.filter.logout.class')" ]; then echo "gatein.sso.filter.logout.class=org.gatein.sso.agent.filter.CASLogoutFilter" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^gatein.sso.filter.logout.url')" ]; then echo "gatein.sso.filter.logout.url=\${gatein.sso.server.url}/logout" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^gatein.sso.filter.login.sso.url')" ]; then echo "gatein.sso.filter.login.sso.url=\${gatein.sso.cas.server.url}/login?service=\${gatein.sso.portal.url}/@@portal.container.name@@/initiatessologin" >>"gatein/conf/exo.properties"; fi
	local CASSRVFULLPATH="$(realpath ../cas-server-$casv)"
	exoprint_suc "The CAS Server \e]8;;file://$CASSRVFULLPATH\acas-server-$casv\e]8;;\a has been created !"
}
# @Public: Clone eXo-Dev Repository
exocldev() {
	git clone "git@github.com:exodev/$1.git"
	cd $1
}

# @Public: Add SAML SSO to eXo Platform Server Instance
exossosaml() {
	if ! isTomcat && ! isJBoss; then
		exoprint_err "Please check you are working on eXo Platform server instance!"
		return
	fi
	if isJBoss; then
		exoprint_warn "Not supported For JBoss Server!"
		return
	fi
	exoprint_op "Installing eXo SAML Addon..."
	./addon install exo-saml --no-compat --conflict=overwrite --force
	if [ ! -f lib/jboss-security-spi-3.0.0.Final.jar ]; then
		exoprint_op "Downloading jboss-security-spi-3.0.0.Final.jar..."
		if wget -qO "lib/jboss-security-spi-3.0.0.Final.jar" "https://repo1.maven.org/maven2/org/picketbox/jboss-security-spi/3.0.0.Final/jboss-security-spi-3.0.0.Final.jar"; then
			exoprint_err "Could not download jboss-security-spi-3.0.0.Final.jar !"
			return
		fi
	fi
	if [ ! -d "gatein/conf/saml2" ] && [ -d "standalone/configuration/gatein/saml2" ]; then
		cp -rf "standalone/configuration/gatein/saml2" "gatein/conf" &>/dev/null
		rm -rf "standalone" &>/dev/null
	fi
	# Workaround Begin {
	#################################################
	printf "Input picketLink-sp.xml configFile Path: (Default \${catalina.home}/gatein/conf/saml2/picketlink-sp.xml) "
	read picketLinkCFGFIle && echo
	if [ -z "$picketLinkCFGFIle" ]; then picketLinkCFGFIle="\${catalina.home}/gatein/conf/saml2/picketlink-sp.xml"; fi
	mkdir -p conf/Catalina &>/dev/null
	local CATALINACONFPORTAL="conf/Catalina/portal.xml"
	echo "<Context path='/portal' docBase='portal' reloadable='true' crossContext='true' privileged='true'>" >$CATALINACONFPORTAL
	echo "  <Realm className='org.apache.catalina.realm.JAASRealm'" >>$CATALINACONFPORTAL
	echo "         appName='gatein-domain'" >>$CATALINACONFPORTAL
	echo "         userClassNames='org.exoplatform.services.security.jaas.UserPrincipal'" >>$CATALINACONFPORTAL
	echo "         roleClassNames='org.exoplatform.services.security.jaas.RolePrincipal'/>" >>$CATALINACONFPORTAL
	echo "  <Valve" >>$CATALINACONFPORTAL
	echo "      className='org.picketlink.identity.federation.bindings.tomcat.sp.ServiceProviderAuthenticator'" >>$CATALINACONFPORTAL
	echo "      configFile=\"$picketLinkCFGFIle\" />" >>$CATALINACONFPORTAL
	echo "  <Valve" >>$CATALINACONFPORTAL
	echo "      className='org.apache.catalina.authenticator.FormAuthenticator'" >>$CATALINACONFPORTAL
	echo "      characterEncoding='UTF-8'/>" >>$CATALINACONFPORTAL
	echo "</Context>" >>$CATALINACONFPORTAL
	#################################################
	# } EO Workaround
	local SRVPORT=$(grep -Pi 'port=\"[0-9]+\" protocol=\"org.apache.coyote.http11.Http11NioProtocol\"' conf/server.xml | grep -oP '\d{4}' | head -n 1)
	if [ -z "$SRVPORT" ]; then SRVPORT="8080"; fi
	if [ ! -f "gatein/conf/exo.properties" ]; then touch "gatein/conf/exo.properties" || (
		exoprint_err "Could not create exo.properties file!"
		return
	); fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^gatein.sso.enabled')" ]; then echo "gatein.sso.enabled=true" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^gatein.sso.callback.enabled')" ]; then echo "gatein.sso.callback.enabled=\${gatein.sso.enabled}" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^gatein.sso.login.module.enabled=')" ]; then echo "gatein.sso.login.module.enabled=\${gatein.sso.enabled}" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^gatein.sso.login.module.class')" ]; then echo "gatein.sso.login.module.class=org.gatein.sso.agent.login.SAML2IntegrationLoginModule" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^gatein.sso.filter.login.sso.url')" ]; then echo "gatein.sso.filter.login.sso.url=/@@portal.container.name@@/dologin" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^gatein.sso.filter.initiatelogin.enabled')" ]; then echo "gatein.sso.filter.initiatelogin.enabled=false" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^gatein.sso.valve.enabled')" ]; then echo "gatein.sso.valve.enabled=\${gatein.sso.enabled}" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^gatein.sso.valve.class')" ]; then echo "gatein.sso.valve.class=org.picketlink.identity.federation.bindings.tomcat.sp.ServiceProviderAuthenticator" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^gatein.sso.saml.config.file')" ]; then echo "gatein.sso.saml.config.file=$picketLinkCFGFIle" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^gatein.sso.idp.host')" ]; then echo "gatein.sso.idp.host=" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^gatein.sso.idp.url')" ]; then echo "gatein.sso.idp.url=http://\${gatein.sso.idp.host}:8080/" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^gatein.sso.sp.url')" ]; then echo "gatein.sso.sp.url=http://localhost:$SRVPORT/portal/dologin" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^gatein.sso.picketlink.keystore')" ]; then echo "gatein.sso.picketlink.keystore=\${catalina.home}/gatein/conf/saml2/jbid_test_keystore.jks" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^gatein.sso.valve.class')" ]; then echo "gatein.sso.valve.class=org.gatein.sso.saml.plugin.valve.ServiceProviderAuthenticator" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^gatein.sso.filter.logout.class')" ]; then echo "gatein.sso.filter.logout.class=org.gatein.sso.saml.plugin.filter.SAML2LogoutFilter" >>"gatein/conf/exo.properties"; fi

	if [ -z "$(cat gatein/conf/exo.properties | grep '^gatein.sso.filter.logout.enabled')" ]; then echo "gatein.sso.filter.logout.enabled=true" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^#gatein.sso.filter.logout.class')" ]; then echo "#gatein.sso.filter.logout.class=org.gatein.sso.agent.filter.SAML2LogoutFilter" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^gatein.sso.filter.logout.url')" ]; then echo "gatein.sso.filter.logout.url=\${gatein.sso.sp.url}?GLO=true" >>"gatein/conf/exo.properties"; fi
	#  if [ -z "$(cat gatein/conf/exo.properties | grep '^')" ]; then echo "" >>"gatein/conf/exo.properties"; fi

	exoprint_suc "You can also customize SAML configuration with \e]8;;file://"$(realpath gatein/conf/exo.properties)"\aexo.properties\e]8;;\a file."

}

# @Public: Clone eXo-Addons Repository
exocladd() {
	git clone "git@github.com:exo-addons/$1.git"
	cd $1
}

# @Public: Clone eXoPlatform Repository
exoclplf() {
	git clone "git@github.com:exoplatform/$1.git"
	cd $1
}

# @Public: Inject JAR/WAR to selected eXo Server instance
exodevinject() {
	if [[ -z "$1" ]]; then
		exoprint_err "Please specify files !"
		return
	fi
	if [[ -z $SRVDIR ]]; then
		exoprint_err "Please set \$SRVDIR value !"
		return
	fi
	if [ ! -f "$SRVDIR/bin/tomcat-juli.jar" ]; then
		echo "Error, Please make sure you are working on Tomcat Server!"
		return
	fi
	$SRVDIR/stop_eXo.sh &>/dev/null
	kill -9 $(lsof -t -i:8080) &>/dev/null
	echo "Injecting $1 File..."
	if [[ ${1#*.} == "war" ]]; then
		cp -f "$(realpath $1)" "$SRVDIR/webapps/"
		rm "$SRVDIR/webapps/${1%*.}"
	fi
	if [[ ${1#*.} == "jar" ]]; then
		cp -rf "$(realpath $1)" "$SRVDIR/lib/"
	fi
	exoprint_suc "$1 has been injected successfully!"
}

# @Public: Start selected eXo Server instance Silently
exodevstart() {
	if [[ -z $SRVDIR ]]; then
		exoprint_err "Please set \$SRVDIR value !"
		return
	fi
	if [ ! -f "$SRVDIR/bin/tomcat-juli.jar" ]; then
		echo "Error, Please make sure you are working on Tomcat Server!"
		return
	fi
	$SRVDIR/start_eXo.sh -b $* &>/dev/null
}

# @Public: Stop selected eXo Server instance
exodevstop() {
	if [[ -z "$SRVDIR" ]]; then
		exoprint_err "Please set \$SRVDIR value !"
		return
	fi
	if [ ! -f "$SRVDIR/bin/tomcat-juli.jar" ]; then
		exoprint_err "Please make sure you are working on Tomcat Server!"
		return
	fi
	"$SRVDIR/stop_eXo.sh" &
	kill -9 $(lsof -t -i:8080) &>/dev/null
}

# @Public: Restart selected eXo Server instance
devrestart() {
	exodevstop
	exodevstart
}

# @Public: Synchronize selected eXo Server instance's log file
exodevsync() {
	if [[ -z "$SRVDIR" ]]; then
		exoprint_err "Please set \$SRVDIR value !"
		return
	fi
	if [ ! -f "$SRVDIR/bin/tomcat-juli.jar" ]; then
		exoprint_err "Please make sure you are working on Tomcat Server!"
		return
	fi
	if [[ ! -f $SRVDIR/logs/catalina.out ]]; then
		exoprint_err "Please start the server!"
		return
	fi
	if [ ! -z "$LOGFILTER" ]; then
		if [[ "$LOGFILTER" == "INFO" ]] || [[ "$LOGFILTER" == "WARN" ]] || [[ "$LOGFILTER" == "ERROR" ]]; then
			exoprint_op "Synchronizing eXo Platform Log with \"$LOGFILTER\" logging filter..."
		else
			exoprint_warn "Invalid LOGFILTER value. Please choose one of these values INFO, WARN, or ERROR. Otherwise leave it empty"
			unset LOGFILTER
		fi
	fi
	if check_command fgrep && [ ! -z "$LOGFILTER" ]; then
		tail -f $SRVDIR/logs/platform.log | fgrep "$LOGFILTER" --color=never | colorize_log
	else
		tail -f $SRVDIR/logs/platform.log | colorize_log
	fi
}

# @Public: Enable LDAP Integration For eXo Platform
exoidldap() {
	local tcloader="./bin/tomcat-juli.jar"
	if ! isTomcat; then
		exoprint_err "Please make sure you are working on Tomcat Server!"
		return
	fi
	if [[ "$1" == "--undo" ]]; then
		if [ -z "$(find webapps -name 'ldap-extension-*')" ]; then
			exoprint_err "Could not find LDAP extension !"
		else
			rm -rf webapps/ldap-extension-* &>/dev/null && exoprint_suc "LDAP extension has been removed !"
		fi
		return
	fi
	assert_command sed || return
	assert_command grep || return
	CFGLIST=($(unzip -v webapps/portal.war WEB-INF/conf/organization/picketlink-idm/examples/* | grep -oP "WEB.*\-config.xml" | cut -d"/" -f6))
	echo "Please select LDAP/AD Configuration File:"
	counter=1
	for i in "${CFGLIST[@]}"; do
		echo "  $counter/ $i"
		((counter++))
	done
	printf "** Option [1..${#CFGLIST[@]}]: "
	read cfgopt
	if (($cfgopt < 1 || $cfgopt > ${#CFGLIST[@]})); then
		exoprint_err "Invalid Option! Please try again."
		return
	fi
	local CFGFILE="${CFGLIST[$cfgopt - 1]}"
	local EXOCMD="$HOME/.exocmd"
	local TMPDIR="/tmp/ldap-extension"
	if [ ! -d "$EXOCMD" ] || [ ! -f "$EXOCMD/extension.zip" ]; then
		exoprint_err "Could not get files, please reinstall eXo-Easy-Shell !"
		return
	fi
	local PLFVERSION=$(find lib -name 'commons-api-*' | sed -E 's/lib\/commons-api-//g' | sed -E 's/.jar//g')
	if [ -z "$PLFVERSION" ]; then
		exoprint_err "Could not get platform version !"
		return
	fi
	local PLFBRANCH=$(echo ${PLFVERSION%.*}".x")
	if [ -z "$PLFBRANCH" ]; then
		exoprint_err "Could not get platform major version !"
		return
	fi
	if [[ $CFGFILE =~ "ldap" ]]; then
		printf "Input adminDN: (Default cn=admin,dc=exosupport,dc=com) "
	elif [[ $CFGFILE =~ "msad" ]]; then
		printf "Input adminDN: (Default EXOSUPPORT\Administrator) "
	fi
	local adminDN=""
	read adminDN && echo
	if [ -z "$adminDN" ]; then
		if [[ $CFGFILE =~ "ldap" ]]; then
			adminDN="cn=admin,dc=exosupport,dc=com"
		elif [[ $CFGFILE =~ "msad" ]]; then
			adminDN="EXOSUPPORT\Administrator"
		else
			exoprint_warn "adminDN value is empty!"
		fi
	fi
	local adminPassword=""
	printf "Input adminPassword: (Default root) "
	read -s adminPassword && echo
	[ -z "$adminPassword" ] && adminPassword="root"
	local DCNAME=""
	if [[ $CFGFILE =~ "*msad*" ]]; then
		printf "Input DCName: (Default DC=exosupport,DC=com) "
		read -s DCNAME && echo
	fi
	[[ $CFGFILE =~ "*ldap*" ]] && DCNAME=$(echo "dc="${adminDN#*dc=})
	[ -z "$DCNAME" ] && DCNAME="DC=exosupport,DC=com"
	local providerURL=""
	printf "Input providerURL: (Default ldap://127.0.0.1:389) "
	read -s providerURL && echo
	[ -z "$providerURL" ] && providerURL="ldap://127.0.0.1:389"
	echo "You have selected:"
	echo " -- Configuration File : $CFGFILE"
	echo " -- AdminDN            : $adminDN"
	echo " -- DCNAME             : $DCNAME"
	echo " -- ProviderURL        : $providerURL"
	read -p "Press enter to continue" && clear
	rm -rf $TMPDIR &>/dev/null
	exoprint_op "Generating LDAP extension..."
	check_command crc32 && [[ "$(crc32 $EXOCMD/extension.zip)" != "3480e93e" ]] && exoprint_warn "Tampered extension.zip file!"
	if ! unzip -o $EXOCMD/extension.zip -d $TMPDIR &>/dev/null; then
		exoprint_err "Could not create extension !"
		return
	fi
	if ! eval "sed -i 's/PLFBRANCH/$PLFBRANCH/g' $TMPDIR/pom.xml" &>/dev/null; then
		exoprint_err "Could not set major version in the maven project !"
		return
	fi
	if ! eval "sed -i 's/PLFVERSION/$PLFVERSION/g' $TMPDIR/pom.xml" &>/dev/null; then
		exoprint_err "Could not set version in the maven project !"
		return
	fi
	if ! sed -i 's/EXTID/ldap-extension/g' $TMPDIR/pom.xml &>/dev/null; then
		exoprint_err "Could not set artificatid in the maven project !"
		return
	fi
	if ! sed -i 's/EXTDESC/ldap Extension/g' $TMPDIR/pom.xml &>/dev/null; then
		exoprint_err "Could not set description in the maven project !"
		return
	fi
	local CONFDIR="$TMPDIR/src/main/webapp/WEB-INF/conf"
	if ! unzip -j webapps/portal.war WEB-INF/conf/organization/idm-configuration.xml -d "$CONFDIR/organization/" &>/dev/null; then
		exoprint_err "Could not get idm-configuration.xml file !"
		return
	fi
	if ! unzip -j webapps/portal.war WEB-INF/conf/organization/picketlink-idm/examples/$CFGFILE -d "$CONFDIR/organization/picketlink-idm/" &>/dev/null; then
		exoprint_err "Could not get $CFGFILE file !"
		return
	fi
	if ! mv "$CONFDIR/organization/picketlink-idm/$CFGFILE" "$CONFDIR/organization/picketlink-idm/picketlink-idm-ldap-config.xml" &>/dev/null; then
		exoprint_err "Could not rename $CFGFILE file to picketlink-idm-ldap-config.xml !"
		return
	fi
	if ! sed -i "s/<value>war:\\/conf\\/organization\\/picketlink-idm\\/picketlink-idm-config.xml<\\/value>/<!--<value>war:\\/conf\\/organization\\/picketlink-idm\\/picketlink-idm-config.xml<\\/value>-->/g" "$CONFDIR/organization/idm-configuration.xml" &>/dev/null; then
		exoprint_err "Could not deactivate the default configuration file !"
		return
	fi
	if ! sed -i "s/<!--<value>war:\\/conf\\/organization\\/picketlink-idm\\/examples\\/picketlink-idm-ldap-config.xml<\\/value>-->/<value>war:\\/conf\\/organization\\/picketlink-idm\\/picketlink-idm-ldap-config.xml<\\/value>/g" "$CONFDIR/organization/idm-configuration.xml" &>/dev/null; then
		exoprint_err "Could not activate picketlink-idm-ldap-config.xml file !"
		return
	fi
	if ! sed -i "s/ldap:\\/\\/localhost:1389/$(echo $providerURL | sed 's#/#\\/#g')/g;s/\[ldap|ldaps\]:\\/\\/\[msad-host\]:\[port\]/$(echo $providerURL | sed 's#/#\\/#g')/g" "$CONFDIR/organization/picketlink-idm/picketlink-idm-ldap-config.xml" &>/dev/null; then
		exoprint_err "Could not set the providerURL!"
		return
	fi
	if ! sed -i "s/<value>secret<\\/value>/<value>$adminPassword<\\/value>/g;s/<value>\[adminPasswordValue\]<\\/value>/<value>$adminPassword<\\/value>/g" "$CONFDIR/organization/picketlink-idm/picketlink-idm-ldap-config.xml" &>/dev/null; then
		exoprint_err "Could not set the adminPassword!"
		return
	fi
	if ! sed -Ei "s/cn=Manager,dc=my-domain,dc=com/$adminDN/g;s/TEST*.Administrator/$(echo $adminDN | sed 's/\\/\\\\/g')/g" "$CONFDIR/organization/picketlink-idm/picketlink-idm-ldap-config.xml" &>/dev/null; then
		exoprint_err "Could not set the adminDN!"
		return
	fi
	if ! sed -i "s/dc=my-domain,dc=com/$DCNAME/g;s/DC=test,DC=domain/$DCNAME/g" "$CONFDIR/organization/picketlink-idm/picketlink-idm-ldap-config.xml" &>/dev/null; then
		exoprint_err "Could not set the DCNAME!"
		return
	fi
	if ! sed -i "s/ou=People,o=portal,o=gatein/ou=users/g" "$CONFDIR/organization/picketlink-idm/picketlink-idm-ldap-config.xml" &>/dev/null; then
		exoprint_err "Could not set the organization unit!"
		return
	fi
	if ! mvn -f $TMPDIR/pom.xml clean install &>/dev/null; then
		exoprint_err "Could not build the extension!"
		return
	fi
	if ! rm -rf webapps/ldap-extension-* &>/dev/null; then
		exoprint_err "Could not remove the old extension!"
		return
	fi
	if ! cp -f "$TMPDIR/target/ldap-extension-$PLFBRANCH.war" webapps/ &>/dev/null; then
		exoprint_err "Could not place the extension!"
		return
	fi
	local EXTFILENAME="$(realpath webapps/ldap-extension-$PLFBRANCH.war)"
	rm -rf $TMPDIR &>/dev/null &>/dev/null || exoprint_warn "Could not remove unecessary files!"
	if [ ! -f "gatein/conf/exo.properties" ]; then touch "gatein/conf/exo.properties" || (
		exoprint_err "Could not create exo.properties file!"
		return
	); fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^exo.idm.externalStore.import.cronExpression')" ]; then echo "exo.idm.externalStore.import.cronExpression=0 */1 * ? * *" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^exo.idm.externalStore.queue.processing.cronExpression')" ]; then echo "exo.idm.externalStore.queue.processing.cronExpression=0 */2 * ? * *" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^exo.idm.externalStore.queue.processing.error.retries.max')" ]; then echo "exo.idm.externalStore.queue.processing.error.retries.max=5" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^exo.idm.externalStore.delete.cronExpression')" ]; then echo "exo.idm.externalStore.delete.cronExpression=0 59 23 ? * *" >>"gatein/conf/exo.properties"; fi
	if [ -z "$(cat gatein/conf/exo.properties | grep '^exo.idm.externalStore.update.onlogin')" ]; then echo "exo.idm.externalStore.update.onlogin=true" >>"gatein/conf/exo.properties"; fi
	exoprint_suc "\e]8;;file://$EXTFILENAME\aLDAP extension\e]8;;\a has been created !"
	echo -e "You can also customize externalStore Job Task with \e]8;;file://"$(realpath gatein/conf/exo.properties)"\aexo.properties\e]8;;\a file."
}

# @Public: Inject Users to LDAP Server
exoldapinject() {
	assert_command gpw || return
	assert_command ldapadd || return
	local lwid=0
	local grwid=1
	echo -n Min User ID:
	read lwid
	echo -n Max User ID:
	read grwid
	local strlen=4
	if [[ $lwid > $grwid ]]; then
		exoprint_err "Invalid Min and Max ID values!"
		return
	fi
	echo -n "OpenLDAP Domain Config (Example dc=exosupport,dc=com):"
	local dconfig=""
	local passadmin="123456"
	local password="123456"
	read dconfig
	echo ""
	echo -n LDAP Admin Password:
	read -s passadmin
	echo ""
	echo -n Users Password:
	read -s password
	echo ""
	if [[ ${#password} < 6 ]]; then
		echo "Users Password Invalid ! Min Password length is : 6"
		return
	fi
	if [ -z "$dconfig" ]; then
		dconfig="dc=exosupport,dc=com"
	fi
	if [[ ! $1 == "" ]]; then
		strlen=$1
	fi
	local mdp=$(echo -n "$password" | sha1sum | awk '{print $1}')
	for ((i = $lwid; i <= $grwid; i++)); do
		local fname="$(/usr/bin/gpw 1 $strlen)"
		local lname="$(/usr/bin/gpw 1 $strlen)"
		local name="$fname $lname"
		local uname="$fname$lname"
		echo "dn: cn=$name,ou=users,$dconfig
       objectClass: top
       objectClass: account
       uid: $uname
       objectClass: posixAccount
       uidNumber: $i
       gidNumber: 500
       homeDirectory: /home/users/$uname
       loginShell: /bin/bash
       gecos: $uname
       userPassword: $mdp" >/tmp/tmp.ldif
		printf "Creating user $name..."
		if ldapadd -x -w $passadmin -D "cn=admin,$dconfig" -f /tmp/tmp.ldif; then exoprint_suc "OK"; else exoprint_err "Fail"; fi
	done
	#rm -rf tmp.ldif &>/dev/null
	exoprint_suc "Users have been injected !"
}

# @Public: Inject Spaces to eXo Server Instance
exoinjectspaces() {
	local SHORT=HpscvarU
	local LONG=host,port,spaceprefix,count,verbose,auth,visibility,registration,uppercase
	if [[ $1 == "-h" ]] || [[ "$1" == "--help" ]]; then
		usageSpaces
		return
	fi
	local PARSED=$(getopt --options $SHORT --longoptions $LONG --name "$0" -- "$@")
	if [[ $? -ne 0 ]]; then
		# e.g. $? == 1
		#  then getopt has complained about wrong arguments to stdout
		return
	fi
	local re='^[0-9]+$'
	while true; do
		case "$1" in
		-H | --host)
			local host="$2"
			shift 2
			;;
		-p | --port)
			local port="$2"
			shift 2
			;;
		-s | --spaceprefix)
			local spaceprefix="$2"
			shift 2
			;;
		-v | --visibility)
			if [[ "$2" == "public" ]] || [[ "$2" == "hidden" ]]; then
				local visibility="$2"
			else
				exoprint_err "Wrong visibility value ! must be public or hidden"
				return
			fi
			shift 2
			;;
		-r | --registration)
			if [[ "$2" == "open" ]] || [[ "$2" == "validation" ]] || [[ "$2" == "closed" ]]; then
				local registration="$2"
			else
				exoprint_err "Wrong registration value ! must be open, validation or closed"
				return
			fi
			shift 2
			;;
		-U | --uppercase)
			local uppercase=1
			shift
			;;
		-c | --count)
			local nbOfSpaces="$2"
			shift 2
			;;
		-a | --auth)
			local auth="$2"
			shift 2
			;;
		"")
			break
			;;
		*)
			exoprint_err "Programming error"
			return
			;;
		esac
	done
	if [ -z "$nbOfSpaces" ]; then
		exoprint_err "Missing number of profiles to create (-c)"
		echo ""
	fi

	if [ -z "$host" ]; then host="localhost"; fi
	if [ -z "$port" ]; then port="8080"; fi
	if [ -z "$spaceprefix" ]; then spaceprefix="space"; fi
	if [ -z "$auth" ]; then auth="root:gtn"; fi
	if [ -z "$visibility" ]; then visibility="public"; fi
	if [ -z "$registration" ]; then registration="open"; fi
	local saltregex=""
	if [ -z "$uppercase" ]; then saltregex="a-z"; else saltregex="A-Z"; fi

	if ! [[ $port =~ $re ]]; then
		exoprint_err "Port must be a number" >&2
		exit 1
	fi
	if ! [[ $nbOfSpaces =~ $re ]]; then
		exoprint_err "Number of profiles must be a number" >&2
		exit 1
	fi

	local spaceIndex=1

	until [ $spaceIndex -gt $nbOfSpaces ]; do
		local displayName=$(head -c 500 /dev/urandom | tr -dc "$saltregex" | fold -w 6 | head -n 1)
		local url="http://$host:$port/rest/private/v1/social/spaces"
		local data="{\"displayName\": \"$displayName\","
		data+="\"description\": \"$spaceprefix$spaceIndex\","
		data+="\"visibility\": \"$visibility\","
		data+="\"subscription\": \"$registration\"}"
		local curlCmd="curl -s -w '%{response_code}' -X POST -u "$auth" -H \"Content-Type: application/json\" --data '$data' $url | grep -o  '[1-9][0-9][0-9]'"
		printf "Creating space displayName=\"$(tput setaf 12)$displayName$(tput init)\"..."
		local httprs=$(eval $curlCmd)
		if [[ "$httprs" =~ "200" ]]; then echo -e "$(tput setaf 2)OK$(tput init)"; else echo -e "$(tput setaf 1)Fail$(tput init)"; fi
		spaceIndex=$(($spaceIndex + 1))
	done

}

# @Private: Inject users help
usageUsers() {
	echo " Usage : exoinjectusers -c <nb_of_users> [options]"
	echo ""
	echo "    -h| --help           help"
	echo "    -H| --host           server hostname Default: localhost"
	echo "    -p| --port           server port Default: 8080"
	echo "    -u| --userprefix     prefix of the injected users Default: user"
	echo "    -P| --userpassword   password of the injected users Default: 123456"
	echo "    -a| --auth           Root credentials Default: root:gtn"
	echo "    -c| --count          number of users to create"
	echo "    -o| --offset         start number of users index to create Default: 1"
	echo "    -U| --uppercase      Uppercased User Full Name Default: unused"
	echo ""
}

# @Private: Inject spaces help
usageSpaces() {
	echo "Usage : exoinjectspaces -c <nb_of_spaces> [options]"
	echo ""
	echo "    -h| --help           help"
	echo "    -H| --host           server hostname Default: localhost"
	echo "    -p| --port           server port Default: 8080"
	echo "    -s| --spaceprefix    prefix of the injected spaces Default: space"
	echo "    -a| --auth           Root credentials Default: root:gtn"
	echo "    -c| --count          number of spaces to create"
	echo "    -r| --registration   Space registration Default: open"
	echo "    -v| --visibility     Space visibility Default: public"
	echo "    -U| --uppercase      Uppercased Space displayName Default: unused"
	echo ""
}

# @Public: Inject Users to eXo Server Instance
exoinjectusers() {
	local SHORT=HPpscvuaoU
	local LONG=host,port,userprefix,count,verbose,userpassword,auth,offset,uppercase
	if [[ $1 == "-h" ]] || [[ "$1" == "--help" ]]; then
		usageUsers
		return
	fi
	local PARSED=$(getopt --options $SHORT --longoptions $LONG --name "$0" -- "$@")
	if [[ $? -ne 0 ]]; then
		exoprint_err "Could not parse arguments"
		return
	fi
	local re='^[0-9]+$'
	while true; do
		case "$1" in
		-H | --host)
			local host="$2"
			shift 2
			;;
		-p | --port)
			local port="$2"
			shift 2
			;;
		-u | --userprefix)
			local userprf="$2"
			shift 2
			;;
		-U | --uppercase)
			local uppercase=1
			shift
			;;
		-c | --count)
			local nbOfUsers="$2"
			shift 2
			;;
		-P | --userpassword)
			local passwd="$2"
			shift 2
			;;
		-a | --auth)
			local auth="$2"
			shift 2
			;;
		-o | --offset)
			if ! [[ $2 =~ $re ]]; then
				exoprint_err "Offset must be a number" >&2
				return
			fi
			local startFrom="$2"
			shift 2
			;;
		-v | --verbose)
			local verbose=y
			shift
			;;
		"")
			break
			;;
		*)
			exoprint_err "Programming error"
			return
			;;
		esac
	done
	if [ -z "$nbOfUsers" ]; then
		exoprint_err "Missing number of profiles to create (-c)"
		return
	fi
	if [ -z "$host" ]; then host="localhost"; fi
	if [ -z "$port" ]; then port="8080"; fi
	if [ -z "$userprf" ]; then userprf="user"; fi
	if [ -z "$passwd" ]; then passwd="123456"; fi
	if [ -z "$auth" ]; then auth="root:gtn"; fi
	if [ -z "$startFrom" ]; then startFrom=1; fi
	local saltregex=""
	if [ -z "$uppercase" ]; then saltregex="a-z"; else saltregex="A-Z"; fi

	if ! [[ $port =~ $re ]]; then
		exoprint_err "Port must be a number" >&2
		return
	fi
	if ! [[ $nbOfUsers =~ $re ]]; then
		exoprint_err "Number of profiles must be a number" >&2
		return
	fi
	local userIndex=$startFrom
	until [ $userIndex -gt $nbOfUsers ]; do
		local firstname=$(head -c 500 /dev/urandom | tr -dc "$saltregex" | fold -w 6 | head -n 1)
		local lastname=$(head -c 500 /dev/urandom | tr -dc "$saltregex" | fold -w 6 | head -n 1)
		local url="http://$host:$port/rest/private/v1/social/users"
		local data="{\"id\": \"$userIndex\","
		data+="\"username\": \"$userprf$userIndex\","
		data+="\"lastname\": \"$lastname\","
		data+="\"firstname\": \"$firstname\","
		data+="\"fullname\": \"$userprf$userIndex\","
		data+="\"password\": \"$passwd\","
		data+="\"email\": \"$userprf$userIndex@exomail.org\"}"
		local curlCmd="curl -s -w '%{response_code}' -X POST -u "$auth" -H \"Content-Type: application/json\" --data '$data' $url | grep -o  '[1-4][0-9][0-9]'"
		printf "Creating user ID=$userprf$userIndex, Full Name=\"$(tput setaf 12)$firstname $lastname$(tput init)\"..."
		local httprs=$(eval $curlCmd)
		if [[ "$httprs" =~ "200" ]]; then echo -e "$(tput setaf 2)OK$(tput init)"; else echo -e "$(tput setaf 1)Fail$(tput init)"; fi
		userIndex=$(($userIndex + 1))
	done
}

# @Public: Change HTTP Port of eXo Server Instance
exochangeport() {
	if [ -z "$1" ] || [[ ! "$1" =~ ^[0-9]+$ ]]; then
		exoprint_err "Please specify a correct server port!"
		return
	fi

	if ! isTomcat && ! isJBoss; then
		exoprint_err "Please check you are working on eXo Platform server instance!"
		return
	fi
	if isTomcat; then
		if eval "sed -Ei 's/port=\"[0-9]+\" protocol=\"org.apache.coyote.http11.Http11NioProtocol\"/port=\"$1\" protocol=\"org.apache.coyote.http11.Http11NioProtocol\"/g' conf/server.xml" &>/dev/null; then
			exoprint_suc "eXo Server Port has been changed to $1 !"
		else
			exoprint_err "Could not change eXo Server to $1 !"
		fi
	fi
	if isJBoss; then
		if eval "sed -Ei 's/jboss.http.port:[0-9]+/jboss.http.port:$1/g' standalone/configuration/standalone-exo.xml" &>/dev/null; then
			exoprint_suc "eXo Server Port has been changed to $1 !"
		else
			exoprint_err "Could not change eXo Server to $1 !"
		fi
	fi
}

# @Public: Get eXo Tribe Log File
exogettribelog() {
	if [[ $1 == "--reset" ]]; then
		rm -rf "$HOME/.plfcred.exo" &>/dev/null
		exoprint_suc "Repository credentials has been cleared!"
		return
	fi
	assert_command wget || return
	store_credentials
	local cred=$(read_credentials)
	[ $? -eq 1 ] && return
	local LOGFILENAME="platform-$(date +'%d-%m-%Y--%H:%M:%S').log"
	local TRIBELOGURL="$EXOCOMMUNITYLOGURL"
	[[ $1 =~ ^--(preprod|dev|qa)$ ]] && local TRIBESUFFIX=$(echo $1 | sed 's/--//g') && TRIBELOGURL=$(echo $TRIBELOGURL | eval sed 's/community/community-$TRIBESUFFIX/g')
	local LOGFULLURI="https://$cred@$TRIBELOGURL"
	if ! wget --user-agent="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)" "$LOGFULLURI" -O "$LOGFILENAME" --progress=bar:force 2>&1 | progressfilt; then
		exoprint_err "Could not download $LOGFILENAME !"
		return
	fi
	local LOGFOLDERPATH="$(realpath "$LOGFILENAME")"
	exoprint_suc "\e]8;;file://$LOGFOLDERPATH\a$LOGFILENAME\e]8;;\a has been created !"
}

# @Public: Sync eXo Tribe Log
exosynctribelog() {
	if [[ $1 == "--reset" ]]; then
		rm -rf "$HOME/.plfcred.exo" &>/dev/null
		exoprint_suc "Repository credentials has been cleared!"
		return
	fi
	if [[ $1 == "-l" ]]; then
		local linenb="$2"
	fi
	if [ -z "$linenb" ]; then linenb="20"; fi
	assert_command wget || return
	store_credentials
	local cred=$(read_credentials)
	[ $? -eq 1 ] && return
	local TRIBELOGURL="$EXOCOMMUNITYLOGURL"
	[[ $1 =~ ^--(preprod|dev|qa)$ ]] && local TRIBESUFFIX=$(echo $1 | sed 's/--//g') && TRIBELOGURL=$(echo $TRIBELOGURL | eval sed 's/community/community-$TRIBESUFFIX/g')
	local LOGFULLURI="https://$cred@$TRIBELOGURL"
	if [ ! -z "$LOGFILTER" ]; then
		if [[ "$LOGFILTER" == "INFO" ]] || [[ "$LOGFILTER" == "WARN" ]] || [[ "$LOGFILTER" == "ERROR" ]]; then
			exoprint_op "Synchronizing eXo Tribe Log with \"$LOGFILTER\" logging filter..."
		else
			exoprint_warn "Invalid LOGFILTER value. Please choose one of these values INFO, WARN, or ERROR. Otherwise leave it empty"
			unset LOGFILTER
		fi
	fi
	if check_command fgrep && [ ! -z "$LOGFILTER" ]; then
		while true; do wget --user-agent="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)" -qO- $LOGFULLURI | tail -f -n $linenb | fgrep "$LOGFILTER" --color=never | colorize_log; done
	else
		while true; do wget --user-agent="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)" -qO- $LOGFULLURI | tail -f -n $linenb | colorize_log; done
	fi
}

# @Public: Get eXo Tribe PLF version
exogettribeversion() {
	local TRIBEURL="$EXOCOMMUNITYDN"
	[[ $1 =~ ^--(preprod|dev|qa)$ ]] && local TRIBESUFFIX=$(echo $1 | sed 's/--//g') && TRIBEURL=$(echo $TRIBEURL | eval sed 's/community/community-$TRIBESUFFIX/g')
	local TRIBEVERSION=$(wget -qO- https://$TRIBEURL/rest/platform/info | grep -o -P '(?<="platformVersion":").*(?=","platformBuildNumber)')
	if [ -z "$TRIBEVERSION" ]; then
		exoprint_err "Could not get eXo Tribe Version !"
		return
	fi
	exoprint_suc "eXo Tribe version: $TRIBEVERSION"
	check_command fgrep || return
	read -p "Would you like to download this version [y/n] ? " -n 1 -r
	echo # (optional) move to a new line
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		exoget tomcat $TRIBEVERSION $*
	fi
}

# @Public: Get eXo Supported version for eXo Instance
exogetaddonversion() {
	local SHORT=v
	local LONG=version
	local PARSED=$(getopt --options $SHORT --longoptions $LONG --name "$0" -- "$@")
	if [[ $? -ne 0 ]]; then
		# e.g. $? == 1
		#  then getopt has complained about wrong arguments to stdout
		return
	fi
	while true; do
		case "$1" in
		-v | --version)
			local PLFVERSION="$2"
			shift 2
			;;
		"")
			break
			;;
		*)
			local ADDONNAME="$1"
			shift
			;;
		esac
	done
	if isTomcat; then
		local PLFVERSION=$(find lib -name 'commons-api-*' | sed -E 's/lib\/commons-api-//g' | sed -E 's/.jar//g')
	fi
	if [ -z "$PLFVERSION" ]; then
		exoprint_err "Could not get platform version !"
		return
	fi
	if [ -z "$ADDONNAME" ]; then
		exoprint_err "Please set eXo Addon name !"
		return
	fi
	local MIDIUMVERSION=$(echo $PLFVERSION | grep -Po "^[0-9]\.[0-9]")
	if [ -z "$MIDIUMVERSION" ]; then
		exoprint_err "Could not get midium platform version !"
		return
	fi
	local MAJORVERSION=$(echo $PLFVERSION | grep -Po "^[0-9]")
	local CATALOGOUT=$(wget -qO- "http://storage.exoplatform.org/public/Addons/list.json")
	local CMPADDVER=$(echo $CATALOGOUT | eval "jq ' .[] | select((.id==\"$ADDONNAME\") and (.compatibility | startswith(\"[$MIDIUMVERSION\"))) | .version'" | tr -d '"')
	if [ ! -z "$CMPADDVER" ]; then
		echo "$(tput setaf 2)******* Compatible Version *******$(tput init)"
		echo $CMPADDVER | tr " " "\n"
	fi
	local MTADDVER=$(echo $CATALOGOUT | eval "jq ' .[] | select((.id==\"$ADDONNAME\") and (.compatibility | startswith(\"[$MAJORVERSION\")) and (.compatibility | endswith(\")\"))) | .version'" | tr -d '"')
	if [ ! -z "$MTADDVER" ]; then
		echo "$(tput setaf 3)*** +/- Compatible Version *******$(tput init)"
		echo $MTADDVER | tr " " "\n"
	fi
}

# @Public: Update eXo-Easy-Shell
exoupdate() {
	local UPGITURL="https://github.com/hbenali/eXo-Easy-Shell"
	local WORKINGDIR="$HOME/.exocmd"
	if ! ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
		exoprint_err "Could not update eXo-Easy-Shell! Please check your internet connection!"
		return
	fi
	if [ -z "$(command git)" ]; then
		exoprint_err "Git command must be installed ! "
		return
	fi
	if [ ! -d "$WORKINGDIR" ]; then
		exoprint_err "Could not update eXo-Easy-Shell! Please check $WORKINGDIR Folder is present!"
		return
	fi
	if [ -d "$WORKINGDIR/.git" ] || [[ "$1" == "--force" ]] || [[ "$1" == "-f" ]]; then
		if ! git -C $WORKINGDIR ls-remote &>/dev/null; then
			exoprint_err "Could not update eXo-Easy-Shell! Enable to connect to the Github Server!"
			return
		fi
		git -C $WORKINGDIR fetch &>/dev/null
		if [ -z "$(git -C $WORKINGDIR diff 'origin/master')" ]; then
			exoprint_suc "You are working on the latest version of eXo-Easy-Shell!"
			return
		fi
		git -C "$WORKINGDIR/" checkout master --force &>/dev/null
		git -C "$WORKINGDIR/" pull --force &>/dev/null
	else
		exoprint_op "eXo-Easy-Shell Updater initialization, please wait..."
		git -C "$WORKINGDIR/" init &>/dev/null && git -C "$WORKINGDIR/" remote add origin "$UPGITURL" &>/dev/null && git -C "$WORKINGDIR/" fetch &>/dev/null && git -C "$WORKINGDIR/" checkout -t origin/master -f &>/dev/null || (
			exoprint_err "Could not update eXo-Easy-Shell !"
			return
		)
	fi
	exoprint_suc "You have updated eXo-Easy-Shell to the latest version !"
	if [ -f "$WORKINGDIR/whatsnew.nfo" ] && [ ! -z "$(cat $WORKINGDIR/whatsnew.nfo)" ]; then
		echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ What's new ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
		cat "$WORKINGDIR/whatsnew.nfo"
	fi
	source "$WORKINGDIR/custom.sh"
}

# @Public: Upgrade eXo Platform to selected version
exoupgrade() {
	if ! isTomcat; then
		exoprint_err "Please check you are working on eXo Platform Tomcat server instance!"
		return
	fi
	local currentversion=$(get_exo_tomcat_version)
	echo "--> The current version is: $currentversion"
	read -p "To which version would you like to upgrade [Default: latest]? " selectedversion
	[ -z $selectedversion ] && selectedversion="latest"
	clear
	echo "W'll perform an upgrade from $currentversion to $(echo $selectedversion | sed 's/latest/SNAPSHOT/g') version."
	read -p "Press enter to continue" && clear
	exoprint_op "Downloading $selectedversion version..."
	exoget "tomcat" $selectedversion --silent --nocd --noclean
	local targetsrvdir="$(realpath platform-$(echo $selectedversion | sed 's/latest/6.0.x-SNAPSHOT/g'))"
	exoprint_op "Checking installed addons..."
	local installedaddons=($(get_installed_addons_list .))
	for i in ${installedaddons[@]}; do
		is_addon_installed $targetsrvdir $i || $targetsrvdir/addon install $i
	done
	exoprint_op "Copying data..."
	cp -rf gatein/data $targetsrvdir/gatein &>/dev/null
	exoprint_op "Copying server.xml..."
	cp -f conf/server.xml $targetsrvdir/conf/server.xml &>/dev/null
	if [ -f gatein/conf/exo.properties ]; then
		exoprint_op "Copying exo.properties"
		cp -f gatein/conf/exo.properties $targetsrvdir/gatein/conf/exo.properties &>/dev/null
	fi
	if [[ $(basename $targetsrvdir) == $(basename $(pwd)) ]] || [ -d ../$(basename $targetsrvdir) ]; then
		local newtargetsrvdir="$targetsrvdir-$(date +%s)"
		mv $targetsrvdir $newtargetsrvdir
		local targetsrvdir=$newtargetsrvdir
	fi
	mv $targetsrvdir ..
	local targetsrvdir="$(realpath ../$(basename $targetsrvdir | sed 's/latest/6.0.x-SNAPSHOT/g'))"
	exoprint_suc "\e]8;;file://$targetsrvdir\a$(basename $targetsrvdir)\e]8;;\a has been created !"
	cd $targetsrvdir
}

# @Public: Integrate JRebel with eXo Tomcat server
exojrebel() {
	if ! isTomcat; then
		exoprint_err "JRebel integration is working only with eXo Tomcat instance!"
		return
	fi
	exoprint_op "Looking for Jetbrains IDE instance(s)"
	local JetbrainsInstances=($(ls -d $HOME/.IntelliJIdea* 2>/dev/null))
	if [ -z $JetbrainsInstances ]; then
		exoprint_err "Jetbrains IntelliJ Idea is not installed !"
		return
	fi
	local jrebelmodule=""
	for i in "${JetbrainsInstances[@]}"; do
		local rbpath=$(find $i -name libjrebel64.so 2>/dev/null)
		[ ! -z $rbpath ] && jrebelmodule=$rbpath
	done
	if [ -z $jrebelmodule ]; then
		exoprint_err "JRebel IDE Plugin is not installed !"
		return
	fi
	local customenvfile="bin/setenv-customize.sh"
	touch $customenvfile
	grep -q "export REBEL_MODULE=$jrebelmodule" $customenvfile || echo "export REBEL_MODULE=$jrebelmodule" >>$customenvfile
	grep -q "export JAVA_OPTS=\"-agentpath:\$REBEL_MODULE -Drebel.remoting_plugin=true -Drebel.remoting_port=9000 \$JAVA_OPTS\"" $customenvfile || echo "export JAVA_OPTS=\"-agentpath:\$REBEL_MODULE -Drebel.remoting_plugin=true -Drebel.remoting_port=9000 \$JAVA_OPTS\"" >>$customenvfile
	exoprint_suc "JRebel is now integrated with eXo Tomcat Server Instance!"
}

# @Public: Fetch all local repositories
exogitfetch() {
	local CURRENT_DIR="$(pwd)"
	read -p "Please specify the directoy having local repositories [ Default: Current ] :" CURRENT_DIR
	[ -z $CURRENT_DIR -o ! -d $CURRENT_DIR ] && CURRENT_DIR="$(pwd)"
	local LOG_FILE=""
	read -p "Please specify log file path [ Default: none ] :" LOG_FILE
	[ -z $LOG_FILE ] && LOG_FILE="/dev/null" || [ -e $LOG_FILE ] || touch $LOG_FILE || {
		exoprint_err "Could not write $LOG_FILE file ! Please check permissions" && return
	}
	[ $LOG_FILE == "/dev/null" ] || mkdir -p $(dirname $LOG_FILE) 2>&1 &>/dev/null
	for i in $(ls -d $CURRENT_DIR/*); do
		if [ ! -d $i/.git ]; then
			local UP_STATE="$i isn't a local repository, so skipped"
		else
			local UP_STATE="Updating $i..."
			git -C $i fetch --all 2>&1 &>/dev/null && UP_STATE=$UP_STATE"OK" || UP_STATE=$UP_STATE"KO"
		fi
		echo "$(date '+%Y-%m-%d %H:%M:%S') | $UP_STATE" >>$LOG_FILE
	done
}

# @Public: Show eXo-Easy-Shell Help Menu
exohelp() {
	echo -e "$(tput setaf 2)       ************************************************************************************************************************$(tput init)"
	echo -e "$(tput setaf 3)                                            \e]8;;https://github.com/hbenali/eXo-Easy-Shell\aeXo-Easy-Shell\e]8;;\a by Houssem Ben Ali 2019 v 4.4 $(tput init)"
	echo -e "$(tput setaf 3)                                                **   Github   :$(tput init) \e]8;;https://github.com/hbenali\agithub.com/hbenali\e]8;;\a"
	echo -e "$(tput setaf 3)                                                ** eXo Account:$(tput init) \e]8;;https://$EXOCOMMUNITYDN/portal/intranet/profile/houssem.benali\aexoplatorm.com/houssem.benali\e]8;;\a"
	echo -e "                                                                                                              \e]8;;https://exoplatform.com\aexoplatform.com\e]8;;\a"
	echo -e "$(tput setaf 2)       ************************************************************************************************************************$(tput init)"
	echo -e "$(tput setaf 4)       Help Page: $(tput init)\n"
	echo "-- exoget:"
	echo -e "$(tput setaf 2)       Usage:$(tput init)      exoget <tomcat|jboss> <version|latest> [--noclean] : Download eXo platform Instance."
	echo "                   exoget <--reset> : Reset eXo Nexus repository stored credentials."
	echo -e "       $(tput setaf 6)Note :$(tput init)      <latest> argument  is only available for eXo Tomcat Server Instance"
	echo "-- exostart:"
	echo -e "$(tput setaf 2)       Usage:$(tput init)      exostart: Run eXo platform instance."
	echo -e "       $(tput setaf 6)Note :$(tput init)      [Optional] Set $(tput setaf 3)LOGFILTER$(tput init) value to filter server log : INFO, WARN, or ERROR before running exostart (Ex LOGFILTER=WARN)"
	echo "-- exostop:"
	echo -e "$(tput setaf 2)       Usage:$(tput init)      exostop [--force]: Stop eXo platform instance."
	echo "-- exochangedb:"
	echo -e "$(tput setaf 2)       Usage:$(tput init)      exochangedb <mysql|oracle|hsqldb|...> [-v|--version ADDON_VERSION]: Change eXo platform DBMS."
	echo "-- exodataclear:"
	echo -e "$(tput setaf 2)       Usage:$(tput init)      exodataclear: Clear eXo platform Data and log file."
	echo "-- exodump:"
	echo -e "$(tput setaf 2)       Usage:$(tput init)      exodump: Backup and Clear eXo platform Data and log file."
	echo "-- exodumprestore:"
	echo -e "$(tput setaf 2)       Usage:$(tput init)      exodatarestore: Restore Dumpped eXo platform Data and log file."
	echo "-- exodevstart:"
	echo -e "$(tput setaf 2)       Usage:$(tput init)      exodevstart: Run eXo Platform Developement Instance."
	echo -e "       $(tput setaf 6)Note :$(tput init)      [Mandatory] Set $(tput setaf 3)SRVDIR$(tput init) value containing the server Path"
	echo "-- exodevstop:"
	echo -e "$(tput setaf 2)       Usage:$(tput init)      exodevstop Stop eXo Platform Developement Instance."
	echo -e "       $(tput setaf 6)Note :$(tput init)      [Mandatory] Set $(tput setaf 3)SRVDIR$(tput init) value containing the server Path"
	echo "-- exodevinject:"
	echo -e "$(tput setaf 2)       Usage:$(tput init)      exodevinject: Inject war & jar file into eXo platform."
	echo -e "       $(tput setaf 6)Note :$(tput init)      [Mandatory] Set $(tput setaf 3)SRVDIR$(tput init) value containing the server Path"
	echo "-- exodevsync:"
	echo -e "$(tput setaf 2)       Usage:$(tput init)      exodevsync: Print eXo Platform Log"
	echo -e "       $(tput setaf 6)Note :$(tput init)      [Mandatory] Set $(tput setaf 3)SRVDIR$(tput init) value containing the server Path"
	echo -e "                   [Optional] Set $(tput setaf 3)LOGFILTER$(tput init) value to filter server log : INFO, WARN, or ERROR before running exodevsync (Ex LOGFILTER=WARN)"
	echo "-- exoidldap:"
	echo -e "$(tput setaf 2)       Usage:$(tput init)      exoidldap: Apply LDAP/AD integration on eXo platform."
	echo "                   exoidldap <undo> : Remove ldap integration from eXo platform."
	echo "-- exossocas:"
	echo -e "$(tput setaf 2)       Usage:$(tput init)      exossocas: Apply cas integration on eXo platform."
	echo "                   exossocas <undo>: Remove cas integration from eXo platform."
	echo "-- exoldapinject:"
	echo -e "$(tput setaf 2)       Usage:$(tput init)      exoldapinject [<name_length:4>]: Inject Random users to OpenLDAP Server [ou=users,dc=exosupport,dc=com]."
	echo "-- exoinjectusers:"
	echo -e "$(tput setaf 2)       Usage:$(tput init)      exoinjectusers -c <nb_of_users>."
	echo "                   exoinjectusers -h for more details"
	echo "-- exoinjectspaces:"
	echo -e "$(tput setaf 2)       Usage:$(tput init)      exoinjectspaces -c <nb_of_spaces>."
	echo "                   exoinjectspaces -h for more details"
	echo "-- exocldev:"
	echo -e "$(tput setaf 2)       Usage:$(tput init)      exocldev <repo_name>: Clone eXodev Github Repository."
	echo "-- exoclplf:"
	echo -e "$(tput setaf 2)       Usage:$(tput init)      exoclplf <repo_name>: Clone eXoplatform Github Repository."
	echo "-- exocladd:"
	echo -e "$(tput setaf 2)       Usage:$(tput init)      exocladd <repo_name>: Clone eXo-addons Github Repository."
	echo "-- exoupdate:"
	echo -e "$(tput setaf 2)       Usage:$(tput init)      exoupdate: Update eXo-Easy-Shell"
	echo "-- exogettribelog:"
	echo -e "$(tput setaf 2)       Usage:$(tput init)      exogettribelog: Download eXo Tribe log file."
	echo "                   exogettribelog <--reset> : Reset eXo Nexus repository stored credentials."
	echo "                   exogettribelog <--dev|--preprod|--qa> : Select eXo Tribe Instance."
	echo "-- exosynctribelog:"
	echo -e "$(tput setaf 2)       Usage:$(tput init)      exosynctribelog [-l <line_numbers>]: Synchronize eXo Tribe log file."
	echo "                   exosynctribelog <--dev|--preprod|--qa> : Select eXo Tribe Instance."
	echo -e "       $(tput setaf 6)Note :$(tput init)      [Optional] Set $(tput setaf 3)LOGFILTER$(tput init) value to filter server log : INFO, WARN, or ERROR before running exosynctribelog (Ex LOGFILTER=WARN)"
	echo "-- exogetaddonversion:"
	echo -e "$(tput setaf 2)       Usage:$(tput init)      exogetaddonversion <ADDON_NAME> [-v|--version PLF_VERSION]: Get CompatAible eXo Shell Addon versions"
	echo "-- exojconsole:"
	echo -e "$(tput setaf 2)       Usage:$(tput init)      exojconsole: Open JMX Console for eXo Platform Server"
	echo "-- exoupgrade:"
	echo -e "$(tput setaf 2)       Usage:$(tput init)      exoupgrade: Perform the eXo Upgrade Process to a selected version"
	echo "-- exojrebel:"
	echo -e "$(tput setaf 2)       Usage:$(tput init)      exojrebel: Integrate JRebel Remote hot deployment with eXo Platform Server"
	echo "-- exogitfetch:"
	echo -e "$(tput setaf 2)       Usage:$(tput init)      exogitfetch: Download all local git repositories updates"
}

# <----------------- GUI FUNs ------------------------------------------------->
# @Private: Print Error Message
exoprint_err() {
	echo -e "$(tput setaf 1)Error:$(tput init) $1"
}

# @Private: Print Success Message
exoprint_suc() {
	echo -e "$(tput setaf 2)Success:$(tput init) $1"
}

# @Private: Print Warning Message
exoprint_warn() {
	echo -e "$(tput setaf 3)Warning:$(tput init) $1"
}

# @Private: Print Operation Message
exoprint_op() {
	echo -e "$(tput setaf 6)Operation:$(tput init) $1"
}

# @Private: Print Colored LOG
colorize_log() {
	eval "sed -e 's/\[\(.*\)\]/$(tput setaf 2)\[\1\]$(tput init)/g;s/<\(.*\)>/$(tput setaf 6)<\1>$(tput init)/g;s/INFO/$(tput setaf 4)INFO$(tput init)/g;s/WARN/$(tput setaf 1)WARN$(tput init)/g;s/ERROR/$(tput setaf 1)$(tput bold)ERROR$(tput init)/g;'"
}

# <----------------- INTERNAL FUNs ------------------------------------------------->
# @Private: Check command is installed
check_command() {
	hash $1 2>&1 &>/dev/null
}

# @Private: Assert given command is installed
assert_command() {
	check_command $1
	local exitval=$?
	if (($exitval != 0)); then
		exoprint_err "$1 is not installed !"
	fi
	return $exitval
}

# @Private: Store eXo Repository credentials
store_credentials() {
	local username=""
	local password=""
	if [ ! -f "$HOME/.plfcred.exo" ]; then
		echo "Please input your eXo repository credentials:"
		echo -n "Username: "
		read username
		echo -n "Password: "
		read -s password
		echo "$username:$password" >"$HOME/.plfcred.exo"
		clear
		echo "Initial Config File has been created!"
	fi
	[ -f "$HOME/.plfcred.exo" ] && [ ! -z "$(cat $HOME/.plfcred.exo)" ]
}

# @Private: Get eXo Repository credentials
read_credentials() {
	if [ ! -f "$HOME/.plfcred.exo" ]; then
		exoprint_err "Could not find credentials file !"
		return 1
	fi
	echo $(<"$HOME/.plfcred.exo")
}

# @Private: Get eXo Server pid
exec_exo_pid() {
	local srvpids=($(jps | grep "Bootstrap\|jboss-modules.jar" | cut -d " " -f1 | sort -u))
	if ((${#srvpids[@]} > 1)); then
		echo "Please choose one eXo Process ID:"
		local counter=1
		for i in "${srvpids[@]}"; do
			local srvpath=$(lsof -p $i | grep cwd | grep -oE "[^ ]+$" --color=never)
			if find $srvpath/lib -name exo.kernel.container*.jar &>/dev/null || find $srvpath/standalone/deployments/platform.ear/lib -name exo.kernel.container*.jar &>/dev/null; then
				printf '%-15s' "   $counter/ [$i]"
				printf '%-20s' "$(jps | grep $i --color=never | cut -d " " -f2)"
				printf '%-40s\n' "$srvpath"
				((counter++))
			fi
		done
		if (($counter == 2)); then # counter == 1 (+1)
			echo "Option 1 has been selected by default"
			local selected=1
		elif (($counter > 2)); then
			printf "** Option [1..$((counter - 1))]: "
			read selected
		else
			exoprint_err "No Running eXo Server is detected"
			return 1
		fi
		if (($selected < 1)) || (($selected > $counter)); then
			exoprint_err "Please select option between 1 and ${#svrpids[@]}"
			return 1
		fi
		local selectedpid=${srvpids[$selected - 1]}
	elif ((${#srvpids[@]} == 1)); then
		local selectedpid=${srvpids}
	else
		exoprint_err "No Running eXo Server is detected"
		return 1
	fi
	eval $* $selectedpid
}

# @Private: Get eXo Version from Tomcat Server
get_exo_tomcat_version() {
	echo $(find lib -name 'commons-api-*' | sed -E 's/lib\/commons-api-//g' | sed -E 's/.jar//g')
}

# @Private: is_addon_installed
is_addon_installed() {
	cat $1/addons/statuses/*.status | jq ".id" | tr -d "\"" | xargs | grep -q $2
}
# @Private: Get eXo installed addon
get_installed_addons_list() {
	cat $1/addons/statuses/*.status | jq ".id" | tr -d "\"" | xargs
}
