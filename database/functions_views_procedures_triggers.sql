-- 医疗信息管理系统函数、视图、存储过程、触发器脚本
USE medical_management_system;

-- ===================================================================
-- 2.2 函数
-- ===================================================================

-- (1) 创建函数：根据诊所职工id获取职工类型
DELIMITER //
CREATE FUNCTION get_user_type_by_id(id INT)
RETURNS VARCHAR(300)
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
END//
DELIMITER ;

-- (2) 创建函数：输入用户id，查看用户薪资水平
DELIMITER //
CREATE FUNCTION check_salary_level(id INT) 
RETURNS VARCHAR(8)
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
END//
DELIMITER ;

-- 测试函数
SELECT '=== 函数测试 ===' AS '';
SELECT 
    staff_id,
    name,
    position,
    get_user_type_by_id(staff_id) AS 职工类型,
    salary,
    check_salary_level(staff_id) AS 薪资水平
FROM staff_info 
WHERE position IN ('医生', '护士')
ORDER BY staff_id;

-- ===================================================================
-- 2.3 视图
-- ===================================================================

-- (1) 创建病人视图：要求显示病人基本信息和病历信息
CREATE VIEW v_patients AS 
SELECT 
    pa.pt_id,
    pa.name AS 病人姓名,
    pa.gender AS 性别,
    pa.age AS 年龄,
    pa.phone AS 电话,
    pa.address AS 地址,
    pa.blood_type AS 血型,
    pa.allergy_history AS 过敏史,
    c.case_id,
    c.visit_date AS 就诊日期,
    c.department AS 就诊科室,
    c.description AS 病情描述,
    c.diagnosis AS 诊断结果,
    c.therapy AS 治疗方案,
    s.name AS 主治医生,
    n.name AS 护理护士,
    c.status AS 就诊状态
FROM patient_info pa
LEFT JOIN case_record c ON pa.pt_id = c.pt_id
LEFT JOIN staff_info s ON c.doctor_id = s.staff_id
LEFT JOIN staff_info n ON c.nurse_id = n.staff_id;

-- 查看视图数据
SELECT '=== 病人视图数据 ===' AS '';
SELECT * FROM v_patients ORDER BY pt_id, 就诊日期;

-- ===================================================================
-- 2.4 存储过程
-- ===================================================================

-- (1) 创建存储过程：每增加一个病人，对应的诊断医生薪资自动增加99
DELIMITER //
CREATE PROCEDURE add_patient(
    IN p_pt_id INT,
    IN p_doctor_id INT,
    IN p_nurse_id INT,
    IN p_visit_date DATE,
    IN p_visit_time TIME,
    IN p_department VARCHAR(50),
    IN p_description TEXT,
    IN p_diagnosis TEXT,
    IN p_therapy TEXT
)
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
END//
DELIMITER ;

-- (2) 创建存储过程：每创建一个处方，需要从药品信息表的药品库存里扣除处方所包含的相应药品数量，并输出扣除后的该药品的库存数量
DELIMITER //
CREATE PROCEDURE add_prescription(
    IN p_case_id INT,
    IN p_drug_id INT,
    IN p_quantity INT,
    IN p_dosage VARCHAR(100),
    IN p_frequency VARCHAR(50),
    IN p_duration VARCHAR(50),
    IN p_notes TEXT,
    OUT p_remaining_stock INT
)
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
END//
DELIMITER ;

-- ===================================================================
-- 2.5 触发器
-- ===================================================================

-- (1) 触发器功能：实时更新药品库存量（注意对比触发器执行前后的内容）
DELIMITER //
CREATE TRIGGER update_drug_stock_after_prescription
AFTER INSERT ON prescription
FOR EACH ROW
BEGIN
    -- 记录库存变化日志到临时表（这里简化为更新药品的更新时间）
    UPDATE drug_info 
    SET updated_at = CURRENT_TIMESTAMP
    WHERE drug_id = NEW.drug_id;
    
    -- 如果库存过低，可以在这里添加预警逻辑
    -- 这里简化实现
END//
DELIMITER ;

-- 创建药品库存变化日志表
CREATE TABLE drug_stock_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    drug_id INT NOT NULL,
    operation_type ENUM('减少', '增加') NOT NULL,
    quantity_change INT NOT NULL,
    old_stock INT NOT NULL,
    new_stock INT NOT NULL,
    operation_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    operation_reason VARCHAR(200),
    FOREIGN KEY (drug_id) REFERENCES drug_info(drug_id)
) COMMENT '药品库存变化日志表';

-- 更新触发器以记录详细日志
DELIMITER //
CREATE TRIGGER log_drug_stock_change
AFTER UPDATE ON drug_info
FOR EACH ROW
BEGIN
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
END//
DELIMITER ;

-- 测试存储过程和触发器
SELECT '=== 测试前药品库存 ===' AS '';
SELECT drug_id, name, stock_quantity FROM drug_info WHERE drug_id = 1;

-- 测试创建处方的存储过程
CALL add_prescription(1, 1, 5, '1粒', '每日2次', '3天', '测试处方', @remaining_stock);
SELECT CONCAT('剩余库存：', @remaining_stock) AS 处方创建结果;

SELECT '=== 测试后药品库存 ===' AS '';
SELECT drug_id, name, stock_quantity FROM drug_info WHERE drug_id = 1;

SELECT '=== 库存变化日志 ===' AS '';
SELECT * FROM drug_stock_log ORDER BY log_id DESC LIMIT 5; 