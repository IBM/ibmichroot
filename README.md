#ibmichroot project
The new IBM i Chroot project is factored to include a yum option (*). 

Project download directory structure:
```
main
|->chroot ... chroot scripts for chroot_setup.sh (original)
|->pkg ... poor mans pkg_setup.sh (original)
|->yum ... new rpm + yum + createrepo (replacement for pkg_setup.sh)
```
View the [repo](https://bitbucket.org/litmis/ibmichroot/src) to see `README.md` files for each topic.

(*) The new yum version is NOT available as IBM i PTF.

