# Kuantum Hesaplama Temelleri ve Q# Öğrenim Rehberi

Bu rehber, klasik yazılım mühendisliği altyapısına sahip öğrenciler için kuantum bilişim teorisinin temel kavramlarını ve Q# kodlama pratiklerini açıklamak amacıyla hazırlanmıştır.

---

## 1. Qubit ve Süperpozisyon (Superposition)

### Klasik Bit vs. Qubit
*   **Klasik Bit:** Sadece iki durumdan birinde bulunabilir: $0$ veya $1$ (açık veya kapalı).
*   **Qubit (Kuantum Bit):** Aynı anda hem $|0\rangle$ hem de $|1\rangle$ durumlarının doğrusal bir kombinasyonunda (süperpozisyon) bulunabilen kuantum sistemidir.

Kuantum durumunu matematiksel olarak bir dalga fonksiyonu ile gösteririz:
$$|\psi\rangle = \alpha|0\rangle + \beta|1\rangle$$

Burada $\alpha$ ve $\beta$, ilgili durumların genliklerini (amplitude) temsil eden karmaşık (complex) sayılardır. Bu genliklerin mutlak karelerinin toplamı her zaman 1 olmalıdır (olasılıkların korunumu yasası):
$$|\alpha|^2 + |\beta|^2 = 1$$

*   $|\alpha|^2$: Qubit ölçüldüğünde $|0\rangle$ sonucunu alma olasılığıdır.
*   $|\beta|^2$: Qubit ölçüldüğünde $|1\rangle$ sonucunu alma olasılığıdır.

### Bloch Küresi (Bloch Sphere)
Tek bir qubit'in durumu, yarıçapı 1 olan geometrik bir küre (Bloch Küresi) üzerindeki bir nokta olarak görselleştirilebilir:
*   Kürenin kuzey kutbu $|0\rangle$ durumunu temsil eder.
*   Güney kutbu $|1\rangle$ durumunu temsil eder.
*   Ekvator üzerindeki tüm noktalar ise eşit süperpozisyon durumlarını temsil eder (örneğin, Hadamard kapısı ile elde edilen $|+\rangle = \frac{|0\rangle + |1\rangle}{\sqrt{2}}$ durumu).

---

## 2. Kuantum Ölçümü ve Rastgelelik (Measurement & Randomness)

Kuantum mekaniğinde ölçüm yapmak, qubit'in süperpozisyon durumunu yok eder. Ölçüm yapıldığında qubit, olasılık genliklerine ($|\alpha|^2$ ve $|\beta|^2$) bağlı olarak anında klasik bir değere ($0$ veya $1$) **çöker (collapse)**. 

Bu rastgelelik yarı-rastgelelik (pseudorandomness) değildir; tamamen doğa yasalarından kaynaklanan **gerçek rastgeleliktir (true randomness)**.

---

## 3. Klonlanamazlık İlkesi (No-Cloning Principle)

Kuantum mekaniğinin en temel teoremlerinden biri, bilinmeyen rastgele bir kuantum durumunun mükemmel bir kopyasının oluşturulmasının imkansız olmasıdır:
*   Klasik programlamada bir değişkenin değerini kopyalamak (`let b = a`) son derece doğaldır.
*   Kuantum dünyasında ise bir qubit'in süperpozisyon durumunu okumadan (ki okumak durumu çökertecektir) başka bir qubit'e birebir kopyalamak fiziksel olarak yasaktır. 

Bu kural, kuantum algoritmalarının tasarımını zorlaştırsa da kuantum kriptografisinin (örneğin kırılamaz kuantum anahtar dağıtımının) temelini oluşturur.

---

## 4. Dolanıklık ve Bell Durumları (Entanglement & Bell States)

Dolanıklık, iki veya daha fazla qubit'in durumlarının birbirinden bağımsız olarak açıklanamayacak şekilde birbirine bağlanmasıdır. Dolanık qubit'lerden birinin ölçülmesi, aralarındaki mesafe ne olursa olsun diğer qubit'in durumunu anında belirler.

En temel dolanıklık durumu **Bell State** ($|\Phi^+\rangle$) olarak adlandırılır:
$$|\Phi^+\rangle = \frac{|00\rangle + |11\rangle}{\sqrt{2}}$$

Bu durumu oluşturmak için:
1. Birinci qubit'e **Hadamard (H)** kapısı uygulanarak süperpozisyona sokulur.
2. İki qubit arasında **CNOT (Controlled-NOT)** kapısı uygulanarak birinci qubit'in durumu ikinci qubit'e dolandırılır.

Eğer birinci qubit ölçüldüğünde $0$ çıkarsa, ikinci qubit de kesinlikle $0$ çıkacaktır. Birinci qubit $1$ çıkarsa, ikinci qubit de kesinlikle $1$ çıkacaktır.

---

## 5. Kuantum Işınlama (Quantum Teleportation)

