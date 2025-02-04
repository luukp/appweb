#
#   appweb-vxworks-default.mk -- Makefile to build Embedthis Appweb for vxworks
#

NAME                  := appweb
VERSION               := 8.2.4
PROFILE               ?= default
ARCH                  ?= $(shell echo $(WIND_HOST_TYPE) | sed 's/-.*$(ME_ROOT_PREFIX)/')
CPU                   ?= $(subst X86,PENTIUM,$(shell echo $(ARCH) | tr a-z A-Z))
OS                    ?= vxworks
CC                    ?= cc$(subst x86,pentium,$(ARCH))
LD                    ?= ldundefined
AR                    ?= arundefined
CONFIG                ?= $(OS)-$(ARCH)-$(PROFILE)
BUILD                 ?= build/$(CONFIG)
LBIN                  ?= $(BUILD)/bin
PATH                  := $(LBIN):$(PATH)

ME_COM_CGI            ?= 0
ME_COM_COMPILER       ?= 1
ME_COM_DIR            ?= 0
ME_COM_EJS            ?= 0
ME_COM_ESP            ?= 1
ME_COM_FAST           ?= 1
ME_COM_HTTP           ?= 1
ME_COM_LIB            ?= 1
ME_COM_LINK           ?= 1
ME_COM_MATRIXSSL      ?= 0
ME_COM_MBEDTLS        ?= 1
ME_COM_MDB            ?= 1
ME_COM_MPR            ?= 1
ME_COM_NANOSSL        ?= 0
ME_COM_OPENSSL        ?= 0
ME_COM_OSDEP          ?= 1
ME_COM_PCRE           ?= 1
ME_COM_PHP            ?= 0
ME_COM_PROXY          ?= 1
ME_COM_SQLITE         ?= 0
ME_COM_SSL            ?= 1
ME_COM_VXWORKS        ?= 0
ME_COM_WATCHDOG       ?= 1

ME_COM_OPENSSL_PATH   ?= "/path/to/openssl"

ifeq ($(ME_COM_LIB),1)
    ME_COM_COMPILER := 1
endif
ifeq ($(ME_COM_LINK),1)
    ME_COM_COMPILER := 1
endif
ifeq ($(ME_COM_MBEDTLS),1)
    ME_COM_SSL := 1
endif
ifeq ($(ME_COM_OPENSSL),1)
    ME_COM_SSL := 1
endif
ifeq ($(ME_COM_ESP),1)
    ME_COM_MDB := 1
endif

export PATH           := $(WIND_GNU_PATH)/$(WIND_HOST_TYPE)/bin:$(PATH)
CFLAGS                += -fno-builtin -fno-defer-pop -fvolatile -w
DFLAGS                += -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h" $(patsubst %,-D%,$(filter ME_%,$(MAKEFLAGS))) -DME_COM_CGI=$(ME_COM_CGI) -DME_COM_COMPILER=$(ME_COM_COMPILER) -DME_COM_DIR=$(ME_COM_DIR) -DME_COM_EJS=$(ME_COM_EJS) -DME_COM_ESP=$(ME_COM_ESP) -DME_COM_FAST=$(ME_COM_FAST) -DME_COM_HTTP=$(ME_COM_HTTP) -DME_COM_LIB=$(ME_COM_LIB) -DME_COM_LINK=$(ME_COM_LINK) -DME_COM_MATRIXSSL=$(ME_COM_MATRIXSSL) -DME_COM_MBEDTLS=$(ME_COM_MBEDTLS) -DME_COM_MDB=$(ME_COM_MDB) -DME_COM_MPR=$(ME_COM_MPR) -DME_COM_NANOSSL=$(ME_COM_NANOSSL) -DME_COM_OPENSSL=$(ME_COM_OPENSSL) -DME_COM_OSDEP=$(ME_COM_OSDEP) -DME_COM_PCRE=$(ME_COM_PCRE) -DME_COM_PHP=$(ME_COM_PHP) -DME_COM_PROXY=$(ME_COM_PROXY) -DME_COM_SQLITE=$(ME_COM_SQLITE) -DME_COM_SSL=$(ME_COM_SSL) -DME_COM_VXWORKS=$(ME_COM_VXWORKS) -DME_COM_WATCHDOG=$(ME_COM_WATCHDOG) 
IFLAGS                += "-I$(BUILD)/inc"
LDFLAGS               += '-Wl,-r'
LIBPATHS              += -L$(BUILD)/bin
LIBS                  += -lgcc

DEBUG                 ?= debug
CFLAGS-debug          ?= -g
DFLAGS-debug          ?= -DME_DEBUG
LDFLAGS-debug         ?= -g
DFLAGS-release        ?= 
CFLAGS-release        ?= -O2
LDFLAGS-release       ?= 
CFLAGS                += $(CFLAGS-$(DEBUG))
DFLAGS                += $(DFLAGS-$(DEBUG))
LDFLAGS               += $(LDFLAGS-$(DEBUG))

ME_ROOT_PREFIX        ?= deploy
ME_BASE_PREFIX        ?= $(ME_ROOT_PREFIX)
ME_DATA_PREFIX        ?= $(ME_VAPP_PREFIX)
ME_STATE_PREFIX       ?= $(ME_VAPP_PREFIX)
ME_BIN_PREFIX         ?= $(ME_VAPP_PREFIX)
ME_INC_PREFIX         ?= $(ME_VAPP_PREFIX)/inc
ME_LIB_PREFIX         ?= $(ME_VAPP_PREFIX)
ME_MAN_PREFIX         ?= $(ME_VAPP_PREFIX)
ME_SBIN_PREFIX        ?= $(ME_VAPP_PREFIX)
ME_ETC_PREFIX         ?= $(ME_VAPP_PREFIX)
ME_WEB_PREFIX         ?= $(ME_VAPP_PREFIX)/web
ME_LOG_PREFIX         ?= $(ME_VAPP_PREFIX)
ME_SPOOL_PREFIX       ?= $(ME_VAPP_PREFIX)
ME_CACHE_PREFIX       ?= $(ME_VAPP_PREFIX)
ME_APP_PREFIX         ?= $(ME_BASE_PREFIX)
ME_VAPP_PREFIX        ?= $(ME_APP_PREFIX)
ME_SRC_PREFIX         ?= $(ME_ROOT_PREFIX)/usr/src/$(NAME)-$(VERSION)

WEB_USER              ?= $(shell egrep 'www-data|_www|nobody' /etc/passwd | sed 's^:.*^^' |  tail -1)
WEB_GROUP             ?= $(shell egrep 'www-data|_www|nobody|nogroup' /etc/group | sed 's^:.*^^' |  tail -1)

