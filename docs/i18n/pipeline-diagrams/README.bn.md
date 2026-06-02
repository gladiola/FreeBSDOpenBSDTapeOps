# A/B/C Pipeline Diagrams (বাংলা)

[← README (বাংলা)](../README.bn.md)

এই স্থানীয়কৃত কপিটি পাইপলাইন ডায়াগ্রামগুলোকে সংশ্লিষ্ট স্থানীয়কৃত README-এর সাথে যুক্ত করে।

## ইভেন্ট স্টেট ডায়াগ্রাম

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : কম্পিউটার A rsyslog ইভেন্ট তৈরি করে

    A_WritingLogs --> B_HourlyRotate : প্রতি ঘণ্টার cron / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : রোটেট করা ঘণ্টাভিত্তিক লগ তৈরি
    B_WaitMoreLogs --> B_DailyArchive : দৈনিক cron / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : .tar.gz (বা .tar.gz.enc) তৈরি হয়েছে

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : scp দিয়ে কম্পিউটার C-এ পাঠানো
    B_SendArchives --> B_RetryLater : C ব্যস্ত (.busy marker) বা ট্রান্সফার ব্যর্থ
    B_RetryLater --> B_SendArchives : পুনরায় চেষ্টার সময়সীমা

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : গৃহীত ও কিউতে যোগ
    C_ReceiveValidate --> C_Reject : অবৈধ আর্কাইভ

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : আর্কাইভ টেপে যোগ + .taped marker
    C_WriteTape --> C_WaitTape : টেপ নেই/স্পেস নেই/ত্রুটি
    C_WaitTape --> C_WriteTape : পরের রানে পুনরায় চেষ্টা

    C_Taped --> C_Inventory : প্রয়োজনে / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : প্রয়োজনে / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : পুনরুদ্ধার করা আর্কাইভ আউটপুট
```

## সিকোয়েন্স ডায়াগ্রাম

```mermaid
sequenceDiagram
    autonumber
    participant A as কম্পিউটার A (rsyslog উৎস)
    participant B as কম্পিউটার B (আর্কাইভ/পাঠানো)
    participant C as কম্পিউটার C (গ্রহণ/টেপ)
    participant T as টেপ ডিভাইস

    Note over A,B: প্রতি ঘণ্টায় গ্রহণ/রোটেশন
    A->>B: rsyslog ইভেন্ট ধারাবাহিকভাবে পাঠান
    B->>B: computer-b-hourly-rotate.sh

    Note over B: দৈনিক প্যাকেজিং
    B->>B: computer-b-daily-archive.sh
    B->>B: .tar.gz (বা .tar.gz.enc) তৈরি করুন

    Note over B,C: এক বা একাধিক C সার্ভারে ট্রান্সফার
    B->>C: scp এর মাধ্যমে computer-b-send-archives.sh
    alt C ব্যস্ত (.busy marker)
        C-->>B: ব্যস্ততার সংকেত
        B->>B: অপেক্ষা/পুনরায় চেষ্টা/ফলব্যাক সার্ভার
    else ট্রান্সফার গৃহীত
        C-->>B: আর্কাইভ পাওয়া গেছে
    end

    Note over C: গ্রহণ ও কিউ
    C->>C: computer-c-receive-archives.sh
    alt আর্কাইভ বৈধ
        C->>C: টেপ লেখার কিউতে যোগ করুন
    else আর্কাইভ অবৈধ
        C->>C: প্রত্যাখ্যান + ত্রুটি লগ
    end

    Note over C,T: টেপ রেকর্ডিং লুপ
    C->>C: computer-c-write-to-tape.sh
    C->>T: ডেটার শেষে গিয়ে আর্কাইভ যোগ করুন
    T-->>C: লেখা সফল
    C->>C: .taped চিহ্ন দিন (এবং retention অনুযায়ী পরিষ্কার)

    opt অপারেটর ইনভেন্টরি
        C->>T: computer-c-inventory-tape.sh
        T-->>C: marker-ভিত্তিক TOC
    end

    opt অপারেটর পুনরুদ্ধার অনুরোধ
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: মিল থাকা marker-এ আর্কাইভ ডেটা
        C-->>A: পরীক্ষার জন্য পুনরুদ্ধার করা .tar.gz ফেরত দিন
    end
```

[← README (বাংলা)](../README.bn.md)
