<div align="center">

# ⏱️ Day 06 — Static Timing Analysis (STA)

![Topic](https://img.shields.io/badge/Topic-STA%20Fundamentals-7c3aed?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Complete-16a34a?style=for-the-badge)
![Fmax](https://img.shields.io/badge/Fmax-52.63%20MHz-2563eb?style=for-the-badge)
![Difficulty](https://img.shields.io/badge/Difficulty-Fundamentals-f59e0b?style=for-the-badge)

**Setup Timing • Hold Timing • Slack • Minimum Clock Period • Maximum Frequency**

</div>

---

## 📋 Problem Statement

Consider two positive edge-triggered D flip-flops connected through combinational logic. Using the given timing parameters, perform Static Timing Analysis (STA) and determine whether the circuit satisfies setup and hold timing.

## 📊 Given Parameters

| Parameter | Symbol | Value |
|:----------|:------:|------:|
| 🕐 Clock Period | `T` | **20 ns** |
| ➡️ Clock-to-Q Delay | `Tcq` | **3 ns** |
| 🔀 Combinational Delay | `Tcomb` | **12 ns** |
| 📥 Setup Time | `Tsetup` | **4 ns** |
| 📤 Hold Time | `Thold` | **2 ns** |
| ⚖️ Clock Skew | — | **0 ns** |

## 🔌 Circuit Diagram

![Circuit Diagram](circuit_diagram.svg)

## 📈 Timing Window Visualization

![Timing Diagram](timing_diagram.svg)

> [!NOTE]
> The **green region** above marks setup slack (margin before the setup window starts), and the **orange region** marks hold slack (margin after the launch edge, before hold time ends). Both are positive here, so the path is safe.

---

## 🧠 My Approach

I first identified the complete launch-to-capture timing path. The data starts at FF1, passes through the clock-to-Q delay, propagates through the combinational logic, and finally reaches FF2.

STA verifies this timing path **mathematically**, without applying simulation vectors.

The analysis is divided into:
- 🔴 Setup timing
- 🟠 Hold timing

## 📚 Theory

> [!TIP]
> **Static Timing Analysis (STA)** verifies whether a synchronous circuit satisfies timing constraints without applying input vectors — it checks every path in the design mathematically, not through simulation.

| Term | Meaning |
|:-----|:--------|
| **Tcq** | Delay from clock edge to flip-flop output |
| **Tcomb** | Delay through combinational logic |
| **Setup Time** | Data must be stable **before** the capturing edge |
| **Hold Time** | Data must remain stable **after** the capturing edge |

---

## ✅ Solution

### Q1 — Data Arrival Time

```
Arrival Time = Tcq + Tcomb
             = 3 + 12
             = 15 ns
```
**➡️ Answer: 15 ns**

### Q2 — Setup Required Time

```
Required Time = Clock Period − Setup Time
              = 20 − 4
              = 16 ns
```
**➡️ Answer: 16 ns**

### Q3 — Setup Slack

```
Setup Slack = Required Time − Arrival Time
            = 16 − 15
            = +1 ns
```
> [!IMPORTANT]
> **✅ Positive slack → setup timing is MET.**

### Q4 — Hold Required Time

```
Hold Required Time = Hold Time = 2 ns
```
**➡️ Answer: 2 ns**

### Q5 — Hold Slack

```
Hold Slack = Arrival Time − Hold Required Time
           = 15 − 2
           = +13 ns
```
> [!IMPORTANT]
> **✅ Positive slack → hold timing is MET.**

### Q6 — Minimum Clock Period

```
Tmin = Tcq + Tcomb + Tsetup
     = 3 + 12 + 4
     = 19 ns
```
**➡️ Answer: 19 ns**

### Q7 — Maximum Operating Frequency

```
Fmax = 1 / Tmin
     = 1 / 19 ns
     ≈ 52.63 MHz
```
**➡️ Answer: 52.63 MHz**

### Q8 — Effect of Positive Clock Skew

| Effect on | Impact |
|:----------|:-------|
| ✅ Setup timing | Improves (more margin) |
| ⚠️ Hold timing | Reduces margin |
| 🚨 Risk | Excessive positive skew can cause **hold violations** |

### Q9 — Timing Verification Summary

<div align="center">

| Check | Result | Status |
|:------|-------:|:------:|
| Arrival Time | 15 ns | — |
| Setup Slack | +1 ns | ✅ |
| Hold Slack | +13 ns | ✅ |
| Tmin | 19 ns | — |
| Fmax | 52.63 MHz | — |

**🎉 The circuit satisfies both setup and hold timing.**

</div>

---

## 🔍 Observations

- Arrival time = 15 ns
- Setup slack is positive ✅
- Hold slack is positive ✅
- Minimum clock period = 19 ns
- Maximum frequency ≈ 52.63 MHz

## 🎓 Key Learning

- Learned STA fundamentals
- Calculated arrival time
- Calculated setup and hold slack
- Determined minimum clock period
- Determined maximum operating frequency
- Understood the effect of clock skew

## 🏁 Conclusion

The design satisfies both setup and hold timing requirements. The minimum clock period is **19 ns**, allowing a maximum operating frequency of **52.63 MHz**.

---

## 💬 Interview Questions with Answers

<details>
<summary><b>1. What is STA?</b></summary>
A mathematical timing verification technique that checks all paths without applying test vectors.
</details>

<details>
<summary><b>2. What is clock-to-Q delay?</b></summary>
Delay from the clock edge to a valid Q output.
</details>

<details>
<summary><b>3. What is setup time?</b></summary>
Time data must be stable <i>before</i> the clock edge.
</details>

<details>
<summary><b>4. What is hold time?</b></summary>
Time data must remain stable <i>after</i> the clock edge.
</details>

<details>
<summary><b>5. What is arrival time?</b></summary>
Time taken for data to reach the destination flip-flop.
</details>

<details>
<summary><b>6. What is required time?</b></summary>
The latest (setup) or earliest (hold) allowable arrival time.
</details>

<details>
<summary><b>7. What is setup slack?</b></summary>
Required time minus arrival time.
</details>

<details>
<summary><b>8. What is hold slack?</b></summary>
Arrival time minus hold required time.
</details>

<details>
<summary><b>9. What causes a setup violation?</b></summary>
Negative setup slack.
</details>

<details>
<summary><b>10. What causes a hold violation?</b></summary>
Negative hold slack.
</details>

<details>
<summary><b>11. Which timing determines maximum frequency?</b></summary>
Setup timing.
</details>

<details>
<summary><b>12. How does positive clock skew affect setup?</b></summary>
Improves setup timing.
</details>

<details>
<summary><b>13. How does positive clock skew affect hold?</b></summary>
Worsens hold timing.
</details>

<details>
<summary><b>14. What is a critical path?</b></summary>
The path with the <b>least slack</b> in the design — not simply the physically longest path. A shorter path with a tighter required time can be more critical than a longer path with a generous one, which is why "least slack" is the precise definition, not "longest delay."
</details>

<details>
<summary><b>15. Why is STA important?</b></summary>
It ensures reliable chip timing before fabrication, across every path, without needing simulation vectors.
</details>

---

<div align="center">

**#100DaysOfVLSI** · Day 6 of 100 · Next up: Day 07 🚀

</div>
