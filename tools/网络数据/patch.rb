# -*- coding: UTF-8 -*-

require 'rubygems'
require 'pp'
require '../utils/city'
require 'date'

h = get_excel('csv/电商top100_out.csv','A2','B1000000000')

#generate area graph...
h = h.to_a.sort!{|a| Date.parse(a[0])}
#write_area(h[30..-1],0,1,'wl_dstop100')
write_bar(h[30..-1],0,1,'wl_dstop100','#9d2933','','90%')

#http://127.0.0.1:4567/wl_dstop100.html
#http://127.0.0.1:4567/wl_gyzs.html


# 供应指数
h = get_excel('csv/供应指数_out.csv','A2','C1000000000')

def get_avg(h,i,n=30)
    v = 0

    num = 0
    (i...h.length).each do |k|
        #pp h[i][0],h[k][0]
        if Date.parse(h[i][0]) - Date.parse(h[k][0]) < n
            num += 1
            v += h[k][2].to_i
        end
    end
 #   pp v,num
    to_n_point_float(v*1.0/num,2)
end

max = 0
t = []
#write out csv...
File.open('csv/供应指数_out.csv', "w",:encoding=>"gbk") { |iol|  
    iol << "日期,30天日均发布量*,成分车商每日发布量" << "\n"
    (0...h.length).each do |i|
#        pp i
#        pp h[i]
        if Date.parse(h[0][0]) - Date.parse(h[i][0]) <= 90
            iol << "#{h[i][0]},#{get_avg(h,i)},#{h[i][2]}\n"
            max = i
            t << [h[i][0],get_avg(h,i)]
        else
            iol << "#{h[i][0]},,#{h[i][2]}\n"
        end

        #pp "#{h[i][0]},#{get_avg(h,i)},#{h[i][1]}\n"
    end
}

t = t.to_a.sort!{|a| Date.parse(a[0])}
write_area(t[0..max],0,1,'wl_gyzs','#576b7c','#25f96e','#576b7c')

#############价格波动！
## TODO,read from db or tianyan?
##

