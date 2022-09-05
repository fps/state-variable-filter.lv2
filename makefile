.PHONY: all install clean

VERSION = v2

PREFIX ?= /usr/local
INSTALLDIR ?= $(PREFIX)/lv2

all: svf-$(VERSION).so manifest.ttl svf.ttl

svf.cc: svf.cc.in
	cat svf.cc.in | sed -e 's/VERSION/$(VERSION)/g' > svf.cc

svf.ttl: svf.ttl.in
	cat svf.ttl.in | sed -e 's/VERSION/$(VERSION)/g' > svf.ttl

manifest.ttl: manifest.ttl.in
	cat manifest.ttl.in | sed -e 's/VERSION/$(VERSION)/g' > manifest.ttl

svf-$(VERSION).so: common.cc svf.cc submodules
	g++ -O3 -ffast-math -Wall -Wextra -o svf-$(VERSION).so -shared svf.cc

submodules:
	make -C state-variable-filter

install: all
	install -d $(INSTALLDIR)/svf-$(VERSION)
	cp -f manifest.ttl svf.ttl svf-$(VERSION).so $(INSTALLDIR)/svf-$(VERSION)

clean:
	rm -f manifest.ttl svf.ttl svf-$(VERSION).so svf.cc
