#
# SIPenv: Java programming environment for Socio-Informatics major
#

# Project name
PROJECT_NAME = sipenv
# Portable SIPenv ver. num.
VERSION = 3.0
# Command-Line Env. ver. num.
CLE_VERSION = 1.1
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
#                  +- setpath.bat
#                  +- version.txt

SIPENV_DIR = sipenv
JAVA_DIR = java
ECLIPSE_DIR = eclipse
PORTABLEGIT_DIR = PortableGit
WORKSPACE_DIR = work
ECLIPSE_WORKSPACE = workspace

VERSION_TXT = version.txt

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

PLEIADES_VERSION = 2020.04.27
PLEIADES_ZIP = pleiades-win-${PLEIADES_VERSION}.zip
PLEIADES_DIR = pleiades

########################################################################

GITFORWINDOWS_VERSION = 2.26.2
PORTABLEGIT_DIST = PortableGit-${GITFORWINDOWS_VERSION}-64-bit.7z.exe

########################################################################

JCLINIT_SRC = jclinit.src
JCLINIT_GIT_SRC = jclinit-git.src
JCLINIT_BAT = jclinit.bat

JAVAENV_SRC = javaenv.src
JAVAENV_BAT = javaenv.bat

SETPATH_SRC = setpath.src	# not exist
SETPATH_GIT_SRC = setpath-git.src
SETPATH_BAT = setpath.bat

########################################################################

RELEASE_DIR = ../release
DIST_DIR = ../distfiles
WORK_DIR = work

########################################################################

all: sipenv-all
sipenv-all: sipenv-git-jcl-pleiades

sipenv-all-zip:
	${MAKE} ${MAKE_FLAGS} clean
	${MAKE} ${MAKE_FLAGS} sipenv-jcl-zip
	# ${MAKE} ${MAKE_FLAGS} clean	# jcl-pleiades includs jcl
	${MAKE} ${MAKE_FLAGS} sipenv-jcl-pleiades-zip
	${MAKE} ${MAKE_FLAGS} clean
	${MAKE} ${MAKE_FLAGS} sipenv-git-jcl-zip
	# ${MAKE} ${MAKE_FLAGS} clean	# git-jcl-pleiades (all) includes git-jcl
	${MAKE} ${MAKE_FLAGS} sipenv-zip

########################################################################

ZIP_FILE = ${RELEASE_DIR}/${PROJECT_NAME}-${VERSION}.`date "+%Y%m%d"`.zip

zip:
	${7Z} a ${ZIP_FILE} ${SIPENV_DIR}

########################################################################

sipenv-jcl-zip: sipenv-jcl
	${MAKE} ${MAKE_FLAGS} VERSION="${VERSION}-java" zip

sipenv-jcl-pleiades-zip: sipenv-jcl-pleiades
	${MAKE} ${MAKE_FLAGS} VERSION="${VERSION}-eclipse" zip

sipenv-git-jcl-zip: sipenv-git-jcl
	${MAKE} ${MAKE_FLAGS} VERSION="${VERSION}-git-java" zip

sipenv-git-jcl-pleiades-zip: sipenv-git-jcl-pleiades
	${MAKE} ${MAKE_FLAGS} VERSION="${VERSION}-git-eclipse" zip

sipenv-zip: sipenv-git-jcl-pleiades
	${MAKE} ${MAKE_FLAGS} VERSION="${VERSION}" zip

########################################################################

sipenv-jcl:	install-jcl
sipenv-eclipse: install-eclipse
sipenv-pleiades: install-pleiades
sipenv-jcl-pleiades: install-jcl install-pleiades
sipenv-git-jcl: install-git-jcl
sipenv-git-jcl-pleiades: install-git-jcl install-pleiades

########################################################################

${SIPENV_DIR}:
	${MKDIR} ${SIPENV_DIR}

${SIPENV_DIR}/${WORKSPACE_DIR}:
	${MKDIR} ${SIPENV_DIR}/${WORKSPACE_DIR}

${SIPENV_DIR}/${VERSION_TXT}:
	${MAKE} ${MAKE_FLAGS} ${SIPENV_DIR}
	echo -e "version=${VERSION}\r\ncreated="`date "+%Y/%m/%d %T"`"\r" > ${SIPENV_DIR}/${VERSION_TXT}

${WORK_DIR}:
	${MKDIR} ${WORK_DIR}

########################################################################

install-jdk: ${SIPENV_DIR}/${JAVA_DIR}/${JAVA_MAJOR}

