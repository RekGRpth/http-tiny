#
# Makefile for http-tiny
#  written by L. Demailly
#
#  (c)1998 Laurent Demailly
#  (c)1996 Observatoire de Paris
#
# $Id: Makefile,v 1.3 1996/04/15 14:25:24 dl Exp $
#
# $Log: Makefile,v $
#

# Check the following :

prefix=/usr/local

# where to install executable
BINDIR=$(prefix)/bin
# where to put man pages
MANDIR=$(prefix)/man
# where to put lib
LIBDIR=$(prefix)/lib
# where to put include
INCDIR=$(prefix)/include

# Your compiler
CC = gcc
# Compile flags
CDEBUGFLAGS = -O -Wmissing-prototypes -Wall -ansi -pedantic
#CDEBUGFLAGS = -O

# defines
#DEFINES= -D_HPUX_SOURCE
# for HPUX (ansi)
#DEFINES= -D_HPUX_SOURCE
# for solaris some defines is needed for strncmp,... but can't find the good
# one...
#DEFINES= -D
# others, probably
DEFINES= -DVERBOSE

# Solaris
#SYSLIBS= -lsocket -lnsl

#INCLPATH =

# mostly standard
RM= rm -f
CP = cp -f
CHMOD= chmod
MKDIR= mkdir -p
AR = ar
RANLIB = ranlib
TAR= gtar

# no edit should be needed below...

CFLAGS = $(CDEBUGFLAGS) $(INCLPATH) $(DEFINES)
LDFLAGS= $(CFLAGS) -L.

LIBOBJS =  http_lib.o

TARGETS = libhttp.a http

all: $(TARGETS)

http:  http.o libhttp.a
	$(CC) $(LDFLAGS) $@.o -lhttp $(SYSLIBS) -o $@

libhttp.a:   $(LIBOBJS)
	$(RM) $@
	$(AR) r $@ $(LIBOBJS)
	$(RANLIB) $@

install: $(TARGETS)
	$(CP) http $(BINDIR)
	$(CP) libhttp.a $(LIBDIR)
	$(CP) man1/http.1 $(MANDIR)/man1
	$(CP) man3/http_lib.3 $(MANDIR)/man3
	$(CP) http_lib.h $(INCDIR)

clean: 
	$(RM) $(TARGETS)
	$(RM) *.tgz
	$(RM) *.o
	$(RM) *~
	$(RM) #*
	$(RM) core

depend:
	makedepend $(INCLPATH) $(DEFINES) *.c

# internal use

man3: http_lib.c
	$(MKDIR) $@
	( cd $@ ; c2man -i \"http_lib.h\" -ngv -ls ../http_lib.c )

fdoc:
	$(RM) -r man3
	$(MAKE) man3

pure:
	$(MAKE) clean
	$(MAKE) CC="purify gcc -g"

tar:
	$(MAKE) clean
	$(RM) -r http-tiny-$(VERSION)
	$(RM) -f http-tiny-*.tar.gz
	$(MKDIR) http-tiny-$(VERSION)
	-$(CP) * http-tiny-$(VERSION)
	$(TAR) cf - man1 | (cd http-tiny-$(VERSION) ; $(TAR) xvf - )
	$(TAR) cf - man3 | (cd http-tiny-$(VERSION) ; $(TAR) xvf - )
	$(TAR) cvfz http-tiny-$(VERSION).tar.gz http-tiny-$(VERSION)

distrib: tar
	$(CP) http-tiny-$(VERSION).tar.gz /poubelle/ftp/www/
	$(CP) http-tiny-$(VERSION).tar.gz /users/dl/public_html/


# DO NOT DELETE THIS LINE -- make depend depends on it.


