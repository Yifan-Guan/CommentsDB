use comments;

INSERT INTO `book_comments` (
`book_comment_id`,
`recommendation_degree`,
`book_comment_content`
)
VALUES 
(1001, 0, "Test comment : Deletion containing transaction application.");

INSERT INTO `views` (
`view_book_comment_id`,
`view_chapter_id`,
`view_create_time`,
`view_reader_name`,
`view_ip_address`
)
VALUES 
(1001, 1, "2002-04-06", "77", "test ip");

INSERT INTO `analyses` (
`analysis_comment_id`,
`analysis_scale_id`,
`analysis_result`
)
VALUES 
(1001, 1,
"Test for deletion containing transaction application."
);