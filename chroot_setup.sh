#!/bin/sh
#
# global
#

if [ -d /QOpenSys/usr/bin ]
then
  CHROOT_DEBUG=0
  system_OS400=1
  # setup paths to IBM Open source binaries and libraries 
  # Notes: https://bitbucket.org/litmis/ibmichroot/issues/8/alternative-download-pkg_setupsh-on-linux
  PATH=/QOpenSys/usr/bin:/QOpenSys/usr/sbin:/opt/freeware/bin
  LIBPATH=/QOpenSys/usr/lib:/opt/freeware/lib
  export PATH
  export LIBPATH
  echo "**********************"
  echo "Live IBM i session (changes made)."
  echo "**********************"
  echo "PATH=$PATH"
  echo "LIBPATH=$LIBPATH"
else
  CHROOT_DEBUG=1
  system_OS400=0
  echo "**********************"
  echo "Not IBM i, no action is taken (debug flow purpose only)."
  echo "**********************"
fi

CHROOT_DIR=""
CHROOT_LIST=""
CHROOT_PID="$$"
CHROOT_VARG=""

function chroot_mkdir {
  echo "mkdir -p $CHROOT_DIR$1"
  if (($CHROOT_DEBUG==0)); then
    mkdir -p $CHROOT_DIR$1
  fi
}
# function occurs INSIDE chroot
# requires some utilities:
#  /QOpenSys/usr/bin
#  /QOpenSys/usr/lib
function chroot_ln {
  echo "chroot $CHROOT_DIR ln -sf $1 $2"
  if (($CHROOT_DEBUG==0)); then
    chroot $CHROOT_DIR /QOpenSys/usr/bin/bsh -c "ln -sf $1 $2"
  fi
}
# function occurs OUTSIDE chroot
function chroot_ln_rel {
  mydir=$(dirname $1)
  mybase=$(basename $1)
  if (($CHROOT_DEBUG==0)); then
    relname=$(ls -l $1 | awk '{print $(NF)}')
  else
    relname="../../testing/$1"
  fi
  echo "cd $CHROOT_DIR$mydir"
  echo "ln -sf $relname $mybase"
  if (($CHROOT_DEBUG==0)); then
    here=$(pwd)
    cd $CHROOT_DIR$mydir
    ln -sf $relname $mybase
    cd $here
  fi
}
# function occurs OUTSIDE chroot
function chroot_ln_fix_rel {
  mydir=$(dirname $1)
  mybase=$(basename $1)
  relname=$2
  echo "cd $CHROOT_DIR$mydir"
  echo "ln -sf $relname $mybase"
  if (($CHROOT_DEBUG==0)); then
    here=$(pwd)
    cd $CHROOT_DIR$mydir
    ln -sf $relname $mybase
    cd $here
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
function chroot_tar_dir {
  chroot_mkdir $1
  mydir=$(dirname $1)
  mybase=$(basename $1)
  here=$(pwd)
  if [ -f $here/$mybase.tar ]; then
    echo "Using existing $here/$mybase.tar"
  else
    echo "cd $mydir"
    echo "tar -chf $here/$mybase.tar $mybase"
    echo "cd $CHROOT_DIR$mydir"
    echo "tar -xf $here/$mybase.tar"
  fi
  if (($CHROOT_DEBUG==0)); then    
    if ! [ -f $here/$mybase.tar ]; then
      cd $mydir
      tar -chf $here/$mybase.tar $mybase
    fi
    cd $CHROOT_DIR$mydir
    tar -xf $here/$mybase.tar
    cd $here
  fi
}
function chroot_chmod {
  echo "chroot $CHROOT_DIR /QOpenSys/usr/bin/bsh -c \"chmod $1 $2\""
  if (($CHROOT_DEBUG==0)); then
    chroot $CHROOT_DIR /QOpenSys/usr/bin/bsh -c "chmod $1 $2" 
  fi
}
function chroot_chmod_dir {
  if ([ "$2" == "/" ]); then
    all="*"
  else
    all="/*"
  fi
  echo "chroot $CHROOT_DIR /QOpenSys/usr/bin/bsh -c \"chmod -R $1 $2$all\""
  if (($CHROOT_DEBUG==0)); then
    chroot $CHROOT_DIR /QOpenSys/usr/bin/bsh -c "chmod -R $1 $2$all"
  fi
}
function chroot_chown {
  echo "chroot $CHROOT_DIR /QOpenSys/usr/bin/bsh -c 'chown $1 $2'"
  if (($CHROOT_DEBUG==0)); then
    chroot $CHROOT_DIR /QOpenSys/usr/bin/bsh -c "chown $1 $2"
  fi
}
function chroot_chown_dir {
  if ([ "$2" == "/" ]); then
    all="*"
  else
    all="/*"
  fi
  echo "chroot $CHROOT_DIR /QOpenSys/usr/bin/bsh -c 'chown -R $1 $2$all'"
  if (($CHROOT_DEBUG==0)); then
    chroot $CHROOT_DIR /QOpenSys/usr/bin/bsh -c "chown -R $1 $2$all"
  fi
}
function chroot_system {
  cmd=$(echo "$1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12} ${13} ${14} ${15} ${16} ${17} ${18} ${19} ${20}" | sed -e 's/[[:space:]]*$//')
  echo "system -i \"$cmd\""
  if (($CHROOT_DEBUG==0)); then
    system -i "$cmd"
  fi
}
function chroot_sh {
  echo "$@"
  if (($CHROOT_DEBUG==0)); then
    eval $@
  fi
}
function chroot_setup {  
  # copy needed PASE binaries
  action=""
  while read -r name <&3; do
    case "$name" in
      "")
        # echo "empty"
      ;;
      *#*)
        # echo "comment"
      ;;
      :*)
        # echo "action"
        action=$name
      ;;
      *)
        case "$action" in
          ":file")
             chroot_setup $name
             action=":file"
          ;;
          ":mkdir")
             chroot_mkdir $name
          ;;
          ":ln_fix_rel")
             chroot_ln_fix_rel $name
          ;;
          ":ln_rel")
             chroot_ln_rel $name
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
          ":tar_dir")
             chroot_tar_dir $name
          ;;
          ":system")
             chroot_system $name
          ;;
          ":sh")
             chroot_sh $name
          ;;          
        esac
      ;;      
    esac
  done 3<$1
}
#
# main
#
opr="-g"
lst=0
qsys=0
for arg in "$@"
{
  if ([ $CHROOT_LIST ] && [ $CHROOT_DIR ]); then
    # split by equals sign
    CHROOT_VARG="$CHROOT_VARG $arg"
  elif ([ $CHROOT_LIST ]); then
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
mkdir -p $CHROOT_DIR
# run operation
# $PS1='ranger$ '
key=""
val=""
sed_cmd="-e 's/1/1/g'" # Need this for when no global variables passed.
for i in $(echo $CHROOT_VARG | tr "=" "\n")
do
  if ([ $key ]); then
    val=$i
    sed_cmd="$sed_cmd -e 's|$key|$val|g'"
    key=""
    val=""
  else
    key=$i
  fi
done
CHROOT_LIST_TMP=$CHROOT_LIST.$(date "+%Y%m%d.%H%M%S").tmp
eval "sed $sed_cmd $CHROOT_LIST > $CHROOT_LIST_TMP"
case "$opr" in
  -g)
    chroot_setup $CHROOT_LIST_TMP
    rm $CHROOT_LIST_TMP
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
    echo "./$(basename $0) chroot_copy.lst /QOpenSys/root_path var1=/myval var2=MYNAME ..."
  ;;
esac

