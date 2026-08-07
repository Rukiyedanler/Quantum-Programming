namespace QuantumAlgorithms {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;

    /// # Açıklama
    /// Hadamard (H) kapısı kullanarak süperpozisyon oluşturur ve ölçüm yapar.
    /// %50 ihtimalle Zero (0) veya One (1) döndürür.
    operation GenerateRandomBit() : Result {
        use q = Qubit();
        H(q);
        return MResetZ(q);
    }

    /// # Açıklama
    /// İki qubit'i Hadamard ve CNOT kapıları kullanarak dolanık (entangled) hale getirir.
    /// Her iki qubit ölçüldüğünde sonuçlar her zaman mükemmel şekilde koreledir (ikisi de 0 veya ikisi de 1).
    operation CreateBellState() : (Result, Result) {
        use (q1, q2) = (Qubit(), Qubit());
        H(q1);
        CNOT(q1, q2);
        let r1 = MResetZ(q1);
        let r2 = MResetZ(q2);
        return (r1, r2);
    }

    /// # Açıklama
    /// Kuantum Işınlama (Quantum Teleportation) protokolü.
    /// Alice, elindeki bir qubit'in kuantum durumunu Bob'a dolanıklık ve klasik bitler aracılığıyla aktarır.
    /// `messageState` parametresi gönderilecek durumu temsil eder (false ise |0>, true ise |1>).
    operation Teleport(messageState : Bool) : Result {
        use (msg, alice, bob) = (Qubit(), Qubit(), Qubit());
        
        // 1. Gönderilecek kuantum durumunu hazırla
        if messageState {
            X(msg); // |1> durumuna getir
        }
        
        // 2. Alice ve Bob arasında dolanık Bell çifti oluştur
        H(alice);
        CNOT(alice, bob);
        
        // 3. Alice kendi qubit'leri (msg ve alice) üzerinde Bell ölçümü hazırlar
        CNOT(msg, alice);
        H(msg);
        
        // 4. Alice ölçüm yapar ve qubit'leri sıfırlar
        let rMsg = MResetZ(msg);
        let rAlice = MResetZ(alice);
        
        // 5. Bob, Alice'in ölçüm sonuçlarına göre kendi qubit'ine düzeltme kapıları uygular
        if rAlice == One {
            X(bob);
        }
        if rMsg == One {
            Z(bob);
        }
        
        // 6. Bob qubit'ini ölçerek durumu doğrular
        return MResetZ(bob);
    }
}
