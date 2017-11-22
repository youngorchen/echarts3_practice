@echo On
chcp 65001

cls

del ..\server\public\my_js\* /S /Q
del ..\server\public\liuxiang\* /S /Q
del ..\server\public\wangluoshuju\* /S /Q
del ..\server\public\zhouzhuantianshu\* /S /Q
del 流向处理\csv\* /S /Q
del 周转天数\csv\* /S /Q
del 网络数据\csv\* /S /Q

rem set cx1=凯越 宝马5系 奔驰C级 嘉年华
set cx1=%1
set pat=%2

copy /A /V /Y c:\temp\%cx1%_周转天数.csv .\周转天数\csv\in_原始数据.csv
copy /A /V /Y c:\temp\%cx1%_网络数据.csv .\网络数据\csv\in_原始数据.csv
copy /A /V /Y c:\temp\%cx1%_流向数据.csv .\流向处理\csv\in_原始数据.csv

cd 流向处理
ruby lxcl.rb

cd ..\网络数据
ruby wlsj.rb %cx1%

rem pause

rem +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
rem ...............................patch.............................
rem +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

rem copy the patch_out file first from the related series..
rem then call ruby patch.rb
rem 
copy /V /Y %pat%\%cx1%\电商top100_out.csv csv\电商top100_out.csv
copy /V /Y %pat%\%cx1%\供应指数_out.csv csv\供应指数_out.csv

ruby patch.rb

cd ..\周转天数
ruby zzts.rb


cd ..\..\client
ruby client_test.rb

cd ..\tools

rem del output /F /S /Q
rd output\%cx1% /S /Q
mkdir output\%cx1%

xcopy /S /V /F /Y /I 流向处理\csv\*  output\%cx1%\流向处理
xcopy /S /V /F /Y /I 网络数据\csv\*  output\%cx1%\网络数据
xcopy /S /V /F /Y /I 周转天数\csv\*  output\%cx1%\周转天数

xcopy /S /V /F /Y /I ..\server\public\liuxiang\*  output\%cx1%\流向处理
xcopy /S /V /F /Y /I ..\server\public\wangluoshuju\* output\%cx1%\网络数据
xcopy /S /V /F /Y /I ..\server\public\zhouzhuantianshu\* output\%cx1%\周转天数

cd office
del out.doc /S /Q
ruby e1.rb %cx1% '2017' '第三季度'

copy /V /Y out.doc ..\output\%cx1%\result.docx

cd ..

