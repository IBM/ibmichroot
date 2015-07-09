#!/bin/sh
#
# global
#
system_OS400=$(uname | grep -c OS400)
if (($system_OS400==0)); then
  CHROOT_DEBUG=1
else
  CHROOT_DEBUG=0
fi
CHROOT_DIR=""
CHROOT_LIST=""
function chroot_mkdir {
  echo "mkdir -p $CHROOT_DIR$1"
  if (($CHROOT_DEBUG==0)); then
    mkdir -p $CHROOT_DIR$1
  fi
}
function chroot_ln {
  echo "chroot $CHROOT_DIR ln -sf $1 $2"
  if (($CHROOT_DEBUG==0)); then
    chroot $CHROOT_DIR /QOpenSys/usr/bin/bsh -c "PATH=/QOpenSys/usr/bin; LIBPATH=/QOpenSys/usr/lib; export PATH LIBPATH; ln -sf $1 $2"
  fi
}
function chroot_mknod {
  echo "mknod $CHROOT_DIR$1 $2 $3 $4"
  if (($CHROOT_DEBUG==0)); then
    mknod $CHROOT_DIR$1 $2 $3 $4
  fi
}
function chroot_cp {
  # tgt=$(dirname $1)
  echo "cp $1 $CHROOT_DIR$1"
  if (($CHROOT_DEBUG==0)); then
    cp $1 $CHROOT_DIR$1
  fi
}
function chroot_cp_dir {
  chroot_mkdir $1
  echo "cp -R $1/* $CHROOT_DIR$1/."
  if (($CHROOT_DEBUG==0)); then
    cp -R $1/* $CHROOT_DIR$1/.
  fi
}
function chroot_chmod {
  echo "chmod $1 $CHROOT_DIR$2"
  if (($CHROOT_DEBUG==0)); then
    chmod $1 $CHROOT_DIR$2
  fi
}
function chroot_chmod_dir {
  if ([ "$2" == "/" ]); then
    all="*"
  else
    all="/*"
  fi
  echo "chmod -R $1 $CHROOT_DIR$2$all"
  if (($CHROOT_DEBUG==0)); then
    chmod -R $1 $CHROOT_DIR$2$all
  fi
}
function chroot_chown {
  echo "chown $1 $CHROOT_DIR$2"
  if (($CHROOT_DEBUG==0)); then
    chown $1 $CHROOT_DIR$2
  fi
}
function chroot_chown_dir {
  if ([ "$2" == "/" ]); then
    all="*"
  else
    all="/*"
  fi
  echo "chown -R $1 $CHROOT_DIR$2$all"
  if (($CHROOT_DEBUG==0)); then
    chown -R $1 $CHROOT_DIR$2$all
  fi
}
function chroot_setup {
  # copy needed PASE binaries
  action=""
  while read name; do
    case "$name" in
      "")
        # echo "empty"
      ;;
      *#*)
        # echo "comment"
      ;;
      *:*)
        # echo "action"
        action=$name
      ;;
      *)
        # echo "stuff"
        case "$action" in
          ":file")
             chroot_setup $name
             action=":file"
          ;;
          ":mkdir")
             chroot_mkdir $name
          ;;
          ":ln")
             chroot_ln $name
          ;;
          ":mknod")
             chroot_mknod $name
          ;;
          ":cp_dir")
             chroot_cp_dir $name
          ;;
          ":cp")
             chroot_cp $name
          ;;
          ":chmod_dir")
             chroot_chmod_dir $name
          ;;
          ":chmod")
             chroot_chmod $name
          ;;
          ":chown_dir")
             chroot_chown_dir $name
          ;;
          ":chown")
             chroot_chown $name
          ;;
        esac
      ;;
    esac
  done <$1
}
#
# main
#
opr="-g"
lst=0
qsys=0
for arg in "$@"
{
  if ([ $CHROOT_LIST ]); then
    CHROOT_DIR=$arg
  else
    CHROOT_LIST=$arg
  fi
}
# check input
lst=$(echo $CHROOT_LIST | grep -c '.lst')
if (($lst==0)); then
  echo "Error: 1st paramter missing *.lst ($CHROOT_LIST)"
  opr="error"
fi
qopen=$(echo $CHROOT_DIR | grep -c '/QOpenSys')
if (($qopen==0)); then
  echo "Error: 2nd paramter must start /QOpenSys ($CHROOT_DIR)"
  opr="error"
fi
# run operation
# $PS1='ranger$ '
case "$opr" in
  -g)
    chroot_setup $CHROOT_LIST
    echo "============"
    echo "chroot command:"
    echo "  > chroot $CHROOT_DIR /bin/bsh"
    echo "chroot ssh profile (optional):"
    echo "  > mkdir -p $CHROOT_DIR/home/MYPROF"
    echo "  > CHGUSRPRF USRPRF(MYPROF) LOCALE(*NONE) HOMEDIR($CHROOT_DIR/./home/MYPROF)"
    echo "    '/./home/MYPROF' is required auto ssh login chroot (IBM i hack)"
    echo "other useful settings chroot (optional):"
    echo "  > \$PS1='dev$ '"
    echo "  > LANG=C"
    echo "  > LANG=819"
  ;;
  *)
    echo "./$(basename $0) chroot_copy.lst /QOpenSys/root_path"
  ;;
esac

