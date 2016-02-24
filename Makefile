#
# Assume standlone toolchain
#
#CC  = arm-linux-gnueabihf-gcc
#CXX = arm-linux-gnueabihf-g++
#AR  = arm-linux-gnueabihf-ar

DIR=$(shell pwd)

INCLUDES = \
	-I$(DIR)/c_environment \
	-I$(DIR)/c_environment/hardware \
	-I$(DIR)/c_environment/hardware/arduino \
	-I$(DIR)/c_environment/hardware/arduino/cores \
	-I$(DIR)/c_environment/hardware/arduino/cores/arduino \
	-I$(DIR)/c_environment/hardware/arduino/variants \
	-I$(DIR)/c_environment/hardware/arduino/variants/sunxi \
	-I$(DIR)/c_environment/libraries \
	-I$(DIR)/c_environment/libraries/SPI \
	-I$(DIR)/c_environment/libraries/Wire \
	-I$(DIR)/c_environment/libraries/PN532_SPI \
	-I$(DIR)/c_environment/libraries/SHT1x  

CFLAGS = -fPIC
#CFLAGS = $(INCLUDES)
#CFLAGS += -march=armv7-a -mfpu=neon
CFLAGS += -DARDUINO=100

SRCS = \
	c_environment/hardware/arduino/cores/arduino/main.cpp \
	c_environment/hardware/arduino/cores/arduino/platform.cpp \
	c_environment/hardware/arduino/cores/arduino/Print.cpp \
	c_environment/hardware/arduino/cores/arduino/Stream.cpp \
	c_environment/hardware/arduino/cores/arduino/Tone.cpp \
	c_environment/hardware/arduino/cores/arduino/WInterrupts.c \
	c_environment/hardware/arduino/cores/arduino/wiring.c \
	c_environment/hardware/arduino/cores/arduino/wiring_analog.c \
	c_environment/hardware/arduino/cores/arduino/wiring_digital.c \
	c_environment/hardware/arduino/cores/arduino/wiring_pulse.c \
	c_environment/hardware/arduino/cores/arduino/wiring_shift.c \
	c_environment/hardware/arduino/cores/arduino/WMath.cpp \
	c_environment/hardware/arduino/cores/arduino/WString.cpp \
	c_environment/hardware/arduino/cores/arduino/Serial.cpp \
	c_environment/libraries/Wire/Wire.cpp \
	c_environment/libraries/SPI/SPI.cpp \
	c_environment/libraries/LiquidCrystal/Dyrobot_MCP23008.cpp \
	c_environment/libraries/LiquidCrystal/LiquidCrystal.cpp \
	c_environment/libraries/PN532_SPI/PN532.cpp \
	c_environment/libraries/SHT1x/SHT1x.cpp 

#OBJS = $(SRCS:%.c=%.o)
OBJS = $(patsubst %.c,%.o,$(patsubst %.cpp,%.o,$(SRCS)))

%.o: %.cpp
	@rm -f $@ 
	$(CXX) $(CFLAGS) $(INCLUDES) -c $< -o $@ -Wno-deprecated-declarations

%.o: %.c
	@rm -f $@ 
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@ -Wno-deprecated-declarations

LIB_STATIC = c_environment/libarduino.a
LIB_SHARE = c_environment/libarduino.so
LIB = $(LIB_STATIC) $(LIB_SHARE)

all: $(LIB)
	make -C src/
	make -C c_environment/sample/

green-thumb: $(LIB)
	make -C src/

samples: %(LIB)
	make -C c_environment/sample/


$(LIB): $(OBJS)
	$(AR) cq $(LIB_STATIC) $(OBJS)
	$(CXX) -shared -Wl,-soname,$(LIB_SHARE) -o $(LIB_SHARE) $(OBJS)

clean:
	rm -f $(LIB_STATIC) $(LIB_SHARE) $(OBJS)


