import html
K={'fact':('#f0f0f0','#8a8a8a','#191919'),'step':('#d9f2dc','#2e7d32','#191919'),'judg':('#fde3d0','#e8590c','#191919'),
   'concl':('#2e7d32','#1b5e20','#ffffff'),'lane':('#ffffff','#ffffff','#5f5f5f')}
W=725; H=318
boxes={}
out=[f'<svg viewBox="0 0 {W} {H}" width="100%" role="img" aria-label="Reasoning map">',
 '<defs><marker id="ah" viewBox="0 0 8 8" refX="7.5" refY="4" markerWidth="7" markerHeight="7" orient="auto"><path d="M0,0 L8,4 L0,8 z" fill="#7a7a7a"/></marker></defs>']
def lane(y,h,label):
    out.append(f'<rect x="0" y="{y}" width="{W}" height="{h}" rx="6" fill="#fafbfc" stroke="#ececec"/>')
    out.append(f'<text x="8" y="{y+14}" font-size="9" font-weight="700" fill="#5f5f5f">{label}</text>')
def box(name,x,y,w,h,kind,lines,cite=None):
    f,s,t=K[kind]; boxes[name]=(x,y,w,h)
    out.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="5" fill="{f}" stroke="{s}" stroke-width="1.4"/>')
    n=len(lines)+(1 if cite else 0); lh=11.5; y0=y+h/2-(n*lh)/2+9
    for i,l in enumerate(lines):
        out.append(f'<text x="{x+w/2}" y="{y0+i*lh:.1f}" font-size="9.3" text-anchor="middle" fill="{t}" font-weight="{600 if kind=="concl" else 500}">{html.escape(l)}</text>')
    if cite:
        out.append(f'<text x="{x+w/2}" y="{y0+len(lines)*lh:.1f}" font-size="8" text-anchor="middle" fill="{"#1b5e20" if kind=="step" else "#5f5f5f"}" font-style="italic">{html.escape(cite)}</text>')
def side(name,which):
    x,y,w,h=boxes[name]
    return {'r':(x+w,y+h/2),'l':(x,y+h/2),'t':(x+w/2,y),'b':(x+w/2,y+h)}[which]
def arrow(a,sa,b,sb,curve=0):
    (x1,y1),(x2,y2)=side(a,sa),side(b,sb)
    if curve:
        mx,my=(x1+x2)/2,(y1+y2)/2+curve
        out.append(f'<path d="M{x1:.1f},{y1:.1f} Q{mx:.1f},{my:.1f} {x2:.1f},{y2:.1f}" fill="none" stroke="#7a7a7a" stroke-width="1.2" marker-end="url(#ah)"/>')
    else:
        out.append(f'<path d="M{x1:.1f},{y1:.1f} L{x2:.1f},{y2:.1f}" fill="none" stroke="#7a7a7a" stroke-width="1.2" marker-end="url(#ah)"/>')

lane(0,128,'2025 · CRYSTALLIZE')
lane(136,140,'2026 · THE STRIP')
# 2025
box('f1',10,30,135,44,'fact',['Opco shares: cost $100,','worth $2,000,000'])
box('s1',170,30,140,44,'step',['Transferred to Holdco,','elected at $1,250,100'],'ITA 85(1)')
box('s3',345,30,150,44,'step',['Holdco preferred shares','cost $1,250,100'],'ITA 85(1)(g)')
box('s2',530,30,185,44,'step',['$1,250,000 capital gain,','fully sheltered'],'ITA 110.6(2.1)')
box('j',530,84,185,38,'judg',['Judgment call: is Opco a small','business corporation? Yes (low risk)'])
arrow('f1','r','s1','l'); arrow('s1','r','s3','l'); arrow('s1','t','s2','t',curve=-34); arrow('j','t','s2','b')
# 2026
box('f2',10,166,135,44,'fact',['Holdco shares sold to','Newco for a $1,250,100 note'])
box('s4',170,166,140,44,'step',['Hard cost only $100:','sheltered gain taken off'],'ITA 84.1(2)(a.1)')
box('s5',345,166,150,44,'step',['$1,250,000 of the note','is a deemed dividend'],'ITA 84.1(1)(b)')
box('s6',530,150,185,36,'step',['Taxed: $1,437,500 of income'],'ITA 82(1)')
box('s7',530,196,185,44,'step',['$1,250,000 capital loss denied','as superficial; moves to Newco'],'ITA 54; 40(2)(g); 53(1)(f)')
box('f3',170,226,140,40,'fact',['Newco is controlled by','the taxpayer (affiliated)'])
arrow('f2','r','s4','l'); arrow('s4','r','s5','l'); arrow('s5','r','s6','l'); arrow('s5','r','s7','l'); arrow('f3','r','s7','l')
arrow('s3','b','s4','t')
out.append('<path d="M530,66 Q392,118 252,166" fill="none" stroke="#7a7a7a" stroke-width="1.2" marker-end="url(#ah)"/>')
# conclusion
box('k',170,284,545,30,'concl',['Conclusion: the crystallization works; the strip does not, and the loss moves to Newco\'s cost.'])
arrow('s5','b','k','t'); arrow('s7','b','k','t')
out.append('</svg>')
open('map.svg','w').write(''.join(out))
