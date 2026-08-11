import time
from qdk import Context

def main():
    print("=== KUANTUM BIRIM TESTLERI VE DOGRULAMA SUIITI ===\n")
    try:
        ctx = Context(project_root=".")
        print("[OK] Q# Projesi yuklendi.\n")
    except Exception as e:
        print("[ERROR] Q# Projesi yuklenemedi:", e)
        return

    # 1. Birim Testi: Oracle Sadece Faz Degistiriyor mu?
    print("--- 1. Birim Testi: TestOraclePhaseOnly ---")
    try:
        ctx.run("GroverSearch.TestOraclePhaseOnly()", 1)
        print("[OK] Birim testi basariyla tamamlandi. Oracle durum genliklerinin buyuklugunu bozmadan sadece fazi (isareti) degistirdi!\n")
    except Exception as e:
        print("[FAIL] Oracle birim testi basarisiz oldu:", e)
        return

    # 2. Dogruluk Testi: 1000 Iterasyon Arama
    shots = 1000
    print(f"--- 2. Dogruluk Testi: RunGroverAccuracyTest ({shots} deneme) ---")
    try:
        start_time = time.time()
        # RunGroverAccuracyTest Q# icindeki for dongusuyle 1000 deneme yapar ve basarili sayisini doner
        raw_results = ctx.run(f"GroverSearch.RunGroverAccuracyTest({shots})", 1)
        elapsed = time.time() - start_time
        
        success_count = raw_results[0]
        success_pct = (success_count / shots) * 100
        
        print(f"Toplam Deneme   : {shots}")
        print(f"Basarili Arama  : {success_count} (Olasilik: {success_pct:.2f}%)")
        print(f"Gecen Sure      : {elapsed:.4f} saniye")
        
        if success_count == shots:
            print("\n[OK] Dogruluk testi basariyla tamamlandi. Grover algoritmasi 4 elemanli uzayda 1 iterasyonda %100 basari saglar.")
        else:
            print(f"\n[WARNING] Beklenen %100 basariya ulasilamadi. Basari: {success_count}/{shots}")
            
    except Exception as e:
        print("[ERROR] Dogruluk testi sirasinda hata olustu:", e)

if __name__ == "__main__":
    main()
