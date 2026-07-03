-- =========================================================================
--  SISU - GYM TRACKER APP
--  Database Schema (MySQL 8.0+)
--  Generated from requirements: FR01-FR05, NFR01-NFR03
-- =========================================================================
--  Mapping reference:
--  FR01 Home        -> posts, post_likes, post_comments, user_streaks
--  FR02 Workout     -> routines, routine_exercises, workout_plans, plan_routines
--  FR03 Profile     -> workout_logs, body_measurements, exercise_records,
--                       friendships, muscle_groups (3D body model)
--  FR03 Notification-> notifications
--  FR04 AI          -> ai_conversations, ai_messages
--  FR05 GymRoom     -> gyms, gym_images, gym_reviews
--  NFR02 Dark Mode / NFR03 Language -> user_settings
-- =========================================================================

CREATE DATABASE IF NOT EXISTS sisu_gym_tracker
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE sisu_gym_tracker;

SET FOREIGN_KEY_CHECKS = 0;

-- =========================================================================
-- 1. USERS & SETTINGS
-- =========================================================================

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    username        VARCHAR(50)  NOT NULL UNIQUE,
    email           VARCHAR(150) NOT NULL UNIQUE,
    password_hash   VARCHAR(255) NOT NULL,
    full_name       VARCHAR(150),
    avatar_url      VARCHAR(255),
    bio             TEXT,
    gender          ENUM('male','female','other'),
    date_of_birth   DATE,
    height_cm       DECIMAL(5,2),
    weight_kg       DECIMAL(5,2),
    is_active       BOOLEAN DEFAULT TRUE,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- NFR02 (Dark/Light mode) + NFR03 (vi/en language) + notification toggles
