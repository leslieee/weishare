{include file='admin/main.tpl'}
<script type="text/javascript" src="/assets/public/tinymce/tinymce.min.js"></script>

<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1>
            内容管理
            <small>Admin Control</small>
        </h1>
    </section>

    <!-- Main content -->
    <section class="content">

        <div class="row">
            <div class="col-xs-12">
                <div id="msg-error" class="alert alert-warning alert-dismissable" style="display:none">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    <h4>
                        <i class="icon fa fa-warning"></i> 出错了!</h4>

                    <p id="msg-error-p"></p>
                </div>
                <div id="ss-msg-success" class="alert alert-success alert-dismissable" style="display:none">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    <h4>
                        <i class="icon fa fa-info"></i> 修改成功!</h4>

                    <p id="ss-msg-success-p"></p>
                </div>
            </div>
        </div>
        <div class="row">
            <!-- left column -->
            <div class="col-md-12">
                <!-- general form elements -->
                <div class="box box-primary">

                    <div class="box-body">
                        <div class="form-horizontal">

                            <div id="msg-success" class="alert alert-info alert-dismissable" style="display:none">
                                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                                <h4>
                                    <i class="icon fa fa-info"></i> Ok!</h4>

                                <p id="msg-success-p"></p>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-3 control-label">模板展示微信号</label>

                                <div class="col-sm-3">
                                    <input value="{$wxid}" class="form-control" placeholder="微信号" id="wxid" width="200">
                                    <button type="submit" id="pwd-update" class="btn btn-primary">修改</button>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-3 control-label">微信二维码<br>(仅二维码部分)</label>

                                <div class="col-sm-9">
                                    <form method="post" action="/admin/contentupload" enctype="multipart/form-data">
                                        <input type="file" name="picture">
                                        <button type="submit" class="btn btn-primary"> 提交 </button>
                                    </form>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">当前二维码</label>

                                <div class="col-sm-9">
                                    <img src="/0.png" width="100" height="100">
                                </div>
                            </div>
                        </div>
                        <p>模板内容只能替换文字,修改文字颜色,不能整行删除</p>
                        <p>模板内的微信号需要单独替换</p>
                        <p>插入图片需要先到<a href="/upload">图片上传</a>,上传成功右键到文件名有复制链接地址选项,再在编辑框插入图片,第一个选项输入复制的链接地址还有第三个有大小控制</p>
                        <form method="post" action='/admin/htmlchange'>
                            <textarea rows="15" name='content'></textarea>
                            <input type='submit' class="btn btn-primary" value='保存' />
                        </form>
                    </div>
                    <!-- /.box-body -->

                    <!--<div class="box-footer">
                        <button type="submit" id="pwd-update" class="btn btn-primary">修改</button>
                    </div>-->

                </div>
            </div>
        </div>
    </section>
    <!-- /.content -->
</div>
<!-- /.content-wrapper -->

<script>
    $("#msg-success").hide();
    $("#msg-error").hide();
    $("#ss-msg-success").hide();

</script>

<script>
    $(document).ready(function () {
        $("#pwd-update").click(function () {
            $.ajax({
                type: "POST",
                url: "/admin/content/edit",
                dataType: "json",
                data: {
                    wxid: $("#wxid").val(),
                    // wximg: $("#wximg").val()
                },
                success: function (data) {
                    if (data.ret) {
                        $("#msg-error").hide();
                        $("#msg-success").show();
                        $("#msg-success-p").html(data.msg);
                    } else {
                        $("#msg-error").show();
                        $("#msg-error-p").html(data.msg);
                    }
                },
                error: function (jqXHR) {
                    alert("发生错误：" + jqXHR.status);
                }
            })
        })
    })

</script>

<script type="text/javascript">
tinymce.init({
    selector: "textarea",
    theme: "modern",
    plugins: [
        "advlist autolink lists link image charmap print preview hr anchor pagebreak",
        "searchreplace wordcount visualblocks visualchars code fullscreen",
        "insertdatetime media nonbreaking save table contextmenu directionality",
        "emoticons template paste textcolor colorpicker textpattern"
    ],
    toolbar1: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image",
    toolbar2: "print preview media | forecolor backcolor emoticons",
    image_advtab: true,
    templates: [
        {literal}
        {title: 'Test template 1', content: 'Test 1'},
        {title: 'Test template 2', content: 'Test 2'}
        {/literal}
    ]
 });

function bl(){
    if (isEmpty(tinyMCE.activeEditor)) {
        setTimeout(bl,1000);
    } else {
        tinyMCE.activeEditor.setContent(`{$html}`);
    }
}
setTimeout(bl,1000);

function isEmpty(obj){
    for (var name in obj){
        return false;
    }
    return true;
};

</script>

{include file='admin/footer.tpl'}
