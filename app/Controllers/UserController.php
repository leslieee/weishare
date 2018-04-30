<?php

namespace App\Controllers;

use App\Models\CheckInLog;
use App\Models\InviteCode;
use App\Models\Node;
use App\Models\TrafficLog;
use App\Models\Order;
use App\Models\V2rayNode;
use App\Models\UserInfo;
use App\Models\UserFingerprint;
use App\Models\Plan;
use App\Services\Auth;
use App\Services\Config;
use App\Services\DbConfig;
use App\Utils\Hash;
use App\Utils\Tools;


/**
 *  HomeController
 */
class UserController extends BaseController
{

    private $user;

    public function __construct()
    {
        $this->user = Auth::getUser();
    }

    public function view()
    {
        $userFooter = DbConfig::get('user-footer');
        return parent::view()->assign('userFooter', $userFooter);
    }

    public function index($request, $response, $args)
    {
        $msg = DbConfig::get('user-index');
        if ($msg == null) {
            $msg = "在后台修改用户中心公告...";
        }
        // $v2ray_node_1 = V2rayNode::where("id", 1)->first();
        // $v2ray_node_2 = V2rayNode::where("id", 2)->first();

        $nodes = v2rayNode::all();
        $v2ray_qr_android_array = array();
        $v2ray_qr_ios_array = array();
        foreach ($nodes as $node) {
            // android的二维码
            $ary['add'] = $node->address;
            $ary['ps'] = $node->name;
            $ary['port'] = $node->port;
            $ary['id'] = $this->user->uuid;
            $ary['security'] = $node->security;
            $ary['aid'] = $node->alter_id;
            if ($node->network == "websocket"){
                $ary['net'] = "ws";
            }
            $ary['host'] = $node->path;
            if ($node->tls == "1"){
                $ary['tls'] = "tls";
            }
            $ary['type'] = $node->type;
            $json = json_encode($ary);
            $v2ray_qr_1_android = "vmess://" . base64_encode($json);
            array_push($v2ray_qr_android_array, $v2ray_qr_1_android);

            // iOS的二维码
            $v2ray_qr_1_ios = "vmess://" . base64_encode($node->security . ":" . $this->user->uuid . "@" . $node->address . ":" . $node->port) . "?obfs=" . $node->network . "&path=" . $node->path . "&tls=" .$node->tls;
            array_push($v2ray_qr_ios_array, $v2ray_qr_1_ios);
        }
        
        // 公告信息
        $userInfos = UserInfo::where("hidden", 0)->orderBy('id','desc')->get();
        // 价格表
        $plans = Plan::orderBy('id','DESC')->get();
        // 判断当前是否已过期
        date_default_timezone_set('Asia/Shanghai');
        if ($this->user->payment_date > time()) {
            $this->user->payment_status = "有效";
            $this->user->save();
        } else {
            $this->user->payment_status = "已过期";
            $this->user->save();
        }

        return $this->view()->assign('v2ray_qr_android_array', $v2ray_qr_android_array)
                            ->assign('v2ray_qr_ios_array', $v2ray_qr_ios_array)
                            ->assign('userInfos', $userInfos)
                            ->assign('nodes', $nodes)
                            ->assign('msg', $msg)
                            ->assign('plans',$plans)
                            ->display('user/index.tpl');
    }

    public function postFingerPrint($request, $response, $args) {
        // 采集指纹
        $arg_fingerprint = $request->getParam('fingerprint');
        $arg_system = $request->getParam('system');
        $arg_browser = $request->getParam('browser');
        $arg_useragent = $request->getHeaderLine('User-Agent');

        $print = UserFingerprint::where('fingerprint', $arg_fingerprint)->first();
        if ($print != null) {
            // 已经存在
            // 是否同一个用户的
            if ($print->user_id == $this->user->id) {
                // 同一用户
            } else {
                // 不同用户
                $fingerprint = new UserFingerprint();
                $fingerprint->user_id = $this->user->id;
                $fingerprint->user_name = $this->user->user_name;
                $fingerprint->user_email = $this->user->email;
                $fingerprint->fingerprint = $arg_fingerprint;
                $fingerprint->system = $arg_system;
                $fingerprint->browser = $arg_browser;
                $fingerprint->same = "跟" . $print->user_name . "的指纹一样";
                $fingerprint->useragent = $arg_useragent;
                $fingerprint->save();
            }
        } else {
            // 不存在
            $fingerprint = new UserFingerprint();
            $fingerprint->user_id = $this->user->id;
            $fingerprint->user_name = $this->user->user_name;
            $fingerprint->user_email = $this->user->email;
            $fingerprint->fingerprint = $arg_fingerprint;
            $fingerprint->system = $arg_system;
            $fingerprint->browser = $arg_browser;
            $fingerprint->useragent = $arg_useragent;
            $fingerprint->save();
        }        
    }

