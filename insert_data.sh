#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $winner != "winner" ]]
  then
    insert_winner_teams=$($PSQL "INSERT INTO teams(name) VALUES('$winner')")
    if [[ $insert_winner_teams == "INSERT 0 1" ]]
    then
      echo $winner Inserted
    else
      echo $winner is Duplicate Entry
    fi
  fi

  if [[ $opponent != "opponent" ]]
  then
    insert_opponent_teams=$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
    if [[ $insert_opponent_teams == "INSERT 0 1" ]]
    then
      echo $opponent Inserted
    else
      echo $opponent is Duplicate Entry
    fi
  fi
done


cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $year != "year" ]]
  then
    get_winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
    get_opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")

    insert_games_query=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$year', '$round', '$get_winner_id', '$get_opponent_id', '$winner_goals', '$opponent_goals')")
  fi
done