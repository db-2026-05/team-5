-- ================================================================
-- DATABASE ADMINISTRATION TEMPLATE (TOPIC 11)
-- ================================================================
-- WHAT SHOULD BE ADDED HERE:
-- 1) CREATE ROLE statements for at least 2 distinct roles.
--    Example roles: read-only analyst, read-write editor.
--
-- 2) GRANT statements assigning appropriate permissions to each role:
--    - Read-only role: GRANT SELECT ON ALL TABLES IN SCHEMA ...
--    - Read-write role: GRANT SELECT, INSERT, UPDATE, DELETE ...
--
-- 3) CREATE USER statements for at least 2 users.
--    Each user must be assigned to one of the defined roles.
--
-- 4) Comments before each section explaining the rationale:
--    - Why this role exists
--    - What access it should and should not have
--
-- RECOMMENDED ORDER:
-- 1) Roles + their GRANTs
-- 2) Users + GRANT ROLE TO USER
-- 3) Optional: REVOKE statements for fine-grained restrictions
-- 4) Optional cleanup block (commented out by default):
--    -- DROP USER ...; DROP ROLE ...;
--
-- IMPORTANT:
-- - Use explicit GRANT / REVOKE statements — do not rely on defaults.
-- - Roles must have meaningfully different permission levels.
-- - Script must execute in PostgreSQL without errors.
-- ================================================================

-- Add your script below this line

-- CREATE ROLES

CREATE ROLE manager_role;
CREATE ROLE trainer_role;
CREATE ROLE receptionist_role;
CREATE ROLE member_role;


-- CREATE USERS
-- Real trainer and member names are taken from the existing database records. Manager and receptionist names are fictional.

-- Trainers
CREATE USER oleksandr_kovalenko WITH PASSWORD 'password1';
CREATE USER alina_savchenko WITH PASSWORD 'password2';

-- Members
CREATE USER dmytro_tkachenko WITH PASSWORD 'password3';
CREATE USER maria_kovalchuk WITH PASSWORD 'password4';

-- Managers
CREATE USER mykola_bondarenko WITH PASSWORD 'password5';

-- Receptionists
CREATE USER oksana_petrenko WITH PASSWORD 'password6';
CREATE USER vasyl_kravchenko WITH PASSWORD 'password7';


-- ASSIGN USERS TO ROLES

GRANT trainer_role TO oleksandr_kovalenko;
GRANT trainer_role TO alina_savchenko;
GRANT member_role TO dmytro_tkachenko;
GRANT member_role TO maria_kovalchuk;
GRANT manager_role TO mykola_bondarenko;
GRANT receptionist_role TO oksana_petrenko;
GRANT receptionist_role TO vasyl_kravchenko;


-- GRANT SCHEMA ACCESS

GRANT USAGE ON SCHEMA public TO manager_role;
GRANT USAGE ON SCHEMA public TO trainer_role;
GRANT USAGE ON SCHEMA public TO receptionist_role;
GRANT USAGE ON SCHEMA public TO member_role;


-- GRANT PERMISSIONS

-- classes
-- Members and trainers can view classes but cannot modify them.
-- Receptionist manages class scheduling (insert and update).
-- Only manager can delete a class permanently.

GRANT SELECT ON classes TO member_role;
GRANT SELECT ON classes TO trainer_role;
GRANT SELECT, INSERT, UPDATE ON classes TO receptionist_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON classes TO manager_role;


-- equipment
-- Members can view available equipment.
-- Trainers can update equipment status.
-- Receptionist can only view equipment, not modify it.
-- Only manager can add new equipment or delete old records.

GRANT SELECT ON equipment TO member_role;
GRANT SELECT, UPDATE ON equipment TO trainer_role;
GRANT SELECT ON equipment TO receptionist_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON equipment TO manager_role;


-- equipment_class
-- All roles can view which equipment is used in which class.
-- Only manager can manage these links (add, update, delete).

GRANT SELECT ON equipment_class TO member_role;
GRANT SELECT ON equipment_class TO trainer_role;
GRANT SELECT ON equipment_class TO receptionist_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON equipment_class TO manager_role;


-- attendance
-- Members have no access to attendance.
-- Trainers can view attendance for their classes.
-- Receptionist handles check-ins (insert and update).
-- Only manager can delete attendance records.

GRANT SELECT ON attendance TO trainer_role;
GRANT SELECT, INSERT, UPDATE ON attendance TO receptionist_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON attendance TO manager_role;


