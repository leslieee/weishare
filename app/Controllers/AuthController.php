<?php

namespace App\Controllers;

use App\Models\InviteCode;
use App\Models\User;
use App\Models\UserFingerprint;
use App\Services\Auth;
use App\Services\Auth\EmailVerify;
use App\Services\Config;
use App\Services\Logger;
use App\Services\Mail;
use App\Utils\Check;
use App\Utils\Hash;
use App\Utils\Http;
use App\Utils\Tools;


/**
 *  AuthController
 */
class AuthController extends BaseController
{
    // Register Error Code
    const WrongCode = 501;
    const IllegalEmail = 502;
    const PasswordTooShort = 511;
    const PasswordNotEqual = 512;
    const EmailUsed = 521;

    // Login Error Code
    const UserNotExist = 601;
    const UserPasswordWrong = 602;

    // Verify Email
    const VerifyEmailWrongEmail = 701;
    const VerifyEmailExist = 702;

    public function login($request, $response, $args)
    {
        return $this->view()->display('auth/login.tpl');
    }

    public function loginHandle($request, $response, $args)
    {
        // $data = $request->post('sdf');
        $email = $request->getParam('email');
        $email = strtolower($email);
        $passwd = $request->getParam('passwd');
        $rememberMe = $request->getParam('remember_me');

        // Handle Login
        $user = User::where('email', '=', $email)->first();

        if ($user == null) {
            $res['ret'] = 0;
            $res['error_code'] = self::UserNotExist;
            $res['msg'] = "邮箱或者密码错误";
            return $this->echoJson($response, $res);
        }

        if (!Hash::checkPassword($user->pass, $passwd)) {
            $res['ret'] = 0;
            $res['error_code'] = self::UserPasswordWrong;
            $res['msg'] = "邮箱或者密码错误";
            return $this->echoJson($response, $res);
        }
        // @todo
        $time = 3600 * 24;
        if ($rememberMe) {
            $time = 3600 * 24 * 7;
        }
        Logger::info("login user $user->id ");
        Auth::login($user->id, $time);

        // 如果没有uuid 就生成
        if ($user->uuid == "") {
            $str = md5(uniqid(mt_rand(), true));   
            $uuid  = substr($str,0,8) . '-';   
            $uuid .= substr($str,8,4) . '-';   
            $uuid .= substr($str,12,4) . '-';   
            $uuid .= substr($str,16,4) . '-';   
            $uuid .= substr($str,20,12);   
            $user->uuid = $uuid;
            // $user->save();
        }
        // 给没有套餐信息的帐号按之前的流量数添加天数
        // 从注册日期开始加 
        // 小于30       一个月
        // 30 到 80     三个月
        // 80 到 200    六个月
        // 200 到 15000 12个月
        // 15000 到无限  24个月
        date_default_timezone_set('Asia/Shanghai');
        if ($user->payment_date == null){
            $transfer = $user->transfer_enable/1024/1024/1024;
            if ($transfer < 30) {
                // 在reg的基础上加一个月
                $regDate = $user->reg_date . ' +1 month';
                $user->payment_date = strtotime($regDate);
                $user->payment_day = 30;
                $user->payment_name = "一个月体验套餐";
                // $user->save();
            } elseif ($transfer >= 30 && $transfer < 80) {
                $regDate = $user->reg_date . ' +3 month';
                $user->payment_date = strtotime($regDate);
                $user->payment_day = 90;
                $user->payment_name = "三个月体验套餐";
                // $user->save();
            } elseif ($transfer >= 80 && $transfer < 200) {
                $regDate = $user->reg_date . ' +6 month';
                $user->payment_date = strtotime($regDate);
                $user->payment_day = 180;
                $user->payment_name = "半年套餐";
                // $user->save();
            } elseif ($transfer >= 200 && $transfer < 15000) {
                $regDate = $user->reg_date . ' +1 year';
                $user->payment_date = strtotime($regDate);
                $user->payment_day = 360;
                $user->payment_name = "一年套餐";
                // $user->save();
            } elseif ($transfer > 15000) {
                $regDate = $user->reg_date . ' +2 year';
                $user->payment_date = strtotime($regDate);
                $user->payment_day = 720;
                $user->payment_name = "两年套餐";
                // $user->save();
            }
        }
        // 判断当前是否已过期
        if ($user->payment_date > time()) {
            $user->payment_status = "有效";
            // $user->save();
        } else {
            $user->payment_status = "已过期";
            // $user->save();
        }
        // 获取登录地址
        $ip = Http::getClientIP();
        $addressInfo = json_decode(file_get_contents('https://ip.huomao.com/ip?ip=' . $ip), true);
        if ($addressInfo != null) {
            $user->login_address = $addressInfo["country"] . $addressInfo["province"] . $addressInfo["city"] . $addressInfo["isp"];
        }

        // 最后再来保存
        $user->save();
        

        $res['ret'] = 1;
        $res['msg'] = "欢迎回来";
        return $this->echoJson($response, $res);
    }

