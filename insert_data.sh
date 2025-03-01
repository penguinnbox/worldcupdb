#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
$PSQL "TRUNCATE games,teams;"

    psql -U freecodecamp -d worldcup <<EOF 
    CREATE TEMPORARY TABLE temp (
        year INT,
        round VARCHAR(40),
        winner VARCHAR(60),
        opponent VARCHAR(60),
        winner_goals INT,
        opponent_goals INT
    );
    
    \COPY temp(year, round, winner, opponent, winner_goals, opponent_goals) FROM '/workspace/project/games.csv' WITH (DELIMITER ',', FORMAT csv, HEADER); 


    INSERT INTO teams(name)
    SELECT winner AS name FROM temp
    UNION
    SELECT opponent AS name FROM temp;

  
    INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
    SELECT 
        year, 
        round, 
        (SELECT team_id FROM teams WHERE name = winner LIMIT 1) AS winner_id, 
        (SELECT team_id FROM teams WHERE name = opponent LIMIT 1) AS opponent_id, 
        winner_goals, 
        opponent_goals
    FROM temp; 
EOF