DROP TABLE IF EXISTS user_settings;
CREATE TABLE user_settings (
    user_id              BIGINT UNSIGNED PRIMARY KEY,
    theme                ENUM('light','dark') DEFAULT 'light',
    language             ENUM('vi','en') DEFAULT 'vi',
    notif_friend_post    BOOLEAN DEFAULT TRUE,
    notif_reminder       BOOLEAN DEFAULT TRUE,
    notif_record         BOOLEAN DEFAULT TRUE,
    updated_at           TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_settings_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================================================
-- 2. FRIENDS (FR01 "view other profiles", FR03 "Friends")
-- =========================================================================

DROP TABLE IF EXISTS friendships;
CREATE TABLE friendships (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT UNSIGNED NOT NULL,   -- requester
    friend_id       BIGINT UNSIGNED NOT NULL,   -- target
    status          ENUM('pending','accepted','blocked') DEFAULT 'pending',
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    responded_at    TIMESTAMP NULL,
    UNIQUE KEY uq_friend_pair (user_id, friend_id),
    CONSTRAINT fk_friend_user   FOREIGN KEY (user_id)   REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_friend_target FOREIGN KEY (friend_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_no_self_friend CHECK (user_id <> friend_id)
) ENGINE=InnoDB;

-- =========================================================================
-- 3. SOCIAL FEED — POSTS (FR01 Home)
-- =========================================================================

DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT UNSIGNED NOT NULL,
    workout_log_id  BIGINT UNSIGNED NULL,        -- optional: post generated from a workout session
    content         TEXT,
    media_url       VARCHAR(255),
    media_type      ENUM('image','video') NULL,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_post_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS post_likes;
CREATE TABLE post_likes (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    post_id         BIGINT UNSIGNED NOT NULL,
    user_id         BIGINT UNSIGNED NOT NULL,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_post_like (post_id, user_id),
    CONSTRAINT fk_like_post FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    CONSTRAINT fk_like_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS post_comments;
CREATE TABLE post_comments (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    post_id         BIGINT UNSIGNED NOT NULL,
    user_id         BIGINT UNSIGNED NOT NULL,
    content         TEXT NOT NULL,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_comment_post FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    CONSTRAINT fk_comment_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================================================
-- 4. STREAKS (FR01 "week/month streak")
-- =========================================================================

DROP TABLE IF EXISTS user_streaks;
CREATE TABLE user_streaks (
    user_id              BIGINT UNSIGNED PRIMARY KEY,
    current_streak_days  INT DEFAULT 0,
    longest_streak_days  INT DEFAULT 0,
    week_workout_count    INT DEFAULT 0,
    month_workout_count   INT DEFAULT 0,
    last_workout_date     DATE,
    updated_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_streak_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================================================
-- 5. EXERCISES & MUSCLE GROUPS (FR02, FR03 "3D body model")
-- =========================================================================

DROP TABLE IF EXISTS muscle_groups;
CREATE TABLE muscle_groups (
    id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(50) NOT NULL UNIQUE,    -- Chest, Back, Shoulders, Arms, Legs, Core...
    body_model_part VARCHAR(50)                     -- key used to highlight the 3D body model
) ENGINE=InnoDB;

DROP TABLE IF EXISTS exercises;
CREATE TABLE exercises (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(150) NOT NULL,
    description     TEXT,
    instructions    TEXT,
    equipment       VARCHAR(100),
    difficulty      ENUM('beginner','intermediate','advanced') DEFAULT 'beginner',
    video_url       VARCHAR(255),
    image_url       VARCHAR(255),
    is_custom       BOOLEAN DEFAULT FALSE,          -- FALSE = system library, TRUE = user-created
    created_by      BIGINT UNSIGNED NULL,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_exercise_creator FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

DROP TABLE IF EXISTS exercise_muscle_groups;
CREATE TABLE exercise_muscle_groups (
    exercise_id     BIGINT UNSIGNED NOT NULL,
    muscle_group_id INT UNSIGNED NOT NULL,
    is_primary      BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (exercise_id, muscle_group_id),
    CONSTRAINT fk_emg_exercise FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE,
    CONSTRAINT fk_emg_muscle   FOREIGN KEY (muscle_group_id) REFERENCES muscle_groups(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================================================
-- 6. ROUTINES (FR02 "My routine" / "New routine" / "Add exercise")
-- =========================================================================
-- Business rule: a routine must contain at least 1 exercise
-- ("Không cho phép tạo routine trống") -> enforced at application layer.

DROP TABLE IF EXISTS routines;
CREATE TABLE routines (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT UNSIGNED NOT NULL,
    name            VARCHAR(150) NOT NULL,
    description     TEXT,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_routine_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS routine_exercises;
CREATE TABLE routine_exercises (
    id                BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    routine_id        BIGINT UNSIGNED NOT NULL,
    exercise_id       BIGINT UNSIGNED NOT NULL,
    sort_order        INT DEFAULT 0,
    target_sets       INT DEFAULT 3,
    target_reps       INT DEFAULT 10,
    target_weight_kg  DECIMAL(6,2),
    rest_seconds      INT DEFAULT 60,
    CONSTRAINT fk_re_routine  FOREIGN KEY (routine_id)  REFERENCES routines(id)  ON DELETE CASCADE,
    CONSTRAINT fk_re_exercise FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================================================
-- 7. WORKOUT PLANS (FR02 "Plan" button, classic/famous plans)
-- =========================================================================
-- Business rule: a plan must contain at least 3 routines/days
-- ("Không cho phép plan trống, ít nhất 3 plans") -> enforced at application layer.

DROP TABLE IF EXISTS workout_plans;
CREATE TABLE workout_plans (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(150) NOT NULL,          -- e.g. "Push Pull Legs", "StrongLifts 5x5"
    description     TEXT,
    level           ENUM('beginner','intermediate','advanced') DEFAULT 'beginner',
    duration_weeks  INT,
    is_featured     BOOLEAN DEFAULT TRUE,           -- famous/classic system plan
    created_by      BIGINT UNSIGNED NULL,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_plan_creator FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

DROP TABLE IF EXISTS plan_routines;
CREATE TABLE plan_routines (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    plan_id         BIGINT UNSIGNED NOT NULL,
    routine_id      BIGINT UNSIGNED NOT NULL,
    day_order       INT NOT NULL,                   -- Day 1, Day 2, Day 3 ...
    CONSTRAINT fk_pr_plan    FOREIGN KEY (plan_id)    REFERENCES workout_plans(id) ON DELETE CASCADE,
    CONSTRAINT fk_pr_routine FOREIGN KEY (routine_id) REFERENCES routines(id)      ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS user_plans;
CREATE TABLE user_plans (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT UNSIGNED NOT NULL,
    plan_id         BIGINT UNSIGNED NOT NULL,
    started_at      DATE,
    is_active       BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_up_user FOREIGN KEY (user_id) REFERENCES users(id)         ON DELETE CASCADE,
    CONSTRAINT fk_up_plan FOREIGN KEY (plan_id) REFERENCES workout_plans(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================================================
-- 8. WORKOUT LOGS / SESSIONS (FR03 "Calendar", "My workouts")
-- =========================================================================

DROP TABLE IF EXISTS workout_logs;
CREATE TABLE workout_logs (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT UNSIGNED NOT NULL,
    routine_id      BIGINT UNSIGNED NULL,
    workout_date    DATE NOT NULL,
    started_at      DATETIME,
    ended_at        DATETIME,
    notes           TEXT,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_log_user    FOREIGN KEY (user_id)    REFERENCES users(id)    ON DELETE CASCADE,
    CONSTRAINT fk_log_routine FOREIGN KEY (routine_id) REFERENCES routines(id) ON DELETE SET NULL
) ENGINE=InnoDB;

DROP TABLE IF EXISTS workout_log_exercises;
CREATE TABLE workout_log_exercises (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    workout_log_id  BIGINT UNSIGNED NOT NULL,
    exercise_id     BIGINT UNSIGNED NOT NULL,
    set_number      INT NOT NULL,
    reps            INT,
    weight_kg       DECIMAL(6,2),
    is_completed    BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_lex_log      FOREIGN KEY (workout_log_id) REFERENCES workout_logs(id) ON DELETE CASCADE,
    CONSTRAINT fk_lex_exercise FOREIGN KEY (exercise_id)    REFERENCES exercises(id)    ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================================================
-- 9. PERSONAL RECORDS (FR03 "Exercises/record", Notification "Record")
-- =========================================================================

DROP TABLE IF EXISTS exercise_records;
CREATE TABLE exercise_records (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT UNSIGNED NOT NULL,
    exercise_id     BIGINT UNSIGNED NOT NULL,
    record_type     ENUM('max_weight','max_reps','max_volume','best_time') NOT NULL,
    value           DECIMAL(10,2) NOT NULL,
    unit            VARCHAR(20),
    achieved_at     DATE NOT NULL,
    workout_log_id  BIGINT UNSIGNED NULL,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_rec_user     FOREIGN KEY (user_id)        REFERENCES users(id)        ON DELETE CASCADE,
    CONSTRAINT fk_rec_exercise FOREIGN KEY (exercise_id)    REFERENCES exercises(id)    ON DELETE CASCADE,
    CONSTRAINT fk_rec_log      FOREIGN KEY (workout_log_id) REFERENCES workout_logs(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- =========================================================================
-- 10. BODY MEASUREMENTS (FR03 "Measures")
-- =========================================================================

DROP TABLE IF EXISTS body_measurements;
CREATE TABLE body_measurements (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT UNSIGNED NOT NULL,
    measured_at     DATE NOT NULL,
    weight_kg       DECIMAL(5,2),
    body_fat_pct    DECIMAL(5,2),
    chest_cm        DECIMAL(5,2),
    waist_cm        DECIMAL(5,2),
    hip_cm          DECIMAL(5,2),
    arm_cm          DECIMAL(5,2),
    thigh_cm        DECIMAL(5,2),
    calf_cm         DECIMAL(5,2),
    shoulder_cm     DECIMAL(5,2),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_measure_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================================================
-- 11. NOTIFICATIONS (FR03 - Notification)
-- =========================================================================

DROP TABLE IF EXISTS notifications;
CREATE TABLE notifications (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT UNSIGNED NOT NULL,          -- recipient
    type            ENUM('friend_post','reminder','record','friend_request','comment','like') NOT NULL,
    actor_id        BIGINT UNSIGNED NULL,              -- who triggered it (friend, commenter...)
    reference_type  VARCHAR(50),                       -- 'post','exercise_record','routine'...
    reference_id    BIGINT UNSIGNED,
    content         VARCHAR(255),
    is_read         BOOLEAN DEFAULT FALSE,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_notif_user  FOREIGN KEY (user_id)  REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_notif_actor FOREIGN KEY (actor_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- =========================================================================
-- 12. AI CHAT (FR04)
-- =========================================================================

DROP TABLE IF EXISTS ai_conversations;
CREATE TABLE ai_conversations (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT UNSIGNED NOT NULL,
    title           VARCHAR(150),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_aiconv_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS ai_messages;
CREATE TABLE ai_messages (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    conversation_id BIGINT UNSIGNED NOT NULL,
    role            ENUM('user','assistant') NOT NULL,
    content         TEXT NOT NULL,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_aimsg_conv FOREIGN KEY (conversation_id) REFERENCES ai_conversations(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================================================
-- 13. GYM ROOMS (FR05)
-- =========================================================================

DROP TABLE IF EXISTS gyms;
CREATE TABLE gyms (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(200) NOT NULL,
    description     TEXT,
    province        VARCHAR(100) NOT NULL,
    district        VARCHAR(100) NOT NULL,
    ward            VARCHAR(100),
    address         VARCHAR(255),
    phone           VARCHAR(20),
    latitude        DECIMAL(10,6),
    longitude       DECIMAL(10,6),
    opening_hours   VARCHAR(100),
    price_range     VARCHAR(100),
    is_active       BOOLEAN DEFAULT TRUE,             -- "vẫn còn hoạt động"
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

DROP TABLE IF EXISTS gym_images;
CREATE TABLE gym_images (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    gym_id          BIGINT UNSIGNED NOT NULL,
    image_url       VARCHAR(255) NOT NULL,
    CONSTRAINT fk_gymimg_gym FOREIGN KEY (gym_id) REFERENCES gyms(id) ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS gym_reviews;
CREATE TABLE gym_reviews (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    gym_id          BIGINT UNSIGNED NOT NULL,
    user_id         BIGINT UNSIGNED NOT NULL,
    rating          TINYINT NOT NULL,
    comment         TEXT,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_review_gym  FOREIGN KEY (gym_id)  REFERENCES gyms(id)  ON DELETE CASCADE,
    CONSTRAINT fk_review_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_rating_range CHECK (rating BETWEEN 1 AND 5)
) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS = 1;

-- =========================================================================
-- INDEXES (read performance for common app queries)
-- =========================================================================

CREATE INDEX idx_posts_user            ON posts(user_id);
CREATE INDEX idx_posts_created         ON posts(created_at);
CREATE INDEX idx_workout_logs_user_date ON workout_logs(user_id, workout_date);
CREATE INDEX idx_routine_user          ON routines(user_id);
CREATE INDEX idx_notifications_user_read ON notifications(user_id, is_read);
CREATE INDEX idx_gyms_location         ON gyms(province, district);
CREATE INDEX idx_exercise_records_user ON exercise_records(user_id, exercise_id);
CREATE INDEX idx_measurements_user_date ON body_measurements(user_id, measured_at);

-- =========================================================================
-- SEED DATA — Muscle groups (for FR03 3D body model + exercise tagging)
-- =========================================================================

INSERT INTO muscle_groups (name, body_model_part) VALUES
('Chest',     'chest'),
('Back',      'back'),
('Shoulders', 'shoulders'),
('Biceps',    'arm_front'),
('Triceps',   'arm_back'),
('Abs',       'core'),
('Quadriceps','leg_front'),
('Hamstrings','leg_back'),
('Glutes',    'glutes'),
('Calves',    'calves');

-- =========================================================================
-- SEED DATA — A few base exercises (system library)
-- =========================================================================

INSERT INTO exercises (name, description, equipment, difficulty, is_custom) VALUES
('Bench Press',   'Compound chest press using a barbell.',  'Barbell',  'intermediate', FALSE),
('Squat',         'Compound lower-body lift.',               'Barbell',  'intermediate', FALSE),
('Deadlift',      'Compound posterior-chain lift.',          'Barbell',  'advanced',     FALSE),
('Pull Up',       'Bodyweight back/bicep pull.',             'Pull-up Bar','beginner',   FALSE),
('Overhead Press','Standing shoulder press.',                'Barbell',  'intermediate', FALSE),
('Plank',         'Core stability hold.',                    'None',     'beginner',     FALSE);

INSERT INTO exercise_muscle_groups (exercise_id, muscle_group_id, is_primary) VALUES
(1, 1, TRUE), (1, 5, FALSE),
(2, 7, TRUE), (2, 9, FALSE), (2, 8, FALSE),
(3, 8, TRUE), (3, 2, FALSE), (3, 9, FALSE),
(4, 2, TRUE), (4, 4, FALSE),
(5, 3, TRUE), (5, 5, FALSE),
(6, 6, TRUE);

-- =========================================================================
-- SEED DATA — Sample "famous/classic" workout plan (FR02)
-- =========================================================================
-- NOTE: routines below are placeholder "template" routines owned by a system
-- account (user_id = 1). Create that admin/system user first in real seeding.

-- INSERT INTO users (id, username, email, password_hash) VALUES
-- (1, 'sisu_system', 'system@sisu.app', 'placeholder_hash');

-- INSERT INTO routines (user_id, name) VALUES
-- (1, 'Push Day'), (1, 'Pull Day'), (1, 'Leg Day');

-- INSERT INTO workout_plans (name, description, level, duration_weeks, is_featured) VALUES
-- ('Push Pull Legs', 'Classic 3-day split for hypertrophy.', 'intermediate', 8, TRUE);

-- INSERT INTO plan_routines (plan_id, routine_id, day_order) VALUES
-- (1, 1, 1), (1, 2, 2), (1, 3, 3);

-- =========================================================================
-- END OF SCRIPT
-- =========================================================================
