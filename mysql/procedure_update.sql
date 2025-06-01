INSERT INTO `authors` (
`author_id`,
`author_name`,
`author_introduction`
)
VALUES 
(6001, "Procedure test author name", "Procedure test author introduction");

INSERT INTO `books` (
`book_id`,
`book_name`,
`book_type`,
`book_introduction`,
`book_url`
)
VALUES 
(6001, "Procedure test book name", "Procedure test type", 
"Procedure test book introduction", "Procedure test book url");

INSERT INTO `book_platforms` (
`book_platform_id`,
`book_platform_name`,
`book_platform_introduction`,
`book_platform_url`
)
VALUES
(6001, "Procedure test book platform", 
"Procedure test book platform introduction", "Procedure test book platform url");

INSERT INTO `book_information` (
`bi_book_id`,
`bi_author_id`,
`bi_platform_id`
) 
VALUES 
(6001, 6001, 6001);