    public function getclient($request, $response, $args)
    {
        $hk1 = $this->getSSURL(1); //hk1
        $us1 = $this->getSSURL(2); //us1
        $jp1 = $this->getSSURL(4); //jp1
        return $this->view()->assign('hk1', $hk1)->assign('us1', $us1)->assign('jp1', $jp1)->display('user/getclient.tpl');
    }

    public function payment($request, $response, $args)
    {
        $plans = Plan::orderBy('id','DESC')->get();
        return $this->view()->assign('plans',$plans)->display('user/payment.tpl');
    }

    public function paymentHandleById($request, $response, $args)
    {
        $id = $args['id'];
        $Plan = Plan::find($id);

        // $paymentType = $request->getParam('paymentType');
        // 如果已经有待付款订单 则更新该订单
        $order = Order::where('user_id', $this->user->id)->where('order_status','待付款')->first();
        if ($order != null && $order->count() > 0){
            // 使用已经产生的订单
        } else {
            // 产生订单
            $order = new Order();
        }
        // 如果已经有已完成订单，则在上次完成时间上累加(还没有过期)
        $completeOrder = Order::where('user_id', $this->user->id)->where('order_status','已完成')->orderBy('id','desc')->first();
        date_default_timezone_set('Asia/Shanghai');
        if ($completeOrder != null && $completeOrder->count() > 0 && $completeOrder->payment_date > time()) {
            $order->user_id = $this->user->id;
            $order->user_name = $this->user->user_name;
            $order->user_email = $this->user->email;
            $order->payment_date = strtotime(date('Y-m-d H:i:s', $completeOrder->payment_date) . $Plan->plan_time);
            $order->payment_name =$Plan->plan_name;
        } else {
            // 如果没有已完成的 那就在当前时间上累加
            // 还有一种情况有完成但是已过期的也是这种模式
            $order->user_id = $this->user->id;
            $order->user_name = $this->user->user_name;
            $order->user_email = $this->user->email;
            $order->payment_date = strtotime($Plan->plan_time);
            $order->payment_name = $Plan->plan_name;
        }
        
        if (!$order->save()){
            $res['ret'] = 0;
            $res['msg'] = "订单提交失败";
            return $response->getBody()->write(json_encode($res));
        } else {
            // $res['ret'] = 1;
            // $res['msg'] = "订单提交成功";
            // return $this->echoJson($response, $res);
            $newResponse = $response->withStatus(302)->withHeader('Location', '/user/order');
            return $newResponse;
        }

    }

    public function order($request, $response, $args) 
    {
        $orders = Order::where('user_id', '=', $this->user->id)->orderBy('id', 'desc')->get();
        return $this->view()->assign('orders', $orders)->display('user/order.tpl');
    }

    public function getWinZip($request, $response, $args)
    {
        // 从v2ray_node读取配置
        $nodes = v2rayNode::all();
        // 读取配置文件
        $configStr = file_get_contents("./downloads/v2rayN/guiNConfig.json");
        $configJson = json_decode($configStr, true);
        // unset($configJson["vmess"]);
        $configJson["vmess"] = [];
        foreach ($nodes as $node) {
            $addNode["address"] = $node->address;
            $addNode["port"] = (int)$node->port;
            $addNode["id"] = $this->user->uuid;
            $addNode["alterId"] = (int)$node->alter_id;
            $addNode["security"] = $node->security;
            $addNode["network"] = $node->getWebsocketAlias();
            $addNode["remarks"] = $node->name;
            $addNode["headerType"] = $node->type;
            $addNode["requestHost"] = $node->path;
            $addNode["streamSecurity"] = $node->getTlsAlias();
            array_push($configJson["vmess"], $addNode);
        }
        // var_dump($configJson);
        $fp = fopen("./downloads/v2rayN/guiNConfig.json", 'w');
        if ($fp) {
            fwrite($fp, json_encode($configJson, JSON_PRETTY_PRINT|JSON_UNESCAPED_SLASHES));
            fclose($fp);
            // 修改配置
            // 打包
            // echo shell_exec("tar -czvf ./downloads/v2rayN_win.zip -C ./downloads/v2rayN .");
            echo shell_exec("cd ./downloads;rm -f v2rayN_win.zip;zip -r v2rayN_win.zip ./v2rayN;cd ..");
            echo shell_exec("/bin/cp ./downloads/v2rayN_win.zip ./downloads/upload/v2rayN_win.zip");
            $newResponse = $response->withStatus(302)->withHeader('Location', "https://download.speedss.top/v2rayN_win.zip");
            return $newResponse;
        } else {
            echo "permission denied.";
        }
    }

