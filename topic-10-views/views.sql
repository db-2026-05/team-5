-- ================================================================
-- SQL VIEWS TEMPLATE (TOPIC 10)
-- ================================================================
-- WHAT SHOULD BE ADDED HERE:
-- 1) CREATE VIEW scripts for required view types:
--    - Horizontal view (select specific columns)
--    - Vertical view (filter specific rows)
--    - Mixed view (columns + row filters)
--    - Join-based view (multiple tables)
--    - Subquery-based view
--    - UNION-based view
--    - View based on another view
--    - Updatable view with WITH CHECK OPTION
--
-- 2) Comments before each view explaining:
--    - Purpose of the view
--    - How it supports your project design
--
-- 3) Optional demo SELECT statements to show view output.
--
-- RECOMMENDED ORDER:
-- 1) Simple views (horizontal / vertical / mixed)
-- 2) Join and subquery views
-- 3) UNION and layered views
-- 4) CHECK OPTION view
--
-- IMPORTANT:
-- - Script must execute in PostgreSQL without errors.
-- - Keep naming consistent and readable.
-- - Submit all views in this single SQL file.
-- ================================================================

-- Add your CREATE VIEW statements below this line


-- Валерія
-- Views for members, member_subscriptions, membership_plans

-- 1. Horizontal View (only selected columns from members)
CREATE VIEW view_member_contacts AS
SELECT first_name,
       last_name,
       email
FROM members;

SELECT * FROM view_member_contacts;


-- 2. Vertical View (filtered rows)
CREATE VIEW view_active_subscriptions AS
SELECT *
FROM member_subscriptions
WHERE status = 'active';

SELECT * FROM view_active_subscriptions;


-- 3. Mixed View (columns + filter)
CREATE VIEW view_recent_members AS
SELECT first_name,
       last_name,
       email
FROM members
WHERE date_of_birth > '1995-01-01';

SELECT * FROM view_recent_members;


-- 4. Join-based View (combines all tables)
CREATE VIEW view_member_subscription_details AS
SELECT m.member_id,
       m.first_name,
       m.last_name,
       p.plan_type,
       s.start_date,
       s.end_date,
       s.status
FROM members m
JOIN member_subscriptions s
     ON m.member_id = s.member_id
JOIN membership_plans p
     ON p.plan_id = s.plan_id;

SELECT * FROM view_member_subscription_details;


-- 5. Subquery-based View (premium members)
CREATE VIEW view_premium_members AS
SELECT first_name,
       last_name,
       email
FROM members
WHERE member_id IN (
    SELECT member_id
    FROM member_subscriptions
    WHERE plan_id = (
        SELECT plan_id
        FROM membership_plans
        WHERE plan_type = 'premium'
    )
);

SELECT * FROM view_premium_members;


-- 6. UNION-based View (expired + cancelled subscriptions)
CREATE VIEW view_non_active_subscriptions AS
SELECT member_id,
       status
FROM member_subscriptions
WHERE status = 'expired'

UNION

SELECT member_id,
       status
FROM member_subscriptions
WHERE status = 'cancelled';

SELECT * FROM view_non_active_subscriptions;


-- 7. Layered View (view based on another view)
CREATE VIEW view_active_member_details AS
SELECT first_name,
       last_name,
       plan_type
FROM view_member_subscription_details
WHERE status = 'active';

SELECT * FROM view_active_member_details;


-- 8. CHECK OPTION View (restricts invalid status changes)
CREATE VIEW view_active_subscriptions_check AS
SELECT subscription_id,
       member_id,
       plan_id,
       start_date,
       end_date,
       status
FROM member_subscriptions
WHERE status = 'active'
WITH CHECK OPTION;

SELECT * FROM view_active_subscriptions_check;

-- Анжела


-- Views for classes, attendance, equipment, equipment_class

-- 1. HORIZONTAL VIEW (provides scheduling information about classes)

CREATE VIEW view_classes_schedule AS
SELECT class_name, trainer_id, class_date, start_time, end_time, room
FROM classes;

SELECT * FROM view_classes_schedule;


-- 2. VERTICAL VIEW (shows only large classes where capacity exceeds 15)

CREATE VIEW view_large_classes AS
SELECT *
FROM classes
WHERE capacity > 15;

SELECT * FROM view_large_classes;


-- 3. MIXED VIEW (shows upcoming classes with only the fields relevant for members)

CREATE VIEW view_upcoming_classes AS
SELECT class_name, room, class_date, start_time, end_time
FROM classes
WHERE class_date >= CURRENT_DATE;

SELECT * FROM view_upcoming_classes;


-- 4. JOIN VIEW (combines classes and equipment into one place so you can see what gear each class is using)

CREATE VIEW view_class_equipment AS
SELECT c.class_name, c.class_date, c.room, e.equipment_name, e.status AS equipment_status
FROM classes c
JOIN equipment_class ec ON c.class_id = ec.class_id
JOIN equipment e ON ec.equipment_id = e.equipment_id;

