require 'win32ole'
require 'date'
require 'rubyexcel'
require '../utils/city'
require 'pp'


def excel
    #file ='c:/temp/15w_1708.xlsx'
    file =Dir.pwd+'./15w_1708.xlsx'

    excel = WIN32OLE.new('Excel.Application')
    excel.visible = true
    excel.WorkBooks.Open(file)
    worksheet = excel.ActiveWorkbook.WorkSheets(1)
end

def word
    file ='c:/temp/t1.docx'

    word = WIN32OLE.new('Word.Application')
    word.visible = true
    worddoc = word.Documents.Open(file)
    
    0.upto(10){
        worddoc.Content.Text="asdf"
    }
    #worksheet = excel.ActiveWorkbook.WorkSheets(1)
end


def outlook
    file ='c:/temp/t1.docx'
    outlook = WIN32OLE.new('Outlook.Application') 
    #outlook.visible = true    
    message = outlook.CreateItem(0)     
    message.Subject = 'Subject line here'    
    message.Body = 'This is the body of your message.'     
    message.To = 'xiaofan2350@yahoo.com.cn'     
    message.Attachments.Add(file, 1)     
    message.Send 
end

#outlook
#excel
#word

def replace_doc(doc, find, repl)
    begin
        word = WIN32OLE.new('Word.Application')
        #word.Visible = true
        doc = word.Documents.Open(doc)

        word.Selection.HomeKey(unit=6)
        finder = word.Selection.Find
        finder.Text = "[#{find}]"

        while word.Selection.Find.Execute
            word.Selection.TypeText(text=repl)
        end

        doc.SaveAs(doc)
        doc.Close
    rescue Exception => e
        puts e.message
        puts "Unable to edit file."
    end
    #doc.sentences.each{ |x| @content = @content + x.text }

end


