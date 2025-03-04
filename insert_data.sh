#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
$PSQL "TRUNCATE games,teams"

 while IFS="," read -r year round winner opponent winner_goals opponent_goals
 do
    $PSQL "INSERT INTO teams(name) values('$winner') ON CONFLICT DO NOTHING"
    $PSQL "INSERT INTO teams(name) values('$opponent') ON CONFLICT DO NOTHING"
    $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($year, '$round', (SELECT team_id FROM teams WHERE name='$winner'), (SELECT team_id FROM teams WHERE name='$opponent'), $winner_goals, $opponent_goals) ON CONFLICT DO NOTHING"
 done < <(tail -n +2 games.csv) 
    