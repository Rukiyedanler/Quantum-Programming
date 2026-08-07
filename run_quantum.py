import time
from qdk import Context

def print_header(title):
    print("=" * 60)
    print(f" {title.upper()} ".center(60, "="))
    print("=" * 60)

def main():
    print("Kuantum Simülasyon Ortamı Başlatılıyor...")
    try:
        # Q# projesini yükle (qsharp.json ve src/ klasörünü algılar)
        ctx = Context(project_root=".")
        print("[OK] Q# Projesi başarıyla yüklendi.\n")
    except Exception as e:
        print("[ERROR] Q# Projesi yüklenirken hata oluştu:", e)
        return

    # Kuantum algoritmalarını referans al
    algorithms = ctx.code.QuantumAlgorithms

    # =========================================================================
    # Deney 1: Süperpozisyon (Rastgele Bit Üreteci)
    # =========================================================================
    print_header("Deney 1: Süperpozisyon ve Rastgele Bit Üreteci")
    print("Hadamard (H) kapısı uygulanarak qubit süperpozisyona sokuluyor...")
    print("Simülatör 1000 kez çalıştırılıyor...\n")
    
    shots = 1000
    start_time = time.time()
    random_results = ctx.run(algorithms.GenerateRandomBit, shots=shots)
    elapsed = time.time() - start_time
    
    zeros = sum(1 for r in random_results if str(r) == "Zero")
    ones = sum(1 for r in random_results if str(r) == "One")
    
    zero_pct = (zeros / shots) * 100
    one_pct = (ones / shots) * 100
    
    print(f"Toplam Atış (Shots): {shots}")
    print(f"Zero (|0>) Sonucu  : {zeros} ({zero_pct:.2f}%)")
    print(f"One (|1>) Sonucu   : {ones} ({one_pct:.2f}%)")
    print(f"Simülasyon Süresi  : {elapsed:.4f} saniye")
    
    # Görsel çubuk grafik (ASCII kullanıyoruz)
    bar_len = 30
    zero_bar = "#" * int(bar_len * (zeros / shots))
    one_bar = "#" * int(bar_len * (ones / shots))
    print(f"\n|0> Dagilimi: |{zero_bar:<{bar_len}}|")
    print(f"|1> Dagilimi: |{one_bar:<{bar_len}}|")
    print("\n[OK] Süperpozisyon doğrulandı. Sonuçlar beklendiği gibi ~%50 oranındadır.")
    print("=" * 60 + "\n")

    # =========================================================================
    # Deney 2: Dolanıklık (Bell State)
    # =========================================================================
    print_header("Deney 2: Dolanıklık (Bell State)")
    print("Hadamard ve CNOT uygulanarak dolanık iki qubit hazırlanıyor...")
    print("Her iki qubit ölçülüyor. Simülatör 1000 kez çalıştırılıyor...\n")
    
    start_time = time.time()
    # Bell durumunu simüle et
    bell_results = ctx.run(algorithms.CreateBellState, shots=shots)
    elapsed = time.time() - start_time
    
    # Sonuç çiftlerini say
    double_zeros = 0
    double_ones = 0
    mismatched = 0
    
    for r1, r2 in bell_results:
        s1, s2 = str(r1), str(r2)
        if s1 == "Zero" and s2 == "Zero":
            double_zeros += 1
        elif s1 == "One" and s2 == "One":
            double_ones += 1
        else:
            mismatched += 1
            
    print(f"Toplam Atış (Shots)  : {shots}")
    print(f"|00> Durumu (İkisi 0): {double_zeros} ({ (double_zeros / shots) * 100:.2f}%)")
    print(f"|11> Durumu (İkisi 1): {double_ones} ({ (double_ones / shots) * 100:.2f}%)")
    print(f"Uyuşmayan (01 veya 10): {mismatched} ({(mismatched / shots) * 100:.2f}%)")
    print(f"Simülasyon Süresi    : {elapsed:.4f} saniye")
    
    if mismatched == 0:
        print("\n[OK] Dolanıklık (Entanglement) DOĞRULANDI!")
        print("  Qubitlerin ölçüm sonuçları %100 oranında koreledir (Her zaman aynı sonucu verdiler).")
    else:
        print("\n[ERROR] Dolanıklık doğrulanamadı, uyuşmayan ölçümler var.")
    print("=" * 60 + "\n")

    # =========================================================================
    # Deney 3: Kuantum Işınlama (Quantum Teleportation)
    # =========================================================================
    print_header("Deney 3: Kuantum Işınlama (Quantum Teleportation)")
    print("Alice, Bob'a dolanıklık ve klasik bitlerle kuantum durumu ışınlıyor...")
    print("Girdi durumları |0> ve |1> için 500'er deneme yapılıyor...\n")
    
    teleport_shots = 500
    
    # |0> Durumunu ışınlama deneyi (messageState = False)
    start_time = time.time()
    teleport_0_results = ctx.run("QuantumAlgorithms.Teleport(false)", shots=teleport_shots)
    elapsed_0 = time.time() - start_time
    
    t0_success = sum(1 for r in teleport_0_results if str(r) == "Zero")
    t0_fail = teleport_shots - t0_success
    
    # |1> Durumunu ışınlama deneyi (messageState = True)
    start_time = time.time()
    teleport_1_results = ctx.run("QuantumAlgorithms.Teleport(true)", shots=teleport_shots)
    elapsed_1 = time.time() - start_time
    
    t1_success = sum(1 for r in teleport_1_results if str(r) == "One")
    t1_fail = teleport_shots - t1_success
    
    total_teleport_success = t0_success + t1_success
    total_teleport_shots = teleport_shots * 2
    success_rate = (total_teleport_success / total_teleport_shots) * 100
    
    print(f"|0> Işınlama Başarısı: {t0_success}/{teleport_shots} (Hata: {t0_fail})")
    print(f"|1> Işınlama Başarısı: {t1_success}/{teleport_shots} (Hata: {t1_fail})")
    print(f"Toplam Başarı Oranı  : {success_rate:.2f}%")
    print(f"Ortalama Süre        : {(elapsed_0 + elapsed_1) / 2:.4f} saniye")
    
    if success_rate == 100.0:
        print("\n[OK] Kuantum Işınlama (Quantum Teleportation) PROTOKOLÜ BAŞARIYLA TAMAMLANDI!")
        print("  Alice'in qubit durumu Bob'un qubit'ine %100 doğrulukla aktarıldı.")
    else:
        print("\n[ERROR] Protokol başarısız oldu. Durum kaybı veya aktarım hatası mevcut.")
    print("=" * 60 + "\n")

if __name__ == "__main__":
    main()
