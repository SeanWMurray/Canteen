# PDFs

`docs/pdf/crystallization-memo.pdf` and `docs/pdf/canteen-one-pager.pdf` are built with these scripts,
from a working directory `DIR` holding `mermaid.min.js` (from the `mermaid` npm package) and, for the
memo, `axioms.txt` (the output of `#print axioms` for the theorems it quotes):

    python3 scripts/pdf/build_memo.py DIR        # DIR/memo.html, from docs/blueprint/crystallization.md
    (cd DIR && python3 scripts/pdf/reasoning_map.py)   # DIR/map.svg, the one-pager's reasoning map
    python3 scripts/pdf/build_onepager.py DIR    # DIR/onepager3.html
    node scripts/pdf/render.js DIR/memo.html docs/pdf/crystallization-memo.pdf

Rendering uses Playwright's Chromium. The one-pager is written for tax professionals; its reasoning map is a
simplified, hand-laid-out version of the crystallization memo's dependency graph, and its counts were taken
from the repository when it was built.
