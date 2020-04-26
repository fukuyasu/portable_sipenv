#
# SIPenv: Java programming environment for Socio-Informatics major
#

# Project name
PROJECT_NAME = sipenv
# Portable SIPenv ver. num.
VERSION = 3.0-rc1
# Command-Line Env. ver. num.
CLE_VERSION = 1.0
# Portable SIPenv Title
SIPENV_TITLE = Programming Environment / Socio-Informatics Major

########################################################################

7Z = /c/Program\ Files/7-Zip/7z
EXTRAC32 = /c/WINDOWS/system32/extrac32
ATTRIB = /c/WINDOWS/system32/attrib

RM = /bin/rm -f
CP = /bin/cp -p
MV = /bin/mv
MKDIR = /bin/mkdir -p
SED = /usr/bin/sed
FIND = /usr/bin/find
SHELL = /bin/sh

########################################################################

#
# ファイル／ディレクトリ構造
#   ${SIPENV_DIR} -+- ${JAVA_DIR} -+- ${JAVA_MAJOR} : JAVA_HOME
#                  +- ${PORTABLEGIT_DIR} : PortableGit
#                  +- ${ECLIPSE_DIR} : eclipse + pleiades
#                  +- ${WORKSPACE_DIR} : work
#                  +- ${ECLIPSE_WORKSPACE} : eclipse workspace
#                  +- Java command-line.lnk
#                  +- jclinit.bat
#                  +- javaenv.bat
#                  +- version.txt

SIPENV_DIR = sipenv
JAVA_DIR = java
ECLIPSE_DIR = eclipse
PORTABLEGIT_DIR = PortableGit
WORKSPACE_DIR = work
ECLIPSE_WORKSPACE = workspace

########################################################################

JAVA_MAJOR = 11
JAVA_MINOR = ${JAVA11_MINOR}
JAVA_PATCH = ${JAVA11_PATCH}
JAVA_VERSION = ${JAVA11_VERSION}
JAVA_ZIP = ${JAVA11_ZIP}

JAVA11_MINOR = 0.7
# JAVA11_PATCH = 10.1
JAVA11_PATCH = 10
JAVA11_VERSION = -11.${JAVA11_MINOR}+${JAVA11_PATCH}
JAVA11_ZIP = OpenJDK11U-jdk_x64_windows_hotspot_11.${JAVA11_MINOR}_${JAVA11_PATCH}.zip

########################################################################

ECLIPSE_VERSION = 2020-03-R
ECLIPSE_ZIP = eclipse-java-${ECLIPSE_VERSION}-win32-x86_64.zip
ECLIPSE_CONFIG_SCRIPT = eclipseconf.sh

########################################################################

PLEIADES_VERSION = 2020.04.20
PLEIADES_ZIP = pleiades-win-${PLEIADES_VERSION}.zip
PLEIADES_DIR = pleiades

########################################################################

GITFORWINDOWS_VERSION = 2.26.2
PORTABLEGIT_DIST = PortableGit-${GITFORWINDOWS_VERSION}-64-bit.7z.exe

########################################################################

JCLINIT_SRC = jclinit.src
JCLINIT_BAT = jclinit.bat
JAVAENV_SRC = javaenv.src
JAVAENV_BAT = javaenv.bat

########################################################################

RELEASE_DIR = ../release
DIST_DIR = ../distfiles
WORK_DIR = work

########################################################################

all: sipenv-all

########################################################################

ZIP_FILE = ${RELEASE_DIR}/${PROJECT_NAME}-${VERSION}.`date "+%Y%m%d"`.zip

sipenv-zip: sipenv-all ${SIPENV_DIR}/version.txt
	${7Z} a ${ZIP_FILE} ${SIPENV_DIR}

sipenv-all: ${SIPENV_DIR} java-env ${SIPENV_DIR}/${WORKSPACE_DIR} install-eclipse install-pleiades config-eclipse install-portablegit

${SIPENV_DIR}/version.txt:
	${MKDIR} ${SIPENV_DIR}
	echo -e "version=${VERSION}\r\ncreated="`date "+%Y/%m/%d %T"`"\r" > ${SIPENV_DIR}/version.txt
	if [ -x ${SIPENV_DIR}/${JAVA_DIR}/${JAVA_MAJOR}/bin/java ]; then \
	    ${SIPENV_DIR}/${JAVA_DIR}/${JAVA_MAJOR}/bin/java -version 2>&1 \
		| head -1 >>  ${SIPENV_DIR}/version.txt; \
	fi
	echo -e "eclipse=${ECLIPSE_VERSION}\r" >>  ${SIPENV_DIR}/version.txt
	echo -e "pleiades=${PLEIADES_VERSION}\r" >>  ${SIPENV_DIR}/version.txt

${SIPENV_DIR}:
	${MKDIR} ${SIPENV_DIR}

########################################################################

java-env: install-jdk${JAVA_MAJOR} java-command-line

java-command-line: ${SIPENV_DIR} ${SIPENV_DIR}/${JCLINIT_BAT} ${SIPENV_DIR}/${JAVAENV_BAT} ${SIPENV_DIR}/Java\ command-line.lnk

${SIPENV_DIR}/Java\ command-line.lnk: Java\ command-line.lnk
	${CP} "Java command-line.lnk" ${SIPENV_DIR}

