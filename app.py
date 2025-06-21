from flask import Flask, render_template, request, redirect, url_for, flash, jsonify, session
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime, date
from functools import wraps
import pymysql

# 安装pymysql作为MySQL驱动
pymysql.install_as_MySQLdb()

app = Flask(__name__)
app.config['SECRET_KEY'] = 'medical-system-secret-key-2025'
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:root@localhost:3306/medical_management_system'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# 数据库模型定义
class StaffInfo(db.Model):
    __tablename__ = 'staff_info'
    
    staff_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), nullable=False)
    gender = db.Column(db.Enum('男', '女'), nullable=False)
    age = db.Column(db.Integer, nullable=False)
    phone = db.Column(db.String(20), nullable=False)
    email = db.Column(db.String(100))
    position = db.Column(db.Enum('医生', '护士', '接待员', '管理员'), nullable=False)
    department = db.Column(db.String(50))
    hire_date = db.Column(db.Date, nullable=False)
    salary = db.Column(db.Numeric(10, 2), nullable=False)
    status = db.Column(db.Enum('在职', '离职'), default='在职')
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

class PatientInfo(db.Model):
    __tablename__ = 'patient_info'
    
    pt_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), nullable=False)
    gender = db.Column(db.Enum('男', '女'), nullable=False)
    age = db.Column(db.Integer, nullable=False)
    phone = db.Column(db.String(20), nullable=False)
    id_card = db.Column(db.String(18), unique=True)
    address = db.Column(db.String(200))
    emergency_contact = db.Column(db.String(50))
    emergency_phone = db.Column(db.String(20))
    blood_type = db.Column(db.Enum('A', 'B', 'AB', 'O'))
    allergy_history = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

class DrugInfo(db.Model):
    __tablename__ = 'drug_info'
    
    drug_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    category = db.Column(db.String(50), nullable=False)
    specification = db.Column(db.String(100))
    unit = db.Column(db.String(20), nullable=False)
    price = db.Column(db.Numeric(10, 2), nullable=False)
    stock_quantity = db.Column(db.Integer, nullable=False, default=0)
    manufacturer = db.Column(db.String(100))
    production_date = db.Column(db.Date)
    expiry_date = db.Column(db.Date)
    description = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

class Appointment(db.Model):
    __tablename__ = 'appointment'
    
    appointment_id = db.Column(db.Integer, primary_key=True)
    pt_id = db.Column(db.Integer, db.ForeignKey('patient_info.pt_id'), nullable=False)
    doctor_id = db.Column(db.Integer, db.ForeignKey('staff_info.staff_id'), nullable=False)
    receptionist_id = db.Column(db.Integer, db.ForeignKey('staff_info.staff_id'))
    appointment_date = db.Column(db.Date, nullable=False)
    appointment_time = db.Column(db.Time, nullable=False)
    department = db.Column(db.String(50), nullable=False)
    appointment_type = db.Column(db.Enum('初诊', '复诊', '急诊'), nullable=False)
    status = db.Column(db.Enum('已预约', '已就诊', '已取消', '已完成'), default='已预约')
    symptoms = db.Column(db.Text)
    notes = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

class CaseRecord(db.Model):
    __tablename__ = 'case_record'
    
    case_id = db.Column(db.Integer, primary_key=True)
    pt_id = db.Column(db.Integer, db.ForeignKey('patient_info.pt_id'), nullable=False)
    doctor_id = db.Column(db.Integer, db.ForeignKey('staff_info.staff_id'), nullable=False)
    nurse_id = db.Column(db.Integer, db.ForeignKey('staff_info.staff_id'))
    visit_date = db.Column(db.Date, nullable=False)
    visit_time = db.Column(db.Time, nullable=False)
    department = db.Column(db.String(50), nullable=False)
    chief_complaint = db.Column(db.Text)
    present_illness = db.Column(db.Text)
    past_history = db.Column(db.Text)
    physical_examination = db.Column(db.Text)
    auxiliary_examination = db.Column(db.Text)
    description = db.Column(db.Text, nullable=False)
    diagnosis = db.Column(db.Text, nullable=False)
    therapy = db.Column(db.Text, nullable=False)
    doctor_advice = db.Column(db.Text)
    follow_up_date = db.Column(db.Date)
    status = db.Column(db.Enum('就诊中', '已完成', '需复诊'), default='就诊中')
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

