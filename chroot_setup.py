#!/QOpenSys/pkgs/bin/python3

import argparse
import os
import logging
import Template from string
from enum import Enum

parser = argparse.ArgumentParser()
# positional arguments
parser.add_argument("chroot_directory", metavar="CHROOT_DIRECTORY", help="TODO: some help text")
parser.add_argument("chroot_type", metavar="CHROOT_TYPE", help="TODO: some help text", nargs="?")
# optional arguments
parser.add_argument("-g", dest='globals', nargs='*', metavar="", help="TODO: global variable")
parser.add_argument("-i", dest='yum_installs' nargs='*' metavar="", help="TODO: yum install")
parser.add_argument("-y", dest='auto_yes', metavar="", help="TODO: auto yes")
parser.add_argument("-v", dest='verbose', metavar="", help="TODO: verbose output")
args = parser.parse_args()
parser.parse_args()

print("""
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
""")

CHROOT_DEBUG : bool = False

print(args.chroot_directory)

# TODO: documentation
def chroot_mkdir ( dir: str ):
  # TODO: fix print statement
  print('os.mkdirs(' + args.chroot_directory + dir + ', exist_ok=True)')
  if (CHROOT_DEBUG == False):
    os.mkdirs(args.chroot_directory + dir, exist_ok=True)

# TODO: documentation
# Function should occur inside a chroot
def chroot_ln (target: str, link_name: str):
  # TODO: fix print statement
  printf('chroot $CHROOT_DIR ln -sf $1 $2')
  if (CHROOT_DEBUG == False):
    # TODO: check that we don't have to go into the chroot. I suspect we might
    os.symlink(target, link_name, dir_fd=args.chroot_directory)

# TODO: documentation
# function occurs OUTSIDE chroot
# def chroot_ln_rel (target: str, link_name: str):
#   mydir = os.path.dirname(target)
#   mybase = os.path.basename(target)
#   if (CHROOT_DEBUG == False):

#     relname=$(ls -l $1 | awk '{print $(NF)}')
#   else
#     relname="../../testing/$1"
#   fi
#   echo "cd $CHROOT_DIR$mydir"
#   echo "ln -sf $relname $mybase"
#   if (($CHROOT_DEBUG==0)); then
#     here=$(pwd)
#     cd $CHROOT_DIR$mydir
#     ln -sf $relname $mybase
#     cd $here
#   fi
# }

# TODO: documentation
# function occurs OUTSIDE chroot
def chroot_ln_fix_rel(target: str, link_name: str):
  mydir = os.path.dirname(target)
  mybase = os.path.basename(target)
  print('cd ' + args.chroot_directory + mydir)
  print('ln ' + link_name + ' ' + mybase)

  if (CHROOT_DEBUG == False):
    here = os.getcwd()
    os.chdir(args.chroot_directory + mydir)
    os.symlink(target, link_name)
    ln -sf $relname $mybase
    os.chdir(here)


# TODO: documentation
def chroot_mknod (node: str, type: str, major, minor) {
  print("mknod $CHROOT_DIR$1 $2 $3 $4")
  if (CHROOT_DEBUG == False):
    os.mknod(args.chroot_directory + node, type, major, minor)
    # /QOpenSys/usr/sbin/mknod $CHROOT_DIR$1 $2 $3 $4
}

# TODO: documentation
def chroot_cp ( source: str ):
  print("cp $1 $CHROOT_DIR$1")
  if (CHROOT_DEBUG == False):
    shutil.copy(source, args.chroot_directory + source)

# TODO: documentation
def chroot_cp_dir ( source: str ):
  print("cp -R $1/* $CHROOT_DIR$1/.")
  # TODO: Why mkdir before checking debug?
  chroot_mkdir(source)
  if (CHROOT_DEBUG == False):
    shutil.copytree(source, args.chroot_directory + source)


def chroot_chmod (mode, file)
  # TODO: change 
  printf("chroot $CHROOT_DIR /QOpenSys/usr/bin/bsh -c \"chmod $1 $2\"")
  if (CHROOT_DEBUG == False):
    os.chmod(args.chroot_directory + file, int(mode), 8)

