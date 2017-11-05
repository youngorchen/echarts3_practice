require 'rubygems'
require 'sinatra'
require 'open-uri'
require "base64" 

set :public_folder, './public'

  get '/' do
         '----------'
  end

  post '/' do
    puts params.to_s
    b = /(?<=base64,)[\S|\s]+/.match(params['baseimg'])
    #puts   b  
    File.open('./public/'+ params['file_name'],"wb") {|f|
        f.write(Base64.decode64(b.to_s))  
    }
    'done!' #+ params.to_s

  end             
