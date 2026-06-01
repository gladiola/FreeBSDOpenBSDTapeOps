# FreeBSDOpenBSDTapeOps (ไทย)

สคริปต์เชลล์แบบโต้ตอบสำหรับงานเทปแม่เหล็กทั่วไป โดยใช้ mt และ tar

## การใช้งานแบบรวดเร็ว

- รัน `./scriptedDemo.sh` บน FreeBSD หรือ `./scriptedDemo_openbsd.sh` บน OpenBSD
- ยืนยันว่าใส่เทปแล้ว และกด Enter ในแต่ละขั้นตอน
- ใช้สคริปต์ใน `scripts/` สำหรับการเก็บถาวร A→B→C การส่งต่อ การเขียนเทป การตรวจรายการ และการกู้คืน

## Commands

```sh
./scriptedDemo.sh            # FreeBSD demo
./scriptedDemo_openbsd.sh    # OpenBSD demo
scripts/test-computer-a-b-c-integration.sh
```
