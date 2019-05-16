<?php

namespace App\Controllers;

//use Psr\Http\Message\ServerRequestInterface as Request;
//use Psr\Http\Message\ResponseInterface as Response;
use Slim\Http\Request;
use Slim\Http\Response;

use App\Models\InviteCode;
use App\Models\V2rayNode;
use App\Models\User;
use App\Services\Auth;
use App\Services\Config;
use App\Services\DbConfig;
use App\Services\Logger;
use App\Utils\Check;
use App\Utils\Http;
use App\Utils\Hash;

/**
 *  HomeController
 */
class HomeController extends BaseController
{

    public function index($request, $response, $args)
    {
        //$homeIndexMsg = DbConfig::get('home-index');
        //return $this->view()->assign('homeIndexMsg', $homeIndexMsg)->display('index.tpl');
        return $this->redirect($response, '/auth/login');
    }

    public function intro()
    {
        // return $this->redirect($response, '/auth/login');
        // return $this->view()->display('intro.tpl');
        
        // if 模板1 或者 模板2
        // return $this->view()->display('weixinshare1.tpl');

        // 读取微信id
        $file = fopen("wxid", "r");// or exit("无法打开文件!");
        // 读取文件每一行，直到文件结尾
        if ($file) {
            $wxid = fgets($file);
            fclose($file);
            $file1 = fopen("html", "r");
            if ($file1) {
                $html = fread($file1,filesize("html"));
                fclose($file1);
                return $this->view()->assign('html', $html)->assign('wxid', $wxid)->display('weixinshare1.tpl');
            } else {
                return $this->view()->assign('wxid', $wxid)->display('weixinshare1.tpl');
            }
        } else {
            return $this->view()->display('weixinshare1.tpl');
        }
    }

    public function intro3()
    {
        // 读取微信id
        $file = fopen("wxid", "r");// or exit("无法打开文件!");
        // 读取文件每一行，直到文件结尾
        if ($file) {
            $wxid = fgets($file);
            fclose($file);
            return $this->view()->assign('wxid', $wxid)->display('weixinshare3.tpl');
        } else {
            return $this->view()->display('weixinshare3.tpl');
        }
    }

    public function intro4()
    {
        // 读取微信id
        $file = fopen("wxid", "r");// or exit("无法打开文件!");
        // 读取文件每一行，直到文件结尾
        if ($file) {
            $wxid = fgets($file);
            fclose($file);
            return $this->view()->assign('wxid', $wxid)->display('weixinshare4.tpl');
        } else {
            return $this->view()->display('weixinshare4.tpl');
        }
    }

    public function configclient()
    {
        return $this->view()->display('configclient.tpl');
    }

    public function getServerConfig($request, $response, $args)
    {
        $email = $request->getParam('email');
        $email = strtolower($email);
        $passwd = $request->getParam('passwd');
        $user = User::where('email', '=', $email)->first();
        if ($user == null) {
            $res['ret'] = 0;
            $res['msg'] = "邮箱或者密码错误";
            return $this->echoJson($response, $res);
        }
        if (!Hash::checkPassword($user->pass, $passwd)) {
            $res['ret'] = 0;
            $res['msg'] = "邮箱或者密码错误";
            return $this->echoJson($response, $res);
        }
        // 从v2ray_node读取配置
        $nodes = v2rayNode::all();
        $configJson = [];
        foreach ($nodes as $node) {
            $addNode["address"] = $node->address;
            $addNode["port"] = (int)$node->port;
            $addNode["id"] = $user->uuid;
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

    public function getAndroidServerConfig($request, $response, $args)
    {
        $email = $request->getParam('email');
        $email = strtolower($email);
        $passwd = $request->getParam('passwd');
        $user = User::where('email', '=', $email)->first();
        if ($user == null) {
            $res['ret'] = 0;
            $res['msg'] = "邮箱或者密码错误";
            return $this->echoJson($response, $res);
        }
        if (!Hash::checkPassword($user->pass, $passwd)) {
            $res['ret'] = 0;
            $res['msg'] = "邮箱或者密码错误";
            return $this->echoJson($response, $res);
        }
        // 从v2ray_node读取配置
        $nodes = v2rayNode::all();
        $configJson = [];
        foreach ($nodes as $node) {
            $addNode["add"] = $node->address;
            $addNode["ps"] = $node->name;
            $addNode["port"] = $node->port;
            $addNode["id"] = $user->uuid;
            $addNode["aid"] = $node->alter_id;
            $addNode["net"] = $node->getWebsocketAlias();
            $addNode["host"] = $node->path;
            $addNode["tls"] = $node->getTlsAlias();
            $addNode["type"] = $node->type;
            $addNodeStr = json_encode($addNode);
            $addNodeStr = base64_encode($addNodeStr);
            $addNodeStr = "vmess://" . $addNodeStr;
            array_push($configJson, $addNodeStr);
        }
        // return $this->echoJson($response, $configJson);
        echo json_encode($configJson, JSON_UNESCAPED_SLASHES);
    }

    public function code()
    {
        $msg = DbConfig::get('home-code');
        $codes = InviteCode::where('user_id', '=', '0')->take(10)->get();
        return $this->view()->assign('codes', $codes)->assign('msg', $msg)->display('code.tpl');
    }

    public function debug($request, $response, $args)
    {
        $server = [
            "headers" => $request->getHeaders(),
            "content_type" => $request->getContentType()
        ];
        $res = [
            "server_info" => $server,
            "ip" => Http::getClientIP(),
            "version" => Config::get('version'),
            "reg_count" => Check::getIpRegCount(Http::getClientIP()),
        ];
        Logger::debug(json_encode($res));
        return $this->echoJson($response, $res);
    }

    public function tos()
    {
        return $this->view()->display('tos.tpl');
    }

    public function postDebug(Request $request,Response $response, $args)
    {
        $res = [
            "body" => $request->getBody(), 
            "params" => $request->getParams() 
        ];
        return $this->echoJson($response, $res);
    }

}
