#!/usr/bin/env bash
echo "Cloning dependencies"
git clone --depth=1 https://github.com/sohamxda7/llvm-stable  clang
git clone https://github.com/sohamxda7/llvm-stable -b gcc64 --depth=1 gcc
git clone https://github.com/sohamxda7/llvm-stable -b gcc32  --depth=1 gcc32
git clone --depth=1 https://github.com/sohamxda7/AnyKernel3 AnyKernel
echo "Done"
echo "KernelSU"
curl -LSs "https://raw.githubusercontent.com/ReSukiSU/ReSukiSU/main/kernel/setup.sh" | bash
echo "Curl Done"
DATE=$(TZ=Asia/Kolkata date +"%Y%m%d-%T")
START=$(date +"%s")
TANGGAL=$(date +"%F%S")
KERNEL_DIR=$(pwd)
PATH="${KERNEL_DIR}/clang/bin:${KERNEL_DIR}/gcc/bin:${KERNEL_DIR}/gcc32/bin:${PATH}"
export ARCH=arm64
export KBUILD_BUILD_USER=Zone-D543

# Compile plox
function compile() {
    make O=out ARCH=arm64 lavender-perf_defconfig
    make -j$(nproc --all) O=out \
				ARCH=arm64 \
			CC=clang \
                    	CLANG_TRIPLE=aarch64-linux-gnu- \
                    	CROSS_COMPILE=aarch64-linux-android- \
                    	CROSS_COMPILE_ARM32=arm-linux-androideabi-  2>&1 | tee log.txt

    cp out/arch/arm64/boot/Image.gz-dtb AnyKernel
}
# Zipping
function zipping() {
	mkdir -p zone
	ZIPNAME="lavender.zip"
       cd AnyKernel
        zip -r9 "../$ZIPNAME" * 
        cd ..
        #Pindah Zip
        mv "$ZIPNAME" zone/
}
compile
zipping
END=$(date +"%s")
DIFF=$(($END - $START))
