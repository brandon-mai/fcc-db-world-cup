#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")
cat games.csv | while IFS="," read YEAR ROUND WIN OPP WIN_GOAL OPP_GOAL
do
  if [[ $YEAR != 'year' ]]
  then
    # get winning team's ID
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WIN'")
    # if not found, insert and get
    if [[ -z $WIN_ID ]]
    then
      INSERT_WIN_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$WIN')")
      if [[ $INSERT_WIN_RESULT == 'INSERT 0 1' ]]
      then echo Inserted a winning team: $WIN
      fi
      WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WIN'")
    fi

    # get opponent team's ID
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPP'")
    # if not found, insert and get
    if [[ -z $OPP_ID ]]
    then
      INSERT_OPP_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$OPP')")
      if [[ $INSERT_OPP_RESULT == 'INSERT 0 1' ]]
      then echo Inserted an opponent team: $OPP
      fi
      OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPP'")
    fi

    # insert into games table
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WIN_ID, $OPP_ID, $WIN_GOAL, $OPP_GOAL)")
    if [[ $INSERT_GAME_RESULT == 'INSERT 0 1' ]]
    then echo Inserted a game: $WIN vs. $OPP
    fi
  fi
done
