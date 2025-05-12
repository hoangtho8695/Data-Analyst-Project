-- REMOVING DUPLICATES

SELECT *
FROM `google-play-app-project`.`data-google-play-store-apps`;
CREATE TABLE `google-play-app-project`.`data2`
LIKE `google-play-app-project`.`data-google-play-store-apps`;

SET SESSION sql_mode = '';
-- Insert the value from the original table
INSERT `google-play-app-project`.`data2`
SELECT *
FROM `google-play-app-project`.`data-google-play-store-apps`;

WITH duplicate_cte AS (
SELECT *,
	row_number() OVER(
    PARTITION BY App, Category, Rating, Reviews, Size, Installs, `Type`, Price, Content_Rating, Genres, Last_Updated2, Current_Ver, Android_Ver)
    as row_num
FROM `google-play-app-project`.`data2`)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE `google-play-app-project`.`data3` (
  `App` varchar(255) DEFAULT NULL,
  `Category` varchar(255) DEFAULT NULL,
  `Rating` float DEFAULT NULL,
  `Reviews` int DEFAULT NULL,
  `Size` varchar(255) DEFAULT NULL,
  `Installs` varchar(255) DEFAULT NULL,
  `Type` varchar(255) DEFAULT NULL,
  `Price` varchar(255) DEFAULT NULL,
  `Content_Rating` varchar(255) DEFAULT NULL,
  `Genres` varchar(255) DEFAULT NULL,
  `Last_Updated2` date DEFAULT NULL,
  `Current_Ver` varchar(255) DEFAULT NULL,
  `Android_Ver` varchar(255) DEFAULT NULL,
  `row_num` int -- add comlumn row num so it equals to data2
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT `google-play-app-project`.`data3`
SELECT DISTINCT
	App, Category, Rating, Reviews, Size, Installs, `Type`, Price, Content_Rating, Genres, Last_Updated2, Current_Ver, Android_Ver,
	row_number() OVER(
    PARTITION BY App, Category, Rating, Reviews, Size, Installs, `Type`, Price, Content_Rating, Genres, Last_Updated2, Current_Ver, Android_Ver)
    as row_num
FROM `google-play-app-project`.`data2`;

DELETE 
FROM data3
WHERE row_num > 1;
