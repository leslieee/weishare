{include file='admin/main.tpl'}

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1>
            用户公告
            <small>userInfo</small>
        </h1>
    </section>

    <!-- Main content -->
    <section class="content">
        <div class="row">
            <div class="col-xs-12">
                <div class="box">
                    <div class="box-body table-responsive no-padding">
                        {$userInfos->render()}
                        <table class="table table-hover">
                            <tr>
                                <th>id</th>
                                <th>内容</th>
                                <th>创建时间</th>
                                <th>是否隐藏</th>
                            </tr>
                            {foreach $userInfos as $userInfo}
                            <tr>
                                <td>#{$userInfo->id}</td>
                                <td>{$userInfo->content}</td>
                                <td>{$userInfo->created_at}</td>
                                {if $userInfo->hidden==0}
                                    <td>已显示</td>
                                {else}
                                    <td>已隐藏</td>
                                {/if}                         
                                <td>
                                    {if $userInfo->hidden==0}
                                        <a class="btn btn-info btn-sm" href="/admin/userinfo/{$userInfo->id}/hidden">隐藏</a>
                                    {else}
                                        <a class="btn btn-info btn-sm" href="/admin/userinfo/{$userInfo->id}/hidden">显示</a>
                                    {/if}
                                    <a class="btn btn-info btn-sm" href="/admin/userinfo/{$userInfo->id}/edit">编辑</a>
                                    <a class="btn btn-danger btn-sm" href="/admin/userinfo/{$userInfo->id}/delete">删除</a>
                                </td>
                            </tr>
                            {/foreach}
                        </table>
                        {$userInfos->render()}
                    </div><!-- /.box-body -->
                    <div class="box-footer text-center">
                        <a class="btn btn-primary" href="/admin/userinfo/new">创建公告</a>
                    </div>
                </div><!-- /.box -->
            </div>
        </div>

    </section><!-- /.content -->
</div><!-- /.content-wrapper -->

{include file='admin/footer.tpl'}