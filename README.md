# CDP1802 8-bit Computer — Design and Construction

Design, construction and testing of an 8-bit microcomputer built around the **RCA CDP1802**, the first CMOS microprocessor (also known for flying in the Galileo probe and the Hubble Space Telescope).

Final engineering project for *Proyecto y Diseño Electrónico* (ET546), Electronic Engineering, **Universidad Nacional de Misiones**, Argentina (November 2022).

📄 **[Read the full report (PDF, Spanish)](informe/ProyectoFinal.pdf)**: 166 pages covering theory, schematics, PCBs, assembly code and test results.  
🖼️ **[Project poster](Poster_PyD_2022_Grupo_A.pdf)**

<p align="center">
  <img src="informe/Codigo%20fuente/imagenes/foto_sistema_med.jpg" width="48%" alt="Medium system, assembled">
  <img src="informe/Codigo%20fuente/imagenes/sistema_final_3D.png" width="48%" alt="Final system, 3D render of the PCB">
</p>

---

## Overview

The project was developed in three stages of increasing complexity. Each stage was designed in KiCad, simulated, and (for the first two) built and tested on hardware.

| Stage | Status | Highlights |
|---|---|---|
| **Minimal system** | ✅ Built and tested | CDP1802 + 8K EEPROM, 8-bit addressing, jumper-selectable program banks, single-sided PCB |
| **Medium system** | ✅ Built and tested | 16-bit addressing (64 KB), 32K EEPROM + 32K RAM, USB-UART link, runs Tiny BASIC and a diskless Elf/OS |
| **Final system** | 📐 Designed (schematics + PCB) | Power supply, bank-switched memory, I²C and SPI serial memories, 12-bit ADC, parallel I/O |

### 1. Minimal system
- CDP1802 with an AT28C64 EEPROM using only the 8 low address lines (256-byte programs).
- A8/A9 set by jumpers, allowing four independent programs in the same EEPROM without reprogramming.
- Four assembly programs written and verified on hardware: LED blink, push-button input, conditional blink, and a **bit-banged UART transmitter at 600 baud** using the Q output, with the delay loop derived analytically from the instruction cycle timing.
- Subroutines use the CDP1802 *SEP technique*, which requires no RAM (the system has none).

### 2. Medium system
- 74HC373 address latch to demultiplex the CDP1802's time-shared address bus to a full **16-bit / 64 KB** space.
- Memory map: 32K EEPROM (program) + 32K DS1744 timekeeping RAM (data).
- FT232RL USB-UART module for communication with a PC terminal (Tera Term).
- Ported and ran third-party software on real hardware:
  - **Tiny BASIC interpreter**: modified the source (register definitions, idle line polarity, autorun) and reassembled it.
  - **Diskless Elf/OS** operating system.

### 3. Final system (design)
Fully backwards compatible with the previous stages. Designed as a modular set of schematics and a double-sided 30 × 30 cm PCB:
- **Linear power supply** with line filter and ±12 V / 5 V regulation.
- **Bank-switched memory map**: boot mode (EEPROM + RAM) and run mode (program copied to RAM, a second RAM swapped in to maximise working memory).
- **Hardware SPI engine** built from discrete logic (MC14014 + 74HC595 shift registers, 74HC161/74HC74/74HC73 clock generator producing exactly 8 pulses at 2 MHz), which offloads the serial shifting from the CPU. Intended for a **microSD** card.
- **I²C serial memories**: 24LC1025 EEPROM and MB85RC64A **FRAM**, driven in software through the parallel port.
- **12-bit ADC** (MAX127) with OPA4277 signal conditioning for **4–20 mA** industrial current loops.
- **82C55 parallel I/O** mapped into the CDP1802's dedicated I/O space (INP/OUT instructions).

The report also outlines future work, including I/O drivers, SD-card support, a PLC-oriented use case and guidelines for a real-time operating system.

---

## Tools

| Area | Tools |
|---|---|
| Schematics and PCB | KiCad |
| Assembly and simulation | A18 cross-assembler, Emma02 emulator (debugging and instruction tracing) |
| Programming hardware | XGecu TL866 universal programmer; an Arduino-based EEPROM programmer was also built |
| Communication | FT232RL, Tera Term |
| Documentation | LaTeX (memoir, biblatex/biber), Git, VS Code |

---

## Repository structure

```
Poster_PyD_2022_Grupo_A.pdf   Project poster
informe/
  ProyectoFinal.pdf           Compiled report (Spanish)
  Codigo fuente/              LaTeX source (chapters, appendices, bibliography, figures)
archivos_de_kicad/            KiCad projects: schematics, PCBs, BOMs and exports
  1_Sistema_minimo/
  2_Sistema_medio/
  3_Sistema_final/            Full system plus separate sub-projects (ADC conditioning, SPI)
programas/                    CDP1802 assembly programs (.asm), assembled output (.hex, .lst) and build scripts
decodificador SPI/            Proteus simulations of the hardware SPI circuit
```

The KiCad projects were made with KiCad 6 (the minimal system also includes the original KiCad 5 files).  
Programs are assembled with the [A18 cross-assembler](https://www.retrotechnology.com/memship/a18.html); each folder includes a `.bat` script that assembles the `.asm` file with the same name.

### Building the report
Requires a LaTeX distribution (MiKTeX or TeX Live) with `biber`.

```bash
cd "informe/Codigo fuente"
pdflatex proyecto
biber proyecto
pdflatex proyecto
pdflatex proyecto
```

---

## Third-party software

The `programas/` folder also contains third-party code that was studied, modified or run on the hardware. It is included for reference, and credit goes to its original authors:
- **Tiny BASIC** for the 1802, from the [Membership Card](http://www.sunrise-ev.com/1802.htm) project (the `original/` folder is unmodified; `modificado/` contains our changes).
- **FIG-Forth** for the 1802, from Lee Hart's Membership Card resources.

---

## Authors

- **Felipe Santiago Alegre Chamorro**
- Atilio Boher
- Uriel Adrián Vera

Supervisor: Ing. Ricardo A. Korpys, Facultad de Ingeniería, UNaM.