install-jdk11:
	${MAKE} ${MAKE_FLAGS} JAVA_MAJOR=11 JAVA_MINOR=${JAVA11_MINOR} JAVA_PATCH=${JAVA11_PATCH} JAVA_VERSION=${JAVA11_VERSION} JAVA_ZIP=${JAVA11_ZIP} install-jdk

${SIPENV_DIR}/${JAVA_DIR}/${JAVA_MAJOR}:
	${MAKE} ${MAKE_FLAGS} ${SIPENV_DIR}
	${7Z} x ${DIST_DIR}/${JAVA_ZIP} -o${SIPENV_DIR}/${JAVA_DIR}
	${MV} ${SIPENV_DIR}/${JAVA_DIR}/jdk${JAVA_VERSION}  ${SIPENV_DIR}/${JAVA_DIR}/${JAVA_MAJOR}
	${MAKE} ${MAKE_FLAGS} ${SIPENV_DIR}/${JAVAENV_BAT}
	${MAKE} ${MAKE_FLAGS} ${SIPENV_DIR}/${VERSION_TXT}
	if [ -x ${SIPENV_DIR}/${JAVA_DIR}/${JAVA_MAJOR}/bin/java ]; then \
	    ${SIPENV_DIR}/${JAVA_DIR}/${JAVA_MAJOR}/bin/java --version 2>&1 \
		| head -1 >>  ${SIPENV_DIR}/${VERSION_TXT}; \
	fi

${SIPENV_DIR}/${JAVAENV_BAT}: ${JAVAENV_SRC}
	${MAKE} ${MAKE_FLAGS} ${SIPENV_DIR}
	cat ${JAVAENV_SRC} \
	    | ${SED} -e 's|__JAVA_DIR__|${JAVA_DIR}|g' \
	    > ${SIPENV_DIR}/${JAVAENV_BAT}
	${ATTRIB} +r +h +s ${SIPENV_DIR}/${JAVAENV_BAT}

########################################################################

install-jcl: ${SIPENV_DIR}/Java\ command-line.lnk

${SIPENV_DIR}/Java\ command-line.lnk: Java\ command-line.lnk
	${MAKE} ${MAKE_FLAGS} ${SIPENV_DIR}
	${MAKE} ${MAKE_FLAGS} ${SIPENV_DIR}/${JCLINIT_BAT}
	${CP} "Java command-line.lnk" ${SIPENV_DIR}

${SIPENV_DIR}/${JCLINIT_BAT}: ${JCLINIT_SRC}
	${MAKE} ${MAKE_FLAGS} install-jdk${JAVA_MAJOR}
	${MAKE} ${MAKE_FLAGS} ${SIPENV_DIR}
	${MAKE} ${MAKE_FLAGS} ${SIPENV_DIR}/${WORKSPACE_DIR}
	cat ${JCLINIT_SRC} \
	    | ${SED} -e 's|__VERSION__|${CLE_VERSION}|g' \
		     -e 's|__JAVA_MAJOR__|${JAVA_MAJOR}|g' \
		     -e 's|__TITLE__|${SIPENV_TITLE}|g' \
		     -e 's|__WORKSPACE_DIR__|${WORKSPACE_DIR}|g' \
	    > ${SIPENV_DIR}/${JCLINIT_BAT}
	${ATTRIB} +r +h +s ${SIPENV_DIR}/${JCLINIT_BAT}

${SIPENV_DIR}/${SETPATH_BAT}: ${SETPATH_SRC}
	${MAKE} ${MAKE_FLAGS} ${SIPENV_DIR}
	cat ${SETPATH_SRC} \
	    | ${SED} -e 's|__PORTABLEGIT_DIR__|${PORTABLEGIT_DIR}|g' \
	    > ${SIPENV_DIR}/${SETPATH_BAT}
	${ATTRIB} +r +h +s ${SIPENV_DIR}/${SETPATH_BAT}

########################################################################

ECLIPSE_INI = ${SIPENV_DIR}/${ECLIPSE_DIR}/eclipse.ini

install-pleiades: ${SIPENV_DIR}/${ECLIPSE_DIR}/plugins/jp.sourceforge.mergedoc.pleiades/pleiades.jar

${SIPENV_DIR}/${ECLIPSE_DIR}/plugins/jp.sourceforge.mergedoc.pleiades/pleiades.jar:
	${MAKE} ${MAKE_FLAGS} install-eclipse
	${MAKE} ${MAKE_FLAGS} ${WORK_DIR}/${PLEIADES_DIR}
	${FIND} ${WORK_DIR}/${PLEIADES_DIR} -mindepth 1 -maxdepth 1 ! -name "setup*" \
		-exec ${CP} -R {} ${SIPENV_DIR}/${ECLIPSE_DIR}/ \;
	# pleiades を有効化
	echo '-Xverify:none' >> ${ECLIPSE_INI}
	echo '-javaagent:plugins/jp.sourceforge.mergedoc.pleiades/pleiades.jar' >> ${ECLIPSE_INI}
	echo -e "pleiades=${PLEIADES_VERSION}\r" >>  ${SIPENV_DIR}/${VERSION_TXT}

