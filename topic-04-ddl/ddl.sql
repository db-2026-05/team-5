-- ================================================================
-- SQL DDL TEMPLATE (TOPIC 04)
-- ================================================================
-- WHAT SHOULD BE ADDED HERE:
-- 1) Full PostgreSQL DDL for your finalized schema.
-- 2) CREATE TABLE statements for all entities from your ER diagram.
-- 3) Primary keys, foreign keys, NOT NULL, UNIQUE, CHECK constraints.
-- 4) Indexes for important search/join columns.
-- 5) Clean structure and comments (group by tables/constraints/indexes).
--
-- RECOMMENDED ORDER:
-- 1) Tables
-- 2) Constraints (if not inline)
-- 3) Indexes
--
-- TEAM NOTE:
-- Valeriia - members, membership_plans, member_subscriptions
-- Anzhela - classes, equipment, equipment_class, attendance
-- Anna - trainers, specializations, trainer_specializations
-- Inna - personal_training, fitness_goals
-- Tetiana - progress_records
--
-- IMPORTANT:
-- The script must run in PostgreSQL and produce a working schema that
-- matches your approved ER diagram and conceptual schema.
-- Submit this as one SQL file.
-- ================================================================

-- Add your DDL below this line

-- Create a members table
CREATE TABLE members (
member_id BIGSERIAL,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
email VARCHAR(254) NOT NULL,
phone VARCHAR(20) NOT NULL,
date_of_birth DATE NOT NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,

CONSTRAINT pk_members
PRIMARY KEY (member_id),

CONSTRAINT uq_members_email
UNIQUE (email),

CONSTRAINT chk_members_date_of_birth
CHECK (date_of_birth < CURRENT_DATE)
);


-- Create a membership_plans
CREATE TABLE membership_plans(
plan_id BIGSERIAL,
plan_type VARCHAR(20) NOT NULL,
price NUMERIC(10,2) NOT NULL,
duration_month SMALLINT NOT NULL,
description VARCHAR(500),

CONSTRAINT pk_membership_plans
PRIMARY KEY (plan_id),

CONSTRAINT uq_membership_plans_plan_type
UNIQUE (plan_type),

CONSTRAINT chk_membership_plans_price
CHECK (price > 0),

CONSTRAINT chk_membership_plans_duration_month
CHECK (duration_month BETWEEN 1 AND 12)
);


-- Create trainers table
CREATE TABLE trainers (
    trainer_id BIGSERIAL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(254) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    trainer_level VARCHAR(20) NOT NULL,
    hire_date DATE DEFAULT CURRENT_DATE NOT NULL,
    trainer_availability VARCHAR(50) NOT NULL,

    CONSTRAINT pk_trainers
    PRIMARY KEY (trainer_id),

    CONSTRAINT uq_trainers_email
    UNIQUE (email),

    CONSTRAINT uq_trainers_phone
    UNIQUE (phone),

    CONSTRAINT chk_trainers_level
    CHECK (trainer_level IN ('junior', 'middle', 'senior')),

	CONSTRAINT chk_trainers_availability
	CHECK (trainer_availability IN ('available', 'unavailable', 'on leave'))
);


-- Create specializations table
CREATE TABLE specializations (
    specialization_id BIGSERIAL,
    specialization_name VARCHAR(50) NOT NULL,
    description VARCHAR(500),

    CONSTRAINT pk_specializations
    PRIMARY KEY (specialization_id),

    CONSTRAINT uq_specializations_specialization_name
    UNIQUE (specialization_name)
);


-- Create classes table
CREATE TABLE classes (
	class_id BIGSERIAL,
	class_name VARCHAR(50) NOT NULL,
	trainer_id BIGINT NOT NULL,
	class_date DATE NOT NULL,
	start_time TIME NOT NULL,
	end_time TIME NOT NULL,
	capacity INT NOT NULL,
	room VARCHAR(30) NOT NULL,
	description VARCHAR(500),

	CONSTRAINT pk_classes
	PRIMARY KEY (class_id),
	
	CONSTRAINT fk_classes_trainers
	FOREIGN KEY (trainer_id)
	REFERENCES trainers(trainer_id)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,

	CONSTRAINT chk_classes_time
	CHECK (start_time < end_time),

	CONSTRAINT chk_classes_capacity
	CHECK (capacity > 0 AND capacity <= 30)
);


