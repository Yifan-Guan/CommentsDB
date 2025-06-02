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
`evaluation_scale_name` VARCHAR(100),
`evaluation_scale_path` TINYTEXT,
PRIMARY KEY(`evaluation_scale_id`)
) DEFAULT CHARSET=`utf8mb4`;

CREATE TABLE IF NOT EXISTS `chapters` (
`chapter_id` BIGINT UNSIGNED AUTO_INCREMENT,
`chapter_name` VARCHAR(100),
`chapter_volume` VARCHAR(100),
`chapter_url` TINYTEXT,
PRIMARY KEY(`chapter_id`)
) DEFAULT CHARSET=`utf8mb4`;

CREATE TABLE IF NOT EXISTS `books` (
`book_id` INT UNSIGNED AUTO_INCREMENT,
`book_name` VARCHAR(100),
`book_type` VARCHAR(100),
`book_introduction` TEXT,
`book_url` TINYTEXT,
PRIMARY KEY(`book_id`)
) DEFAULT CHARSET=`utf8mb4`;

CREATE TABLE IF NOT EXISTS `authors` (
`author_id` INT UNSIGNED AUTO_INCREMENT,
`author_name` VARCHAR(100),
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

CREATE TRIGGER `comment_after_insert_trigger` AFTER INSERT ON `book_comments` FOR EACH ROW
UPDATE `statistics` SET 	`statistic_number_value` = `statistic_number_value` + 1 
WHERE `statistic_id` = 1;

CREATE TRIGGER `comment_after_delete_trigger` AFTER DELETE ON `book_comments` FOR EACH ROW
UPDATE `statistics` SET 	`statistic_number_value` = `statistic_number_value` - 1 
WHERE `statistic_id` = 1;

CREATE TRIGGER `book_after_insert_trigger` AFTER INSERT ON `books` FOR EACH ROW
UPDATE `statistics` SET 	`statistic_number_value` = `statistic_number_value` + 1 
WHERE `statistic_id` = 2;

CREATE TRIGGER `book_after_delete_trigger` AFTER DELETE ON `books` FOR EACH ROW
UPDATE `statistics` SET 	`statistic_number_value` = `statistic_number_value` - 1 
WHERE `statistic_id` = 2;

CREATE TRIGGER `author_after_insert_trigger` AFTER INSERT ON `authors` FOR EACH ROW
UPDATE `statistics` SET 	`statistic_number_value` = `statistic_number_value` + 1 
WHERE `statistic_id` = 3;

CREATE TRIGGER `author_after_delete_trigger` AFTER DELETE ON `authors` FOR EACH ROW
UPDATE `statistics` SET 	`statistic_number_value` = `statistic_number_value` - 1 
WHERE `statistic_id` = 3;


DELIMITER ;;
CREATE TRIGGER `comment_before_insert_trigger` BEFORE INSERT ON `book_comments` FOR EACH ROW
BEGIN
	DECLARE `error_msg` VARCHAR(100);
	IF NEW.`recommendation_degree` > 10 THEN
		SET `error_msg` = "The value of recommend degree is between 0 and 10.";
		SIGNAL SQLSTATE "04061" SET MESSAGE_TEXT = `error_msg`;
	END IF;
END;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `update_author_information`(
IN `u_id` INT UNSIGNED,
IN `u_name` VARCHAR(100),
IN `u_introduction` TEXT)
BEGIN
	DECLARE `table_have` TINYINT;
	DECLARE `old_id` INT UNSIGNED;
    DECLARE `error_msg` VARCHAR(100);
	SELECT COUNT(*) FROM `authors` WHERE `author_name` = `u_name` INTO `table_have`;
	IF `table_have` = 0 THEN
		SET `error_msg` = "No such author, insert first";
        SIGNAL SQLSTATE "04062" SET MESSAGE_TEXT = `error_msg`;
	ELSE
		UPDATE `authors` SET `author_id` = `u_id`, `author_introduction` = `u_introduction`
        WHERE `author_name` = `u_name`;
	END IF;
END;;
DELIMITER ;

CREATE VIEW `complete_book_information` AS
SELECT `book_id`, `book_name`, `book_type`, `author_name`, 
`book_platform_name`, `book_introduction`, `book_url`
FROM `books`, `authors`, `book_platforms`, `book_information`
WHERE `books`.`book_id` = `book_information`.`bi_book_id`
AND `book_information`.`bi_author_id` = `authors`.`author_id`
AND `book_information`.`bi_platform_id` = `book_platforms`.`book_platform_id`;

CREATE VIEW `complete_comment_information` AS
SELECT DISTINCT `book_comment_id`, `view_create_time`, `view_reader_name`, `view_ip_address`, 
`book_name`, `book_comment_content`
FROM `book_comments`, `views`, `book_chapter`, `books`, `book_information`
WHERE `book_comments`.`book_comment_id` = `views`.`view_book_comment_id`
AND `views`.`view_chapter_id` = `book_chapter`.`bc_book_id`
AND `book_chapter`.`bc_book_id` = `books`.`book_id`;