    public function register($request, $response, $args)
    {
        $ary = $request->getQueryParams();
        $code = "";
        if (isset($ary['code'])) {
            $code = $ary['code'];
        }
        $requireEmailVerification = Config::get('emailVerifyEnabled');
        return $this->view()->assign('code', $code)->assign('requireEmailVerification', $requireEmailVerification)->display('auth/register.tpl');
    }

    public function registerHandle($request, $response, $args)
    {
        $name = $request->getParam('name');
        $email = $request->getParam('email');
        $email = strtolower($email);
        $passwd = $request->getParam('passwd');
        // 这里有个坑 新加的字段传不上来 所以只能用旧的了
        $adminName = $request->getParam('repasswd');
        $code = $request->getParam('code');
        $verifycode = $request->getParam('verifycode');
        // $adminName = $request->getParam('adminName');
        // echo $adminName;

        $fingerprint = $request->getParam('fingerprint');
        // 检测指纹
        // 这里改为从指纹库检索
        // $user_finger = User::where('fingerprint', $fingerprint)->first();
        $user_finger = UserFingerprint::where('fingerprint', $fingerprint)->first();
        if ($user_finger == null) {
            $shouldAddTime = true;
        }

        // check code
        $c = InviteCode::where('code', $code)->first();
        if ($c == null) {
            // 如果邀请码为空则判断adminName
            if ($adminName == null) {
                $res['ret'] = 0;
                $res['error_code'] = self::WrongCode;
                $res['msg'] = "邀请码无效";
                return $this->echoJson($response, $res);
            } else {
                // if ($adminName == "leslie" || $adminName == "管道工") {
                if ($adminName == "管道工") {
                    $char = Tools::genRandomChar(32);
                    $c = new InviteCode();
                    $c->code = $char;
                    $c->user_id = 1;
                    $c->save();
                } else if ($adminName == "凸凸突突兔套") {
                    $char = Tools::genRandomChar(32);
                    $c = new InviteCode();
                    $c->code = $char;
                    $c->user_id = 298;
                    $c->save();
                } else {
                    $res['ret'] = 0;
                    $res['error_code'] = self::WrongCode;
                    $res['msg'] = "管理员名字不正确";
                    return $this->echoJson($response, $res);
                }
            }
        }

        // check email format
        if (!Check::isEmailLegal($email)) {
            $res['ret'] = 0;
            $res['error_code'] = self::IllegalEmail;
            $res['msg'] = "邮箱无效";
            $c->delete();
            return $this->echoJson($response, $res);
        }
        // check pwd length
        if (strlen($passwd) < 8) {
            $res['ret'] = 0;
            $res['error_code'] = self::PasswordTooShort;
            $res['msg'] = "密码太短";
            $c->delete();
            return $this->echoJson($response, $res);
        }

        // check pwd re
        // if ($passwd != $repasswd) {
        //     $res['ret'] = 0;
        //     $res['error_code'] = self::PasswordNotEqual;
        //     $res['msg'] = "两次密码输入不符";
        //     return $this->echoJson($response, $res);
        // }

        // check email
        $user = User::where('email', $email)->first();
        if ($user != null) {
            $res['ret'] = 0;
            $res['error_code'] = self::EmailUsed;
            $res['msg'] = "邮箱已经被注册了";
            $c->delete();
            return $this->echoJson($response, $res);
        }

        // verify email
        if (Config::get('emailVerifyEnabled') && !EmailVerify::checkVerifyCode($email, $verifycode)) {
            $res['ret'] = 0;
            $res['msg'] = '邮箱验证代码不正确';
            $c->delete();
            return $this->echoJson($response, $res);
        }

        // check ip limit
        $ip = Http::getClientIP();
        $ipRegCount = Check::getIpRegCount($ip);
        if ($ipRegCount >= Config::get('ipDayLimit')) {
            $res['ret'] = 0;
            $res['msg'] = '当前IP注册次数超过限制';
            $c->delete();
            return $this->echoJson($response, $res);
        }

        // do reg user
        $user = new User();
        $user->user_name = $name;
        $user->email = $email;
        $user->pass = Hash::passwordHash($passwd);
        $user->passwd = Tools::genRandomChar(6);
        $user->port = Tools::getLastPort() + 1;
        $user->t = 0;
        $user->u = 0;
        $user->d = 0;
        $user->transfer_enable = Tools::toGB(Config::get('defaultTraffic'));
        $user->invite_num = Config::get('inviteNum');
        $user->reg_ip = Http::getClientIP();
        $user->ref_by = $c->user_id;
        $user->fingerprint = $fingerprint;

        // 添加注册地址
        $addressInfo = json_decode(file_get_contents('https://ip.huomao.com/ip?ip=' . $ip), true);
        if ($addressInfo != null) {
            $user->reg_address = $addressInfo["country"] . $addressInfo["province"] . $addressInfo["city"] . $addressInfo["isp"];
            $user->login_address = "";
        }
      
        // 注册新加时间
        if ($shouldAddTime) {
            date_default_timezone_set('Asia/Shanghai');
            $user->payment_date = strtotime('+3 day');
            $user->payment_day = 3;
            $user->payment_name = "3天体验套餐";
        } else {
            date_default_timezone_set('Asia/Shanghai');
            $user->payment_date = time()-10;
            $user->payment_day = 0;
            $user->payment_name = "重复注册, 请联系管理员";
        }
        
        // 生成uuid
        $str = md5(uniqid(mt_rand(), true));   
        $uuid  = substr($str,0,8) . '-';   
        $uuid .= substr($str,8,4) . '-';   
        $uuid .= substr($str,12,4) . '-';   
        $uuid .= substr($str,16,4) . '-';   
        $uuid .= substr($str,20,12);   
        $user->uuid = $uuid;
        
        // 之前推荐好友赠送用的 已废弃
        //$userAddTraffic = User::find($c->user_id);
        //$userAddTraffic->transfer_enable = $userAddTraffic->transfer_enable + 10737418240;
        //if ($userAddTraffic->save()) {
            //    	$myfile1 = fopen("pd", "a");
            //	$txt1 = $userAddTraffic->user_name . " " . "add 10GB traffic" . "\n";
            //	fwrite($myfile1, $txt1);
            //	fclose($myfile1);
        //}

        if ($user->save()) {
            $res['ret'] = 1;
            $res['msg'] = "注册成功";
            $c->delete();
            return $this->echoJson($response, $res);
        }
        $res['ret'] = 0;
        $res['msg'] = "未知错误";
        return $this->echoJson($response, $res);
    }

    public function sendVerifyEmail($request, $response, $args)
    {
        $res = [];
        $email = $request->getParam('email');

        if (!Check::isEmailLegal($email)) {
            $res['ret'] = 0;
            $res['error_code'] = self::VerifyEmailWrongEmail;
            $res['msg'] = '邮箱无效';
            return $this->echoJson($response, $res);
        }

        // check email
        $user = User::where('email', $email)->first();
        if ($user != null) {
            $res['ret'] = 0;
            $res['error_code'] = self::VerifyEmailExist;
            $res['msg'] = "邮箱已经被注册了";
            return $this->echoJson($response, $res);
        }

        if (EmailVerify::sendVerification($email)) {
            $res['ret'] = 1;
            $res['msg'] = '验证代码已发送至您的邮箱，请在登录邮箱后将验证码填到相应位置.';
            return $this->echoJson($response, $res);
        }
        $res['ret'] = 0;
        $res['msg'] = '邮件发送失败，请联系管理员';
        return $this->echoJson($response, $res);
    }

    public function logout($request, $response, $args)
    {
        Auth::logout();
        return $this->redirect($response, '/auth/login');
    }

}
