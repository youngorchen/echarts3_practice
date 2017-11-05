-- SQL 0.25 小库，db_sct_vip 
 
select 
    c.city as '城市',
    date(c.input_date) as '首次发布时间',
    b.brand as '标准品牌',s.series as '标准车系',
   
case c.site 
        when 2 then '赶集'
        when 1 then '58同城'
        when 3 then '百姓'
        when 4 then '淘车'
        when 5 then '51汽车'
        when 6 then '第一车网'
        when 7 then '二手车之家'
        when 8 then '华夏二手车'
        when 9 then '搜狐'
        when 11 then '273'
        when 101 then '奔驰'
        when 102 then '奥迪'
        when 103 then '宝马'
        when 104 then '车王'
        when 105 then '澳康达'
        when 106 then '优车诚品'
        when 107 then '人人车'
        when 108 then '卓杰行'
        when 109 then '捷和'
        when 110 then '长安福特'
        when 113 then '一汽大众'
        when 114 then '雷克萨斯'
        when 115 then '东风日产'
        when 116 then '上海通用'
        when 117 then '广汽丰田'
        when 118 then '东风悦达起亚'
        when 119 then '车多多'
        when 120 then '一汽丰田'
        when 121 then '车速'
        when 122 then '米车'
        when 123 then '百优卡'
        when 124 then '优信'
        when 125 then '99好车'
        when 126 then '一汽丰田2'
        when 129 then '宾利4S店' -- 未抓
        when 130 then '保时捷' -- 未抓
        when 131 then '现代首选'
        when 133 then '好车无忧'
        when 134 then '瓜子'
        when 135 then '阳光车网'
        when 136 then '上海通用'
        when 137 then '上海大众汽车' -- \http://www.svwuc.com/p.html
        when 138 then '爱卡二手车' -- \ http://used.xcar.com.cn/search/0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0/
        when 139 then '大搜车' -- \ http://www.souche.com/beijing/list
        when 140 then '车猫' 
        when 141 then '平安好车' 
        when 142 then '广汽本田'
        when 143 then '车101'
        when 144 then '看车网'
        when 145 then '家家好车'
        when 146 then '迈卡易'
        when 147 then '精真估'
        when 148 then '家有好车'
        when 149 then '中古车网'
        when 150 then '武汉国景'
        when 151 then '路虎官网' -- 原第一车网上，已停用
        when 152 then '捷豹官网' -- 原第一车网上，已停用
        when 153 then '神州买卖车'
        when 154 then '中古车网'
        when 155 then '东风日产'
        when 156 then '沃尔沃'
        when 157 then '捷豹官网'
        when 158 then '路虎官网'
        when 160 then '东风本田'
        when 161 then '奥迪2'
        when 10001 then '批车网'

        else cast(concat('未知:',c.site) as char) end as '站点',
m.merchant_name as '成份车商名',
m.source_type as '来源',
m.use_flags as '天眼属性'

    from db_sct_vip.sct_vip_dt_car_info as c
left join db_appServer.def_brand_series_t as bs on bs.id = c.series_id
left join db_appServer.def_brand_info_t as b on b.id = bs.bid
left join db_appServer.def_series_info_t as s on s.id = bs.sid
left join db_sct_vip.def_model_detail as md on md.id = c.model_id
left join db_sct_vip.sct_vip_ft_merchant as m on m.id = c.vip_merchant_id
left join sct_vip_ft_merchant_more as mm on mm.id = m.id 
    where 1 = 1 
    
#    and m.use_flags = 3
    and (m.use_flags = 3 or m.use_flags = 2) 
    and s.series like '%PARAM0%'

 
    and c.input_date>'PARAM1' and c.input_date<'PARAM2'  -- 从本季度前1个月开始到本季度末

    order by input_date desc 
    -- limit 20
    -- into outfile '/tmp/kaiyue2jidu2.xls' -- 从数据库后台导出数据,导出的文件名不能用汉字和括号
    -- CHARACTER SET gbk --  从数据库后台导出数据 admin hope2017

    


