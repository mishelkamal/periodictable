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
    echo "I could not find that element in the database."
  else 
    NAME="$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER")"
    SYMBOL="$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER")"
    ATOMIC_MASS="$($PSQL "SELECT atomic_mass FROM elements FULL JOIN properties ON elements.atomic_number=properties.atomic_number WHERE elements.atomic_number = $ATOMIC_NUMBER")"
    MELTING_POINT_CELSIUS="$($PSQL "SELECT melting_point_celsius FROM elements FULL JOIN properties ON elements.atomic_number=properties.atomic_number WHERE elements.atomic_number = $ATOMIC_NUMBER")"
    BOILING_POINT_CELSIUS="$($PSQL "SELECT boiling_point_celsius FROM elements FULL JOIN properties ON elements.atomic_number=properties.atomic_number WHERE elements.atomic_number = $ATOMIC_NUMBER")"
    TYPE="$($PSQL "SELECT types.type FROM elements FULL JOIN properties ON elements.atomic_number=properties.atomic_number FULL JOIN types ON properties.type_id=types.type_id WHERE elements.atomic_number = $ATOMIC_NUMBER")"
    echo "$NAME ($SYMBOL) $ATOMIC_MASS $BOILING_POINT_CELSIUS $MELTING_POINT_CELSIUS $TYPE"
  fi

fi

#"The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius."