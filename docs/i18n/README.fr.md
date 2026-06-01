# FreeBSDOpenBSDTapeOps (Français)

Scripts shell interactifs qui parcourent les opérations courantes sur bande magnétique avec `mt` et `tar`.

## Index de documentation par langue

- [US English](docs/i18n/README.en-US.md)
- [Deutsch (German)](docs/i18n/README.de.md)
- [Español (Spanish)](docs/i18n/README.es.md)
- [Français (French)](docs/i18n/README.fr.md)
- [Português (Portuguese)](docs/i18n/README.pt.md)
- [Italiano (Italian)](docs/i18n/README.it.md)
- [繁體中文 (香港) / Traditional Chinese (Hong Kong)](docs/i18n/README.zh-HK.md)
- [简体中文 (Simplified Chinese)](docs/i18n/README.zh-CN.md)
- [한국어 (Korean)](docs/i18n/README.ko.md)
- [हिन्दी (Hindi)](docs/i18n/README.hi.md)
- [Русский (Russian)](docs/i18n/README.ru.md)
- [العربية (Arabic)](docs/i18n/README.ar.md)
- [Kiswahili (Swahili)](docs/i18n/README.sw.md)
- [日本語 (Japanese)](docs/i18n/README.ja.md)
- [Kreyòl Ayisyen (Haitian Creole)](docs/i18n/README.ht.md)
- [ʻŌlelo Hawaiʻi (Hawaiian)](docs/i18n/README.haw.md)
- [Gagana Samoa (Samoan)](docs/i18n/README.sm.md)
- [Te Reo Māori (Maori)](docs/i18n/README.mi.md)
- [Afrikaans](docs/i18n/README.af.md)
- [Nederlands (Dutch)](docs/i18n/README.nl.md)
- [Hausa](docs/i18n/README.ha.md)
- [አማርኛ (Amharic)](docs/i18n/README.am.md)
- [Yorùbá (Yoruba)](docs/i18n/README.yo.md)
- [বাংলা (Bengali)](docs/i18n/README.bn.md)
- [Gaeilge (Irish)](docs/i18n/README.ga.md)
- [Eesti (Estonian)](docs/i18n/README.et.md)
- [Suomi (Finnish)](docs/i18n/README.fi.md)
- [Svenska (Swedish)](docs/i18n/README.sv.md)
- [Norsk (Norwegian)](docs/i18n/README.no.md)
- [Українська (Ukrainian)](docs/i18n/README.uk.md)
- [ไทย (Thai)](docs/i18n/README.th.md)
- [Bahasa Indonesia](docs/i18n/README.id.md)
- [Tagalog](docs/i18n/README.tl.md)
- [Bahasa Melayu (Malay)](docs/i18n/README.ms.md)
- [Basa Jawa (Javanese)](docs/i18n/README.jv.md)
- [Ελληνικά (Greek)](docs/i18n/README.el.md)
- [Latina (Latin)](docs/i18n/README.la.md)
- [עברית (Hebrew)](docs/i18n/README.he.md)


## Scripts

| Script | OS cible |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

Les deux scripts exécutent la même séquence d’opérations :

1. Demander à l’utilisateur de confirmer que la bande est chargée.
2. Rembobiner la bande.
3. Afficher l’état de la bande.
4. Lister le contenu des archives aux positions de fichier 0, 1, 2 et 3 avec `tar t`.
5. Mettre la bande hors ligne.

Chaque étape fait une pause et attend que l’utilisateur appuie sur **Entrée** avant de continuer, ce qui rend ces scripts adaptés aux démonstrations interactives ou aux procédures guidées.

## Différences entre les deux scripts

### 1. Chemin du périphérique de bande

Les scripts ciblent des nœuds de périphérique de bande différents :

- **FreeBSD** (`scriptedDemo.sh`) : `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`) : `/dev/nrst0`

Les deux sont des nœuds de périphérique sans rembobinage (préfixe `n`), donc la position de la bande est conservée entre les commandes et les scripts contrôlent explicitement le positionnement avec `mt rewind` et `mt fsf`.

### 2. Étape de chargement de la bande

- **FreeBSD** : exécute `mt -f /dev/nsa0 load` au démarrage pour charger mécaniquement la cartouche de bande dans le lecteur avant le rembobinage.
- **OpenBSD** : ignore la commande `load`, car `mt(1)` sur OpenBSD ne prend pas en charge le sous-commande `load`. Le script OpenBSD suppose que la bande est déjà présente dans le lecteur et passe directement au rembobinage.

## Scripts de pipeline de logs OpenBSD A-vers-B-vers-C

Le répertoire `scripts/` fournit des scripts pour le scénario où l’ordinateur OpenBSD B reçoit des entrées rsyslog de l’ordinateur A, les regroupe quotidiennement, les envoie à l’un des serveurs ordinateur C, puis l’ordinateur C les écrit sur bande.

