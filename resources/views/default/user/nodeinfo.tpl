{include file='user/main.tpl'}

<div class="content-wrapper">
    <section class="content-header">
        <h1>
            节点列表
            <small>Node List</small>
        </h1>
    </section>
    <!-- Main content -->
    <section class="content">
        <!-- START PROGRESS BARS -->

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
            <div class="col-md-12">
                <div class="callout callout-warning">
                    <h4>注意!</h4>
                    <p>配置文件以及二维码请勿泄露！</p>
                    <p>安卓和Mac客户端可以直接点击一键导入配置(客户端安装并开启的情况下)</p>
                    <p>windows客户端可以右键点击屏幕右下角状态栏的小飞机图标->服务器->扫描屏幕上的二维码(确保小飞机图标->服务器->勾选为最新添加的服务器), 然后右键点击小飞机图标->启动系统代理, 系统代理模式选择全局模式.
                        配置成功</p>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-6">
                <a class="btn btn-primary btn-flat" href="{$ssqr}">点击一键导入配置</a>
            </div>
        </div>

        <div class="row">
            <div class="col-md-6">
                <div class="box box-solid">
                    <div class="box-header">
                        <i class="fa fa-code"></i>

                        <h3 class="box-title">配置Json</h3>
                    </div>
                    <!-- /.box-header -->
                    <div class="box-body">
                        <!--<textarea class="form-control" rows="6">{$json_show}</textarea>-->
                        <p>服务器地址: {$json_show['server']}</p>
                        <p>服务器端口: {$json_show['server_port']}</p>
                        <p>服务器密码: {$json_show['password']}</p>
                        <p>加密方式: {$json_show['method']}</p>
                    </div>
                    <!-- /.box-body -->
                </div>
                <!-- /.box -->
                <div class="box box-solid">
                    <div class="box-header">
                        <i class="fa fa-code"></i>

                        <h3 class="box-title">配置地址</h3>
                    </div>
                    <!-- /.box-header -->
                    <div class="box-body">
                        <div class="input-group">
                            <input type="text" id="ss-qr-text" class="form-control" value="{$ssqr}">
                            <div class="input-group-btn">
                                <a class="btn btn-primary btn-flat" href="{$ssqr}">></a>
                            </div>
                        </div>
                    </div>
                    <!-- /.box-body -->
                </div>
                <!-- /.box -->
            </div>
            <!-- /.col (right) -->

            <div class="col-md-6">
                <div class="box box-solid">
                    <div class="box-header">
                        <i class="fa fa-qrcode"></i>

                        <h3 class="box-title">配置二维码</h3>
                    </div>
                    <!-- /.box-header -->
                    <div class="box-body">
                        <div class="text-center">
                            <div id="ss-qr"></div>
                        </div>
                    </div>
                    <!-- /.box-body -->
                </div>
                <!-- /.box -->
            </div>
            <!-- /.col (right) -->
        </div>
        <!--<div class="row">
            <div class="col-md-12">
                <div class="box box-solid">
                    <div class="box-header">
                        <i class="fa fa-qrcode"></i>

                        <h3 class="box-title">Surge配置</h3>
                    </div>
                    <div class="box-body">
                        <div class="row">
                            <div class="col-md-4">
                                <h4>Surge使用步骤</h4>

                                <p>基础配置只需要做一次：
                                <ol>
                                    <li>打开 Surge ，点击右上角“Edit”，点击“Download Configuration from URL”</li>
                                    <li>输入基础配置的地址（或扫描二维码得到地址，复制后粘贴进来），点击“OK”</li>
                                    <li><b>注意：</b>基础配置不要改名，不可以直接启用。</li>
                                </ol>
                                </p>
                                <p>代理配置需要根据不同的节点进行添加：
                                <ol>
                                    <li>点击“New Empty Configuration”</li>
                                    <li>在“NAME”里面输入一个配置文件的名称</li>
                                    <li>点击下方“Edit in Text Mode”</li>
                                    <li>输入代理配置的全部文字（或扫描二维码得到配置，复制后粘贴进来），点击“OK”</li>
                                    <li>直接启用代理配置即可科学上网。</li>
                                </ol>
                                </p>
                            </div>
                            <div class="col-md-4">
                                <h4>基础配置</h4>

                                <div class="text-center">
                                    <div id="surge-base-qr"></div>
                                </div>
                                <textarea id="surge-base-text" class="form-control" rows="6">{$surge_base}</textarea>
                            </div>
                            <div class="col-md-4">
                                <h4>代理配置</h4>

                                <div class="text-center">
                                    <div id="surge-proxy-qr"></div>
                                </div>
                                <textarea id="surge-proxy-text" class="form-control" rows="6">{$surge_proxy}</textarea>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>-->
        <!-- /.row -->
        <!-- END PROGRESS BARS -->
        <script src=" /assets/public/js/jquery.qrcode.min.js "></script>
        <script>
            var text_qrcode = jQuery('#ss-qr-text').val();
            jQuery('#ss-qr').qrcode({
                "text": text_qrcode
            });
            var text_surge_base = jQuery('#surge-base-text').val();
            jQuery('#surge-base-qr').qrcode({
                "text": text_surge_base
            });
            var text_surge_proxy = jQuery('#surge-proxy-text').text();
            jQuery('#surge-proxy-qr').qrcode({
                "text": text_surge_proxy
            });
        </script>
    </section>
    <!-- /.content -->
</div>
<!-- /.content-wrapper -->
{include file='user/footer.tpl'}