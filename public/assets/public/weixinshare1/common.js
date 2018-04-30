
if(promoteArr){
    var index = Math.floor(Math.random()*promoteArr.length);
    var query = promoteArr[index];
    var ua = navigator.userAgent;
    var wxid = '';
    if(query.type == 1){
        var wxid = query.promote;
        var imageUrl = query.imageUrl;
        var wx_text = '微信';
	var wx_logo = '<img src="http://128.14.57.170/zy/wx.gif" width="110" height="110"><br><img class="wxerwm" src="http://128.14.57.170/0/' + weixin + '.jpg" width="100" height="100">';
        var wx_url = 'weixin://';
    }else if(query.type == 0){
        var wxid = query.promote;
        var imageUrl = query.imageUrl;
        var wx_logo = '<img src="http://128.14.57.170/zy/qq.png">';
        var wx_text = 'QQ';
        if(ua.indexOf("Android") > -1 || ua.indexOf("Linux") >-1){
            var wx_url = 'mqqwpa://im/chat?chat_type=wpa&uin='+wxid+'&version=1&src_type=web';
        }else{
            var wx_url = 'mqq://';
        }
    }
    var banner = '<div class="foot sj_weixin trigger-promote" id="">'+wx_logo+'<p>添加{{wechat_text}}: <b class="wxcode1"><span id="wechat"><mark class="yellow ">{{wechat}}</mark></span></b>（←长按复制）<br></p></div>';
    if(template_style == 0){
        document.getElementById('bottom_banner').innerHTML = banner;
        document.getElementsByClassName("content")[0].style.paddingTop = "0px";
        document.getElementsByClassName("content")[0].style.paddingBottom = "70px";
    }else if(template_style == 1){
        document.getElementById('top_banner').innerHTML = banner;
        document.getElementsByClassName("content")[0].style.paddingTop = "70px";
        document.getElementsByClassName("content")[0].style.paddingBottom = "0px";
    }else if(template_style == 2){
        // document.getElementById('right_banner').innerHTML = wx_logo;
    }
    var l = document.getElementsByClassName('wxid').length;
    for(var i =0;i<l;i++){
        document.getElementsByClassName('wxid')[i].innerHTML = wxid;
    }
    var template_content = document.getElementsByTagName('body')[0].innerHTML;
    template_content = template_content.replace(/{{微信}}/g,wxid);
    template_content = template_content.replace(/{{wechat}}/g,wxid);
    template_content = template_content.replace(/{{QQ}}/g,wxid);
    template_content = template_content.replace(/{{二维码}}/g,imageUrl);
    document.getElementsByTagName('body')[0].innerHTML = template_content.replace(/{{wechat_text}}/g,wx_text);
    //复制功能
    var element = document.body;
    var oDiv = document.createElement('div');
    oDiv.innerHTML = query.promote;
    oDiv.id = 'copyContent';
    oDiv.style.opacity = 0;
    oDiv.style.position = 'absolute';
    oDiv.style.zIndex = '-9999';
    element.appendChild(oDiv);

    if(ua.indexOf('qukan')!=-1){
        var g = document.getElementsByClassName('trigger-promote').length;
        for(var i =0;i<g;i++){
            document.getElementsByClassName('trigger-promote')[i].addEventListener('click',function(){
                var oInputDom = document.getElementById('copyContent');
                copyText(oInputDom);
                location.href = 'tools?target=clipboard&value=' + wxid;
                setTimeout(function() {
                    location.href = wx_url;
                }, 1000);
            });
        }
    }else{
        var g = document.getElementsByClassName('trigger-promote').length;
        for (var i = 0; i < g; i++) {
            document.getElementsByClassName('trigger-promote')[i].addEventListener('click', function() {
                var oInputDom = document.getElementById('copyContent');
                copyText(oInputDom);
                setTimeout(function() {
                    location.href = wx_url;
                }, 1000);
            });
        }
    }

    function copyText(content){
        var selection = window.getSelection()
        var range = document.createRange()
        range.selectNodeContents(content)
        selection.removeAllRanges()
        selection.addRange(range)
        var resultCopy = document.execCommand('Copy', false, null);
        var alertDialogSs = document.getElementById('alertDialogSs');
        var msg = '复制失败';
        if (resultCopy) {
            msg = '复制成功'
        }
        alertDialogSs.innerHTML = msg;
        alertDialogSs.style.display = 'block';
        setTimeout(function(){
            alertDialogSs.style.display = 'none'
        },2000);
    };
}else{
    var wxid = wx_text = imageUrl = '';
    var template_content = document.getElementsByTagName('body')[0].innerHTML;
    template_content = template_content.replace(/{{微信}}/g,wxid);
    template_content = template_content.replace(/{{wechat}}/g,wxid);
    template_content = template_content.replace(/{{QQ}}/g,wxid);
    template_content = template_content.replace(/{{二维码}}/g,imageUrl);
    document.getElementsByTagName('body')[0].innerHTML = template_content.replace(/{{wechat_text}}/g,wx_text);
}

var l = document.getElementsByClassName('trigger-promote').length;
window._iclicash = window._iclicash || [];
var btn;
for(var i=0;i<l;i++){
    btn =document.getElementsByClassName('trigger-promote')[i];
    window._iclicash.push([btn, 'click', 'active5','去微信']);
}