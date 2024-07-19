-- Step 1: Create a database

-- CREATE DATABASE myisam_test;
USE myisam_test;

-- Step 2: Create a table with MyISAM engine, including boolean, date, and timestamp columns
CREATE TABLE test_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    is_active BOOLEAN,      -- Boolean column
    created_date DATE,      -- Date column
    updated_at TIMESTAMP    -- Timestamp column
) ENGINE=MyISAM;

-- Step 3: Insert 20 rows of data
INSERT INTO test_table (name, age, is_active, created_date, updated_at) VALUES 
('Alice', 30, TRUE, '2023-01-01', '2023-01-01 12:00:00'),
('Bob', 25, FALSE, '2023-02-01', '2023-02-01 13:00:00'),
('Charlie', 35, TRUE, '2023-03-01', '2023-03-01 14:00:00'),
('David', 28, TRUE, '2023-04-01', '2023-04-01 15:00:00'),
('Eve', 22, FALSE, '2023-05-01', '2023-05-01 16:00:00'),
('Frank', 40, TRUE, '2023-06-01', '2023-06-01 17:00:00'),
('Grace', 27, FALSE, '2023-07-01', '2023-07-01 18:00:00'),
('Heidi', 33, TRUE, '2023-08-01', '2023-08-01 19:00:00'),
('Ivan', 29, TRUE, '2023-09-01', '2023-09-01 20:00:00'),
('Judy', 31, FALSE, '2023-10-01', '2023-10-01 21:00:00'),
('Ken', 26, TRUE, '2023-11-01', '2023-11-01 22:00:00'),
('Laura', 24, FALSE, '2023-12-01', '2023-12-01 23:00:00'),
('Mallory', 37, TRUE, '2024-01-01', '2024-01-01 10:00:00'),
('Niaj', 21, TRUE, '2024-02-01', '2024-02-01 11:00:00'),
('Olivia', 32, FALSE, '2024-03-01', '2024-03-01 12:00:00'),
('Peggy', 38, TRUE, '2024-04-01', '2024-04-01 13:00:00'),
('Quentin', 23, FALSE, '2024-05-01', '2024-05-01 14:00:00'),
('Ruth', 34, TRUE, '2024-06-01', '2024-06-01 15:00:00'),
('Sybil', 39, FALSE, '2024-07-01', '2024-07-01 16:00:00'),
('Trent', 36, TRUE, '2024-08-01', '2024-08-01 17:00:00');

CREATE INDEX idx_name ON test_table(name);
