namespace GroverSearch {
    open Microsoft.Quantum.Intrinsic;

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
}