class Prescription(db.Model):
    __tablename__ = 'prescription'
    
    prescription_id = db.Column(db.Integer, primary_key=True)
    case_id = db.Column(db.Integer, db.ForeignKey('case_record.case_id'), nullable=False)
    drug_id = db.Column(db.Integer, db.ForeignKey('drug_info.drug_id'), nullable=False)
    quantity = db.Column(db.Integer, nullable=False)
    dosage = db.Column(db.String(100), nullable=False)
    frequency = db.Column(db.String(50), nullable=False)
    duration = db.Column(db.String(50), nullable=False)
    notes = db.Column(db.Text)
    price = db.Column(db.Numeric(10, 2), nullable=False)
    status = db.Column(db.Enum('已开具', '已配药', '已发药'), default='已开具')
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

# 登录装饰器
def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'logged_in' not in session:
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function

# 登录路由
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        
        # 简单的硬编码验证
        if username == 'admin' and password == 'admin':
            session['logged_in'] = True
            session['username'] = username
            flash('登录成功！', 'success')
            return redirect(url_for('staff_list'))
        else:
            flash('用户名或密码错误！', 'error')
    
    return render_template('login.html')

@app.route('/logout')
def logout():
    session.pop('logged_in', None)
    session.pop('username', None)
    flash('您已成功登出！', 'success')
    return redirect(url_for('login'))

# 主页路由
@app.route('/')
def index():
    return redirect(url_for('login'))

# 职工管理路由
@app.route('/staff')
@login_required
def staff_list():
    staff_members = StaffInfo.query.all()
    return render_template('staff/list.html', staff_members=staff_members)

@app.route('/staff/add', methods=['GET', 'POST'])
@login_required
def staff_add():
    if request.method == 'POST':
        try:
            staff = StaffInfo(
                name=request.form['name'],
                gender=request.form['gender'],
                age=int(request.form['age']),
                phone=request.form['phone'],
                email=request.form['email'],
                position=request.form['position'],
                department=request.form['department'],
                hire_date=datetime.strptime(request.form['hire_date'], '%Y-%m-%d').date(),
                salary=float(request.form['salary'])
            )
            db.session.add(staff)
            db.session.commit()
            flash('职工信息添加成功！', 'success')
            return redirect(url_for('staff_list'))
        except Exception as e:
            flash(f'添加失败：{str(e)}', 'error')
    return render_template('staff/add.html')

@app.route('/staff/edit/<int:staff_id>', methods=['GET', 'POST'])
@login_required
def staff_edit(staff_id):
    staff = StaffInfo.query.get_or_404(staff_id)
    if request.method == 'POST':
        try:
            staff.name = request.form['name']
            staff.gender = request.form['gender']
            staff.age = int(request.form['age'])
            staff.phone = request.form['phone']
            staff.email = request.form['email']
            staff.position = request.form['position']
            staff.department = request.form['department']
            staff.hire_date = datetime.strptime(request.form['hire_date'], '%Y-%m-%d').date()
            staff.salary = float(request.form['salary'])
            staff.status = request.form['status']
            db.session.commit()
            flash('职工信息更新成功！', 'success')
            return redirect(url_for('staff_list'))
        except Exception as e:
            flash(f'更新失败：{str(e)}', 'error')
    return render_template('staff/edit.html', staff=staff)

@app.route('/staff/delete/<int:staff_id>')
@login_required
def staff_delete(staff_id):
    try:
        staff = StaffInfo.query.get_or_404(staff_id)
        db.session.delete(staff)
        db.session.commit()
        flash('职工信息删除成功！', 'success')
    except Exception as e:
        flash(f'删除失败：{str(e)}', 'error')
    return redirect(url_for('staff_list'))

# 病人管理路由
@app.route('/patients')
@login_required
def patient_list():
    patients = PatientInfo.query.all()
    return render_template('patient/list.html', patients=patients)

