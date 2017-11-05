SELECT year as 年份,
 `quarter` as 季度,
brand_group as 企业,
brand as 品牌,
series as 车型,
displacement as 排量,
initial_city as 原城市,
target_city as 流向城市,
car_age_segment as 车龄年,
quantity as 数量
from ding_xiang_v2 
where year = '2017'
and (`quarter` like '%PARAM1%' or `quarter` like '%PARAM2%')
and series like '%PARAM0%'                          