TARGETS               += $(BUILD)/bin/appweb.out
TARGETS               += $(BUILD)/bin/authpass.out
ifeq ($(ME_COM_ESP),1)
    TARGETS           += $(BUILD)/bin/appweb-esp.out
endif
ifeq ($(ME_COM_ESP),1)
    TARGETS           += $(BUILD)/.extras-modified
endif
ifeq ($(ME_COM_HTTP),1)
    TARGETS           += $(BUILD)/bin/http.out
endif
TARGETS               += $(BUILD)/.install-certs-modified
ifeq ($(ME_COM_SQLITE),1)
    TARGETS           += $(BUILD)/bin/libsql.out
endif
TARGETS               += $(BUILD)/bin/makerom.out
TARGETS               += $(BUILD)/bin/server.out
TARGETS               += src/server/cache
TARGETS               += $(BUILD)/bin/appman.out

unexport CDPATH

ifndef SHOW
.SILENT:
endif

all build compile: prep $(TARGETS)

.PHONY: prep

prep:
	@echo "      [Info] Use "make SHOW=1" to trace executed commands."
	@if [ "$(CONFIG)" = "" ] ; then echo WARNING: CONFIG not set ; exit 255 ; fi
	@if [ "$(ME_APP_PREFIX)" = "" ] ; then echo WARNING: ME_APP_PREFIX not set ; exit 255 ; fi
	@if [ "$(WIND_BASE)" = "" ] ; then echo WARNING: WIND_BASE not set. Run wrenv.sh. ; exit 255 ; fi
	@if [ "$(WIND_HOST_TYPE)" = "" ] ; then echo WARNING: WIND_HOST_TYPE not set. Run wrenv.sh. ; exit 255 ; fi
	@if [ "$(WIND_GNU_PATH)" = "" ] ; then echo WARNING: WIND_GNU_PATH not set. Run wrenv.sh. ; exit 255 ; fi
	@[ ! -x $(BUILD)/bin ] && mkdir -p $(BUILD)/bin; true
	@[ ! -x $(BUILD)/inc ] && mkdir -p $(BUILD)/inc; true
	@[ ! -x $(BUILD)/obj ] && mkdir -p $(BUILD)/obj; true
	@[ ! -f $(BUILD)/inc/me.h ] && cp projects/appweb-vxworks-default-me.h $(BUILD)/inc/me.h ; true
	@if ! diff $(BUILD)/inc/me.h projects/appweb-vxworks-default-me.h >/dev/null ; then\
		cp projects/appweb-vxworks-default-me.h $(BUILD)/inc/me.h  ; \
	fi; true
	@if [ -f "$(BUILD)/.makeflags" ] ; then \
		if [ "$(MAKEFLAGS)" != "`cat $(BUILD)/.makeflags`" ] ; then \
			echo "   [Warning] Make flags have changed since the last build" ; \
			echo "   [Warning] Previous build command: "`cat $(BUILD)/.makeflags`"" ; \
		fi ; \
	fi
	@echo "$(MAKEFLAGS)" >$(BUILD)/.makeflags

clean:
	rm -f "$(BUILD)/obj/appweb.o"
	rm -f "$(BUILD)/obj/authpass.o"
	rm -f "$(BUILD)/obj/cgiHandler.o"
	rm -f "$(BUILD)/obj/cgiProgram.o"
	rm -f "$(BUILD)/obj/config.o"
	rm -f "$(BUILD)/obj/convenience.o"
	rm -f "$(BUILD)/obj/esp.o"
	rm -f "$(BUILD)/obj/espHandler.o"
	rm -f "$(BUILD)/obj/espLib.o"
	rm -f "$(BUILD)/obj/fastHandler.o"
	rm -f "$(BUILD)/obj/fastProgram.o"
	rm -f "$(BUILD)/obj/http.o"
	rm -f "$(BUILD)/obj/httpLib.o"
	rm -f "$(BUILD)/obj/makerom.o"
	rm -f "$(BUILD)/obj/mbedtls.o"
	rm -f "$(BUILD)/obj/mpr-mbedtls.o"
	rm -f "$(BUILD)/obj/mpr-openssl.o"
	rm -f "$(BUILD)/obj/mpr-version.o"
	rm -f "$(BUILD)/obj/mprLib.o"
	rm -f "$(BUILD)/obj/pcre.o"
	rm -f "$(BUILD)/obj/proxyHandler.o"
	rm -f "$(BUILD)/obj/rom.o"
	rm -f "$(BUILD)/obj/server.o"
	rm -f "$(BUILD)/obj/sqlite.o"
	rm -f "$(BUILD)/obj/sqlite3.o"
	rm -f "$(BUILD)/obj/testHandler.o"
	rm -f "$(BUILD)/obj/watchdog.o"
	rm -f "$(BUILD)/bin/appweb.out"
	rm -f "$(BUILD)/bin/authpass.out"
	rm -f "$(BUILD)/bin/appweb-esp.out"
	rm -f "$(BUILD)/.extras-modified"
	rm -f "$(BUILD)/bin/http.out"
	rm -f "$(BUILD)/.install-certs-modified"
	rm -f "$(BUILD)/bin/libappweb.out"
	rm -f "$(BUILD)/bin/libesp.out"
	rm -f "$(BUILD)/bin/libhttp.out"
	rm -f "$(BUILD)/bin/libmbedtls.a"
	rm -f "$(BUILD)/bin/libmpr.out"
	rm -f "$(BUILD)/bin/libmpr-mbedtls.a"
	rm -f "$(BUILD)/bin/libmpr-version.a"
	rm -f "$(BUILD)/bin/libpcre.out"
	rm -f "$(BUILD)/bin/libsql.out"
	rm -f "$(BUILD)/bin/makerom.out"
	rm -f "$(BUILD)/bin/server.out"
	rm -f "$(BUILD)/bin/appman.out"

clobber: clean
	rm -fr ./$(BUILD)

#
#   me.h
#

$(BUILD)/inc/me.h: $(DEPS_1)

#
#   osdep.h
#
DEPS_2 += src/osdep/osdep.h
DEPS_2 += $(BUILD)/inc/me.h

$(BUILD)/inc/osdep.h: $(DEPS_2)
	@echo '      [Copy] $(BUILD)/inc/osdep.h'
	mkdir -p "$(BUILD)/inc"
	cp src/osdep/osdep.h $(BUILD)/inc/osdep.h

#
#   mpr.h
#
DEPS_3 += src/mpr/mpr.h
DEPS_3 += $(BUILD)/inc/me.h
DEPS_3 += $(BUILD)/inc/osdep.h

$(BUILD)/inc/mpr.h: $(DEPS_3)
	@echo '      [Copy] $(BUILD)/inc/mpr.h'
	mkdir -p "$(BUILD)/inc"
	cp src/mpr/mpr.h $(BUILD)/inc/mpr.h