@app.route('/patients/add', methods=['GET', 'POST'])
@login_required
def patient_add():
    if request.method == 'POST':
        try:
            patient = PatientInfo(
                name=request.form['name'],
                gender=request.form['gender'],
                age=int(request.form['age']),
                phone=request.form['phone'],
                id_card=request.form['id_card'],
                address=request.form['address'],
                emergency_contact=request.form['emergency_contact'],
                emergency_phone=request.form['emergency_phone'],
                blood_type=request.form['blood_type'],
                allergy_history=request.form['allergy_history']
            )
            db.session.add(patient)
            db.session.commit()
            flash('病人信息添加成功！', 'success')
            return redirect(url_for('patient_list'))
        except Exception as e:
            flash(f'添加失败：{str(e)}', 'error')
    return render_template('patient/add.html')

@app.route('/patients/view/<int:pt_id>')
@login_required
def patient_view(pt_id):
    patient = PatientInfo.query.get_or_404(pt_id)
    return render_template('patient/view.html', patient=patient)

@app.route('/patients/edit/<int:pt_id>', methods=['GET', 'POST'])
@login_required
def patient_edit(pt_id):
    patient = PatientInfo.query.get_or_404(pt_id)
    if request.method == 'POST':
        try:
            patient.name = request.form['name']
            patient.gender = request.form['gender']
            patient.age = int(request.form['age'])
            patient.phone = request.form['phone']
            patient.id_card = request.form['id_card']
            patient.address = request.form['address']
            patient.emergency_contact = request.form['emergency_contact']
            patient.emergency_phone = request.form['emergency_phone']
            patient.blood_type = request.form['blood_type']
            patient.allergy_history = request.form['allergy_history']
            db.session.commit()
            flash('病人信息更新成功！', 'success')
            return redirect(url_for('patient_list'))
        except Exception as e:
            flash(f'更新失败：{str(e)}', 'error')
    return render_template('patient/edit.html', patient=patient)

# 药品管理路由
@app.route('/drugs')
@login_required
def drug_list():
    drugs = DrugInfo.query.all()
    today = datetime.now().date()
    return render_template('drug/list.html', drugs=drugs, today=today)

@app.route('/drugs/add', methods=['GET', 'POST'])
@login_required
def drug_add():
    if request.method == 'POST':
        try:
            drug = DrugInfo(
                name=request.form['name'],
                category=request.form['category'],
                specification=request.form['specification'],
                unit=request.form['unit'],
                price=float(request.form['price']),
                stock_quantity=int(request.form['stock_quantity']),
                manufacturer=request.form['manufacturer'],
                production_date=datetime.strptime(request.form['production_date'], '%Y-%m-%d').date() if request.form['production_date'] else None,
                expiry_date=datetime.strptime(request.form['expiry_date'], '%Y-%m-%d').date() if request.form['expiry_date'] else None,
                description=request.form['description']
            )
            db.session.add(drug)
            db.session.commit()
            flash('药品信息添加成功！', 'success')
            return redirect(url_for('drug_list'))
        except Exception as e:
            flash(f'添加失败：{str(e)}', 'error')
    return render_template('drug/add.html')

@app.route('/drugs/edit/<int:drug_id>', methods=['GET', 'POST'])
@login_required
def drug_edit(drug_id):
    drug = DrugInfo.query.get_or_404(drug_id)
    if request.method == 'POST':
        try:
            drug.name = request.form['name']
            drug.category = request.form['category']
            drug.specification = request.form['specification']
            drug.unit = request.form['unit']
            drug.price = float(request.form['price'])
            drug.stock_quantity = int(request.form['stock_quantity'])
            drug.manufacturer = request.form['manufacturer']
            drug.production_date = datetime.strptime(request.form['production_date'], '%Y-%m-%d').date() if request.form['production_date'] else None
            drug.expiry_date = datetime.strptime(request.form['expiry_date'], '%Y-%m-%d').date() if request.form['expiry_date'] else None
            drug.description = request.form['description']
            db.session.commit()
            flash('药品信息更新成功！', 'success')
            return redirect(url_for('drug_list'))
        except Exception as e:
            flash(f'更新失败：{str(e)}', 'error')
    return render_template('drug/edit.html', drug=drug)

