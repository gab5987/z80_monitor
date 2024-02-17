ROM := AT28C16@DIP24

AS = vasmz80_std
ASFLAGS = -Fvobj

LD = vlink
LDFLAGS = -b rawbin1 -T link.ld

SRCDIR = main
BUILDDIR = build

TARGET = bootable.bin

SRC := $(wildcard main/*.s)
OBJ := $(addprefix build/,$(notdir $(SRC:.s=.o)))

all: $(TARGET)

upload: $(TARGET)
	minipro -p $(ROM) -w $(TARGET)

$(TARGET): $(OBJ)
	$(LD) $(LDFLAGS) -o $(TARGET) $(OBJ)

$(BUILDDIR)/%.o: $(SRCDIR)/%.s | $(BUILDDIR)
	$(AS) $(ASFLAGS) -o $@ $<

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

clean:
	rm -rf $(BUILDDIR)

.PHONY: all clean