#
#   http.h
#
DEPS_4 += src/http/http.h
DEPS_4 += $(BUILD)/inc/mpr.h

$(BUILD)/inc/http.h: $(DEPS_4)
	@echo '      [Copy] $(BUILD)/inc/http.h'
	mkdir -p "$(BUILD)/inc"
	cp src/http/http.h $(BUILD)/inc/http.h

#
#   appweb.h
#
DEPS_5 += src/appweb.h
DEPS_5 += $(BUILD)/inc/osdep.h
DEPS_5 += $(BUILD)/inc/mpr.h
DEPS_5 += $(BUILD)/inc/http.h

$(BUILD)/inc/appweb.h: $(DEPS_5)
	@echo '      [Copy] $(BUILD)/inc/appweb.h'
	mkdir -p "$(BUILD)/inc"
	cp src/appweb.h $(BUILD)/inc/appweb.h

#
#   config.h
#

$(BUILD)/inc/config.h: $(DEPS_6)

#
#   customize.h
#
DEPS_7 += src/customize.h

$(BUILD)/inc/customize.h: $(DEPS_7)
	@echo '      [Copy] $(BUILD)/inc/customize.h'
	mkdir -p "$(BUILD)/inc"
	cp src/customize.h $(BUILD)/inc/customize.h

#
#   embedtls.h
#
DEPS_8 += src/mbedtls/embedtls.h

$(BUILD)/inc/embedtls.h: $(DEPS_8)
	@echo '      [Copy] $(BUILD)/inc/embedtls.h'
	mkdir -p "$(BUILD)/inc"
	cp src/mbedtls/embedtls.h $(BUILD)/inc/embedtls.h

#
#   esp.h
#
DEPS_9 += src/esp/esp.h
DEPS_9 += $(BUILD)/inc/me.h
DEPS_9 += $(BUILD)/inc/osdep.h
DEPS_9 += $(BUILD)/inc/http.h

$(BUILD)/inc/esp.h: $(DEPS_9)
	@echo '      [Copy] $(BUILD)/inc/esp.h'
	mkdir -p "$(BUILD)/inc"
	cp src/esp/esp.h $(BUILD)/inc/esp.h

#
#   mbedtls.h
#
DEPS_10 += src/mbedtls/mbedtls.h

$(BUILD)/inc/mbedtls.h: $(DEPS_10)
	@echo '      [Copy] $(BUILD)/inc/mbedtls.h'
	mkdir -p "$(BUILD)/inc"
	cp src/mbedtls/mbedtls.h $(BUILD)/inc/mbedtls.h

#
#   mpr-version.h
#
DEPS_11 += src/mpr-version/mpr-version.h
DEPS_11 += $(BUILD)/inc/mpr.h

$(BUILD)/inc/mpr-version.h: $(DEPS_11)
	@echo '      [Copy] $(BUILD)/inc/mpr-version.h'
	mkdir -p "$(BUILD)/inc"
	cp src/mpr-version/mpr-version.h $(BUILD)/inc/mpr-version.h

#
#   pcre.h
#
DEPS_12 += src/pcre/pcre.h

$(BUILD)/inc/pcre.h: $(DEPS_12)
	@echo '      [Copy] $(BUILD)/inc/pcre.h'
	mkdir -p "$(BUILD)/inc"
	cp src/pcre/pcre.h $(BUILD)/inc/pcre.h

#
#   sqlite3.h
#
DEPS_13 += src/sqlite/sqlite3.h

$(BUILD)/inc/sqlite3.h: $(DEPS_13)
	@echo '      [Copy] $(BUILD)/inc/sqlite3.h'
	mkdir -p "$(BUILD)/inc"
	cp src/sqlite/sqlite3.h $(BUILD)/inc/sqlite3.h

#
#   sqlite3rtree.h
#

$(BUILD)/inc/sqlite3rtree.h: $(DEPS_14)

#
#   windows.h
#

$(BUILD)/inc/windows.h: $(DEPS_15)

#
#   appweb.o
#
DEPS_16 += $(BUILD)/inc/appweb.h

$(BUILD)/obj/appweb.o: \
    src/server/appweb.c $(DEPS_16)
	@echo '   [Compile] $(BUILD)/obj/appweb.o'
	$(CC) -c -o $(BUILD)/obj/appweb.o $(CFLAGS) -DME_DEBUG=1 -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h\" -D_FILE_OFFSET_BITS=64 -D_FILE_OFFSET_BITS=64 -DMBEDTLS_USER_CONFIG_FILE=\"embedtls.h\" -DME_COM_OPENSSL_PATH=$(ME_COM_OPENSSL_PATH) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/server/appweb.c

#
#   authpass.o
#
DEPS_17 += $(BUILD)/inc/appweb.h

$(BUILD)/obj/authpass.o: \
    src/utils/authpass.c $(DEPS_17)
	@echo '   [Compile] $(BUILD)/obj/authpass.o'
	$(CC) -c -o $(BUILD)/obj/authpass.o $(CFLAGS) -DME_DEBUG=1 -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h\" -D_FILE_OFFSET_BITS=64 -D_FILE_OFFSET_BITS=64 -DMBEDTLS_USER_CONFIG_FILE=\"embedtls.h\" -DME_COM_OPENSSL_PATH=$(ME_COM_OPENSSL_PATH) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/utils/authpass.c

#
#   appweb.h
#

src/appweb.h: $(DEPS_18)

#
#   cgiHandler.o
#
DEPS_19 += src/appweb.h

$(BUILD)/obj/cgiHandler.o: \
    src/modules/cgiHandler.c $(DEPS_19)
	@echo '   [Compile] $(BUILD)/obj/cgiHandler.o'
	$(CC) -c -o $(BUILD)/obj/cgiHandler.o $(CFLAGS) -DME_DEBUG=1 -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h\" -D_FILE_OFFSET_BITS=64 -D_FILE_OFFSET_BITS=64 -DMBEDTLS_USER_CONFIG_FILE=\"embedtls.h\" -DME_COM_OPENSSL_PATH=$(ME_COM_OPENSSL_PATH) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/modules/cgiHandler.c

#
#   cgiProgram.o
#

$(BUILD)/obj/cgiProgram.o: \
    src/utils/cgiProgram.c $(DEPS_20)
	@echo '   [Compile] $(BUILD)/obj/cgiProgram.o'
	$(CC) -c -o $(BUILD)/obj/cgiProgram.o $(CFLAGS) -DME_DEBUG=1 -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h\" $(IFLAGS) src/utils/cgiProgram.c

#
#   config.o
#
DEPS_21 += src/appweb.h
DEPS_21 += $(BUILD)/inc/pcre.h

