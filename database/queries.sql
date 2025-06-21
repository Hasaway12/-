-- 医疗信息管理系统查询脚本
USE medical_management_system;

-- ===================================================================
-- 2.1 数据查询
-- ===================================================================

-- (1) 多表连接查询 join on
-- 查询入职在某一时间（如2024年）入职的医生中，每个医生治疗的病人，要求显示：医生姓名、治疗病人的数量，按治疗病人的数量从大到小排序。

SELECT '=== (1) 多表连接查询：2024年入职医生治疗病人统计 ===' AS '';

SELECT 
    s.name AS 医生姓名,
    COUNT(DISTINCT c.pt_id) AS 治疗病人数量,
    s.hire_date AS 入职日期,
    s.department AS 科室
FROM staff_info s 
INNER JOIN case_record c ON s.staff_id = c.doctor_id
WHERE s.position = '医生' 
  AND YEAR(s.hire_date) = 2024
GROUP BY s.staff_id, s.name, s.hire_date, s.department
ORDER BY 治疗病人数量 DESC, s.name;

-- (2) 高级查询 select 聚合函数 from where group by having
-- 查询用药种类大于1的病人，要求显示：病人id, 姓名，病情描述、诊断结果、治疗方案，用药数量，按病人id排序

SELECT '=== (2) 高级查询：用药种类大于1的病人统计 ===' AS '';

SELECT 
    pa.pt_id AS 病人ID,
    pa.name AS 病人姓名,
    c.description AS 病情描述,
    c.diagnosis AS 诊断结果,
    c.therapy AS 治疗方案,
    COUNT(DISTINCT pr.drug_id) AS 用药种类数量,
    GROUP_CONCAT(DISTINCT d.name SEPARATOR ', ') AS 用药清单
FROM patient_info pa
INNER JOIN case_record c ON pa.pt_id = c.pt_id
INNER JOIN prescription pr ON c.case_id = pr.case_id
INNER JOIN drug_info d ON pr.drug_id = d.drug_id
GROUP BY pa.pt_id, pa.name, c.description, c.diagnosis, c.therapy
HAVING COUNT(DISTINCT pr.drug_id) > 1
ORDER BY pa.pt_id;

-- (3) 子查询 >= > <= = in >=all <all =any（任选2个）
-- 查询用药相同的病人，要求显示：药品名、用药使用量，病人姓名、性别、年龄、病情描述、诊断结果、治疗方案，先按药品名升序排，后按药品使用量降序排

SELECT '=== (3-1) 子查询：查询用药相同的病人（使用IN） ===' AS '';

SELECT 
    dr.name AS 药品名,
    pr.quantity AS 用药使用量,
    pa.name AS 病人姓名,
    pa.gender AS 性别,
    pa.age AS 年龄,
    ca.description AS 病情描述,
    ca.diagnosis AS 诊断结果,
    ca.therapy AS 治疗方案
FROM prescription pr
INNER JOIN drug_info dr ON pr.drug_id = dr.drug_id
INNER JOIN case_record ca ON pr.case_id = ca.case_id
INNER JOIN patient_info pa ON ca.pt_id = pa.pt_id
WHERE pr.drug_id IN (
    -- 子查询：找出被多个病人使用的药品
    SELECT drug_id 
    FROM prescription p2
    INNER JOIN case_record c2 ON p2.case_id = c2.case_id
    GROUP BY drug_id
    HAVING COUNT(DISTINCT c2.pt_id) > 1
)
ORDER BY dr.name ASC, pr.quantity DESC;

SELECT '=== (3-2) 子查询：查询薪资高于平均薪资的医生及其治疗病人数 ===' AS '';

SELECT 
    s.name AS 医生姓名,
    s.salary AS 薪资,
    s.department AS 科室,
    COUNT(DISTINCT c.pt_id) AS 治疗病人数,
    (SELECT AVG(salary) FROM staff_info WHERE position = '医生') AS 医生平均薪资
FROM staff_info s
LEFT JOIN case_record c ON s.staff_id = c.doctor_id
WHERE s.position = '医生' 
  AND s.salary >= ALL (
      SELECT AVG(salary) 
      FROM staff_info 
      WHERE position = '医生'
  )
GROUP BY s.staff_id, s.name, s.salary, s.department
ORDER BY s.salary DESC;

-- 额外查询：统计各科室医生数量和平均薪资
SELECT '=== 额外查询：各科室统计信息 ===' AS '';

SELECT 
    department AS 科室,
    COUNT(*) AS 医生数量,
    AVG(salary) AS 平均薪资,
    MIN(salary) AS 最低薪资,
    MAX(salary) AS 最高薪资
FROM staff_info 
WHERE position = '医生'
GROUP BY department
ORDER BY 平均薪资 DESC;

-- 额外查询：药品库存预警（库存少于100的药品）
SELECT '=== 额外查询：药品库存预警 ===' AS '';

SELECT 
    name AS 药品名称,
    category AS 分类,
    stock_quantity AS 库存数量,
    price AS 单价,
    CASE 
        WHEN stock_quantity < 50 THEN '严重不足'
        WHEN stock_quantity < 100 THEN '库存不足'
        ELSE '库存充足'
    END AS 库存状态
FROM drug_info
WHERE stock_quantity < 100
ORDER BY stock_quantity ASC; 