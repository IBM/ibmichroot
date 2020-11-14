# Table of Contents

- [IBM i Chroot (version 2)](#ibm-i-chroot-version-2)
- [Install](#install)
- [Usage](#usage)
  - [Example](#chroot-setup-example)
  - [Config files](#config-files)
- [Install Software into Chroot](#install-software-into-chroot)
- [Remove Chroot](#install-software-into-chroot)
- [Advanced](#advanced)
- [Chroot Manager](#chroot-manager)
- [Resources](#resources)

## IBM i Chroot (version 2)

Chroot (Change Root) is a PASE command used to change the relative root of a IBM
i shell job.

The purpose of this project is to automate and simplifiy chroot environment creation.

To learn more about chroots in PASE view these [resources](#resources)

## Install

This project is available via RPM

`yum install ibmichroot`

For more information about yum read the [docs](https://bitbucket.org/ibmi/opensource/src/master/docs/yum/)

## Usage

Before running `chroot_setup` ensure you have proper permissions first!

- Minimum of `*IOSYSCFG` to create device nodes

- `*ALLOBJ` needed to run `yum`.

`Usage: chroot_setup [OPTIONS] CHROOT DIRECTORY [CHROOT TYPE]`

```lang-none
[Options] - optional additonal arguments listed below

-v: More verbose output.
-y: Auto respond yes to the prompts.
-g: Dynamic global variables.  
-i: yum install into chroot.
```

```lang-none
CHROOT DIRECTORY - is the Directory where the chroot will be created.

This parameter is required and chroot directory path must begin with /QOpenSys/
```

```lang-none
[CHROOT TYPE] - is specified by the .lst config files located within /chroot
within this project.

This parameter is optional, when undefined a chroot with minimal with includes
will be created.

Full file names are not required when specifying the [CHROOT TYPE]

- chroot_minimal.lst OR minimal will work

```

## Example

Creating a minimal chroot:

```bash
chroot_setup /QOpenSys/root_path
```

## Config files

The `.lst` files that start with `chroot...` are meant for creating chroot
environments based on specific needs.

For example, you can create a bare minimum chroot environment with
`chroot_minimal.lst`.

Or you could add multiple `*.lst` files together to create an environment with
many features.

Visit [config](https://github.com/IBM/ibmichroot/blob/master/config) to see an
exhaustive list of `chroot_xxxx.lst` files.

## Install Software into Chroot

After Creating a chroot with minimal and includes configuration you can use`yum`
to install into your chroot.

It's recommended to install bash within your chroot as well. You can do so with:

```bash
yum --installroot=/QOpenSys/root_path install bash
```

Packages such as Node.js can be installed by invoking:

```bash
yum --installroot=/QOpenSys/root_path install nodejs8
```

As a convinence you can use  `-i` option:

```bash
chroot_setup -i bash /QOpenSys/root_path
```

***Note***

If you plan to access DB2 from `python, node.js, etc` from within the chroot

iconv conversion tables provided from `nls.lst` is required.

```bash
chroot_setup /QOpenSys/root_path nls
```

## Advanced

You can pass in any named variable to `chroot_setup.sh` so you can have
replacement values in xxxxx.lst files.

For example:

In your custom .lst file you could have this:

```lang-none
:system
CHGAUT OBJ('mydir') USER(myuser) DTAAUT(*RWX) OBJAUT(*ALL) SUBTREE(*ALL)
```

```bash
chroot_setup -g myuser=AARON -g mydir=/QOpenSys/root_path /QOpenSys/root_path /path/to/yourCustom.lst
```

Any instance of `myuser` would be interpreted as `AARON` when the script is run.
Same for `mydir` and `/QOpenSys/root_path`.

## Chroot Manager

TODO: Document `chroot_mgr.py`

## Resources

- [A (root) Change For The Better](http://bit.ly/ibmsystemsmag-chroot)

- [A (root) Change for the Better (part II)](http://bit.ly/ism-chroot2)

- [IFS Containers (presentation)](https://krengel.tech/litmis-ifs-containers)
