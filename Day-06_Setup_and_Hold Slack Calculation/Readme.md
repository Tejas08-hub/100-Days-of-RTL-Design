# Day 06 — Static Timing Analysis (STA)

> **Topic:** STA Fundamentals — Setup Timing, Hold Timing, Slack, Minimum Clock Period, Maximum Frequency

## Question of the Day

### Problem Statement

Consider two positive edge-triggered D flip-flops connected through combinational logic. Using the given timing parameters, perform Static Timing Analysis (STA) and determine whether the circuit satisfies setup and hold timing.

## Given Parameters

| Parameter           | Value |
|----------------------|-------|
| Clock Period          | 20 ns |
| Clock-to-Q Delay      | 3 ns  |
| Combinational Delay   | 12 ns |
| Setup Time            | 4 ns  |
| Hold Time             | 2 ns  |
| Clock Skew            | 0 ns  |

## Circuit

```
Clock
  │
  ▼
+-----+   Tcq = 3ns   +------------------+   +-----+
| FF1 | ------------> |  Comb = 12 ns    |-->| FF2 |
+-----+                +------------------+   +-----+
```

## My Approach

I first identified the complete launch-to-capture timing path. The data starts at FF1, passes through the clock-to-Q delay, propagates through the combinational logic, and finally reaches FF2.

STA verifies this timing path mathematically, without applying simulation vectors.

The analysis is divided into:
- Setup timing
- Hold timing

## Theory

**Static Timing Analysis (STA)** verifies whether a synchronous circuit satisfies timing constraints without applying input vectors.

Important parameters:
- **T_cq:** Delay from clock edge to flip-flop output.
- **T_comb:** Delay through combinational logic.
- **Setup Time:** Data must be stable *before* the capturing edge.
- **Hold Time:** Data must remain stable *after* the capturing edge.

## Solution

### Q1. Data Arrival Time

**Formula:** `Arrival Time = T_cq + T_comb`

**Calculation:** `3 + 12 = 15 ns`

**Answer:** 15 ns

### Q2. Setup Required Time

**Formula:** `Required Time = Clock Period − Setup Time`

**Calculation:** `20 − 4 = 16 ns`

**Answer:** 16 ns

### Q3. Setup Slack

**Formula:** `Setup Slack = Required Time − Arrival Time`

**Calculation:** `16 − 15 = +1 ns`

**Answer:** +1 ns — positive slack means setup timing is met.

### Q4. Hold Required Time

**Formula:** `Hold Required Time = Hold Time`

**Calculation:** `= 2 ns`

**Answer:** 2 ns

### Q5. Hold Slack

**Formula:** `Hold Slack = Arrival Time − Hold Required Time`

**Calculation:** `15 − 2 = +13 ns`

**Answer:** +13 ns — positive slack means hold timing is met.

### Q6. Minimum Clock Period

**Formula:** `T_min = T_cq + T_comb + T_setup`

**Calculation:** `3 + 12 + 4 = 19 ns`

**Answer:** 19 ns

### Q7. Maximum Operating Frequency

**Formula:** `F_max = 1 / T_min`

**Calculation:** `1 / 19 ns ≈ 52.63 MHz`

**Answer:** 52.63 MHz

### Q8. Effect of Positive Clock Skew

- Improves setup timing.
- Reduces hold margin.
- Excessive positive skew can cause hold violations.

### Q9. Timing Verification Summary

| Check         | Result     |
|---------------|------------|
| Arrival Time  | 15 ns      |
| Setup Slack   | +1 ns      |
| Hold Slack    | +13 ns     |
| T_min         | 19 ns      |
| F_max         | 52.63 MHz  |

**The circuit satisfies both setup and hold timing.**

## Observations

- Arrival time = 15 ns.
- Setup slack is positive.
- Hold slack is positive.
- Minimum clock period = 19 ns.
- Maximum frequency ≈ 52.63 MHz.

## Key Learning

- Learned STA fundamentals.
- Calculated arrival time.
- Calculated setup and hold slack.
- Determined minimum clock period.
- Determined maximum operating frequency.
- Understood the effect of clock skew.

## Conclusion

The design satisfies both setup and hold timing requirements. The minimum clock period is **19 ns**, allowing a maximum operating frequency of **52.63 MHz**.

## Interview Questions with Answers

1. **What is STA?** — A mathematical timing verification technique that checks all paths without applying test vectors.
2. **What is clock-to-Q delay?** — Delay from the clock edge to a valid Q output.
3. **What is setup time?** — Time data must be stable *before* the clock edge.
4. **What is hold time?** — Time data must remain stable *after* the clock edge.
5. **What is arrival time?** — Time taken for data to reach the destination flip-flop.
6. **What is required time?** — The latest (setup) or earliest (hold) allowable arrival time.
7. **What is setup slack?** — Required time minus arrival time.
8. **What is hold slack?** — Arrival time minus hold required time.
9. **What causes a setup violation?** — Negative setup slack.
10. **What causes a hold violation?** — Negative hold slack.
11. **Which timing determines maximum frequency?** — Setup timing.
12. **How does positive clock skew affect setup?** — Improves setup timing.
13. **How does positive clock skew affect hold?** — Worsens hold timing.
14. **What is a critical path?** — The path with the **least slack** in the design — not simply the physically longest path. A shorter path with a tighter required time can be more critical than a longer path with a generous one, which is why "least slack" is the precise definition, not "longest delay."
15. **Why is STA important?** — It ensures reliable chip timing before fabrication, across every path, without needing simulation vectors.
