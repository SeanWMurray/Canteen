import sys, html
S=sys.argv[1]
BLUE='#257de0'; GRID='#e6e6e6'; T1='#191919'; T2='#666666'
CAT=['#257de0','#f47230','#00b894','#f2a600','#ee7fac']

def fmt(n): return f'{n:,}'

# 1. Theorems by area: horizontal bars, single series, sorted
areas=[('Capital gains and losses',87),('Worked transactions',80),('Framework and tests',67),('Corporate reorganizations',43),
       ('Income, deductions and tax',32),('Attribution, death, gifts',21),('Related and affiliated persons',17)]
def hbars(data,w=330,bar=12,gap=9,label_w=150):
    mx=max(v for _,v in data); h=len(data)*(bar+gap)+18
    plot=w-label_w-34
    out=[f'<svg viewBox="0 0 {w} {h}" width="100%" role="img" aria-label="Theorems by area">']
    for t in range(0,101,25):
        x=label_w+plot*t/100
        out.append(f'<line x1="{x:.1f}" y1="0" x2="{x:.1f}" y2="{h-16}" stroke="{GRID}" stroke-width="1"/>')
        out.append(f'<text x="{x:.1f}" y="{h-4}" font-size="7.5" fill="{T2}" text-anchor="middle">{t}</text>')
    for i,(lab,v) in enumerate(data):
        y=i*(bar+gap)+4; bw=plot*v/100
        out.append(f'<text x="{label_w-6}" y="{y+bar-2.5}" font-size="8.5" fill="{T1}" text-anchor="end">{html.escape(lab)}</text>')
        # bar: square at baseline, 4px rounded end
        r=4
        out.append(f'<path d="M{label_w},{y} h{bw-r:.1f} q{r},0 {r},{r} v{bar-2*r} q0,{r} -{r},{r} h-{bw-r:.1f} z" fill="{BLUE}"><title>{lab}: {v}</title></path>')
        out.append(f'<text x="{label_w+bw+4:.1f}" y="{y+bar-2.5}" font-size="8.5" fill="{T1}" font-weight="600">{v}</text>')
    out.append('</svg>'); return ''.join(out)

# 2. Growth: modules of the Act encoded, by commit
growth=[0,0,0,2,2,4,7,12,13,13,14,15,16,16,16,16,17,19,20,22,23,24,25,26,27,28,29,30,31,32,33,33,33,34,35,36,36,37,38,38,38,39,40,41,42,43,44,45,46,46,47,48,49,50,51,51,51,52,53,54,55,55]
def line(data,w=330,h=150):
    L,R,Tp,B=26,40,8,22; pw=w-L-R; ph=h-Tp-B; n=len(data); mx=60
    X=lambda i: L+pw*i/(n-1); Y=lambda v: Tp+ph*(1-v/mx)
    out=[f'<svg viewBox="0 0 {w} {h}" width="100%" role="img" aria-label="Modules of the Act encoded, by commit">']
    for t in range(0,61,20):
        out.append(f'<line x1="{L}" y1="{Y(t):.1f}" x2="{L+pw}" y2="{Y(t):.1f}" stroke="{GRID}" stroke-width="1"/>')
        out.append(f'<text x="{L-5}" y="{Y(t)+2.5:.1f}" font-size="7.5" fill="{T2}" text-anchor="end">{t}</text>')
    for c in [1,20,40,62]:
        out.append(f'<text x="{X(c-1):.1f}" y="{h-8}" font-size="7.5" fill="{T2}" text-anchor="middle">{c}</text>')
    out.append(f'<text x="{L+pw/2:.1f}" y="{h}" font-size="7.5" fill="{T2}" text-anchor="middle">commit</text>')
    pts=' '.join(f'{X(i):.1f},{Y(v):.1f}' for i,v in enumerate(data))
    area=f'{X(0):.1f},{Y(0):.1f} '+pts+f' {X(n-1):.1f},{Y(0):.1f}'
    out.append(f'<polygon points="{area}" fill="{BLUE}" fill-opacity="0.10"/>')
    out.append(f'<polyline points="{pts}" fill="none" stroke="{BLUE}" stroke-width="2" stroke-linejoin="round" stroke-linecap="round"/>')
    ex,ey=X(n-1),Y(data[-1])
    out.append(f'<circle cx="{ex:.1f}" cy="{ey:.1f}" r="4" fill="{BLUE}" stroke="#ffffff" stroke-width="2"/>')
    out.append(f'<text x="{ex+7:.1f}" y="{ey+3:.1f}" font-size="8.5" fill="{T1}" font-weight="600">55</text>')
    # annotate the first day
    out.append('</svg>'); return ''.join(out)

