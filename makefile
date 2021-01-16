.PHONY: all

all: svf-v1.so

svf-v1.so: common.cc svf.cc
	g++ -O3 -ffast-math -Wall  -o svf-v1.so -shared svf.cc
