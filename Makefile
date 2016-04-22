NAME=	egzact
LOCALBASE?=	${HOME}/.egison
BINDIR?=	${LOCALBASE}/bin

COMMANDS=	$(shell ls bin | sed 's/.egi//')
DIRS=	$(shell find lib/${NAME} -type d)
LIBS=	$(shell find lib/${NAME} -type f)

SED_LIBS=	sed -e 's|../lib|${HOME}/.egison/lib|g'

INSTALL?=	install
MKDIR?=	mkdir -p
RMDIR?=	rmdir
RM?=	rm -f

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
	done
	${MKDIR} ${BINDIR}
	@for i in ${COMMANDS}; \
	do \
		echo ${INSTALL_PROGRAM} bin/$${i}.egi ${BINDIR}/$${i}; \
		${INSTALL_PROGRAM} bin/$${i}.egi ${BINDIR}/$${i}; \
		echo cat bin/$${i}.egi | ${SED_LIBS} > ${BINDIR}/$${i}; \
		cat bin/$${i}.egi | ${SED_LIBS} > ${BINDIR}/$${i}; \
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
