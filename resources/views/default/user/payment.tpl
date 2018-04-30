{include file='user/main.tpl'}

<div class="content-wrapper">
    <section class="content-header">
        <h1>
            购买套餐
            <small>Payment</small>
        </h1>
    </section>

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
            <div class="col-xs-12 col-sm-10 col-md-8">
                <div class="box box-primary">
                    <div class="box-header">
                        <h5 class="box-title">第一步：选择套餐并提交</h5>
                        <p></p>
                        <p></p>
                    </div>

                    <div class="box-body table-responsive no-padding">
                        <div id="msg-success" class="alert alert-info alert-dismissable" style="display:none">
                            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                            <h4>
                                <i class="icon fa fa-info"></i> Ok!</h4>

                            <p id="msg-success-p"></p>
                        </div>
                        <table class="table table-hover">
                            <tr>
                                <td></td>
                                <td>套餐</td>
                                <td>价格</td>
                                <td>赠送</td>
                                <td>设备数量</td>
                                <td>流量限制</td>
                                
                                <td>
                                    <td>
                            </tr>
                            {foreach $plans as $plan}
                            <tr>
                                <td></td>
                                <td>{$plan->plan_name}</td>
                                <td>{$plan->plan_price}</td>
                                <td>{$plan->plan_detail}</td>
                                <td>{$plan->plan_client}</td>
                                <td>{$plan->plan_flow}</td>
                                
                                <td>
                                    <a class="btn btn-primary btn-sm" href="/user/payment/{$plan->id}">提交订单</a>
                                </td>
                            </tr>
                            {/foreach}
                        </table>
                        <!--<div class="form-horizontal">

                            <div id="msg-success" class="alert alert-info alert-dismissable" style="display:none">
                                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                                <h4>
                                    <i class="icon fa fa-info"></i> Ok!</h4>

                                <p id="msg-success-p"></p>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-3 control-label">套餐类型</label>

                                <div class="col-sm-9">
                                    <select class="form-control" id="paymentType" style="width: 60%;">
                                        <option value="1month">包月 15</option>
                                        <option value="6month">半年 60元</option>
                                        <option value="1year">一年 120元</option>
                                        <option value="2year">两年 199元</option>
                                    </select>
                                </div>
                            </div>
                        </div>-->
                    </div>

                    <div class="box-footer">
                        <div class="row">
                            <div class="col-xs-12 col-sm-10 col-md-8 text-center">
                                <!-- <a id="payment" class="btn btn-primary" style="width: 20%;">提交</a> -->
                                <a class="btn btn-primary" href="/user/order">查看我的订单</a>
                            </div>
                        </div>

                    </div>

                </div>
                <!-- /.box -->
            </div>
        </div>
        <div class="row">
            <div class="col-xs-12 col-sm-10 col-md-8">
                <div class="box box-primary">
                    <div class="box-header">
                        <p class="box-title">第二步：转账后联系微信号hushuanq 等待开通</p>
                        <p>因为特殊原因，现在不支持自动充值到帐</p>
                    </div>

                    <div class="box-body">
                        <div class="row">
                            <div class="col-xs-6">
                                <img src="/downloads/alipay.jpg" class="img-rounded img-responsive" alt="Cinque Terre">
                            </div>
                            <div class="col-xs-6">
                                <img src="/downloads/wepay.jpg" class="img-rounded img-responsive" alt="Cinque Terre">
                            </div>
                        </div>
                    </div>

                    <div class="box-footer">
                        <!-- <button type="submit" id="payment" class="btn btn-primary">提交</button> -->
                    </div>

                </div>
                <!-- /.box -->
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
        $("#payment").click(function () {
            $.ajax({
                type: "POST",
                url: "payment",
                dataType: "json",
                data: {
                    paymentType: $("#paymentType").val(),
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
</script> {include file='user/footer.tpl'}