${SIPENV_DIR}/${JCLINIT_BAT}: ${JCLINIT_SRC}
	cat ${JCLINIT_SRC} \
	    | ${SED} -e 's|__VERSION__|${CLE_VERSION}|g' \
		     -e 's|__JAVA_MAJOR__|${JAVA_MAJOR}|g' \
		     -e 's|__TITLE__|${SIPENV_TITLE}|g' \
		     -e 's|__PORTABLEGIT_DIR__|${PORTABLEGIT_DIR}|g' \
	    > ${SIPENV_DIR}/${JCLINIT_BAT}
	${ATTRIB} +r +h +s ${SIPENV_DIR}/${JCLINIT_BAT}

${SIPENV_DIR}/${JAVAENV_BAT}: ${JAVAENV_SRC}
	cat ${JAVAENV_SRC} \
	    | ${SED} -e 's|__JAVA_DIR__|${JAVA_DIR}|g' \
	    > ${SIPENV_DIR}/${JAVAENV_BAT}
	${ATTRIB} +r +h +s ${SIPENV_DIR}/${JAVAENV_BAT}

install-jdk11:
	${MAKE} ${MAKE_FLAGS} JAVA_MAJOR=11 JAVA_MINOR=${JAVA11_MINOR} JAVA_PATCH=${JAVA11_PATCH} JAVA_VERSION=${JAVA11_VERSION} JAVA_ZIP=${JAVA11_ZIP} install-jdk

install-jdk: ${SIPENV_DIR} ${SIPENV_DIR}/${JAVA_DIR}/${JAVA_MAJOR}

${SIPENV_DIR}/${JAVA_DIR}/${JAVA_MAJOR}:
	${7Z} x ${DIST_DIR}/${JAVA_ZIP} -o${SIPENV_DIR}/${JAVA_DIR}
	${MV} ${SIPENV_DIR}/${JAVA_DIR}/jdk${JAVA_VERSION}  ${SIPENV_DIR}/${JAVA_DIR}/${JAVA_MAJOR}

########################################################################

ECLIPSE_INI = ${SIPENV_DIR}/${ECLIPSE_DIR}/eclipse.ini

install-eclipse: ${SIPENV_DIR}/${ECLIPSE_DIR}

${SIPENV_DIR}/${ECLIPSE_DIR}: install-jdk${JAVA_MAJOR}
	${7Z} x ${DIST_DIR}/${ECLIPSE_ZIP} -o${SIPENV_DIR}

	# Eclipse起動用のJREを ${JAVA_DIR}/${JAVA_MAJOR} にインストールしたバイナリに設定
	${SED} -i 's|\(-product\)|-vm\n../${JAVA_DIR}/${JAVA_MAJOR}/bin/javaw.exe\n\1|' ${ECLIPSE_INI}

	# ワークスペースを ../workspace に設定
	${MKDIR} ${SIPENV_DIR}/${ECLIPSE_WORKSPACE}
	${SED} -i 's|\(-Dosgi.instance.area.default.*\)/eclipse-workspace|\1/workspace|' ${ECLIPSE_INI}
	echo -e '-Duser.home=../' >> ${ECLIPSE_INI}

config-eclipse:
	${SHELL} ${ECLIPSE_CONFIG_SCRIPT} ${SIPENV_DIR}/${ECLIPSE_DIR} ${SIPENV_DIR}/${ECLIPSE_WORKSPACE}

########################################################################

install-pleiades: ${SIPENV_DIR}/${ECLIPSE_DIR}/plugins/jp.sourceforge.mergedoc.pleiades/pleiades.jar

${SIPENV_DIR}/${ECLIPSE_DIR}/plugins/jp.sourceforge.mergedoc.pleiades/pleiades.jar: install-eclipse
	${MAKE} ${MAKE_FLAGS} ${WORK_DIR}/${PLEIADES_DIR}
	${FIND} ${WORK_DIR}/${PLEIADES_DIR} -mindepth 1 -maxdepth 1 ! -name "setup*" \
		-exec ${CP} -R {} ${SIPENV_DIR}/${ECLIPSE_DIR}/ \;

	# pleiades を有効化
	echo '-Xverify:none' >> ${ECLIPSE_INI}
	echo '-javaagent:plugins/jp.sourceforge.mergedoc.pleiades/pleiades.jar' >> ${ECLIPSE_INI}

${WORK_DIR}/${PLEIADES_DIR}:
	${7Z} x ${DIST_DIR}/${PLEIADES_ZIP} -o${WORK_DIR}/${PLEIADES_DIR}

########################################################################

install-portablegit: ${DIST_DIR}/${PORTABLEGIT_DIST} ${SIPENV_DIR}
	${DIST_DIR}/${PORTABLEGIT_DIST} -y -o${SIPENV_DIR}/${PORTABLEGIT_DIR}

########################################################################

${SIPENV_DIR}/${WORKSPACE_DIR}:
	${MKDIR} ${SIPENV_DIR}/${WORKSPACE_DIR}

########################################################################

clean: clean-simp clean-work

clean-simp:
	${RM} -R ${SIPENV_DIR}

clean-work:
	${RM} -R ${WORK_DIR}

clean-java:
	${RM} -R ${SIPENV_DIR}/${JAVA_DIR}

clean-eclipse:
	${RM} -R ${SIPENV_DIR}/${ECLIPSE_DIR}
	${RM} -R ${SIPENV_DIR}/${ECLIPSE_WORKSPACE}
	${RM} -R ${SIPENV_DIR}/.eclipse
	${RM} -R ${SIPENV_DIR}/.p2
	${RM} -R ${SIPENV_DIR}/.tooling
