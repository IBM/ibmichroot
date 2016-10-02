#IBM i Chroot
**Chroot environment creation.** Chroot (Change Root) is a PASE command used to change the relative root of a IBM i shell job.  Read [this article](http://bit.ly/ibmsystemsmag-chroot) for more info on Chroot in PASE.

#Chroot Setup
chroot_setup.sh -- set up chroot
```
$ chroot_setup.sh -help
$ chroot_setup.sh chroot_minimal.lst /QOpenSys/root_path [dynamic global variables]

```
##Chroot config files
The `.lst` files that start with `chroot...` are meant for creating chroot environments based on specific needs.  For example, you can create a bare minimum chroot environment with `chroot_minimal.lst`.  Or you could create a Node.js environment with `chroot_OPS_NODE.lst`.  Or you could add multiple `chroot...lst` files together to create an environment with many features.

View the [repo](https://bitbucket.org/litmis/ibmichroot/src) to see an exhaustive list of `chroot_xxxx.lst` files.


- chroot_minimal.lst         -- minimal PASE chroot env (/bin, /dev, /usr, ...)
- chroot_bins.lst            -- copy most of PASE /usr/bin (gcc development)
- chroot_includes.lst        -- copy most of PASE /usr/lib (gcc development)
- chroot_libs.lst            -- copy most of PASE /usr/lib (gcc development)
- chroot_OPS_GCC.lst         -- copy IBM OPS GCC into my chroot (not available yet)
- chroot_OPS_NODE.lst        -- copy IBM node into my chroot
- chroot_OPS_PYTHON.lst      -- copy IBM python into my chroot (not available yet)
- chroot_OPS_SC1.lst         -- copy IBM openssl into my chroot
- chroot_PowerRuby.lst       -- copy PowerRuby into my chroot (PASE)
- chroot_ZendServer5.lst     -- copy Zend Server 5 into my chroot (PASE)
- chroot_ZendServer6.lst     -- copy Zend Server 6 into my chroot (PASE)
- chroot_template.lst        -- exmple template for your own chroot copy

**Articles about chroot: **
[A (root) Change For The Better](http://bit.ly/ibmsystemsmag-chroot)
[A (root) Change for the Better (part II)](http://bit.ly/ism-chroot2)

##Dynamic Global Variables
You can pass in any named variable to `chroot_setup.sh` so you can have replacement values in `xxxxx.lst` files.  For example:

```
$ chroot_setup.sh chroot_minimal.lst /QOpenSys/root_path myuser=AARON
```
And then in your `.lst` file you could have this:
```
:system
CHGAUT OBJ('/home/myuser') USER(myuser) DTAAUT(*RWX) OBJAUT(*ALL) SUBTREE(*ALL)
```

