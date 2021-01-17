.PHONY: all install

VERSION = v2

PREFIX ?= /usr/local/lv2

all: svf-$(VERSION).so manifest.ttl svf-$(VERSION).ttl

svf.cc: svf.cc.in
	cat svf.cc.in | sed -e 's/VERSION/$(VERSION)/g' > svf.cc

svf-$(VERSION).ttl: svf.ttl.in
	cat svf.ttl.in | sed -e 's/VERSION/$(VERSION)/g' > svf-$(VERSION).ttl

manifest.ttl: manifest.ttl.in
	cat manifest.ttl.in | sed -e 's/VERSION/$(VERSION)/g' > manifest.ttl

svf-$(VERSION).so: common.cc svf.cc
	g++ -O3 -ffast-math -Wall  -o svf-$(VERSION).so -shared svf.cc

install:
	install -d $(PREFIX)/svf-$(VERSION)
	cp -f manifest.ttl svf-$(VERSION).ttl svf-$(VERSION).so $(PREFIX)/svf-$(VERSION)
