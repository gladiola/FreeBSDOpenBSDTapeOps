# FreeBSDOpenBSDTapeOps (हिन्दी)

`mt` और `tar` का उपयोग करके सामान्य मैग्नेटिक टेप ऑपरेशनों का मार्गदर्शन करने वाली इंटरैक्टिव शेल स्क्रिप्टें.

## भाषा दस्तावेज़ सूचकांक

- [US English](README.en-US.md)
- [Deutsch (German)](README.de.md)
- [Español (Spanish)](README.es.md)
- [Français (French)](README.fr.md)
- [Português (Portuguese)](README.pt.md)
- [Italiano (Italian)](README.it.md)
- [繁體中文 (香港) / Traditional Chinese (Hong Kong)](README.zh-HK.md)
- [简体中文 (Simplified Chinese)](README.zh-CN.md)
- [한국어 (Korean)](README.ko.md)
- [हिन्दी (Hindi)](README.hi.md)
- [Русский (Russian)](README.ru.md)
- [العربية (Arabic)](README.ar.md)
- [Kiswahili (Swahili)](README.sw.md)
- [日本語 (Japanese)](README.ja.md)
- [Kreyòl Ayisyen (Haitian Creole)](README.ht.md)
- [ʻŌlelo Hawaiʻi (Hawaiian)](README.haw.md)
- [Gagana Samoa (Samoan)](README.sm.md)
- [Te Reo Māori (Maori)](README.mi.md)
- [Afrikaans](README.af.md)
- [Nederlands (Dutch)](README.nl.md)
- [Hausa](README.ha.md)
- [አማርኛ (Amharic)](README.am.md)
- [Yorùbá (Yoruba)](README.yo.md)
- [বাংলা (Bengali)](README.bn.md)
- [Gaeilge (Irish)](README.ga.md)
- [Eesti (Estonian)](README.et.md)
- [Suomi (Finnish)](README.fi.md)
- [Svenska (Swedish)](README.sv.md)
- [Norsk (Norwegian)](README.no.md)
- [Українська (Ukrainian)](README.uk.md)
- [ไทย (Thai)](README.th.md)
- [Bahasa Indonesia](README.id.md)
- [Tagalog](README.tl.md)
- [Bahasa Melayu (Malay)](README.ms.md)
- [Basa Jawa (Javanese)](README.jv.md)
- [Ελληνικά (Greek)](README.el.md)
- [Latina (Latin)](README.la.md)
- [עברית (Hebrew)](README.he.md)


## स्क्रिप्टें

| स्क्रिप्ट | लक्ष्य OS |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

दोनों स्क्रिप्टें ऑपरेशनों का एक ही क्रम निष्पादित करती हैं:

1. उपयोगकर्ता से पुष्टि करने के लिए कहती हैं कि टेप लोड है.
2. टेप को रीवाइंड करती हैं.
3. टेप की स्थिति प्रिंट करती हैं.
4. `tar t` का उपयोग करके फ़ाइल स्थिति 0, 1, 2, और 3 पर मौजूद आर्काइव्स की सामग्री सूचीबद्ध करती हैं.
5. टेप को ऑफ़लाइन ले जाती हैं.

हर चरण रुकता है और आगे बढ़ने से पहले उपयोगकर्ता के **Enter** दबाने की प्रतीक्षा करता है, जिससे ये स्क्रिप्टें इंटरैक्टिव डिमॉन्स्ट्रेशन या निर्देशित वॉकथ्रू के लिए उपयुक्त बनती हैं.

## दोनों स्क्रिप्टों के बीच अंतर

### 1. टेप डिवाइस पथ

स्क्रिप्टें अलग-अलग टेप डिवाइस नोड्स को लक्षित करती हैं:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

दोनों बिना-स्वतः-रीवाइंड वाले डिवाइस नोड्स हैं (`n` प्रीफ़िक्स), इसलिए कमांडों के बीच टेप की स्थिति सुरक्षित रहती है और स्क्रिप्टें `mt rewind` तथा `mt fsf` के साथ स्थिति को स्पष्ट रूप से नियंत्रित करती हैं.

### 2. टेप लोडिंग चरण

- **FreeBSD**: रीवाइंड करने से पहले टेप कार्ट्रिज को ड्राइव में यांत्रिक रूप से लोड करने के लिए स्टार्टअप पर `mt -f /dev/nsa0 load` जारी करता है.
- **OpenBSD**: `load` कमांड को छोड़ देता है क्योंकि OpenBSD के `mt(1)` में `load` उप-कमांड समर्थित नहीं है. OpenBSD स्क्रिप्ट मानती है कि टेप पहले से ही ड्राइव में मौजूद है और सीधे रीवाइंड पर आगे बढ़ती है.

