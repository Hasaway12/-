-- 医疗信息管理系统数据库创建脚本
-- 创建时间：2024年

-- 创建数据库
DROP DATABASE IF EXISTS medical_management_system;
CREATE DATABASE medical_management_system DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE medical_management_system;

-- 1. 诊所职工信息表
CREATE TABLE staff_info (
    staff_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '职工ID',
    name VARCHAR(50) NOT NULL COMMENT '姓名',
    gender ENUM('男', '女') NOT NULL COMMENT '性别',
    age INT NOT NULL COMMENT '年龄',
    phone VARCHAR(20) NOT NULL COMMENT '电话',
    email VARCHAR(100) COMMENT '邮箱',
    position ENUM('医生', '护士', '接待员', '管理员') NOT NULL COMMENT '职位',
    department VARCHAR(50) COMMENT '科室',
    hire_date DATE NOT NULL COMMENT '入职日期',
    salary DECIMAL(10,2) NOT NULL COMMENT '薪资',
    status ENUM('在职', '离职') DEFAULT '在职' COMMENT '状态',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) COMMENT '诊所职工信息表';

-- 2. 病人基本信息表
CREATE TABLE patient_info (
    pt_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '病人ID',
    name VARCHAR(50) NOT NULL COMMENT '姓名',
    gender ENUM('男', '女') NOT NULL COMMENT '性别',
    age INT NOT NULL COMMENT '年龄',
    phone VARCHAR(20) NOT NULL COMMENT '电话',
    id_card VARCHAR(18) UNIQUE COMMENT '身份证号',
    address VARCHAR(200) COMMENT '地址',
    emergency_contact VARCHAR(50) COMMENT '紧急联系人',
    emergency_phone VARCHAR(20) COMMENT '紧急联系电话',
    blood_type ENUM('A', 'B', 'AB', 'O') COMMENT '血型',
    allergy_history TEXT COMMENT '过敏史',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) COMMENT '病人基本信息表';

-- 3. 药品信息表
CREATE TABLE drug_info (
    drug_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '药品ID',
    name VARCHAR(100) NOT NULL COMMENT '药品名称',
    category VARCHAR(50) NOT NULL COMMENT '药品分类',
    specification VARCHAR(100) COMMENT '规格',
    unit VARCHAR(20) NOT NULL COMMENT '单位',
    price DECIMAL(10,2) NOT NULL COMMENT '单价',
    stock_quantity INT NOT NULL DEFAULT 0 COMMENT '库存数量',
    manufacturer VARCHAR(100) COMMENT '生产厂家',
    production_date DATE COMMENT '生产日期',
    expiry_date DATE COMMENT '有效期',
    description TEXT COMMENT '药品说明',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) COMMENT '药品信息表';

-- 4. 就诊预约表
CREATE TABLE appointment (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '预约ID',
    pt_id INT NOT NULL COMMENT '病人ID',
    doctor_id INT NOT NULL COMMENT '医生ID',
    receptionist_id INT COMMENT '接待员ID',
    appointment_date DATE NOT NULL COMMENT '预约日期',
    appointment_time TIME NOT NULL COMMENT '预约时间',
    department VARCHAR(50) NOT NULL COMMENT '科室',
    appointment_type ENUM('初诊', '复诊', '急诊') NOT NULL COMMENT '预约类型',
    status ENUM('已预约', '已就诊', '已取消', '已完成') DEFAULT '已预约' COMMENT '状态',
    symptoms TEXT COMMENT '主要症状',
    notes TEXT COMMENT '备注',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (pt_id) REFERENCES patient_info(pt_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES staff_info(staff_id) ON DELETE CASCADE,
    FOREIGN KEY (receptionist_id) REFERENCES staff_info(staff_id) ON DELETE SET NULL
) COMMENT '就诊预约表';

-- 5. 病人病历记录表
CREATE TABLE case_record (
    case_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '病历ID',
    pt_id INT NOT NULL COMMENT '病人ID',
    doctor_id INT NOT NULL COMMENT '医生ID',
    nurse_id INT COMMENT '护士ID',
    visit_date DATE NOT NULL COMMENT '就诊日期',
    visit_time TIME NOT NULL COMMENT '就诊时间',
    department VARCHAR(50) NOT NULL COMMENT '科室',
    chief_complaint TEXT COMMENT '主诉',
    present_illness TEXT COMMENT '现病史',
    past_history TEXT COMMENT '既往史',
    physical_examination TEXT COMMENT '体格检查',
    auxiliary_examination TEXT COMMENT '辅助检查',
    description TEXT NOT NULL COMMENT '病情描述',
    diagnosis TEXT NOT NULL COMMENT '诊断结果',
    therapy TEXT NOT NULL COMMENT '治疗方案',
    doctor_advice TEXT COMMENT '医嘱',
    follow_up_date DATE COMMENT '复诊日期',
    status ENUM('就诊中', '已完成', '需复诊') DEFAULT '就诊中' COMMENT '状态',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (pt_id) REFERENCES patient_info(pt_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES staff_info(staff_id) ON DELETE CASCADE,
    FOREIGN KEY (nurse_id) REFERENCES staff_info(staff_id) ON DELETE SET NULL
) COMMENT '病人病历记录表';

-- 6. 处方表
CREATE TABLE prescription (
    prescription_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '处方ID',
    case_id INT NOT NULL COMMENT '病历ID',
    drug_id INT NOT NULL COMMENT '药品ID',
    quantity INT NOT NULL COMMENT '数量',
    dosage VARCHAR(100) NOT NULL COMMENT '用法用量',
    frequency VARCHAR(50) NOT NULL COMMENT '使用频率',
    duration VARCHAR(50) NOT NULL COMMENT '使用时长',
    notes TEXT COMMENT '用药备注',
    price DECIMAL(10,2) NOT NULL COMMENT '总价',
    status ENUM('已开具', '已配药', '已发药') DEFAULT '已开具' COMMENT '状态',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (case_id) REFERENCES case_record(case_id) ON DELETE CASCADE,
    FOREIGN KEY (drug_id) REFERENCES drug_info(drug_id) ON DELETE CASCADE
) COMMENT '处方表';

-- 创建索引优化查询性能
CREATE INDEX idx_staff_position ON staff_info(position);
CREATE INDEX idx_staff_hire_date ON staff_info(hire_date);
CREATE INDEX idx_patient_name ON patient_info(name);
CREATE INDEX idx_appointment_date ON appointment(appointment_date);
CREATE INDEX idx_case_visit_date ON case_record(visit_date);
CREATE INDEX idx_prescription_case ON prescription(case_id);

-- 显示所有表结构
SHOW TABLES; 