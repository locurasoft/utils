#!/bin/bash 

wget https://sourceforge.net/projects/luabinaries/files/5.1.4/Docs%20and%20Sources/lua5_1_4_Sources.zip/download -O lua5_1_4_Sources.zip
unzip lua5_1_4_Sources.zip
rm lua5_1_4_Sources.zip

wget http://bitop.luajit.org/download/LuaBitOp-1.0.2.zip -O LuaBitOp-1.0.2.zip
unzip LuaBitOp-1.0.2.zip
rm LuaBitOp-1.0.2.zip

cp LuaBitOp-1.0.2/bit.c lua5.1/src
mv lua5.1/src/luac.c lua5.1/src/luac.c.bak