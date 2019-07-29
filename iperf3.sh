workspace='/tmp/iperf3'
cross_compile_tool='arm-2014.05-29-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2'
cross_tool_folder='arm-2014.05'
echo "[INFO] Workspace: ${workspace}"
mkdir -p ${workspace}
echo "[STEP] Download iperf3.7 src"
wget -O "${workspace}/iperf3.7.tar.gz" https://github.com/esnet/iperf/archive/3.7.tar.gz
tar -xzf "${workspace}/iperf3.7.tar.gz" -C "${workspace}" && rm "${workspace}/iperf3.7.tar.gz"

echo "[STEP] Download cross compile arm-none-linux-gnueabi"
wget -O "${workspace}/${cross_compile_tool}" "https://sourcery.mentor.com/GNUToolchain/package12813/public/arm-none-linux-gnueabi/${cross_compile_tool}"
tar jxf "${workspace}/${cross_compile_tool}" -C "${workspace}" && rm "${workspace}/${cross_compile_tool}"

echo "[STEP] Configure"
export TARGETMACH=arm-none-linux-gnueabi
export CC="${workspace}/${cross_tool_folder}/bin/arm-none-linux-gnueabi-gcc"
export CXX="${workspace}/${cross_tool_folder}/bin/arm-none-linux-gnueabi-g++"
export LD="${workspace}/${cross_tool_folder}/bin/arm-none-linux-gnueabi-ld"
export CFLAGS="-I${workspace}/${cross_tool_folder}/arm-none-linux-gnueabi/include"
export LDFLAGS="-static -L${workspace}/${cross_tool_folder}/arm-none-linux-gnueabi/lib"
export PATH="${workspace}/${cross_tool_folder}/bin":"${workspace}/${cross_tool_folder}/arm-none-linux-gnueabi/bin":$PATH
cd ./iperf-3.7
./configure --host=arm-linux-gnueabi --enable-static --disable-shared --without-openssl

echo "[STEP] Compile"
make

echo "[INFO] Done"
ls "${workspace}/src/iperf3"
file "${workspace}/src/iperf3"
