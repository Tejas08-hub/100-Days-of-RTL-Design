# Day 06 --- Static Timing Analysis (STA)

> **Topic:** STA Fundamentals --- Setup Timing, Hold Timing, Slack,
> Minimum Clock Period, Maximum Frequency

## Question of the Day

### Problem Statement

Consider two positive edge-triggered D flip-flops connected through
combinational logic. Using the given timing parameters, perform Static
Timing Analysis (STA) and determine whether the circuit satisfies setup
and hold timing.

## Given Parameters

  Parameter               Value
  --------------------- -------
  Clock Period            20 ns
  Clock-to-Q Delay         3 ns
  Combinational Delay     12 ns
  Setup Time               4 ns
  Hold Time                2 ns
  Clock Skew               0 ns

## Circuit

``` text
Clock
  │
  ▼
+-----+   Tcq=3ns   +----------------+   +-----+
| FF1 | ----------> | Comb=12 ns     |-> | FF2 |
+-----+             +----------------+   +-----+
```

## My Approach

I first identified the complete launch-to-capture timing path. The data
starts at FF1, passes through the Clock-to-Q delay, propagates through
the combinational logic, and finally reaches FF2.

STA verifies this timing path mathematically without applying simulation
vectors.

The analysis is divided into: - Setup timing - Hold timing

## Theory

**Static Timing Analysis (STA)** verifies whether a synchronous circuit
satisfies timing constraints without applying input vectors.

Important parameters: - **Tcq:** Delay from clock edge to flip-flop
output. - **Tcomb:** Delay through combinational logic. - **Setup
Time:** Data must be stable before the capturing edge. - **Hold Time:**
Data must remain stable after the capturing edge.

## Solution

### Q1. Data Arrival Time

Formula

``` text
Arrival Time = Tcq + Tcomb
```

Calculation

``` text
Arrival Time
= 3 + 12
= 15 ns
```

**Answer:** 15 ns

### Q2. Setup Required Time

``` text
Required Time = Clock Period − Setup Time
= 20 − 4
= 16 ns
```

**Answer:** 16 ns

### Q3. Setup Slack

``` text
Setup Slack = Required Time − Arrival Time
= 16 − 15
= +1 ns
```

**Answer:** +1 ns

Positive slack means setup timing is met.

### Q4. Hold Required Time

``` text
Hold Required Time = Hold Time
= 2 ns
```

**Answer:** 2 ns

### Q5. Hold Slack

``` text
Hold Slack = Arrival Time − Hold Required Time
= 15 − 2
= +13 ns
```

**Answer:** +13 ns

Positive slack means hold timing is met.

### Q6. Minimum Clock Period

``` text
Tmin = Tcq + Tcomb + Tsetup
= 3 + 12 + 4
= 19 ns
```

**Answer:** 19 ns

### Q7. Maximum Operating Frequency

``` text
Fmax = 1 / Tmin
= 1 / 19 ns
≈ 52.63 MHz
```

**Answer:** 52.63 MHz

### Q8. Positive Clock Skew

-   Improves setup timing.
-   Reduces hold margin.
-   Excessive positive skew can cause hold violations.

### Q9. Timing Verification

  Check               Result
  -------------- -----------
  Arrival Time         15 ns
  Setup Slack          +1 ns
  Hold Slack          +13 ns
  Tmin                 19 ns
  Fmax             52.63 MHz

The circuit satisfies both setup and hold timing.

## Observations

-   Arrival time = 15 ns.
-   Setup slack is positive.
-   Hold slack is positive.
-   Minimum clock period = 19 ns.
-   Maximum frequency ≈ 52.63 MHz.

## Key Learning

-   Learned STA fundamentals.
-   Calculated arrival time.
-   Calculated setup and hold slack.
-   Determined minimum clock period.
-   Determined maximum operating frequency.
-   Understood the effect of clock skew.

## Conclusion

The design satisfies both setup and hold timing requirements. The
minimum clock period is **19 ns**, allowing a maximum operating
frequency of **52.63 MHz**.

## Interview Questions with Answers

1.  What is STA? --- A mathematical timing verification technique
    without test vectors.
2.  What is Clock-to-Q delay? --- Delay from clock edge to valid Q
    output.
3.  What is setup time? --- Time data must be stable before the clock
    edge.
4.  What is hold time? --- Time data must remain stable after the clock
    edge.
5.  What is arrival time? --- Time taken for data to reach the
    destination flip-flop.
6.  What is required time? --- Latest allowable arrival time.
7.  What is setup slack? --- Required time minus arrival time.
8.  What is hold slack? --- Arrival time minus hold required time.
9.  What causes a setup violation? --- Negative setup slack.
10. What causes a hold violation? --- Negative hold slack.
11. Which timing determines maximum frequency? --- Setup timing.
12. How does positive clock skew affect setup? --- Improves setup
    timing.
13. How does positive clock skew affect hold? --- Worsens hold timing.
14. What is a critical path? --- The longest timing path in a design.
15. Why is STA important? --- It ensures reliable chip timing before
    fabrication.
