.PHONY: all install

VERSION = v2

PREFIX ?= /usr/local/lv2

all: svf.so manifest.ttl svf.ttl

svf.ttl: svf.ttl.in
	cat svf.ttl.in | sed -e 's/VERSION/$(VERSION)/g' > svf.ttl

manifest.ttl: manifest.ttl.in
	cat manifest.ttl.in | sed -e 's/VERSION/$(VERSION)/g' > manifest.ttl

svf.so: common.cc svf.cc
	g++ -O3 -ffast-math -Wall -Wextra -o svf-$(VERSION).so -shared svf.cc

install:
	install -d $(PREFIX)/svf-$(VERSION)
	cp -f manifest.ttl svf.ttl svf.so $(PREFIX)/svf-$(VERSION)