No-Cloning ilkesine göre kuantum durumlarını kopyalayamayız. Ancak **Kuantum Işınlama** protokolü sayesinde, dolanıklık ve klasik iletişim kanallarını kullanarak bir qubit'in kuantum bilgisini fiziksel olarak taşımadan başka bir qubit'e aktarabiliriz.

### Protokol Adımları (Alice & Bob):
1. **Paylaşım:** Üçüncü bir taraf dolanık bir Bell çifti ($q_A$ ve $q_B$) oluşturur. $q_A$'yı Alice'e, $q_B$'yi Bob'a gönderir.
2. **Mesaj Hazırlığı:** Alice ışınlamak istediği bilinmeyen durumdaki $|\psi\rangle$ qubit'ini (mesaj qubit'i) alır.
3. **Bell Ölçümü:** Alice kendi elindeki mesaj qubit'i ile dolanık qubit'i ($q_A$) üzerinde CNOT ve H kapılarını kullanarak bir ölçüm gerçekleştirir. Bu ölçüm sonucunda 2 adet klasik bit ($0$ veya $1$) elde eder. (Alice'in orijinal kuantum durumu bu ölçümle çöker/yok olur).
4. **Klasik İletişim:** Alice ölçüm sonuçlarını klasik bir kanal (internet, telefon vb.) üzerinden Bob'a gönderir.
5. **Düzeltme (Correction):** Bob, Alice'den gelen iki klasik bite göre elindeki qubit'e ($q_B$) şu düzeltmeleri uygular:
    * Birinci bit 1 ise: **X kapısı** (durum değiştirici) uygular.
    * İkinci bit 1 ise: **Z kapısı** (faz değiştirici) uygular.
6. **Sonuç:** Bob'un qubit'i ($q_B$), Alice'in başlangıçtaki mesaj durumuna ($|\psi\rangle$) dönüşmüştür.

---

## 6. Bilgisayar Bilimleri Analojileri

*   **Süperpozisyon vs. Paralel Arama:** Süperpozisyon, tüm olası girdilerin aynı anda kuantum register'ında bulunmasıdır. Bunu, algoritmanın tek bir işlemle tüm olası arama uzayını paralel olarak değerlendirmesi gibi düşünebilirsiniz (ancak sadece tek bir ölçüm sonucu alabileceğimiz için özel kuantum algoritmaları gereklidir).
*   **Dolanıklık vs. Paylaşılan Dağıtık Durum:** Dolanıklık, iki uzak sistemin veritabanı senkronizasyonuna gerek duymadan her zaman mükemmel bir şekilde eşleşen değerler döndürmesi gibidir. Aradaki bağ anlıktır ve ağ gecikmesinden etkilenmez (ancak bu bağ ışık hızından hızlı bilgi iletmek için kullanılamaz).

---

## 7. Checkpoint Quiz

Kendinizi test etmek için aşağıdaki soruları yanıtlayın. (Cevap anahtarı sayfanın altındadır).

### Sorular:
1. **Aşağıdakilerden hangisi bir Q# `function` bloğu içerisinde yapılabilir?**
   * A) Bir Qubit tahsis etmek (`use`)
   * B) Hadamard (H) kapısı uygulamak
   * C) İki klasik tamsayıyı toplamak ve sonucu döndürmek
   * D) Qubit ölçümü gerçekleştirmek

2. **Bir qubit $|\psi\rangle = \frac{\sqrt{3}}{2}|0\rangle + \frac{1}{2}|1\rangle$ durumundayken ölçülürse, $|1\rangle$ çıkma olasılığı nedir?**
   * A) %25
   * B) %50
   * C) %75
   * D) %100

3. **No-Cloning (Klonlanamazlık) ilkesi aşağıdakilerden hangisini yasaklar?**
   * A) Bir qubit'in ölçülerek değerinin okunmasını
   * B) Bilinmeyen bir kuantum durumunun başka bir qubit'e kopyalanmasını
   * C) Qubit'lerin dolanık hale getirilmesini
   * D) Klasik bilgisayarlarda kuantum simülasyonu çalıştırılmasını

4. **Kuantum Işınlama (Quantum Teleportation) protokolünde Alice'den Bob'a aktarılan bilgi nedir?**
   * A) Dolanık qubit'ler üzerinden ışık hızından hızlı gönderilen klasik veriler
   * B) Kuantum durumunu çökerterek elde edilen klasik bitlerin kendisi
   * C) Fiziksel qubit'in kendisi
   * D) Qubit'in kuantum durumu (fiziksel taşıma olmadan ve klasik feed-forward yardımıyla)

---

### Cevap Anahtarı:
1. **C** (Functions sadece saf klasik mantık içerir, yan etki oluşturacak kuantum işlemleri barındıramaz).
2. **A** (Olasılık genliğinin mutlak karesi alınır: $(1/2)^2 = 1/4 = 0.25$, yani %25).
3. **B** (Bilinmeyen rastgele bir kuantum durumunun kopyalanması kuantum mekaniğince imkansız kılınmıştır).
4. **D** (Fiziksel olarak qubit gönderilmez, sadece dolanıklık ve klasik bitlerle durumu aktarılır).