$(BUILD)/obj/config.o: \
    src/config.c $(DEPS_21)
	@echo '   [Compile] $(BUILD)/obj/config.o'
	$(CC) -c -o $(BUILD)/obj/config.o $(CFLAGS) -DME_DEBUG=1 -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h\" -D_FILE_OFFSET_BITS=64 -D_FILE_OFFSET_BITS=64 -DMBEDTLS_USER_CONFIG_FILE=\"embedtls.h\" -DME_COM_OPENSSL_PATH=$(ME_COM_OPENSSL_PATH) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/config.c

#
#   convenience.o
#
DEPS_22 += src/appweb.h

$(BUILD)/obj/convenience.o: \
    src/convenience.c $(DEPS_22)
	@echo '   [Compile] $(BUILD)/obj/convenience.o'
	$(CC) -c -o $(BUILD)/obj/convenience.o $(CFLAGS) -DME_DEBUG=1 -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h\" -D_FILE_OFFSET_BITS=64 -D_FILE_OFFSET_BITS=64 -DMBEDTLS_USER_CONFIG_FILE=\"embedtls.h\" -DME_COM_OPENSSL_PATH=$(ME_COM_OPENSSL_PATH) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/convenience.c

#
#   esp.h
#

src/esp/esp.h: $(DEPS_23)

#
#   esp.o
#
DEPS_24 += src/esp/esp.h
DEPS_24 += $(BUILD)/inc/mpr-version.h

$(BUILD)/obj/esp.o: \
    src/esp/esp.c $(DEPS_24)
	@echo '   [Compile] $(BUILD)/obj/esp.o'
	$(CC) -c -o $(BUILD)/obj/esp.o $(CFLAGS) -DME_DEBUG=1 -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h\" -D_FILE_OFFSET_BITS=64 -D_FILE_OFFSET_BITS=64 -DMBEDTLS_USER_CONFIG_FILE=\"embedtls.h\" -DME_COM_OPENSSL_PATH=$(ME_COM_OPENSSL_PATH) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/esp/esp.c

#
#   espHandler.o
#
DEPS_25 += src/appweb.h
DEPS_25 += $(BUILD)/inc/esp.h

$(BUILD)/obj/espHandler.o: \
    src/modules/espHandler.c $(DEPS_25)
	@echo '   [Compile] $(BUILD)/obj/espHandler.o'
	$(CC) -c -o $(BUILD)/obj/espHandler.o $(CFLAGS) -DME_DEBUG=1 -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h\" -D_FILE_OFFSET_BITS=64 -D_FILE_OFFSET_BITS=64 -DMBEDTLS_USER_CONFIG_FILE=\"embedtls.h\" -DME_COM_OPENSSL_PATH=$(ME_COM_OPENSSL_PATH) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/modules/espHandler.c

#
#   espLib.o
#
DEPS_26 += src/esp/esp.h
DEPS_26 += $(BUILD)/inc/pcre.h
DEPS_26 += $(BUILD)/inc/http.h

$(BUILD)/obj/espLib.o: \
    src/esp/espLib.c $(DEPS_26)
	@echo '   [Compile] $(BUILD)/obj/espLib.o'
	$(CC) -c -o $(BUILD)/obj/espLib.o $(CFLAGS) -DME_DEBUG=1 -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h\" -D_FILE_OFFSET_BITS=64 -D_FILE_OFFSET_BITS=64 -DMBEDTLS_USER_CONFIG_FILE=\"embedtls.h\" -DME_COM_OPENSSL_PATH=$(ME_COM_OPENSSL_PATH) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/esp/espLib.c

#
#   fastHandler.o
#
DEPS_27 += src/appweb.h

$(BUILD)/obj/fastHandler.o: \
    src/modules/fastHandler.c $(DEPS_27)
	@echo '   [Compile] $(BUILD)/obj/fastHandler.o'
	$(CC) -c -o $(BUILD)/obj/fastHandler.o $(CFLAGS) -DME_DEBUG=1 -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h\" -D_FILE_OFFSET_BITS=64 -D_FILE_OFFSET_BITS=64 -DMBEDTLS_USER_CONFIG_FILE=\"embedtls.h\" -DME_COM_OPENSSL_PATH=$(ME_COM_OPENSSL_PATH) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/modules/fastHandler.c

#
#   fcgiapp.h
#

../../../../usr/local/include/fcgiapp.h: $(DEPS_28)

#
#   fastProgram.o
#
DEPS_29 += ../../../../usr/local/include/fcgiapp.h

$(BUILD)/obj/fastProgram.o: \
    src/utils/fastProgram.c $(DEPS_29)
	@echo '   [Compile] $(BUILD)/obj/fastProgram.o'
	$(CC) -c -o $(BUILD)/obj/fastProgram.o $(CFLAGS) -DME_DEBUG=1 -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h\" "-I/usr/local/include" src/utils/fastProgram.c

#
#   http.h
#

src/http/http.h: $(DEPS_30)

#
#   http.o
#
DEPS_31 += src/http/http.h

$(BUILD)/obj/http.o: \
    src/http/http.c $(DEPS_31)
	@echo '   [Compile] $(BUILD)/obj/http.o'
	$(CC) -c -o $(BUILD)/obj/http.o $(CFLAGS) -DME_DEBUG=1 -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h\" -D_FILE_OFFSET_BITS=64 -D_FILE_OFFSET_BITS=64 -DMBEDTLS_USER_CONFIG_FILE=\"embedtls.h\" -DME_COM_OPENSSL_PATH=$(ME_COM_OPENSSL_PATH) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/http/http.c

#
#   httpLib.o
#
DEPS_32 += src/http/http.h
DEPS_32 += $(BUILD)/inc/pcre.h

$(BUILD)/obj/httpLib.o: \
    src/http/httpLib.c $(DEPS_32)
	@echo '   [Compile] $(BUILD)/obj/httpLib.o'
	$(CC) -c -o $(BUILD)/obj/httpLib.o $(CFLAGS) -DME_DEBUG=1 -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h\" -D_FILE_OFFSET_BITS=64 -D_FILE_OFFSET_BITS=64 -DMBEDTLS_USER_CONFIG_FILE=\"embedtls.h\" -DME_COM_OPENSSL_PATH=$(ME_COM_OPENSSL_PATH) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/http/httpLib.c

#
#   makerom.o
#
DEPS_33 += $(BUILD)/inc/mpr.h

$(BUILD)/obj/makerom.o: \
    src/makerom/makerom.c $(DEPS_33)
	@echo '   [Compile] $(BUILD)/obj/makerom.o'
	$(CC) -c -o $(BUILD)/obj/makerom.o $(CFLAGS) -DME_DEBUG=1 -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h\" -D_FILE_OFFSET_BITS=64 -D_FILE_OFFSET_BITS=64 -DMBEDTLS_USER_CONFIG_FILE=\"embedtls.h\" -DME_COM_OPENSSL_PATH=$(ME_COM_OPENSSL_PATH) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/makerom/makerom.c