SELECT * FROM view_class_equipment;


-- 5. SUBQUERY VIEW (shows classes that have more than 1 available piece of equipment)

CREATE VIEW view_well_equipped_classes AS
SELECT c.class_name, c.class_date, c.room
FROM classes c
JOIN (
    SELECT ec.class_id
    FROM equipment_class ec
    JOIN equipment e ON ec.equipment_id = e.equipment_id
    WHERE e.status = 'available'
    GROUP BY ec.class_id
    HAVING COUNT(*) > 1
) AS sub ON c.class_id = sub.class_id;

SELECT * FROM view_well_equipped_classes;


-- 6. UNION VIEW (classes with available equipment and ones that had more than 1 member present)

CREATE VIEW view_class_highlights AS
SELECT class_id, 'available_equipment' AS source
FROM equipment_class
JOIN equipment ON equipment_class.equipment_id = equipment.equipment_id
WHERE status = 'available'

UNION

SELECT class_id, 'popular_class' AS source
FROM attendance
WHERE status = 'present'
GROUP BY class_id
HAVING COUNT(member_id) > 1;

SELECT * FROM view_class_highlights;


-- 7. VIEW OF A VIEW (builds on view_class_highlights which already references attendance)

CREATE VIEW view_class_attendance_summary AS
SELECT a.class_id, COUNT(a.member_id) AS total_present
FROM view_class_highlights v
JOIN attendance a ON v.class_id = a.class_id
WHERE a.status = 'present'
  AND v.source = 'popular_class'
GROUP BY a.class_id;


-- 8. VIEW WITH CHECK OPTION (shows only available equipment and makes sure no one can update a piece of equipment to a different status)

CREATE VIEW view_available_equipment AS
SELECT equipment_id, equipment_name, category, status
FROM equipment
WHERE status = 'available'
WITH CHECK OPTION;

SELECT * FROM view_available_equipment;


-- Views for trainers, specializations, trainer_specializations, progress_records, fitness_goals, personal_training

-- 1. HORIZONTAL VIEW (trainer's contact info only)

CREATE VIEW view_trainer_contacts AS
SELECT first_name, last_name, email, phone
FROM trainers;

SELECT * FROM view_trainer_contacts;


-- 2. VERTICAL VIEW (only fitness goals that are still active)

CREATE VIEW view_active_fitness_goals AS
SELECT *
FROM fitness_goals
WHERE status = 'active';

SELECT * FROM view_active_fitness_goals;


-- 3. MIXED VIEW (finished personal training sessions)

CREATE VIEW view_finished_sessions AS
SELECT member_id, trainer_id, session_date, price
FROM personal_training
WHERE status = 'finished';

SELECT * FROM view_finished_sessions;


-- 4. JOIN VIEW (see which trainer teaches what according to the specializations)

CREATE VIEW view_trainer_specialization_details AS
SELECT t.first_name, t.last_name, t.trainer_level, s.specialization_name
FROM trainers t
JOIN trainer_specializations ts ON t.trainer_id = ts.trainer_id
JOIN specializations s ON ts.specialization_id = s.specialization_id;

SELECT * FROM view_trainer_specialization_details;


-- 5. SUBQUERY VIEW (members who have more than one progress record)

CREATE VIEW view_actively_tracked_members AS
SELECT m.first_name, m.last_name, m.email
FROM members m
WHERE m.member_id IN (
    SELECT pr.member_id
    FROM progress_records pr
    GROUP BY pr.member_id
    HAVING COUNT(*) > 1
);

SELECT * FROM view_actively_tracked_members;


-- 6. UNION VIEW (members whose goals were abandoned and trainers who are currently unavailable)
-- entity_type added explicitly so person_id is never ambiguous between members and trainers.

CREATE VIEW view_attention_watchlist AS
SELECT member_id AS person_id, 'member' AS entity_type, 'abandoned_goal' AS reason
FROM fitness_goals
WHERE status = 'abandoned'

UNION

SELECT trainer_id AS person_id, 'trainer' AS entity_type, 'unavailable_trainer' AS reason
FROM trainers
WHERE trainer_availability = 'unavailable';

SELECT * FROM view_attention_watchlist;


-- 7. VIEW OF A VIEW (builds on view_finished_sessions which already filters finished sessions)

CREATE VIEW view_member_session_spend AS
SELECT fs.member_id, m.first_name, m.last_name, SUM(fs.price) AS total_pt_spent
FROM view_finished_sessions fs
JOIN members m ON fs.member_id = m.member_id
GROUP BY fs.member_id, m.first_name, m.last_name;


-- 8. VIEW WITH CHECK OPTION (shows only senior-level trainers, no one can use this view to change a trainer's level)

CREATE VIEW view_senior_trainers_check AS
SELECT trainer_id, first_name, last_name, trainer_level
FROM trainers
WHERE trainer_level = 'senior'
WITH CHECK OPTION;

SELECT * FROM view_senior_trainers_check;
