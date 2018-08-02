# IBM i Chroot (version 2)
**Chroot environment creation.** Chroot (Change Root) is a PASE command used to change the relative root of a IBM i shell job.  Read [this article](http://bit.ly/ibmsystemsmag-chroot) for more info on Chroot in PASE.

## Installation
The highly-preferred way to install these scripts is by installing the RPM form via `yum`. For more information, see [docs](https://bitbucket.org/ibmi/opensource/src/master/docs/yum/)

After installation, creating a simple chroot (and then loading software into the chroot) can be done by simply running a couple commands. For instance, the following two commands create a chroot directory, then install bash inside the newly-created chroot
```
chroot_setup /QOpenSys/root_path
yum --installroot=/QOpenSys/root_path install bash
```

## Chroot Setup Script
chroot_setup.sh -- set up chroot

**Usage: chroot_setup [OPTIONS] [CHROOT DIRECTORY] [CHROOT TYPE]***  
[Options]  

-v: More verbose output.   
-y: Auto respond yes to the prompts.   
-g: Dynamic global variables.  

[CHROOT DIRECTORY] is the Directory where the chroot will be.

[CHROOT TYPE] is specified by the .lst config files located within /chroot within this project.  


#### Example  
``` 
$ chroot_setup /QOpenSys/root_path

$ chroot_setup /QOpenSys/root_path minimal includes

```
* NOTE: If [CHROOT DIRECTORY] is the only argument specified a chroot with minimal & includes will be created. The Script will prompt to confirm.

* NOTE: Full names are not required when specifying the [CHROOT TYPE] chroot_minimal.lst OR minimal will both work.

## Chroot config files
The `.lst` files that start with `chroot...` are meant for creating chroot environments based on specific needs.  For example, you can create a bare minimum chroot environment with `chroot_minimal.lst`. Or you could add multiple `chroot...lst` files together to create an environment with many features.

View the [repo](https://bitbucket.org/litmis/ibmichroot/src) to see an exhaustive list of `chroot_xxxx.lst` files.


- chroot_minimal.lst         -- minimal PASE chroot env (/bin, /dev, /usr, ...)
- chroot_bins.lst            -- copy most of PASE /usr/bin (gcc development)
- chroot_includes.lst        -- copy most of PASE /usr/lib (gcc development)
- chroot_libs.lst            -- copy most of PASE /usr/lib (gcc development)
- chroot_PowerRuby.lst       -- copy PowerRuby into my chroot (PASE)
- chroot_ZendServer5.lst     -- copy Zend Server 5 into my chroot (PASE)
- chroot_ZendServer6.lst     -- copy Zend Server 6 into my chroot (PASE)
- chroot_template.lst        -- example template for your own chroot copy

## Using Yum With Chroot
After Creating a chroot with minimal and includes configuration you can use Yum to install into your chroot.
Packages such as Node.js can be installed by invoking:

`yum --installroot=/QOpenSys/root_path install nodejs8`

It is recommended to install bash within your chroot as well. you can do so with: 

`yum --installroot=/QOpenSys/root_path install bash`

# Advanced

## Dynamic Global Variables
You can pass in any named variable to chroot_setup.sh so you can have replacement values in xxxxx.lst files. For example:

`$ chroot_setup -g myuser=AARON -g mydir=/QOpenSys/root_path /QOpenSys/root_path /path/to/yourCustom.lst`   

And then in your .lst file you could have this:

`:system`   
`CHGAUT OBJ('mydir') USER(myuser) DTAAUT(*RWX) OBJAUT(*ALL) SUBTREE(*ALL)`

Any instance of `myuser` would be interpreted as `AARON` when the script is run.  Same for `mydir` and `/QOpenSys/root_path`.

## Chroot Manager Python Script
TODO: Document chroot_mgr.py

## Articles
**Articles about chroot:**  
- [A (root) Change For The Better](http://bit.ly/ibmsystemsmag-chroot)  
- [A (root) Change for the Better (part II)](http://bit.ly/ism-chroot2) 
- [IFS Containers (presentation)](https://krengel.tech/litmis-ifs-containers) 