#
#   mbedtls.h
#

src/mbedtls/mbedtls.h: $(DEPS_34)

#
#   mbedtls.o
#
DEPS_35 += src/mbedtls/mbedtls.h

$(BUILD)/obj/mbedtls.o: \
    src/mbedtls/mbedtls.c $(DEPS_35)
	@echo '   [Compile] $(BUILD)/obj/mbedtls.o'
	$(CC) -c -o $(BUILD)/obj/mbedtls.o $(CFLAGS) -DME_DEBUG=1 -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h\" -DMBEDTLS_USER_CONFIG_FILE=\"embedtls.h\" $(IFLAGS) src/mbedtls/mbedtls.c

#
#   mpr-mbedtls.o
#
DEPS_36 += $(BUILD)/inc/mpr.h

$(BUILD)/obj/mpr-mbedtls.o: \
    src/mpr-mbedtls/mpr-mbedtls.c $(DEPS_36)
	@echo '   [Compile] $(BUILD)/obj/mpr-mbedtls.o'
	$(CC) -c -o $(BUILD)/obj/mpr-mbedtls.o $(CFLAGS) -DME_DEBUG=1 -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h\" -D_FILE_OFFSET_BITS=64 -DMBEDTLS_USER_CONFIG_FILE=\"embedtls.h\" $(IFLAGS) src/mpr-mbedtls/mpr-mbedtls.c

#
#   mpr-openssl.o
#
DEPS_37 += $(BUILD)/inc/mpr.h

$(BUILD)/obj/mpr-openssl.o: \
    src/mpr-openssl/mpr-openssl.c $(DEPS_37)
	@echo '   [Compile] $(BUILD)/obj/mpr-openssl.o'
	$(CC) -c -o $(BUILD)/obj/mpr-openssl.o $(CFLAGS) -DME_DEBUG=1 -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h\" $(IFLAGS) "-I$(BUILD)/inc" "-I$(ME_COM_OPENSSL_PATH)/include" src/mpr-openssl/mpr-openssl.c

#
#   mpr-version.h
#

src/mpr-version/mpr-version.h: $(DEPS_38)

#
#   mpr-version.o
#
DEPS_39 += src/mpr-version/mpr-version.h
DEPS_39 += $(BUILD)/inc/pcre.h

$(BUILD)/obj/mpr-version.o: \
    src/mpr-version/mpr-version.c $(DEPS_39)
	@echo '   [Compile] $(BUILD)/obj/mpr-version.o'
	$(CC) -c -o $(BUILD)/obj/mpr-version.o $(CFLAGS) -DME_DEBUG=1 -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h\" $(IFLAGS) src/mpr-version/mpr-version.c

#
#   mpr.h
#

src/mpr/mpr.h: $(DEPS_40)

#
#   mprLib.o
#
DEPS_41 += src/mpr/mpr.h

$(BUILD)/obj/mprLib.o: \
    src/mpr/mprLib.c $(DEPS_41)
	@echo '   [Compile] $(BUILD)/obj/mprLib.o'
	$(CC) -c -o $(BUILD)/obj/mprLib.o $(CFLAGS) -DME_DEBUG=1 -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h\" -D_FILE_OFFSET_BITS=64 -D_FILE_OFFSET_BITS=64 -DMBEDTLS_USER_CONFIG_FILE=\"embedtls.h\" -DME_COM_OPENSSL_PATH=$(ME_COM_OPENSSL_PATH) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/mpr/mprLib.c

#
#   pcre.h
#

src/pcre/pcre.h: $(DEPS_42)

#
#   pcre.o
#
DEPS_43 += $(BUILD)/inc/me.h
DEPS_43 += src/pcre/pcre.h

$(BUILD)/obj/pcre.o: \
    src/pcre/pcre.c $(DEPS_43)
	@echo '   [Compile] $(BUILD)/obj/pcre.o'
	$(CC) -c -o $(BUILD)/obj/pcre.o $(CFLAGS) -DME_DEBUG=1 -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h\" $(IFLAGS) src/pcre/pcre.c

#
#   proxyHandler.o
#
DEPS_44 += src/appweb.h

$(BUILD)/obj/proxyHandler.o: \
    src/modules/proxyHandler.c $(DEPS_44)
	@echo '   [Compile] $(BUILD)/obj/proxyHandler.o'
	$(CC) -c -o $(BUILD)/obj/proxyHandler.o $(CFLAGS) -DME_DEBUG=1 -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h\" -D_FILE_OFFSET_BITS=64 -D_FILE_OFFSET_BITS=64 -DMBEDTLS_USER_CONFIG_FILE=\"embedtls.h\" -DME_COM_OPENSSL_PATH=$(ME_COM_OPENSSL_PATH) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/modules/proxyHandler.c

#
#   rom.o
#
DEPS_45 += $(BUILD)/inc/mpr.h

$(BUILD)/obj/rom.o: \
    src/rom.c $(DEPS_45)
	@echo '   [Compile] $(BUILD)/obj/rom.o'
	$(CC) -c -o $(BUILD)/obj/rom.o $(CFLAGS) -DME_DEBUG=1 -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h\" -D_FILE_OFFSET_BITS=64 -D_FILE_OFFSET_BITS=64 -DMBEDTLS_USER_CONFIG_FILE=\"embedtls.h\" -DME_COM_OPENSSL_PATH=$(ME_COM_OPENSSL_PATH) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/rom.c

#
#   server.o
#
DEPS_46 += src/http/http.h

$(BUILD)/obj/server.o: \
    src/http/server.c $(DEPS_46)
	@echo '   [Compile] $(BUILD)/obj/server.o'
	$(CC) -c -o $(BUILD)/obj/server.o $(CFLAGS) -DME_DEBUG=1 -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h\" -D_FILE_OFFSET_BITS=64 -D_FILE_OFFSET_BITS=64 -DMBEDTLS_USER_CONFIG_FILE=\"embedtls.h\" -DME_COM_OPENSSL_PATH=$(ME_COM_OPENSSL_PATH) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/http/server.c

#
#   sqlite3.h
#

src/sqlite/sqlite3.h: $(DEPS_47)

#
#   sqlite.o
#
DEPS_48 += $(BUILD)/inc/me.h
DEPS_48 += src/sqlite/sqlite3.h
DEPS_48 += $(BUILD)/inc/windows.h

$(BUILD)/obj/sqlite.o: \
    src/sqlite/sqlite.c $(DEPS_48)
	@echo '   [Compile] $(BUILD)/obj/sqlite.o'
	$(CC) -c -o $(BUILD)/obj/sqlite.o $(CFLAGS) -DME_DEBUG=1 -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h\" $(IFLAGS) src/sqlite/sqlite.c

