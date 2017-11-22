@echo On
chcp 65001

for %%h in (赛拉图 卡罗拉 凯越 奥迪A6L 沃尔沃XC60  本田CR-V 帕萨特 宝马5系 天籁 雅阁 捷达 嘉年华  别克GL8 普拉多 思域 大众POLO 宝马3系 轩逸 飞度 宝来 蒙迪欧 奥迪A4L 起亚K2 君威 凯迪拉克XTS 锐志 科鲁兹 凯美瑞 朗逸 奔驰E级 宝马X5 骐达 奥德赛 速腾 福克斯 奥迪Q5 狮跑 君越 雷克萨斯ES 威驰 汉兰达 桑塔纳 奔驰C级 迈腾 致胜 英朗XT 揽胜极光 丰田RAV4 途观 高尔夫 昂科威 皇冠) do (
 rem for %%h in ( 福克斯 奥迪Q5 狮跑 君越 雷克萨斯ES 威驰 汉兰达 桑塔纳 奔驰C级 迈腾 致胜 英朗XT 揽胜极光 丰田RAV4 途观 高尔夫 昂科威 皇冠) do (
 rem echo call pro.bat %%h
 rem call pro.bat %%h
 call pro.bat %%h ..\..\patch
)

