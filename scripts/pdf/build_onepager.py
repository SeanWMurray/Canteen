import sys, html
S=sys.argv[1]
T1='#191919'; T2='#5f5f5f'; GRID='#e3e3e3'
# Plain-language reasoning map of the crystallization memo (simplified from its full graph)
nodes = [
 ('L1','law','Section 85(1)<br/>rollover'),('L2','law','Section 84.1'),('L3','law','Capital gains<br/>deduction, 110.6'),
 ('L4','law','Superficial loss rules,<br/>40(2)(g), 53(1)(f)'),('L5','law','Dividend gross-up,<br/>82(1)'),
 ('F1','fact','Taxpayer controls<br/>Opco, Holdco, Newco'),('F2','fact','Opco shares:<br/>cost $100, worth $2M'),
 ('F3','fact','Step 1: Opco shares to<br/>Holdco, elect $1,250,100'),('F4','fact','Step 2: Holdco shares sold<br/>to Newco for a $1,250,100 note'),
 ('J','judg','Judgment call: is Opco a<br/>small business corporation?<br/><i>assumed yes, low risk</i>'),
 ('A1','step','Elected amount<br/>$1,250,100'),('A2','step','84.1 grinds paid-up<br/>capital to $100'),
 ('A3','step','$1.25M gain<br/>fully sheltered'),('A4','step','Hard cost of the<br/>Holdco shares: $100'),
 ('A5','step','$1.25M of the note is<br/>a deemed dividend'),('A6','step','$1.25M capital loss is<br/>superficial: denied'),
 ("A7","step","Loss added to<br/>Newco's cost"),('A8','step','Dividend taxed:<br/>$1,437,500 income'),
 ('K','concl','Conclusion: the crystallization works;<br/>the strip does not'),
]
edges = [('L1','A1'),('F3','A1'),('L2','A2'),('F1','A2'),('A1','A3'),('A2','A3'),('L3','A3'),('F2','A3'),('J','A3'),
 ('A3','A4'),('L2','A4'),('F4','A4'),('A4','A5'),('A5','A8'),('L5','A8'),('A5','A6'),('L4','A6'),('A6','A7'),
 ('A3','K'),('A8','K'),('A7','K')]
styles={'law':'fill:#dbe9fa,stroke:#257de0','fact':'fill:#f0f0f0,stroke:#8a8a8a','judg':'fill:#fde3d0,stroke:#e8590c',
        'step':'fill:#d9f2dc,stroke:#2e7d32','concl':'fill:#2e7d32,stroke:#1b5e20,color:#ffffff'}
lines=['flowchart TD']
for i,k,lab in nodes: lines.append(f'  {i}["{lab}"]:::{k}')
for a,b in edges: lines.append(f'  {a} --> {b}')
for k,v in styles.items(): lines.append(f'  classDef {k} {v},stroke-width:1.5px,color:{T1}' if k!='concl' else f'  classDef {k} {v},stroke-width:1.5px')
graph='\n'.join(lines)
legend=''.join(f'<span class="lg"><i style="{st}"></i>{n}</span>' for st,n in [
  ('background:#f0f0f0;border-color:#8a8a8a','Your facts'),
  ('background:#fde3d0;border-color:#e8590c','Judgment call'),('background:#d9f2dc;border-color:#2e7d32','Verified step, with its citation')])

