.PHONY: all

all: svf.so

svf.so: common.cc svf.cc
	g++ -O3 -ffast-math -Wall  -o svf.so -shared svf.cc
