# 医疗信息管理系统

## 项目简介

本项目是一个基于Flask的医疗信息管理系统，专门为疫情期间的诊所设计，可以方便诊所实现医疗就诊信息管理，涵盖病人预约—接待员统计—医生看病—护士护理的整个就诊流程。

## 功能特性

### 数据库设计
- **6张核心数据表**：
  - 诊所职工信息表 (staff_info)
  - 病人基本信息表 (patient_info)
  - 药品信息表 (drug_info)
  - 就诊预约表 (appointment)
  - 病人病历记录表 (case_record)
  - 处方表 (prescription)

### 数据库功能
- **多表连接查询**：医生治疗病人统计、用药分析等
- **高级查询**：聚合函数、分组查询、条件过滤
- **子查询**：复杂数据分析和统计
- **数据库函数**：职工类型查询、薪资水平判断
- **视图**：病人信息综合视图
- **存储过程**：自动化业务逻辑处理
- **触发器**：实时库存更新和日志记录

### Web界面功能
- **职工管理**：增删改查职工信息
- **病人管理**：患者信息管理
- **药品管理**：库存管理、过期预警
- **预约管理**：就诊预约安排
- **病历管理**：诊断记录管理
- **处方管理**：用药记录跟踪

## 技术栈

- **后端**：Python Flask + SQLAlchemy
- **数据库**：MySQL 8.0+
- **前端**：Bootstrap 5 + Jinja2模板
- **图标**：Font Awesome
- **数据库驱动**：PyMySQL

## 安装部署

### 环境要求
- Python 3.8+
- MySQL 8.0+
- pip

### 安装步骤

1. **克隆项目**
```bash
git clone <project-url>
cd 医疗信息管理系统
```

2. **创建虚拟环境**
```bash
python -m venv venv
source venv/bin/activate  # Linux/Mac
# 或
venv\Scripts\activate  # Windows
```

3. **安装依赖**
```bash
pip install -r requirements.txt
```

4. **配置数据库**
- 确保MySQL服务运行
- 创建数据库用户（如果需要）
- 修改 `app.py` 中的数据库连接字符串：
```python
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://用户名:密码@localhost/medical_management_system'
```

5. **初始化数据库**
```bash
# 在MySQL中执行以下SQL文件
mysql -u root -p < database/create_database.sql
mysql -u root -p < database/insert_test_data.sql
mysql -u root -p < database/functions_views_procedures_triggers.sql
```

6. **运行应用**
```bash
python app.py
```

7. **访问系统**
打开浏览器访问：http://localhost:5000

## 数据库脚本说明

- `database/create_database.sql` - 数据库和表结构创建
- `database/insert_test_data.sql` - 测试数据插入
- `database/queries.sql` - 示例查询语句
- `database/functions_views_procedures_triggers.sql` - 函数、视图、存储过程、触发器

## 使用说明

### 1. 系统首页
- 查看系统概况和统计信息
- 快捷操作入口

### 2. 职工管理
- 添加新职工（医生、护士、接待员、管理员）
- 编辑职工信息
- 薪资管理
- 在职状态管理

### 3. 病人管理
- 注册新病人
- 管理病人基本信息
- 过敏史记录
- 紧急联系人信息

### 4. 药品管理
- 添加新药品
- 库存管理
- 过期预警
- 价格管理

## 数据库查询示例

### 多表连接查询
查询2024年入职医生的治疗病人数量：
```sql
SELECT s.name AS 医生姓名, COUNT(DISTINCT c.pt_id) AS 治疗病人数量
FROM staff_info s 
INNER JOIN case_record c ON s.staff_id = c.doctor_id
WHERE s.position = '医生' AND YEAR(s.hire_date) = 2024
GROUP BY s.staff_id, s.name
ORDER BY 治疗病人数量 DESC;
```

### 高级查询
查询用药种类大于1的病人：
```sql
SELECT pa.pt_id, pa.name, c.description, c.diagnosis, 
       COUNT(DISTINCT pr.drug_id) AS 用药种类数量
FROM patient_info pa
INNER JOIN case_record c ON pa.pt_id = c.pt_id
INNER JOIN prescription pr ON c.case_id = pr.case_id
GROUP BY pa.pt_id, pa.name, c.description, c.diagnosis
HAVING COUNT(DISTINCT pr.drug_id) > 1
ORDER BY pa.pt_id;
```

## 注意事项

1. **数据库权限**：确保MySQL用户有足够权限创建数据库和表
2. **字符编码**：使用UTF-8编码支持中文
3. **端口冲突**：如果5000端口被占用，修改app.py中的端口号
4. **生产环境**：生产部署时请修改SECRET_KEY和数据库密码

## 开发扩展

系统采用模块化设计，可以轻松扩展功能：
- 添加新的数据表和模型
- 扩展Web路由和页面
- 增加数据分析功能
- 集成报表系统

## 许可证

本项目仅供学习和教学使用。

## 联系信息

如有问题，请联系项目开发团队。 