@app.route('/drugs/stock/<int:drug_id>', methods=['GET', 'POST'])
@login_required
def drug_stock(drug_id):
    drug = DrugInfo.query.get_or_404(drug_id)
    if request.method == 'POST':
        try:
            adjustment = int(request.form['adjustment'])
            drug.stock_quantity += adjustment
            if drug.stock_quantity < 0:
                drug.stock_quantity = 0
            db.session.commit()
            flash(f'库存调整成功！当前库存：{drug.stock_quantity}', 'success')
            return redirect(url_for('drug_list'))
        except Exception as e:
            flash(f'库存调整失败：{str(e)}', 'error')
    return render_template('drug/stock.html', drug=drug)

# 预约管理路由
@app.route('/appointments')
@login_required
def appointment_list():
    appointments = db.session.query(Appointment).join(
        PatientInfo, Appointment.pt_id == PatientInfo.pt_id
    ).join(
        StaffInfo, Appointment.doctor_id == StaffInfo.staff_id
    ).add_columns(
        PatientInfo.name.label('patient_name'),
        StaffInfo.name.label('doctor_name')
    ).all()
    return render_template('appointment/list.html', appointments=appointments)

@app.route('/appointments/add', methods=['GET', 'POST'])
@login_required
def appointment_add():
    if request.method == 'POST':
        try:
            appointment = Appointment(
                pt_id=int(request.form['pt_id']),
                doctor_id=int(request.form['doctor_id']),
                receptionist_id=int(request.form['receptionist_id']) if request.form['receptionist_id'] else None,
                appointment_date=datetime.strptime(request.form['appointment_date'], '%Y-%m-%d').date(),
                appointment_time=datetime.strptime(request.form['appointment_time'], '%H:%M').time(),
                department=request.form['department'],
                appointment_type=request.form['appointment_type'],
                symptoms=request.form['symptoms'],
                notes=request.form['notes']
            )
            db.session.add(appointment)
            db.session.commit()
            flash('预约创建成功！', 'success')
            return redirect(url_for('appointment_list'))
        except Exception as e:
            flash(f'预约创建失败：{str(e)}', 'error')
    
    patients = PatientInfo.query.all()
    doctors = StaffInfo.query.filter_by(position='医生').all()
    receptionists = StaffInfo.query.filter_by(position='接待员').all()
    return render_template('appointment/add.html', patients=patients, doctors=doctors, receptionists=receptionists)

@app.route('/appointments/view/<int:appointment_id>')
@login_required
def appointment_view(appointment_id):
    appointment = Appointment.query.get_or_404(appointment_id)
    patient = PatientInfo.query.get(appointment.pt_id)
    doctor = StaffInfo.query.get(appointment.doctor_id)
    receptionist = StaffInfo.query.get(appointment.receptionist_id) if appointment.receptionist_id else None
    return render_template('appointment/view.html', appointment=appointment, patient=patient, doctor=doctor, receptionist=receptionist)

@app.route('/appointments/edit/<int:appointment_id>', methods=['GET', 'POST'])
@login_required
def appointment_edit(appointment_id):
    appointment = Appointment.query.get_or_404(appointment_id)
    if request.method == 'POST':
        try:
            appointment.pt_id = int(request.form['pt_id'])
            appointment.doctor_id = int(request.form['doctor_id'])
            appointment.receptionist_id = int(request.form['receptionist_id']) if request.form['receptionist_id'] else None
            appointment.appointment_date = datetime.strptime(request.form['appointment_date'], '%Y-%m-%d').date()
            appointment.appointment_time = datetime.strptime(request.form['appointment_time'], '%H:%M').time()
            appointment.department = request.form['department']
            appointment.appointment_type = request.form['appointment_type']
            appointment.status = request.form['status']
            appointment.symptoms = request.form['symptoms']
            appointment.notes = request.form['notes']
            db.session.commit()
            flash('预约信息更新成功！', 'success')
            return redirect(url_for('appointment_list'))
        except Exception as e:
            flash(f'更新失败：{str(e)}', 'error')
    
    patients = PatientInfo.query.all()
    doctors = StaffInfo.query.filter_by(position='医生').all()
    receptionists = StaffInfo.query.filter_by(position='接待员').all()
    return render_template('appointment/edit.html', appointment=appointment, patients=patients, doctors=doctors, receptionists=receptionists)

