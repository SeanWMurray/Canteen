# Graphs

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

Diagrams drawn from the Lean definitions, so they always show the rules as encoded.

- [Flowcharts of the rules](flowcharts.md): Section 54, "superficial loss", Paragraph 40(2)(g) as a whole, Subparagraph 40(2)(g)(i), Subparagraph 40(2)(g)(ii): debts, Subparagraph 40(2)(g)(iii): personal-use property, Section 54 "personal-use property", Subsection 40(3.3): suspended losses, Subsection 50(2): a personal-use debt that goes bad, Subsection 40(3.6): a share disposed of to an affiliated corporation, Paragraph 40(2)(e.1): a debt within a related group, Section 54 "principal residence", for an individual and a year, Subsection 73(1): the spousal rollover, Subsection 70(6): rollover on death, Subsection 74.5(1): the fair market value exception to attribution, Subsection 45(1): change in use, with the elections, Subsection 85(1): transfer of property to a corporation, Subsection 84.1(1): shares sold to a non-arm's length corporation, Section 110.6 "qualified small business corporation share", Paragraph 251.2(2)(a), with 256(7)(a): loss restriction events, Subsections 74.1(1) and (2): income attribution, Subsection 55(2): dividends over safe income, Subsection 86(1): share exchanges, Subsection 44(1): replacement property, Subsection 186(4): connected corporations, Subsection 88(1): winding up a subsidiary, Subsection 87(1): amalgamation, Subsection 39(4): the Canadian securities election, Subsection 50(1): bad debts and worthless shares, Subsection 74.4(2): corporate attribution, Subsection 15(2): shareholder loans, Subparagraph 20(1)(c)(i): interest on borrowed money, Subparagraph 40(2)(g)(iv): transfers to registered plans, Clause 40(2)(g)(iv)(A), Clause 40(2)(g)(iv)(B), Paragraph 251.1(1)(a), Rule X (the placeholder from the design)
- [Decision trees over the judgment calls](decision-trees.md): Spouse repurchase: are the shares identical?, Sibling and day-31 repurchase: two judgment calls, one answer, TFSA contribution: paragraph 40(2)(g) on both answers to J-AFF, A debt sold at a loss: income purpose and arm's length dealing both judged, Rule X with condition B and the exception both left to judgment
- [Timelines of the superficial loss period](timelines.md): Spouse repurchase, Sibling purchase and day-31 repurchase, The edges of the period: days −31, −30, +30 and +31, A suspended loss under 40(3.4): Opco and Sisterco
- [Who is affiliated with whom](affiliation.md): A family group, Holdco, owned by the taxpayer and spouse, An amalgamation: the hypothetical world of 251.1(2), with Newco supposed to exist immediately before, Holdco, owned with a friend, if the taxpayer controls it de facto
- [Who is related to whom](related.md): Three generations
- [A transaction series, step by step](series.md): If condition B is met (J-B = yes), If condition B is not met (J-B = no)
- [Provision map](provisions.md): which encoded provisions rely on which, read from the Lean
- [Dashboard](dashboard.md): statements by status, judgment calls by risk, the transactions by date, and the Act as encoded
- [Architecture](architecture.md): every module, by layer, and how they build on each other

Each blueprint in [`docs/blueprint/`](../blueprint/README.md) also has its own dependency graphs.
