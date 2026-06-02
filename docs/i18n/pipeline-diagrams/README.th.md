# A/B/C Pipeline Diagrams (ไทย)

[← README (ไทย)](../README.th.md)

ฉบับแปลนี้เชื่อมแผนภาพไปป์ไลน์กับ README ฉบับแปลที่สอดคล้องกัน

## แผนภาพสถานะเหตุการณ์

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : คอมพิวเตอร์ A ส่งเหตุการณ์ rsyslog

    A_WritingLogs --> B_HourlyRotate : cron รายชั่วโมง / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : สร้างล็อกรายชั่วโมงที่หมุนแล้ว
    B_WaitMoreLogs --> B_DailyArchive : cron รายวัน / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : สร้าง .tar.gz (หรือ .tar.gz.enc) แล้ว

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : โอนผ่าน scp ไปยังคอมพิวเตอร์ C
    B_SendArchives --> B_RetryLater : C ไม่ว่าง (.busy marker) หรือโอนล้มเหลว
    B_RetryLater --> B_SendArchives : ช่วงลองใหม่

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : รับแล้วและเข้าคิว
    C_ReceiveValidate --> C_Reject : อาร์ไคฟ์ไม่ถูกต้อง

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : เพิ่มอาร์ไคฟ์ลงเทปและทำเครื่องหมาย .taped
    C_WriteTape --> C_WaitTape : ไม่มีเทป/พื้นที่ไม่พอ/ผิดพลาด
    C_WaitTape --> C_WriteTape : ลองใหม่รอบถัดไป

    C_Taped --> C_Inventory : ตามต้องการ / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : ตามต้องการ / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : เอาต์พุตอาร์ไคฟ์ที่กู้คืน
```

## แผนภาพลำดับ

```mermaid
sequenceDiagram
    autonumber
    participant A as คอมพิวเตอร์ A (แหล่ง rsyslog)
    participant B as คอมพิวเตอร์ B (เก็บถาวร/ส่ง)
    participant C as คอมพิวเตอร์ C (รับ/เทป)
    participant T as อุปกรณ์เทป

    Note over A,B: รับเข้า/หมุนรายชั่วโมง
    A->>B: ส่งเหตุการณ์ rsyslog ต่อเนื่อง
    B->>B: computer-b-hourly-rotate.sh

    Note over B: แพ็กเกจรายวัน
    B->>B: computer-b-daily-archive.sh
    B->>B: สร้าง .tar.gz (หรือ .tar.gz.enc)

    Note over B,C: โอนไปยังเซิร์ฟเวอร์ C หนึ่งเครื่องหรือหลายเครื่อง
    B->>C: computer-b-send-archives.sh ผ่าน scp
    alt C ไม่ว่าง (.busy marker)
        C-->>B: แจ้งสถานะไม่ว่าง
        B->>B: รอ/ลองใหม่/ใช้เซิร์ฟเวอร์สำรอง
    else รับการโอนแล้ว
        C-->>B: ได้รับอาร์ไคฟ์แล้ว
    end

    Note over C: รับเข้าและเข้าคิว
    C->>C: computer-c-receive-archives.sh
    alt อาร์ไคฟ์ถูกต้อง
        C->>C: เข้าคิวสำหรับเขียนเทป
    else อาร์ไคฟ์ไม่ถูกต้อง
        C->>C: ปฏิเสธและบันทึกข้อผิดพลาด
    end

    Note over C,T: ลูปการบันทึกลงเทป
    C->>C: computer-c-write-to-tape.sh
    C->>T: เลื่อนไปท้ายข้อมูลแล้วเพิ่มอาร์ไคฟ์
    T-->>C: เขียนสำเร็จ
    C->>C: ทำเครื่องหมาย .taped (และล้างตามนโยบายเก็บรักษา)

    opt การตรวจรายการโดยผู้ปฏิบัติงาน
        C->>T: computer-c-inventory-tape.sh
        T-->>C: สารบัญตาม marker
    end

    opt คำขอกู้คืนจากผู้ปฏิบัติงาน
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: ข้อมูลอาร์ไคฟ์ที่ marker ที่ตรงกัน
        C-->>A: ส่งคืน .tar.gz ที่กู้คืนเพื่อการตรวจสอบ
    end
```

[← README (ไทย)](../README.th.md)