# 病历管理路由
@app.route('/cases')
@login_required
def case_list():
    cases = db.session.query(CaseRecord).join(
        PatientInfo, CaseRecord.pt_id == PatientInfo.pt_id
    ).join(
        StaffInfo, CaseRecord.doctor_id == StaffInfo.staff_id
    ).add_columns(
        PatientInfo.name.label('patient_name'),
        StaffInfo.name.label('doctor_name')
    ).all()
    return render_template('case/list.html', cases=cases)

@app.route('/cases/add', methods=['GET', 'POST'])
@login_required
def case_add():
    if request.method == 'POST':
        try:
            case = CaseRecord(
                pt_id=int(request.form['pt_id']),
                doctor_id=int(request.form['doctor_id']),
                nurse_id=int(request.form['nurse_id']) if request.form['nurse_id'] else None,
                visit_date=datetime.strptime(request.form['visit_date'], '%Y-%m-%d').date(),
                visit_time=datetime.strptime(request.form['visit_time'], '%H:%M').time(),
                department=request.form['department'],
                chief_complaint=request.form.get('chief_complaint', ''),
                present_illness=request.form.get('present_illness', ''),
                past_history=request.form.get('past_history', ''),
                physical_examination=request.form.get('physical_examination', ''),
                auxiliary_examination=request.form.get('auxiliary_examination', ''),
                description=request.form['description'],
                diagnosis=request.form['diagnosis'],
                therapy=request.form['therapy'],
                doctor_advice=request.form.get('doctor_advice', ''),
                follow_up_date=datetime.strptime(request.form['follow_up_date'], '%Y-%m-%d').date() if request.form.get('follow_up_date') else None
            )
            db.session.add(case)
            db.session.commit()
            flash('病历创建成功！', 'success')
            return redirect(url_for('case_list'))
        except Exception as e:
            flash(f'病历创建失败：{str(e)}', 'error')
    
    patients = PatientInfo.query.all()
    doctors = StaffInfo.query.filter_by(position='医生').all()
    nurses = StaffInfo.query.filter_by(position='护士').all()
    return render_template('case/add.html', patients=patients, doctors=doctors, nurses=nurses)

@app.route('/cases/view/<int:case_id>')
@login_required
def case_view(case_id):
    case = CaseRecord.query.get_or_404(case_id)
    patient = PatientInfo.query.get(case.pt_id)
    doctor = StaffInfo.query.get(case.doctor_id)
    nurse = StaffInfo.query.get(case.nurse_id) if case.nurse_id else None
    return render_template('case/view.html', case=case, patient=patient, doctor=doctor, nurse=nurse)

@app.route('/cases/edit/<int:case_id>', methods=['GET', 'POST'])
@login_required
def case_edit(case_id):
    case = CaseRecord.query.get_or_404(case_id)
    if request.method == 'POST':
        try:
            case.pt_id = int(request.form['pt_id'])
            case.doctor_id = int(request.form['doctor_id'])
            case.nurse_id = int(request.form['nurse_id']) if request.form['nurse_id'] else None
            case.visit_date = datetime.strptime(request.form['visit_date'], '%Y-%m-%d').date()
            case.visit_time = datetime.strptime(request.form['visit_time'], '%H:%M').time()
            case.department = request.form['department']
            case.chief_complaint = request.form.get('chief_complaint', '')
            case.present_illness = request.form.get('present_illness', '')
            case.past_history = request.form.get('past_history', '')
            case.physical_examination = request.form.get('physical_examination', '')
            case.auxiliary_examination = request.form.get('auxiliary_examination', '')
            case.description = request.form['description']
            case.diagnosis = request.form['diagnosis']
            case.therapy = request.form['therapy']
            case.doctor_advice = request.form.get('doctor_advice', '')
            case.status = request.form['status']
            case.follow_up_date = datetime.strptime(request.form['follow_up_date'], '%Y-%m-%d').date() if request.form.get('follow_up_date') else None
            case.cost = float(request.form['cost']) if request.form.get('cost') else None
            db.session.commit()
            flash('病历信息更新成功！', 'success')
            return redirect(url_for('case_list'))
        except Exception as e:
            flash(f'更新失败：{str(e)}', 'error')
    
    patients = PatientInfo.query.all()
    doctors = StaffInfo.query.filter_by(position='医生').all()
    nurses = StaffInfo.query.filter_by(position='护士').all()
    return render_template('case/edit.html', case=case, patients=patients, doctors=doctors, nurses=nurses)

