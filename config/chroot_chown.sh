#!/bin/sh
#

#
# main
#
CHROOT_OWN=""
opr="error"
for arg in "$@"
{
  if ([ $CHROOT_OWN ]); then
    echo "Error: extra paramter $arg ignored"
  else
    CHROOT_OWN=$arg
  fi
}
# check input
if ([ $CHROOT_OWN ]); then
  opr="-g"
else
  echo "Error: 1st paramter owner missing (user profile owner)"
fi
# run operation
case "$opr" in
  -g)
    chroot /QOpenSys/$CHROOT_OWN /QOpenSys/usr/bin/bsh -c "chown -Rh $CHROOT_OWN ."
  ;;
  *)
    echo "./$(basename $0) owner"
  ;;
esac

