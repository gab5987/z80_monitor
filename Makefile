ROM := AT28C16@DIP24

AS = vasmz80_std
ASFLAGS = -Fvobj

LD = vlink
LDFLAGS = -s -b rawbin1 -C z2 -T link.ld

SRCDIR = main
BUILDDIR = build

TARGET = binary.bin
BOOTABLE = bootable.bin

BIOS_ROM_SIZE = 0x0800

SRC := $(wildcard main/*.s)
OBJ := $(addprefix build/,$(notdir $(SRC:.s=.o)))

all: $(TARGET)

upload: $(TARGET)
	dd if=$(TARGET) of=$(BOOTABLE) bs=1 skip=0 count=$(BIOS_ROM_SIZE)
	minipro -p $(ROM) -w $(BOOTABLE)

$(TARGET): $(OBJ)
	$(LD) $(LDFLAGS) -o $(TARGET) $(OBJ)

$(BUILDDIR)/%.o: $(SRCDIR)/%.s | $(BUILDDIR)
	$(AS) $(ASFLAGS) -o $@ $<

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

clean:
	rm -rf $(BUILDDIR)

.PHONY: all clean