## OpenBSD A-to-B-to-C लॉग पाइपलाइन स्क्रिप्टें

`scripts/` डायरेक्टरी उस परिदृश्य के लिए स्क्रिप्टें प्रदान करती है जिसमें OpenBSD Computer B, Computer A से rsyslog प्रविष्टियाँ प्राप्त करता है, उन्हें प्रतिदिन बैच करता है, कई Computer C सर्वरों में से किसी एक को भेजता है, और Computer C उन्हें टेप पर लिखता है.

| स्क्रिप्ट | उद्देश्य |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Computer B पर सक्रिय rsyslog इनपुट फ़ाइल से घंटेवार घुमाई गई लॉग फ़ाइल बनाता है. |
| `scripts/computer-b-daily-archive.sh` | सक्रिय-लेखन टकराव से बचने के लिए वर्तमान घंटे को छोड़ते हुए, Computer B पर एक दिन (`YYYYMMDD`) के घंटेवार लॉग्स को समय-सीमा वाली `.tar.gz` आर्काइव में बंडल करता है. |
| `scripts/computer-b-send-archives.sh` | Computer B से एक या अधिक Computer C सर्वरों को `scp` के माध्यम से न भेजी गई दैनिक आर्काइव्स (`.tar.gz` और वैकल्पिक `.tar.gz.enc`) भेजता है. |
| `scripts/computer-c-receive-archives.sh` | आने वाली सादा-पाठ आर्काइव्स का सत्यापन करता है और सादा-पाठ/एन्क्रिप्टेड आर्काइव्स को टेप के लिए कतारबद्ध करता है. |
| `scripts/computer-c-write-to-tape.sh` | कतारबद्ध सादा-पाठ या एन्क्रिप्टेड आर्काइव्स को टेप पर लिखता है, स्थान जाँचता है, सुरक्षित रूप से सुरक्षित रूप से जोड़ता है, और उन्हें रिकॉर्ड किए गए के रूप में चिह्नित करता है. |
| `scripts/computer-c-inventory-tape.sh` | फ़ाइल मार्कर के आधार पर टेप की विषय-सूची प्रिंट करता है ताकि ऑपरेटर आर्काइव्स को जल्दी खोज सकें. |
| `scripts/computer-c-restore-archive-from-tape.sh` | अनुरोधित आर्काइव के लिए टेप फ़ाइल स्थितियों को स्कैन करता है, आवश्यकता होने पर डिक्रिप्ट करता है, और पुनर्प्राप्त डेटा को एक फ़ाइल में सहेजता है. |
| `scripts/test-computer-a-b-c-integration.sh` | एक निर्धारक स्थानीय A→B→C एकीकरण परीक्षण चलाता है (जिसमें टेप पुनर्स्थापन शामिल है) जो वास्तविक घड़ी-समय पर निर्भर नहीं करता. |

सामान्य शेड्यूलिंग:

- `computer-b-hourly-rotate.sh` हर घंटे चलाएँ (B पर cron).
- `computer-b-daily-archive.sh` दिन में एक बार चलाएँ (B पर cron).
- `computer-b-send-archives.sh` आर्काइव बनने के बाद चलाएँ (B पर cron).
- `computer-c-receive-archives.sh` को C पर समय-समय पर चलाएँ.
- `computer-c-write-to-tape.sh` को सही टेप डिवाइस के साथ C पर समय-समय पर चलाएँ.
- जब मार्कर-दर-मार्कर विषय-सूची की आवश्यकता हो, तब `computer-c-inventory-tape.sh` को C पर चलाएँ.
- किसी विशिष्ट आर्काइव को निरीक्षण के लिए पुनर्प्राप्त करना हो, तब `computer-c-restore-archive-from-tape.sh` को C पर चलाएँ.

सभी पाइपलाइन स्क्रिप्टें कंसोल आउटपुट के अतिरिक्त `logger` के माध्यम से syslog में भी परिचालन संदेश भेजती हैं (उदाहरण के लिए, rsyslog/जर्नलिंग के माध्यम से दिखाई देने वाले).

### Computer B से बहु-सर्वर प्रेषण

`computer-b-send-archives.sh` एकल-सर्वर मोड और बहु-सर्वर मोड दोनों का समर्थन करता है:

- एकल-सर्वर: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- बहु-सर्वर: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

क्लाइंट-पक्ष सर्वर चयन विकल्प:

- एक Computer C पर स्थिर रहने के लिए आर्ग्युमेंट्स में एक सर्वर दें.
- वैकल्पिक वापसी की अनुमति देने के लिए कई सर्वर दें.
- दिए गए सर्वरों की सूची में से एक विशिष्ट सर्वर चुनने के लिए `PREFERRED_SERVER=user@host` सेट करें.

