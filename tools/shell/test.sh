IFS=$'\n'
OLDIFS="$IFS"
#BRAND='雷克萨斯'
#SERS='雷克萨斯ES'

#BRAND='宝马'
#SERS='宝马5系'

#BRAND='奔驰'
#SERS='奔驰C级'

#BRAND='别克'
#SERS='凯越'

#BRAND='福特'
#SERS='嘉年华'

BRAND=$1
SERS=$2

J1='三'
J2='3'
S_DATE='2017-06-01 00:00:00'
E_DATE='2017-10-01 00:00:00'

cd ..
ruby dump_sql_to_csv.rb '172.16.0.31' 3306 wx_data_source sql/原始数据.sql csv/${SERS}_流向数据.csv $SERS $J1 $J2

ruby dump_sql_to_csv.rb '172.16.0.31' 3306 db_sct_vip sql/网络数据.sql csv/${SERS}_网络数据.csv $SERS $S_DATE $E_DATE

ruby dump_sql_to_csv.rb '172.16.0.31' 3306 db_sct_vip sql/周转天数.sql csv/${SERS}_周转天数.csv $BRAND $SERS $S_DATE $E_DATE

sz csv/${SERS}_网络数据.csv
sz csv/${SERS}_流向数据.csv
sz csv/${SERS}_周转天数.csv

IFS="$OLDIFS"

