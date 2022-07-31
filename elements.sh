#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t -c"

if [[ -z $1  ]]
then 
  echo "Please provide an element as an argument."
else
  NUMCHECK='^[0-9]+$'
  LENGTH=${#1}
  echo "length $LENGTH"
  if [[ $1 =~ $NUMCHECK ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = CAST ($1 AS INT)")
  else
    if [[ $LENGTH<3 ]]
    then
      ATOMIC_NUMBER="$($PSQL "SELECT atomic_number FROM elements WHERE symbol ILIKE '$1'")"
    else
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name ILIKE '$1'")
    fi
  fi
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "Not a valid element"
  else 
    echo $ATOMIC_NUMBER
  fi

fi