#IBM i Chroot
The IBM i Chroot project is delivered with license program `5733OPS` option 3 (PTF  `SI58604`) and is comprised of two primary components:

- **Package installation.**  Packages are obtained from perzl.org via the `pkg_setup.sh` script and are in `rpm` format.  These packages can be installed either inside or outside of a Chroot environment
- **Chroot environment creation.** Chroot (Change Root) is a PASE command used to change the relative root of a IBM i shell job.  Read [this article](http://bit.ly/ibmsystemsmag-chroot) for more info on Chroot in PASE.

The original setup instructions are on [YiPs](http://yips.idevcloud.com/wiki/index.php/PASE/OpenSourceBeta) and will eventually be migrated here.

#Chroot Setup
chroot_setup.sh -- set up chroot (optional, you could skip to **Package Setup** below)
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

#Package Setup
The `pkg_setup.sh` script can be run inside or outside a chroot environment. Use `pkg_setup.sh -help` to learn more about the command and see example invocation.

```
$ pkg_setup.sh -help
./pkg_setup.sh [-w|-i|-a|-k] /path/pkg_*.lst
   -a - wget and install rpm list (default)
   -w - wget rpm list (no install)
   -i - install rpm list (no wget)
   -k - remove rpm list (destructive)
   fix - fix perzl libiconv
Example:
  ./pkg_setup.sh pkg_gcc-4.6.2.lst
```

##Package config files
A number of packages (`.lst` files) are already setup, though you can create your own (and even contribute them back to this repo via pull request!).

View the [repo](https://bitbucket.org/litmis/ibmichroot/src) to see an exhaustive list of `pkg_perzl_xxxx.lst` files.

- pkg_perzl_gcc-4.6.2.lst    -- gcc environment 4.6.2 widely used IBM i products (recommend)
- pkg_perzl_gcc-4.8.3.lst    -- newer gcc environment 4.8.3, may not work existing products
- pkg_perzl_perl-5.8.8.lst   -- better perl over 5799PTL toolkit
- pkg_perzl_python-2.6.8.lst -- most popular python for Linux (recommend)
- pkg_perzl_python-2.7.5.lst -- last great python 2, too bad not widely used (hint)
- pkg_perzl_utils.lst        -- zips, sed, tar, it's all in here
- pkg_setup.sh

##Package UnInstall
**DANGER**  Be very careful when uninstalling things because one package might be a dependency of another.  For example, let's say you installed Git and GCC.  Then at a later date you determined GCC wasn't needed.  If you uninstalled all the GCC dependencies listed in `pkg_perzl_gcc-4.8.3.lst`, including bash, then you'd be deleting a Git dependency (bash).

Armed with the above knowledge/warning, to uninstall a single package you can run the following command.

```
rpm --nodeps -e git
```

**Side note:** This is yet another reason to create chroot environments instead of installing packages globally, because if you hose something in a chroot environment you can simply recreate it.  If you hose something in base PASE, well, good luck, and you've been warned.

#Other Files
- rpm.rte                     -- rpm installer (set up during pkg_setup.sh)
- wget-1.9.1-1.aix5.1.ppc.rpm -- slim version wget for perzl wegt rpms 

#License
MIT.  View [`LICENSE`](https://bitbucket.org/litmis/ibmichroot/src) file.