require 'win32ole'     
word = WIN32OLE.new('Word.Application')     
word.visible=true #是否打开文件     
puts word.Documents.methods
#.open('C:\Users\williamchen\Documents\GitHub\echarts3_practice\tools\office\template.docx')   
for i in(0..100)       
    word.Selection.Font.Size=12       
    word.Selection.Font.ColorIndex = 2       
    word.Selection.TypeText("Word with Ruby \n")     
end     
#word.DefaultSaveFormat     
#word.Documents.close() 