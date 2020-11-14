#!/QOpenSys/usr/bin/sh

echo "
  #####  #     # ######  ####### ####### ####### 
 #     # #     # #     # #     # #     #    #    
 #       #     # #     # #     # #     #    #    
 #       ####### ######  #     # #     #    #    
 #       #     # #   #   #     # #     #    #    
 #     # #     # #    #  #     # #     #    #    
  #####  #     # #     # ####### #######    #    
                                                 
  #####  ####### ####### #     # ######          
 #     # #          #    #     # #     #         
 #       #          #    #     # #     #         
  #####  #####      #    #     # ######          
       # #          #    #     # #               
 #     # #          #    #     # #               
  #####  #######    #     #####  #

"

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
    /QOpenSys/usr/sbin/mknod $CHROOT_DIR$1 $2 $3 $4
  fi
}
function chroot_cp {
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
        action=$name
        echo "action = $name"
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
function print_usage {
  printf "\nUsage: [OPTIONS] [CHROOT DIRECTORY] [CHROOT TYPE]* \n"
  printf "\nOPTIONS:\n -g = global variable\n -i = yum install\n -y = auto yes\n -v = verbose output\n\n"
}

function intial_check {
  if [ -d /QOpenSys/usr/bin ]; then
    CHROOT_DEBUG=0
    system_OS400=1
    # setup paths to IBM Open source binaries and libraries 
    # Notes: https://bitbucket.org/litmis/ibmichroot/issues/8/alternative-download-pkg_setupsh-on-linux
    PATH=/QOpenSys/usr/bin:/QOpenSys/usr/sbin:
    LIBPATH=/QOpenSys/usr/lib
    export PATH
    export LIBPATH
    echo "**********************"
    echo "Live IBM i session (changes made)."
    echo "**********************"
    
    if ((isVerbose == 1 )) ; then
      echo "PATH=$PATH"
      echo "LIBPATH=$LIBPATH"
    fi

else
  CHROOT_DEBUG=1
  system_OS400=0
  echo "**********************"
  echo "Not IBM i, no action is taken (debug flow purpose only)."
  echo "**********************"
  exit -1
fi

}

function debug {
  if ((isVerbose == 1)) ; then
    echo $1
  fi
}

function yumInstall {
  if (($isInstalls==1)); then
    CHROOT_DIR=$1
    #Yum requires both paths
    LIBPATH=/QOpenSys/pkgs/lib:/QOpenSys/usr/lib

    for var in ${installs[@]}
    {
      debug "/QOpenSys/pkgs/bin/yum --installroot=$CHROOT_DIR install $var"
      if (($isYes==1)); then
        /QOpenSys/pkgs/bin/yum -y --installroot="$CHROOT_DIR" install $var
      else
        /QOpenSys/pkgs/bin/yum --installroot="$CHROOT_DIR" install $var
      fi
    }

  fi
}

#
# main
#

lst=0
ops=0
qsys=0
CHROOT_DIR=""
CHROOT_LIST=""
# Dependency on readlink from coreutils
SCRIPT_DIR=$(dirname $(/QOpenSys/pkgs/bin/readlink -f $0))/config



# Verify At Least 1 Argument Was Passed
if [ ! $# -ge 1 ]; then
  printf "\nERROR: At Least 1 argument [CHROOT DIRECTORY] must be passed\n"
  print_usage;
  exit -1;
fi

#Parse any flags that were passesd
isYes=0
isVerbose=0
isGlobals=0
isInstalls=0

while getopts g:i:vy flag; do
    case $flag in
        # global variables flag
        g)
          # GLOBALS="$OPTARG"
          # verify global var matches pattern key=value
          echo "$OPTARG" | grep -E '^.+(=).+'
          if [ $? -ne 0 ]; then
            printf "\nInvalid Argument: Global varibales should be in key=value format\n"
            exit -1
          fi
          isGlobals=1
          #Adds Global variable to end of list
          globals[${#globals[*]}+1]="$OPTARG"
          debug "\nGlobal: $OPTARG was added to the list\n"
        ;;
        # yes flag
        y)
          isYes=1
        ;;
        # verbose flag
        v)
          isVerbose=1 
        ;;
        #yum install flag
        i)
          #check if yum is installed
          if [ ! -f /QOpenSys/pkgs/bin/yum ]; then
            echo "ERROR: Yum could not be located"
            exit -1
          fi
          isInstalls=1
          #Adds install variable to end of list
          installs[${#installs[*]}+1]="$OPTARG"
          debug "\nInstall: $OPTARG was added to the list\n"
        ;;
        *)
          echo "Invalid Argument"
          print_usage
          exit -1
    esac
done

if (($isGlobals==1)); then
debug "Number of Elements in the Globals Array: ${#globals[*]}"
debug "Globals Array Contents: ${globals[*]}"
fi

if (($isInstalls==1)); then
debug "Number of Elements in the Installs Array: ${#installs[*]}"
debug "Installs Array Contents: ${installs[*]}"
fi

shift $((OPTIND-1))

# call the intial_check function
intial_check


TEMP_DIR=$(/QOpenSys/pkgs/bin/readlink -f $1) #this is done because the arg may be a relative path name. Needs to be done, therefore, before any 'cd'
debug "Scipt Dir: $SCRIPT_DIR"
cd "$SCRIPT_DIR"
debug "PWD: $PWD"

# Validate CHROOT DIRECTORY Argument starts with /QOpenSys/...
echo "$TEMP_DIR" | grep -iE '^[/]+QOpenSys/.+'

if [ $? -ne 0 ]; then
   printf "\nERROR: [CHROOT DIRECTORY] Must begin with /QOpenSys/...\n"
   print_usage
   exit -2;
fi

CHROOT_DIR=$TEMP_DIR

# Check if the specified Dir Already Exists
if [ ! -d "$CHROOT_DIR" ]; then
  echo "$CHROOT_DIR Does not Exist"
  mkdir -p "$CHROOT_DIR"
  #check if mkdir failed
  if [ $? -ne 0 ]; then
    echo "***$CHROOT_DIR creation failed!***"
    exit -3;
  fi
   echo "+++$CHROOT_DIR creation was successful!+++"
else
  if (($isYes==0)); then
    echo "$CHROOT_DIR Directory already exists"
    echo "Would you like to continue chroot setup? [y/N]: \c"
    read input
    if [ ! $input == "y" ]; then
        echo "Bye"
        exit -4;
    fi
  fi
fi

#remove the first arg from $@ shift others up
shift

# Validate CHROOT TYPE Argument(s)
case "$#" in
   0) # Only the chroot directory was provided: Ask if minimal with includes chroot is desired.
      if (( $isYes == 0 )) ; then
        echo "Would you like to create a minimal chroot w/ includes and nls @ $CHROOT_DIR? [y/N]: \c"
        read input 
        if [ ! $input == "y" ]; then
          echo "Specify your desired [CHROOT TYPE]"
          print_usage
          exit -5;
        fi
      fi 

      mylist[0]="$SCRIPT_DIR/default.lst"
    ;;

    *) #if chroot types were specified then use those
      for arg in "$@"
      {
        echo "Chroot type is: $arg"
        # verify a depricated OPS file was not specified
        ops=$(echo "$arg" | grep -ic 'ops')
        if ((!$ops==0)); then
          echo "OPS has been depricated, and replaced with YUM Packages. Run $0 with a valid [CHROOT TYPE]"
          print_usage
          exit -6;
        fi
        CHROOT_LIST=$arg
        
        #add chroot prefix if doesnot exist
        prefix=$(echo $CHROOT_LIST | grep -c 'chroot')
          if (($prefix==0)); then
          #prefix chroot to the file
          CHROOT_LIST="chroot_$CHROOT_LIST"
        fi

        # check if the .lst file name was given
        lst=$(echo $CHROOT_LIST | grep -c '.lst')
        if (($lst==0)); then
          #append .lst to the file
          CHROOT_LIST="$CHROOT_LIST.lst"
        fi

        #check if the .lst file exists
        if [ ! -f "$CHROOT_LIST" ]; then
          echo "$CHROOT_LIST: Cannot be found in: $PWD"
          exit -7;
        else
          #Adds File Name to End of list
          mylist[${#mylist[*]}+1]=$(/QOpenSys/pkgs/bin/readlink -f $CHROOT_LIST)
        fi
      }
    ;;
esac

debug "Number of Elements in the mylist: ${#mylist[*]}"
debug "mylist Contents: ${mylist[*]}"
sed_cmd=''
#Prepare sed_cmd for dynamic global variables if set.
if (( $isGlobals==1 )) ; then
  for var in ${globals[@]}
  {
    KEY=$(echo "$var" | cut -f1 -d '=')

    VALUE=$(echo "$var" | cut -f2 -d '=')

    sed_cmd="s|$KEY|$VALUE|g; $sed_cmd"
  }
fi

#Perform Chroot Setup
for chroot in ${mylist[@]}
{
  echo "====================================="
  echo "setting up based on $chroot"
  echo "====================================="
  CHROOT_TMP=$chroot.$(date "+%Y%m%d.%H%M%S").tmp
  if (( $isGlobals==1 )) ; then
    debug "Running Sed for Globals\n"
    debug "sed $sed_cmd $chroot > $CHROOT_TMP"
    sed "$sed_cmd" $chroot > $CHROOT_TMP

    else
    cat $chroot > $CHROOT_TMP
  fi

  #call the chroot_setup function
  chroot_setup $CHROOT_TMP
  #Clean Up 
  rm $CHROOT_TMP
}

mkdir -p "$CHROOT_DIR/QOpenSys/etc"
ETC_PROFILE="$CHROOT_DIR/QOpenSys/etc/profile"
if [ ! -f "$ETC_PROFILE" ]; then
  echo "Priming /QOpenSys/etc/profile"
  cat <<EOF >> "$ETC_PROFILE"
PATH=/QOpenSys/pkgs/bin:$PATH
export PATH
OBJECT_MODE=64
export OBJECT_MODE
EOF
fi

# perform installs if set
yumInstall $CHROOT_DIR

printf "\n\nDONE!\n"
printf "\nTo enter Your Chroot"
printf "\nRUN: chroot $CHROOT_DIR /QOpenSys/usr/bin/sh\n"
printf "\nTo set up your PATH to pick up RPM packages once inside your chroot"
printf "\nRUN: . /QOpenSys/etc/profile"
