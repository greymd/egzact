NAME=	egzact
LOCALBASE?=	${HOME}/.egison
BINDIR?=	${LOCALBASE}/bin

COMMANDS=	$(shell /bin/ls bin | sed 's/.egi//')
DIRS=	$(shell /usr/bin/find lib/${NAME} -type d | /usr/bin/tail -r)
LIBS=	$(shell /usr/bin/find lib/${NAME} -type f)
ARGMAX=	$(shell getconf ARG_MAX)

SED_LIBS=	/usr/bin/sed -i '' -e 's|../lib|${HOME}/.egison/lib|g'
SED_ARGMAX=	/usr/bin/sed -i '' -e 's|ARGMAX 65535|ARGMAX ${ARGMAX}|g'

INSTALL?=	/usr/bin/install
MKDIR?=	/bin/mkdir -p
RMDIR?=	/bin/rmdir
RM?=	/bin/rm -f

INSTALL_PROGRAM=${INSTALL} -m ${BINMODE}
INSTALL_LIBS=	${INSTALL} -m ${DOCMODE}
BINMODE=	755
DOCMODE=	644

all:
	@echo "Run 'make install' to install"

install:
	@for i in ${DIRS}; \
	do \
		echo ${MKDIR} ${LOCALBASE}/$${i}; \
		${MKDIR} ${LOCALBASE}/$${i}; \
	done
	@for i in ${LIBS}; \
	do \
		echo ${INSTALL_LIBS} $${i} ${LOCALBASE}/$${i}; \
		${INSTALL_LIBS} $${i} ${LOCALBASE}/$${i}; \
		echo ${SED_ARGMAX} ${LOCALBASE}/$${i}; \
		${SED_ARGMAX} ${LOCALBASE}/$${i}; \
	done
	${MKDIR} ${BINDIR}
	@for i in ${COMMANDS}; \
	do \
		echo ${INSTALL_PROGRAM} bin/$${i}.egi ${BINDIR}/$${i}; \
		${INSTALL_PROGRAM} bin/$${i}.egi ${BINDIR}/$${i}; \
		echo ${SED_LIBS} ${BINDIR}/$${i}; \
		${SED_LIBS} ${BINDIR}/$${i}; \
	done

uninstall:
	@for i in ${LIBS}; \
	do \
		echo ${RM} ${LOCALBASE}/$${i}; \
		${RM} ${LOCALBASE}/$${i}; \
	done
	@for i in ${DIRS}; \
	do \
		echo ${RMDIR} ${LOCALBASE}/$${i}; \
		${RMDIR} ${LOCALBASE}/$${i}; \
	done
	@for i in ${COMMANDS}; \
	do \
		echo ${RM} ${BINDIR}/$${i}; \
		${RM} ${BINDIR}/$${i}; \
	done

deinstall: uninstall
