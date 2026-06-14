-- ================================================================
-- SQL DML TEMPLATE (TOPIC 09)
-- ================================================================
-- WHAT SHOULD BE ADDED HERE:
-- 1) INSERT scripts for all required tables in your database.
-- 2) At least 10 records per table with meaningful, realistic values.
-- 3) UPDATE / DELETE scripts where they are relevant to business logic.
-- 4) If UPDATE / DELETE are not relevant for a table, add a short note
--    in documentation explaining why.
-- 5) Comments by section so the script is easy to read and run.
--
-- SCRIPT GOALS:
-- - Populate the database with usable test data.
-- - Validate constraints through realistic DML scenarios.
-- - Support the core functionality of your application.
--
-- RECOMMENDED ORDER:
-- 1) Reference data (lookups/dictionaries)
-- 2) Core entities
-- 3) Transactional data
-- 4) Optional UPDATE / DELETE checks
--
-- IMPORTANT:
-- - Use anonymized or privacy-safe sample data where possible.
-- - The script must execute in PostgreSQL.
-- - Submit this as one SQL file.
-- ================================================================

-- Add your DML below this line


-- INSERT

-- Валерія
-- membership_plans
-- Only three subscription types exist: monthly, yearly, and premium.

INSERT INTO membership_plans (plan_type, price, duration_month, description)
VALUES
    ('monthly', 9.99, 1, 'Monthly subscription plan with standard access'),
    ('yearly', 99.99, 12, 'Yearly subscription plan with standard access'),
    ('premium', 199.99, 12, 'Premium subscription plan with full access and exclusive features');

-- Валерія
-- members

INSERT INTO members (first_name, last_name, email, phone, date_of_birth)
VALUES
    ('Олександр', 'Шевченко', 'oleksandr.shevchenko@example.com', '+380671234567', '1995-03-15'),
    ('Марія', 'Ковальчук', 'maria.kovalchuk@example.com', '+380501112233', '1998-07-22'),
    ('Андрій', 'Бондаренко', 'andrii.bondarenko@example.com', '+380931234567', '1992-11-08'),
    ('Ірина', 'Мельник', 'iryna.melnyk@example.com', '+380661234567', '1997-01-30'),
    ('Дмитро', 'Ткаченко', 'dmytro.tkachenko@example.com', '+380971112233', '1990-09-12'),
    ('Наталія', 'Савченко', 'nataliia.savchenko@example.com', '+380681234567', '1994-05-18'),
    ('Віталій', 'Кравченко', 'vitalii.kravchenko@example.com', '+380631234567', '1989-12-03'),
    ('Олена', 'Петренко', 'olena.petrenko@example.com', '+380951234567', '1996-08-27'),
    ('Максим', 'Лисенко', 'maksym.lysenko@example.com', '+380731234567', '1993-04-10'),
    ('Тетяна', 'Мороз', 'tetiana.moroz@example.com', '+380991234567', '1999-10-25');

-- Валерія
-- member_subscriptions

INSERT INTO member_subscriptions (member_id, plan_id, start_date, end_date, status)
VALUES
    (1, 1, '2025-01-01', '2025-02-01', 'expired'),
    (2, 2, '2025-01-15', '2026-01-15', 'active'),
    (3, 3, '2025-03-01', '2026-03-01', 'active'),
    (4, 1, '2025-06-01', '2025-07-01', 'expired'),
    (5, 2, '2025-04-10', '2026-04-10', 'active'),
    (6, 3, '2025-05-15', '2026-05-15', 'active'),
    (7, 1, '2025-07-01', '2025-08-01', 'active'),
    (8, 2, '2025-02-20', '2026-02-20', 'active'),
    (9, 3, '2025-01-10', '2026-01-10', 'cancelled'),
    (10, 1, '2025-08-01', '2025-09-01', 'active');

-- Тетяна
-- trainers
-- All data except for trainer_availability must be non-NULL. Default value for hire_date is CURRENT_DATE. email and phone must be unique by uq_trainers_email and uq_trainers_phone. Possible values for trainer_level are 'junior', 'middle', 'senior'. Possible values for trainer_availability are 'available', 'unavailable', 'on leave'.

