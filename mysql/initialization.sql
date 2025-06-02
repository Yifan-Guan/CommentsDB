use comments;

INSERT INTO `book_comments` (
`book_comment_id`,
`recommendation_degree`,
`book_comment_content`
)
VALUES 
(1, 0, "Test comment example"),
(2, 0, "重温经典！同道中人点个赞"),
(3, 0, "好看吗 老夫十年书虫但是就是没看过番茄的吞噬星空 哈哈哈希望不会失望"),
(4, 0, "重温经典 又是一遍 从高二第一次看 现在已经大二了"),
(5, 0, "打卡，不知道刷第几遍了，第一次追还是高中那会，记得后期完结的挺突兀的，本以为起源之地起码还要写不少时间，结果突然就结局了，不过确实是难得的好书，修炼等级清晰，时间线，世界观，还有战斗场面都不错。"),
(6, 0, "科技层次的衡量标准之一就是对于能源的利用程度，越发达肯定是电越便宜，电梯的电相对于能量罩的电根本就是大海中的一滴水，有必要这样来省电么……"),
(7, 0, 
"巴菲特注重价值投资，
就从他08年持有比亚迪，涨到80不出手，跌到20不出手，再涨到220还是不出手");

INSERT INTO  `evaluation_scales` (
`evaluation_scale_id`,
`evaluation_scale_name`,
`evaluation_scale_path`
)
VALUES 
(1, "Test evaluation scale example", "Test path"),
(2, "科幻网文评价维度", "./science_fiction_scale.xlsx");

INSERT INTO `chapters` (
`chapter_id`,
`chapter_name`,
`chapter_volume`,
`chapter_url`
)
VALUES 
(1, "Test chapter name", "Test volume", "Test chapter url"),
(2, "第一章 罗峰",
 "第一篇 一夜觉醒 第一集 深夜觉醒·共20章 免费",
 "www.qidian.com/chapter/1639199/28520417/"),
 (3, "第二章 RR",
 "第一篇 一夜觉醒 第一集 深夜觉醒·共20章 免费",
 "www.qidian.com/chapter/1639199/28525150/");

INSERT INTO `books` (
`book_id`,
`book_name`,
`book_type`,
`book_introduction`,
`book_url`
)
VALUES 
(1, "Test book name", "Test type", "Test book introduction", "Test book url"),
(2, "吞噬星空", "科幻", 
"继《九鼎记》《盘龙》《星辰变》《寸芒》《星峰传说》后，番茄的第六本书！
星空中。
“这颗星球，通体土黄色，没有任何生命存在，直径21000公里，咦，竟然蕴含‘星泪金’矿脉，真是天助我也，将这颗星球吞噬掉后，我的实力应该能恢复到受伤前的80％。”脸色苍白的罗峰盘膝坐在一颗飞行的陨石上，遥看远处的一颗无生命存在的行星。
番茄第六部小说《吞噬星空》，将为大家展现出一个浩瀚广阔、神秘莫测的未来世界。
。",
"https://www.qidian.com/book/1639199/");

INSERT INTO `authors` (
`author_id`,
`author_name`,
`author_introduction`
)
VALUES 
(1, "Test author name", "Test author introduction"),
(2, "我吃西红柿",
"阅文集团白金作家，网络文学代表人物之一，作品留下无数神话般的纪录。"
);

INSERT INTO `book_platforms` (
`book_platform_id`,
`book_platform_name`,
`book_platform_introduction`,
`book_platform_url`
)
VALUES
(1, "Test book platform", "Test book platform introduction", "Test book platform url"),
(2, "起点中文网", 
"起点中文网是阅文集团旗下原创文学网站，创立于2002年5月，总部位于中国（上海）自由贸易试验区环科路999弄1号，起点中文网以推动中国原创文学事业为宗旨，形成创作、培养、销售为一体的电子在线出版机制，拥有玄幻、武侠、都市、历史等题材作品起点中文网是阅文集团旗下原创文学网站，创立于2002年5月，总部位于中国（上海）自由贸易试验区环科路999弄1号，起点中文网以推动中国原创文学事业为宗旨，形成创作、培养、销售为一体的电子在线出版机制，拥有玄幻、武侠、都市、历史等题材作品", 
"https://www.qidian.com/all/");

INSERT INTO `views` (
`view_book_comment_id`,
`view_chapter_id`,
`view_create_time`,
`view_reader_name`,
`view_ip_address`
)
VALUES 
(1, 1, "2002-04-06", "Test reader", "Test ip"),
(2, 2, "2017-08-19", "贰貨Qiqi", "未知"),
(3, 2, "2024-07-10", "财神爷s", "浙江"),
(4, 2, "2024-06-17", "再等几分钟", "吉林"),
(5, 2, "2023-10-30", "青雪尘", "广东"),
(6, 3, "2020-06-20", "梦三巡", "未知"),
(7, 3, "2021-04-03", "阿贝尔的日记", "北京");

INSERT INTO `analyses` (
`analysis_comment_id`,
`analysis_scale_id`,
`analysis_result`
)
VALUES 
(1, 1, "Test analysis result"),
(2, 2,
""
),
(3, 2,
""
),
(4, 2,
""
),
(5, 2,
""
),
(6, 2,
""
);

INSERT INTO `book_chapter` (
`bc_chapter_id`,
`bc_book_id`
)
VALUES 
(1, 1),
(2, 2),
(3, 2);

INSERT INTO `book_information` (
`bi_book_id`,
`bi_author_id`,
`bi_platform_id`
) 
VALUES 
(1, 1, 1),
(2, 2, 2);