#! /bin/bash

PSQL1="psql -X --username=postgres --dbname=worldcup  --no-align --tuples-only -c"
ps="psql -X --username=postgres --dbname=postgres  --no-align --tuples-only -c"
drop=$($ps "drop database worldcup;")
echo $drop
CREATE=$($ps "\i db.sql ")
echo $CREATE

cat games.csv | while IFS="," read  YEAR  ROUND  WINNER  OPPONENT WINNER_GOALS  OPPONENT_GOALS
do
    #compruebo si existe los nombres de los equipos en la tabla teams
    W=$($PSQL1 "select name from teams where name='$WINNER';")
    O=$($PSQL1 "select name from teams where name='$OPPONENT';")
    if [[ $WINNER != 'winner' && $OPPONENT != 'opponent' ]]
    then
        if [[ -z $W ]]
        then
            INSERT_W=$($PSQL1 "INSERT INTO teams (name) VALUES ('$WINNER');")
            if [[ $INSERT_W == "INSERT 0 1" ]]
            then
                echo insertando $WINNER
            else
                echo ya existia $WINNER
            fi
        fi
        if [[ -z $O ]]
        then
            INSERT_O=$($PSQL1 "INSERT INTO teams (name) VALUES ('$OPPONENT');")
            if [[ $INSERT_O == "INSERT 0 1"  ]]
            then
                echo insertando $OPPONENT
            else
                echo ya existia $OPPONENT
            fi
        fi
    fi
    #se insertaron los equipos insertando juegos
    ID_WINNER=$($PSQL1 "SELECT team_id from teams where name='$WINNER';")
    ID_OPPONENT=$($PSQL1 "SELECT team_id from teams where name='$OPPONENT';")

    INSERT=$($PSQL1 "INSERT INTO games (year , round , winner_id , opponent_id , winner_goals , opponent_goals) VALUES ($YEAR, '$ROUND' , $ID_WINNER , $ID_OPPONENT , $WINNER_GOALS , $OPPONENT_GOALS);")
    echo insert;
done

consulta=$($PSQL1 "select * from teams;")
echo $consulta
consulta2=$($PSQL1 "select * from games;")
echo -e "\n\n\n\n\n\n" $consulta2