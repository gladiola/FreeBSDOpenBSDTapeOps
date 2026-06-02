# مخططات خط أنابيب A/B/C (العربية)

[← README (العربية)](../README.ar.md)

تربط هذه النسخة المترجمة مخططات خط الأنابيب بملف README المترجم المقابل.

## مخطط حالة الأحداث

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : الحاسوب A يُنتج أحداث rsyslog

    A_WritingLogs --> B_HourlyRotate : كرون كل ساعة / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : تم إنشاء سجل مُدار كل ساعة
    B_WaitMoreLogs --> B_DailyArchive : كرون يومي / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : تم إنشاء .tar.gz (أو .tar.gz.enc)

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : نقل scp إلى الحاسوب C
    B_SendArchives --> B_RetryLater : انشغال C (علامة .busy) أو فشل النقل
    B_RetryLater --> B_SendArchives : نافذة إعادة المحاولة

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : تم القبول + الإدراج في الطابور
    C_ReceiveValidate --> C_Reject : أرشيف غير صالح

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : أُضيف الأرشيف إلى الشريط + علامة .taped
    C_WriteTape --> C_WaitTape : لا يوجد شريط/مساحة/حدث خطأ
    C_WaitTape --> C_WriteTape : إعادة المحاولة في التشغيل التالي

    C_Taped --> C_Inventory : عند الطلب / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : عند الطلب / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : إخراج الأرشيف المستعاد
```

## مخطط التسلسل

```mermaid
sequenceDiagram
    autonumber
    participant A as الحاسوب A (مصدر rsyslog)
    participant B as الحاسوب B (الأرشفة/الإرسال)
    participant C as الحاسوب C (الاستقبال/الشريط)
    participant T as جهاز الشريط

    Note over A,B: استيعاب/تدوير كل ساعة
    A->>B: إرسال أحداث rsyslog باستمرار
    B->>B: computer-b-hourly-rotate.sh (كل ساعة)

    Note over B: التغليف اليومي
    B->>B: computer-b-daily-archive.sh (يوميًا)
    B->>B: إنشاء .tar.gz (أو .tar.gz.enc)

    Note over B,C: النقل إلى خادم C واحد أو أكثر
    B->>C: computer-b-send-archives.sh عبر scp
    alt C مشغول (علامة .busy)
        C-->>B: إشارة انشغال
        B->>B: انتظار/إعادة محاولة/خادم بديل
    else تم قبول النقل
        C-->>B: تم استلام الأرشيف
    end

    Note over C: الاستقبال والإدراج في الطابور
    C->>C: computer-c-receive-archives.sh
    alt الأرشيف صالح
        C->>C: إدراج في طابور الكتابة إلى الشريط
    else الأرشيف غير صالح
        C->>C: رفض + تسجيل الخطأ
    end

    Note over C,T: حلقة التسجيل على الشريط
    C->>C: computer-c-write-to-tape.sh
    C->>T: الانتقال إلى نهاية البيانات + إلحاق الأرشيف
    T-->>C: نجحت الكتابة
    C->>C: وَسم .taped (وتنظيف حسب سياسة الاحتفاظ)

    opt جرد المشغّل
        C->>T: computer-c-inventory-tape.sh
        T-->>C: فهرس علامة بعلامة
    end

    opt طلب استعادة من المشغّل
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: حمولة الأرشيف عند العلامة المطابقة
        C-->>A: ملف .tar.gz مستعاد للفحص
    end
```

[← README (العربية)](../README.ar.md)
