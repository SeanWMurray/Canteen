import sys, re, html
S=sys.argv[1]; repo='/home/user/Canteen'
T1='#191919'; T2='#666666'; GRID='#e6e6e6'
prov=open(repo+'/docs/graphs/provisions.md').read()
edges=re.findall(r'(v\d+) --> (v\d+)', prov)
short={0:'54 "superficial loss"',1:'40(2)(g)(i)',2:'54, statute form',3:'53(1)(f)',4:'251.1(1)(a)',5:'251.1 affiliated',6:'251 related',
7:'251.1(2), 251(3.1)',8:'40(2)(g) facts',9:'40(2)(g)(ii)',10:'40(2)(g)(iii)',11:'40(2)(g)(iv)',12:'40(2)(g)',13:'40(3.3)–(3.5)',
14:'40(3.6)',15:'40(2)(e.1)',16:'40(2)(b) residence',17:'38–41 capital gains',18:'3 income',19:'111 net capital loss',20:'69(1)',
21:'73(1) rollover',22:'70(5), (6) death',23:'74.2',24:'45 change in use',25:'85(1) rollover',26:'84.1',27:'110.6 exemption',
28:'251.2 loss restriction',29:'74.1',30:'82(1), 121 dividends',31:'112, 55(2)',32:'13, 20(16)',33:'84(3) redemptions',
34:'83(2), 89(1)',35:'86 freeze',36:'44(1)',37:'47(1)',38:'186(4) connected',39:'84(4), 40(3)',40:'88(1) wind-up',41:'87 amalgamation',
42:'51 convertible',43:'117(2) rates',44:'118 personal',45:'118.1 donations',46:'120.4 split income',47:'2(2), 3 the year',
48:'39(4) election',49:'50(1)',50:'43(1)',51:'74.4(2)',52:'123–125 corporate rates',53:'50(2)'}
area={}
for v in [0,1,2,3,8,9,10,11,12,13,14,15,53]: area[v]='loss'
for v in [4,5,6,7,28,38]: area[v]='persons'
for v in [16,17,24,32,36,37,48,49,50]: area[v]='gains'
for v in [25,26,31,33,34,35,39,40,41,42,52]: area[v]='corp'
for v in [18,19,20,21,22,23,27,29,30,43,44,45,46,47,51]: area[v]='indiv'
assert len(area)==54
cols={'loss':'#257de0','persons':'#f47230','gains':'#00b894','corp':'#f2a600','indiv':'#ee7fac'}
tints={'loss':'#dbe9fa','persons':'#fde3d6','gains':'#ccf1ea','corp':'#fdedc7','indiv':'#fbe2ec'}
names=[('loss','Superficial and denied losses'),('persons','Related and affiliated persons'),('gains','Capital gains and property'),
       ('corp','Corporations'),('indiv','Individuals: attribution, death, income and tax')]
lines=['flowchart LR']
for v in range(54):
    lab=short[v].replace('"','#quot;')
    lines.append(f'  v{v}["{lab}"]:::{area[v]}')
for a,b in edges: lines.append(f'  {a} --> {b}')
for k in cols: lines.append(f'  classDef {k} fill:{tints[k]},stroke:{cols[k]},stroke-width:1.5px,color:{T1}')
provgraph='\n'.join(lines)
legend=''.join(f'<span class="lg"><i style="background:{tints[k]};border-color:{cols[k]}"></i>{n}</span>' for k,n in names)

memo=open(repo+'/docs/blueprint/crystallization.md').read()
i=memo.index('### What the Lean proofs use'); j=memo.index('```mermaid',i)+len('```mermaid'); k=memo.index('```',j)
memograph=memo[j:k].strip()

mlegend=''.join(f'<span class="lg"><i style="background:{f};border-color:{s}"></i>{n}</span>' for f,s,n in
  [('#c8e6c9','#2e7d32','Proven (a theorem)'),('#bbdefb','#1565c0','Encoded law'),('#eeeeee','#616161','Fact'),('#ffe0b2','#ef6c00','Judgment call')])

tiles=[('55','modules of the Income Tax Act'),('347','theorems, kernel-checked'),('850','tests and read-back checks'),
       ('7,353','declarations audited for axioms'),('11','memos, 10 worked transactions'),('78','interpretation choices for review')]
tiles_html=''.join(f'<div class="tile"><div class="v">{v}</div><div class="l">{l}</div></div>' for v,l in tiles)
memokey=('L1–L5 the law: 85(1), 84.1, 110.6, the superficial loss rule and 53(1)(f), 82(1). F1–F4 the facts. J-SBC: is Opco a small '
 'business corporation? A1–A7 the steps: the elected amount, the paid-up capital grind, the sheltered gain, the hard cost, the '
 '$1,250,000 dividend, its tax, the denied loss and Newco\'s cost. K the conclusion; W1 the other answer to J-SBC.')
