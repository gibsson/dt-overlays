# Inspired from CHIP-dt-overlays Makefile
GCC?=gcc
DTC_OPTIONS?=-@ -q
DTC_SRC=$(CURDIR)/dtc
DTC=$(DTC_SRC)/dtc

.DEFAULT_GOAL=all

V ?= 0
ifeq ($V, 0)
E = @
P = @echo
else
E =
P = @true
endif

$(DTC):
	$P '  MAKE	DTC'
	$E make -C $(DTC_SRC)

OBJECTS:= $(patsubst %.dtso,%.dtbo,$(wildcard overlays/*.dtso))

%.pre.dtso: %.dtso
	$P '  CC 	$@'
	$E $(GCC) -E -nostdinc -I$(CURDIR)/include -x assembler-with-cpp -undef -o $@ $^

%.dtbo: %.pre.dtso
	$P '  DTC	$@'
	$E $(DTC) $(DTC_OPTIONS) -I dts -O dtb -o $@ $^
	$E rm $^

all: $(DTC) $(OBJECTS)

clean:
	$P '  CLEAN		DTC'
	$E make -C $(DTC_SRC) clean
	$P '  RM		OBJS'
	$E rm -f $(OBJECTS)
