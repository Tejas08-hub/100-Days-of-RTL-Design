# Day 21 — Physical Design Flow Fundamentals (Written)

## Question of the Day

### Problem Statement

Understand the fundamental **Physical Design (PD) flow** in VLSI, starting from a synthesized gate-level netlist and progressing through floorplanning, placement, Clock Tree Synthesis (CTS), routing, and signoff before tapeout.

The objective is to understand not only what happens at each stage, but also **why each stage is necessary, what decisions are made, and what problems can occur if a stage is poorly implemented**.

---

## 1. Full Physical Design Flow

After synthesis, the RTL is converted into a **gate-level netlist** containing standard cells, macros, flip-flops, and their logical connections.

However, the synthesized netlist does not contain the complete physical information required for fabrication. Physical Design converts this logical representation into a physical layout.

The basic flow is:

```text
Synthesis
    ↓
Gate-Level Netlist
    ↓
Floorplanning
    ↓
Placement
    ↓
Clock Tree Synthesis (CTS)
    ↓
Routing
    ↓
Signoff
    ↓
Tapeout
```

### Floorplanning

Floorplanning defines the overall physical organization of the chip.

Major decisions include:

- Die area
- Core area
- Macro locations
- I/O locations
- Power planning
- Placement regions
- Routing resources
- Macro halos and blockages

A poor floorplan can create long interconnects, timing problems, congestion, power-delivery issues, and increased implementation difficulty.

### Placement

Placement determines the physical locations of individual standard cells within the floorplan.

The placement tool tries to optimize:

- Timing
- Congestion
- Power
- Cell density
- Routability

A poor placement can create high congestion, long critical paths, excessive wire delay, and timing violations.

### Clock Tree Synthesis (CTS)

CTS builds the clock distribution network that connects the clock source to the sequential elements such as flip-flops.

The main objectives of CTS are:

- Reduce/control clock skew
- Control clock latency
- Maintain acceptable clock transition/slew
- Balance the clock distribution

A poor clock tree can cause excessive skew, setup/hold timing problems, clock transition violations, and increased clock power.

### Routing

Routing creates the actual physical connections between cells, macros, and I/O using metal layers and vias.

Routing must satisfy:

- Connectivity
- Routing congestion
- Timing requirements
- Signal integrity
- Manufacturing design rules

Poor routing can result in routing failures, longer wire paths, timing degradation, crosstalk, and DRC violations.

### Signoff

Signoff is the final verification stage before tapeout.

Important signoff checks include:

- Static Timing Analysis (STA)
- Design Rule Check (DRC)
- Layout Versus Schematic (LVS)
- IR Drop
- Electromigration (EM)
- Signal integrity
- Power analysis

The purpose is to ensure that the design is:

- Functionally correct
- Timing clean
- Physically valid
- Electrically reliable
- Manufacturable

After the required signoff checks pass, the design can proceed to tapeout.

---

## 2. Why is Floorplanning So Important?

Floorplanning is one of the most consequential stages in Physical Design because it establishes the physical framework for the rest of the implementation.

During floorplanning, decisions are made about:

- Die and core dimensions
- Macro locations
- I/O locations
- Power distribution
- Available routing space
- Placement regions

These decisions strongly influence timing, power, congestion, and overall implementation difficulty.

**Effect on Timing**

If two blocks communicate frequently but are placed far apart:

```text
Block A ───────────────────── Block B
```

the interconnect becomes longer.

Longer interconnect generally results in higher parasitic resistance and capacitance, increasing wire delay.

Therefore:

```text
Poor Floorplan
      ↓
Long Interconnect
      ↓
Higher Delay
      ↓
Timing Violations
```

**Effect on Congestion**

If too many cells or macros are concentrated in one region:

```text
High Cell Density
       ↓
Less Routing Space
       ↓
Routing Congestion
       ↓
Routing Difficulty
```

**Effect on Power**

Longer interconnects generally introduce more capacitance. Switching these larger capacitances can increase dynamic power.

Poor power planning can also increase voltage drop and reliability problems.

**Effect on Overall Chip Cost**

A poor floorplan can lead to:

- Larger die area
- More routing resources
- More optimization iterations
- Higher power
- Timing closure difficulties
- Increased implementation effort

Therefore, a good floorplan reduces problems that would otherwise become much harder to fix in later stages.

---

## 3. Congestion

### Definition

Routing congestion occurs when the routing demand in a region approaches or exceeds the available routing capacity.

Conceptually:

```text
Routing Demand > Routing Capacity
             ↓
         Congestion
```

### Causes of Congestion

Congestion can be caused by:

- High cell density
- Poor macro placement
- Too many nets crossing a region
- Large fanout
- Long interconnects
- Insufficient routing resources
- Poor floorplanning
- Wide combinational structures with many interconnections

For example:

```text
        Many Nets
           ↓
   ┌───────────────┐
   │ █████████████ │
   │ █████████████ │
   │ █████████████ │
   └───────────────┘
           ↓
     High Congestion
```

