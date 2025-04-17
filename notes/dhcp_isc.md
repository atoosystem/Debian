# Serveur DHCP isc

## Installer le Serveur DHCP

Installer le paquet *isc-dhcp-server*

### Configuration(s)

Modifier le 1er fichier de configuration afin de spécifier quelle(s) interface(s) le service doit écouter :

```bash
nano /etc/default/isc-dhcp-server
...
#       Separate multiple interfaces with spaces, e.g. "eth0 eth1".
INTERFACESv4="ens33"
INTERFACESv6=""
```

Configuration du service : /etc/dhcp/dhcpd.conf

```bash
nano /etc/dhcp/dhcpd.conf
...
# Serveur DNS du réseau
option domain-name "labo.local";
option domain-name-servers 192.168.30.12;
...
# Refuse les adresses MAC en double.
deny duplicates;
...
# Lease time en secondes
default-lease-time 345600;  # 4 jours
max-lease-time 691200;      # 8 Jours
...
# DHCP Officiel.
authoritative;
...

# PAs de DHCP sur ce réseau, mais déclaré quand même
subnet 192.168.30.0 netmask 255.255.255.0 {
}

# DHCP sur la place de 101 à 150
subnet 172.18.9.0 netmask 255.255.255.0 {
  range 172.18.9.101 172.18.9.150;
  option routers 192.168.30.254;
}
...
# Réservation d'IP pour cette machine ( hors plage DHCP)
host cli1 {
 hardware ethernet 04:be:54:5e:04:5A;
 fixed-address 172.18.9.205;
}
```
Afin de vérifier la configuration lancer dhcp server en mode débug :

```bash
systemctl stop isc-dhcp-server
dhcpd -d
```

Une fois que la configuration est fiable.
```bash
systemctl enable isc-dhcp-server
systemctl start isc-dhcp-server
```

## Tolérance de panne

Installation d'un autre serveur dhcp sur une autre machine.
La différence va venir de la configuration : 

- Mettre une durée de baux plus courte
- Ce 2eme serveur estdoit être  "not authoritative"
- ajouter une temporisation "min-secs 5"
- Créer une nouvelle étendue délivrant des adresses dans une plage différente du premier serveur
- Réserver 20 % d'hôtes sur le serveur principal pour le serveur secondaire

## Configuration serveur DHCP Relay

### Serveur DHCP relay

- Installer le paquet *isc-dhcp-relay*
- Déterminer les interfaces sur lesquelles doit écouter le server DHCP Relay ( au moins 2)

1ere option :

```bash
dpkg-reconfigure isc-dhcp-relay
```
Répondre aux questions de l'assistant.

2è option : passer par le fichier de configuration

```bash
nano /etc/default/isc-dhcp-relay

# Adresse du serveur DHCP
SERVERS="192.168.30.11"

# Quelles interfaces écouter?
INTERFACES="ens33 ens36"

# Options 
OPTIONS=""
```
> Redémarrer le service après configuration
