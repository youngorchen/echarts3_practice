# -*- coding: UTF-8 -*-

require 'rubygems'
require 'pp'
require '../utils/city'
require 'date'

$ec_2_gbk = Encoding::Converter.new("utf-8", "gbk")
$ec_2_utf8 = Encoding::Converter.new("gbk","utf-8")

#城市 首次发布时间  标准品牌    标准车系    站点  成份车商名   来源  天眼属性
recs = read_csv_gbk('csv/in_原始数据.csv',8)
#pp recs

#series = '凯越' #ARGV[1] 
pp ARGV
series = ARGV[0]
pp series
#pp to_utf8(series)
#pp to_gbk(series)

source = $map_4s[series.to_sym] 
pp source 
#STDIN.gets

def group_by_col(recs,col,cs_name)
    h = {}

    cs_name.each do |cs|
        h[cs] = 0

        recs.each do |r|
            h[cs] += 1 if r[col] == cs
        end
    end
    h
end

def get_excel_and_chart(recs,col,source,file_name,js_file,color1)

    recs_4s = []

    if source == ''  #没有网络数据数据4s店映射的，取全部数据
        recs_4s = recs
    else
        unless source.class == [].class
            recs_4s = recs.select { |e|  $ec_2_utf8.convert(e[col]) == source } 
        else
            recs_4s = recs.select { |e|  source.index($ec_2_utf8.convert(e[col])) }
        end
    end
    #pp recs_4s


    cs_name = []
    recs_4s.each do |cs|
        cs_name << cs[-3]
    end

    cs_name.uniq!

    #pp cs_name


    h = group_by_col(recs_4s,-3,cs_name)
    h = h.sort_by {|k,v| -v }

    #pp h
    cs_tol = 0

    h.each { |k,v|  cs_tol += v }
    #pp cs_tol

    #pp h
    t10 = 0
    (0...10).each do |i|
        begin
            t10 += h[i][1]    #???????????????????
        rescue Exception => e  
            puts "i=#{i}"
            puts h
            puts h[i]
            puts e.message  
            puts e.backtrace.inspect 
            #exit
        end
    end

    t10p =  to_n_point_float(t10*100.0/cs_tol,2)
    
    #write out csv...
    File.open(file_name, "w",:encoding=>"gbk") { |iol|  
        iol << "车商名字,发布量*" << "\n"
        h.each do |k,v|
            iol << "#{k},#{v}\n"
        end
        iol << "," << cs_tol << "\n"
        iol << ","  << t10p << "\n"
    }

    #generate pie...
    #write_pie(h[0..4],0,1,js_file)
    ht = [h[9],h[8],h[7],h[6],h[5],h[4],h[3],h[2],h[1],h[0]]
    write_bar2(ht,0,1,js_file,color1)
end

#http://127.0.0.1:4567/wl_4s.html
#http://127.0.0.1:4567/wl_dlcs.html
#http://127.0.0.1:4567/wl_dstop100.html
#http://127.0.0.1:4567/wl_gyzs.html

ind = 0
recs_3m = recs[1..-1].select { |e|  
    #pp recs[1][1],e[1]
    ind += 1
    begin
        Date.parse(recs[1][1]) - Date.parse(e[1]) <= 90
    rescue
        pp recs[1][1],e[1],ind
        puts "###-----------------################"
        STDIN.gets
        exit
    end
}  #d第一行的时间

get_excel_and_chart(recs_3m,-2,source,'csv/4s_out.csv','wl_4s','#2e4e7e') 

recs_3m_1 = recs_3m.select { |e|  e[-1] == '3'}  #d第一行的时间

get_excel_and_chart(recs_3m_1,-2,['网络媒体','车王','澳康达','捷和'],'csv/独立车商_out.csv','wl_dlcs','#9d2933') 

#'瓜子网' '人人车网'

recs_4s = recs_3m.select { |e|  $ec_2_utf8.convert(e[-2]).index('瓜子') || $ec_2_utf8.convert(e[-2]).index('人人车') }

cs_name = []

recs_4s.each do |i|
    cs_name << i[0]
end

cs_name.uniq!

h = group_by_col(recs_4s,0,cs_name).sort_by {|a| -a[1]}

#top 100
cs_name = []
h[0..100].each do |v|
    cs_name << v[0]
end

#pp cs_name

dates = []

recs.each do |v|
    dates << v[1]   unless $ec_2_utf8.convert(v[1]) == '首次发布时间'     
end

dates = dates.uniq!.sort {|a,b| Date.parse(b) <=> Date.parse(a)}

#pp dates

h = {}
dates.each do |d|
    h[d] = 0
    print "."
    cs_name.each do |c|
        recs_4s.each do |e|  
            h[d] += 1 if e[0] == c && e[1] == d 
        end
    end
end

#pp h
#write out csv...
File.open('csv/电商top100_out.csv', "w",:encoding=>"gbk") { |iol|  
    iol << "首次发布时间,C2C电商平台在前100个城市每日发布的车源总量*" << "\n"
    h.each do |k,v|
        iol << "#{k},#{v}\n"
    end
}

#generate area graph...
h = h.to_a.sort!{|a| Date.parse(a[0])}
#write_area(h[30..-1],0,1,'wl_dstop100')
write_bar(h[30..-1],0,1,'wl_dstop100','#9d2933','','90%')

# 供应指数
h = {}
dates.each do |d|
    h[d] = 0
    print "."
    recs.each do |v|
        #pp v
        if v[1] == d && v[-1] == '3'  #属性3
            h[d] += 1 
            #puts "--",d,v[1],v[-1]
        end

    end
end

#pp h
h = h.to_a

def get_avg(h,i,n=30)
    v = 0

    num = 0
    (i...h.length).each do |k|
        #pp h[i][0],h[k][0]
        if Date.parse(h[i][0]) - Date.parse(h[k][0]) < n
            num += 1
            v += h[k][1]
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
        #pp h[i]
        if Date.parse(h[0][0]) - Date.parse(h[i][0]) <= 90
            iol << "#{h[i][0]},#{get_avg(h,i)},#{h[i][1]}\n"
            max = i
            t << [h[i][0],get_avg(h,i)]
        else
            iol << "#{h[i][0]},,#{h[i][1]}\n"
        end

        #pp "#{h[i][0]},#{get_avg(h,i)},#{h[i][1]}\n"
    end
}

t = t.to_a.sort!{|a| Date.parse(a[0])}
write_area(t[0..max],0,1,'wl_gyzs','#576b7c','#25f96e','#576b7c')

#############价格波动！
## TODO,read from db or tianyan?
##