### Problems Caused by Congestion

High congestion can result in:

- Routing failures
- Routing detours
- Longer wire lengths
- Increased parasitic delay
- Setup timing violations
- Increased power
- DRC violations
- Difficult timing closure

Therefore, congestion must be considered during both floorplanning and placement.

---

## 4. DRC vs LVS

DRC and LVS are both important physical verification checks, but they verify different aspects of the design.

### DRC — Design Rule Check

DRC verifies whether the physical layout follows the manufacturing rules defined by the semiconductor foundry.

Examples include:

- Minimum metal width
- Minimum metal spacing
- Via dimensions
- Layer-specific rules
- Enclosure requirements
- Other manufacturing constraints

For example, if two metal wires are placed too close together:

```text
Metal A  ═══════

Metal B  ═══════
          ↑
      Too little spacing
```

The layout violates the foundry's design rules.

Therefore:

```text
DRC → FAIL
```

**Easy way to remember:**
DRC asks: *"Can this physical layout be manufactured according to the foundry rules?"*

### LVS — Layout Versus Schematic

LVS checks whether the electrical connectivity extracted from the physical layout matches the intended schematic or reference netlist.

For example, if the intended circuit is:

```text
A ── AND ── B → Y
```

but the physical layout accidentally connects:

```text
A ── AND ── C → Y
```

the physical layout may still obey all manufacturing rules.

Therefore:

```text
DRC → PASS
LVS → FAIL
```

**Easy way to remember:**
LVS asks: *"Does the physical layout represent the intended circuit?"*

---

## 5. Macro Placement and Sensitive Analog Blocks

Sensitive analog blocks such as:

- PLL
- ADC
- DAC

can be affected by noise generated by high-frequency digital blocks.

High-speed digital circuits generate switching activity that can introduce:

- Supply noise
- Ground noise
- Substrate coupling
- Electromagnetic coupling
- Crosstalk

Therefore, sensitive analog blocks are often physically separated from noisy digital regions and I/O activity.

Conceptually:

```text
High-Speed Digital
       ↓
   Switching Noise
       ↓
 Physical Coupling
       ↓
Sensitive Analog Block
       ↓
Performance Degradation
```

For example, noise coupling into a PLL can affect its clock quality and increase jitter.

Therefore, careful floorplanning and physical isolation are important for mixed-signal designs.

---

## 6. Connection to STA and Timing Closure

Static Timing Analysis (STA) determines whether data arrives within the required timing window.

For example:

```text
Launch FF
    ↓
Combinational Logic
    ↓
Capture FF
```

After physical implementation, the actual interconnect introduces:

- Resistance
- Capacitance
- Wire delay
- Crosstalk effects

Therefore, timing can change significantly as the design progresses through placement, CTS, and routing.

### Timing Closure is Iterative

If STA reports a setup violation:

```text
Critical Path
      ↓
Setup Violation
      ↓
Physical Optimization
      ↓
Placement Optimization
      ↓
Cell Sizing / Buffering
      ↓
Routing Optimization
      ↓
STA Again
```

If the problem is caused by a fundamental floorplanning decision, the design may even need to return to the floorplanning stage.

Therefore, timing closure is not a one-time final check.

It is an iterative process involving physical optimization and repeated STA analysis.

**Example**

If two critical blocks are physically far apart:

```text
Block A ───────────────────────── Block B
```

the long interconnect can introduce significant delay.

Moving related logic closer together can reduce interconnect delay and improve setup timing.

However, not every timing violation requires floorplan modification. Other possible solutions include:

- Cell resizing
- Buffer insertion
- Placement optimization
- Routing optimization
- Logic restructuring
- Reducing congestion

---

## Interview Concepts & Quick Revision

### Floorplanning vs Placement

**Floorplanning**
Determines the overall physical organization of the chip, including die/core dimensions, macro locations, I/O locations, power structures, and major physical constraints.

**Placement**
Determines the physical locations of individual standard cells inside the floorplan while optimizing timing, congestion, power, and routability.

**One-Line Interview Answer**
Floorplanning decides where the major blocks and physical regions of the chip should be located, while placement determines where the individual standard cells should be placed within that floorplan.

### Why is Power Planning Done During Floorplanning?

Power planning involves structures such as:

- Power rings
- Power straps
- Power grid
- Decoupling capacitors

These structures need physical space and affect the available routing resources.

Therefore, power planning must be considered early rather than being left until the end of routing.

A weak power grid can cause:

```text
High Current Demand
       ↓
Voltage Drop
       ↓
IR Drop
       ↓
Timing / Functional Problems
```

Power planning also needs to consider electromigration and current-carrying capability of metal interconnects.

### What is a Halo?

A halo is a reserved placement/keep-out region around a macro where standard-cell placement is restricted or prohibited.

Example:

