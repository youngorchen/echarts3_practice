# -*- coding: UTF-8 -*-

require 'rubygems'
require 'pp'
require '../utils/city'
require 'date'


#年份 季度  企业  品牌  车型  排量  原城市 流向城市    车龄年 数量

recs = read_csv_gbk('csv/in_原始数据.csv',10)[1..-1]

#流向统计_out.csv
#本地交易TOP50城市_out.csv
#外迁TOP50城市_out.csv
#外迁TOP1-5_out.csv

def sum(org,org_c,tar_c)
    #pp "#{org_c}"
    #pp "#{tar_c}"
    t = org.select { |e|  e[6] == org_c and e[7] == tar_c}
    #t = org.select { |e|  pp "#{org_c},#{tar_c},#{e[6]},#{e[7]}",e[6] == org_c and e[7] == tar_c}
    #pp t
    s = 0
    t.each { |e| s+= e[9].to_i }
    s
end


# 流出目标地区  外迁量(**) 集中度(top 15) ==> 外迁TOP1..5
def sum_org_waiqian(c,org,cities,n)

    arr = []
    cities.each do |i|
        #puts i,c
        next if c == i
        arr << [i,sum(org,to_gbk(c),to_gbk(i))]
    end

    arr = arr.sort_by { |e|  -e[1]}

    t15 = 0
    (0..14).each do |i|
        t15 += arr[i][1].to_i
    end

    total = 0
    (0...arr.length).each do |i|
        total += arr[i][1].to_i
    end

    File.open("csv/外迁TOP#{n}_out.csv", "w",:encoding=>"gbk") { |iol|  
        iol << "#{c}流出目标地区,外迁量o*" << "\n"
        arr.each do |i|
            iol << "#{i.join(',')}\n"
        end
        iol << "max,#{to_n_point_float(t15/total.to_f)*100}%"
    }

    write_pie(arr[0..4],0,1,"w_t#{n}_2",true,$color[n])
    write_map3(arr,0,1,"w_t#{n}_1",c,$color[n])
end