def chroot_chmod_dir (mode, path) {
  for root, dirs, files in os.walk(args.chroot_directory + path):  
    for dir in dirs:  
      os.chmod(os.path.join(root, dir), int(mode, 8))
    for file in files:
      os.chmod(os.path.join(root, file), int(mode, 8))

def chroot_chown (user: str, file: str)
  # TODO: change 
  printf("chroot $CHROOT_DIR /QOpenSys/usr/bin/bsh -c \"chmod $1 $2\"")
  if (CHROOT_DEBUG == False):
    os.chown(args.chroot_directory + file, user)

#TODO: documentation
def chroot_chown_dir (user: str , path: str) {
  for root, dirs, files in os.walk(args.chroot_directory + path):  
    for dir in dirs:  
      os.chown(os.path.join(root, dir), user)
    for file in files:
      os.chown(os.path.join(root, file), user)

# TODO: documentation
def chroot_system(line: str):
  line = line.rstrip()
  print('system -i "' + line + '"')
  if (CHROOT_DEBUG == False):
    os.system('system -i "' + line + '"')

# TODO: documentation
def chroot_sh(line: str):
  print(line)
  if (CHROOT_DEBUG == False):
    os.system(line)

action_dictionary = {
  ':file'       : chroot_setup,
  ':mkidr'      : chroot_mkdir,      # done
  ':ln_fix_rel' : chroot_ln_fix_rel, # done
  ':ln_rel'     : chroot_ln_rel,     # done
  ':ln'         : chroot_ln,         # done
  ':mknod'      : chroot_mknod,      # done
  ':cp_dir'     : chroot_cp_dir,     # done
  ':cp'         : chroot_cp,         # done
  ':chmod_dir'  : chroot_chmod_dir,  # done
  ':chmod'      : chroot_chmod,      # done
  ':chown_dir'  : chroot_chown_dir,  # done
  ':chown'      : chroot_chown,      # done
  ':system'     : chroot_system,
  ':sh'         : chroot_sh
}

def chroot_setup (chroot_lst):
  lst_file = open(chroot_lst, 'r')
  action = None

  # Iterate over all lines in the file, executing actions where encountered
  for line in lst_file:
    line = line.strip()

    # Blank line
    if not line:
      # print('empty')

    # Comment
    else if line.startswith('#'):
      # print('comment')

    # Determine action
    else if line.startswith(':'):
      action = action_dictionary[line]

    # Execute action
    else:
      if action not None:
        action(line)

# TODO: documentation
def initial_check ():
  if (os.path.exists('/QOpenSys/usr/bin')):
    CHROOT_DEBUG = False
    PATH='/QOpenSys/usr/bin:/QOpenSys/usr/sbin:'
    LIBPATH='/QOpenSys/usr/lib'
    os.environ['PATH'] = PATH
    os.environ['LIBPATH'] = LIBPATH
    print("**********************")
    print("Live IBM i session (changes made).")
    print("**********************")

    if (ags.verbose):
      print('PATH=' + PATH)
      print('LIBPATH=' + LIBPATH)

  else:
    CHROOT_DEBUG = True
    print("**********************")
    print("Not IBM i, no action is taken (debug flow purpose only).")
    print("**********************")
    # exit -1


def yum_install(package_list: list):
  os.environ["LIBPATH"] = '/QOpenSys/pkgs/lib:/QOpenSys/usr/lib'
  install_template = Template('/QOpenSys/pkgs/bin/yum $yes --installroot=$chroot_dir install $package')
  auto_yes = '-y' if args.auto_yes else ''
  for package in package_list:
    command = install_template.substitute(yes=auto_yes, chroot_dir=args.chroot_directory, package=package)
    logger.debug(command)
    os.system(command)

#
# MAIN
#

lst = 0
ops = 0
qsys = 0
CHROOT_DIR = ""
CHROOT_LIST = ""
SCRIPT_DIR = os.path.dirname(os.readlink(args.chroot_directory)) + "/config"

# Didn't implement all of the checks, argparse can do that

intial_check()

# This is done because the arg may be a relative path name.
# Need to be done before any 'cd'
TEMP_DIR = os.readlink(args.chroot_directory)

logger.debug("Scipt Dir: " + SCRIPT_DIR)
os.chdir(SCRIPT_DIR)
logger.debug("PWD: " + os.getcwd())

if not TEMP_DIR.startswith('/QOpenSys/'):
  print("\nERROR: [CHROOT DIRECTORY] Must begin with /QOpenSys/...\n")
  parser.print_help
  sys.exit(-2)

CHROOT_DIR = TEMP_DIR


if not os.path.isdir(CHROOT_DIR):
  print(CHROOT_DIR + " does not exist.")
  os.mkdir(CHROOT_DIR)
  # TODO: Check creation
else:
  if not args.auto_yes
    print(CHROOT_DIR + " directory already exists")
    val = input("Would you like to continue chroot setup? [y/N]")
    if not val == "y":
      print("Bye")
      sys.exit(-4)
  else:
    # continues automatically


## CHANGE
# Validate CHROOT TYPE Argument(s)
if not args.chroot_type:
  # Only chroot_directory was provided to the script:
  # Ask if minimal with includes chroot is desired
  if not args.auto_yes:
    val = input("Would you like to create a minimal chroot w/ includes @ " + CHROOT_DIR + "? [y/N]:")
    if not val == "y":
      print("Specify your desired [CHROOT TYPE]")
      parser.print_help
      sys.exit(-5)

  mylist = []
  mylist.append(SCRIPT_DIR + "/chroot_includes.lst")
  mylist.append(SCRIPT_DIR + "/chroot_minimal.lst")

else:
  # If chroot types were specified, then use those
  for arg in args.chroot_type
    print("Chroot type is: " + arg)
    # TODO: I think this is line with the shell script, but what about random
    # list names that might include 'ops' in them?
    if ("ops" in arg):

      # verify a deprecated OPS file was not specified
      print("OPS has been depricated, and replaced with YUM Packages. Run $0 with a valid [CHROOT TYPE]")
      parser.print_help
      sys.exit(-6)

    CHROOT_LIST = arg

    # add chroot prefix if it doesn't exist
    if not CHROOT_LIST.startswith('chroot'):
      CHROOT_LIST = 'chroot_' + CHROOT_LIST

    # check that the .lst file name was given
    if not CHROOT_LIST.endswith('.lst')
      CHROOT_LIST = CHROOT_LIST + '.lst'

    # check that the .lst file exists
    if not os.path.isfile(CHROOT_LIST):
      print(CHROOT_LIST + " cannot be found in " os.cwd)
      sys.exit(-7)
    else:
      # append file name to end of list
      mylist.append(os.readlink(CHROOT_LIST))

logger.debug("Number of elements in the list: " + len(mylist))
logger.debug("List contents: " + mylist) #TODO: doubt this works

# convert any global variables passed from a list of string "KEY=VALUE" to a
# dictionary holding "KEY": "VALUE"
globals_dictionary = {}
if args.globals:
    for global_var in args.globals:
      global_tokens = global_var.split('=')
      globals_dictionary[global_tokens[0]] = global_tokens[1]

for chroot_file in mylist:
  print("=====================================")
  print("setting up based on " + chroot_file)
  print("=====================================")

  for key in globals_dictionary:
    os.environ[key] = globals_dictionary[key]

  chroot_setup(chroot)

  for key in globals_dictionary:
    del os.environ[key]

os.makedirs(args.chroot_directory + '/QOpenSys/etc', exit_ok=True)
etc_profile = (args.chroot_directory + '/QOpenSys/etc/profile')
if not os.path.isfile(etc_profile):
  print('Priming /QOpenSys/etc/profile')
  etc_file = open(etc_profile, 'a')
  etc_file.write('PATH=/QOpenSys/pkgs/bin:$PATH\n')
  etc_file.write('export PATH\n')
  etc_file.write('OBJECT_MODE=64\n')
  etc_file.write('export OBJECT_MODE\n')

# perform installs if set
yum_install(args.yum_installs)

print("""

Done creating your chroot!

To enter your chroot
Run: chroot """ + args.chroot_directory + """ /QOpenSys/usr/bin/sh

To set up your PATH to pick up RPM packages once inside your chroot
Run: . /QOpenSys/etc/profile
""")