#
#   sqlite3.o
#
DEPS_49 += $(BUILD)/inc/me.h
DEPS_49 += src/sqlite/sqlite3.h
DEPS_49 += $(BUILD)/inc/config.h
DEPS_49 += $(BUILD)/inc/windows.h
DEPS_49 += $(BUILD)/inc/sqlite3rtree.h

$(BUILD)/obj/sqlite3.o: \
    src/sqlite/sqlite3.c $(DEPS_49)
	@echo '   [Compile] $(BUILD)/obj/sqlite3.o'
	$(CC) -c -o $(BUILD)/obj/sqlite3.o $(CFLAGS) -DME_DEBUG=1 -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h\" $(IFLAGS) src/sqlite/sqlite3.c

#
#   testHandler.o
#
DEPS_50 += src/appweb.h

$(BUILD)/obj/testHandler.o: \
    src/modules/testHandler.c $(DEPS_50)
	@echo '   [Compile] $(BUILD)/obj/testHandler.o'
	$(CC) -c -o $(BUILD)/obj/testHandler.o $(CFLAGS) -DME_DEBUG=1 -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h\" -D_FILE_OFFSET_BITS=64 -D_FILE_OFFSET_BITS=64 -DMBEDTLS_USER_CONFIG_FILE=\"embedtls.h\" -DME_COM_OPENSSL_PATH=$(ME_COM_OPENSSL_PATH) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/modules/testHandler.c

#
#   watchdog.o
#
DEPS_51 += $(BUILD)/inc/mpr.h

$(BUILD)/obj/watchdog.o: \
    src/watchdog/watchdog.c $(DEPS_51)
	@echo '   [Compile] $(BUILD)/obj/watchdog.o'
	$(CC) -c -o $(BUILD)/obj/watchdog.o $(CFLAGS) -DME_DEBUG=1 -DVXWORKS -DRW_MULTI_THREAD -DCPU=PENTIUM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_GNU_TOOL -D_WRS_KERNEL_ -D_VSB_CONFIG_FILE=\"/WindRiver/vxworks-7/samples/prebuilt_projects/vsb_vxsim_linux/h/config/vsbConfig.h\" -D_FILE_OFFSET_BITS=64 -D_FILE_OFFSET_BITS=64 -DMBEDTLS_USER_CONFIG_FILE=\"embedtls.h\" -DME_COM_OPENSSL_PATH=$(ME_COM_OPENSSL_PATH) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/watchdog/watchdog.c

ifeq ($(ME_COM_MBEDTLS),1)
#
#   libmbedtls
#
DEPS_52 += $(BUILD)/inc/osdep.h
DEPS_52 += $(BUILD)/inc/embedtls.h
DEPS_52 += $(BUILD)/inc/mbedtls.h
DEPS_52 += $(BUILD)/obj/mbedtls.o

$(BUILD)/bin/libmbedtls.a: $(DEPS_52)
	@echo '      [Link] $(BUILD)/bin/libmbedtls.a'
	$(AR) -cr $(BUILD)/bin/libmbedtls.a "$(BUILD)/obj/mbedtls.o"
endif

ifeq ($(ME_COM_MBEDTLS),1)
#
#   libmpr-mbedtls
#
DEPS_53 += $(BUILD)/bin/libmbedtls.a
DEPS_53 += $(BUILD)/obj/mpr-mbedtls.o

$(BUILD)/bin/libmpr-mbedtls.a: $(DEPS_53)
	@echo '      [Link] $(BUILD)/bin/libmpr-mbedtls.a'
	$(AR) -cr $(BUILD)/bin/libmpr-mbedtls.a "$(BUILD)/obj/mpr-mbedtls.o"
endif

ifeq ($(ME_COM_OPENSSL),1)
#
#   libmpr-openssl
#
DEPS_54 += $(BUILD)/obj/mpr-openssl.o

$(BUILD)/bin/libmpr-openssl.a: $(DEPS_54)
	@echo '      [Link] $(BUILD)/bin/libmpr-openssl.a'
	$(AR) -cr $(BUILD)/bin/libmpr-openssl.a "$(BUILD)/obj/mpr-openssl.o"
endif

#
#   libmpr
#
DEPS_55 += $(BUILD)/inc/osdep.h
ifeq ($(ME_COM_MBEDTLS),1)
    DEPS_55 += $(BUILD)/bin/libmpr-mbedtls.a
endif
ifeq ($(ME_COM_MBEDTLS),1)
    DEPS_55 += $(BUILD)/bin/libmbedtls.a
endif
ifeq ($(ME_COM_OPENSSL),1)
    DEPS_55 += $(BUILD)/bin/libmpr-openssl.a
endif
DEPS_55 += $(BUILD)/inc/mpr.h
DEPS_55 += $(BUILD)/obj/mprLib.o

ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_55 += -lssl
    LIBPATHS_55 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_55 += -lcrypto
    LIBPATHS_55 += -L"$(ME_COM_OPENSSL_PATH)"
endif

$(BUILD)/bin/libmpr.out: $(DEPS_55)
	@echo '      [Link] $(BUILD)/bin/libmpr.out'
	$(CC) -r -o $(BUILD)/bin/libmpr.out $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/mprLib.o" -lmpr-openssl $(LIBPATHS_55) $(LIBS_55) $(LIBS_55) $(LIBS) -lmpr-mbedtls -lmbedtls 

ifeq ($(ME_COM_PCRE),1)
#
#   libpcre
#
DEPS_56 += $(BUILD)/inc/pcre.h
DEPS_56 += $(BUILD)/obj/pcre.o

$(BUILD)/bin/libpcre.out: $(DEPS_56)
	@echo '      [Link] $(BUILD)/bin/libpcre.out'
	$(CC) -r -o $(BUILD)/bin/libpcre.out $(LDFLAGS) $(LIBPATHS) "$(BUILD)/obj/pcre.o" $(LIBS) 
endif

ifeq ($(ME_COM_HTTP),1)
#
#   libhttp
#
DEPS_57 += $(BUILD)/bin/libmpr.out
ifeq ($(ME_COM_PCRE),1)
    DEPS_57 += $(BUILD)/bin/libpcre.out
endif
DEPS_57 += $(BUILD)/inc/http.h
DEPS_57 += $(BUILD)/obj/httpLib.o

ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_57 += -lssl
    LIBPATHS_57 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_57 += -lcrypto
    LIBPATHS_57 += -L"$(ME_COM_OPENSSL_PATH)"
endif

$(BUILD)/bin/libhttp.out: $(DEPS_57)
	@echo '      [Link] $(BUILD)/bin/libhttp.out'
	$(CC) -r -o $(BUILD)/bin/libhttp.out $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/httpLib.o" $(LIBPATHS_57) $(LIBS_57) $(LIBS_57) $(LIBS) -lmpr-openssl -lmpr-mbedtls -lmbedtls 
