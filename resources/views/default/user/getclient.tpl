{include file='user/main.tpl'}

<div class="content-wrapper">
    <section class="content-header">
        <h1>
            客户端
            <small>Client</small>
        </h1>
    </section>
    <!-- Main content -->
    <!-- Main content -->
    <section class="content">

        <!-- <div class="row">
            <div class="col-md-10">
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
                    <h4>安装步骤</h4>
                    <!--<p>1. 下载客户端</p>
                    <p>2. 点击一键导入配置</p>
                    <p>3. 在客户端内开启服务</p>-->
                    <p>安卓和Mac客户端可以直接点击一键导入配置(客户端安装并开启的情况下)</p>
                    <p>windows客户端需要先打开节点配置页面
                        <a href="/user/node/5">hk1节点配置</a> (确保屏幕上有二维码), 然后打开客户端, 右键点击屏幕右下角状态栏的小飞机图标->服务器->扫描屏幕上的二维码(确保小飞机图标->服务器->勾选为最新添加的服务器),
                        然后右键点击小飞机图标->启动系统代理, 系统代理模式选择全局模式. 配置成功</p>
                    <p>ps: 安装手册包含各平台详细步骤, 支持快速查看.</p>
                    {$msg}
                </div>
            </div>
        </div>

        <div class="row">
            <!-- left column -->
            <div class="col-md-6">
                <div class="box box-primary">
                    <div class="box-header">
                        <i class="fa fa-bullhorn"></i>

                        <h3 class="box-title">客户端下载</h3>
                    </div>
                    <!-- /.box-header -->
                    <div class="box-body">
                        <p>Windows客户端(xp, win7)&nbsp&nbsp
                            <a href="/downloads/Shadowsocks_win_2.5.6.exe">2.5.6经典版</a>
                            <a href="/configclient#win">配置教程</a>
                        </p>
                        <p>Win10用户可以下载新版&nbsp&nbsp
                            <a href="/downloads/Shadowsocks_win_4.0.1.exe">4.0.1新版</a>
                            <a href="/configclient#win">配置教程</a>
                        </p>
                        <p>Mac客户端&nbsp&nbsp
                            <a href="/downloads/ShadowsocksX-2.6.3.dmg">点击下载</a>
                            <a href="/configclient#mac">配置教程</a>
                        </p>
                        <p>Android客户端&nbsp&nbsp
                            <a href="/downloads/com.github.shadowsocks.apk">点击下载</a>
                            <a href="/configclient#android">配置教程</a>
                        </p>
                        <p>iOS用户请在App Store搜索下载"Wingy"&nbsp&nbsp
                            <a href="https://itunes.apple.com/cn/app/wingy-http-s-socks5-proxy-utility/id1178584911?mt=8"
                                target="_blank">点击查看</a>
                            <a href="/configclient#ios">配置教程</a>
                        </p>
                        <p>Wingy国区已下架, 请下载ipa安装包, 用iTunes安装
                            <a href="/downloads/wingy.ipa">点击下载</a>
                        </p>
                        <p>Linux用户请参考安装手册进行安装
                            <a href="/configclient#linux">配置教程</a>
                        </p>
                        <p>安装手册(包含各个平台)&nbsp&nbsp
                            <a href="/downloads/SpeedSS_Installation_Manual.pdf">快速查看</a>&nbsp&nbsp
                            <a href="/downloads/SpeedSS_Installation_Manual.docx">点击下载</a>
                        </p>
                        <p>安装手册配套软件包&nbsp&nbsp
                            <a href="/downloads/SpeedSS_Installation_Manual_Package.zip">点击下载</a>
                        </p>
                    </div>
                    <!-- /.box-body -->
                </div>
                <!-- /.box -->
            </div>
            <!-- /.col (right) -->
        </div>

        <div class="row">
            <div class="col-md-10">
                <a class="btn btn-primary" href="{$hk1}">一键导入hk1香港服务器配置</a>
                <a class="btn btn-primary" href="{$jp1}">一键导入jp1日本服务器配置</a>
                <a class="btn btn-primary" href="{$us1}">一键导入us1美国服务器配置</a>
            </div>
        </div>

    </section>
    <!-- /.content -->
</div>
<!-- /.content-wrapper -->
{include file='user/footer.tpl'}