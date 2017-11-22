require 'watir'

#$HIDE_IE = true  #hide windows

b = Watir::Browser.new  :firefox  

Dir.glob("../server/public/*.html").each { | fn |
    #puts fn
    fn = File.basename(fn)
    #puts fn
    fn = "http://127.0.0.1:4567/#{fn}"
    puts fn
    b.goto fn
    sleep 3
}

sleep 10
b.close
#b.goto('http://127.0.0.1:4567/e2.html')