INSERT INTO trainers (first_name, last_name, email, phone, trainer_level, hire_date, trainer_availability)
VALUES
    ('Oleksandr', 'Kovalenko', 'oleksandr.kovalenko@gmail.com', '+380501234567', 'senior', '2026-04-03', 'available'),
    ('Dmytro', 'Hrytsenko', 'dmytro.hrytsenko@outlook.com', '+380631112233', 'middle', '2026-05-04', 'unavailable'),
    ('Ivan', 'Melnyk', 'ivanmelnyk@gmail.com', '+380671234890', 'junior', '2026-06-09', 'available'),
    ('Mariia', 'Polishchuk', 'm.polishchuk@outlook.com', '+380681112244', 'junior', '2026-05-12', 'available'),
    ('Kateryna', 'Klymenko', 'katya.klymenko@icloud.com', '+380731234321', 'middle', '2026-04-19', 'on leave'),
    ('Bohdan', 'Moroz', 'bohdan.moroz@icloud.com', '+380931112255', 'senior', '2026-04-11', 'unavailable'),
    ('Oksana', 'Kostenko', 'o.kostenko@outlook.com', '+380951234654', 'middle', '2026-05-31', 'available'),
    ('Maksym', 'Marchenko', 'maks.march@gmail.com', '+380961112266', 'junior', DEFAULT, 'available'),
    ('Andrii', 'Danylchenko', 'andrii.danyl@gmail.com', '+380971234987', 'middle', '2026-04-30', 'unavailable'),
    ('Alina', 'Savchenko', 'alina.sav@ukr.net', '+380991112277', 'senior', '2026-05-27', 'available');

-- Анжела
-- specializations
-- specialization_name is UNIQUE (uq_specializations_specialization_name)

INSERT INTO specializations (specialization_name, description)
VALUES
    ('Functional Training', 'Circuit and movement-based training for strength and endurance'),
    ('Yoga', 'Hatha, flow and hot yoga instruction'),
    ('Boxing', 'Cardio boxing and combat fitness coaching'),
    ('Barre', 'Ballet-inspired strength, posture and flexibility training'),
    ('Strength & Power', 'Heavy lifting, resistance and power-focused programming'),
    ('Pilates', 'Core stability and body alignment through mat and equipment work'),
    ('TRX', 'Suspension-based bodyweight training'),
    ('Cycling', 'Indoor cycling and high-intensity cardio on stationary bikes'),
    ('Stretching & Mobility', 'Flexibility, recovery and mobility work');

-- Тетяна
-- trainer_specializations
-- PK is (trainer_id, specialization_id), no duplicate pairs.

INSERT INTO trainer_specializations (trainer_id, specialization_id)
VALUES
    (9, 7),
    (2, 8),
    (2, 1),
    (3, 7),
    (4, 2),
    (1, 5),
    (6, 9),
    (7, 8),
    (4, 4),
    (1, 3),
    (10, 3);

-- Тетяна
-- progress_records
-- member_id and record_date cannot be NULL; record_date cannot be earlier than today.

INSERT INTO progress_records (member_id, record_date, weight, body_fat, muscle_mass, notes)
VALUES
    (2, '2026-06-11', 88.50, 30.00, 33.00, 'Initial measurement'),
    (1, '2026-06-11', 72.00, NULL, NULL, 'Body weight at the start of the programme'),
    (1, '2026-06-11', 72.60, 15.00, 35.00, 'A weight gain of 0.6 kg — thats progress'),
    (3, '2026-06-05', 90.20, 28.00, 40.00, 'Initial measurement — start'),
    (3, '2026-06-10', 85.10, 22.00, 44.00, 'Goal achieved — 5 kg lost'),
    (2, '2026-06-08', 87.80, NULL, NULL, 'A loss of 0.7 kg in a week — thats good progress'),
    (4, '2026-06-11', NULL, 24.50, NULL, 'Body fat percentage at the start'),
    (4, '2026-06-09', NULL, 20.90, NULL, 'A 3.6% decrease — a positive trend'),
    (6, '2026-06-07', NULL, NULL, NULL, 'Starting points, with the aim of improving physical fitness'),
    (9, '2026-06-11', 83.00, 18.00, 41.00, 'Starting points, need to strengthen muscles');

-- Тетяна
-- fitness_goals
-- All data except achievement_date must be non-NULL. Default value for status is 'active'; other values: 'achieved', 'abandoned'. Possible values for goal_type are 'weight_loss', 'strength', 'endurance', 'cardio'. Possible values for target_unit are 'kg', 'percent', 'reps', 'minutes', 'km'.
-- target_value > 0 is verified by chk_fitness_goals_target_value.