def lxtj(recs_org)
    #年份0  季度1  企业2  品牌3  车型4  排量5  原城市6 流向城市7    车龄年8 数量9
    k1 = []
    v1 = []
    k2 = []
    v2 = []
    k3 = []
    v3 = []

    $cities.each do |c|
        k1<< "'"+c+"'"  #本地
        k2<< "'"+c+"'"  #流出
        k3<< "'"+c+"'"  #流入

        s1 = 0
        s2 = 0
        s3 = 0

        recs_org.each do |r|
            u6 = to_utf8(r[6]) 
            u7 = to_utf8(r[7])

            if u6 == c && r[7] == r[6]
                s1 += r[9].to_i
            end 
            if u6 == c && r[7] != r[6]
                s2 += r[9].to_i
            end
            if u7 == c && r[7] != r[6]
                s3 += r[9].to_i
            end
        end

        v1 << s1
        v2 << s2
        v3 << s3
    end

    #pp k1,v1,v2,v3
    #exit


    head = "地区,外迁量O,流入量I,本地过户量L,总交易量Q(O+I+L）,外迁率KO（O/Q）,本地过户率KL（L/Q）,外迁值VO(KO*O)的平方根,外迁指数IO=VO/VOmax,本地交易值VL(KL*L)的平方根,本地交易指数IL=VL/Vlmax"

    vo_arr = []
    vl_arr = []

    vomax=0
    vlmax=0

    $cities.each do |c|
        t = k2.index("'"+c+"'")
        o = (t ? v2[t] : 0).to_i
        
        t = k3.index("'"+c+"'")
        i = (t ? v3[t] : 0).to_i

        t = k1.index("'"+c+"'")
        l = (t ? v1[t] : 0).to_i

        q = o+i+l

        begin
            ko = to_n_point_float(o.to_f/q)
        rescue
            ko = 0
        end

        begin
            kl = to_n_point_float(l.to_f/q)
        rescue
            kl = 0
        end
        vo = Math.sqrt(ko*o)
        vl = Math.sqrt(kl*l)
        vo_arr << vo
        vl_arr << vl
    end

    vomax=vo_arr.max
    vlmax=vl_arr.max

    recs = []

    File.open('csv/流向统计_out.csv', "w",:encoding=>"gbk") { |iol|  
        iol << head << "\n"
        $cities.each do |c|
            t = k2.index("'"+c+"'")
            o = (t ? v2[t] : 0).to_i
            
            #pp k2[0]
            #pp c

            #pp a
            #pp t
            
            t = k3.index("'"+c+"'")
            i = (t ? v3[t] : 0).to_i

            t = k1.index("'"+c+"'")
            l = (t ? v1[t] : 0).to_i

            q = o+i+l

            begin
                ko = to_n_point_float(o.to_f/q)
            rescue
                ko = 0
            end

            begin
                kl = to_n_point_float(l.to_f/q)
            rescue
                kl = 0
            end

            vo = Math.sqrt(ko*o)
            vl = Math.sqrt(kl*l)

    #head = "地区0,外迁量O1,流入量I2,本地过户量L3,总交易量Q(O+I+L）4,外迁率KO（O/Q）5,本地过户率KL（L/Q）6,外迁值VO(KO*O)的平方根7,外迁指数IO=VO/VOmax8,本地交易值VL(KL*L)的平方根9,本地交易指数IL=VL/Vlmax10"

            vo = to_n_point_float(vo)
            io = to_n_point_float(vo/vomax)
            vl = to_n_point_float(vl)
            il = to_n_point_float(vl/vlmax)

            iol << "#{c},#{o},#{i},#{l},#{q},#{ko},#{kl},#{vo},#{io},#{vl},#{il}\n"
            recs << [c,o,i,l,q,ko,kl,vo,io,vl,il]
        end
    }


    # "地区 本地过户率KL 本地交易指数IL  本地过户量L** "  => 本地交易TOP50城市
    recs = recs.sort_by { |a| -a[3]  }  #本地过户量L

    ttt = []
    File.open('csv/本地交易TOP50城市_out.csv', "w",:encoding=>"gbk") { |iol|  
        iol << "地区,本地过户率KL,本地交易指数IL,本地过户量L*" << "\n"
        (0...50).each do |i|
            t = recs[i]
            ttt << [t[0],t[6],t[10],t[3]]
            iol << "#{t[0]},#{t[6]},#{t[10]},#{t[3]}\n"
        end
    }


    #write_map(recs,0,3,'bd_top50')
    write_buble(ttt,0,[1,2,3],'bd_top50','#2e4e7e','#2e4e7e')


    # 地区  外迁率vo 外迁指数io    外迁量o** => 外迁TOP50城市

    recs = recs.sort_by { |a| -a[1]  }  #外迁量o**

    File.open('csv/外迁TOP50城市_out.csv', "w",:encoding=>"gbk") { |iol|  
        iol << "地区,外迁率vo,外迁指数io,外迁量o*" << "\n"
        (0...50).each do |i|
            t = recs[i]
            iol << "#{t[0]},#{t[7]},#{t[8]},#{t[1]}\n"
        end
    }

    write_map(recs,0,1,'w_top50','#9d2933')

    #五个城市是 recs[0..4]
    #puts recs[0..4].join(',')


    (0..4).each do |i|
        puts "processing #{i}...."
        sum_org_waiqian(recs[i][0],recs_org,$cities,i+1)
    end
end

lxtj(recs)
#车龄分布_out.csv