css=f'''
@page {{ size: Letter; margin: 11mm 12mm; }}
* {{ box-sizing: border-box }}
body {{ font-family: "Helvetica Neue", Helvetica, Arial, sans-serif; color:{T1}; margin:0; font-size:8.6pt; line-height:1.36 }}
.top {{ border-bottom:2px solid {T1}; padding-bottom:5pt; display:flex; justify-content:space-between; align-items:flex-end }}
h1 {{ font-size:21pt; margin:0; letter-spacing:-.01em }}
.tag {{ font-size:11pt; color:{T2}; margin-top:2pt }}
.meta {{ font-size:7.5pt; color:{T2}; text-align:right; white-space:nowrap }}
h2 {{ font-size:10.2pt; margin:6pt 0 2pt }}
p {{ margin:2pt 0 5pt }}
.lead {{ font-size:9.2pt; margin:6pt 0 3pt }}
.steps {{ display:grid; grid-template-columns:repeat(4,1fr); gap:7pt; margin:3pt 0 4pt }}
.step {{ background:#f5f8fc; border-radius:6px; padding:6pt 8pt; border-top:3px solid #257de0 }}
.step b {{ display:block; font-size:9pt; margin-bottom:2pt }}
.step span {{ font-size:8pt; color:#333 }}
.n {{ display:inline-block; width:15px; height:15px; border-radius:50%; background:#257de0; color:#fff; font-size:8pt; text-align:center;
     line-height:15px; margin-right:4px; font-weight:600 }}
.cols {{ display:grid; grid-template-columns: 1fr 1.1fr; gap:14pt; align-items:start }}
ul {{ margin:2pt 0 3pt; padding-left:12pt }} li {{ margin:2.5pt 0 }}
.lgs {{ font-size:7.6pt; margin:2pt 0 3pt }}
.lg {{ display:inline-block; margin-right:9pt; white-space:nowrap }}
.lg i {{ display:inline-block; width:9px; height:9px; border:1.5px solid; border-radius:2px; margin-right:3px; vertical-align:-1px }}
.sub {{ font-size:7.8pt; color:{T2}; margin:0 0 2pt }}
#map svg {{ width:100% !important; max-width:100% !important; height:auto; max-height:66mm }}
#map {{ margin:0 0 2pt }}
.result {{ background:#eef7ef; border:1px solid #cfe8d2; border-radius:6px; padding:6pt 9pt; font-size:8.4pt }}
.cov {{ font-size:7.5pt; margin:2pt 0 3pt; line-height:1.33 }} .cov b {{ color:{T1} }}
.nums {{ display:grid; grid-template-columns:repeat(4,1fr); gap:6pt; margin:4pt 0 2pt }}
.num {{ background:#f6f6f6; border-radius:6px; padding:5pt 7pt }}
.num .v {{ font-size:14pt; font-weight:600; line-height:1.1 }} .num .l {{ font-size:7.4pt; color:{T2} }}
.foot {{ margin-top:6pt; border-top:1px solid {GRID}; padding-top:4pt; font-size:7.4pt; color:{T2} }}
'''
page=f'''<!DOCTYPE html><html><head><meta charset="utf-8"><title>Canteen</title><style>{css}</style>
<script src="{S}/mermaid.min.js"></script></head><body>
<div class="top"><div><h1>Canteen</h1><div class="tag">Tax analysis as a logical argument you can check, step by step, against the Act.</div></div>
<div class="meta">Income Tax Act (Canada), consolidated to 2026-10-29<br/>github.com/SeanWMurray/Canteen</div></div>

<p class="lead">Canteen is the <i>Income Tax Act</i> written as precise rules a computer can apply. Give it the facts of a file
and it tells you which provisions apply, computes the amounts to the cent, and writes out its reasoning as a logical chain, like a
working paper, each step citing the Act. Then a mathematical checker <b>proves</b> that every conclusion follows, by strict logical
steps, from the provisions and your facts.</p>

<h2>How it works</h2>
<div class="steps">
<div class="step"><b><span class="n">1</span>The law, written once</b><span>Translated from the consolidated Act, conditions and
exceptions intact.</span></div>
<div class="step"><b><span class="n">2</span>Your facts</b><span>Dates, amounts, ownership. Who is related or affiliated
is worked out, not assumed.</span></div>
<div class="step"><b><span class="n">3</span>Judgment calls, flagged</b><span>Named, with the result either way and a risk
rating.</span></div>
<div class="step"><b><span class="n">4</span>A checked conclusion</b><span>Every amount, cross-reference and logical step verified
end to end, not spot-checked.</span></div>
</div>

<h2>What a conclusion looks like: the reasoning map</h2>
<p class="sub">A crystallization followed by a surplus strip, simplified from the memo Canteen produces. Each arrow is a logical reliance:
change a fact, a provision or the judgment call, and everything downstream is recomputed and rechecked.</p>
<div class="lgs">{legend}</div>
<div id="map">{open(S+'/map.svg').read()}</div>
<div class="cols">
<div>
<h2>Why it helps your practice</h2>
<ul>
<li><b>Reviewable.</b> It reads like a memo, a citation on every line; no technical knowledge needed.</li>
<li><b>Interactions caught.</b> Here, 84.1(2)(a.1) undoes the crystallized cost, and the loss it creates is superficial.</li>
<li><b>Assumptions on the record.</b> Each conclusion lists its judgment calls; the other answer is already computed.</li>
<li><b>What-ifs in seconds.</b> Change a date, amount or shareholder; the analysis reruns, verified.</li>
<li><b>Consistent and open.</b> Same rules on every file; each interpretation chosen is written down for your review.</li>
</ul></div>
<div>
<h2>The example's result</h2>
<div class="result">The 2025 crystallization shelters a $1,250,000 gain. The 2026 sale for a $1,250,100 note fails as a strip:
$1,250,000 is a deemed dividend under 84.1 ($1,437,500 of income after the gross-up), and the matching $1,250,000 capital loss is
denied as superficial and added to Newco's cost. Every step verified; the result rests on one judgment call, rated low risk.</div>
<h2>What's covered so far</h2>
<p class="cov"><b>62</b> provisions and groups of provisions · <b>16</b> worked transactions, each a full memo · <b>951</b> test
cases with known answers · <b>87</b> interpretation choices open for review.</p>
<p class="cov"><b>Losses:</b> superficial and suspended losses, 40(2)(g), bad debts. <b>Gains:</b> 38–41, principal residence,
45, 44, 47, depreciable property, 110.6. <b>Corporate:</b> 85, 86, 87, 88(1), 84, 84.1, 55(2), capital dividends, corporate and
refundable taxes, GRIP. <b>Individuals:</b> 69, 70, 73, attribution, TOSI, dividends, interest, rates, credits,
minimum tax, pension splitting. <b>Relationships:</b>
related, affiliated, connected, loss restriction events.</p>
</div></div>

<div class="foot">Federal tax only; provincial tax is not computed. The examples are constructed, not client files. Canteen supports
professional judgment; it does not replace it, and nothing here is tax advice.</div>
<script>
mermaid.initialize({{ startOnLoad:false, theme:'base', themeVariables:{{ fontFamily:'Helvetica Neue, Arial', fontSize:'14px', lineColor:'#8c8c8c' }},
  flowchart:{{ htmlLabels:true, useMaxWidth:true, nodeSpacing:14, rankSpacing:26, curve:'basis' }} }});
Promise.resolve().then(()=>{{ window.__ready = true; }}).catch(e=>{{ document.body.insertAdjacentHTML('afterbegin','<p>'+e+'</p>'); window.__ready=true; }});
</script></body></html>'''
open(S+'/onepager3.html','w').write(page)
