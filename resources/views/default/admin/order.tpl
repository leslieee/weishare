{include file='admin/main.tpl'}

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1>
            订单列表
            <small>Order List</small>
        </h1>
    </section>

    <!-- Main content -->
    <section class="content">
        <div class="row">
            <div class="col-xs-12">
                <div class="box">
                    <div class="box-body table-responsive no-padding">
                        {$orders->render()}
                        <table class="table table-hover">
                            <tr>
                                <th>id</th>
                                <th>用户id</th>
                                <th>用户名</th>
                                <th>邮箱</th>
                                <th>套餐有效期</th>
                                <th>套餐类型</th>
                                <th>订单状态</th>
                                <th>创建时间</th>
                                <th>备注</th>
                            </tr>
                            {foreach $orders as $order}
                            <tr>
                                <td>#{$order->id}</td>
                                <td>{$order->user_id}</td>
                                <td>{$order->user_name}</td>
                                <td>{$order->user_email}</td>
                                <td>{date('Y-m-d H:i:s', $order->payment_date)}</td>
                                <td>{$order->payment_name}</td>
                                <td>{$order->order_status}</td>
                                <td>{$order->created_time}</td>
                                {if $order->remarks == ""}
                                    <td><a class="btn btn-primary btn-sm" value="{$order->id}" href="/admin/order/{$order->id}/orderremarks">添加备注</a></td>
                                {else}
                                    <td>{$order->remarks}</td>  
                                {/if}                            
                                <td>
                                    
                                    {if $order->getOrderStatus()==0}
                                        <a class="btn btn-primary btn-sm" value="{$order->id}" href="/admin/order/{$order->id}/pass">通过</a>
                                    {else if $order->getOrderStatus()==1}
                                        <a class="btn btn-primary btn-sm" disabled="disabled" value="{$order->id}" href="/admin/order/{$order->id}/pass">已通过</a>
                                    {/if}                                    
                                </td>
                            </tr>
                            {/foreach}
                        </table>
                        {$orders->render()}
                    </div><!-- /.box-body -->
                </div><!-- /.box -->
            </div>
        </div>

    </section><!-- /.content -->
</div><!-- /.content-wrapper -->

{include file='admin/footer.tpl'}