-- Create equipment table
CREATE TABLE equipment (
	equipment_id BIGSERIAL,
	equipment_name VARCHAR(50) NOT NULL,
	category VARCHAR(30) NOT NULL,
	status VARCHAR(20) NOT NULL,
	last_maintenance_date DATE,

	CONSTRAINT pk_equipment
	PRIMARY KEY (equipment_id),

	CONSTRAINT chk_equipment_status
	CHECK (status IN ('available', 'in_use', 'broken')),

CONSTRAINT chk_equipment_last_maintenance_date
CHECK (last_maintenance_date <= CURRENT_DATE)
);


--Create a member_subscriptions table
CREATE TABLE member_subscriptions(
subscription_id BIGSERIAL,
member_id BIGINT NOT NULL,
plan_id BIGINT NOT NULL,
start_date DATE DEFAULT CURRENT_DATE NOT NULL,
end_date DATE NOT NULL,
status VARCHAR(20) NOT NULL DEFAULT 'active',

CONSTRAINT pk_member_subscriptions
PRIMARY KEY (subscription_id),

CONSTRAINT chk_member_subscriptions_end_date
CHECK (end_date > start_date),

CONSTRAINT chk_member_subscriptions_status
CHECK (status IN ('active', 'expired', 'cancelled')),

CONSTRAINT fk_member_subscriptions_members
FOREIGN KEY (member_id)
REFERENCES members(member_id)
ON DELETE RESTRICT
ON UPDATE CASCADE,

CONSTRAINT fk_member_subscriptions_membership_plans
FOREIGN KEY (plan_id)
REFERENCES membership_plans(plan_id)
ON DELETE RESTRICT
ON UPDATE CASCADE

);