# 3. Memo statements by status: one segmented bar with legend
status=[('Proven',150),('Encoded',40),('Fact',36),('Judgment call',8),('Not formalized',3)]
def segbar(data,w=330,h=58):
    tot=sum(v for _,v in data); x=0; out=[f'<svg viewBox="0 0 {w} {h}" width="100%" role="img" aria-label="Memo statements by status">']
    bh=16; avail=w-2*(len(data)-1)
    for k,(lab,v) in enumerate(data):
        bw=avail*v/tot
        rx = 4 if k in (0,len(data)-1) else 0
        out.append(f'<rect x="{x:.1f}" y="0" width="{bw:.1f}" height="{bh}" rx="{rx}" fill="{CAT[k]}"><title>{lab}: {v}</title></rect>')
        if bw>26:
            out.append(f'<text x="{x+bw/2:.1f}" y="{bh-4.5}" font-size="8" text-anchor="middle" fill="{"#ffffff" if k==0 else T1}" font-weight="600">{v}</text>')
        x+=bw+2
    # legend
    lx=0; ly=bh+12
    for k,(lab,v) in enumerate(data):
        t=f'{lab} {v}'; tw=11+len(t)*4.4+12
        if lx+tw>w: lx=0; ly+=13
        out.append(f'<rect x="{lx}" y="{ly}" width="8" height="8" rx="2" fill="{CAT[k]}"/>')
        out.append(f'<text x="{lx+11}" y="{ly+7}" font-size="8" fill="{T1}">{html.escape(t)}</text>')
        lx+=tw
    out.append('</svg>'); return ''.join(out)

# pipeline diagram
def pipeline(w=690,h=70):
    steps=[('Statute text','verbatim, 45 extracts'),('Rules in Lean','in the statute\'s own shape'),('Facts and judgment calls','calls kept explicit, branched'),
           ('Checked theorems','by the Lean kernel'),('Explanations and memos','every step cites the Act')]
    bw=(w-4*22)/5; out=[f'<svg viewBox="0 0 {w} {h}" width="100%" role="img" aria-label="How it works">']
    for i,(a,b) in enumerate(steps):
        x=i*(bw+22)
        fill = '#eaf2fc' if i!=3 else '#c8e6c9'
        stroke = '#9dc8f7' if i!=3 else '#2e7d32'
        out.append(f'<rect x="{x:.1f}" y="10" width="{bw:.1f}" height="46" rx="6" fill="{fill}" stroke="{stroke}" stroke-width="1"/>')
        out.append(f'<text x="{x+bw/2:.1f}" y="30" font-size="8.6" font-weight="600" text-anchor="middle" fill="{T1}">{html.escape(a)}</text>')
        out.append(f'<text x="{x+bw/2:.1f}" y="44" font-size="7.2" text-anchor="middle" fill="{T2}">{html.escape(b)}</text>')
        if i<4:
            ax=x+bw+3
            out.append(f'<path d="M{ax:.1f},33 h14" stroke="{T2}" stroke-width="1.3" marker-end="url(#arr)"/>')
    out.insert(1,f'<defs><marker id="arr" viewBox="0 0 8 8" refX="7" refY="4" markerWidth="6" markerHeight="6" orient="auto"><path d="M0,0 L8,4 L0,8 z" fill="{T2}"/></marker></defs>')
    out.append('</svg>'); return ''.join(out)

tiles=[('55','modules of the Income Tax Act'),('347','theorems, kernel-checked'),('850','tests and read-back checks'),
       ('7,353','declarations audited for axioms'),('11','memos, 10 worked transactions'),('78','interpretation choices for review')]
tiles_html=''.join(f'<div class="tile"><div class="v">{v}</div><div class="l">{l}</div></div>' for v,l in tiles)

example='''5. Therefore subsection 84.1(1) applies. [ITA 84.1(1)]
6. The greater of the subject shares' paid-up capital ($100.00) and their adjusted cost base as 84.1(2)(a.1) reduces it ($100.00) is $100.00. [ITA 84.1(1)(a) B, (b) E; 84.1(2)(a.1)]
8. A dividend of $1,250,000.00 is deemed paid to the taxpayer: the $1,250,100.00 of other consideration exceeds $100.00. [ITA 84.1(1)(b)]
9. The taxpayer's proceeds of disposition are $100.00. [ITA 54 "proceeds of disposition" (k)]'''

coverage=('<b>Capital gains:</b> 3, 38–41, 40(2)(b), (e.1), (g), 40(3)–(3.6), 43, 44, 45, 47, 50, 53(1)(f), 54 superficial loss. '
 '<b>Corporate:</b> 51, 55(2), 84(3), (4), 84.1, 85, 86, 87, 88(1), 83(2)/89(1), 112, 186(4). '
 '<b>People:</b> 69(1), 70(5)–(6), 73(1), 74.1, 74.2, 74.4, 251, 251.1, 251.2, 256(7). '
 '<b>Tax:</b> 2(2), 13, 20(16), 39(4), 82, 110.6, 111, 117(2), 118, 118.1, 120.4, 121.')