| Script | But |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Crée un log rotatif horaire à partir du fichier d’entrée rsyslog actif sur l’ordinateur B. |
| `scripts/computer-b-daily-archive.sh` | Regroupe une journée (`YYYYMMDD`) de logs horaires dans une archive `.tar.gz` à plage horaire sur l’ordinateur B, en excluant l’heure en cours pour éviter les conflits d’écriture active. |
| `scripts/computer-b-send-archives.sh` | Envoie les archives quotidiennes non envoyées (`.tar.gz` et éventuellement `.tar.gz.enc`) de l’ordinateur B vers un ou plusieurs serveurs ordinateur C via `scp`. |
| `scripts/computer-c-receive-archives.sh` | Valide les archives entrantes en clair et met en file d’attente les archives en clair/chiffrées pour la bande. |
| `scripts/computer-c-write-to-tape.sh` | Écrit sur bande les archives en attente (en clair ou chiffrées), vérifie l’espace, ajoute de manière sûre et les marque comme enregistrées. |
| `scripts/computer-c-inventory-tape.sh` | Affiche une table des matières de la bande par marqueur de fichier afin que les opérateurs retrouvent rapidement les archives. |
| `scripts/computer-c-restore-archive-from-tape.sh` | Parcourt les positions de fichier de la bande pour une archive demandée, déchiffre si nécessaire et enregistre les données récupérées dans un fichier. |
| `scripts/test-computer-a-b-c-integration.sh` | Exécute un test d’intégration local déterministe A→B→C (incluant la restauration depuis bande) qui ne dépend pas du temps réel. |

Planification typique :

- Exécuter `computer-b-hourly-rotate.sh` toutes les heures (cron sur B).
- Exécuter `computer-b-daily-archive.sh` une fois par jour (cron sur B).
- Exécuter `computer-b-send-archives.sh` après la création d’archive (cron sur B).
- Exécuter `computer-c-receive-archives.sh` périodiquement sur C.
- Exécuter `computer-c-write-to-tape.sh` périodiquement sur C avec le bon périphérique de bande.
- Exécuter `computer-c-inventory-tape.sh` sur C quand vous avez besoin d’une table des matières marqueur par marqueur.
- Exécuter `computer-c-restore-archive-from-tape.sh` sur C quand vous devez récupérer une archive spécifique pour inspection.

Tous les scripts du pipeline émettent également des messages opérationnels vers syslog via `logger` (par exemple visibles via rsyslog/journaling) en plus de la sortie console.

### Envoi multi-serveur depuis l’ordinateur B

`computer-b-send-archives.sh` prend en charge à la fois le mode serveur unique et le mode multi-serveur :

- Serveur unique : `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- Multi-serveur : `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

Options de sélection de serveur côté client :

- Fournir un serveur dans les arguments pour se fixer à un seul ordinateur C.
- Fournir plusieurs serveurs pour permettre le basculement.
- Définir `PREFERRED_SERVER=user@host` pour choisir un serveur spécifique dans la liste fournie.

Options de gestion d’occupation sur l’ordinateur B :

- `REMOTE_BUSY_MARKER` (par défaut : `.busy`) : fichier marqueur vérifié côté distant.
- `BUSY_RETRY_SECONDS` (par défaut : `60`) : délai entre les tentatives lorsque le serveur est occupé.
- `BUSY_MAX_RETRIES` (par défaut : `10`) : nombre maximal de tentatives par serveur.

### Publication de l’état occupé depuis l’ordinateur C

`computer-c-write-to-tape.sh` crée un marqueur d’occupation pendant l’écriture active des archives sur bande et le supprime lorsqu’il est inactif.

- `BUSY_MARKER` (par défaut : `<received_dir>/.busy`)

Pointez `REMOTE_BUSY_MARKER` sur l’ordinateur B vers l’emplacement du marqueur utilisé par l’ordinateur C.

### Sécurité de bande et comportement d’ajout sur l’ordinateur C

Avant d’écrire chaque archive, `computer-c-write-to-tape.sh` vérifie la capacité disponible de la bande/périphérique et exige au minimum :

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

Variables pertinentes :

- `TAPE_SAFETY_MARGIN_BYTES` (par défaut : `10485760`)
- `TAPE_AVAILABLE_BYTES` (remplacement pour un espace disponible connu)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (autorise l’écriture si l’espace ne peut pas être détecté)

Pour les vrais périphériques de bande, le script d’écriture se place en fin de données (`mt eom`/`mt eod`) avant d’écrire, de sorte que plusieurs archives sont ajoutées au lieu d’écraser le contenu existant de la bande.

### Horodatages lisibles par l’humain dans les noms de fichiers