# 处方管理路由
@app.route('/prescriptions')
@login_required
def prescription_list():
    prescriptions = db.session.query(Prescription).join(
        CaseRecord, Prescription.case_id == CaseRecord.case_id
    ).join(
        DrugInfo, Prescription.drug_id == DrugInfo.drug_id
    ).join(
        PatientInfo, CaseRecord.pt_id == PatientInfo.pt_id
    ).add_columns(
        DrugInfo.name.label('drug_name'),
        PatientInfo.name.label('patient_name'),
        CaseRecord.case_id.label('case_id')
    ).all()
    return render_template('prescription/list.html', prescriptions=prescriptions)

@app.route('/prescriptions/add', methods=['GET', 'POST'])
@login_required
def prescription_add():
    if request.method == 'POST':
        try:
            # 获取药品价格计算总价
            drug = DrugInfo.query.get(int(request.form['drug_id']))
            quantity = int(request.form['quantity'])
            total_price = drug.price * quantity
            
            prescription = Prescription(
                case_id=int(request.form['case_id']),
                drug_id=int(request.form['drug_id']),
                quantity=quantity,
                dosage=request.form['dosage'],
                frequency=request.form['frequency'],
                duration=request.form['duration'],
                notes=request.form['notes'],
                price=total_price
            )
            db.session.add(prescription)
            db.session.commit()
            flash('处方开具成功！', 'success')
            return redirect(url_for('prescription_list'))
        except Exception as e:
            flash(f'处方开具失败：{str(e)}', 'error')
    
    cases = db.session.query(CaseRecord).join(PatientInfo).add_columns(
        PatientInfo.name.label('patient_name')
    ).all()
    drugs = DrugInfo.query.all()
    return render_template('prescription/add.html', cases=cases, drugs=drugs)

@app.route('/prescriptions/view/<int:prescription_id>')
@login_required
def prescription_view(prescription_id):
    prescription = Prescription.query.get_or_404(prescription_id)
    case = CaseRecord.query.get(prescription.case_id)
    drug = DrugInfo.query.get(prescription.drug_id)
    patient = PatientInfo.query.get(case.pt_id)
    doctor = StaffInfo.query.get(case.doctor_id)
    return render_template('prescription/view.html', prescription=prescription, case=case, drug=drug, patient=patient, doctor=doctor)

@app.route('/prescriptions/edit/<int:prescription_id>', methods=['GET', 'POST'])
@login_required
def prescription_edit(prescription_id):
    prescription = Prescription.query.get_or_404(prescription_id)
    if request.method == 'POST':
        try:
            # 获取药品价格计算总价
            drug = DrugInfo.query.get(int(request.form['drug_id']))
            quantity = int(request.form['quantity'])
            total_price = drug.price * quantity
            
            prescription.case_id = int(request.form['case_id'])
            prescription.drug_id = int(request.form['drug_id'])
            prescription.quantity = quantity
            prescription.dosage = request.form['dosage']
            prescription.frequency = request.form['frequency']
            prescription.duration = request.form['duration']
            prescription.notes = request.form['notes']
            prescription.price = total_price
            prescription.status = request.form['status']
            db.session.commit()
            flash('处方信息更新成功！', 'success')
            return redirect(url_for('prescription_list'))
        except Exception as e:
            flash(f'更新失败：{str(e)}', 'error')
    
    cases = db.session.query(CaseRecord).join(PatientInfo).add_columns(
        PatientInfo.name.label('patient_name')
    ).all()
    drugs = DrugInfo.query.all()
    return render_template('prescription/edit.html', prescription=prescription, cases=cases, drugs=drugs)

if __name__ == '__main__':
    app.run(debug=True) 