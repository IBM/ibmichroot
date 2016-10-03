#ibmichroot project
The new IBM i Chroot project is factored to include a yum option (*). 

Project download directory structure:
```
main
|->chroot ... chroot_setup.sh chroot scripts and lists (original)
|->pkg ... pkg_setup.sh download/install aix rpms (original)
|->yum ... new rpm + yum + createrepo (experimental replacement for pkg_setup.sh)
```
View the [repo](https://bitbucket.org/litmis/ibmichroot/src) to see `README.md` files for each topic.

(*) The new yum version is NOT available as IBM i PTF.

