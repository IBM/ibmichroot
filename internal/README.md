# Builders ibmichroot (Tony/Aaron).

*** These files are ibmichroot builders only. Do not copy to your IBM i machine ***


This is the source for os400_bundle_v1. The actual bundle used in installation is os400_bundle_v1.tar.
Adds, changes, supplements to aix toolbox rpm, yum, createrepo are found here.
*** No action is required if no changes are made. Yum tar files have all correct data for install. ***



*** =========================================== ***

*** os400_bundle_v1.tar ***

*** =========================================== ***
if you make changes to os400_bundle_v1 update master yum/os400_bundle_v1.tar.
```
$ cd internal
$ tar -cf os400_bundle_v1.tar os400_bundle_v1
$ cp os400_bundle_v1.tar ../yum/.
```

*** Information: Additional tar files are packaged directly from aix toolbox rpms. ***

yum rpms:
```
$ ls yum/yum_bundle_v1/aix_toolbox_rpms/       
curl-7.44.0-1.aix6.1.ppc.rpm                  libxml2-2.9.3-2.aix6.1.ppc.rpm                python-pycurl-7.19.3-1.aix6.1.ppc.rpm         xz-libs-5.2.2-1.aix6.1.ppc.rpm
db-4.8.24-3.aix6.1.ppc.rpm                    libxml2-python-2.9.3-2.aix6.1.ppc.rpm         python-tools-2.7.10-1.aix6.1.ppc.rpm          yum-3.4.3-3.aix6.1.noarch.rpm
gdbm-1.8.3-5.aix5.2.ppc.rpm                   pysqlite-1.1.7-1.aix6.1.ppc.rpm               python-urlgrabber-3.10.1-1.aix6.1.noarch.rpm  yum-metadata-parser-1.1.4-1.aix6.1.ppc.rpm
gettext-0.10.40-8.aix5.2.ppc.rpm              python-2.7.10-1.aix6.1.ppc.rpm                readline-6.1-2.aix6.1.ppc.rpm
glib2-2.14.6-2.aix5.2.ppc.rpm                 python-devel-2.7.10-1.aix6.1.ppc.rpm          sqlite-3.7.15.2-2.aix6.1.ppc.rpm
libgcc-4.8.5-1.aix7.2.ppc.rpm                 python-iniparse-0.4-1.aix6.1.noarch.rpm       xz-5.2.2-1.aix6.1.ppc.rpm
```

createrepo rpms:
```
$ ls yum/createrepo_bundle_v1/aix_toolbox_rpms/
createrepo-0.10.3-2.aix6.1.noarch.rpm              python-jsonpatch-1.8-1.aix6.1.noarch.rpm           python-setuptools-devel-0.9.8-2.aix6.1.noarch.rpm
deltarpm-3.6-1.aix6.1.ppc.rpm                      python-jsonpointer-1.0-1.aix6.1.noarch.rpm         python-six-1.3.0-1.aix6.1.noarch.rpm
python-argparse-1.2.1-1.aix6.1.noarch.rpm          python-oauth-1.0.1-1.aix6.1.noarch.rpm             rpm-devel-4.9.1.3-3.aix6.1.ppc.rpm
python-boto-2.34.0-1.aix6.1.noarch.rpm             python-prettytable-0.7.2-1.aix6.1.noarch.rpm       rpm-devel-python-4.9.1.3-3.aix6.1.ppc.rpm
python-configobj-5.0.5-1.aix6.1.noarch.rpm         python-requests-2.4.3-1.aix6.1.noarch.rpm
python-deltarpm-3.6-1.aix6.1.ppc.rpm               python-setuptools-0.9.8-2.aix6.1.noarch.rpm

```

rpm restore:
```
$ ls yum/rpm_bundle_v1                
rpm.rte.4.9.1.3                           zz-os400-provides-1.0-1.os400.noarch.rpm

Note: 
- zz-os400-provides-1.0-1.os400.noarch.rpm is virtual rpm lists/provides function from PASE.
- zz-os400-provides-1.0-1.os400.noarch.rpm is NOT complete as of this time.

Until zz-os400-provides-1.0-1.os400.noarch.rpm completed AIX RPMs not installed by yum will report things like ...
$ yum check
bash-4.3-16.ppc has missing requires of libdl.a(shr.o)
:

see file:
setup_rpm.sh
```

*** until openssl ptf ***
IBM i libcrypto.so.1.0.1 and libssl.so.1.0.1 are provide
libssl.a(libssl.so) and libcrypto.a(libcrypto.so) to 
match aix tool box shared library usage patterns.
After future PTF any update will be ignored by
yum/setup_ibm_ssl.sh.
```
$ ls internal/os400_bundle_v1/lib-patch/
libcfg.a  libcrypto.so.1.0.1  libodm.a  libssl.so.1.0.1

see file:
$ setup_ibm_ssl.sh 
```

AIX rpm/yum requires libodm.a, libcfg.a. 
These files are not used for functional purpose, so stubs are provided.
```
$ cd internal/fakeodm
$ gmake
$ cp libodm.a ../os400_bundle_v1/lib-patch/.

$ cd internal/fakecfg
$ gmake
$ cp libcfg.a ../os400_bundle_v1/lib-patch/.


see file:
setup_rpm.sh
```

rpm utility uses rpmrc configuration file.
A special version is created during install
to account for unusual IBM i uname -m archtecture.
```
$ ls internal/os400_bundle_v1/rpm-conf/
rpmrc-aix  rpmrc-os400

see file:
$ setup_rpmrc.sh
```

Remove yum restriction of ONLY qsecofr usage (root uid=0), 
patchs yumcommands.py and yumupd.py are required.
```
$ ls internal/os400_bundle_v1/yum-patch/
yumcommands.py  yumupd.py

see file:
setup_yum.sh
```

Special rpm conversion utilities are provided
to help create os400 rpms. The utilities are installed 
with setup_yum.sh. More utilities may be added
depending on various discussions, etc. 
```
$ ls internal/os400_bundle_v1/yum-os400/
os400repackage

see file:
setup_yum.sh
```

A sample set of yum configuration files provided with tar file.
Information is public in yum README.md.
```
$ ls internal/os400_bundle_v1/yum-conf/
repodata.tar         yum.conf-os400-aix-mix            yum.conf-os400-ifs     yum.conf-os400-mix
yum.conf-aixtoolbox  yum.conf-os400-apache_basic_auth  yum.conf-os400-litmis

see file:
setup_yum.sh
```






