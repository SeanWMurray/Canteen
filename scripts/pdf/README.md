# PDFs

`docs/pdf/crystallization-memo.pdf` and `docs/pdf/canteen-one-pager.pdf` are built with these scripts,
from a working directory `DIR` holding `mermaid.min.js` (from the `mermaid` npm package) and, for the
memo, `axioms.txt` (the output of `#print axioms` for the theorems it quotes):

    python3 scripts/pdf/build_memo.py DIR        # DIR/memo.html, from docs/blueprint/crystallization.md
    python3 scripts/pdf/build_onepager.py DIR    # DIR/onepager2.html, from docs/graphs/provisions.md and the crystallization memo
    node scripts/pdf/render.js DIR/memo.html docs/pdf/crystallization-memo.pdf

Rendering uses Playwright's Chromium. The one-pager's dependency graphs are read from the generated
docs; its headline counts were taken from the repository when it was built.
