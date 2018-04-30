{include file='user/main.tpl'}

<div class="content-wrapper">
    <section class="content-header">
        <h1>
            订单列表
            <small>Order List</small>
        </h1>
    </section>

    <section class="content">
        <div class="row">
            <div class="col-xs-12 col-sm-10 col-md-8">
                <div class="box">
                    <div class="box-body table-responsive no-padding">
                        <table class="table table-hover">
                            <tr>
                                <th>id</th>
                                <!--<th>用户id</th>-->
                                <th>套餐类型</th>
                                <th>订单状态</th>
                                <th>用户名</th>
                                <th>邮箱</th>
                                <th>套餐有效期</th>
                                <th>创建时间</th>
                            </tr>
                            {foreach $orders as $order}
                            <tr>
                                <td>#{$order->id}</td>
                                <!--<td>{$order->user_id}</td>-->
                                <td>{$order->payment_name}</td>
                                <td>{$order->order_status}</td>
                                <td>{$order->user_name}</td>
                                <td>{$order->user_email}</td>
                                <td>{date('Y-m-d H:i:s', $order->payment_date)}</td>
                                <td>{$order->created_time}</td>
                            </tr>
                            {/foreach}
                        </table>
                    </div>
                    <div class="box-footer text-center">
                        <a class="btn btn-primary" href="/user/payment">返回</a>
                    </div>
                </div>
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
</div>

{include file='user/footer.tpl'}