```text
┌─────────────────────────────┐
│          Halo               │
│    ┌──────────────────┐     │
│    │                  │     │
│    │      SRAM        │     │
│    │                  │     │
│    └──────────────────┘     │
│          Halo               │
└─────────────────────────────┘
```

**Why is a Halo Needed?**

A halo provides space around the macro for:

- Routing
- Macro pin access
- Power connections
- Buffer insertion
- Physical optimization

If two macros are placed too close together without sufficient spacing:

```text
Macro A │ │ Macro B
        │ │
        │ │
```

the narrow routing channel between them can become highly congested.

Therefore, halos help maintain sufficient physical space around macros.

---

## What Does a Physical Design Engineer Actually Do?

A Physical Design Engineer is responsible for converting the synthesized logical design into a physically realizable implementation while balancing:

- Timing
- Area
- Power
- Congestion
- Signal Integrity
- Reliability
- Manufacturability

The engineer does not simply run tools. They:

- Prepare design inputs and constraints
- Configure physical implementation parameters
- Analyze reports
- Identify violations
- Optimize the design
- Iterate through different stages
- Verify the final implementation

### Floorplanning Engineer

Focuses on:

- Die/core dimensions
- Macro placement
- I/O planning
- Power planning
- Utilization
- Routing resources
- Halos and blockages

### Placement Engineer

Focuses on:

- Standard-cell placement
- Timing-driven placement
- Congestion
- Cell density
- Critical paths
- Fanout
- Placement optimization

### CTS Engineer

Focuses on:

- Clock skew
- Clock latency
- Clock transition
- Clock fanout
- Clock buffers
- Clock tree topology

### Routing Engineer

Focuses on:

- Metal layers
- Vias
- Global routing
- Detailed routing
- Congestion
- Crosstalk
- Signal integrity
- DRC

### Signoff Engineer

Focuses on:

- STA
- DRC
- LVS
- IR Drop
- Electromigration
- Signal integrity
- Power and reliability analysis

---

## Analog Layout Engineer vs Digital Physical Design Engineer

Analog layout engineers work primarily with custom/transistor-level layouts, while digital PD engineers mainly work with standard-cell-based physical implementation.

### Analog Layout Flow

```text
Analog Schematic
       ↓
Transistor-Level Design
       ↓
Analog Layout
       ↓
DRC
       ↓
LVS
       ↓
Parasitic Extraction (PEX)
       ↓
Post-Layout Simulation
       ↓
Optimization
       ↓
Tapeout
```

Analog layout requires special attention to:

- Device matching
- Common-centroid layout
- Interdigitation
- Dummy devices
- Symmetry
- Guard rings
- Shielding
- Sensitive routing
- Noise isolation

Unlike digital placement, analog layout is highly custom because physical geometry can directly affect circuit performance.

---

## Key Learning

- Learned the complete Physical Design flow from synthesized netlist to tapeout.
- Understood the purpose of floorplanning, placement, CTS, routing, and signoff.
- Learned why floorplanning is one of the most consequential decisions in physical design.
- Understood how poor macro placement can cause timing and congestion problems.
- Learned the precise meaning of routing congestion.
- Understood the difference between DRC and LVS.
- Learned why sensitive analog blocks need physical isolation from noisy digital regions.
- Understood the role of halos around macros.
- Learned why power planning must be considered during floorplanning.
- Understood IR drop and its relationship with the power distribution network.
- Connected Physical Design with STA and timing closure learned earlier.
- Learned that timing closure requires multiple iterations rather than a single final timing check.
- Understood the difference between floorplanning and placement.
- Learned the responsibilities and skills required by different Physical Design engineers.
- Understood the role of Analog Layout Engineers and how custom analog layout differs from digital physical design.

## Simulation / Verification Result

This was a conceptual Physical Design fundamentals day, so no RTL simulation or testbench was required.

The following concepts were studied and verified conceptually:

- ✔ Complete Physical Design flow understood.
- ✔ Floorplanning and placement concepts understood.
- ✔ Routing congestion understood.
- ✔ CTS objectives understood.
- ✔ DRC and LVS differences understood.
- ✔ Macro placement and halo concepts understood.
- ✔ Power planning and IR drop understood.
- ✔ STA and timing closure connection understood.
- ✔ Signoff requirements understood.
- ✔ Digital Physical Design and Analog Layout roles distinguished.

## Conclusion

This project builds the fundamental mental model required to understand Physical Design in VLSI. Starting from a synthesized gate-level netlist, the design is physically organized through floorplanning, optimized through placement, provided with a controlled clock network through CTS, physically connected through routing, and finally verified through signoff checks such as STA, DRC, LVS, IR Drop, and EM.

The most important learning is that Physical Design is an iterative optimization process involving timing, area, power, congestion, reliability, and manufacturability. A poor decision in an early stage can create problems in later stages, which is why engineers repeatedly analyze reports and optimize the physical implementation before tapeout.
