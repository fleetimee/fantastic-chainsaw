SELECT u.username, ur.role_id_role, ur.user_uuid, r.role_name, r.id_role
FROM users u
         INNER JOIN user_role ur
                    ON u.uuid = ur.user_uuid
         INNER JOIN roles r
                    ON r.id_role = ur.role_id_role
WHERE id_role = 1;

SELECT *
FROM roles;

SELECT *
FROM "knowledges"
ORDER BY created_at DESC
LIMIT 10;

SELECT *
FROM "references"
WHERE code_ref1 = '001';

SELECT *
FROM "references";

SELECT *
FROM "references"
WHERE code_ref1 = '001';

SELECT *
FROM knowledges;

SELECT *
FROM "quizzes"
WHERE quiz_title ILIKE '%jav%'
ORDER BY id_quiz DESC
LIMIT 2;

SELECT *
FROM sections;

SELECT *
FROM "references"
WHERE code_ref1 = '004'
  AND code_ref2 = '0043';


-- QUERIES FOR THE LIST OF THREAD
-- IN THE COURSE
SELECT c.course_name, t.threads_title, t.created_at
FROM courses c
         INNER JOIN threads t
                    ON c.id_course = t.id_course
WHERE c.id_course = 1
ORDER BY t.created_at;

SELECT *
FROM threads
WHERE id_course = 1
ORDER BY created_at DESC
LIMIT 10;


-- QUERIES FOR THE FORUM POSTS
-- IN THE THREADS
SELECT u.username, c.course_name, t.threads_title, p.content, p.created_at
FROM courses c
         INNER JOIN threads t
                    ON c.id_course = t.id_course
         INNER JOIN posts p
                    ON t.id_threads = p.id_threads
         INNER JOIN users u
                    ON p.user_uuid = u.uuid
WHERE t.id_threads = 1
ORDER BY p.created_at DESC;

SELECT *
FROM threads
WHERE id_threads = 1;

SELECT p.id_post,
       t.id_threads,
       t.threads_title,
       p.content,
       p.created_at,
       p.updated_at,
       u.username,
       u.uuid AS user_uuid,
       c.course_name,
       r.role_name
FROM courses c
         INNER JOIN threads t
                    ON c.id_course = t.id_course
         INNER JOIN posts p
                    ON t.id_threads = p.id_threads
         INNER JOIN users u
                    ON p.user_uuid = u.uuid
         INNER JOIN user_role ur
                    ON u.uuid = ur.user_uuid
         INNER JOIN roles r
                    ON r.id_role = ur.role_id_role
WHERE t.id_threads = 1
ORDER BY p.created_at
LIMIT 10 OFFSET 0;

INSERT INTO posts (id_threads, user_uuid, content)
VALUES (?, ?, ?)
RETURNING id_post, id_threads, user_uuid, content, created_at, updated_at;


SELECT *
FROM posts
WHERE id_threads = 6;

-- Count the number course that a user has
SELECT COUNT(c.id_course) AS number_of_course
FROM courses c
         INNER JOIN user_course uc
                    ON c.id_course = uc.course_id_course
WHERE uc.user_uuid = '02cf0f69-55bb-4ff7-8efd-9fc06353fec5';


-- Count the number of post that a user has
SELECT COUNT(p.id_post) AS number_of_post
FROM posts p
         INNER JOIN users u
                    ON p.user_uuid = u.uuid
WHERE u.uuid = 'cf97bdce-fd2d-415c-8ae7-7f998e2b1987';

-- Count the number of quiz that a user has
SELECT COUNT(q.id_quiz) AS number_of_quiz
FROM quizzes q
         INNER JOIN user_quizzes uq
                    ON q.id_quiz = uq.id_quiz
WHERE uq.user_uuid = '02cf0f69-55bb-4ff7-8efd-9fc06353fec5';

