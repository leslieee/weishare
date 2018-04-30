{include file='user/main.tpl'}

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1>
            邀请
            <small>Invite</small>
        </h1>
    </section>

    <!-- Main content -->
    <!-- Main content -->
    <section class="content">
        <div class="row">
            <div class="col-sm-12">
                <div id="msg-error" class="alert alert-warning alert-dismissable" style="display:none">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    <h4>
                        <i class="icon fa fa-warning"></i> 出错了!</h4>

                    <p id="msg-error-p"></p>
                </div>
            </div>
        </div>

        <!-- <div class="row">
            <div class="col-md-8">
                <button id="getclient" class="btn btn-primary">获取客户端</button>
                <button id="getconfig" class="btn btn-primary">获取配置</button>
                <button id="nodelist" class="btn btn-primary">节点列表</button>
                <button id="trafficrecord" class="btn btn-primary">流量记录</button>
                <button id="changeinfo" class="btn btn-primary">修改资料</button>
                <button id="invitefriend" class="btn btn-primary">邀请好友</button>
            </div>
        </div> -->

        <div class="row">
            <div class="col-md-6">
                <div class="callout callout-warning">
                    <p>邀请有记录, 虚假邀请会面临封号</p>
                </div>
            </div>
        </div>


        <div class="row">
            <!-- left column -->
            <div class="col-md-6">
                <!-- general form elements -->
                <div class="box box-primary">
                    <div class="box-header">
                        <i class="fa fa-rocket"></i>

                        <h3 class="box-title">邀请</h3>
                    </div>
                    <!-- /.box-header -->
                    <div class="box-body">
                        <button id="invite" class="btn btn-sm btn-info">生成我的邀请码</button>
                    </div>
                    <!-- /.box -->
                    <div class="box-header">
                        <h3 class="box-title">我的邀请码</h3>
                    </div>
                    <!-- /.box-header -->
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>###</th>
                                    <th>邀请码(点右键复制链接)</th>
                                    <th>状态</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach $codes as $code}
                                <tr>
                                    <td>
                                        <b>{$code->id}</b>
                                    </td>
                                    <td>
                                        <a href="/auth/register?code={$code->code}" target="_blank">{$code->code}</a>
                                    </td>
                                    <td>可用</td>
                                </tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- /.content -->
</div>
<!-- /.content-wrapper -->

<script>
    $(document).ready(function () {
        $("#invite").click(function () {
            $.ajax({
                type: "POST",
                url: "/user/invite",
                dataType: "json",
                success: function (data) {
                    window.location.reload();
                },
                error: function (jqXHR) {
                    alert("发生错误：" + jqXHR.status);
                }
            })
        })
    })

</script> {include file='user/footer.tpl'}