-- specializations
-- All roles can view specializations.
-- Only manager can add or delete specializations.

GRANT SELECT ON specializations TO member_role;
GRANT SELECT ON specializations TO trainer_role;
GRANT SELECT ON specializations TO receptionist_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON specializations TO manager_role;


-- membership_plans
-- Members, trainers, and receptionist can view available plans.
-- Only manager can add, modify, or delete plans.

GRANT SELECT ON membership_plans TO member_role;
GRANT SELECT ON membership_plans TO trainer_role;
GRANT SELECT ON membership_plans TO receptionist_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON membership_plans TO manager_role;


-- members
-- Members can view their own data.
-- Trainers can view member profiles.
-- Receptionist handles registrations and contact updates (insert and update).
-- Only manager can permanently delete a member profile.

GRANT SELECT ON members TO member_role;
GRANT SELECT ON members TO trainer_role;
GRANT SELECT, INSERT, UPDATE ON members TO receptionist_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON members TO manager_role;


-- member_subscriptions
-- Members can view their own subscription status.
-- Trainers have no access.
-- Receptionist can update existing subscriptions.
-- Insert access was revoked.
-- Only manager can delete subscription records.

GRANT SELECT ON member_subscriptions TO member_role;
GRANT SELECT, INSERT, UPDATE ON member_subscriptions TO receptionist_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON member_subscriptions TO manager_role;


-- trainers
-- Members can view trainer profiles.
-- Trainers can view other trainers' profiles.
-- Receptionist can view trainer data for scheduling.
-- Only manager can add, modify, or delete trainer records.

GRANT SELECT ON trainers TO member_role;
GRANT SELECT ON trainers TO trainer_role;
GRANT SELECT ON trainers TO receptionist_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON trainers TO manager_role;


-- trainer_specializations
-- Members and trainers can view specializations.
-- Receptionist can view this data for scheduling.
-- Only manager can assign or remove specializations from trainers.

GRANT SELECT ON trainer_specializations TO member_role;
GRANT SELECT ON trainer_specializations TO trainer_role;
GRANT SELECT ON trainer_specializations TO receptionist_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON trainer_specializations TO manager_role;


-- progress_records
-- Members can view their own progress records.
-- Trainers can insert and update progress records.
-- Receptionist has no access as this is personal health information.
-- Only manager can delete progress records.

GRANT SELECT ON progress_records TO member_role;
GRANT SELECT, INSERT, UPDATE ON progress_records TO trainer_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON progress_records TO manager_role;


-- fitness_goals
-- Members can view their own fitness goals.
-- Trainers can create and update goals.
-- Receptionist has no access to fitness goals.
-- Only manager can delete goal records.

GRANT SELECT ON fitness_goals TO member_role;
GRANT SELECT, INSERT, UPDATE ON fitness_goals TO trainer_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON fitness_goals TO manager_role;


-- personal_training
-- Members can view their own personal trainings.
-- Trainers can insert and update sessions.
-- Receptionist can view and book sessions.
-- Only manager can delete personal training records.

GRANT SELECT ON personal_training TO member_role;
GRANT SELECT, INSERT, UPDATE ON personal_training TO trainer_role;
GRANT SELECT, INSERT ON personal_training TO receptionist_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON personal_training TO manager_role;


-- REVOKE
-- After review, receptionist should not update specializations. Specialization data is handled only by the manager.
REVOKE UPDATE ON specializations FROM receptionist_role;

-- After review, receptionist should not create new subscriptions. Subscription creation is a financial decision handled only by the manager.
REVOKE INSERT ON member_subscriptions FROM receptionist_role;


-- OPTIONAL CLEANUP
-- DROP USER IF EXISTS oleksandr_kovalenko;
-- DROP USER IF EXISTS alina_savchenko;
-- DROP USER IF EXISTS dmytro_tkachenko;
-- DROP USER IF EXISTS maria_kovalchuk;
-- DROP USER IF EXISTS mykola_bondarenko;
-- DROP USER IF EXISTS oksana_petrenko;
-- DROP USER IF EXISTS vasyl_kravchenko;
-- DROP ROLE IF EXISTS manager_role;
-- DROP ROLE IF EXISTS trainer_role;
-- DROP ROLE IF EXISTS receptionist_role;
-- DROP ROLE IF EXISTS member_role;