def gen_word_replace(series,year,quanter)
    file =Dir.pwd+'./template.docx'

    
    top5_bendi = get_excel(Dir.pwd + "/../流向处理/csv/本地交易TOP50城市_out.csv",'A2','A6').join('、')
    top5_waiqian = get_excel(Dir.pwd + "/../流向处理/csv/外迁TOP50城市_out.csv",'A2','A6')
    top5_waiqian_1_5 = get_excel(Dir.pwd + "/../流向处理/csv/外迁TOP1_out.csv",'A2','A6').join('、')
    top5_waiqian_2_5 = get_excel(Dir.pwd + "/../流向处理/csv/外迁TOP2_out.csv",'A2','A6').join('、')
    top5_waiqian_3_5 = get_excel(Dir.pwd + "/../流向处理/csv/外迁TOP3_out.csv",'A2','A6').join('、')
    top5_waiqian_4_5 = get_excel(Dir.pwd + "/../流向处理/csv/外迁TOP4_out.csv",'A2','A6').join('、')
    top5_waiqian_5_5 = get_excel(Dir.pwd + "/../流向处理/csv/外迁TOP5_out.csv",'A2','A6').join('、')
    
    arr1 = get_excel(Dir.pwd + "/../流向处理/csv/in_原始数据.csv",'A2','J10000000')
    
    bak1 = total_bendi = arr1.select {|a| a[6] == a[7]}.inject(0) { 
        |result, element| 
        result + element[-1].to_i }
    #puts "total_bendi=#{total_bendi}"

    total_bendi = total_bendi / 1000 * 1000    

    bak2 = total_waiqian = arr1.select {|a| a[6] != a[7]}.inject(0) { 
        |result, element| 
        result + element[-1].to_i }
    
    total_waiqian = total_waiqian / 1000 * 1000

    #puts total_bendi,total_waiqian

    total1 = change_str(total_bendi + total_waiqian)
    total_bendi = change_str(total_bendi)
    total_waiqian = change_str(total_waiqian)
    #puts "total1=#{total1}",total_bendi,total_waiqian
    #exit

    if total1.to_i == 0 
        total1 = "0(#{bak1+bak2})"
        total_bendi = "0(#{bak1})"
        total_waiqian = "0(#{bak2})"
    end

  begin
    arr = get_excel(Dir.pwd + "/../网络数据/csv/独立车商_out.csv",'A2','A11')
    arr1 = []
    arr.each_with_index do |item, index|
        arr1 << "（#{index+1}）#{item}"
    end
    top10_dlcs = arr1.join('、')
    pp top10_dlcs
    

    arr = get_excel(Dir.pwd + "/../网络数据/csv/4s_out.csv",'A2','A11')
    arr1 = []
    arr.each_with_index do |item, index|
        arr1 << "（#{index+1}）#{item}"
    end
    top10_4s = arr1.join('、')
    pp top10_4s

    top10_4s = 'N/A' if top10_4s == ''
    
  rescue
    puts '*'*800
    #STDIN.gets
  end  
    arr = get_excel(Dir.pwd + "/../流向处理/csv/排量发布_out.csv",'A2','C300')
    pp arr

    bd_max = 0
    wq_max = 0

    plfb_bendi_T = ''
    plfb_waiqian_T = ''

    arr.each_with_index do |item, index|
        if item[1].to_i > bd_max
            bd_max = item[1].to_i
            plfb_bendi_T = item[0]
        end
        if item[2].to_i > wq_max
            wq_max = item[2].to_i
            plfb_waiqian_T = item[0]
        end
    end

    bd_sum = arr.inject(0) { |result, element| 
        puts result
        pp element
        result + element[1].to_i 
    }
    wq_sum = arr.inject(0) { |result, element| result + element[2].to_i }

    puts "bd_max=#{bd_max}"
    puts bd_sum

    plfb_bendi_percent = "#{bd_max*100/bd_sum}%"
    plfb_waiqian_percent = "#{wq_max*100/wq_sum}%"

    puts plfb_bendi_percent

    #pp top10_4s
    #exit

    word = WIN32OLE.new('Word.Application')
    #word.visible = true
    old_doc = word.Documents.Open(file) 

    {
        '[brand]' => series,
        'date' => Date.today.strftime('%B %d, %Y'),
        '[year]' => year,
        '[quanter]' => quanter,
        '[top5_bendi]' => top5_bendi,
        '[top5_waiqian]' => top5_waiqian.join('、'),
        '[top5_waiqian_1]' => top5_waiqian[0],
        '[top5_waiqian_2]' => top5_waiqian[1],
        '[top5_waiqian_3]' => top5_waiqian[2],
        '[top5_waiqian_4]' => top5_waiqian[3],
        '[top5_waiqian_5]' => top5_waiqian[4],
        '[top5_waiqian_1_5]' => top5_waiqian_1_5,
        '[top5_waiqian_2_5]' => top5_waiqian_2_5,
        '[top5_waiqian_3_5]' => top5_waiqian_3_5,
        '[top5_waiqian_4_5]' => top5_waiqian_4_5,
        '[top5_waiqian_5_5]' => top5_waiqian_5_5,
        '[total1]' => total1,
        '[total_bendi]'=> total_bendi,
        '[total_waiqian]'=> total_waiqian,
        '[top10_dlcs]' => top10_dlcs,
        '[top10_4s]' => top10_4s,
        '[plfb_bendi_T]' => plfb_bendi_T,
        '[plfb_bendi_percent]' => plfb_bendi_percent,
        '[plfb_waiqian_T]' => plfb_waiqian_T,
        '[plfb_waiqian_percent]' => plfb_waiqian_percent,

    }.each do |key, value|
      begin
        word.Selection.HomeKey(unit=6) # start at beginning
        find = word.Selection.Find
        find.Text = "#{key}" # text must be in square brackets
        while word.Selection.Find.Execute
            word.Selection.TypeText(text=value) #replace
        end
      rescue Exception => e  
            puts e.message  
            puts e.backtrace.inspect
      end
    end
    #old_doc.Activate
    #old_doc.Content.InsertAfter (" The end.") 
    #puts f = old_doc.Content.Find("凯越")
    #puts f.Replacement("奔驰")
    #puts old_doc.Content.Find.Found 
    #puts old_doc.Content.Find.Execute "2017"
    #puts old_doc.Content.Find.Found 
    #puts old_doc.Content.Text
    #puts old_doc.Selection.Text


    #new_doc = word.documents.Add
    #text = old_doc.selection.
    #0.upto(10){
        #new_doc.Selection.TypeText("Hello Ruby Relatives!")
        #new_doc.Selection.TypeParagraph
    #}
    #old_doc.SaveAs Dir.pwd + "./out.doc"
    #new_doc.close
    old_doc.SaveAs Dir.pwd + "./out.doc"
    old_doc.close
    word.quit
end

pp ARGV
series = ARGV[0]
pp series
gen_word_replace(series,ARGV[1],ARGV[2])
