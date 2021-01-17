.PHONY: all install

VERSION = v2

PREFIX ?= /usr/local/lv2

all: svf-$(VERSION).so manifest.ttl svf.ttl

svf.cc: svf.cc.in
	cat svf.cc.in | sed -e 's/VERSION/$(VERSION)/g' > svf.cc

svf.ttl: svf.ttl.in
	cat svf.ttl.in | sed -e 's/VERSION/$(VERSION)/g' > svf.ttl

manifest.ttl: manifest.ttl.in
	cat manifest.ttl.in | sed -e 's/VERSION/$(VERSION)/g' > manifest.ttl

svf-$(VERSION).so: common.cc svf.cc
	g++ -O3 -ffast-math -Wall -Wextra -o svf-$(VERSION).so -shared svf.cc

install:
	install -d $(PREFIX)/svf-$(VERSION)
	cp -f manifest.ttl svf.ttl svf-$(VERSION).so $(PREFIX)/svf-$(VERSION)