css=f'''
@page {{ size: Letter; margin: 10mm 11mm; }}
* {{ box-sizing: border-box }}
body {{ font-family: "Helvetica Neue", Helvetica, Arial, sans-serif; color:{T1}; margin:0; font-size:8.6pt; line-height:1.36 }}
.top {{ display:flex; justify-content:space-between; align-items:flex-end; border-bottom:2px solid {T1}; padding-bottom:4pt }}
h1 {{ font-size:21pt; margin:0 }}
.tag {{ font-size:10pt; color:{T2}; margin-top:1pt }}
.meta {{ font-size:7.3pt; color:{T2}; text-align:right; white-space:nowrap; margin-left:12pt }}
.tiles {{ display:grid; grid-template-columns: repeat(6,1fr); gap:5pt; margin:6pt 0 5pt }}
.tile {{ background:#f6f8fb; border-radius:6px; padding:4pt 7pt }}
.tile .v {{ font-size:14pt; font-weight:600; line-height:1.1 }}
.tile .l {{ font-size:7.2pt; color:{T2}; margin-top:1pt }}
h2 {{ font-size:10pt; margin:4pt 0 1pt }}
.sub {{ font-size:7.5pt; color:{T2}; margin:0 0 2pt }}
p {{ margin:2pt 0 4pt }}
.lgs {{ margin:2pt 0 2pt; font-size:7.4pt; color:{T1} }}
.lg {{ display:inline-block; margin-right:9pt; white-space:nowrap }}
.lg i {{ display:inline-block; width:9px; height:9px; border:1.5px solid; border-radius:2px; margin-right:3px; vertical-align:-1px }}
.mermaid {{ text-align:center }}
#prov svg {{ width:100% !important; max-width:100% !important; height:auto; max-height:100mm }}
#memo svg {{ width:100% !important; max-width:100% !important; height:auto; max-height:54mm }}
.two {{ display:grid; grid-template-columns: 1.7fr 1fr; gap:12pt; align-items:start; margin-top:4pt }}
.key {{ font-size:7.4pt; margin:3pt 0 }}
.two .lg {{ margin-right:7pt }}
.foot {{ margin-top:4pt; border-top:1px solid {GRID}; padding-top:3pt; font-size:7.2pt; color:{T2} }}
'''
page=f'''<!DOCTYPE html><html><head><meta charset="utf-8"><title>Canteen</title><style>{css}</style>
<script src="{S}/mermaid.min.js"></script></head><body>
<div class="top"><div><h1>Canteen</h1>
<div class="tag">Canadian income tax law in Lean 4: every conclusion is a theorem the computer has checked.</div></div>
<div class="meta">Income Tax Act, consolidated to 2026-10-29<br/>Lean 4.36<br/>github.com/SeanWMurray/Canteen</div></div>
<div class="tiles">{tiles_html}</div>
<p>Each provision is written in Lean in the statute's own shape: its conditions, exceptions and citations. Given a transaction's
facts, a rule decides whether it applies, computes the amounts to the cent, and explains itself in numbered English steps citing
the Act. Judgment calls ("identical property", "all or substantially all") are never silently decided: each is named, both
answers are explored, and every conclusion lists the calls it relies on. The Lean kernel checks every claimed result.</p>

<h2>How the encoded provisions build on each other</h2>
<p class="sub">Each box is a provision encoded in Lean; an arrow runs from a provision to one whose encoding uses it. Read from the
compiled modules, not drawn by hand (arrows implied by others are left out).</p>
<div class="lgs">{legend}</div>
<div class="mermaid" id="prov">{html.escape(provgraph)}</div>
<h2>One memo, statement by statement: crystallizing the exemption, then stripping the cost</h2>
<p class="sub">The dependencies Lean finds inside the proofs (solid) and those stated only in the memo's reasoning (dotted). A memo
that uses something it does not declare fails to build.</p>
<div class="two">
<div class="mermaid" id="memo">{html.escape(memograph.replace('graph TD','graph LR',1))}</div>
<div><div class="lgs">{mlegend}</div>
<p class="key">{html.escape(memokey)}</p>
<p class="key">Result, all checked by the kernel: the 2025 gain of $1,250,000 is sheltered; the 2026 note is a $1,250,000
dividend under 84.1(2)(a.1); the matching capital loss is superficial, nil, and moves to Newco's cost. Every proof uses only
Lean's three standard axioms.</p></div>
</div>
<div class="foot">Constructed examples, not advice. The verbatim statute text for every encoded provision is in the repository.</div>
<script>
mermaid.initialize({{ startOnLoad:false, theme:'base', themeVariables:{{ fontFamily:'Helvetica Neue, Arial', fontSize:'15px', lineColor:'#9e9e9e' }},
  flowchart:{{ htmlLabels:true, useMaxWidth:true, nodeSpacing:8, rankSpacing:30, curve:'basis' }} }});
mermaid.run({{ querySelector: '.mermaid' }}).then(()=>{{ window.__ready = true; }}).catch(e=>{{ document.body.insertAdjacentHTML('afterbegin','<p>'+e+'</p>'); window.__ready=true; }});
</script></body></html>'''
open(S+'/onepager2.html','w').write(page)
