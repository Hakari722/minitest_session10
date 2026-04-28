CREATE DATABASE minitest_session10;
USE minitest_session10;

CREATE TABLE Members (
	member_id VARCHAR(5) PRIMARY KEY NOT NULL ,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL,
    membership_type VARCHAR(50) NOT NULL,
    join_date DATE 
);

CREATE TABLE Trainers (
	trainer_id VARCHAR(5) PRIMARY KEY NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(100) NOT NULL,
    experience INT NOT NULL,
    salary DECIMAL(12,2) NOT NULL
);

CREATE TABLE Classes(
	class_id VARCHAR(5) PRIMARY KEY NOT NULL,
    class_name VARCHAR(100) NOT NULL,
    trainer_id VARCHAR(5) NOT NULL,
    FOREIGN KEY (trainer_id) REFERENCES Trainers(trainer_id),
    schedule_time DATETIME NOT NULL,
    max_capacity INT NOT NULL,
    fee DECIMAL(10,2) NOT NULL
);

CREATE TABLE Enrollments(
	enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    class_id VARCHAR(5) NOT NULL,
    FOREIGN KEY(class_id) REFERENCES Classes(class_id),
    member_id VARCHAR(5) NOT NULL,
	FOREIGN KEY(member_id) REFERENCES Members(member_id),
	enrollment_status VARCHAR(20) NOT NULL,
    enroll_date DATE NOT NULL
);

-- ALTER TABLE Members
-- ADD CONSTRAINT member_id UNIQUE;

-- ALTER TABLE Classes
-- ADD CONSTRAINT class_id UNIQUE;

INSERT INTO  Members (member_id, full_name, email, phone, membership_type, join_date)
VALUES
('M01', 'Nguyễn Văn An', 'an.nguyen@gmail.com', 0912345678, 'Premium','2025-01-15'),
('M02', 'Trần Thị Bình', 'binh.tran@gmail.com', 0987654321, 'VIP','2025-02-20'),
('M03', 'Lê Hoàng Cường', 'cuong.le@gmail.com', 0978123456, 'Basic','2025-03-10'),
('M04', 'Phạm Minh Dũng', 'dung.pham@gmail.com', 0909876543, 'Premium','2025-04-05');	


INSERT INTO Trainers(trainer_id, full_name, specialty, experience, salary)
VALUES
('T01', 'Coach Alex', 'Strength Training', 8, 25000000.00),
('T02', 'Huấn luyện viên Lan', 'Yoga & Pilates', 6, 18000000.00),
('T03', 'Coach Minh', 'Functional Fitness', 10, 30000000.00);

INSERT INTO Classes (class_id, class_name, trainer_id, schedule_time, max_capacity,fee)
VALUES
('C01', 'Morning Strength', 'T01', '2025-11-10 06:30:00', 20, 150000.00),
('C02', 'Yoga Flow', 'T02', '2025-11-10 17:30:00', 20,120000.00),
('C03', 'HIIT Burn', 'T03', '2025-11-11 18:00:00', 20, 180000.00),
('C04', 'Power Lifting', 'T01', '2025-11-12 07:00:00', 20, 200000.00);

INSERT INTO Enrollments(class_id, member_id, enrollment_status, enroll_date)
VALUES
('C01', 'M01', 'Confirmed', '2025-11-01'),
('C02', 'M02', 'Confirmed', '2025-11-02'),
('C01', 'M03', 'Canceled', '2025-11-03'),
('C04', 'M01', 'Confirmed', '2025-11-05'),
('C03', 'M04', 'Pending', '2025-11-06');


UPDATE Classes
SET fee = fee * 1.2
WHERE class_id = 'C03';

UPDATE Members
SET  membership_type = 'VIP Elite'
WHERE member_id ='M02';

SET SQL_SAFE_UPDATES = 0;
DELETE 
FROM Enrollments
WHERE enrollment_status = 'Canceled';

ALTER TABLE Classes
ADD CONSTRAINT fee CHECK (fee >= 0);

ALTER TABLE Enrollments
MODIFY enrollment_status VARCHAR(20) NOT NULL DEFAULT 'Pending';

ALTER  TABLE Members
ADD gender VARCHAR(10);

SELECT 
	c.class_id,
    c.class_name,
    c.trainer_id, 
    c.schedule_time, 
    c.max_capacity,
    c.fee
FROM Classes c
JOIN Trainers t ON c.trainer_id = t.trainer_id
WHERE t.specialty LIKE 'Strength%' OR t.specialty LIKE'%Fitness' ;


SELECT 
	full_name, 
    email
FROM Members
WHERE full_name LIKE '%n%';

SELECT
	class_id, 
    class_name, 
    schedule_time
FROM Classes
ORDER BY schedule_time ASC;

SELECT
	c.class_name, 
    t.specialty
FROM  Trainers t
JOIN Classes c ON c.trainer_id = t.trainer_id
LIMIT 2 OFFSET 2;

UPDATE Classes
SET fee = fee * 0.85
WHERE TIME(schedule_time) < '12:00:00';


UPDATE Members
SET full_name = UPPER(full_name);

DELETE 
FROM Enrollments
WHERE class_id IN (
		Select 
			class_id 
		FROM Classes
        WHERE fee = 0
);

DELETE 
FROM Classes
WHERE fee = 0;

SELECT 
	e.enrollment_id, 
    m.full_name,
    c.class_name, 
    t.full_name AS team_name
FROM Enrollments e
JOIN Members m ON m.member_id = e.member_id
JOIN Classes c ON c.class_id = e.class_id
JOIN Trainers t ON t.trainer_id = c.trainer_id
WHERE enrollment_status = 'Confirmed';

SELECT 
    c.class_name, 
    c.schedule_time
FROM Classes c
LEFT JOIN Enrollments e ON c.class_id = e.class_id;

SELECT 
    enrollment_status,
    COUNT(enrollment_id) AS total
FROM Enrollments
GROUP BY enrollment_status;

SELECT 
    m.full_name,
    COUNT(e.class_id) AS total_classes
FROM Members m
JOIN Enrollments e 
    ON m.member_id = e.member_id
GROUP BY m.member_id, m.full_name
HAVING COUNT(e.class_id) >= 2;
