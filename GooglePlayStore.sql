use Playstore
-- Total number of apps present in the Google playstore dataset
                                         --(8650)
SELECT COUNT(DISTINCT App)
FROM playstore_apps;
----------------------------------------------------------------------------------
-- Number of Categories present in the dataset
                                         --(33)
SELECT COUNT( DISTINCT Category)
FROM playstore_apps;
----------------------------------------------------------------------------------
-- Average rating and average size of all the apps
SELECT AVG(Rating) as Average_rating, AVG(Size) as Average_Size_inKB
FROM playstore_apps;
----------------------------------------------------------------------------------
-- Overview of all categories wrt Number of installs, least rated app, highest rated app, number of free apps and number of paid apps in that category in that category.
SELECT Category, Min(Rating) as Least_rating, Max(Rating) as Highest_rating, SUM(cast(Installs as bigint)) as Total_installs,
COUNT(CASE WHEN Type = 'Free' THEN 1 END) as Num_of_Free_Apps, 
COUNT(CASE WHEN Type = 'Paid' THEN 1 END) AS Num_of_Paid_Apps
FROM playstore_apps
GROUP BY Category
ORDER BY Total_installs DESC;
----------------------------------------------------------------------------------
-- Q1 Top 10 categories with the number of apps in them
SELECT Top 10 Category, COUNT(*) as Number_of_apps
FROM playstore_apps
GROUP BY Category
Order by Number_of_apps DESC;
--------------------------------------------------------------------------------------
-- Q.2 Which Category of google play store apps has the highest number of installs? Also, find out the total number of installs for that particular category.
SELECT Category, SUM(cast (Installs as bigint)) as No_of_Installs
FROM playstore_apps
Group by Category
ORDER BY No_of_Installs DESC;
------------------------------------------------------------------------------------
-- Q.3 What are the number of installs and reviews for the apps? Return the apps with the highest reviews to the top and mention name of category.
SELECT  App, sum(Reviews) as [No.Of.Review], sum(cast(Installs as bigint)) as [No.Of.Installs]
FROM playstore_apps
group by App
ORDER BY  [No.Of.Review] DESC;
--------------------------------------------------------------------------------------
--Q.4 Find the count of apps in each type
SELECT Type, COUNT(*) AS App_Count
FROM playstore_apps
GROUP BY Type;
--------------------------------------------------------------------------------------
-- Q.5 Find the count of apps in each content rating based on App type.
SELECT Type,
       SUM(case when (content_rating = 'Unrated') then 1 else 0 end) count_unrated,
       SUM(case when (content_rating = 'Everyone 10+') then 1 else 0 end) count_10plus,
       SUM(case when (content_rating = 'Teen') then 1 else 0 end) count_teen,
       SUM(case when (content_rating = 'Everyone') then 1 else 0 end) count_everyone,
       SUM(case when (content_rating = 'Adults only 18+') then 1 else 0 end) count_18plus,
       SUM(case when (content_rating = 'Mature 17+') then 1 else 0 end) count_17plus
FROM playstore_apps
GROUP BY Type;
--------------------------------------------------------------------------------------
-- Q.6 Which Genre has the most number of published apps?
SELECT Genres, COUNT(App) as App_count
FROM playstore_apps
GROUP BY Genres
ORDER BY App_count DESC;
--------------------------------------------------------------------------------------
-- Q.7  Create a new column to bucket rating to high(4-5), medium(2-4), low(0-2). Return the app names
SELECT  App, rating,
CASE 
    WHEN rating BETWEEN 4 AND 5 THEN 'high'
    WHEN rating BETWEEN 2 AND 4 THEN 'medium'
    ELSE 'low' 
END Rating_category
FROM playstore_apps;
--------------------------------------------------------------------------------------
-- Q.8 Return categories with their sentiment counts for each type of sentiment
SELECT playstore_apps. Category,
SUM(CASE WHEN (playstore_reviews.sentiment = 'positive') THEN 1 ELSE 0 END) AS positive_count,
SUM(CASE WHEN (playstore_reviews.sentiment = 'negative') THEN 1 ELSE 0 END) AS negative_count,
SUM(CASE WHEN (playstore_reviews.sentiment = 'neutral') THEN 1 ELSE 0 END) AS neutral_count
FROM playstore_apps 
JOIN playstore_reviews on playstore_apps.app = playstore_reviews.app
GROUP BY playstore_apps.Category;
--------------------------------------------------------------------------------------
--Q.9 Provide the list of all games ordered in such a way that the game that has the highest number of installs is displayed on the top 
SELECT DISTINCT App, Installs, Category
FROM playstore_apps
WHERE Category= 'Game'
ORDER BY Installs DESC;
--------------------------------------------------------------------------------------
-- Q.10 List all non-entertainment and non-education apps that are rated by everyone or teen
SELECT * 
FROM playstore_apps 
WHERE Category NOT IN ('Entertainment', 'Education')
AND Content_Rating IN ('Everyone', 'Teen');
--------------------------------------------------------------------------------------
-- Q.11  Return the app names, categories, sizes, release dates (rename it to “Last Updated”) of apps whose app names have more than 1 word, and whose categories are music and social, and whose sizes are bigger than 10.
SELECT App, Category, Size, Last_Updated as 'Last Updated'
FROM playstore_apps 
WHERE app LIKE '% %'
AND category IN ('Music', 'Social')
AND size > 10;
--------------------------------------------------------------------------------------
-- Q.12 Find the number of apps in each category that have a rating greater than the average rating
SELECT Category, COUNT(App) as App_count
FROM playstore_apps
WHERE Rating > 4.2
GROUP BY Category
ORDER BY App_count DESC;
--------------------------------------------------------------------------------------
-- Q.13 List the largest app size within each app category.
SELECT Category, AVG(Size) as Avg_App_size
FROM playstore_apps
GROUP BY Category
ORDER BY Avg_App_size DESC;