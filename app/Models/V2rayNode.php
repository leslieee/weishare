<?php

namespace App\Models;


class V2rayNode extends Model
{
    protected $table = "v2ray_node";

    public function getTlsAlias()
    {
        if ($this->attributes['tls'] == "1") {
            return "tls";
        }
    }

    public function getWebsocketAlias()
    {
        if ($this->attributes['network'] == "websocket") {
            return "ws";
        }
    }
}