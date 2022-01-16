obj-m += hid-sony.o

package_version := $(shell uname -r | sed 's/.x86_64//' | sed s/-/\ /g | awk -F " " '{print $$1}')
all:
	cd /tmp; apt-get source linux
	cp -f /tmp/linux-${package_version}/drivers/hid/hid-ids.h .
	cp -f /tmp/linux-${package_version}/drivers/hid/hid-sony.c .
	patch -u -b hid-sony.c -i cloneDualshock.patch
	rm hid-sony.c.orig
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
	rm hid-ids.h
	rm hid-sony.c

install:
	cp hid-sony.ko /lib/modules/$(shell uname -r)/kernel/drivers/hid/
