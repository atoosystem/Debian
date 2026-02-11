#!/bin/bash

# Afficher un message de bienvenue
echo "Hello World ! Premier script Bash !"

# verifie si ucun argument
[[ $# -eq 0 ]] && { echo "Aucun argument fourni"; exit 1; }

# Verifie si moins de 2 arguments
if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <arg1> <arg2>"
  exit 1
fi

# Afficher le nombre d'arguments et leur valeur
echo "Nombre total d'arguments : $#"
echo "Valeurs des arguments : $@"
echo "Script: $0" # Nom du script
echo "1er  argument : $1"  # Affiche le premier paramètre positionnel
echo "2ème argument : $2"  # Affiche le xeme paramètre positionnel

echo "Parcours direct :"
for arg in "$@"; do
  echo "- $arg"
done

echo -e "\nParcours inversé :"
for ((i=$#; i>=1; i--)); do
  echo "- ${!i}"
done

echo "ls $HOME"  # Affiche le code d'erreur de la commande ls
ls ~ 
echo " code erreur LS: $?"  # Affiche le code d'erreur de la commande ls

ma_fonction() {
  echo "Ceci est une fonction Bash."
}

ma_fonction

# Afficher un message de fin
echo "Good bye !"