-- Average score of a user quiz in a course
SELECT AVG(uq.score) AS average_score
FROM user_quizzes uq
         INNER JOIN users u
                    ON uq.user_uuid = u.uuid
         INNER JOIN quizzes q
                    ON uq.id_quiz = q.id_quiz
WHERE u.uuid = '02cf0f69-55bb-4ff7-8efd-9fc06353fec5';

-- count how many times a user has taken a quiz by quiz id
SELECT q.id_quiz, q.quiz_title, COUNT(uq.id_quiz) AS attemps
FROM user_quizzes uq
         INNER JOIN users u
                    ON uq.user_uuid = u.uuid
         INNER JOIN quizzes q
                    ON uq.id_quiz = q.id_quiz
WHERE u.uuid = '02cf0f69-55bb-4ff7-8efd-9fc06353fec5'
  AND q.id_quiz = 1
GROUP BY q.id_quiz;

-- count how many times a user has taken a quiz by quiz id and get the attempt count
SELECT q.id_quiz, q.quiz_title, COUNT(uq.id_quiz) AS attemps
FROM user_quizzes uq
         INNER JOIN users u
                    ON uq.user_uuid = u.uuid
         INNER JOIN quizzes q
                    ON uq.id_quiz = q.id_quiz
WHERE u.uuid = '02cf0f69-55bb-4ff7-8efd-9fc06353fec5'
  AND q.id_quiz = 1
GROUP BY q.id_quiz;

-- list of quiz that a user has taken
SELECT q.id_quiz, q.quiz_title, q.quiz_desc, r.value_ref1 AS quiz_type, q.created_at, uq.score
FROM quizzes q
         INNER JOIN user_quizzes uq
                    ON q.id_quiz = uq.id_quiz
         INNER JOIN "references" r
                    ON q.quiz_type = r.code_ref2
WHERE uq.user_uuid = '02cf0f69-55bb-4ff7-8efd-9fc06353fec5';

-- count list of quiz that a user has taken
SELECT COUNT(q.id_quiz)
FROM quizzes q
         INNER JOIN user_quizzes uq
                    ON q.id_quiz = uq.id_quiz
         INNER JOIN "references" r
                    ON q.quiz_type = r.code_ref2
WHERE uq.user_uuid = '02cf0f69-55bb-4ff7-8efd-9fc06353fec5';


-- view recent post that a user has made in a thread
SELECT p.id_post,
       c.id_course,
       t.id_threads,
       t.threads_title,
       p.content,
       p.created_at,
       p.updated_at,
       u.username,
       u.uuid AS user_uuid,
       c.course_name,
       r.role_name
FROM courses c
         INNER JOIN threads t
                    ON c.id_course = t.id_course
         INNER JOIN posts p
                    ON t.id_threads = p.id_threads
         INNER JOIN users u
                    ON p.user_uuid = u.uuid
         INNER JOIN user_role ur
                    ON u.uuid = ur.user_uuid
         INNER JOIN roles r
                    ON r.id_role = ur.role_id_role
WHERE u.uuid = '02cf0f69-55bb-4ff7-8efd-9fc06353fec5'
ORDER BY p.created_at DESC
LIMIT 10;


-- Get link quiz to course
SELECT c.id_course, c.course_name, q.quiz_title, q.quiz_desc, q.created_at
FROM courses c
         INNER JOIN section_course sc
                    ON c.id_course = sc.course_id_course
         INNER JOIN sections s
                    ON sc.section_id_section = s.id_section
         INNER JOIN quizzes q
                    ON s.id_section = q.id_section
WHERE q.id_quiz = 99;

-- Get user role status
SELECT r.role_name
FROM users u
         INNER JOIN user_role ur
                    ON u.uuid = ur.user_uuid
         INNER JOIN roles r
                    ON r.id_role = ur.role_id_role
WHERE u.uuid = 'b3b9b16c-490f-4b02-9ab6-f7cca037f08b';


