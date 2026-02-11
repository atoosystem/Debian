# Shell Bash

## Créer le fichier script

```bash
$ touch mon_script.sh
# ou
$ nano mon_script.sh
# ou
$ vim mon_script.sh
# etc
...
```
## Ajouter les instructions

> Important : Ajouter le shebang. La première ligne du script doit toujours indiquer l’interpréteur à utiliser, ici Bash :

```bash
#!/bin/bash
```
> Puis le(s) instruction(s)

```bash
#!/bin/bash

# Afficher un message de bienvenue
echo "Hello World ! Premier script Bash !"
```

## Rendre le script exécutable

> Pour que le script puisse être lancé, il faut lui donner les droits d’exécution :

```bash
$ chmod +x mon_script.sh
```
> Exécuter le script :

```bash
$ ./mon_script.sh
Hello World ! Premier script Bash !
$
```

## Passer des arguments

> Modifier le script : vim mon_script.sh

```bash
$ vi mon_script.sh
#!/bin/bash

# Afficher un message de bienvenue
echo "Hello World ! Premier script Bash !"
# Afficher le nombre d'arguments et leur valeur
echo "Nombre total d'arguments : $#"
echo "Valeurs des arguments : $@"
:wq

# Pour exécuter ce script avec des arguments : arg1 arg2 arg3
$ ./mon_script.sh A 1 B
```
## Points complémentaires
> Pour demander une saisie à l'utilisateur, utilisez la commande read :

```bash
read -p "Quel est votre nom ? " nom
echo "Bonjour $nom !"
```

> Pour créer une fonction dans un script Bash :

```bash
ma_fonction() {
  echo "Ceci est une fonction Bash."
}

ma_fonction
```
## Exemple

- [Script fonctionnel](../scripts/test.sh)  
