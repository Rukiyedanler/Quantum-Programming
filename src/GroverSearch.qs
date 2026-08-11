namespace GroverSearch {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Diagnostics;

    /// # Açıklama
    /// Grover Oracle (Kâhin) - Özel durum |11⟩ için.
    /// Her iki qubit de |1⟩ durumunda olduğunda faza -1 ekler.
    /// 
    /// Matematiksel Etkisi:
    /// |00⟩ ->  |00⟩
    /// |01⟩ ->  |01⟩
    /// |10⟩ ->  |10⟩
    /// |11⟩ -> -|11⟩
    operation MarkTarget11(register : Qubit[]) : Unit {
        // Controlled Z kapısı, kontrol qubit'leri (|1⟩ durumundayken) hedef qubit'e Z kapısı uygular.
        // Z kapısı |1⟩ durumundaki qubit'in fazını tersine çevirdiği için faza -1 eklenmiş olur.
        // 2 qubit için ilk qubit kontrol (dizi içinde verilir), ikinci qubit hedeftir.
        Controlled Z([register[0]], register[1]);
    }

    /// # Açıklama
    /// Grover Oracle (Kâhin) - Genel sürüm.
    /// X kapılarını kullanarak 2 qubit'lik herhangi bir hedef durumu (örneğin |10⟩) işaretler.
    /// `targetPattern` parametresi hangi durumun arandığını belirtir (örn: [true, false] = |10⟩).
    operation MarkAnyTarget(register : Qubit[], targetPattern : Bool[]) : Unit {
        // Eğer hedef bit deseni false (yani |0⟩ durumu) ise, kontrollü kapı öncesinde X kapısı uygulayarak
        // o qubit'in durumunu geçici olarak |1⟩ yaparız.
        
        // 1. Durumu hazırlama: |0⟩ olması gereken qubit'lerin durumunu X kapısı ile ters çeviriyoruz
        if not targetPattern[0] {
            X(register[0]);
        }
        if not targetPattern[1] {
            X(register[1]);
        }

        // 2. Çoklu-kontrollü Z kapısı (CZ) uyguluyoruz.
        // Bu kapı sadece register'ın tüm qubit'leri |1⟩ olduğunda (yani hedef durumdayken) faza -1 çarpanı ekler.
        Controlled Z([register[0]], register[1]);

        // 3. Durumu geri yükleme: Uyguladığımız X kapılarını geri alarak qubit'leri orijinal durumuna döndürüyoruz
        if not targetPattern[0] {
            X(register[0]);
        }
        if not targetPattern[1] {
            X(register[1]);
        }
    }

    /// # Açıklama
    /// Grover Difüzyon (Diffusion) operatörü.
    /// Qubit genliklerini kendi ortalamalarına göre tersine çevirerek hedef durumun
    /// genliğini yükseltir (Inversion about the mean).
    operation Diffuse(register : Qubit[]) : Unit {
        // 1. Durumu Z-eksenine (köken durumuna) döndürmek için Hadamard (H) kapılarını uyguluyoruz.
        // Bu işlem durumları süperpozisyondan çıkarıp temel durumlara geri çeker.
        for qubit in register {
            H(qubit);
        }

        // 2. Qubit durumlarını X (NOT) kapısı uygulayarak ters çeviriyoruz (|00> -> |11>).
        // Kontrollü Z kapısı (CZ) sadece tüm qubitler |1> olduğunda tetiklendiği için,
        // |00> durumunun fazını tersine çevirmek amacıyla durumları geçici olarak |11>'e taşıyoruz.
        for qubit in register {
            X(qubit);
        }

        // 3. Çoklu-kontrollü Z kapısı uyguluyoruz.
        // register[0] kontrol qubit'i, register[1] ise hedef qubit'tir.
        // Bu işlem sadece |11> durumuna (yani orijinal |00> durumuna) -1 faz çarpanı ekler.
        Controlled Z([register[0]], register[1]);

        // 4. Durumları geri yüklemek için X kapılarını aynı şekilde tekrar uyguluyoruz (|11> -> |00>).
        for qubit in register {
            X(qubit);
        }

        // 5. Yeniden süperpozisyon bazına geçiş yapmak için Hadamard (H) kapılarını tekrar uyguluyoruz.
        for qubit in register {
            H(qubit);
        }
    }

    /// # Açıklama
    /// Grover Arama Algoritmasının Ana Giriş Noktası (EntryPoint).
    /// 2 qubit tahsis eder, süperpozisyon hazırlar, Oracle ve Diffusion adımlarını
    /// 1 döngü çalıştırır, qubitleri ölçer ve sıfırlar.
    @EntryPoint()
    operation RunGroverSearch() : Result[] {
        // 1. 2 adet qubit tahsis ediyoruz
        use register = Qubit[2];

        // 2. Qubitleri süperpozisyona sokuyoruz (|00> -> 1/2(|00> + |01> + |10> + |11>))
        for qubit in register {
            H(qubit);
        }

        // 3. Grover adımlarını 1 döngü (iteration) çalıştırıyoruz (N=4 için 1 tekrar yeterlidir)
        MarkTarget11(register);
        Diffuse(register);

        // 4. Qubitleri ölçüyoruz ve hafıza sızıntısını önlemek için sıfırlıyoruz (MResetZ)
        mutable results = [];
        for qubit in register {
            let r = MResetZ(qubit);
            set results = results + [r];
        }

        // 5. Sonuç dizisini döndürüyoruz (Beklenen sonuç: [One, One])
        return results;
    }

    /// # Açıklama
    /// Grover aramasını belirtilen sayıda (shots) çalıştırıp,
    /// hedefin (|11> durumu yani [One, One]) kaç kez doğru bulunduğunu sayar.
    /// Başarı sayısını döndürür.
    operation RunGroverAccuracyTest(shots : Int) : Int {
        mutable successCount = 0;
        
        for idx in 1..shots {
            let res = RunGroverSearch();
            // Eğer iki qubit de One ise (hedef durum |11>) başarıyı artırırız
            if res[0] == One and res[1] == One {
                set successCount = successCount + 1;
            }
        }
        
        return successCount;
    }

    /// # Açıklama
    /// Oracle'ın (MarkTarget11) temel durumları değiştirmeden sadece fazı
    /// etkilediğini doğrulayan bir birim testidir.
    /// Fact ve ölçüm kullanarak durumların bozulmadığını test eder.
    operation TestOraclePhaseOnly() : Unit {
        // 1. Durum: |00> girdisi için test
        use r0 = Qubit[2];
        // |00> durumundayken Oracle uygula
        MarkTarget11(r0);
        // Ölçüm yapıyoruz ve qubitleri temizliyoruz (MResetZ)
        let m0_0 = MResetZ(r0[0]);
        let m0_1 = MResetZ(r0[1]);
        // Ölçüm sonuçlarının hala Zero olduğunu klasik Fact ile doğruluyoruz
        Fact(m0_0 == Zero, "HATA: |00> durumunda Qubit 0 bozuldu!");
        Fact(m0_1 == Zero, "HATA: |00> durumunda Qubit 1 bozuldu!");

        // 2. Durum: |11> (Hedef) girdisi için test
        use r1 = Qubit[2];
        X(r1[0]);
        X(r1[1]); // |11> durumuna getir
        // Oracle uygula
        MarkTarget11(r1);
        // Ölçüm yapıyoruz ve temizliyoruz (MResetZ)
        let m1_0 = MResetZ(r1[0]);
        let m1_1 = MResetZ(r1[1]);
        // Ölçüm sonuçlarının hala One olduğunu klasik Fact ile doğruluyoruz
        Fact(m1_0 == One, "HATA: |11> durumunda Qubit 0 bozuldu!");
        Fact(m1_1 == One, "HATA: |11> durumunda Qubit 1 bozuldu!");
        
        Message("[TEST-OK] TestOraclePhaseOnly: Oracle birim testi basariyla gecti. Durumlar bozulmadi!");
    }
}
