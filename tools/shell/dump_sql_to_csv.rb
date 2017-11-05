# -*- coding: UTF-8 -*-

require 'rubygems'
require 'mysql2'
require 'pp'
require 'iconv'


@adapter= "mysql2"
@host= "172.16.0.25"
@database= "db_appServer"
@username= ""
@password= ""
@port = 3306

def get_sql(sql_file,extra)
	sql = IO.read(sql_file)

	#replace
	i = 0
	extra.each do |item|
		sql.gsub!(/PARAM#{i}/,item)
		i += 1
	end

	#$stderr.puts sql
	puts "---"*20
	sql
end

def get_n(sql)
	"SELECT count(*) from (#{sql}) as bbbb" 
end

def build_sql(sql,offset,n)
	sql = "SELECT * from (#{sql}) as bbbb limit #{offset},#{n} "

	sql
end

def dump_sql_result(client,sql)
	conv = Iconv.new("GBK//IGNORE","utf-8//IGNORE")  

	res = client.query(sql)
	res.each do |hash|
		#puts hash
	 # begin
		puts hash.map { |k,v| "#{conv.iconv(k.to_s.gsub(/,/,'，').gsub(/\n/,''))}" }.join(",") if $first == 0
		puts hash.map { |k,v| "#{conv.iconv(v.to_s.gsub(/,/,'，').gsub(/\n/,''))}" }.join(",")
		$first = 1
	 # rescue
	 # 	next
	 # end
	end
end

def dump_sql_to_csv(client,sql,output_csv_file,extra)
	n = client.query(get_n(sql))

	n.each do |hash|
		n = hash.values[0].to_i
	end

	pp n

	fn = output_csv_file

	$stdout = File.open(fn, "w")

	offset = 0
	$first = 0
	step = 5000

	while offset  < n do
		dump_sql_result(client,build_sql(sql,offset,step))
		$stderr.puts "#{n},#{offset},#{step}"
		offset += step 
	end

	$stdout.flush
	$stdout.close

	# 取回输出方法的默认输出对象。
	$stdout = STDOUT

	#puts `ruby /data/scripts/mail.rb  mail@a.com '测试数据' '详见附件' #{fn}`
end

unless ARGV[3]
	puts "host db_name sql_file output_csv_file"
	exit
end

host = ARGV[0]
@port = ARGV[1].to_i 
database = ARGV[2]
sql_file = ARGV[3]
output_csv_file = ARGV[4]
extra = ARGV[5..-1]

puts "extra"

pp extra
client = Mysql2::Client.new(:host => host, :username => @username,:password=>@password,:database=>database,:port => @port)
sql = get_sql(sql_file,extra)
puts sql

dump_sql_to_csv(client,sql,output_csv_file,extra)


