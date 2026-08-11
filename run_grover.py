import time
from qdk import Context

def main():
    print("Grover Arama Algoritması Projesi Yükleniyor...")
    try:
        # Proje dizinindeki Q# dosyalarını (qsharp.json ve src/GroverSearch.qs) yüklüyoruz
        ctx = Context(project_root=".")
        print("[OK] Proje başarıyla yüklendi.\n")
    except Exception as e:
        print("[ERROR] Proje yüklenemedi:", e)
        return
        
    shots = 100
    print(f"GroverSearch.RunGroverSearch() operasyonu {shots} kez (shots=100) simüle ediliyor...\n")
    
    start_time = time.time()
    try:
        # Grover aramasını simülatör üzerinde çalıştırıyoruz
        results = ctx.run("GroverSearch.RunGroverSearch()", shots=shots)
        elapsed = time.time() - start_time
        
        # Sonuçların |11> (her iki qubit'in de One olması) olup olmadığını doğruluyoruz
        success_count = 0
        for r in results:
            if len(r) == 2 and str(r[0]) == "One" and str(r[1]) == "One":
                success_count += 1
                
        print("=" * 60)
        print(" GROVER ARAMA SONUÇLARI ".center(60, "="))
        print("=" * 60)
        print(f"Toplam Simülasyon Sayısı (Shots) : {shots}")
        print(f"Hedef Elemanın Bulunma Sıklığı  : {success_count} ({(success_count/shots)*100:.2f}%)")
        print(f"Simülasyon Çalışma Süresi        : {elapsed:.4f} saniye")
        print("=" * 60)
        
        if success_count == shots:
            print("\n[OK] Grover Algoritması simülasyonu BAŞARIYLA TAMAMLANDI!")
            print("     1 İterasyon sonucunda hedef eleman (|11>) %100 olasılıkla bulundu.")
        else:
            print(f"\n[WARNING] Beklenen %100 başarı oranına ulaşılamadı. Başarı: {success_count}/{shots}")
            
    except Exception as e:
        print("[ERROR] Simülasyon sırasında bir hata oluştu:", e)

if __name__ == "__main__":
    main()