INSERT INTO fitness_goals (member_id, goal_type, goal_description, target_unit, target_value, target_date, achievement_date, status)
VALUES
    (2, 'weight_loss', 'Lose weight by summer', 'kg', 80.00, '2026-09-01', NULL, 'active'),
    (1, 'strength', 'Build upper body muscle mass', 'percent', 40.00, '2026-08-10', NULL, 'active'),
    (3, 'weight_loss', 'Lose weight by vacation', 'kg', 85.00, '2026-08-22', '2026-08-25', 'achieved'),
    (9, 'strength', 'Get back into shape', 'percent', 50.00, '2026-09-11', NULL, DEFAULT),
    (4, 'weight_loss', 'Reduction in body fat percentage', 'percent', 17.00, '2026-07-27', NULL, 'active'),
    (6, 'cardio', 'Improvement in overall health', 'kg', 57.00, '2026-07-11', NULL, DEFAULT),
    (7, 'strength', 'Keeping fit', 'reps', 75.00, '2026-10-31', NULL, 'active'),
    (5, 'endurance', 'Training for a triathlon', 'minutes', 1020.00, '2026-12-15', NULL, 'active'),
    (10, 'endurance', 'Build muscle tone and improve appearance', 'km', 21.00, '2026-09-30', NULL, 'active'),
    (8, 'cardio', 'Improve health and boost stamina', 'km', 12.00, '2026-07-10', NULL, 'abandoned'),
    (2, 'weight_loss', 'Lose weight by summer — updated', 'kg', 78.00, '2026-09-01', NULL, 'active');

-- Тетяна
-- personal_training
-- All data except notes must be non-NULL; default value for status is 'planned'. Possible values for status are 'planned', 'finished', 'canceled'.
-- price > 0 is verified by chk_personal_training_price.
-- end_time > start_time is verified by chk_personal_training_times.

INSERT INTO personal_training (member_id, trainer_id, session_date, start_time, end_time, price, notes, status)
VALUES
    (8, 1, '2026-04-22', '09:00', '10:00', 400.00, NULL, 'canceled'),
    (1, 4, '2026-06-03', '11:00', '12:30', 600.00, 'Focus on the chest and shoulders', 'finished'),
    (9, 5, '2026-05-29', '14:00', '16:00', 1000.00, 'Functional bodyweight training', 'canceled'),
    (6, 6, '2026-06-05', '08:00', '09:00', 500.00, 'Yoga and breathing techniques', 'finished'),
    (4, 8, '2026-05-25', '17:00', '18:30', 700.00, NULL, 'finished'),
    (5, 2, '2026-05-08', '10:00', '11:30', 600.00, 'Strength exercises for the legs', 'finished'),
    (9, 3, '2026-07-06', '13:00', '15:00', 900.00, 'TRX — a complete workout routine', 'planned'),
    (8, 3, '2026-06-18', '09:30', '10:30', 500.00, NULL, 'planned'),
    (7, 1, '2026-06-27', '16:00', '17:00', 400.00, 'Introductory session to assess objectives', DEFAULT),
    (2, 7, '2026-05-14', '18:00', '19:00', 500.00, 'Basic exercises for beginners', 'finished');

-- Анжела
-- equipment
-- One item is 'broken' and one 'in_use' to verify the CHECK constraint on status IN ('available', 'in_use', 'broken').

INSERT INTO equipment (equipment_name, category, status, last_maintenance_date)
VALUES
    ('Treadmill', 'Cardio', 'available', '2026-05-10'),
    ('Stationary Bike', 'Cardio', 'available', '2026-04-25'),
    ('Elliptical Machine', 'Cardio', 'available', '2026-05-20'),
    ('Dumbbell Set', 'Free Weights', 'in_use', '2026-01-10'),
    ('Smith Machine', 'Strength Machines', 'available', '2026-05-01'),
    ('Leg Press Machine', 'Strength Machines', 'broken', '2026-05-18'),
    ('Yoga Mat', 'Accessories', 'available', '2026-05-30'),
    ('TRX Suspension Trainer', 'Accessories', 'available', '2026-02-10'),
    ('Punching Bag', 'Boxing', 'available', '2026-01-22'),
    ('Resistance Bands', 'Accessories', 'available', '2026-04-11');

-- Анжела
-- classes
-- capacity values respect CHECK (capacity > 0 AND capacity <= 30).
-- start_time < end_time is verified by chk_classes_time.

