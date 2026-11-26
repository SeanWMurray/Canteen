# Timelines of the superficial loss period

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

The disposition, the period in paragraph (a) (30 days before to 30 days after, both ends included), every acquisition, and the end of the period in paragraph (b). Acquisitions that meet both (a) and (b) are red.

## Spouse repurchase

```mermaid
gantt
    title Superficial loss period for the disposition on 2025-06-15
    dateFormat YYYY-MM-DD
    axisFormat %b %d
    section Period (a)
    2025-05-16 to 2025-07-15 :active, period, 2025-05-16, 61d
    section Disposition
    2025-06-15 disposition of 100 common shares of ABC Ltd. (loss $509.99) :milestone, disp, 2025-06-15, 0d
    section Acquisitions
    2025-06-20 the taxpayer's spouse (affiliated) acquires 100 common shares of ABC Ltd. (in period, held at end) :milestone, crit, a0, 2025-06-20, 0d
    section End of period (b)
    2025-07-15 end of period :milestone, endp, 2025-07-15, 0d
```

## Sibling purchase and day-31 repurchase

```mermaid
gantt
    title Superficial loss period for the disposition on 2025-03-03
    dateFormat YYYY-MM-DD
    axisFormat %b %d
    section Period (a)
    2025-02-01 to 2025-04-02 :active, period, 2025-02-01, 61d
    section Disposition
    2025-03-03 disposition of 50 common shares of DEF Inc. (loss $1,000.00) :milestone, disp, 2025-03-03, 0d
    section Acquisitions
    2025-03-10 the taxpayer's sibling (not affiliated) acquires 50 common shares of DEF Inc. (in period, held at end) :milestone, a0, 2025-03-10, 0d
    2025-04-03 the taxpayer acquires 50 common shares of DEF Inc. (outside period, held at end) :milestone, a1, 2025-04-03, 0d
    section End of period (b)
    2025-04-02 end of period :milestone, endp, 2025-04-02, 0d
```

## The edges of the period: days −31, −30, +30 and +31

```mermaid
gantt
    title Superficial loss period for the disposition on 2025-06-15
    dateFormat YYYY-MM-DD
    axisFormat %b %d
    section Period (a)
    2025-05-16 to 2025-07-15 :active, period, 2025-05-16, 61d
    section Disposition
    2025-06-15 disposition of 100 common shares of ABC Ltd. (loss $500.00) :milestone, disp, 2025-06-15, 0d
    section Acquisitions
    2025-05-15 the taxpayer acquires 100 common shares of ABC Ltd. (outside period, held at end) :milestone, a0, 2025-05-15, 0d
    2025-05-16 the taxpayer acquires 100 common shares of ABC Ltd. (in period, held at end) :milestone, crit, a1, 2025-05-16, 0d
    2025-07-15 the taxpayer acquires 100 common shares of ABC Ltd. (in period, held at end) :milestone, crit, a2, 2025-07-15, 0d
    2025-07-16 the taxpayer acquires 100 common shares of ABC Ltd. (outside period, held at end) :milestone, a3, 2025-07-16, 0d
    section End of period (b)
    2025-07-15 end of period :milestone, endp, 2025-07-15, 0d
```

