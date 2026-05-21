# TEAMWORK - Topic 04 (SQL DDL)

## Склад команди
- Команда: team-05
- Варіант предметної області: Варіант 2 — Fitness Center Management (рівень Medium)

## [Посилання на відео-презентацію](https://www.loom.com/share/face627dbfd7469a924c524bb8b8d1b1)

## Таблиця внесків
| Учасник | Роль у команді | Що зроблено | Артефакти / файли |
| - | - | - | - |
| Валерія | Financial module (Members & Subscriptions) | таблиці: members, membership_plans, member_subscriptions, зібрала фінальний ddl.sql, відео-презентація | ddl.sql, відео |
| Анна | HR module (Trainers & Specializations) | таблиці: trainers, specializations, trainer_specializations, документація | ddl.sql, TEAMWORK.md |
| Анжела | Operations module (Classes, Attendance & Equipment) | таблиці: classes, attendance, equipment, equipment_class | ddl.sql |
| Інна | Personal Training & Goals module | таблиці: personal_training, fitness_goals | ddl.sql |
| Тетяна | Progress Tracking module | таблиця: progress_records | ddl.sql |

## Контекст теми

Команда поділила 13 таблиць зі схеми на чотири функціональні блоки, де кожен учасник пише повний DDL для свого набору таблиць: CREATE TABLE, всі intra-table constraints (PK / NOT NULL / UNIQUE / CHECK / DEFAULT), FK з політиками ON DELETE та ON UPDATE, індекси на FK-колонках і часто фільтрованих полях, плюс COMMENT ON TABLE / COMMENT ON COLUMN для документації прямо в базі. Потім всі чотири частини збираються у фінальний ddl.sql у правильному порядку залежностей. Контроль відповідності оригінальній схемі — звірка кожної таблиці з schema.dbml (типи колонок, FK-направлення, UNIQUE обмеження). Скрипт був успішно виконаний у PostgreSQL.

## Коротке обґрунтування командного підходу

1. Як ми розподілили DDL-обʼєкти між учасниками:
За функціональними блоками, а не за алфавітом чи кількістю таблиць.
- Блок 1 — фінансова частина (members + membership_plans + member_subscriptions).
- Блок 2 — HR-частина (trainers + specializations + junction).
- Блок 3 — операційне ядро (classes + attendance + equipment + junction).
- Блок 4 — індивідуальна робота з клієнтом (personal training + goals + progress).

Кожен блок — самодостатній набір повʼязаних таблиць, тож учасник пише і CREATE TABLE, і всі constraints до них, без потреби координуватися з іншими по дрібницях.

2. Чому обрали саме такий поділ роботи:
Ми обрали такий підхід для мінімізації залежностей між учасниками. Junction-таблиці (trainer_specializations, equipment_class) ми залишили в тому ж блоці, що і обидві батьківські таблиці — щоб одна людина писала весь звʼязок. FK через блоки (наприклад, attendance.member_id → members.member_id) проходять через узгоджені імена колонок (одна конвенція _id) — це дозволило паралелізувати роботу. Узгодили спільні конвенції імен constraints (pk_, fk_, uq_, chk_, idx_) та політики зовнішніх ключів (переважно ON DELETE RESTRICT та ON UPDATE CASCADE) ПЕРЕД написанням коду, щоб остаточний ddl.sql був стилістично однорідним.

3. Як перевіряли відповідність DDL ER-діаграмі:
- По-перше, schema.dbml як джерело істини — кожна таблиця DDL звіряється з відповідною секцією DBML (типи, UNIQUE, напрямки FK).
- По-друге, dbml2sql --postgres генерує референсний DDL зі схеми; ми порівнювали його з нашим написаним вручну, щоб переконатися, що жодний звʼязок і жодне UNIQUE-обмеження не пропущене.
- По-третє, виконання скрипта у чистій PostgreSQL-базі — якщо скрипт виконується без помилок і всі CREATE TABLE проходять, значить порядок створення таблиць і рівні залежностей були визначені правильно.


## Загальні:

Ось безпечний порядок створення таблиць для фінального PostgreSQL DDL-файлу:

1. members
2. membership_plans
3. trainers
4. specializations
5. classes
6. equipment
7. member_subscriptions
8. progress_records
9. fitness_goals
10. personal_training
11. attendance
12. trainer_specializations
13. equipment_class

Foreign key dependencies:

classes → trainers
member_subscriptions → members, membership_plans
progress_records → members
fitness_goals → members
personal_training → members, trainers
attendance → members, classes
trainer_specializations → trainers, specializations
equipment_class → classes, equipment


Під час створення фінального DDL-файлу для PostgreSQL ми дотримувалися правильного порядку створення таблиць. Це було важливо, тому що таблиці з foreign keys могли посилатися тільки на ті таблиці, які вже існували в базі даних.

Спочатку ми створили незалежні таблиці, тобто таблиці, які не містили foreign keys і не залежали від інших таблиць. До них належали members, membership_plans, trainers, specializations та equipment.

Після цього ми створили таблиці, які містили foreign keys і посилалися на основні таблиці. Наприклад, classes посилалася на trainers, member_subscriptions — на members і membership_plans, progress_records та fitness_goals — на members, а personal_training — на members і trainers. Далі була створена таблиця attendance, яка містила foreign keys на members і classes та використовувалася для зберігання інформації про відвідування занять.

Останніми ми створили junction tables, які реалізовували many-to-many relationships між таблицями. Таблиця trainer_specializations зв’язувала trainers і specializations, а equipment_class — classes та equipment.