Computer B पर व्यस्तता-प्रबंधन विकल्प:

- `REMOTE_BUSY_MARKER` (डिफ़ॉल्ट: `.busy`): रिमोट पक्ष पर जाँची जाने वाली संकेतक फ़ाइल.
- `BUSY_RETRY_SECONDS` (डिफ़ॉल्ट: `60`): सर्वर व्यस्त होने पर पुनःप्रयासों के बीच प्रतीक्षा समय.
- `BUSY_MAX_RETRIES` (डिफ़ॉल्ट: `10`): प्रति सर्वर पुनःप्रयासों की अधिकतम संख्या.

### Computer C से व्यस्त स्थिति प्रकाशन

`computer-c-write-to-tape.sh` टेप पर सक्रिय रूप से आर्काइव्स लिखते समय एक व्यस्तता संकेतक बनाता है और निष्क्रिय होने पर उसे हटा देता है.

- `BUSY_MARKER` (डिफ़ॉल्ट: `<received_dir>/.busy`)

Computer B पर `REMOTE_BUSY_MARKER` को उस संकेतक स्थान की ओर इंगित करें जिसका उपयोग Computer C करता है.

### Computer C पर टेप सुरक्षा और जोड़ने का व्यवहार

प्रत्येक आर्काइव लिखने से पहले, `computer-c-write-to-tape.sh` उपलब्ध टेप/डिवाइस क्षमता की जाँच करता है और कम-से-कम यह आवश्यक करता है:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

संबंधित वेरिएबल्स:

- `TAPE_SAFETY_MARGIN_BYTES` (डिफ़ॉल्ट: `10485760`)
- `TAPE_AVAILABLE_BYTES` (ज्ञात उपलब्ध स्थान के लिए ओवरराइड)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (यदि स्थान का पता न चल सके तो लिखने की अनुमति देता है)

वास्तविक टेप डिवाइसेज़ के लिए, लेखन स्क्रिप्ट लिखने से पहले डेटा-अंत (`mt eom`/`mt eod`) तक जाती है, इसलिए कई आर्काइव्स पहले से मौजूद टेप सामग्री को ओवरराइट करने के बजाय जोड़ी जाती हैं.

### फ़ाइलनामों में मानव-पठनीय समय-मुद्राएँ

- घंटेवार लॉग्स का नाम इस तरह होता है: `rsyslog-2026-06-01T1600.log`
- दैनिक आर्काइव्स का नाम इस तरह होता है: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

दैनिक आर्काइव रेंज, आर्काइव में शामिल वास्तविक पहले और अंतिम घंटेवार फ़ाइलों पर आधारित होती हैं.
ये नाम उन लोगों के लिए पठनीय बनाए गए हैं जो इवेंट दिनांक/समय विंडो खोजते हुए स्कैन करते हैं.
सक्रिय लिखाइयाँ प्रेषित न हों, इसके लिए वर्तमान घंटे को जानबूझकर आर्काइव निर्माण से बाहर रखा जाता है.

### दैनिक आर्काइव्स के लिए वैकल्पिक OpenSSL एन्क्रिप्शन

`computer-b-daily-archive.sh` tar आर्काइव बनाने के बाद OpenSSL के साथ आर्काइव्स एन्क्रिप्ट कर सकता है:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` सममित एन्क्रिप्शन के लिए (`openssl enc`, डिफ़ॉल्ट साइफ़र `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` प्राप्तकर्ता-प्रमाणपत्र एन्क्रिप्शन के लिए (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` key-file और certificate दोनों मोडों के लिए OpenSSL साइफ़र चुनने हेतु (डिफ़ॉल्ट: `aes-256-gcm`).

एक समय में इन विकल्पों में से केवल एक ही सेट किया जा सकता है. एन्क्रिप्टेड आउटपुट `.tar.gz.enc` का उपयोग करते हैं.
सुरक्षा के लिए, स्क्रिप्ट कमजोर या गैर-AEAD साइफ़र विकल्पों को अस्वीकार करती है और GCM/poly1305-श्रेणी के साइफ़रों की आवश्यकता रखती है.

### Computer C पर टेप से आर्काइव पुनर्प्राप्ति

