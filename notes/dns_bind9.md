# Serveur DNS Bind9

## Installer le Serveur DNS bind9

```bash
apt install bind9
```

> Important : Les commentaires dans les fichiers de conf de bind9 sont //

## Configuration de bind9

### DNS Résolveur

Le fichier de configuration principal de bind9 se trouve à "/etc/bind/named.conf". 
Il inclut 3 sous fichiers de configuration spécifiques :
- named.conf.options : configuration des options
- named.conf.local : configuration des zones hébergées localement
- named.conf.default-zone : configuration des zones par défaut

#### ACL dans le fichier named.conf

Il est possible de définir une acl (variable) pour les différents réseaux des postes clients dans le fichier named.conf :

```bash 
// goodclients = réseaux des postes clients
acl goodclients { 127.0.0.0/8; 192.168.10.0/24; 172.30.1.0/24; };
```

#### Fichier named.conf.options

Il faudra rajouter l'acl créée dans le fichier named.conf.options :

```bash
options {

  ...
  # Ajout des redirecteurs inconditionnels

  forwarder {
    172.30.30.1;  # Routeur avant la box
    10.10.10.1;   # autre DNS privé 
    1.1.1.3;      # Family protect
  };

  allow-query { goodclients; };
  allow-recursion { goodclients; };
  ...

  auth-nxdomain no;    # conform to RFC1035
  recursion yes;
  listen-on { any; };
  ...
};
```

#### Ajout d'un redirecteur conditionnel

Pour ajouter un redirecteur conditionnel, il faut ajouter une zone de type *forward* au fichier /etc/bind/named.conf.local :

```bash
zone autrezone.local {
  type forward;
  forward only;
  forwarder { 10.20.0.53; };
};
```

## Configuration service DNS faisant autorité

Un serveur bind9 faisant autorité doit avoir une configuration (/etc/bind/named.conf.local) et des données (/var/cache/bind/db.labo.local)

### Configuration d'un serveur primaire

#### Zone directe 

Dans le fichier /etc/bind/named.conf.local : 

```bash
zone "labo.local" {
  type master; # Fait Autorité
  file "/var/cache/bind/db.labo.local";
  allow-transfer { 192.168.30.11}; # IP de l'autre DNS autorisé; 
  allow-query { goodclients; };
};
```
Créer le fichier de données dans /var/cache/bind/db.labo.local :

> Important : Les commentaires dans les fichiers de conf sont ;
```bash
; fichier de zone du domaine labo.local

$ORIGIN labo.local.
$TTL 86400
@ SOA DEB-S2.labo.local. postmaster.labo.local. (
  20220616 ; serial
  86400 ; refresh tous les jours
  7200 ; retry toutes les 2 heures
  3600000 ; expire
  3600 ) ; negative TTL
;
@ NS DEB-S2.labo.local.

DEB-S2  A       192.168.30.12
DEB-S1  A       192.168.30.11
RouTux  A       192.168.30.254
RouTux  A       172.18.30.254
pfSense A       172.30.30.1

dns1    CNAME   DEB-S2.labo.local.
dhcp1   CNAME   DEB-S1.labo.local.

```

Vérifier des configuration: 

```bash
# Verification de la syntaxe globale
named-checkconf

# Verification de la zone du fichier
named-checkzone -z labo.local /var/cache/bind/db.labo.local
```
> Si la commande *named-checkconf* ne retourne rien, tout semble en ordre
> > La commande *named-checkzone* doit retournner le nom de la zone, son serial et "OK"

Recharger la configuration avec la commande :

```bash
rndc reload
```
> Attention : Si la commande retourne "rndc: connect failed: 127.0.0.1#53: connection refused" --> Il faut autoriser 127.0.0.1/8 dans named.conf (acl)

#### Zone inverse

La zone inverse de déclare dans le même fichier :

```bash
vim named.conf.local

zone "30.168.192.in-addr.arpa" {
  type master;
  file "/var/cache/bind/db.192.168.30.inv";
};
```

```bash
vim /var/cache/bind/db.192.168.30.inv

; zone inverse pour 192.168.30.0/24

$TTL 86400
@ SOA DEB-S2.labo.local. postmaster.labo.local. (
20220617 ; serial
86400    ; refresh
7200     ; retry 2h
3600000  ; expire
3600     ; negative TTL
)
;

@ NS DEB-S2.labo.local.
11      PTR     DEB-S1.labo.local.
12      PTR     DEB-S2.labo.local.

```

### Configuration d'un serveur secondaire
//TODO zone de recherche directe et indirectes slave

```bash
zone "labo.local" {
  type slave;
  masters { 192.168.30.11 }; # ip du serveur dns master;
  file "/var/cache/bind/db.labo.local";
  # on remet ici l'acl déclarée dans le named.conf
  allow-query { goodclients; }; 
};
```

## Sécurité

### Configuration DNSSEC

Non abordé
