-- MySQL dump 10.13  Distrib 9.0.1, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: outdoor_help
-- ------------------------------------------------------
-- Server version	9.0.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `app_user`
--

DROP TABLE IF EXISTS `app_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(100) NOT NULL COMMENT '密码',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `nickname` varchar(50) DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像地址',
  `status` tinyint DEFAULT '1' COMMENT '账号状态：0禁用，1正常',
  `is_helper` tinyint DEFAULT '1' COMMENT '是否接收附近求助：0否，1是',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='普通用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_user`
--

LOCK TABLES `app_user` WRITE;
/*!40000 ALTER TABLE `app_user` DISABLE KEYS */;
INSERT INTO `app_user` VALUES (1,'user001','123456','13800000001','张三',NULL,1,1,'2026-04-26 21:58:58','2026-05-15 19:09:52'),(2,'user002','123456','13800000002','李四',NULL,1,1,'2026-04-26 21:58:58','2026-04-26 21:58:58'),(3,'user003','123456','13800000003','王五',NULL,0,0,'2026-04-26 21:58:58','2026-04-26 21:58:58');
/*!40000 ALTER TABLE `app_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emergency_contact`
--

DROP TABLE IF EXISTS `emergency_contact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `emergency_contact` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `name` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `relation_type` int DEFAULT NULL,
  `status` int DEFAULT '1',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emergency_contact`
--

LOCK TABLES `emergency_contact` WRITE;
/*!40000 ALTER TABLE `emergency_contact` DISABLE KEYS */;
INSERT INTO `emergency_contact` VALUES (2,1,'王五','12345678989',NULL,1,'2026-05-15 20:48:43','2026-05-15 20:48:43');
/*!40000 ALTER TABLE `emergency_contact` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `help_event`
--

DROP TABLE IF EXISTS `help_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `help_event` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '求助事件ID',
  `requester_id` bigint NOT NULL COMMENT '求助者用户ID',
  `help_mode` tinyint NOT NULL COMMENT '求助模式：1一键求助，2自定义求助',
  `help_type` varchar(50) NOT NULL COMMENT '求助类型',
  `emergency_level` tinyint NOT NULL DEFAULT '1' COMMENT '求助等级：1普通，2紧急，3高危',
  `description` text COMMENT '求助描述',
  `latitude` decimal(10,7) NOT NULL COMMENT '纬度',
  `longitude` decimal(10,7) NOT NULL COMMENT '经度',
  `radius` int DEFAULT '1000' COMMENT '求助半径，单位米',
  `image_urls` text COMMENT '图片地址，多个图片用逗号分隔',
  `status` tinyint DEFAULT '0' COMMENT '状态：0待响应，1已响应，2进行中，3已完成，4已取消',
  `responder_id` bigint DEFAULT NULL COMMENT '响应者ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_requester_id` (`requester_id`),
  KEY `idx_responder_id` (`responder_id`),
  KEY `idx_level_status` (`emergency_level`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='求助事件表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `help_event`
--

LOCK TABLES `help_event` WRITE;
/*!40000 ALTER TABLE `help_event` DISABLE KEYS */;
INSERT INTO `help_event` VALUES (1,1,1,'一键求助',3,'用户发起一键高危求助，请附近人员尽快协助',34.1234567,108.1234567,1000,NULL,1,2,'2026-04-26 22:39:30','2026-04-26 22:39:30'),(2,2,2,'迷路',2,'我在山路附近迷路了，希望附近用户帮我确认返回路线',34.2234567,108.2234567,3000,NULL,1,1,'2026-04-26 22:39:30','2026-05-15 19:18:24'),(3,3,2,'缺水',1,'饮用水不足，希望附近用户提供帮助',34.3234567,108.3234567,1000,NULL,3,1,'2026-04-26 22:39:30','2026-04-26 22:39:30');
/*!40000 ALTER TABLE `help_event` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `help_notify_record`
--

DROP TABLE IF EXISTS `help_notify_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `help_notify_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '通知记录ID',
  `help_id` bigint NOT NULL COMMENT '求助事件ID',
  `receiver_id` bigint NOT NULL COMMENT '接收通知的用户ID',
  `emergency_level` tinyint NOT NULL COMMENT '求助等级：1普通，2紧急，3高危',
  `need_vibration` tinyint DEFAULT '1' COMMENT '是否需要振动：0否，1是',
  `notify_status` tinyint DEFAULT '0' COMMENT '通知状态：0待发送，1已发送，2发送失败',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_help_id` (`help_id`),
  KEY `idx_receiver_id` (`receiver_id`),
  KEY `idx_emergency_level` (`emergency_level`),
  KEY `idx_notify_status` (`notify_status`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='求助通知记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `help_notify_record`
--

LOCK TABLES `help_notify_record` WRITE;
/*!40000 ALTER TABLE `help_notify_record` DISABLE KEYS */;
INSERT INTO `help_notify_record` VALUES (1,1,2,3,1,1,'2026-04-27 10:36:34'),(2,1,3,3,1,1,'2026-04-27 10:36:34'),(3,2,1,2,1,0,'2026-04-27 10:36:34'),(4,2,3,2,0,2,'2026-04-27 10:36:34'),(5,3,1,1,0,1,'2026-04-27 10:36:34');
/*!40000 ALTER TABLE `help_notify_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `help_response`
--

DROP TABLE IF EXISTS `help_response`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `help_response` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '响应记录ID',
  `help_id` bigint NOT NULL COMMENT '求助事件ID',
  `responder_id` bigint NOT NULL COMMENT '响应者用户ID',
  `distance` decimal(10,2) DEFAULT NULL COMMENT '响应者距离求助点距离，单位米',
  `response_status` tinyint DEFAULT '1' COMMENT '响应状态：1已响应，2取消响应',
  `response_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '响应时间',
  PRIMARY KEY (`id`),
  KEY `idx_help_id` (`help_id`),
  KEY `idx_responder_id` (`responder_id`),
  KEY `idx_response_status` (`response_status`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='求助响应记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `help_response`
--

LOCK TABLES `help_response` WRITE;
/*!40000 ALTER TABLE `help_response` DISABLE KEYS */;
INSERT INTO `help_response` VALUES (1,1,2,650.50,1,'2026-04-27 10:13:24'),(2,3,1,880.00,1,'2026-04-27 10:13:24'),(3,2,1,1200.00,2,'2026-04-27 10:13:24'),(4,2,1,NULL,1,'2026-05-15 19:18:24');
/*!40000 ALTER TABLE `help_response` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_admin`
--

DROP TABLE IF EXISTS `sys_admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_admin` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '管理员ID',
  `username` varchar(50) NOT NULL COMMENT '管理员账号',
  `password` varchar(100) NOT NULL COMMENT '管理员密码',
  `nickname` varchar(50) DEFAULT NULL COMMENT '管理员昵称',
  `role` varchar(30) DEFAULT 'ADMIN' COMMENT '角色：SUPER_ADMIN超级管理员，ADMIN普通管理员',
  `status` tinyint DEFAULT '1' COMMENT '状态：0禁用，1启用',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='管理员表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_admin`
--

LOCK TABLES `sys_admin` WRITE;
/*!40000 ALTER TABLE `sys_admin` DISABLE KEYS */;
INSERT INTO `sys_admin` VALUES (1,'admin','$2a$10$TAZar4uBq4E4WqghR9kwl.d3jzAoVYGS0taiaqeu/vFH/qop0ShPO','系统管理员','SUPER_ADMIN',1,'2026-04-25 19:16:53','2026-04-28 21:18:52'),(2,'admin2','$2a$10$NfEK28NPgX7gHWeXO22Ps.MIejoGhdNoxsdu3t1iEIuz1QSYwu3Zy','普通管理员','ADMIN',1,'2026-04-26 14:13:17','2026-05-15 13:54:33');
/*!40000 ALTER TABLE `sys_admin` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-19 10:02:42