- Les logs horaires sont nommés ainsi : `rsyslog-2026-06-01T1600.log`
- Les archives quotidiennes sont nommées ainsi : `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

Les plages des archives quotidiennes sont basées sur les premiers et derniers fichiers horaires réellement inclus dans l’archive.
Ces noms sont destinés à être lisibles pour les personnes qui parcourent des fenêtres date/heure d’événements.
L’heure courante est volontairement exclue de la création d’archive afin de ne pas transmettre des écritures actives.

### Chiffrement OpenSSL optionnel pour les archives quotidiennes

`computer-b-daily-archive.sh` peut chiffrer les archives avec OpenSSL après la création de l’archive tar :

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` pour le chiffrement symétrique (`openssl enc`, chiffrement par défaut `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` pour le chiffrement par certificat destinataire (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` pour choisir le chiffrement OpenSSL pour les modes fichier-clé et certificat (par défaut : `aes-256-gcm`).

Une seule de ces options peut être définie à la fois. Les sorties chiffrées utilisent `.tar.gz.enc`.
Pour des raisons de sécurité, le script rejette les choix de chiffrement faibles ou non AEAD et exige des chiffrements de classe GCM/poly1305.

### Récupération d’archive depuis bande sur l’ordinateur C

Utilisez `computer-c-restore-archive-from-tape.sh` pour localiser une archive spécifique en recherchant les fichiers bande dans l’ordre depuis le début :

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- Pour des noms d’archive comme `rsyslog-<start>_to_<end>.tar.gz` (ou `.tar.gz.enc`), le script identifie la bonne correspondance en vérifiant que les fichiers horaires de bordure sont présents dans la charge récupérée.
- Si votre convention de nommage d’archive est différente, définissez `TARGET_MEMBER_GLOB` avec un motif shell correspondant à un membre qui doit exister dans l’archive.
- Si une archive est chiffrée, fournissez les paramètres de déchiffrement si nécessaire :
  - `OPENSSL_DECRYPT_KEY_FILE` (mode symétrique `openssl enc` ; chiffrement de déchiffrement par défaut : `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` et `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (mode de déchiffrement S/MIME)

La sortie récupérée est écrite sous forme de fichier `.tar.gz` en clair afin qu’elle puisse être inspectée avec des outils comme `tar -tzf`.

### Inventaire table des matières de bande sur l’ordinateur C

Utilisez `computer-c-inventory-tape.sh` pour afficher une table des matières marqueur par marqueur :

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

Les colonnes de sortie comprennent :

- `file_marker` : position du marqueur de fichier bande (base zéro)
- `status` : `ok`, `decrypted` ou `unreadable`
- `encrypted` : indique si un déchiffrement était nécessaire pour inspecter l’entrée (`yes`/`no`)
- `archive_hint` : nom de type archive inféré lorsque les limites peuvent être reconnues
- `first_member` / `last_member` : premier et dernier membres tar vus à ce marqueur
- `member_count` : nombre de membres tar trouvés à ce marqueur
- `bytes` : octets bruts lus à ce marqueur

Cela permet à un opérateur d’identifier l’index de marqueur à atteindre (`mt fsf <N>`) avant les opérations de restauration.

### Test d’intégration déterministe A/B/C

Utilisez `scripts/test-computer-a-b-c-integration.sh` pour valider l’intégration de bout en bout des ordinateurs A, B et C indépendamment du temps écoulé :

```sh
scripts/test-computer-a-b-c-integration.sh
```

Ce script :

1. Simule l’écriture de logs par A.
2. Exécute la rotation et la création d’archive quotidienne sur B.
3. Simule le transfert vers le dossier d’entrée de C.
4. Exécute réception + écriture sur bande sur C.
5. Restaure l’archive depuis la bande et valide le contenu.

Il utilise un identifiant de jour fixe (`TEST_DAY_STAMP`, par défaut `20260101`) afin que le comportement soit reproductible et non lié à la date/heure courante.

### Rétention 72 heures avec sécurité pour les données non confirmées

Les scripts utilisent désormais par défaut une fenêtre de rétention de 72 heures :

- `computer-b-hourly-rotate.sh` ne supprime les anciens logs horaires que lorsqu’un marqueur local de confirmation `.taped` correspondant existe.
- `computer-b-send-archives.sh` ne supprime les anciennes archives locales que lorsque les marqueurs `.sent` et local `.taped` existent tous les deux.
- `computer-c-write-to-tape.sh` ne supprime que les anciennes archives ayant déjà des marqueurs `.taped`.

Ainsi, les fichiers qui n’ont pas encore été transmis avec succès et enregistrés sur bande sont conservés même s’ils sont plus anciens que `RETENTION_HOURS` (par défaut `72`).
Sur l’ordinateur B, le nettoyage local exige des marqueurs `.taped` locaux (par exemple via une étape de synchronisation retour ou un processus de confirmation manuel).
Sur l’ordinateur C, l’âge de rétention est mesuré à partir de l’heure de modification du marqueur `.taped` (normalement définie au moment de l’écriture réussie sur bande).
