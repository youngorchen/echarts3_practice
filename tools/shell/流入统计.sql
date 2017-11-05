SELECT target_city,  sum(quantity) as '流入'
 FROM ding_xiang_v2 
where year = 2017 
and (`quarter` like '%PARAM1%' or `quarter` like '%PARAM2%')
and initial_city != target_city
and series like '%PARAM0%'  
GROUP BY target_city
order by target_city
