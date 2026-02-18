
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
