#IBM i Package Install (original)
**Package installation.**  Packages are obtained from perzl.org via the `pkg_setup.sh` script and are in `rpm` format.  These packages can be installed either inside or outside of a Chroot environment

#Update
We are attempting to replace this part of ibmichroot project with rpm/yum.
You may continue to use these scripts, but may not be compatible with newer yum.

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
- pkg_perzl_python-2.7.5.lst -- Please note [IBM ships both Python 2.x and 3.x as part of 5733OPS](http://bit.ly/ibmi-python)
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

