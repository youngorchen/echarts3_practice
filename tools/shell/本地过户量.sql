SELECT displacement,  sum(quantity) as '本地过户量'
 FROM ding_xiang_v2 
where year = 2017 
and (`quarter` like '%PARAM1%' or `quarter` like '%PARAM2%')
and initial_city = target_city
and displacement != '未知'
and series like '%PARAM0%'  
GROUP BY displacement
order by displacement