INSERT INTO classes (class_name, trainer_id, class_date, start_time, end_time, capacity, room, description)
VALUES
    ('Hatha Yoga', 4, '2026-06-10', '08:00', '09:00', 15, 'Studio Zen', 'Morning yoga to restore energy and flexibility'),
    ('Boxing', 1, '2026-06-10', '18:30', '19:15', 20, 'Fight Zone', 'Cardio boxing and strength on the mat'),
    ('Hot Pilates', 2, '2026-06-11', '10:00', '11:00', 12, 'Hot Studio', 'Core and back strengthening in a heated room'),
    ('Cycle', 7, '2026-06-11', '19:00', '19:45', 25, 'Cycle Room', 'High-energy cardio on stationary bikes'),
    ('Hot Stretching', 6, '2026-06-12', '17:00', '18:00', 15, 'Hot Studio', 'Full-body stretch and muscle recovery'),
    ('Barre', 6, '2026-06-12', '19:00', '19:45', 20, 'Studio B', 'Ballet-inspired strength and posture class'),
    ('TRX', 3, '2026-06-13', '12:00', '12:45', 10, 'Functional Zone', 'Suspension training for full-body strength'),
    ('Power', 1, '2026-06-13', '16:00', '17:00', 8, 'Heavy Area', 'Strength training with additional weight'),
    ('Hot Yoga Flow', 4, '2026-06-14', '20:00', '21:00', 15, 'Hot Studio', 'Yoga flow in a heated room for deeper stretch'),
    ('Functional', 2, '2026-06-14', '11:00', '12:00', 18, 'Studio A', 'Circuit training for strength and endurance');

-- Анжела
-- equipment_class
-- PK is (class_id, equipment_id), no duplicate pairs.

INSERT INTO equipment_class (class_id, equipment_id)
VALUES
    (1, 7), -- Hatha Yoga - Yoga Mat
    (2, 9), -- Boxing - Punching Bag
    (2, 5), -- Boxing - Smith Machine (strength block)
    (3, 7), -- Hot Pilates - Yoga Mat
    (4, 2), -- Cycle - Stationary Bike
    (5, 7), -- Hot Stretching - Yoga Mat
    (6, 10), -- Barre - Resistance Bands
    (7, 8), -- TRX - TRX Suspension Trainer
    (8, 4), -- Power - Dumbbell Set
    (10, 5), -- Functional - Smith Machine
    (2, 4); -- Boxing - Dumbbell Set

-- Анжела
-- attendance
-- Mix of 'present' and 'absent' to test the status CHECK constraint.
-- attendance_date <= CURRENT_DATE is enforced by chk_attendance_date.

INSERT INTO attendance (member_id, class_id, attendance_date, status)
VALUES
    (1, 2, '2026-06-10', 'present'),
    (2, 3, '2026-06-11', 'present'),
    (4, 1, '2026-06-10', 'present'),
    (5, 4, '2026-06-11', 'absent'),
    (8, 3, '2026-06-11', 'present'),
    (3, 2, '2026-06-10', 'present'),
    (6, 5, '2026-06-11', 'present'),
    (7, 7, '2026-06-10', 'present'),
    (2, 6, '2026-06-11', 'present'),
    (4, 5, '2026-06-11', 'absent');

-- UPDATE

-- members: update phone number after contact information change.
UPDATE members
SET phone = '+380501234999'
WHERE member_id = 1;

-- trainers: update last name after marriage.
UPDATE trainers
SET last_name = 'Khmara'
WHERE first_name = 'Oksana'
    AND last_name = 'Kostenko';

-- fitness_goals: increase the target by 15 minutes for endurance or weight_loss goals where the target unit is 'minutes'.
UPDATE fitness_goals
SET target_value = target_value + 15
WHERE target_unit = 'minutes'
    AND goal_type IN ('endurance', 'weight_loss');

-- personal_training: mark session as finished and append a note (COALESCE preserves existing text if notes is not NULL).
UPDATE personal_training
SET status = 'finished',
    notes = COALESCE(notes, '') || 'Not a bad starting point, she can start by running 5km per session'
WHERE member_id = 8
    AND session_date = '2026-06-18';

-- equipment: set status to 'broken' if not maintained since 2026-03-01. Applied only to 'available' items so as not to overwrite equipment that is currently in use.
UPDATE equipment
SET status = 'broken'
WHERE last_maintenance_date < '2026-03-01'
    AND status = 'available';

-- equipment: restore all broken equipment to service and set today as last maintenance date.
UPDATE equipment
SET status = 'available',
    last_maintenance_date = CURRENT_DATE
WHERE status = 'broken';

-- equipment: flag equipment used in 'Power'-type classes as 'broken' to schedule maintenance after high-intensity use.
UPDATE equipment
SET status = 'broken'
WHERE equipment_id IN (
    SELECT ec.equipment_id
    FROM equipment_class ec
    JOIN classes c ON ec.class_id = c.class_id
    WHERE c.class_name LIKE '%Power%'
);

-- classes: reassign all classes from trainer 6 to trainer 2 (for example, if trainer 6 is on leave).
UPDATE classes
SET trainer_id = 2
WHERE trainer_id = 6;

