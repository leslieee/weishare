<?php

namespace App\Models;


class Order extends Model
{
    protected $table = "user_order";

    public function getOrderStatus()
    {
        if ($this->attributes['order_status'] == "已完成") {
            return 1;
        } else {
            return 0;
        }
    }
}