-- SQL 0.25 小库，db_sct_vip 
 
select 
    
    c.input_date as '首次发布时间',
    c.update_date as 'update_date',
    b.brand as '标准品牌',
    s.series as '标准车系',
    c.status as '车源发布状态',
    c.price as '标价'

    from db_sct_vip.sct_vip_dt_car_info as c

left join db_appServer.def_brand_series_t as bs on bs.id = c.series_id
left join db_appServer.def_brand_info_t as b on b.id = bs.bid
left join db_appServer.def_series_info_t as s on s.id = bs.sid
left join db_sct_vip.def_model_detail as md on md.id = c.model_id
left join db_sct_vip.sct_vip_ft_merchant as m on m.id = c.vip_merchant_id
left join sct_vip_ft_merchant_more as mm on mm.id = m.id 
    where 1 = 1 
    
    and c.status = 3 -- 取下线车    
    
    and b.brand like '%别克%'
    and s.series like '%凯越%'
    -- and c.city like '%北京%'
    
    and c.update_date>'2017-04-01 00:00:00' and c.update_date<'2017-07-01 00:00:00' 

    order by update_date desc 
    -- limit 20
    -- into outfile '/tmp/kaiyuezhouzhuantianshu2.xls' -- 从数据库后台导出数据,导出的文件名不能用汉字和括号
    -- CHARACTER SET gbk --  从数据库后台导出数据 admin hope2017