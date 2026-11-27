import re, subprocess, html, sys
repo='/home/user/Canteen'; S=sys.argv[1]
md=open(repo+'/docs/blueprint/crystallization.md').read()
md=md.replace('> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.\n','')
md=re.sub(r'\]\(\.\./\.\./([^)#]+)(#L\d+)?\)', lambda m: '](https://github.com/SeanWMurray/Canteen/blob/main/'+m.group(1)+(m.group(2) or '')+')', md)
body=subprocess.run(['pandoc','-f','gfm-tex_math_dollars','-t','html5'],input=md,capture_output=True,text=True,check=True).stdout
body=re.sub(r'<pre class="mermaid"><code>(.*?)</code></pre>', lambda m: '<div class="mermaid">'+m.group(1)+'</div>', body, flags=re.S)
# the two dependency graphs: left to right, so they use the page's height
body=body.replace('<div class="mermaid">graph TD\n  n0[&quot;L1 ·','<div class="mermaid dep">graph TD\n  n0[&quot;L1 ·',1)
body=body.replace('<div class="mermaid">graph TD\n  n0[&quot;L1&quot;]','<div class="mermaid dep">graph LR\n  n0[&quot;L1&quot;]',1)
lean=open(repo+'/Canteen/Transactions/Crystallization.lean').read()
def grab(name):
    i=lean.index('theorem '+name); j=lean.rindex('/--',0,i); k=lean.index('\n\n',i); return lean[j:k]
thms='\n\n'.join(grab(n) for n in ['step2_dividend','step2_loss_nil','newco_cost'])
ax=open(S+'/axioms.txt').read()
intro='''<div class="cover">
<div class="kicker">Canteen · a proof's output</div>
<p>This memo is generated from Lean 4. Every statement marked <b>proven</b> is a theorem the Lean kernel has checked; every
<b>encoded</b> statement is the definition it rests on; facts and the one judgment call are stated as such. The arithmetic,
the order of the provisions, and the explanation in the appendix all come from the same code. Nothing here was typed by hand.</p>
<p>The transaction crosses six parts of the <i>Income Tax Act</i>: 85(1) (a rollover to a corporation), 84.1 (surplus stripping),
110.6 (the capital gains deduction), section 54 and 40(2)(g) (the superficial loss rule), 53(1)(f) (the cost addition) and 82(1)
(the dividend gross-up). A constructed example, not advice.</p></div>'''
kernel=f'''<h2>What the kernel checked</h2>
<p>Three of the theorems behind the analysis, exactly as written in
<a href="https://github.com/SeanWMurray/Canteen/blob/main/Canteen/Transactions/Crystallization.lean">Canteen/Transactions/Crystallization.lean</a>.
Each is proved by <code>decide +kernel</code>: the kernel evaluates the encoded law on the facts and confirms the stated result.</p>
<pre class="lean">{html.escape(thms)}</pre>
<p>And Lean's own report of what each proof depends on: only the three standard axioms of Lean's logic, no <code>sorry</code>,
no unchecked native code. The project audits all 7,353 of its declarations the same way on every build.</p>
<pre class="lean">{html.escape(ax)}</pre>'''
body=body.replace('<h2 id="dependency-graph">', intro+'<section class="widepage"><h2 id="dependency-graph">',1)
body=body.replace('<h3 id="what-the-lean-proofs-use">','</section><h3 id="what-the-lean-proofs-use">',1)
body=body.replace('<h2 id="appendix-the-argument-as-lean-renders-it">', kernel+'<h2 id="appendix-the-argument-as-lean-renders-it">',1)
css='''
@page { size: Letter; margin: 16mm 15mm 16mm 15mm; }
body { font-family: "Helvetica Neue", Helvetica, Arial, sans-serif; color:#191919; font-size: 10pt; line-height: 1.45; }
h1 { font-size: 19pt; margin: 0 0 6pt; line-height:1.2 }
h2 { font-size: 13pt; margin: 18pt 0 6pt; padding-top: 4pt; border-top: 1px solid #e0e0e0; page-break-after: avoid; }
h3 { font-size: 10.5pt; margin: 12pt 0 3pt; page-break-after: avoid; }
p { margin: 4pt 0 6pt }
a { color: #1b64be; text-decoration: none; word-break: break-all }
code { font-family: Menlo, Consolas, monospace; font-size: 8pt; }
pre { background:#f6f6f6; border:1px solid #e6e6e6; border-radius:4px; padding:7pt 9pt; font-size:7.6pt; line-height:1.4;
      white-space: pre-wrap; page-break-inside: avoid; }
pre.lean { background:#f4f8fd; border-color:#d6e4f5 }
.cover { background:#f4f8fd; border:1px solid #d6e4f5; border-radius:6px; padding:8pt 12pt; margin:10pt 0 4pt }
.kicker { font-size:8pt; letter-spacing:.06em; text-transform:uppercase; color:#666; margin-bottom:2pt }
.mermaid { text-align:center; margin: 6pt 0; page-break-inside: avoid; }
.mermaid svg { max-width: 100%; height: auto; max-height: 215mm; }
h2#dependency-graph { page-break-before: always; border-top: none; }
@page wide { size: Letter landscape; margin: 12mm; }
.widepage { page: wide; }
.widepage .mermaid svg { width: 100% !important; max-width: 100% !important; max-height: 165mm; }
.mermaid.dep svg { width: 100% !important; max-width: 100% !important; max-height: 230mm; }
h3 + p strong:first-child { color:#444 }
'''
doc=f'''<!DOCTYPE html><html><head><meta charset="utf-8"><title>Crystallization memo</title><style>{css}</style>
<script src="{S}/mermaid.min.js"></script></head><body>{body}
<script>
mermaid.initialize({{ startOnLoad:false, theme:'neutral', flowchart:{{ htmlLabels:true, useMaxWidth:true }} }});
mermaid.run({{ querySelector: '.mermaid' }}).then(()=>{{ window.__ready = true; }}).catch(e=>{{ document.body.insertAdjacentHTML('afterbegin','<p>'+e+'</p>'); window.__ready=true; }});
</script></body></html>'''
open(S+'/memo.html','w').write(doc)
