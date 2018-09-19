#!/bin/bash
mkdir -p ${HOME}/mediainfo
echo "###################################"
echo "  Download Cross Compiler"
wget -O /tmp/arm-2009q1-203-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2 https://sourcery.mentor.com/GNUToolchain/package4571/public/arm-none-linux-gnueabi/arm-2009q1-203-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2
tar jxf /tmp/arm-2009q1-203-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2 -C ${HOME}/mediainfo && rm /tmp/arm-2009q1-203-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2
export TARGETMACH=arm-none-linux-gnueabi
export CC=${HOME}/mediainfo/arm-2009q1/bin/arm-none-linux-gnueabi-gcc
export CXX=${HOME}/mediainfo/arm-2009q1/bin/arm-none-linux-gnueabi-g++
export LD=${HOME}/mediainfo/arm-2009q1/bin/arm-none-linux-gnueabi-ld
export CFLAGS=-I${HOME}/mediainfo/arm-2009q1/arm-none-linux-gnueabi/include
export LDFLAGS="-static -L${HOME}/mediainfo/arm-2009q1/arm-none-linux-gnueabi/lib"
export PATH=$PATH:${HOME}/mediainfo/arm-2009q1/bin:${HOME}/mediainfo/arm-2009q1/arm-none-linux-gnueabi/bin
echo "###################################"
echo "  Download MediaInfo Source"
wget -O /tmp/MediaInfo_CLI_0.7.82_GNU_FromSource.tar.xz https://old.mediaarea.net/download/binary/mediainfo/0.7.82/MediaInfo_CLI_0.7.82_GNU_FromSource.tar.xz
tar xvJf /tmp/MediaInfo_CLI_0.7.82_GNU_FromSource.tar.xz -C ${HOME}/mediainfo && rm /tmp/MediaInfo_CLI_0.7.82_GNU_FromSource.tar.xz
echo "###################################"
echo "  Compile zlib"
cd ${HOME}/mediainfo/MediaInfo_CLI_GNU_FromSource/Shared/Project/zlib
bash Compile.sh --prefix=${HOME}/mediainfo/arm-2009q1/arm-none-linux-gnueabi --static
echo "###################################"
echo "  Compile ZenLib"
cd ${HOME}/mediainfo/MediaInfo_CLI_GNU_FromSource/ZenLib/Project/GNU/Library
./autogen.sh
./configure --enable-static --host=arm-none-linux-gnueabi --prefix=${HOME}/mediainfo/arm-2009q1/arm-none-linux-gnueabi
make && make install
echo "###################################"
echo "  Compile MediaInfoLib"
cd ${HOME}/mediainfo/MediaInfo_CLI_GNU_FromSource/MediaInfoLib/Project/GNU/Library
./autogen.sh
./configure --enable-static --host=arm-none-linux-gnueabi --prefix=${HOME}/mediainfo/arm-2009q1/arm-none-linux-gnueabi
make -j16 && make install
echo "###################################"
echo "  Compile MediaInfo CLI"
cd ${HOME}/mediainfo/MediaInfo_CLI_GNU_FromSource/MediaInfo/Project/GNU/CLI
export CXXFLAGS='-static -Wl,--whole-archive -lpthread -Wl,--no-whole-archive -lc'
./autogen.sh
./configure --enable-static --host=arm-none-linux-gnueabi --prefix=${HOME}/mediainfo/arm-2009q1/arm-none-linux-gnueabi
make
rm mediainfo
${HOME}/mediainfo/arm-2009q1/bin/arm-none-linux-gnueabi-g++ \
    -static -Wl,--whole-archive -lpthread -Wl,--no-whole-archive -lc \
    -O2 -DUNICODE -DUNICODE -o mediainfo CLI_Main.o CommandLine_Parser.o Help.o Core.o \
    -L${HOME}/mediainfo/arm-2009q1/arm-none-linux-gnueabi/lib\
    -L${HOME}/mediainfo/MediaInfo_CLI_GNU_FromSource/MediaInfoLib/Project/GNU/Library \
    ${HOME}/mediainfo/MediaInfo_CLI_GNU_FromSource/MediaInfoLib/Project/GNU/Library/.libs/libmediainfo.a \
    -L../../../../Shared/Source/zlib \
    -L${HOME}/mediainfo/MediaInfo_CLI_GNU_FromSource/ZenLib/Project/GNU/Library \
    -lz ${HOME}/mediainfo/MediaInfo_CLI_GNU_FromSource/ZenLib/Project/GNU/Library/.libs/libzen.a -lpthread -lstdc++
echo "###################################"
echo "Get MediaInfo in Current Path"
echo "File: $(pwd)/mediainfo"
md5sum mediainfo
file mediainfo
echo "###################################"
