#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t -c"

if [[ -z $1  ]]
then 
  echo "Please provide an element as an argument."
else
  echo "Hello"
fi