-- Create progress_records table
CREATE TABLE progress_records (
  record_id BIGSERIAL,
  member_id BIGINT NOT NULL,
  record_date DATE DEFAULT CURRENT_DATE NOT NULL,
  weight NUMERIC(5,2),
  body_fat NUMERIC(5,2),
  muscle_mass NUMERIC(5,2),
  notes TEXT,

    CONSTRAINT pk_progress_records
    PRIMARY KEY (record_id),

    CONSTRAINT fk_progress_records_members
    FOREIGN KEY (member_id)
    REFERENCES members(member_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,

    CONSTRAINT chk_progress_records_record_date
    CHECK (record_date <= CURRENT_DATE),

    CONSTRAINT chk_progress_records_weight
    CHECK (weight > 0),

    CONSTRAINT chk_progress_records_body_fat
    CHECK (body_fat > 0),

    CONSTRAINT chk_progress_records_muscle_mass
    CHECK (muscle_mass > 0)
);


-- Create fitness_goals table
CREATE TABLE fitness_goals (
    goal_id             BIGSERIAL,
    member_id           BIGINT NOT NULL,
    goal_description    VARCHAR(255) NOT NULL,
    goal_type           VARCHAR(50) NOT NULL,
    target_unit         VARCHAR(20) NOT NULL,
    target_value        NUMERIC(10, 2) NOT NULL,
    target_date         DATE NOT NULL,
    achievement_date    DATE,
    status              VARCHAR(20) NOT NULL DEFAULT 'active',

    CONSTRAINT pk_fitness_goals 
        PRIMARY KEY (goal_id),

    CONSTRAINT fk_fitness_goals_members 
        FOREIGN KEY (member_id) REFERENCES members(member_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT chk_fitness_goals_status 
        CHECK (status IN ('active', 'achieved', 'abandoned')),

    CONSTRAINT chk_fitness_goals_goal_type 
        CHECK (goal_type IN ('weight_loss', 'strength', 'endurance', 'cardio')),

    CONSTRAINT chk_fitness_goals_target_unit 
        CHECK (target_unit IN ('kg', 'percent', 'reps', 'minutes', 'km')),

    CONSTRAINT chk_fitness_goals_target_value 
        CHECK (target_value > 0)
);


-- Create personal_training table
CREATE TABLE personal_training (
    session_id      BIGSERIAL,
    member_id       BIGINT NOT NULL,
    trainer_id      BIGINT NOT NULL,
    session_date    DATE NOT NULL,
    start_time      TIME NOT NULL,
    end_time        TIME NOT NULL,
    price           NUMERIC(10, 2) NOT NULL,
    status          VARCHAR(20) NOT NULL DEFAULT 'planned',
    notes           TEXT,

    CONSTRAINT pk_personal_training 
        PRIMARY KEY (session_id),

    CONSTRAINT fk_personal_training_members 
        FOREIGN KEY (member_id) REFERENCES members(member_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_personal_training_trainers 
        FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT chk_personal_training_status 
        CHECK (status IN ('planned', 'finished', 'canceled')),

    CONSTRAINT chk_personal_training_price 
        CHECK (price > 0),

    CONSTRAINT chk_personal_training_times 
        CHECK (end_time > start_time)
);


-- Create attendance table
CREATE TABLE attendance (
	attendance_id BIGSERIAL,
	member_id BIGINT NOT NULL,
	class_id BIGINT NOT NULL,
	attendance_date DATE NOT NULL,
	status VARCHAR(20) NOT NULL,

	CONSTRAINT pk_attendance
	PRIMARY KEY (attendance_id),
	
	CONSTRAINT fk_attendance_members
	FOREIGN KEY (member_id)
	REFERENCES members(member_id)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,

CONSTRAINT fk_attendance_classes
	FOREIGN KEY (class_id)
	REFERENCES classes(class_id)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,

	CONSTRAINT chk_attendance_status
	CHECK (status IN ('present', 'absent')),

	CONSTRAINT chk_attendance_date
	CHECK (attendance_date <= CURRENT_DATE)
);


-- Create trainer_specializations junction table
CREATE TABLE trainer_specializations (
    trainer_id BIGINT NOT NULL,
    specialization_id BIGINT NOT NULL,

    CONSTRAINT pk_trainer_specializations
    PRIMARY KEY (trainer_id, specialization_id),

    CONSTRAINT fk_trainer_specializations_trainers
    FOREIGN KEY (trainer_id)
    REFERENCES trainers(trainer_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,

    CONSTRAINT fk_trainer_specializations_specializations
    FOREIGN KEY (specialization_id)
    REFERENCES specializations(specialization_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);


-- Create equipment_class (junction) table
CREATE TABLE equipment_class (
	class_id BIGINT NOT NULL,
	equipment_id BIGINT NOT NULL,

	CONSTRAINT pk_equipment_class
	PRIMARY KEY (class_id, equipment_id),
	
	CONSTRAINT fk_equipment_class_classes
	FOREIGN KEY (class_id)
	REFERENCES classes(class_id)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,

CONSTRAINT fk_equipment_class_equipment
	FOREIGN KEY (equipment_id)
	REFERENCES equipment(equipment_id)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
);


--classes indexes
CREATE INDEX idx_classes_name
ON classes(class_name);

CREATE INDEX idx_classes_trainer_id
ON classes(trainer_id);

CREATE INDEX idx_classes_date
ON classes(class_date);

--equipment indexes
CREATE INDEX idx_equipment_status
ON equipment(status);

--member_subscriptions INDEXES
CREATE INDEX idx_member_subscriptions_member_id --
ON member_subscriptions(member_id);

CREATE INDEX idx_member_subscriptions_plan_id --
ON member_subscriptions(plan_id);

-- progress_records indexes
CREATE INDEX idx_progress_records_member_id
ON progress_records(member_id);

CREATE INDEX idx_progress_records_record_date
ON progress_records(record_date);

-- fitness_goals indexes
CREATE INDEX idx_fitness_goals_member_id
ON fitness_goals(member_id);

-- personal_training indexes
CREATE INDEX idx_personal_training_member_id ON personal_training(member_id);
CREATE INDEX idx_personal_training_trainer_id ON personal_training(trainer_id);
CREATE INDEX idx_personal_training_session_date ON personal_training(session_date);

--attendance indexes
CREATE INDEX idx_attendance_member_id
ON attendance(member_id);

CREATE INDEX idx_attendance_class_id
ON attendance(class_id);

-- trainer_specializations indexes
CREATE INDEX idx_trainer_specializations_specialization_id
ON trainer_specializations(specialization_id);

--equipment_class indexes
CREATE INDEX idx_equipment_class_equipment_id
ON equipment_class(equipment_id);


--members comments
COMMENT ON TABLE members IS 'Table for storing information about members';
COMMENT ON COLUMN members.email IS 'Unique email';
COMMENT ON COLUMN members.phone IS 'Contact phone number';
COMMENT ON COLUMN members.created_at IS 'Record creation timestamp';

--membership_plans comments
COMMENT ON TABLE membership_plans IS 'Table for storing information about memberships';
COMMENT ON COLUMN membership_plans.plan_type IS 'Membership options';
COMMENT ON COLUMN membership_plans.price IS 'Membership price';
COMMENT ON COLUMN membership_plans.duration_month IS 'Duration of membership';
COMMENT ON COLUMN membership_plans.description IS 'Membership description';

-- trainers comments
COMMENT ON TABLE trainers IS 'Stores information about fitness center trainers';
COMMENT ON COLUMN trainers.trainer_id IS 'Primary key of trainer';
COMMENT ON COLUMN trainers.first_name IS 'Trainer first name';
COMMENT ON COLUMN trainers.last_name IS 'Trainer last name';
COMMENT ON COLUMN trainers.email IS 'Unique trainer email';
COMMENT ON COLUMN trainers.phone IS 'Unique contact phone number';
COMMENT ON COLUMN trainers.trainer_level IS 'Trainer level: junior, middle, or senior';
COMMENT ON COLUMN trainers.hire_date IS 'Date when the trainer was hired';
COMMENT ON COLUMN trainers.trainer_availability IS 'Trainer availability information';

-- specializations comments
COMMENT ON TABLE specializations IS 'Stores available trainer specialization types';
COMMENT ON COLUMN specializations.specialization_id IS 'Primary key of specialization';
COMMENT ON COLUMN specializations.specialization_name IS 'Unique specialization name';
COMMENT ON COLUMN specializations.description IS 'Specialization description';

--classes comments
COMMENT ON TABLE classes IS 'Stores group fitness classes scheduled in the gym system';
COMMENT ON COLUMN classes.class_id IS 'Primary key of class';
COMMENT ON COLUMN classes.class_name IS 'Name of the class (e.g. Yoga, Pilates)';
COMMENT ON COLUMN classes.trainer_id IS 'FK to trainers table';
COMMENT ON COLUMN classes.class_date IS 'Date of the class session';
COMMENT ON COLUMN classes.start_time IS 'Start time of the class';
COMMENT ON COLUMN classes.end_time IS 'End time of the class';
COMMENT ON COLUMN classes.capacity IS 'Maximum number of participants allowed';
COMMENT ON COLUMN classes.room IS 'Room where class takes place';
COMMENT ON COLUMN classes.description IS 'Optional class description';

--equipment comments
COMMENT ON TABLE equipment IS 'Stores gym equipment inventory and status';
COMMENT ON COLUMN equipment.equipment_id IS 'Primary key of equipment';
COMMENT ON COLUMN equipment.equipment_name IS 'Name of equipment';
COMMENT ON COLUMN equipment.category IS 'Type/category of equipment (cardio, strength, etc.)';
COMMENT ON COLUMN equipment.status IS 'Current status of equipment (available, in_use, broken)';
COMMENT ON COLUMN equipment.last_maintenance_date IS 'Date of last maintenance check';

--member_subscriptions COMMENTS
COMMENT ON TABLE member_subscriptions IS 'Table for storing information about members subscriptions';
COMMENT ON COLUMN member_subscriptions.member_id IS 'FK to the table members';
COMMENT ON COLUMN member_subscriptions.plan_id IS 'FK to the table membership_plans';
COMMENT ON COLUMN member_subscriptions.start_date IS 'Start date of membership';
COMMENT ON COLUMN member_subscriptions.end_date IS 'End date of membership';
COMMENT ON COLUMN member_subscriptions.status IS 'Status of membership';

-- progress_records comments
COMMENT ON TABLE progress_records IS 'Stores records of members progress';
COMMENT ON COLUMN progress_records.record_id IS 'Primary key of progress_records';
COMMENT ON COLUMN progress_records.member_id IS 'FK to the members table';
COMMENT ON COLUMN progress_records.record_date IS 'Date of this progress record';
COMMENT ON COLUMN progress_records.weight IS 'The members current weight';
COMMENT ON COLUMN progress_records.body_fat IS 'The members current body fat';
COMMENT ON COLUMN progress_records.muscle_mass IS 'The members current muscle mass';
COMMENT ON COLUMN progress_records.notes IS 'A member or trainers note regarding this progress update';

-- fitness_goals comments
COMMENT ON TABLE fitness_goals IS 'Members fitness goals with target values and achievement tracking';
COMMENT ON COLUMN fitness_goals.goal_description IS 'Free-text description of the goal (e.g., "Lose 5kg by August")';
COMMENT ON COLUMN fitness_goals.goal_type IS 'Category: weight_loss, strength, endurance, or cardio';
COMMENT ON COLUMN fitness_goals.target_unit IS 'Measurement unit: kg, percent, reps, minutes, or km';
COMMENT ON COLUMN fitness_goals.target_value IS 'Numeric target (interpretation depends on target_unit)';
COMMENT ON COLUMN fitness_goals.achievement_date IS 'NULL until goal is achieved';
COMMENT ON COLUMN fitness_goals.status IS 'Goal lifecycle: active, achieved, or abandoned';

-- personal_training comments
COMMENT ON TABLE personal_training IS 'Individual paid training sessions between members and trainers';
COMMENT ON COLUMN personal_training.price IS 'Snapshot price at booking time';
COMMENT ON COLUMN personal_training.status IS 'planned, finished, or canceled';
COMMENT ON COLUMN personal_training.notes IS 'Trainer notes about the session (injuries, progress, next steps)';

--attendance comments
COMMENT ON TABLE attendance IS 'Stores attendance records of members in classes';
COMMENT ON COLUMN attendance.attendance_id IS 'Primary key of attendance record';
COMMENT ON COLUMN attendance.member_id IS 'FK to members table';
COMMENT ON COLUMN attendance.class_id IS 'FK to classes table';
COMMENT ON COLUMN attendance.attendance_date IS 'Date of attendance record';
COMMENT ON COLUMN attendance.status IS 'Attendance status (present, absent)';

-- trainer_specializations comments
COMMENT ON TABLE trainer_specializations IS 'Junction table linking trainers with their specializations';
COMMENT ON COLUMN trainer_specializations.trainer_id IS 'FK to trainers table';
COMMENT ON COLUMN trainer_specializations.specialization_id IS 'FK to specializations table';

--equipment_class comments
COMMENT ON TABLE equipment_class IS 'Junction table linking equipment assigned to classes';
COMMENT ON COLUMN equipment_class.class_id IS 'FK to classes table';
COMMENT ON COLUMN equipment_class.equipment_id IS 'FK to equipment table';