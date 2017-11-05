<?php

include("test.html");

if($action = "save"){

　　$picInfo = $_POST['baseimg'];

　　$streamFileRand = date('YmdHis').rand(1000,9999); //图片名

　　$picType ='.png';//图片后缀

　　$streamFilename = "/www/echarts/".$streamFileRand .$picType; //图片保存地址

　　preg_match('/(?<=base64,)[\S|\s]+/',$picInfo,$picInfoW);//处理base64文本

　　file_put_contents($streamFilename,base64_decode($picInfoW[0]));//文件写入

}

