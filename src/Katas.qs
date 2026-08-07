namespace QuantumKatas {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;

    /// # Görev 1: Durum ve Faz Çevirme (State & Phase Flipping)
    /// Giriş olarak bir qubit `q` ve iki Boolean parametre `flipState` ve `flipPhase` alır.
    /// - Eğer `flipState` true ise, qubit'in durumunu tersine çevirin (|0⟩ ↔ |1⟩).
    /// - Eğer `flipPhase` true ise, qubit'in fazını tersine çevirin (durumun işaretini değiştirin: |+⟩ ↔ |-⟩).
    /// 
    /// İpuçları:
    /// - Qubit durumunu (genlikleri) çevirmek için hangi kuantum kapısı kullanılır? (Klasik NOT kapısı karşılığı)
    /// - Qubit fazını çevirmek için hangi kuantum kapısı kullanılır? (Phase-flip kapısı)
    operation FlipQubitState(q : Qubit, flipState : Bool, flipPhase : Bool) : Unit {
        // TODO: Buraya kodunuzu yazın
        // ...
    }

    /// # Görev 2: Dolanıklık Doğrulaması (Bell State Verification)
    /// Giriş olarak dolanık olduğu iddia edilen iki qubit (`q1` ve `q2`) alır.
    /// Bu qubit'lerin |Φ⁺⟩ = (|00⟩ + |11⟩)/√2 Bell durumunda olup olmadığını test etmeniz gerekmektedir.
    /// Göreviniz: İki qubit'i de ölçün (M veya MResetZ ile). 
    /// Eğer ölçüm sonuçları birbiriyle eşleşiyorsa (ikisi de Zero veya ikisi de One) `true`,
    /// uyuşmuyorsa (biri Zero, diğeri One) `false` döndürün.
    /// 
    /// İpuçları:
    /// - Q# dilinde ölçüm sonuçları `Result` tipindedir ve `Zero` ya da `One` değerlerini alabilir.
    /// - Klasik karşılaştırma operatörlerini (`==`, `and`, `or`) kullanabilirsiniz.
    operation VerifyBellState(q1 : Qubit, q2 : Qubit) : Bool {
        // TODO: Buraya kodunuzu yazın
        // ...
        return false;
    }
}
