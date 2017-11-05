# echarts3_practice

practice how to create graph in own js and save to file:

1. cd server; ruby mini_web.rb

（use mini_web to start server which is save file to local... (filename can be changed)）

2. ruby client_test.rb (then check in the public folder should have some with name postfix png...)

 browse the file(e2.html) in the localhost  

（replace the hhh in the file!!!!)




csv to echart graph and (save locally)
1. csv + template
2. yaml
   (head:true|false
   echarts options data format: data:[{value:$1,name:'$2'},..]
   save_file_name:hhh
   )
3. generate the needed js and run, by using watir（curl doesnt work for the dom), then save file.


template need to be considered ...


1. 
   .3 cd /data/scripts/report/shell 
   change 车龄分布.sh (换品牌，季度)
   sh 车龄分布.sh
   sz ../csv/车龄发布.csv --> c:/temp

2. copy c:\temp\车龄发布.csv  C:\Users\williamchen\Documents\GitHub\echarts3_practice\tools\流向处理\车龄发布.csv
   cd C:\Users\williamchen\Documents\GitHub\echarts3_practice\tools\流向处理
   ruby 车龄分布.rb

3. cd C:\Users\williamchen\Documents\GitHub\echarts3_practice\client
   ruby client_test.rb

4. check C:\Users\williamchen\Documents\GitHub\echarts3_practice\server\public\hhh.png


#####
ALL:
.3 cd /data/scripts/report/shell sh -x arr.sh then copy csv to csv...(change arr.sh necessary!)
in windows, git clone;
cd tools
pro.bat 凯越 (might need change 2017 and quanter!)
Done!
####