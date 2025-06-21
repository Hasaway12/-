/*
 Navicat Premium Data Transfer

 Source Server         : Mysql8.0
 Source Server Type    : MySQL
 Source Server Version : 80012 (8.0.12)
 Source Host           : localhost:3306
 Source Schema         : medical_management_system

 Target Server Type    : MySQL
 Target Server Version : 80012 (8.0.12)
 File Encoding         : 65001

 Date: 21/06/2025 13:56:24
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for appointment
-- ----------------------------
DROP TABLE IF EXISTS `appointment`;
CREATE TABLE `appointment`  (
  `appointment_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '预约ID',
  `pt_id` int(11) NOT NULL COMMENT '病人ID',
  `doctor_id` int(11) NOT NULL COMMENT '医生ID',
  `receptionist_id` int(11) NULL DEFAULT NULL COMMENT '接待员ID',
  `appointment_date` date NOT NULL COMMENT '预约日期',
  `appointment_time` time NOT NULL COMMENT '预约时间',
  `department` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '科室',
  `appointment_type` enum('初诊','复诊','急诊') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '预约类型',
  `status` enum('已预约','已就诊','已取消','已完成') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '已预约' COMMENT '状态',
  `symptoms` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '主要症状',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '备注',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`appointment_id`) USING BTREE,
  INDEX `pt_id`(`pt_id`) USING BTREE,
  INDEX `doctor_id`(`doctor_id`) USING BTREE,
  INDEX `receptionist_id`(`receptionist_id`) USING BTREE,
  INDEX `idx_appointment_date`(`appointment_date`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '就诊预约表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of appointment
-- ----------------------------
INSERT INTO `appointment` VALUES (1, 1, 1, 6, '2025-06-22', '09:00:00', '内科', '初诊', '已预约', '发热、咳嗽', '患者有轻微发热', '2025-06-21 01:42:14', '2025-06-20 19:57:13');
INSERT INTO `appointment` VALUES (2, 2, 2, 6, '2024-11-20', '10:00:00', '外科', '复诊', '已预约', '伤口检查', '术后复查', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `appointment` VALUES (3, 3, 3, 6, '2024-11-21', '14:00:00', '儿科', '初诊', '已预约', '发热、呕吐', '儿童患者', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `appointment` VALUES (4, 4, 8, 6, '2024-11-21', '15:00:00', '妇科', '初诊', '已预约', '月经不调', '需要详细检查', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `appointment` VALUES (5, 5, 1, 6, '2024-11-22', '09:30:00', '内科', '复诊', '已预约', '血压检查', '高血压患者', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `appointment` VALUES (6, 6, 2, 6, '2024-11-22', '11:00:00', '外科', '初诊', '已预约', '腹痛', '急性腹痛', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `appointment` VALUES (7, 7, 3, 6, '2024-11-23', '10:00:00', '儿科', '初诊', '已预约', '咳嗽、流鼻涕', '感冒症状', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `appointment` VALUES (8, 8, 1, 6, '2024-11-23', '16:00:00', '内科', '初诊', '已预约', '胃痛', '饭后胃痛', '2025-06-21 01:42:14', '2025-06-21 01:42:14');

-- ----------------------------
-- Table structure for case_record
-- ----------------------------
DROP TABLE IF EXISTS `case_record`;
CREATE TABLE `case_record`  (
  `case_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '病历ID',
  `pt_id` int(11) NOT NULL COMMENT '病人ID',
  `doctor_id` int(11) NOT NULL COMMENT '医生ID',
  `nurse_id` int(11) NULL DEFAULT NULL COMMENT '护士ID',
  `visit_date` date NOT NULL COMMENT '就诊日期',
  `visit_time` time NOT NULL COMMENT '就诊时间',
  `department` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '科室',
  `chief_complaint` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '主诉',
  `present_illness` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '现病史',
  `past_history` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '既往史',
  `physical_examination` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '体格检查',
  `auxiliary_examination` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '辅助检查',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '病情描述',
  `diagnosis` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '诊断结果',
  `therapy` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '治疗方案',
  `doctor_advice` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '医嘱',
  `follow_up_date` date NULL DEFAULT NULL COMMENT '复诊日期',
  `status` enum('就诊中','已完成','需复诊') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '就诊中' COMMENT '状态',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`case_id`) USING BTREE,
  INDEX `pt_id`(`pt_id`) USING BTREE,
  INDEX `doctor_id`(`doctor_id`) USING BTREE,
  INDEX `nurse_id`(`nurse_id`) USING BTREE,
  INDEX `idx_case_visit_date`(`visit_date`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '病人病历记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of case_record
-- ----------------------------
INSERT INTO `case_record` VALUES (1, 1, 1, 4, '2024-11-20', '09:00:00', '内科', '发热咳嗽3天', '', '', '', '', '患者发热39℃，干咳，无痰，伴有轻微头痛', '上呼吸道感染', '口服抗生素，多休息，多饮水', '按时服药，注意休息', NULL, '就诊中', '2025-06-21 01:42:14', '2025-06-20 19:57:30');
INSERT INTO `case_record` VALUES (2, 2, 2, 5, '2024-11-20', '10:00:00', '外科', '术后复查', '222', '', '', '', '阑尾切除术后7天，伤口愈合良好，无感染征象', '阑尾切除术后', '继续换药，观察伤口', '保持伤口干燥', NULL, '就诊中', '2025-06-21 01:42:14', '2025-06-20 19:38:03');
INSERT INTO `case_record` VALUES (3, 3, 3, 4, '2024-11-21', '14:00:00', '儿科', '发热呕吐2天', '', '', '', '', '患儿发热38.5℃，呕吐3次，精神稍差', '急性胃肠炎', '对症治疗，补液', '清淡饮食，注意补水', NULL, '就诊中', '2025-06-21 01:42:14', '2025-06-20 19:55:18');
INSERT INTO `case_record` VALUES (4, 4, 8, 5, '2024-11-21', '15:00:00', '妇科', '月经不调3个月', NULL, NULL, NULL, NULL, '月经周期不规律，量少，色暗', '月经不调', '中药调理，生活规律', '注意休息，避免熬夜', NULL, '就诊中', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `case_record` VALUES (5, 5, 1, 4, '2024-11-22', '09:30:00', '内科', '血压升高1周', '', '', '', '', '血压160/100mmHg，头晕，无其他不适', '高血压', '降压药物治疗', '定期监测血压', NULL, '就诊中', '2025-06-21 01:42:14', '2025-06-20 19:37:36');
INSERT INTO `case_record` VALUES (6, 6, 2, 5, '2024-11-22', '11:00:00', '外科', '急性腹痛6小时', NULL, NULL, NULL, NULL, '右下腹痛，压痛明显，反跳痛阳性', '急性阑尾炎', '急诊手术治疗', '术前准备，禁食水', NULL, '就诊中', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `case_record` VALUES (7, 7, 3, 4, '2024-11-23', '10:00:00', '儿科', '咳嗽流涕5天', NULL, NULL, NULL, NULL, '咳嗽有痰，流清涕，体温正常', '上呼吸道感染', '止咳化痰，抗病毒治疗', '多饮水，注意保暖', NULL, '就诊中', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `case_record` VALUES (8, 8, 1, 4, '2024-11-23', '16:00:00', '内科', '餐后胃痛2周', NULL, NULL, NULL, NULL, '餐后1小时胃部疼痛，反酸', '慢性胃炎', '制酸剂，胃粘膜保护剂', '规律饮食，少食多餐', NULL, '就诊中', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `case_record` VALUES (9, 1, 1, 4, '2025-06-20', '03:37:00', '内科', '22', '22', '', '', '', '22', '2222', '22', '', NULL, '就诊中', '2025-06-20 19:37:50', '2025-06-20 19:37:50');

-- ----------------------------
-- Table structure for drug_info
-- ----------------------------
DROP TABLE IF EXISTS `drug_info`;
CREATE TABLE `drug_info`  (
  `drug_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '药品ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '药品名称',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '药品分类',
  `specification` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '规格',
  `unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '单位',
  `price` decimal(10, 2) NOT NULL COMMENT '单价',
  `stock_quantity` int(11) NOT NULL DEFAULT 0 COMMENT '库存数量',
  `manufacturer` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生产厂家',
  `production_date` date NULL DEFAULT NULL COMMENT '生产日期',
  `expiry_date` date NULL DEFAULT NULL COMMENT '有效期',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '药品说明',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`drug_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '药品信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of drug_info
-- ----------------------------
INSERT INTO `drug_info` VALUES (1, '阿莫西林胶囊1', '抗生素', '0.25g*24粒', '盒', 15.50, 175, '华北制药', '2024-01-01', '2026-01-01', '用于敏感菌引起的感染', '2025-06-21 01:42:14', '2025-06-20 19:56:58');
INSERT INTO `drug_info` VALUES (2, '布洛芬缓释胶囊', '解热镇痛', '0.3g*10粒', '盒', 8.80, 150, '扬子江药业', '2024-02-01', '2026-02-01', '用于缓解疼痛和发热', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `drug_info` VALUES (3, '复方感冒灵颗粒', '感冒用药', '10g*6袋', '盒', 12.50, 300, '同仁堂', '2024-01-15', '2026-01-15', '用于风寒感冒', '2025-06-21 01:42:14', '2025-06-20 19:28:01');
INSERT INTO `drug_info` VALUES (4, '维生素C片', '维生素类', '0.1g*100片', '瓶', 6.00, 500, '石药集团', '2024-02-15', '2026-02-15', '补充维生素C', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `drug_info` VALUES (5, '蒙脱石散', '止泻药', '3g*6袋', '盒', 18.00, 120, '博雅制药', '2024-01-20', '2026-01-20', '用于急性腹泻', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `drug_info` VALUES (6, '左氧氟沙星片', '抗生素', '0.5g*6片', '盒', 25.00, 80, '齐鲁制药', '2024-02-10', '2026-02-10', '用于敏感菌感染', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `drug_info` VALUES (7, '甘草片', '止咳化痰', '50片', '瓶', 4.50, 700, '太极集团', '2024-01-25', '2026-01-25', '用于止咳化痰', '2025-06-21 01:42:14', '2025-06-20 19:27:40');
INSERT INTO `drug_info` VALUES (8, '头孢克肟胶囊', '抗生素', '0.1g*12粒', '盒', 32.00, 90, '罗欣药业', '2024-02-05', '2026-02-05', '用于敏感菌感染', '2025-06-21 01:42:14', '2025-06-21 01:42:14');

-- ----------------------------
-- Table structure for drug_stock_log
-- ----------------------------
DROP TABLE IF EXISTS `drug_stock_log`;
CREATE TABLE `drug_stock_log`  (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `drug_id` int(11) NOT NULL,
  `operation_type` enum('减少','增加') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity_change` int(11) NOT NULL,
  `old_stock` int(11) NOT NULL,
  `new_stock` int(11) NOT NULL,
  `operation_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `operation_reason` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`log_id`) USING BTREE,
  INDEX `drug_id`(`drug_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '药品库存变化日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of drug_stock_log
-- ----------------------------
INSERT INTO `drug_stock_log` VALUES (1, 1, '减少', 5, 200, 195, '2025-06-21 02:09:51', '库存更新操作');
INSERT INTO `drug_stock_log` VALUES (2, 7, '增加', 300, 400, 700, '2025-06-21 03:27:39', '库存更新操作');
INSERT INTO `drug_stock_log` VALUES (3, 3, '增加', 200, 300, 500, '2025-06-21 03:27:51', '库存更新操作');
INSERT INTO `drug_stock_log` VALUES (4, 3, '减少', 200, 500, 300, '2025-06-21 03:28:01', '库存更新操作');
INSERT INTO `drug_stock_log` VALUES (5, 1, '减少', 20, 195, 175, '2025-06-21 03:56:58', '库存更新操作');

-- ----------------------------
-- Table structure for patient_info
-- ----------------------------
DROP TABLE IF EXISTS `patient_info`;
CREATE TABLE `patient_info`  (
  `pt_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '病人ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '姓名',
  `gender` enum('男','女') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '性别',
  `age` int(11) NOT NULL COMMENT '年龄',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '电话',
  `id_card` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '身份证号',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '地址',
  `emergency_contact` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '紧急联系人',
  `emergency_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '紧急联系电话',
  `blood_type` enum('A','B','AB','O') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '血型',
  `allergy_history` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '过敏史',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`pt_id`) USING BTREE,
  UNIQUE INDEX `id_card`(`id_card`) USING BTREE,
  INDEX `idx_patient_name`(`name`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '病人基本信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of patient_info
-- ----------------------------
INSERT INTO `patient_info` VALUES (1, '陈小明11231231231', '男', 25, '15900159001', '110101199901011234', '北京市朝阳区', '陈父', '15900159002', 'A', '无已知过敏', '2025-06-21 01:42:14', '2025-06-20 19:56:37');
INSERT INTO `patient_info` VALUES (2, '刘小红', '女', 30, '15900159003', '110101199401011235', '北京市海淀区', '刘夫', '15900159004', 'B', '青霉素过敏', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `patient_info` VALUES (3, '张小强', '男', 35, '15900159005', '110101198901011236', '北京市西城区', '张妻', '15900159006', 'O', '无已知过敏', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `patient_info` VALUES (4, '李小花', '女', 28, '15900159007', '110101199601011237', '北京市东城区', '李母', '15900159008', 'AB', '花粉过敏', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `patient_info` VALUES (5, '王小军', '男', 40, '15900159009', '110101198401011238', '北京市丰台区', '王妻', '15900159010', 'A', '海鲜过敏', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `patient_info` VALUES (6, '赵小美', '女', 22, '15900159011', '110101200201011239', '北京市石景山区', '赵父', '15900159012', 'B', '无已知过敏', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `patient_info` VALUES (7, '孙小亮', '男', 45, '15900159013', '110101197901011240', '北京市门头沟区', '孙妻', '15900159014', 'O', '无已知过敏', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `patient_info` VALUES (8, '周小丽', '女', 33, '15900159015', '110101199101011241', '北京市房山区', '周夫', '15900159016', 'A', '药物过敏', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `patient_info` VALUES (9, '1234', '男', 25, '15159012568', '405235211231231231', '香港', '11231', '123333334', 'A', '2222', '2025-06-20 18:16:58', '2025-06-20 18:16:58');

-- ----------------------------
-- Table structure for prescription
-- ----------------------------
DROP TABLE IF EXISTS `prescription`;
CREATE TABLE `prescription`  (
  `prescription_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '处方ID',
  `case_id` int(11) NOT NULL COMMENT '病历ID',
  `drug_id` int(11) NOT NULL COMMENT '药品ID',
  `quantity` int(11) NOT NULL COMMENT '数量',
  `dosage` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用法用量',
  `frequency` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '使用频率',
  `duration` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '使用时长',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '用药备注',
  `price` decimal(10, 2) NOT NULL COMMENT '总价',
  `status` enum('已开具','已配药','已发药') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '已开具' COMMENT '状态',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`prescription_id`) USING BTREE,
  INDEX `drug_id`(`drug_id`) USING BTREE,
  INDEX `idx_prescription_case`(`case_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '处方表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of prescription
-- ----------------------------
INSERT INTO `prescription` VALUES (1, 1, 1, 2, '1粒', '每日3次', '7天', '饭后服用', 31.00, '已开具', '2025-06-21 01:42:14', '2025-06-20 19:57:36');
INSERT INTO `prescription` VALUES (2, 1, 3, 1, '1袋', '每日3次', '5天', '温水冲服', 12.50, '已开具', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `prescription` VALUES (3, 2, 1, 1, '1粒', '每日2次', '5天', '预防感染', 15.50, '已开具', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `prescription` VALUES (4, 3, 5, 1, '1袋', '每日3次', '3天', '空腹服用', 18.00, '已开具', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `prescription` VALUES (5, 3, 4, 1, '2片', '每日1次', '7天', '增强免疫', 6.00, '已开具', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `prescription` VALUES (6, 4, 4, 2, '2片', '每日1次', '30天', '补充营养', 12.00, '已开具', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `prescription` VALUES (7, 5, 2, 1, '1粒', '每日2次', '14天', '饭后服用', 8.80, '已开具', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `prescription` VALUES (8, 6, 6, 1, '1片', '每日2次', '7天', '饭后服用', 25.00, '已开具', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `prescription` VALUES (9, 7, 7, 1, '2片', '每日3次', '7天', '含服', 4.50, '已开具', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `prescription` VALUES (10, 7, 4, 1, '2片', '每日1次', '7天', '增强免疫', 6.00, '已开具', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `prescription` VALUES (11, 8, 5, 1, '1袋', '每日3次', '5天', '饭前服用', 18.00, '已开具', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `prescription` VALUES (12, 1, 1, 5, '1粒', '每日2次', '3天', '测试处方', 77.50, '已开具', '2025-06-21 02:09:50', '2025-06-21 02:09:50');
INSERT INTO `prescription` VALUES (13, 1, 1, 1, '2', '2', '2', '2', 15.50, '已开具', '2025-06-20 19:34:34', '2025-06-20 19:34:34');

-- ----------------------------
-- Table structure for staff_info
-- ----------------------------
DROP TABLE IF EXISTS `staff_info`;
CREATE TABLE `staff_info`  (
  `staff_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '职工ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '姓名',
  `gender` enum('男','女') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '性别',
  `age` int(11) NOT NULL COMMENT '年龄',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '电话',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `position` enum('医生','护士','接待员','管理员') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '职位',
  `department` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '科室',
  `hire_date` date NOT NULL COMMENT '入职日期',
  `salary` decimal(10, 2) NOT NULL COMMENT '薪资',
  `status` enum('在职','离职') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '在职' COMMENT '状态',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`staff_id`) USING BTREE,
  INDEX `idx_staff_position`(`position`) USING BTREE,
  INDEX `idx_staff_hire_date`(`hire_date`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '诊所职工信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of staff_info
-- ----------------------------
INSERT INTO `staff_info` VALUES (1, '张医生', '男', 35, '13800138001', 'zhang@clinic.com', '医生', '内科', '2024-01-15', 8000.00, '在职', '2025-06-21 01:42:14', '2025-06-20 19:56:25');
INSERT INTO `staff_info` VALUES (2, '李医生', '女', 32, '13800138002', 'li@clinic.com', '医生', '外科', '2024-02-20', 7500.00, '在职', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `staff_info` VALUES (3, '王医生', '男', 40, '13800138003', 'wang@clinic.com', '医生', '儿科', '2024-03-10', 8500.00, '在职', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `staff_info` VALUES (4, '赵护士', '女', 28, '13800138004', 'zhao@clinic.com', '护士', '内科', '2024-01-20', 4500.00, '在职', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `staff_info` VALUES (5, '钱护士', '女', 26, '13800138005', 'qian@clinic.com', '护士', '外科', '2024-02-25', 4200.00, '在职', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `staff_info` VALUES (6, '孙接待', '女', 24, '13800138006', 'sun@clinic.com', '接待员', '前台', '2024-01-10', 3500.00, '在职', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `staff_info` VALUES (7, '周管理', '男', 45, '13800138007', 'zhou@clinic.com', '管理员', '行政', '2024-01-05', 12000.00, '在职', '2025-06-21 01:42:14', '2025-06-21 01:42:14');
INSERT INTO `staff_info` VALUES (8, '吴医生', '女', 38, '13800138008', 'wu@clinic.com', '医生', '妇科', '2024-04-01', 8200.00, '在职', '2025-06-21 01:42:14', '2025-06-21 01:42:14');

-- ----------------------------
-- View structure for v_patients
-- ----------------------------
DROP VIEW IF EXISTS `v_patients`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_patients` AS select `pa`.`pt_id` AS `pt_id`,`pa`.`name` AS `病人姓名`,`pa`.`gender` AS `性别`,`pa`.`age` AS `年龄`,`pa`.`phone` AS `电话`,`pa`.`address` AS `地址`,`pa`.`blood_type` AS `血型`,`pa`.`allergy_history` AS `过敏史`,`c`.`case_id` AS `case_id`,`c`.`visit_date` AS `就诊日期`,`c`.`department` AS `就诊科室`,`c`.`description` AS `病情描述`,`c`.`diagnosis` AS `诊断结果`,`c`.`therapy` AS `治疗方案`,`s`.`name` AS `主治医生`,`n`.`name` AS `护理护士`,`c`.`status` AS `就诊状态` from (((`patient_info` `pa` left join `case_record` `c` on((`pa`.`pt_id` = `c`.`pt_id`))) left join `staff_info` `s` on((`c`.`doctor_id` = `s`.`staff_id`))) left join `staff_info` `n` on((`c`.`nurse_id` = `n`.`staff_id`)));

-- ----------------------------
-- Procedure structure for add_patient
-- ----------------------------
DROP PROCEDURE IF EXISTS `add_patient`;
delimiter ;;
CREATE PROCEDURE `add_patient`(IN p_pt_id INT,
    IN p_doctor_id INT,
    IN p_nurse_id INT,
    IN p_visit_date DATE,
    IN p_visit_time TIME,
    IN p_department VARCHAR(50),
    IN p_description TEXT,
    IN p_diagnosis TEXT,
    IN p_therapy TEXT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- 插入病历记录
    INSERT INTO case_record (
        pt_id, doctor_id, nurse_id, visit_date, visit_time, 
        department, description, diagnosis, therapy
    ) VALUES (
        p_pt_id, p_doctor_id, p_nurse_id, p_visit_date, p_visit_time,
        p_department, p_description, p_diagnosis, p_therapy
    );
    
    -- 对应医生薪资增加99
    UPDATE staff_info 
    SET salary = salary + 99 
    WHERE staff_id = p_doctor_id AND position = '医生';
    
    COMMIT;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for add_prescription
-- ----------------------------
DROP PROCEDURE IF EXISTS `add_prescription`;
delimiter ;;
CREATE PROCEDURE `add_prescription`(IN p_case_id INT,
    IN p_drug_id INT,
    IN p_quantity INT,
    IN p_dosage VARCHAR(100),
    IN p_frequency VARCHAR(50),
    IN p_duration VARCHAR(50),
    IN p_notes TEXT,
    OUT p_remaining_stock INT)
BEGIN
    DECLARE current_stock INT;
    DECLARE drug_price DECIMAL(10,2);
    DECLARE total_price DECIMAL(10,2);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- 检查库存是否充足
    SELECT stock_quantity, price INTO current_stock, drug_price
    FROM drug_info 
    WHERE drug_id = p_drug_id;
    
    IF current_stock < p_quantity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '库存不足，无法开具处方';
    END IF;
    
    -- 计算总价
    SET total_price = drug_price * p_quantity;
    
    -- 插入处方记录
    INSERT INTO prescription (
        case_id, drug_id, quantity, dosage, frequency, 
        duration, notes, price
    ) VALUES (
        p_case_id, p_drug_id, p_quantity, p_dosage, p_frequency,
        p_duration, p_notes, total_price
    );
    
    -- 扣除库存
    UPDATE drug_info 
    SET stock_quantity = stock_quantity - p_quantity 
    WHERE drug_id = p_drug_id;
    
    -- 获取扣除后的库存数量
    SELECT stock_quantity INTO p_remaining_stock
    FROM drug_info 
    WHERE drug_id = p_drug_id;
    
    COMMIT;
END
;;
delimiter ;

-- ----------------------------
-- Function structure for check_salary_level
-- ----------------------------
DROP FUNCTION IF EXISTS `check_salary_level`;
delimiter ;;
CREATE FUNCTION `check_salary_level`(id INT)
 RETURNS varchar(8) CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci
  READS SQL DATA 
  DETERMINISTIC
BEGIN
    DECLARE u_salary DECIMAL(10,2);
    DECLARE salary_level VARCHAR(8);
    
    SELECT salary INTO u_salary 
    FROM staff_info 
    WHERE staff_id = id AND status = '在职';
    
    IF u_salary IS NULL THEN
        SET salary_level = '无效用户';
    ELSEIF u_salary < 5000 THEN
        SET salary_level = '一般';
    ELSEIF u_salary >= 5000 AND u_salary < 10000 THEN
        SET salary_level = '中等';
    ELSE
        SET salary_level = '高薪';
    END IF;
    
    RETURN salary_level;
END
;;
delimiter ;

-- ----------------------------
-- Function structure for get_user_type_by_id
-- ----------------------------
DROP FUNCTION IF EXISTS `get_user_type_by_id`;
delimiter ;;
CREATE FUNCTION `get_user_type_by_id`(id INT)
 RETURNS varchar(300) CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci
  READS SQL DATA 
  DETERMINISTIC
BEGIN
    DECLARE user_type VARCHAR(300);
    
    SELECT CONCAT(position, '-', department, '(', name, ')') 
    INTO user_type
    FROM staff_info 
    WHERE staff_id = id AND status = '在职';
    
    IF user_type IS NULL THEN
        SET user_type = '未找到该职工或职工已离职';
    END IF;
    
    RETURN user_type;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table drug_info
-- ----------------------------
DROP TRIGGER IF EXISTS `log_drug_stock_change`;
delimiter ;;
CREATE TRIGGER `log_drug_stock_change` AFTER UPDATE ON `drug_info` FOR EACH ROW BEGIN
    IF NEW.stock_quantity != OLD.stock_quantity THEN
        INSERT INTO drug_stock_log (
            drug_id, 
            operation_type, 
            quantity_change, 
            old_stock, 
            new_stock,
            operation_reason
        ) VALUES (
            NEW.drug_id,
            CASE WHEN NEW.stock_quantity < OLD.stock_quantity THEN '减少' ELSE '增加' END,
            ABS(NEW.stock_quantity - OLD.stock_quantity),
            OLD.stock_quantity,
            NEW.stock_quantity,
            '库存更新操作'
        );
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table prescription
-- ----------------------------
DROP TRIGGER IF EXISTS `update_drug_stock_after_prescription`;
delimiter ;;
CREATE TRIGGER `update_drug_stock_after_prescription` AFTER INSERT ON `prescription` FOR EACH ROW BEGIN
    -- 记录库存变化日志到临时表（这里简化为更新药品的更新时间）
    UPDATE drug_info 
    SET updated_at = CURRENT_TIMESTAMP
    WHERE drug_id = NEW.drug_id;
    
    -- 如果库存过低，可以在这里添加预警逻辑
    -- 这里简化实现
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
