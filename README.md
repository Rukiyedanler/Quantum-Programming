# 2-Qubit Grover's Search Algorithm: Quantum Database Exploration

Welcome to the **Quantum Database Exploration** project! This repository contains a complete, verified implementation of Grover's Search Algorithm for a 4-element (2-qubit) unstructured search space, written in **Q#** and simulated using the modern **Microsoft Quantum Development Kit (QDK)**.

This project serves as a practical learning suite designed to bridge the gap between classical computer science algorithms and quantum computation mechanics.

---

## 1. Project Overview

### What Have We Developed?
We implemented a **2-qubit Grover's Search Algorithm** capable of finding a specific target item ($|11\rangle$) in an unsorted 4-element database in exactly **one query**. 

### Why is this Interesting?
In classical computing, finding a marked item in an unsorted database of size $N$ requires scanning elements sequentially (Linear Search), taking $\mathcal{O}(N)$ queries in the worst case (and $N/2$ on average). For $N=4$, it takes up to 4 checks.

Grover's Algorithm utilizes quantum superposition and amplitude interference to solve this in **$\mathcal{O}(\sqrt{N})$** queries. For $N=4$, $\sqrt{4} = 2$. However, due to the mathematics of quantum rotation, $N=4$ is a unique case where we achieve **100% success in exactly 1 iteration**. This showcases a dramatic speedup over classical algorithms!

---

## 2. Learning Achievements

Through this project, we explored and implemented key quantum mechanics and Q# paradigms:
*   **Superposition:** Using Hadamard ($H$) gates to evaluate all database elements simultaneously.
*   **Phase Inversion & Interference:** Using the Oracle to mark the target state by shifting its phase, and using the Diffusion operator to construct constructive interference (amplifying target probability) and destructive interference (nullifying non-target probabilities).
*   **Q# Programming Patterns:** Defining quantum operations, using loops, utilizing mutable variables (`mutable`, `set`), and managing quantum memory correctly using `MResetZ` (equivalent to garbage collection/resetting dirty qubits).
*   **Diagnostics & Assertions:** Writing Q# unit tests with the `Fact` function from `Microsoft.Quantum.Diagnostics` to verify that operations preserve state norms.

---

## 3. Methodology & Quantum Circuits

The search process is split into three main logical components:

```mermaid
graph TD
    A[|00> Initial State] --> B[Apply H Gates]
    B --> C["Uniform Superposition (25% each)"]
    C --> D["Apply Oracle (Flip target phase to -0.5)"]
    D --> E["Apply Diffusion (Invert about the mean)"]
    E --> F["Target Amplified to 100%"]
    F --> G[Measure & Reset Qubits]
```

### A. Initialization (Superposition)
We bring the qubits from the ground state $|00\rangle$ into a uniform superposition where each state has a $25\%$ probability.
```qsharp
// Uniform superposition preparation
for qubit in register {
    H(qubit);
}
```

### B. The Oracle (Marking the Target)
The Oracle marks the target state $|11\rangle$ by flipping its phase sign from positive to negative ($+0.5 \to -0.5$).
```qsharp
operation MarkTarget11(register : Qubit[]) : Unit {
    // Controlled Z gate applies a -1 phase shift only when all qubits are |1>
    Controlled Z([register[0]], register[1]);
}
```

### C. The Diffusion Operator (Amplitude Amplification)
The Diffusion operator reflects all amplitudes about the average (mean) amplitude. This boosts the negative target amplitude while cancelling out the non-target amplitudes.
```qsharp
operation Diffuse(register : Qubit[]) : Unit {
    // 1. Return to the Z-basis
    for qubit in register { H(qubit); }
    // 2. Temporarily shift |00> to |11>
    for qubit in register { X(qubit); }
    // 3. Perform phase flip on the state
    Controlled Z([register[0]], register[1]);
    // 4. Revert X shifts
    for qubit in register { X(qubit); }
    // 5. Return to superposition
    for qubit in register { H(qubit); }
}
```

---

## 4. Testing & Results

We conducted rigorous simulations on the QDK local state simulator.

### Simulation Output Statistics
Running the main Grover search algorithm 1000 times yielded the following results:

| State | Theoretical Probability | Experimental Count | Experimental Probability | Status |
| :--- | :---: | :---: | :---: | :---: |
| $|00\rangle$ | $0\%$ | 0 | $0.00\%$ | Correct |
| $|01\rangle$ | $0\%$ | 0 | $0.00\%$ | Correct |
| $|10\rangle$ | $0\%$ | 0 | $0.00\%$ | Correct |
| $|11\rangle$ (Target) | $100\%$ | 1000 | $100.00\%$ | Verified |

### Over-Rotation Experiment
We tested the effect of running **2 iterations** of Grover's search instead of 1.
*   **Result:** The success rate dropped from **100% to 25%**.
*   **Analysis:** This demonstrates the *Over-rotation* phenomenon. Geometrically, the state vector rotates past the target eksen at $90^\circ$ and moves back to $150^\circ$, which maps to a $25\%$ overlap (returning the system to the initial random state).

---

## 5. Challenges & Solutions

> [!NOTE]
> Debugging quantum algorithms presents unique challenges since we cannot directly observe qubits without collapsing their superposition.

*   **Challenge 1: OutputFail during DumpMachine()**
    *   *Symptom:* Calling `DumpMachine()` within Q# when executing from Python scripts crashed the simulator on Windows terminals due to console stream redirection limits.
    *   *Solution:* We replaced raw state dumps with classical `Fact` assertions inside Q# unit tests (`TestOraclePhaseOnly`), verifying state properties using non-destructive tests and classical measurement comparisons.
*   **Challenge 2: Windows CP1254 Console Crashes**
    *   *Symptom:* Beautiful Unicode symbols (such as ✓ and ✗) crashed the console during Python script executions due to default terminal code page settings on Windows.
    *   *Solution:* We refactored all python runner output strings to use clean, compatible ASCII banners and progress bars (`[OK]`, `[ERROR]`, `#` meters), ensuring seamless terminal execution on all operating systems.
*   **Challenge 3: Dirty Qubit Releases (Memory Leaks)**
    *   *Symptom:* Q# compilation warnings/errors occurred when releasing qubits that were not in the $|0\rangle$ state at the end of the operation scope.
    *   *Solution:* We integrated the `MResetZ` operation, which measures and resets the qubit in a single operation, guaranteeing clean deallocation.

---

## 6. Next Steps

1.  **Cloud Deployment:** Run the Q# code on actual physical hardware (such as IonQ or Quantinuum trap systems) via **Azure Quantum**.
2.  **Scaling up the Database:** Extend the search space to 3 qubits ($N=8$ elements) or 4 qubits ($N=16$ elements). This will require dynamically calculating the optimal Grover iterations ($R \approx \frac{\pi}{4}\sqrt{N}$) which will no longer be exactly 1.
3.  **Alternative Oracles:** Implement arithmetic oracles (e.g. searching for numbers that satisfy a mathematical formula like $x + 3 = 7$) rather than hardcoded phase markers.
