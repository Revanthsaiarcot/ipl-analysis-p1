
CREATE DATABASE IF NOT EXISTS ipl_db;
USE ipl_db;

CREATE TABLE matches (
    match_id INT,
    season INT,
    team1 VARCHAR(50),
    team2 VARCHAR(50),
    venue VARCHAR(50),
    winner VARCHAR(50),
    match_date DATE
);

CREATE TABLE players (
    player_id INT,
    player_name VARCHAR(100),
    team VARCHAR(50),
    role VARCHAR(50)
);

CREATE TABLE deliveries (
    match_id INT,
    batsman_runs INT,
    bowler_runs INT,
    is_wicket INT
);
CREATE TABLE team_wins (
    team VARCHAR(50),
    wins INT
);

-- DASHBOARD 1: Team Performance
-- 1. Which Team Has the Highest Wins Across Seasons
SELECT winner AS team, COUNT(*) AS total_wins
FROM matches
WHERE winner IS NOT NULL AND winner != ''
GROUP BY winner
ORDER BY total_wins DESC;

-- 2. Wins by Venue
SELECT venue, winner AS team, COUNT(*) AS wins
FROM matches
WHERE winner IS NOT NULL
GROUP BY venue, winner
ORDER BY venue, wins DESC;

-- 3. Season-wise Team Dominance
SELECT season, winner AS team, COUNT(*) AS season_wins
FROM matches
WHERE winner IS NOT NULL
GROUP BY season, winner
ORDER BY season, season_wins DESC;

-- DASHBOARD 2: Match Insights
-- 4. Average Runs Per Match
SELECT AVG(total_runs) AS avg_runs_per_match
FROM (SELECT match_id,
    SUM(batsman_runs + bowler_runs) AS total_runs
    FROM deliveries
    GROUP BY match_id) AS match_totals;

-- 5. Matches with “No Result”
SELECT COUNT(*) AS no_result_matches
FROM matches
WHERE winner IS NULL OR winner = '' OR winner = 'No Result';

-- 6. Home vs Away Performance
SELECT
    SUM(CASE WHEN winner = team1 THEN 1 ELSE 0 END) AS home_wins,
    SUM(CASE WHEN winner = team2 THEN 1 ELSE 0 END) AS away_wins
FROM matches
WHERE winner IS NOT NULL;

-- Dashboard 3: Player & Ball Analytics
-- 7. Runs Distribution Per Match
SELECT match_id, 
       SUM(batsman_runs + bowler_runs) AS total_runs
FROM deliveries
GROUP BY match_id
ORDER BY total_runs DESC;

-- 8. Wickets Per Match
SELECT match_id, COUNT(*) AS total_wickets
FROM deliveries
WHERE is_wicket = 1
GROUP BY match_id
ORDER BY total_wickets DESC;

-- 9. High-Scoring Matches(200+ Runs)
SELECT match_id,
       SUM(batsman_runs + bowler_runs) AS total_runs
FROM deliveries
GROUP BY match_id
HAVING total_runs > 200
ORDER BY total_runs DESC;

-- Dashboard 4: Business KPIs
-- 10. Top 5 Teams by Win Percentage
WITH matches_played AS (
    SELECT team, COUNT(*) AS total_matches
    FROM (
        SELECT team1 AS team FROM matches
        UNION ALL
        SELECT team2 FROM matches
    ) AS teams
    GROUP BY team
),
wins AS (
    SELECT winner AS team, COUNT(*) AS total_wins
    FROM matches
    WHERE winner IS NOT NULL
    GROUP BY winner
)
SELECT 
    mp.team,
    COALESCE(w.total_wins, 0) AS wins,
    mp.total_matches,
    ROUND((COALESCE(w.total_wins, 0) / mp.total_matches) * 100, 2) AS win_percentage
FROM matches_played mp
LEFT JOIN wins w ON mp.team = w.team
ORDER BY win_percentage DESC
LIMIT 5;

-- 11. Impact of Venue on Results
SELECT venue, winner AS team, COUNT(*) AS wins
FROM matches
WHERE winner IS NOT NULL
GROUP BY venue, winner
ORDER BY venue, wins DESC;