-- classes: increase capacity for popular classes.
UPDATE classes
SET capacity = capacity + 5
WHERE class_id IN (
    SELECT class_id
    FROM attendance
    GROUP BY class_id
    HAVING COUNT(*) >= 2
);

-- classes: move high-demand classes to a larger studio.
UPDATE classes
SET room = 'Studio C'
WHERE class_id IN (
    SELECT class_id
    FROM attendance
    GROUP BY class_id
    HAVING COUNT(*) >= 2
);

-- classes: move the largest class (by capacity) to the Main Hall.
UPDATE classes
SET room = 'Main Hall'
WHERE capacity = (
    SELECT MAX(capacity)
    FROM classes
);

-- specializations: rename 'Yoga' to 'Hatha Yoga'.
UPDATE specializations
SET specialization_name = 'Hatha Yoga'
WHERE specialization_name = 'Yoga';

-- specializations: fill in missing descriptions.
UPDATE specializations
SET description = 'No description provided'
WHERE description IS NULL;


-- DELETE

-- progress_records: delete records that have no measurements - they have no analytical value.
DELETE FROM progress_records
WHERE weight IS NULL
    AND body_fat IS NULL
    AND muscle_mass IS NULL;

-- fitness_goals: delete duplicate active goals per member (same member_id, goal_type, and target_unit), keeping only the most recent one.
DELETE FROM fitness_goals
WHERE goal_id IN (
    SELECT goal_id
    FROM (
        SELECT
            goal_id,
            ROW_NUMBER() OVER (
                PARTITION BY member_id, goal_type, target_unit
                ORDER BY goal_id DESC
            ) AS rn
        FROM fitness_goals
        WHERE status = 'active'
    ) duplicated
    WHERE rn > 1
);

-- attendance: remove old absent records before 2026-06-12. These add no value — the member never showed up and the class has already passed.
DELETE FROM attendance
WHERE attendance_date <= '2026-06-12'
    AND status = 'absent';

-- equipment_class: remove links for classes that have no attendance records.
DELETE FROM equipment_class
WHERE class_id NOT IN (
    SELECT DISTINCT class_id
    FROM attendance
);

-- equipment_class: remove the link for the equipment item with the oldest last maintenance date.
DELETE FROM equipment_class
WHERE equipment_id IN (
    SELECT equipment_id
    FROM equipment 
    WHERE last_maintenance_date = (SELECT MIN(last_maintenance_date) FROM equipment)
);

-- classes: delete classes that nobody attended. Classes with at least one attendance record are kept for history.
DELETE FROM classes
WHERE class_id NOT IN (
    SELECT class_id
    FROM attendance
);

-- trainer_specializations: remove boxing-related specializations for the senior trainer Alina Savchenko. Always delete by specialization_id to avoid orphaned FK references in trainer_specializations (ON DELETE RESTRICT would block deletion by name).
DELETE FROM trainer_specializations
WHERE (trainer_id, specialization_id) IN (
    SELECT
        ts.trainer_id,
        ts.specialization_id
    FROM trainer_specializations AS ts
    JOIN trainers AS t ON t.trainer_id = ts.trainer_id
    JOIN specializations AS s ON s.specialization_id = ts.specialization_id
    WHERE t.trainer_level = 'senior'
        AND t.first_name = 'Alina'
        AND t.last_name = 'Savchenko'
        AND s.specialization_name ILIKE '%box%'
);

-- trainer_specializations: remove specialization links for trainers who have no classes
DELETE FROM trainer_specializations
WHERE trainer_id NOT IN (
    SELECT DISTINCT trainer_id FROM classes
);

-- specializations: delete specializations not assigned to any trainer.
DELETE FROM specializations
WHERE specialization_id NOT IN (
    SELECT DISTINCT ts.specialization_id 
    FROM trainer_specializations ts
    JOIN trainers t ON t.trainer_id = ts.trainer_id
    JOIN classes c ON c.trainer_id = t.trainer_id
);


-- WHY NO DELETE IN SOME TABLES

-- members:
-- Has foreign key dependencies in member_subscriptions. Direct deletion is restricted due to ON DELETE RESTRICT.

-- membership_plans:
-- Has foreign key dependencies in member_subscriptions. Direct deletion is restricted due to ON DELETE RESTRICT.

-- trainers:
-- Has foreign key dependencies in classes, personal_training, and trainer_specializations. Direct deletion is restricted due to ON DELETE RESTRICT.

-- member_subscriptions:
-- Subscription history is retained for billing and audit purposes.

-- personal_training:
-- Records are retained as a complete history of member interactions with trainers.

-- equipment:
-- Only the item with the oldest maintenance date is removed via equipment_class. Deleting equipment still referenced in equipment_class would cause a FK error.
