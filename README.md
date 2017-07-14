#ibmichroot project
Welcome to IBM i Chroot project.
The knowledge to set-up successful PASE chroots is extensive.
IBM i Chroot scripts allow easy set-up of PASE chroot projects.

IBM i Chroot scripts work with most AIX RPMs. However, 
IBM LPP OPS project is replacing many of Perzl and AIX toolbox RPMs.
Perzl and OPS RPMs do not always work together.
To work around mixed RPM issues use PASE PATH, LIBPATH env vars.
Eventually scripts are planned to be replaced with IBM i YUM RPM installer (or similar).

Project download directory structure:
```
main
|->chroot ... chroot_setup.sh chroot scripts and lists (*SECOFR)
|->pkg ... pkg_setup.sh download/install aix rpms (chroot)
```
View the [repo](https://bitbucket.org/litmis/ibmichroot/src) to see `README.md` files for each topic.

