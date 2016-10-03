### make
### make TGT64=64
### gcc options
### -v            - verbose compile
### -Wl,-bnoquiet - verbose linker
### -shared       - shared object
### -maix64       - 64bit
### -isystem      - compile PASE system headers
### -nostdlib     - remove libgcc_s.a and crtcxa_s.o
CC          = gcc
# CCFLAGS32   = -v verbose
CCFLAGS32   = -g -Wno-int-to-pointer-cast -Wno-pointer-to-int-cast
CCFLAGS64   = $(CCFLAGS32) -maix64
AR          = ar
AROPT       = -X32_64
INCLUDEPATH = -isystem /QOpenSys/usr/include -I.

###  shared lib
LIBOBJS      = bigfake.o
LIBEXPS      = -Wl,-bE:libodm.exp
SHRLIB32     = libodm.a
SHROBJ32     = shr.o
LIBDEPS32    = -L/QOpenSys/usr/lib -nostdlib -lpthreads -lc -liconv -ldl -lpthread -shared -Wl,-brtl -Wl,-bnoquiet
SHRLIB64     = libodm_64.a
SHROBJ64     = shr_64.o
LIBDEPS64    = $(LIBDEPS32) -maix64

### make TGT64=64
ifdef TGT64
CCFLAGS      = $(CCFLAGS64)
SHRLIB       = $(SHRLIB32)
SHROBJ       = $(SHROBJ64)
LIBDEPS      = $(LIBDEPS64)
### make
else
CCFLAGS      = $(CCFLAGS32)
SHRLIB       = $(SHRLIB32)
SHROBJ       = $(SHROBJ32)
LIBDEPS      = $(LIBDEPS32)
endif

### tells make all things to do (ordered)
all: removeo $(SHRLIB) removeo 

### generic rules
### (note: .c.o compiles all c parts in OBJS list)
.SUFFIXES: .o .c
.c.o:
	$(CC) $(CCFLAGS) $(INCLUDEPATH) -c $<

### -- Build the shared lib(s).
$(SHROBJ): $(LIBOBJS)
	$(CC) $(LIBOBJS) $(LIBEXPS) $(LIBDEPS) -o$(SHROBJ) 
$(SHRLIB): $(SHROBJ)
	$(AR) $(AROPT) ruv $(SHRLIB) $(SHROBJ)

clean:
	rm -f $(SHRLIB)
removeo:
	rm -f *.o