-- Select course that a user has enrolled that can be searched by course name
SELECT c.id_course, c.id_knowledge, c.course_name, c.course_desc, c.image, c.created_at, c.updated_at
FROM courses c
         INNER JOIN user_course uc
                    ON c.id_course = uc.course_id_course
WHERE uc.user_uuid = '02cf0f69-55bb-4ff7-8efd-9fc06353fec5'
  AND c.course_name ILIKE '%Python%'
ORDER BY c.created_at DESC
LIMIT 10 OFFSET 0;

-- count how many course that a user has enrolled
SELECT COUNT(c.id_course) AS number_of_course
FROM courses c
         INNER JOIN user_course uc
                    ON c.id_course = uc.course_id_course
WHERE uc.user_uuid = '02cf0f69-55bb-4ff7-8efd-9fc06353fec5';

SELECT c.id_course,
       c.id_knowledge,
       c.course_name,
       c.course_desc,
       c.image,
       c.date_start,
       c.date_end,
       c.created_at,
       c.updated_at
FROM courses c
         INNER JOIN user_course uc
                    ON c.id_course = uc.course_id_course
WHERE uc.user_uuid = '02cf0f69-55bb-4ff7-8efd-9fc06353fec5'
  AND c.course_name ILIKE '%%'
ORDER BY c.created_at
LIMIT 10 OFFSET 0;


-- select quiz that a user has taken and no duplicate
-- also average score of the quiz if user taken the quiz more than once
SELECT subq.id_quiz,
       subq.quiz_title,
       subq.quiz_desc,
       subq.value_ref1 AS quiz_type,
       subq.created_at,
       subq.average_score
FROM (SELECT q.id_quiz, q.quiz_title, q.quiz_desc, r.value_ref1, q.created_at, AVG(uq.score) AS average_score
      FROM quizzes q
               INNER JOIN user_quizzes uq ON q.id_quiz = uq.id_quiz
               INNER JOIN "references" r ON q.quiz_type = r.code_ref2
      WHERE uq.user_uuid = '02cf0f69-55bb-4ff7-8efd-9fc06353fec5'
      GROUP BY q.id_quiz, q.quiz_title, q.quiz_desc, q.quiz_type, q.created_at, r.value_ref1) subq
ORDER BY subq.average_score
LIMIT 10 OFFSET 0;

-- count query above
SELECT COUNT(subq.id_quiz)
FROM (SELECT q.id_quiz, q.quiz_title, q.quiz_desc, r.value_ref1, q.created_at, AVG(uq.score) AS average_score
      FROM quizzes q
               INNER JOIN user_quizzes uq ON q.id_quiz = uq.id_quiz
               INNER JOIN "references" r ON q.quiz_type = r.code_ref2
      WHERE uq.user_uuid = '02cf0f69-55bb-4ff7-8efd-9fc06353fec5'
      GROUP BY q.id_quiz, q.quiz_title, q.quiz_desc, q.quiz_type, q.created_at, r.value_ref1) subq;


SELECT c.id_course, c.course_name, q.quiz_title, q.quiz_desc, q.created_at
FROM courses c
         INNER JOIN section_course sc
                    ON c.id_course = sc.course_id_course
         INNER JOIN sections s
                    ON sc.section_id_section = s.id_section
         INNER JOIN quizzes q
                    ON s.id_section = q.id_section
WHERE q.id_quiz = '2';

-- Get question and answer of a quiz
SELECT q.id_quiz, q.quiz_title, qu.question_text, a.answer_text, a.is_correct
FROM quizzes q
         INNER JOIN questions qu
                    ON q.id_quiz = qu.id_quiz
         INNER JOIN answers a
                    ON qu.id_question = a.id_question
WHERE q.id_quiz = 2;


-- Get user that taken a quiz by quiz id and get the attempt count
SELECT DISTINCT u.username, u.uuid as user_uuid, COUNT(uq.id_quiz) AS attemps
FROM users u
         INNER JOIN user_quizzes uq
                    ON u.uuid = uq.user_uuid
