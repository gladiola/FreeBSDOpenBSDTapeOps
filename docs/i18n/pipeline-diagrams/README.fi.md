# A/B/C Pipeline Diagrams (Suomi)

[← README (Suomi)](../README.fi.md)

Tämä lokalisoitu kopio yhdistää putkistokaaviot vastaavaan lokalisoituun README-tiedostoon.

## Tapahtumien tilakaavio

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : Tietokone A lähettää rsyslog-tapahtumia

    A_WritingLogs --> B_HourlyRotate : tuntikohtainen cron / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : kierretty tuntiloki luotu
    B_WaitMoreLogs --> B_DailyArchive : päivittäinen cron / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : .tar.gz (tai .tar.gz.enc) tuotettu

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : scp-siirto Tietokoneelle C
    B_SendArchives --> B_RetryLater : C varattu (.busy-merkki) tai siirtovirhe
    B_RetryLater --> B_SendArchives : uudelleenyritysikkuna

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : hyväksytty + jonoon
    C_ReceiveValidate --> C_Reject : virheellinen arkisto

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : arkisto lisätty nauhalle + .taped-merkki
    C_WriteTape --> C_WaitTape : ei nauhaa/tilaa/virhe
    C_WaitTape --> C_WriteTape : yritä uudelleen seuraavalla ajolla

    C_Taped --> C_Inventory : tarvittaessa / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : tarvittaessa / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : palautetun arkiston tuloste
```

## Sekvenssikaavio

```mermaid
sequenceDiagram
    autonumber
    participant A as Tietokone A (rsyslog-lähde)
    participant B as Tietokone B (arkistointi/lähetys)
    participant C as Tietokone C (vastaanotto/nauha)
    participant T as Nauhalaite

    Note over A,B: Tuntikohtainen vastaanotto/kierto
    A->>B: Lähetä rsyslog-tapahtumia jatkuvasti
    B->>B: computer-b-hourly-rotate.sh

    Note over B: Päivittäinen pakkaus
    B->>B: computer-b-daily-archive.sh
    B->>B: Luo .tar.gz (tai .tar.gz.enc)

    Note over B,C: Siirto yhdelle tai useammalle C-palvelimelle
    B->>C: computer-b-send-archives.sh scp:n kautta
    alt C on varattu (.busy-merkki)
        C-->>B: Varausilmoitus
        B->>B: Odota/yritä uudelleen/varapalvelin
    else Siirto hyväksytty
        C-->>B: Arkisto vastaanotettu
    end

    Note over C: Vastaanotto ja jono
    C->>C: computer-c-receive-archives.sh
    alt Arkisto kelvollinen
        C->>C: Jonoon nauhakirjoitusta varten
    else Arkisto virheellinen
        C->>C: Hylkää + kirjaa virhe
    end

    Note over C,T: Nauhakirjoituksen silmukka
    C->>C: computer-c-write-to-tape.sh
    C->>T: Siirry datan loppuun + lisää arkisto
    T-->>C: Kirjoitus onnistui
    C->>C: Merkitse .taped (ja siivoa säilytyksen mukaan)

    opt Ylläpitäjän inventointi
        C->>T: computer-c-inventory-tape.sh
        T-->>C: TOC merkki merkiltä
    end

    opt Ylläpitäjän palautuspyyntö
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: Arkistoitu sisältö vastaavassa merkissä
        C-->>A: Palautettu .tar.gz tarkastusta varten
    end
```

[← README (Suomi)](../README.fi.md)
