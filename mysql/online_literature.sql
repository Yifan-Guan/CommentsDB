CREATE DATABASE IF NOT EXISTS `comments`;
USE comments;

CREATE TABLE IF NOT EXISTS `book_comments` (
`book_comment_id` BIGINT UNSIGNED AUTO_INCREMENT,
`recommendation_degree` TINYINT UNSIGNED DEFAULT 0,
`book_comment_content` TEXT,
PRIMARY KEY (`book_comment_id`)
) DEFAULT CHARSET=`utf8mb4`;

CREATE TABLE IF NOT EXISTS `evaluation_scales` (
`evaluation_scale_id` SMALLINT UNSIGNED AUTO_INCREMENT,
`evaluation_scale_name` TINYTEXT,
`evaluation_scale_path` TINYTEXT,
PRIMARY KEY(`evaluation_scale_id`)
) DEFAULT CHARSET=`utf8mb4`;

CREATE TABLE IF NOT EXISTS `chapters` (
`chapter_id` BIGINT UNSIGNED AUTO_INCREMENT,
`chapter_name` TINYTEXT,
`chapter_volume` TINYTEXT,
`chapter_url` TINYTEXT,
PRIMARY KEY(`chapter_id`)
) DEFAULT CHARSET=`utf8mb4`;

CREATE TABLE IF NOT EXISTS `books` (
`book_id` INT UNSIGNED AUTO_INCREMENT,
`book_name` TINYTEXT,
`book_type` TINYTEXT,
`book_introduction` TEXT,
`book_url` TINYTEXT,
PRIMARY KEY(`book_id`)
) DEFAULT CHARSET=`utf8mb4`;

CREATE TABLE IF NOT EXISTS `authors` (
`author_id` INT UNSIGNED AUTO_INCREMENT,
`author_name` TINYTEXT,
`author_introduction` TEXT,
PRIMARY KEY(`author_id`)
) DEFAULT CHARSET=`utf8mb4`;

CREATE TABLE IF NOT EXISTS `book_platforms` (
`book_platform_id` SMALLINT UNSIGNED AUTO_INCREMENT,
`book_platform_name` TINYTEXT,
`book_platform_introduction` TEXT,
`book_platform_url` TINYTEXT,
PRIMARY KEY(`book_platform_id`)
) DEFAULT CHARSET=`utf8mb4`;

CREATE TABLE IF NOT EXISTS `views` (
`view_book_comment_id` BIGINT UNSIGNED,
`view_chapter_id` BIGINT UNSIGNED,
`view_create_time` DATE,
`view_reader_name` TINYTEXT,
`view_ip_address` TINYTEXT,
PRIMARY KEY(`view_book_comment_id`),
FOREIGN KEY(`view_book_comment_id`) REFERENCES book_comments(`book_comment_id`) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(`view_chapter_id`) REFERENCES chapters(`chapter_id`) ON DELETE CASCADE ON UPDATE CASCADE
) DEFAULT CHARSET=`utf8mb4`;

CREATE TABLE IF NOT EXISTS `analyses` (
`analysis_comment_id` BIGINT UNSIGNED,
`analysis_scale_id` SMALLINT UNSIGNED,
`analysis_result` TEXT,
PRIMARY KEY(`analysis_comment_id`),
FOREIGN KEY(`analysis_comment_id`) REFERENCES book_comments(`book_comment_id`) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(`analysis_scale_id`) REFERENCES evaluation_scales(`evaluation_scale_id`) ON DELETE CASCADE ON UPDATE CASCADE
) DEFAULT CHARSET=`utf8mb4`;

CREATE TABLE IF NOT EXISTS `book_chapter` (
`bc_chapter_id` BIGINT UNSIGNED,
`bc_book_id` INT UNSIGNED,
PRIMARY KEY(`bc_chapter_id`),
FOREIGN KEY(`bc_chapter_id`) REFERENCES chapters(`chapter_id`) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(`bc_book_id`) REFERENCES books(`book_id`) ON DELETE CASCADE ON UPDATE CASCADE
) DEFAULT CHARSET=`utf8mb4`;

CREATE TABLE IF NOT EXISTS `book_information` (
`bi_book_id` INT UNSIGNED,
`bi_author_id` INT UNSIGNED,
`bi_platform_id` SMALLINT UNSIGNED,
PRIMARY KEY(`bi_book_id`),
FOREIGN KEY(`bi_book_id`) REFERENCES books(`book_id`) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(`bi_author_id`) REFERENCES authors(`author_id`) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(`bi_platform_id`) REFERENCES book_platforms(`book_platform_id`) ON DELETE CASCADE ON UPDATE CASCADE
) DEFAULT CHARSET=`utf8mb4`;

CREATE TABLE IF NOT EXISTS `statistics` (
`statistic_id` TINYINT UNSIGNED AUTO_INCREMENT,
`statistic_name` TINYTEXT,
`statistic_number_value` BIGINT UNSIGNED,
`statistic_text_value` TINYTEXT,
PRIMARY KEY(`statistic_id`)
) DEFAULT CHARSET=`utf8mb4`;
INSERT INTO `statistics` (
`statistic_id`,
`statistic_name`,
`statistic_number_value`,
`statistic_text_value`)
VALUES 
(1, "Numbers of book comments", 0, ""),
(2, "Numbers of books", 0, ""),
(3, "Numbers of authors", 0, "");

CREATE TRIGGER `comment_count_trigger` AFTER INSERT ON `book_comments` FOR EACH ROW
UPDATE `statistics` SET 	`statistic_number_value` = `statistic_number_value` + 1 
WHERE `statistic_id` = 1;