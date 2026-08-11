# Grover's Search Algorithm: 2-Qubit Database Search

This project implements Grover's quantum search algorithm for a 4-element (2-qubit) unstructured database using Q# and the Microsoft Quantum Development Kit (QDK). 

---

## 1. Project Specifications & Qubit Allocation

*   **Total Qubits:** **2 qubits** (representing a search space of $N = 2^2 = 4$ elements).
*   **Search Space States:** $|00\rangle, |01\rangle, |10\rangle, |11\rangle$.
*   **Target State:** $|11\rangle$ (both qubits in the state of `One`).
*   **Grover Iterations ($R$):** **1 iteration**. For $N=4$, $\frac{\pi}{4}\sqrt{N} \approx 1.57$ which rounds to 1. A single iteration yields a $100\%$ probability of measuring the target state.

---

## 2. Q# Operations List

The project defines the following operations in the `GroverSearch` namespace:

### `operation MarkTarget(register : Qubit[]) : Unit`
*   **Role:** The **Quantum Oracle**.
*   **Input:** An array of qubits (`register`) containing the search space.
*   **Description:** Marks the target state $|11\rangle$ by applying a phase shift of $-1$ to its amplitude (reflecting the target state about the origin). It leaves all other database states unchanged.
*   **Implementation Details:** Utilizes the Controlled-Z (`Controlled Z`) gate where the first qubit acts as control and the second acts as target.

### `operation Diffuse(register : Qubit[]) : Unit`
*   **Role:** The **Diffusion Operator** (Grover's Inversion about the Mean).
*   **Input:** An array of qubits (`register`).
*   **Description:** Amplifies the amplitude of the marked target state while reducing the amplitudes of non-target states.
*   **Implementation Details:** Transforms the state to the computational basis using Hadamard ($H$) and Pauli-X ($X$) gates, applies a controlled phase-flip, and reverses the transformations.

### `operation RunGroverSearch() : Result[]`
*   **Role:** **Main Entry Point**.
*   **Output:** An array of classical measurements (`Result[]`).
*   **Description:** Allocates 2 qubits, initializes them into a uniform superposition, executes the Grover loop (Oracle and Diffusion), measures the qubits, resets them, and returns the result.

---

## 3. Algorithm Flowchart

```mermaid
graph TD
    A([Start]) --> B[Allocate 2 Qubits in state |00>]
    B --> C[Apply H gate to all qubits]
    C --> D["Initial Superposition: 1/2(|00> + |01> + |10> + |11>)"]
    D --> E["Apply Oracle: MarkTarget()"]
    E --> F["State marked: 1/2(|00> + |01> + |10> - |11>)"]
    F --> G["Apply Diffusion: Diffuse()"]
    G --> H["State amplified: 0|00> + 0|01> + 0|10> + 1|11>"]
    H --> I[Measure qubits]
    I --> J[Reset qubits to |00>]
    J --> K([Return results: [One, One]])
```

---

## 4. Step-by-Step Execution Sequence

1.  **State Initialization:**
    Both qubits start in the $|00\rangle$ state.
2.  **Superposition:**
    Applying $H \otimes H$ spreads the probability amplitude equally:
    $$\alpha_{00} = \alpha_{01} = \alpha_{10} = \alpha_{11} = +0.5$$
3.  **Phase Inversion (Oracle):**
    The Oracle flips the target amplitude sign:
    $$\alpha_{11} \to -0.5$$
4.  **Inversion about the Mean (Diffusion):**
    -   The mean amplitude ($\mu$) is calculated: $\mu = \frac{0.5 + 0.5 + 0.5 - 0.5}{4} = 0.25$.
    -   Each amplitude $a_i$ is reflected about the mean: $a'_i = 2\mu - a_i$.
    -   Non-target amplitudes: $2(0.25) - 0.5 = 0$.
    -   Target amplitude: $2(0.25) - (-0.5) = 1.0$.
5.  **Measurement:**
    The final state collapse yields $|11\rangle$ (represented as `[One, One]`) with $100\%$ certainty.