किसी विशिष्ट आर्काइव को खोजने के लिए `computer-c-restore-archive-from-tape.sh` का उपयोग करें; यह शुरुआत से क्रम में टेप फ़ाइलों को खोजता है:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- `rsyslog-<start>_to_<end>.tar.gz` (या `.tar.gz.enc`) जैसे आर्काइव नामों के लिए, स्क्रिप्ट पुनर्प्राप्त डेटा-पेलोड में सीमा-घंटेवार फ़ाइलों की उपस्थिति जाँचकर सही मिलान पहचानती है.
- यदि आपका आर्काइव नामकरण अलग है, तो `TARGET_MEMBER_GLOB` को उस शेल पैटर्न पर सेट करें जो ऐसे सदस्य से मेल खाता हो जो आर्काइव में अवश्य मौजूद होना चाहिए.
- यदि कोई आर्काइव एन्क्रिप्टेड है, तो आवश्यकता अनुसार डिक्रिप्शन सेटिंग्स प्रदान करें:
  - `OPENSSL_DECRYPT_KEY_FILE` (सममित `openssl enc` मोड; डिफ़ॉल्ट डिक्रिप्ट साइफ़र: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` और `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (S/MIME डिक्रिप्ट मोड)

पुनर्प्राप्त आउटपुट सादा-पाठ `.tar.gz` फ़ाइल के रूप में लिखा जाता है ताकि इसे `tar -tzf` जैसे टूल्स से जाँचा जा सके.

### Computer C पर टेप विषय-सूची सूचीकरण

मार्कर-दर-मार्कर विषय-सूची प्रिंट करने के लिए `computer-c-inventory-tape.sh` का उपयोग करें:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

आउटपुट कॉलमों में शामिल हैं:

- `file_marker`: शून्य-आधारित टेप फ़ाइल मार्कर स्थिति
- `status`: `ok`, `decrypted`, या `unreadable`
- `encrypted`: क्या प्रविष्टि का निरीक्षण करने के लिए डिक्रिप्शन की आवश्यकता थी (`yes`/`no`)
- `archive_hint`: जब सीमाएँ पहचानी जा सकें, तब अनुमानित आर्काइव-शैली नाम
- `first_member` / `last_member`: उस मार्कर में दिखाई देने वाले पहले और अंतिम tar सदस्यों
- `member_count`: उस मार्कर में मिले tar सदस्यों की संख्या
- `bytes`: उस मार्कर पर पढ़े गए कच्चे बाइट्स

इससे ऑपरेटर पुनर्स्थापन क्रियाओं से पहले जाने के लिए मार्कर सूचकांक (`mt fsf <N>`) की पहचान कर सकता है.

### निर्धारक A/B/C एकीकरण परीक्षण

बीते समय की परवाह किए बिना Computers A, B, और C के सिरे-से-सिरे एकीकरण को सत्यापित करने के लिए `scripts/test-computer-a-b-c-integration.sh` का उपयोग करें:

```sh
scripts/test-computer-a-b-c-integration.sh
```

यह स्क्रिप्ट:

1. A द्वारा logs लिखने का अनुकरण करती है.
2. B rotation और daily archive creation चलाती है.
3. C आवक में transfer का अनुकरण करती है.
4. C receive + write-to-tape चलाती है.
5. tape से archive restore करती है और सामग्री को सत्यापित करती है.

यह एक स्थिर दिन-मुहर (`TEST_DAY_STAMP`, डिफ़ॉल्ट `20260101`) का उपयोग करती है ताकि व्यवहार पुनरावृत्त रहे और वर्तमान दिनांक/समय से बँधा न हो.

### अपुष्ट डेटा के लिए सुरक्षा सहित 72-घंटे की संग्रहण

स्क्रिप्टें अब डिफ़ॉल्ट रूप से 72-घंटे की संग्रहण window अपनाती हैं:

- `computer-b-hourly-rotate.sh` पुराने घंटेवार logs को तभी हटाता है जब मेल खाता स्थानीय `.taped` confirmation marker मौजूद हो.
- `computer-b-send-archives.sh` पुराने स्थानीय archives को तभी हटाता है जब `.sent` और स्थानीय `.taped` दोनों confirmation markers मौजूद हों.
- `computer-c-write-to-tape.sh` केवल उन पुराने archives को हटाता है जिन पर पहले से `.taped` markers मौजूद हैं.

परिणामस्वरूप, जो फ़ाइलें अभी तक सफलतापूर्वक प्रेषित होकर tape पर record नहीं हुई हैं, वे `RETENTION_HOURS` (डिफ़ॉल्ट `72`) से अधिक पुरानी होने पर भी सुरक्षित रहती हैं.
Computer B पर, स्थानीय सफ़ाई के लिए local `.taped` markers आवश्यक होते हैं (उदाहरण के लिए, सिंक-बैक चरण या मैनुअल पुष्टि प्रक्रिया से).
Computer C पर, संग्रहण age `.taped` marker के modification time से मापी जाती है (जो सामान्यतः सफल tape write के समय सेट होती है).

## पाइपलाइन आरेख

- [A/B/C Mermaid सीक्वेंस और स्टेट आरेख](pipeline-diagrams/README.hi.md)
