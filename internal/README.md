#ibmichroot work files

*** These files are ibmichroot builders only. Do not copy to your IBM i machine ***

# Builders ibmichroot (Tony/Aaron).
This is the source for os400_bundle_v1. The actual bundle used in installation is os400_bundle_v1.tar.
Adds, changes, supplements to aix toolbox rpm, yum, createrepo are found here.

```
$ cd internal
$ tar -cf os400_bundle_v1.tar os400_bundle_v1
$ cp os400_bundle_v1.tar ../yum/.
```

Additional tar files are packaged directly from aix toolbox rpms.

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
-- so on --
```


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