def clfb(recs_org)
    #1-2年   198
    k = []
    v = []
    sum = 0

    h = recs_org.map { |r| r[-2] }.uniq.sort { |a, b| a.to_i <=> b.to_i }
    #pp h

    h.each do |r|
        k << "'"+ r +"'"
        a1 = 0
        recs_org.each { |e|
            #pp e[-2],r

            a1 += e[-1].to_i if e[-2] == r
        }
        v << a1
        sum += a1
    end

    v1 = v.map { |e|  to_n_point_float(e.to_f*100/sum,2) }

    #pp v1

    #puts k.join(',')
    #puts v1.join(',')
    #pp k
    #pp v

    data = IO.read('../template/bar.template',:encoding=>"utf-8")
    #data.gsub!(/PARAM0/,"[#{to_utf8(k.join(','))}]")
    #data.gsub!(/PARAM1/,"[#{v1.join(',')}]")

    data.gsub!(/PARAM0/,'#2e4e7e') #color

    data.gsub!(/PARAM1/,"'1年','2年','3年','4年','5年','6年','7年','8年','9年','10年','11年','12年','13年','14年','15年','15年以上'") #'1年','2年' xaxis

    data.gsub!(/PARAM2/,'75%') #80%
    data.gsub!(/PARAM3/,"#{v1.join(',')}") # 1,2,3



    #puts data

    IO.write('../../server/public/my_js/clfb.js',data,:encoding=>"utf-8")

    head = "上牌年限,各年份上牌比例"
    File.open('csv/车龄发布_out.csv', "w",:encoding=>"gbk") { |io|  
        io << head << "\n"
        str = ''
        max = 0
        (0...k.length).each do |i|
            io << "#{k[i][1..-2]},#{v1[i]}%\n"
            if v1[i].to_f > max
                str = "#{k[i][1..-2]},#{v1[i]}%\n"
                max =  v1[i].to_f
            end
        end

        io << "max,#{str}"
    }

end

clfb(recs)

#排量分布_out.csv

def plfb(recs_org)
    k1 = []
    v1 = []
    k2 = []
    v2 = []

    h = recs_org.map { |r| r[5] }.uniq.sort { |a, b| a.to_f <=> b.to_f }

    h = h - [to_gbk('未知')]
    #pp h


    h.each do |c|
        k1<< "'"+c+"'"  #外迁
        k2<< "'"+c+"'"  #本地

        a1 = 0
        a2 = 0
        recs_org.each { |e|
            a1 += e[-1].to_i if e[5] == c && e[6] != e[7]
            a2 += e[-1].to_i if e[5] == c && e[6] == e[7]
        }
        v1 << a1
        v2 << a2
    end


    #puts k1.join(',')
    #puts v1.join(',')
    #puts k2.join(',')
    #puts v2.join(',')
    #pp k
    #pp v
    k3 = k1 

    k2.each do |t|
        k3 << t unless k1.include?(t)
    end

    k3 = k3.sort {
        |a,b| a <=> b
    }

    #[{value:5122, name:'1.5L'}, {value:29071, name:'1.6L'}]

    str1 = ''
    str2 = ''

    (0..v1.length-1).each do |i|
        str1 += '{value:' + v1[i].to_s + ",name:" + to_utf8(k1[i])  + "},"
    end

    (0..v2.length-1).each do |i|
        str2 += '{value:' + v2[i].to_s + ",name:" + to_utf8(k2[i])  + "},"
    end

    data = IO.read('../template/ring.template',:encoding=>"utf-8")
    data.gsub!(/PARAM0/,"[#{to_utf8(k3.join(','))}]")
    data.gsub!(/PARAM1/,"[#{str1}]")
    data.gsub!(/PARAM2/,"[#{str2}]")


    #puts data

    IO.write('../../server/public/my_js/plfb.js',data,:encoding=>"utf-8")


    head = "排量,本地过户量,外迁过户量"
    File.open('csv/排量发布_out.csv', "w",:encoding=>"gbk") { |io|  
        io << head << "\n"
        (0...k3.length).each do |i|
            t = k2.index(k3[i])
            #pp t
            #pp v2
            a = t ? v2[t] : 0
            #pp t
            #pp i
            #pp k3[i]
            t = k1.index(k3[i])
            b = t ? v1[t] : 0 

            io << "#{k3[i][1..-2]},#{a},#{b}\n"
        end
    }
end

plfb(recs)