${WORK_DIR}/${PLEIADES_DIR}:
	${MAKE} ${MAKE_FLAGS} ${WORK_DIR}
	${7Z} x ${DIST_DIR}/${PLEIADES_ZIP} -o${WORK_DIR}/${PLEIADES_DIR}

########################################################################

install-eclipse: ${SIPENV_DIR}/${ECLIPSE_DIR}

${SIPENV_DIR}/${ECLIPSE_DIR}:
	${MAKE} ${MAKE_FLAGS} install-jdk${JAVA_MAJOR}
	${7Z} x ${DIST_DIR}/${ECLIPSE_ZIP} -o${SIPENV_DIR}
	# Eclipse起動用のJREを ${JAVA_DIR}/${JAVA_MAJOR} にインストールしたバイナリに設定
	${SED} -i 's|\(-product\)|-vm\n../${JAVA_DIR}/${JAVA_MAJOR}/bin/javaw.exe\n\1|' ${ECLIPSE_INI}
	# ワークスペースを ../workspace に設定
	${MAKE} ${MAKE_FLAGS} ${SIPENV_DIR}/${ECLIPSE_WORKSPACE}
	${SED} -i 's|\(-Dosgi.instance.area.default.*\)/eclipse-workspace|\1/${ECLIPSE_WORKSPACE}|' ${ECLIPSE_INI}
	echo -e '-Duser.home=../' >> ${ECLIPSE_INI}
	# Eclipseの設定ファイルを書き換え
	${SHELL} ${ECLIPSE_CONFIG_SCRIPT} ${SIPENV_DIR}/${ECLIPSE_DIR} ${SIPENV_DIR}/${ECLIPSE_WORKSPACE}
	echo -e "eclipse=${ECLIPSE_VERSION}\r" >>  ${SIPENV_DIR}/${VERSION_TXT}

${SIPENV_DIR}/${ECLIPSE_WORKSPACE}:
	${MKDIR} ${SIPENV_DIR}/${ECLIPSE_WORKSPACE}

########################################################################

install-git-jcl: ${SIPENV_DIR}/${PORTABLEGIT_DIR}

${SIPENV_DIR}/${PORTABLEGIT_DIR}:
	${MAKE} ${MAKE_FLAGS} ${SIPENV_DIR}
	${DIST_DIR}/${PORTABLEGIT_DIST} -y -o${SIPENV_DIR}/${PORTABLEGIT_DIR}
	${MAKE} ${MAKE_FLAGS} SETPATH_SRC=${SETPATH_GIT_SRC} ${SIPENV_DIR}/${{SETPATH_BAT}
	${RM} ${SIPENV_DIR}/${JCLINIT_BAT}
	${MAKE} ${MAKE_FLAGS} JCLINIT_SRC=${JCLINIT_GIT_SRC} install-jcl
	if [ -x ${SIPENV_DIR}/${PORTABLEGIT_DIR}/bin/git ]; then \
	    ${SIPENV_DIR}/${PORTABLEGIT_DIR}/bin/git --version 2>&1 \
		| head -1 >>  ${SIPENV_DIR}/${VERSION_TXT}; \
	fi

########################################################################

clean: clean-simp clean-work

clean-simp:
	${RM} -R ${SIPENV_DIR}

clean-work:
	${RM} -R ${WORK_DIR}

clean-jcl:
	${RM} ${SIPENV_DIR}/"Java command-line.lnk"
	${RM} ${SIPENV_DIR}/${JCLINIT_BAT}

clean-java:
	${RM} -R ${SIPENV_DIR}/${JAVA_DIR}
	${RM} ${SIPENV_DIR}/${JAVAENV_BAT}

clean-eclipse:
	${RM} -R ${SIPENV_DIR}/${ECLIPSE_DIR}
	${RM} -R ${SIPENV_DIR}/${ECLIPSE_WORKSPACE}
	${RM} -R ${SIPENV_DIR}/.eclipse
	${RM} -R ${SIPENV_DIR}/.p2
	${RM} -R ${SIPENV_DIR}/.tooling

clean-portablegit:
	${RM} -R ${SIPENV_DIR}/${PORTABLEGIT_DIR}
