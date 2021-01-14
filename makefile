.PHONY: all

all: svf.so

svf.so: common.cc svf.cc
	g++ -Wall  -o svf.so -shared svf.cc
