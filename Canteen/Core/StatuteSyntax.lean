import Canteen.Core.Statute

/-!
# The `statute` command

Write a rule in a form close to the statute's own text:

```lean
statute ruleX (f : XFacts) named "Rule X" cites "s.X"
  applies where
    | (a) f.condA => "Condition A is met." else "Condition A is not met."
    | (b) judgment "J-B" f.condB => "Condition B is met." else "Condition B is not met."
  except where
    | (c) f.exception => "The exception applies." else "The exception does not apply."
```

This defines `ruleX : Rule XFacts` with `Rule.statute`, so it is sound with nothing to
prove. Each clause is one of:

* `| (a) test => "sentence if met" else "sentence if not met"`: a condition on the facts;
* `| (b) judgment "J-B" test => …`: a condition that rests on judgment call `J-B`;
* `| (b) judgments ids test => …`: one resting on the judgment calls `ids : List String`,
  computed from the facts (written as an atomic term, e.g. in parentheses);
* `| (a) := r`: another rule `r` (written as an atomic term, e.g. `(other.comap g)`),
  with its own explanation.

A label is `(ident)`, e.g. `(a)` or `(i)`, or a string, e.g. `"(e.1)"` or `"opening words"`.
Each clause is cited as the rule's citation followed by its label: `s.X(a)`.

The words `named`, `cites`, `applies`, `except`, `judgment` and `judgments` are not
reserved, so they remain usable as ordinary names elsewhere.
-/

namespace Canteen.StatuteSyntax

open Lean

declare_syntax_cat statuteLabel
syntax "(" ident ")" : statuteLabel
syntax str : statuteLabel

declare_syntax_cat statuteClause
syntax (name := clauseRule) "| " statuteLabel " := " term:max : statuteClause
syntax (name := clauseJudgment) "| " statuteLabel &"judgment" str term " => " str " else " str : statuteClause
syntax (name := clauseJudgments) "| " statuteLabel &"judgments" term:max term " => " str " else " str : statuteClause
syntax (name := clausePlain) "| " statuteLabel term " => " str " else " str : statuteClause

syntax (docComment)? "statute " ident " (" ident " : " term ") " &"named" str &"cites" str
  &"applies" " where " statuteClause+ (&"except" " where " statuteClause+)? : command

/-- The label as written: `(a)` or a string. -/
def labelText : TSyntax `statuteLabel → MacroM String
  | `(statuteLabel| ($i:ident)) => return s!"({i.getId.toString})"
  | `(statuteLabel| $s:str) => return s.getString
  | _ => Macro.throwUnsupported

/-- Where a clause also parses as a plain condition (e.g. `judgment "J-B" f.condB` read as
an application of a function named `judgment`), prefer the keyword reading. -/
def disambiguate (c : TSyntax `statuteClause) : TSyntax `statuteClause :=
  if c.raw.isOfKind choiceKind then
    match c.raw.getArgs.find? (fun alt => !alt.isOfKind ``clausePlain) with
    | some alt => ⟨alt⟩
    | none => ⟨c.raw.getArg 0⟩
  else c

/-- One clause, as a `Rule` term. Clauses are taken apart by kind and position, not by
quotation patterns, which would be ambiguous in the same way as the clauses themselves. -/
def clauseTerm (cite : TSyntax `str) (fv : Ident) (ty : Term) (c : TSyntax `statuteClause) : MacroM Term := do
  let c := disambiguate c
  let a (i : Nat) := c.raw.getArg i
  let label : MacroM (TSyntax `str) := do
    return Syntax.mkStrLit (← labelText ⟨a 1⟩)
  let mk (lbl : TSyntax `str) (t : Term) (m n : TSyntax `str) (rel : Term) : MacroM Term :=
    `(Canteen.Rule.clause $lbl (Canteen.Rule.subCitation $cite $lbl) (fun ($fv : $ty) => $t) $m $n $rel)
  match c.raw.getKind with
  | ``clauseRule => return ⟨a 3⟩
  | ``clauseJudgment =>
    let j : TSyntax `str := ⟨a 3⟩
    mk (← label) ⟨a 4⟩ ⟨a 6⟩ ⟨a 8⟩ (← `(fun _ => [$j]))
  | ``clauseJudgments =>
    let js : Term := ⟨a 3⟩
    mk (← label) ⟨a 4⟩ ⟨a 6⟩ ⟨a 8⟩ (← `(fun ($fv : $ty) => $js))
  | ``clausePlain =>
    mk (← label) ⟨a 2⟩ ⟨a 4⟩ ⟨a 6⟩ (← `(fun _ => []))
  | k => Macro.throwErrorAt c s!"unrecognized statute clause ({k})"

macro_rules
  | `($[$doc:docComment]? statute $name:ident ($fv:ident : $ty:term) named $n:str cites $c:str
        applies where $conds:statuteClause* $[except where $excs:statuteClause*]?) => do
    let cs ← conds.mapM (clauseTerm c fv ty)
    let es ← (excs.getD #[]).mapM (clauseTerm c fv ty)
    `($[$doc:docComment]? def $name : Canteen.Rule $ty := Canteen.Rule.statute $n $c [$cs,*] [$es,*])

end Canteen.StatuteSyntax
