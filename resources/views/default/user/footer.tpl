<script>
    $(document).ready(function () {
        $("#getclient").click(function () {
            window.location.href='/user/getclient';
        })
        $("#getconfig").click(function () {
            window.location.href='/user/node/4';
        })
        $("#nodelist").click(function () {
            window.location.href='/user/node';
        })
        $("#trafficrecord").click(function () {
            window.location.href='/user/trafficlog';
        })
        $("#changeinfo").click(function () {
            window.location.href='/user/edit';
        })
        $("#invitefriend").click(function () {
            window.location.href='/user/invite';
        })
        $("#homepage").click(function () {
            window.location.href='/intro';
        })
    })
</script>

<footer class="main-footer">
    <div align="center">
        {$userFooter}
    </div>
    <div class="pull-right hidden-xs">
        Made with Love
    </div>
    <strong>Copyright &copy; 2016 <a href="#">{$config['appName']}</a> </strong>
    All rights reserved. <!--Powered by <b>ss-panel</b> {$config['version']} --!>| <a href="/tos">服务条款 </a>
</footer>
</div><!-- ./wrapper -->


<!-- Bootstrap 3.3.2 JS -->
<script src="/assets/public/js/bootstrap.min.js" type="text/javascript"></script>
<!-- SlimScroll -->
<script src="/assets/public/plugins/slimScroll/jquery.slimscroll.min.js" type="text/javascript"></script>
<!-- FastClick -->
<script src='/assets/public/plugins/fastclick/fastclick.min.js'></script>
<!-- AdminLTE App -->
<script src="/assets/public/js/app.min.js" type="text/javascript"></script>
<div style="display:none;">
    {$analyticsCode}
</div>
</body>
</html>