    function watchVideo($request, $response, $args) {
        return $this->view()->display('user/watchvideo.tpl');
    }

    function getServerConfig($request, $response, $args) {
        // 从v2ray_node读取配置
        $nodes = v2rayNode::all();
        $configJson = [];
        foreach ($nodes as $node) {
            $addNode["address"] = $node->address;
            $addNode["port"] = (int)$node->port;
            $addNode["id"] = $this->user->uuid;
            $addNode["alterId"] = (int)$node->alter_id;
            $addNode["security"] = $node->security;
            $addNode["network"] = $node->getWebsocketAlias();
            $addNode["remarks"] = $node->name;
            $addNode["headerType"] = $node->type;
            $addNode["requestHost"] = $node->path;
            $addNode["streamSecurity"] = $node->getTlsAlias();
            array_push($configJson, $addNode);
        }
        return $this->echoJson($response, $configJson);
    }

    function getSSURL($node)
    {
        $node = Node::find($node);
        if ($node == null) {}
        $ary['server'] = $node->server;
        $ary['server_port'] = $this->user->port;
        $ary['password'] = $this->user->passwd;
        $ary['method'] = $node->method;
        if ($node->custom_method) {
            $ary['method'] = $this->user->method;
        }
        $json = json_encode($ary);
        $json_show = json_encode($ary, JSON_PRETTY_PRINT);
        $ssurl = $ary['method'] . ":" . $ary['password'] . "@" . $ary['server'] . ":" . $ary['server_port'];
        $ssqr = "ss://" . base64_encode($ssurl);
        return $ssqr;
    }

    public function node($request, $response, $args)
    {
        $msg = DbConfig::get('user-node');
        $user = Auth::getUser();
        $nodes = Node::where('type', 1)->orderBy('sort')->get();
        return $this->view()->assign('nodes', $nodes)->assign('user', $user)->assign('msg', $msg)->display('user/node.tpl');
    }


    public function nodeInfo($request, $response, $args)
    {
        $id = $args['id'];
        $node = Node::find($id);

        if ($node == null) {

        }
        $ary['server'] = $node->server;
        $ary['server_port'] = $this->user->port;
        $ary['password'] = $this->user->passwd;
        $ary['method'] = $node->method;
        if ($node->custom_method) {
            $ary['method'] = $this->user->method;
        }
        $json = json_encode($ary);
        $json_show = json_encode($ary, JSON_PRETTY_PRINT);
        $ssurl = $ary['method'] . ":" . $ary['password'] . "@" . $ary['server'] . ":" . $ary['server_port'];
        $ssqr = "ss://" . base64_encode($ssurl);

        $surge_base = Config::get('baseUrl') . "/downloads/ProxyBase.conf";
        $surge_proxy = "#!PROXY-OVERRIDE:ProxyBase.conf\n";
        $surge_proxy .= "[Proxy]\n";
        $surge_proxy .= "Proxy = custom," . $ary['server'] . "," . $ary['server_port'] . "," . $ary['method'] . "," . $ary['password'] . "," . Config::get('baseUrl') . "/downloads/SSEncrypt.module";
        return $this->view()->assign('json', $json)->assign('json_show', $ary)->assign('ssqr', $ssqr)->assign('surge_base', $surge_base)->assign('surge_proxy', $surge_proxy)->display('user/nodeinfo.tpl');
    }

    public function profile($request, $response, $args)
    {
        return $this->view()->display('user/profile.tpl');
    }

    public function edit($request, $response, $args)
    {
        $method = Node::getCustomerMethod();
        return $this->view()->assign('method', $method)->display('user/edit.tpl');
    }


    public function invite($request, $response, $args)
    {
        $codes = $this->user->inviteCodes();
        return $this->view()->assign('codes', $codes)->display('user/invite.tpl');
    }

    public function doInvite($request, $response, $args)
    {
        //$n = $this->user->invite_num;
        $n = 1;
	    if ($n < 1) {
            $res['ret'] = 0;
            return $response->getBody()->write(json_encode($res));
        }
        for ($i = 0; $i < $n; $i++) {
            $char = Tools::genRandomChar(32);
            $code = new InviteCode();
            $code->code = $char;
            $code->user_id = $this->user->id;
            $code->save();
        }
        $this->user->invite_num = 0;
        $this->user->save();
        $res['ret'] = 1;
        return $this->echoJson($response, $res);
    }

