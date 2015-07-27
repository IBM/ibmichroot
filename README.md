#IBM i Chroot
This is a set of scripts and config files that facilitate create chroot environments on IBM i in the IFS.
#Instructions
You can find setup instructions on [YiPs](http://yips.idevcloud.com/wiki/index.php/PASE/OpenSourceBeta).

#Chroot Setup
chroot_setup.sh -- set up chroot (optional)
```
> .chroot_setup.sh -help
> .chroot_setup.sh chroot_minimal.lst /QOpenSys/root_path
```
##Chroot config files
- chroot_minimal.lst         -- minimal PASE chroot env (/bin, /dev, /usr, ...)
- chroot_bins.lst            -- copy most of PASE /usr/bin (gcc development)
- chroot_libs.lst            -- copy most of PASE /usr/lib (gcc development)
- chroot_includes.lst        -- copy most of PASE /usr/include (gcc development)
- chroot_OPS_GCC.lst         -- copy IBM OPS GCC into my chroot (not available yet)
- chroot_OPS_NODE.lst        -- copy IBM node into my chroot
- chroot_OPS_PYTHON.lst      -- copy IBM python into my chroot
- chroot_OPS_SC1.lst         -- copy IBM openssl into my chroot
- chroot_PowerRuby.lst       -- copy PowerRuby into my chroot (PASE)
- chroot_ZendServer5.lst     -- copy Zend Server 5 into my chroot (PASE)
- chroot_ZendServer6.lst     -- copy Zend Server 6 into my chroot (PASE)
- chroot_template.lst        -- exmple template for your own chroot copy

#Package Setup
pkg_setup.sh -- download and install perzl.org rpms (chroot optional)
```
> ./pkg_setup.sh -help
> ./pkg_setup.sh pkg_gcc-4.6.2.lst
```
##Package config files
- pkg_perzl_gcc-4.6.2.lst    -- gcc environment 4.6.2 widely used IBM i products (recommend)
- pkg_perzl_gcc-4.8.3.lst    -- newer gcc environment 4.8.3, may not work existing products
- pkg_perzl_perl-5.8.8.lst   -- better perl over 5799PTL toolkit
- pkg_perzl_python-2.6.8.lst -- most popular python for Linux (recommend)
- pkg_perzl_python-2.7.5.lst -- last great python 2, too bad not widely used (hint)
- pkg_perzl_utils.lst        -- zips, sed, tar, it's all in here
- pkg_setup.sh

#Other Files
- README.txt                  -- this readme
- rpm.rte                     -- rpm installer (set up during pkg_setup.sh)
- wget-1.9.1-1.aix5.1.ppc.rpm -- slim version wget for perzl wegt rpms 

#License
BSD