css=f'''
@page {{ size: Letter; margin: 11mm 12mm; }}
* {{ box-sizing: border-box }}
body {{ font-family: "Helvetica Neue", Helvetica, Arial, sans-serif; color:{T1}; margin:0; font-size:8.8pt; line-height:1.38 }}
.top {{ display:flex; justify-content:space-between; align-items:flex-end; border-bottom:2px solid {T1}; padding-bottom:5pt }}
h1 {{ font-size:24pt; margin:0; letter-spacing:-.01em }}
.tag {{ font-size:10.5pt; color:{T2}; margin-top:2pt }}
.meta {{ font-size:7.5pt; color:{T2}; text-align:right; white-space:nowrap; margin-left:12pt }}
.tiles {{ display:grid; grid-template-columns: repeat(6,1fr); gap:6pt; margin:9pt 0 8pt }}
.tile {{ background:#f6f8fb; border-radius:6px; padding:6pt 7pt }}
.tile .v {{ font-size:17pt; font-weight:600; line-height:1.1 }}
.tile .l {{ font-size:7.4pt; color:{T2}; margin-top:2pt }}
h2 {{ font-size:10pt; margin:8pt 0 3pt }}
.sub {{ font-size:7.6pt; color:{T2}; margin:0 0 3pt }}
.cols {{ display:grid; grid-template-columns: 1fr 1fr; gap:14pt }}
p {{ margin:2pt 0 5pt }}
ul {{ margin:2pt 0 4pt; padding-left:12pt }} li {{ margin:1.5pt 0 }}
pre {{ background:#f4f8fd; border:1px solid #d6e4f5; border-radius:5px; padding:6pt 7pt; font-family: Menlo, Consolas, monospace;
       font-size:6.6pt; line-height:1.45; white-space:pre-wrap; margin:3pt 0 }}
.foot {{ margin-top:7pt; border-top:1px solid {GRID}; padding-top:5pt; font-size:7.5pt; color:{T2} }}
.foot b {{ color:{T1} }}
'''

page=f'''<!DOCTYPE html><html><head><meta charset="utf-8"><title>Canteen</title><style>{css}</style></head><body>
<div class="top"><div><h1>Canteen</h1>
<div class="tag">Canadian income tax law in Lean 4: every conclusion is a theorem the computer has checked.</div></div>
<div class="meta">Income Tax Act, consolidated to 2026-10-29<br/>Lean 4.36<br/>github.com/SeanWMurray/Canteen</div></div>

<div class="tiles">{tiles_html}</div>

<h2>How it works</h2>
{pipeline()}
<div class="cols">
<div>
<p>Each provision is written in Lean in the statute's own shape: its conditions, its exceptions, its citations. Given the facts of
a transaction, a rule decides whether it applies, computes the amounts to the cent, and explains itself in numbered English
steps, each citing the paragraph it rests on. The Lean kernel checks every claimed result, so a memo's conclusion cannot drift
from the law it states.</p>
<ul>
<li><b>Judgment calls stay visible.</b> "Identical property", "reasonable return", "all or substantially all" are never
silently decided: each is a named call, every answer is explored as a branch, and each conclusion lists the calls it relies on.</li>
<li><b>Facts beat judgment.</b> Where the Act settles a question (related persons, affiliation, control), it is computed,
not assumed.</li>
<li><b>Nothing hidden.</b> A memo that uses a fact or proof it does not declare fails to build, and every build audits all
declarations for the axioms they use.</li>
</ul>
<h2>Theorems by area</h2>
<p class="sub">Count of proven Lean theorems, committed work</p>
{hbars(areas)}
</div>
<div>
<h2>Growth: modules of the Act encoded</h2>
<p class="sub">Provision modules under Canteen/ITA after each of the 62 commits</p>
{line(growth)}
<h2>The memos' 237 statements, by status</h2>
<p class="sub">Across all 11 memos: proven statements are theorems; the rest are what they rest on</p>
{segbar(status)}
<h2>What a proof produces</h2>
<p class="sub">From the crystallization memo: 84.1 turns a $1,250,100 note into a $1,250,000 dividend (excerpt)</p>
<pre>{html.escape(example)}</pre>
</div>
</div>
<div class="foot">{coverage} Every result cites the provision it applies; the verbatim statute text for each is in the repository.
Constructed examples, not advice.</div>
<script>window.__ready = true;</script>
</body></html>'''
open(S+'/onepager.html','w').write(page)
