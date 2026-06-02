# A/B/C Pipeline Diagrams (हिन्दी)

[← README (हिन्दी)](../README.hi.md)

यह स्थानीयकृत प्रति पाइपलाइन आरेखों को संबंधित स्थानीयकृत README से जोड़ती है।

## इवेंट स्टेट आरेख

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : कंप्यूटर A rsyslog इवेंट भेजता है

    A_WritingLogs --> B_HourlyRotate : घंटेवार cron / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : घंटेवार रोटेटेड लॉग बना
    B_WaitMoreLogs --> B_DailyArchive : दैनिक cron / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : .tar.gz (या .tar.gz.enc) बना

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : scp से कंप्यूटर C पर स्थानांतरण
    B_SendArchives --> B_RetryLater : C व्यस्त (.busy marker) या ट्रांसफर विफल
    B_RetryLater --> B_SendArchives : पुनःप्रयास अवधि

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : स्वीकार और कतारबद्ध
    C_ReceiveValidate --> C_Reject : अमान्य आर्काइव

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : आर्काइव टेप में जोड़ा गया + .taped marker
    C_WriteTape --> C_WaitTape : टेप नहीं/स्थान नहीं/त्रुटि
    C_WaitTape --> C_WriteTape : अगली रन में पुनःप्रयास

    C_Taped --> C_Inventory : आवश्यकतानुसार / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : आवश्यकतानुसार / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : पुनर्प्राप्त आर्काइव आउटपुट
```

## सीक्वेंस आरेख

```mermaid
sequenceDiagram
    autonumber
    participant A as कंप्यूटर A (rsyslog स्रोत)
    participant B as कंप्यूटर B (आर्काइव/भेजना)
    participant C as कंप्यूटर C (रिसीव/टेप)
    participant T as टेप डिवाइस

    Note over A,B: घंटेवार इनजेशन/रोटेशन
    A->>B: rsyslog इवेंट लगातार भेजें
    B->>B: computer-b-hourly-rotate.sh

    Note over B: दैनिक पैकेजिंग
    B->>B: computer-b-daily-archive.sh
    B->>B: .tar.gz (या .tar.gz.enc) बनाएँ

    Note over B,C: एक या अधिक C सर्वरों में ट्रांसफर
    B->>C: scp के माध्यम से computer-b-send-archives.sh
    alt C व्यस्त है (.busy marker)
        C-->>B: व्यस्त संकेत
        B->>B: प्रतीक्षा/पुनःप्रयास/फॉलबैक सर्वर
    else ट्रांसफर स्वीकार
        C-->>B: आर्काइव प्राप्त
    end

    Note over C: इनटेक और कतार
    C->>C: computer-c-receive-archives.sh
    alt आर्काइव वैध
        C->>C: टेप लेखन के लिए कतार में डालें
    else आर्काइव अमान्य
        C->>C: अस्वीकार + त्रुटि लॉग
    end

    Note over C,T: टेप रिकॉर्डिंग लूप
    C->>C: computer-c-write-to-tape.sh
    C->>T: डेटा के अंत तक जाकर आर्काइव जोड़ें
    T-->>C: लेखन सफल
    C->>C: .taped चिह्नित करें (और retention अनुसार सफाई)

    opt ऑपरेटर इन्वेंटरी
        C->>T: computer-c-inventory-tape.sh
        T-->>C: मार्कर-दर-मार्कर TOC
    end

    opt ऑपरेटर पुनर्स्थापन अनुरोध
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: मिलते marker पर आर्काइव डेटा
        C-->>A: जांच के लिए पुनर्प्राप्त .tar.gz लौटाएँ
    end
```

[← README (हिन्दी)](../README.hi.md)
