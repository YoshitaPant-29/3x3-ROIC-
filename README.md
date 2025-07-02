# 3x3-Read out integrated cicuit using buffered logic
# 🔧 3×3 ROIC Digital Controller (Verilog RTL)

This project implements a **digital scan controller** for a 3×3 Read-Out Integrated Circuit (ROIC), written in Verilog. It simulates how an infrared image sensor sequentially accesses pixel data through FSM-controlled row and column selection logic.

---

## 🚀 Key Features

- **Finite State Machine (FSM)** based architecture
- **Integration window (`intg`) = exactly 10 clock cycles**
- **3 rows scanned sequentially**
- **3 columns per row**, with precise delays:
  - `col[0]`: HIGH for 1 clk
  - `col[1]`: HIGH after 6 clk
  - `col[2]`: HIGH after 6 more clk
- `fsync`: 1 clock HIGH at the start of each frame
- Frame repeats after a short delay

This kind of logic is used in:
- Infrared sensor scanning systems
- CMOS or IR-based imaging devices
- Embedded control systems for sensor readouts

---

## 🤝 Author-Yoshita Pant


