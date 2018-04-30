<?php

namespace App\Services;

use App\Models\User;
use App\Models\Node;
use App\Models\Order;
use App\Utils\Tools;

class Analytics
{
    public function getPendingOrders()
    {
        return Order::where('order_status','待付款')->count();
    }

    public function getTotalUser()
    {
        return User::count()+300;
    }

    public function getCheckinUser()
    {
        return User::where('last_check_in_time', '>', 0)->count();
    }

    public function getTrafficUsage()
    {
        $total = User::sum('u') + USer::sum('d');
        return Tools::flowAutoShow($total);
    }

    public function getOnlineUser($time)
    {
        $time = time() - $time;
        return User::where('t', '>', $time)->count();
    }

    public function getTotalNode()
    {
        return Node::count();
    }

}