WHERE uq.id_quiz = 1
GROUP BY u.uuid
LIMIT 10 OFFSET 0;

-- join user selected_answer with answer parse json b
SELECT u.username, u.uuid, uq.id_user_quiz, uq.score, uq.selected_answers, b.answer_text, b.is_correct
FROM users u
         INNER JOIN user_quizzes uq
                    ON u.uuid = uq.user_uuid
         INNER JOIN LATERAL JSONB_ARRAY_ELEMENTS_TEXT(uq.selected_answers) AS a ON TRUE
         INNER JOIN answers b
                    ON a::int = b.id_answer
WHERE uq.id_quiz = 1;

SELECT DISTINCT uq.id_user_quiz, uq.user_uuid, q.*, a.*
FROM questions q
         INNER JOIN (SELECT key::int AS question_id, value::int AS answer_id
                     FROM user_quizzes uq
                              CROSS JOIN LATERAL JSONB_EACH_TEXT(selected_answers
                         ) AS json_data) data ON q.id_question = data.question_id
         INNER JOIN answers a ON data.answer_id = a.id_answer
         INNER JOIN user_quizzes uq ON q.id_quiz = uq.id_quiz
WHERE q.id_quiz = 2 AND uq.user_uuid = '02cf0f69-55bb-4ff7-8efd-9fc06353fec5';

SELECT COUNT(q.id_quiz)
FROM user_quizzes uq
         INNER JOIN quizzes q ON uq.id_quiz = q.id_quiz
         INNER JOIN users u ON uq.user_uuid = u.uuid
WHERE q.id_quiz = 1;

-- count only distinct user from quiz
SELECT COUNT(DISTINCT u.uuid)
FROM user_quizzes uq
         INNER JOIN quizzes q ON uq.id_quiz = q.id_quiz
         INNER JOIN users u ON uq.user_uuid = u.uuid
WHERE q.id_quiz = 1;

-- get question and answer of a quiz
SELECT DISTINCT qu.id_question, qu.id_quiz, qu.question_text, a.*
FROM quizzes q
         INNER JOIN questions qu
                    ON q.id_quiz = qu.id_quiz
         INNER JOIN answers a
                    ON qu.id_question = a.id_question
WHERE q.id_quiz = 1;

SELECT * FROM "answers" WHERE "answers"."id_question" IN (1,2,3);

SELECT * FROM "questions" WHERE "questions"."id_quiz" = 1;

SELECT * FROM "quizzes" WHERE "quizzes"."id_quiz" = 1 ORDER BY "quizzes"."id_quiz" LIMIT 1;

-- get all quiz attempt by user
SELECT uq.id_user_quiz, uq.user_uuid, q.*, a.*
FROM questions q
         INNER JOIN (SELECT key::int AS question_id, value::int AS answer_id
                     FROM user_quizzes uq
                              CROSS JOIN LATERAL JSONB_EACH_TEXT(selected_answers
                         ) AS json_data) data ON q.id_question = data.question_id
         INNER JOIN answers a ON data.answer_id = a.id_answer
         INNER JOIN user_quizzes uq ON q.id_quiz = uq.id_quiz
WHERE uq.user_uuid = '02cf0f69-55bb-4ff7-8efd-9fc06353fec5';


SELECT q.id_quiz,
       uq.id_user_quiz,
       uq.user_uuid,
       u.username,
       r.value_ref1 AS quiz_type,
       q.created_at,
       uq.score
FROM quizzes q
         INNER JOIN user_quizzes uq
                    ON q.id_quiz = uq.id_quiz
         INNER JOIN "references" r
                    ON q.quiz_type = r.code_ref2
         INNER JOIN users u
                    ON uq.user_uuid = u.uuid
WHERE q.id_quiz = 1
ORDER BY uq.score DESC;