endif

#
#   libmpr-version
#
DEPS_58 += $(BUILD)/inc/mpr-version.h
DEPS_58 += $(BUILD)/obj/mpr-version.o

$(BUILD)/bin/libmpr-version.a: $(DEPS_58)
	@echo '      [Link] $(BUILD)/bin/libmpr-version.a'
	$(AR) -cr $(BUILD)/bin/libmpr-version.a "$(BUILD)/obj/mpr-version.o"

ifeq ($(ME_COM_ESP),1)
#
#   libesp
#
ifeq ($(ME_COM_HTTP),1)
    DEPS_59 += $(BUILD)/bin/libhttp.out
endif
DEPS_59 += $(BUILD)/bin/libmpr-version.a
ifeq ($(ME_COM_SQLITE),1)
    DEPS_59 += $(BUILD)/bin/libsql.out
endif
DEPS_59 += $(BUILD)/inc/esp.h
DEPS_59 += $(BUILD)/obj/espLib.o
ifeq ($(ME_COM_SQLITE),1)
    DEPS_59 += $(BUILD)/bin/libsql.out
endif

ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_59 += -lssl
    LIBPATHS_59 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_59 += -lcrypto
    LIBPATHS_59 += -L"$(ME_COM_OPENSSL_PATH)"
endif

$(BUILD)/bin/libesp.out: $(DEPS_59)
	@echo '      [Link] $(BUILD)/bin/libesp.out'
	$(CC) -r -o $(BUILD)/bin/libesp.out $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/espLib.o" $(LIBPATHS_59) $(LIBS_59) $(LIBS_59) $(LIBS) -lmpr-version -lmpr-openssl -lmpr-mbedtls -lmbedtls 
endif

#
#   libappweb
#
ifeq ($(ME_COM_ESP),1)
    DEPS_60 += $(BUILD)/bin/libesp.out
endif
ifeq ($(ME_COM_SQLITE),1)
    DEPS_60 += $(BUILD)/bin/libsql.out
endif
ifeq ($(ME_COM_HTTP),1)
    DEPS_60 += $(BUILD)/bin/libhttp.out
endif
DEPS_60 += $(BUILD)/bin/libmpr.out
DEPS_60 += $(BUILD)/bin/libmpr-version.a
DEPS_60 += $(BUILD)/inc/appweb.h
DEPS_60 += $(BUILD)/inc/customize.h
DEPS_60 += $(BUILD)/obj/config.o
DEPS_60 += $(BUILD)/obj/convenience.o
DEPS_60 += $(BUILD)/obj/cgiHandler.o
DEPS_60 += $(BUILD)/obj/espHandler.o
DEPS_60 += $(BUILD)/obj/fastHandler.o
DEPS_60 += $(BUILD)/obj/proxyHandler.o
DEPS_60 += $(BUILD)/obj/testHandler.o
DEPS_60 += $(BUILD)/obj/rom.o

ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_60 += -lssl
    LIBPATHS_60 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_60 += -lcrypto
    LIBPATHS_60 += -L"$(ME_COM_OPENSSL_PATH)"
endif

$(BUILD)/bin/libappweb.out: $(DEPS_60)
	@echo '      [Link] $(BUILD)/bin/libappweb.out'
	$(CC) -r -o $(BUILD)/bin/libappweb.out $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/config.o" "$(BUILD)/obj/convenience.o" "$(BUILD)/obj/cgiHandler.o" "$(BUILD)/obj/espHandler.o" "$(BUILD)/obj/fastHandler.o" "$(BUILD)/obj/proxyHandler.o" "$(BUILD)/obj/testHandler.o" "$(BUILD)/obj/rom.o" $(LIBPATHS_60) $(LIBS_60) $(LIBS_60) $(LIBS) -lmpr-version -lmpr-openssl -lmpr-mbedtls -lmbedtls 

#
#   appweb
#
DEPS_61 += $(BUILD)/bin/libappweb.out
DEPS_61 += $(BUILD)/obj/appweb.o

ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_61 += -lssl
    LIBPATHS_61 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_61 += -lcrypto
    LIBPATHS_61 += -L"$(ME_COM_OPENSSL_PATH)"
endif

$(BUILD)/bin/appweb.out: $(DEPS_61)
	@echo '      [Link] $(BUILD)/bin/appweb.out'
	$(CC) -o $(BUILD)/bin/appweb.out $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/appweb.o" $(LIBPATHS_61) $(LIBS_61) $(LIBS_61) $(LIBS) -lmpr-version -lmpr-openssl -lmpr-mbedtls -lmbedtls -Wl,-r 

#
#   authpass
#
DEPS_62 += $(BUILD)/bin/libappweb.out
DEPS_62 += $(BUILD)/obj/authpass.o

ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_62 += -lssl
    LIBPATHS_62 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_62 += -lcrypto
    LIBPATHS_62 += -L"$(ME_COM_OPENSSL_PATH)"
endif

$(BUILD)/bin/authpass.out: $(DEPS_62)
	@echo '      [Link] $(BUILD)/bin/authpass.out'
	$(CC) -o $(BUILD)/bin/authpass.out $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/authpass.o" $(LIBPATHS_62) $(LIBS_62) $(LIBS_62) $(LIBS) -lmpr-version -lmpr-openssl -lmpr-mbedtls -lmbedtls -Wl,-r 

ifeq ($(ME_COM_ESP),1)
#
#   espcmd
#
DEPS_63 += $(BUILD)/bin/libesp.out
ifeq ($(ME_COM_SQLITE),1)
    DEPS_63 += $(BUILD)/bin/libsql.out
endif
DEPS_63 += $(BUILD)/obj/esp.o

ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_63 += -lssl
    LIBPATHS_63 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_63 += -lcrypto
    LIBPATHS_63 += -L"$(ME_COM_OPENSSL_PATH)"
endif

$(BUILD)/bin/appweb-esp.out: $(DEPS_63)
	@echo '      [Link] $(BUILD)/bin/appweb-esp.out'
	$(CC) -o $(BUILD)/bin/appweb-esp.out $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/esp.o" $(LIBPATHS_63) $(LIBS_63) $(LIBS_63) $(LIBS) -lmpr-version -lmpr-openssl -lmpr-mbedtls -lmbedtls -Wl,-r 
endif

ifeq ($(ME_COM_ESP),1)
#
#   extras
#
DEPS_64 += src/esp/esp-compile.json
DEPS_64 += src/esp/vcvars.bat

$(BUILD)/.extras-modified: $(DEPS_64)
	@echo '      [Copy] $(BUILD)/bin'
	mkdir -p "$(BUILD)/bin"
	cp src/esp/esp-compile.json $(BUILD)/bin/esp-compile.json
	cp src/esp/vcvars.bat $(BUILD)/bin/vcvars.bat
	touch "$(BUILD)/.extras-modified"
