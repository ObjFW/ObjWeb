include ../extra.mk

PROG_NOINST = tests${PROG_SUFFIX}
SRCS = OWTemplateTests.m	\
       TestsAppDelegate.m

include ../buildsys.mk

post-all: ${RUN_TESTS}

.PHONY: run
run:
	rm -f libobjweb.so.${OBJWEB_LIB_MAJOR}
	rm -f libobjweb.so.${OBJWEB_LIB_MAJOR_MINOR}
	rm -f libobjweb.dll libobjweb.${OBJWEB_LIB_MAJOR}.dylib
	if test -f ../src/libobjweb.so; then \
		${LN_S} ../src/libobjweb.so libobjweb.so.${OBJWEB_LIB_MAJOR}; \
		${LN_S} ../src/libobjweb.so \
			libobjweb.so.${OBJWEB_LIB_MAJOR_MINOR}; \
	elif test -f ../src/libobjweb.so.${OBJWEB_LIB_MAJOR_MINOR}; then \
		${LN_S} ../src/libobjweb.so.${OBJWEB_LIB_MAJOR_MINOR} \
			libobjweb.so.${OBJWEB_LIB_MAJOR_MINOR}; \
	fi
	if test -f ../src/libobjweb.dll; then \
		${LN_S} ../src/libobjweb.dll libobjweb.dll; \
	fi
	if test -f ../src/libobjweb.dylib; then \
		${LN_S} ../src/libobjweb.dylib \
			libobjweb.${OBJWEB_LIB_MAJOR}.dylib; \
	fi
	LD_LIBRARY_PATH=.$${LD_LIBRARY_PATH+:}$$LD_LIBRARY_PATH \
	DYLD_LIBRARY_PATH=.$${DYLD_LIBRARY_PATH+:}$$DYLD_LIBRARY_PATH \
	LIBRARY_PATH=.$${LIBRARY_PATH+:}$$LIBRARY_PATH \
	${TEST_LAUNCHER} ./${PROG_NOINST}; EXIT=$$?; \
	rm -f libobjweb.so.${OBJWEB_LIB_MAJOR}; \
	rm -f libobjweb.so.${OBJWEB_LIB_MAJOR_MINOR} libobjweb.dll; \
	rm -f libobjweb.${OBJWEB_LIB_MAJOR}.dylib; \
	exit $$EXIT

${PROG_NOINST}: ${LIBOBJWEB_DEP}

CPPFLAGS += -I../src -I../src/exceptions
LIBS += -L../src -lobjweb
LD = ${OBJC}
