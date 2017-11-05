
    //alert('cool2');
    myChart.setOption(option)
    var img = myChart.getDataURL();
    //alert(img);


    //$('#img1').attr('src', img); //设置重新展现出来！
    //alert($("#img1").attr('src'));

    //alert('cool!');
    if (img) {　　
      $.ajax({　　　　
        type: "post",
        data: {　　　　　　
          baseimg: img,
          file_name: file_name
        },
        url: 'http://127.0.0.1:4567',
        async: true,
        success: function(data) {　　　　　　
          console.log(img);　　　　
        },
        error: function(err) {　　　　　　
          console.log('图片保存失败');　　　　　　
          alert('图片保存失败');　　　　
        }　　
      });
    }
 