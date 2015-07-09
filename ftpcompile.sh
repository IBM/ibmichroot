# bash ftpcompile.sh lp0364d adc
MYPWD=$(<$HOME/.ftprc)
ftp -i -n -v $1 << ftp_end
user $2 $MYPWD

quote namefmt 1
bin

mkdir /QOpenSys/QIBM/ProdData/OPS/GCC
cd /QOpenSys/QIBM/ProdData/OPS/GCC
mput *

quit

ftp_end

