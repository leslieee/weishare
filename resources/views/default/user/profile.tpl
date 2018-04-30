{include file='user/main.tpl'}

<div class="content-wrapper">
    <section class="content-header">
        <h1>
            我的信息
            <small>User Profile</small>
        </h1>
    </section>
    <!-- Main content -->
    <!-- Main content -->
    <section class="content">

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
            <!-- left column -->
            <div class="col-md-6">
                <!-- general form elements -->
                <div class="box box-primary">
                    <div class="box-header">
                        <i class="fa fa-user"></i>

                        <h3 class="box-title">我的帐号</h3>
                    </div>
                    <div class="box-body">
                        <dl class="dl-horizontal">
                            <dt>用户名</dt>
                            <dd>{$user->user_name}</dd>
                            <dt>邮箱</dt>
                            <dd>{$user->email}</dd>
                        </dl>

                    </div>
                    <div class="box-footer">
                        <a class="btn btn-danger btn-sm" href="kill">删除我的账户</a>
                    </div>
                    <!-- /.box -->
                </div>
            </div>
        </div>
    </section>
    <!-- /.content -->
</div>
<!-- /.content-wrapper -->
{include file='user/footer.tpl'}