endif

ifeq ($(ME_COM_HTTP),1)
#
#   httpcmd
#
DEPS_65 += $(BUILD)/bin/libhttp.out
DEPS_65 += $(BUILD)/obj/http.o

ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_65 += -lssl
    LIBPATHS_65 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_65 += -lcrypto
    LIBPATHS_65 += -L"$(ME_COM_OPENSSL_PATH)"
endif

$(BUILD)/bin/http.out: $(DEPS_65)
	@echo '      [Link] $(BUILD)/bin/http.out'
	$(CC) -o $(BUILD)/bin/http.out $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/http.o" $(LIBPATHS_65) $(LIBS_65) $(LIBS_65) $(LIBS) -lmpr-openssl -lmpr-mbedtls -lmbedtls -Wl,-r 
endif

#
#   installPrep
#

installPrep: $(DEPS_66)
	if [ "`id -u`" != 0 ] ; \
	then echo "Must run as root. Rerun with sudo." ; \
	exit 255 ; \
	fi

#
#   install-certs
#
DEPS_67 += src/certs/samples/ca.crt
DEPS_67 += src/certs/samples/ca.key
DEPS_67 += src/certs/samples/ec.crt
DEPS_67 += src/certs/samples/ec.key
DEPS_67 += src/certs/samples/roots.crt
DEPS_67 += src/certs/samples/self.crt
DEPS_67 += src/certs/samples/self.key
DEPS_67 += src/certs/samples/test.crt
DEPS_67 += src/certs/samples/test.key

$(BUILD)/.install-certs-modified: $(DEPS_67)
	@echo '      [Copy] $(BUILD)/bin'
	mkdir -p "$(BUILD)/bin"
	cp src/certs/samples/ca.crt $(BUILD)/bin/ca.crt
	cp src/certs/samples/ca.key $(BUILD)/bin/ca.key
	cp src/certs/samples/ec.crt $(BUILD)/bin/ec.crt
	cp src/certs/samples/ec.key $(BUILD)/bin/ec.key
	cp src/certs/samples/roots.crt $(BUILD)/bin/roots.crt
	cp src/certs/samples/self.crt $(BUILD)/bin/self.crt
	cp src/certs/samples/self.key $(BUILD)/bin/self.key
	cp src/certs/samples/test.crt $(BUILD)/bin/test.crt
	cp src/certs/samples/test.key $(BUILD)/bin/test.key
	touch "$(BUILD)/.install-certs-modified"

ifeq ($(ME_COM_SQLITE),1)
#
#   libsql
#
DEPS_68 += $(BUILD)/inc/sqlite3.h
DEPS_68 += $(BUILD)/obj/sqlite3.o

$(BUILD)/bin/libsql.out: $(DEPS_68)
	@echo '      [Link] $(BUILD)/bin/libsql.out'
	$(CC) -r -o $(BUILD)/bin/libsql.out $(LDFLAGS) $(LIBPATHS) "$(BUILD)/obj/sqlite3.o" $(LIBS) 
endif

#
#   makerom
#
DEPS_69 += $(BUILD)/bin/libmpr.out
DEPS_69 += $(BUILD)/obj/makerom.o

ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_69 += -lssl
    LIBPATHS_69 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_69 += -lcrypto
    LIBPATHS_69 += -L"$(ME_COM_OPENSSL_PATH)"
endif

$(BUILD)/bin/makerom.out: $(DEPS_69)
	@echo '      [Link] $(BUILD)/bin/makerom.out'
	$(CC) -o $(BUILD)/bin/makerom.out $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/makerom.o" $(LIBPATHS_69) $(LIBS_69) $(LIBS_69) $(LIBS) -lmpr-openssl -lmpr-mbedtls -lmbedtls -Wl,-r 

#
#   server
#
ifeq ($(ME_COM_HTTP),1)
    DEPS_70 += $(BUILD)/bin/libhttp.out
endif
DEPS_70 += $(BUILD)/obj/server.o

ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_70 += -lssl
    LIBPATHS_70 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_70 += -lcrypto
    LIBPATHS_70 += -L"$(ME_COM_OPENSSL_PATH)"
endif

$(BUILD)/bin/server.out: $(DEPS_70)
	@echo '      [Link] $(BUILD)/bin/server.out'
	$(CC) -o $(BUILD)/bin/server.out $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/server.o" $(LIBPATHS_70) $(LIBS_70) $(LIBS_70) $(LIBS) -lmpr-openssl -lmpr-mbedtls -lmbedtls -Wl,-r 

#
#   server-cache
#

src/server/cache: $(DEPS_71)
	( \
	cd src/server; \
	mkdir -p "cache" ; \
	)

ifeq ($(ME_COM_WATCHDOG),1)
#
#   watchdog
#
DEPS_72 += $(BUILD)/bin/libmpr.out
DEPS_72 += $(BUILD)/obj/watchdog.o

ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_72 += -lssl
    LIBPATHS_72 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_72 += -lcrypto
    LIBPATHS_72 += -L"$(ME_COM_OPENSSL_PATH)"
endif

$(BUILD)/bin/appman.out: $(DEPS_72)
	@echo '      [Link] $(BUILD)/bin/appman.out'
	$(CC) -o $(BUILD)/bin/appman.out $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/watchdog.o" -lmpr-openssl $(LIBPATHS_72) $(LIBS_72) $(LIBS_72) $(LIBS) -lmpr-mbedtls -lmbedtls -Wl,-r 
endif

#
#   installBinary
#

installBinary: $(DEPS_73)

#
#   install
#
DEPS_74 += installPrep
DEPS_74 += compile
DEPS_74 += stop
DEPS_74 += installBinary
DEPS_74 += start

install: $(DEPS_74)

#
#   run
#
DEPS_75 += compile

run: $(DEPS_75)
	( \
	cd src/server; \
	../../$(BUILD)/bin/appweb --log stdout:2 ; \
	)

#
#   uninstall
#
DEPS_76 += stop

uninstall: $(DEPS_76)
	( \
	cd installs; \
	rm -f "$(ME_VAPP_PREFIX)/appweb.conf" ; \
	rm -f "$(ME_VAPP_PREFIX)/esp.conf" ; \
	rm -f "$(ME_VAPP_PREFIX)/mine.types" ; \
	rm -f "$(ME_VAPP_PREFIX)/install.conf" ; \
	rm -fr "$(ME_VAPP_PREFIX)/inc/appweb" ; \
	)

#
#   uninstallBinary
#

uninstallBinary: $(DEPS_77)

#
#   version
#

version: $(DEPS_78)
	echo $(VERSION)

