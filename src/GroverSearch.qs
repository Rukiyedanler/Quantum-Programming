namespace GroverSearch {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;

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
}
