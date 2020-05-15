#~!/bin/sh
#export environment parameters

. ./env.sh

if [ ! -d $TC_PATH ]
then
	echo "Create toolchain directory"
	mkdir $TC_PATH
fi 	

cd $TC_PATH

if [ ! -d crosstool-NG ]
then
	git clone https://github.com/espressif/crosstool-NG.git
	cd crosstool-NG
	git checkout $TC_VER
	git submodule update --init
 	./bootstrap && ./configure --enable-local && make
	if [ $? -eq 0]; then
		echo "Clone or make has error"
		exit 1
	else
		./ct-ng xtensa-esp32-elf
		./ct-ng build
		chmod -R u+w builds/xtensa-esp32-elf
	fi
fi

export PATH=$TC_PATH/crosstool-NG/builds/xtensa-esp32-elf/bin:$PATH

cd $IDF_PATH && git submodule update --init
cd ~/work/zim/luartos/Lua-RTOS-ESP32 && git pull origin master
cd ~/work/zim/luartos/Lua-RTOS-ESP32 && make SDKCONFIG_DEFAULTS=GENERIC defconfig
