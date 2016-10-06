# cmake tutorial
Using cmake on IBM i.

# create profile
```
> CRTUSRPRF USRPRF(GCC483) PASSWORD() USRCLS(*SECOFR) TEXT('my happy gcc place')
> chgusrprf usrprf(gcc483) locale(*none) homedir('/QOpenSys/gcc483/./home/gcc483')
```


# chroot set-up (admin)
```
$ mkdir /QOpensys/gcc483/home/gcc483
$ cd /QOpenSys/QIBM/ProdData/OPS/GCC
-- or (new version) --
$ cd /QOpenSys/QIBM/ProdData/OPS/GCC/chroot
$ ./chroot_setup.sh chroot_minimal.lst /QOpenSys/gcc483
$ ./chroot_setup.sh chroot_OPS_SC1.lst /QOpenSys/gcc483
$ ./chroot_setup.sh chroot_nls.lst /QOpenSys/gcc483
$ ./chroot_setup.sh chroot_includes.lst /QOpenSys/gcc483
$ ./chroot_chown.sh gcc483
```

# gcc and cmake
```
ssh -X gcc483@myibmi
$ ksh
$ export PATH=.:/opt/freeware/bin:/QOpenSys/usr/bin
$ cd /QOpenSys/QIBM/ProdData/OPS/GCC
-- or (new version) --
$ cd /QOpenSys/QIBM/ProdData/OPS/GCC/chroot
$ ./pkg_setup.sh pkg_perzl_gcc-4.8.3.lst
$ ./pkg_setup.sh pkg_perzl_cmake-2.8.12.lst
$ bash
$ gcc --version
gcc (GCC) 4.8.3
$ g++ --version
g++ (GCC) 4.8.3
$ cmake --version
cmake version 2.8.12.2
```

# add cmake os400
```
$ cd /opt/freeware/share/cmake/Modules/Platform/  
$ cp AIX-GNU-ASM.cmake OS400-GNU-ASM.cmake
$ cp AIX-GNU-C.cmake OS400-GNU-C.cmake    
$ cp AIX-GNU-Fortran.cmake OS400-GNU-Fortran.cmake
$ cp AIX-GNU.cmake OS400-GNU.cmake
$ cp AIX.cmake OS400.cmake
```

# tutorial
```
$ export PATH=.:/opt/freeware/bin:/QOpenSys/usr/bin
$ export LIBPATH=/opt/freeware/lib:/QOpenSys/usr/lib
$ cd cmake_bin
$ mkdir build-dir
$ cd build-dir
$ cmake ..
-- The C compiler identification is GNU 4.8.3
-- The CXX compiler identification is GNU 4.8.3
-- Check for working C compiler: /opt/freeware/bin/gcc
-- Check for working C compiler: /opt/freeware/bin/gcc -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Check for working CXX compiler: /opt/freeware/bin/c++
-- Check for working CXX compiler: /opt/freeware/bin/c++ -- works
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Configuring done
-- Generating done
-- Build files have been written to: /home/gcc483/cmake_bin/build-dir
$ make
Scanning dependencies of target Tutorial
[100%] Building CXX object CMakeFiles/Tutorial.dir/tutorial.cc.o
Linking CXX executable Tutorial
[100%] Built target Tutorial
$ Tutorial 
Tutorial Version 1.0
Usage: Tutorial number
$ Tutorial 42
The square root of 42 is 6.48074
$
```

