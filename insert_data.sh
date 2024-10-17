#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Erase all data
$PSQL "TRUNCATE games, teams"
# Insert the unique teams in the database
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # search for winner
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # if not found
    if [[ -z $WINNER_ID ]]
    then
      echo Team $WINNER not found in db inserting...
      # insert winner
      $PSQL "INSERT INTO teams (name) VALUES ('$WINNER')"
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

    # search for opponent
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    # if not found
    if [[ -z $OPPONENT_ID ]]
    then
      echo Team $OPPONENT not found in db inserting...
      # insert opponent
      $PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')"
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

    # insert in the games table
    $PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)"
  fi
done