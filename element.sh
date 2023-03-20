#!/bin/bash

[ $# -ne 1 ] && echo "Please provide an element as an argument." && exit

PSQL='psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c '
J=' inner join properties using (atomic_number) inner join types using (type_id)'
if [[ $1 =~ [0-9]+ ]]
then
  ROW=$($PSQL "select atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type from elements $J where atomic_number = $1;");
else
  ROW=$($PSQL "select atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type from elements $J where symbol = '$1' or name = '$1';");
fi

[ -z $ROW ] && echo "I could not find that element in the database." && exit

#The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.

echo $ROW | while IFS='|' read ID SYMBOL NAME MASS MPC BPC TYPE
do
  echo -e -n "The element with atomic number $ID is $NAME ($SYMBOL). ";
  echo -e -n "It's a $TYPE, with a mass of $MASS amu. "
  echo -e "$NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
done
exit 0