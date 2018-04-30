/*
 Navicat Premium Data Transfer

 Source Server         : 芝加哥cn2
 Source Server Type    : MySQL
 Source Server Version : 50559
 Source Host           : localhost
 Source Database       : shadowsocks

 Target Server Type    : MySQL
 Target Server Version : 50559
 File Encoding         : utf-8

 Date: 04/30/2018 17:28:13 PM
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `sp_config`
-- ----------------------------
DROP TABLE IF EXISTS `sp_config`;
CREATE TABLE `sp_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(128) NOT NULL,
  `value` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `sp_email_verify`
-- ----------------------------
DROP TABLE IF EXISTS `sp_email_verify`;
CREATE TABLE `sp_email_verify` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(32) NOT NULL,
  `token` varchar(64) NOT NULL,
  `expire_at` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `sp_log`
-- ----------------------------
DROP TABLE IF EXISTS `sp_log`;
CREATE TABLE `sp_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(16) NOT NULL,
  `msg` text NOT NULL,
  `created_time` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `ss_checkin_log`
-- ----------------------------
DROP TABLE IF EXISTS `ss_checkin_log`;
CREATE TABLE `ss_checkin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `checkin_at` int(11) NOT NULL,
  `traffic` double NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1118 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `ss_invite_code`
-- ----------------------------
DROP TABLE IF EXISTS `ss_invite_code`;
CREATE TABLE `ss_invite_code` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(128) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=470 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `ss_node`
-- ----------------------------
DROP TABLE IF EXISTS `ss_node`;
CREATE TABLE `ss_node` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `type` int(3) NOT NULL,
  `server` varchar(128) NOT NULL,
  `method` varchar(64) NOT NULL,
  `custom_method` tinyint(1) NOT NULL DEFAULT '0',
  `traffic_rate` float NOT NULL DEFAULT '1',
  `info` varchar(128) NOT NULL,
  `status` varchar(128) NOT NULL,
  `offset` int(11) NOT NULL DEFAULT '0',
  `sort` int(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `ss_node_info_log`
-- ----------------------------
DROP TABLE IF EXISTS `ss_node_info_log`;
CREATE TABLE `ss_node_info_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `node_id` int(11) NOT NULL,
  `uptime` float NOT NULL,
  `load` varchar(32) NOT NULL,
  `log_time` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `ss_node_online_log`
-- ----------------------------
DROP TABLE IF EXISTS `ss_node_online_log`;
CREATE TABLE `ss_node_online_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `node_id` int(11) NOT NULL,
  `online_user` int(11) NOT NULL,
  `log_time` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `ss_password_reset`
-- ----------------------------
DROP TABLE IF EXISTS `ss_password_reset`;
CREATE TABLE `ss_password_reset` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(32) NOT NULL,
  `token` varchar(128) NOT NULL,
  `init_time` int(11) NOT NULL,
  `expire_time` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `user`
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(128) CHARACTER SET utf8mb4 NOT NULL,
  `email` varchar(32) NOT NULL,
  `pass` varchar(64) NOT NULL,
  `passwd` varchar(16) NOT NULL,
  `t` int(11) NOT NULL DEFAULT '0',
  `u` bigint(20) NOT NULL,
  `d` bigint(20) NOT NULL,
  `transfer_enable` bigint(20) NOT NULL,
  `port` int(11) NOT NULL,
  `protocol` varchar(32) NOT NULL DEFAULT 'origin',
  `obfs` varchar(32) NOT NULL DEFAULT 'plain',
  `switch` tinyint(4) NOT NULL DEFAULT '1',
  `enable` tinyint(4) NOT NULL DEFAULT '1',
  `type` tinyint(4) NOT NULL DEFAULT '1',
  `last_get_gift_time` int(11) NOT NULL DEFAULT '0',
  `last_check_in_time` int(11) NOT NULL DEFAULT '0',
  `last_rest_pass_time` int(11) NOT NULL DEFAULT '0',
  `reg_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `payment_date` int(11) DEFAULT NULL,
  `payment_day` int(11) DEFAULT NULL,
  `payment_name` varchar(32) NOT NULL DEFAULT '',
  `payment_status` varchar(11) NOT NULL DEFAULT '',
  `uuid` varchar(64) NOT NULL DEFAULT '',
  `fingerprint` varchar(64) NOT NULL DEFAULT '',
  `invite_num` int(8) NOT NULL DEFAULT '0',
  `is_admin` int(2) NOT NULL DEFAULT '0',
  `ref_by` int(11) NOT NULL DEFAULT '0',
  `expire_time` int(11) NOT NULL DEFAULT '0',
  `method` varchar(64) NOT NULL DEFAULT 'aes-256-cfb',
  `is_email_verify` tinyint(4) NOT NULL DEFAULT '0',
  `reg_ip` varchar(128) NOT NULL DEFAULT '127.0.0.1',
  `reg_address` varchar(128) NOT NULL DEFAULT '',
  `login_address` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `port` (`port`)
) ENGINE=InnoDB AUTO_INCREMENT=366 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `user_fingerprint`
-- ----------------------------
DROP TABLE IF EXISTS `user_fingerprint`;
CREATE TABLE `user_fingerprint` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `user_name` varchar(64) DEFAULT NULL,
  `user_email` varchar(64) DEFAULT NULL,
  `fingerprint` varchar(64) DEFAULT NULL,
  `system` varchar(64) DEFAULT NULL,
  `browser` varchar(64) DEFAULT NULL,
  `same` varchar(64) DEFAULT '',
  `useragent` varchar(256) DEFAULT '',
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=499 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `user_info`
-- ----------------------------
DROP TABLE IF EXISTS `user_info`;
CREATE TABLE `user_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `hidden` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `user_order`
-- ----------------------------
DROP TABLE IF EXISTS `user_order`;
CREATE TABLE `user_order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `user_name` varchar(64) NOT NULL DEFAULT '',
  `user_email` varchar(64) NOT NULL DEFAULT '',
  `payment_date` int(11) DEFAULT NULL,
  `payment_day` int(11) DEFAULT NULL,
  `payment_name` varchar(64) NOT NULL DEFAULT '',
  `order_status` varchar(11) NOT NULL DEFAULT '待付款',
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `remarks` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `user_plan`
-- ----------------------------
DROP TABLE IF EXISTS `user_plan`;
CREATE TABLE `user_plan` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `plan_name` varchar(64) NOT NULL DEFAULT '',
  `plan_price` varchar(11) NOT NULL DEFAULT '',
  `plan_time` varchar(32) NOT NULL DEFAULT '',
  `plan_client` varchar(11) NOT NULL DEFAULT '3',
  `plan_flow` varchar(11) NOT NULL DEFAULT '无限制',
  `plan_detail` varchar(128) NOT NULL DEFAULT '',
  `hidden` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `user_token`
-- ----------------------------
DROP TABLE IF EXISTS `user_token`;
CREATE TABLE `user_token` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(256) NOT NULL,
  `user_id` int(11) NOT NULL,
  `create_time` int(11) NOT NULL,
  `expire_time` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `user_traffic_log`
-- ----------------------------
DROP TABLE IF EXISTS `user_traffic_log`;
CREATE TABLE `user_traffic_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `u` int(11) NOT NULL,
  `d` int(11) NOT NULL,
  `node_id` int(11) NOT NULL,
  `rate` float NOT NULL,
  `traffic` varchar(32) NOT NULL,
  `log_time` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `v2ray_node`
-- ----------------------------
DROP TABLE IF EXISTS `v2ray_node`;
CREATE TABLE `v2ray_node` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL DEFAULT '',
  `address` varchar(64) NOT NULL DEFAULT '',
  `port` varchar(11) NOT NULL DEFAULT '',
  `uuid` varchar(64) NOT NULL DEFAULT '',
  `alter_id` varchar(11) NOT NULL DEFAULT '',
  `security` varchar(32) NOT NULL DEFAULT '',
  `network` varchar(11) NOT NULL DEFAULT '',
  `path` varchar(20) NOT NULL DEFAULT '',
  `tls` varchar(11) NOT NULL DEFAULT '',
  `type` varchar(11) NOT NULL DEFAULT 'none',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Table structure for `v2ray_node_online_log`
-- ----------------------------
DROP TABLE IF EXISTS `v2ray_node_online_log`;
CREATE TABLE `v2ray_node_online_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `node_ip` varchar(32) NOT NULL DEFAULT '',
  `node_last_uuid` varchar(32) NOT NULL DEFAULT '',
  `node_update_time` varchar(32) NOT NULL,
  `node_online_user` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

SET FOREIGN_KEY_CHECKS = 1;