    public function sys($request, $response, $args)
    {
        return $this->view()->assign('ana', "")->display('user/sys.tpl');
    }

    public function updatePassword($request, $response, $args)
    {
        $oldpwd = $request->getParam('oldpwd');
        $pwd = $request->getParam('pwd');
        $repwd = $request->getParam('repwd');
        $user = $this->user;
        if (!Hash::checkPassword($user->pass, $oldpwd)) {
            $res['ret'] = 0;
            $res['msg'] = "旧密码错误";
            return $response->getBody()->write(json_encode($res));
        }
        if ($pwd != $repwd) {
            $res['ret'] = 0;
            $res['msg'] = "两次输入不符合";
            return $response->getBody()->write(json_encode($res));
        }

        if (strlen($pwd) < 8) {
            $res['ret'] = 0;
            $res['msg'] = "密码太短啦";
            return $response->getBody()->write(json_encode($res));
        }
        $hashPwd = Hash::passwordHash($pwd);
        $user->pass = $hashPwd;
        $user->save();

        $res['ret'] = 1;
        $res['msg'] = "密码修改成功";
        return $this->echoJson($response, $res);
    }

    public function updateSsPwd($request, $response, $args)
    {
        $user = Auth::getUser();
        $pwd = $request->getParam('sspwd');
        if (strlen($pwd) == 0) {
            $pwd = Tools::genRandomChar(8);
        } elseif (strlen($pwd) < 5) {
            $res['ret'] = 0;
            $res['msg'] = "密码要大于4位或者留空生成随机密码";
            return $response->getBody()->write(json_encode($res));;
        }
        $user->updateSsPwd($pwd);
        $res['ret'] = 1;
        $res['msg'] = sprintf("新密码为: %s", $pwd);
        return $this->echoJson($response, $res);
    }

    public function updateMethod($request, $response, $args)
    {
        $user = Auth::getUser();
        $method = $request->getParam('method');
        $method = strtolower($method);
        $user->updateMethod($method);
        $res['ret'] = 1;
        return $this->echoJson($response, $res);
    }

    public function logout($request, $response, $args)
    {
        Auth::logout();
        $newResponse = $response->withStatus(302)->withHeader('Location', '/auth/login');
        return $newResponse;
    }

    public function doCheckIn($request, $response, $args)
    {
        if (!$this->user->isAbleToCheckin()) {
            $res['msg'] = "您似乎已经签到过了...";
            $res['ret'] = 1;
            return $response->getBody()->write(json_encode($res));
        }
        $traffic = rand(Config::get('checkinMin'), Config::get('checkinMax'));
        $trafficToAdd = Tools::toMB($traffic);
        $this->user->transfer_enable = $this->user->transfer_enable + $trafficToAdd;
        $this->user->last_check_in_time = time();
        $this->user->save();
        // checkin log
        try {
            $log = new CheckInLog();
            $log->user_id = Auth::getUser()->id;
            $log->traffic = $trafficToAdd;
            $log->checkin_at = time();
            $log->save();
        } catch (\Exception $e) {
        }
        $res['msg'] = sprintf("获得了 %u MB流量.", $traffic);
        $res['ret'] = 1;
        return $this->echoJson($response, $res);
    }

    public function kill($request, $response, $args)
    {
        return $this->view()->display('user/kill.tpl');
    }

    public function handleKill($request, $response, $args)
    {
        $user = Auth::getUser();
        $passwd = $request->getParam('passwd');
        // check passwd
        $res = array();
        if (!Hash::checkPassword($user->pass, $passwd)) {
            $res['ret'] = 0;
            $res['msg'] = " 密码错误";
            return $this->echoJson($response, $res);
        }
        Auth::logout();
        $user->delete();
        $res['ret'] = 1;
        $res['msg'] = "GG!您的帐号已经从我们的系统中删除.";
        return $this->echoJson($response, $res);
    }

    public function trafficLog($request, $response, $args)
    {
        $pageNum = 1;
        if (isset($request->getQueryParams()["page"])) {
            $pageNum = $request->getQueryParams()["page"];
        }
        $traffic = TrafficLog::where('user_id', $this->user->id)->orderBy('id', 'desc')->paginate(15, ['*'], 'page', $pageNum);
        $traffic->setPath('/user/trafficlog');
        return $this->view()->assign('logs', $traffic)->display('user/trafficlog.tpl');
    }
}
