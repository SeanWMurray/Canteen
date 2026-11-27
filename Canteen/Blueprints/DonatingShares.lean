import Canteen.Core.Blueprint
import Canteen.Transactions.DonatingShares

/-!
# Memo: donating shares in kind, or selling them and donating the cash
-/

namespace Canteen.Blueprints.DonatingShares

open Canteen Canteen.Blueprint Canteen.ITA Canteen.Transactions.DonatingShares

def memo : Blueprint where
  title := "Memo: donating shares in kind, or selling them and donating the cash"
  summary := [
    "**Issue.** An individual with a $200,000 salary wants to give a charity $50,000, and owns public-company shares " ++
      "worth $50,000 that cost $10,000. Should they donate the shares, or sell them and donate the cash?",
    "**Conclusion.** Donate the shares. The gain on shares given to a qualified donee is taxed at nil (A1), while selling " ++
      "first adds $20,000 of taxable capital gain (A2). The donation credit is $14,470 either way (A3), but the higher " ++
      "income also trims the basic personal amount (A4). Federal tax is $26,163.69 in kind against $32,063.85 (A5): a " ++
      "saving of $5,900.16 (K). The minimum tax does not apply (A6); for a $1,000,000 gift it would, either way, and " ++
      "donating in kind would still save $34,243.00 (W1). Provincial tax is not computed.",
    "This is a constructed example, not advice on a real transaction."]
  sections := [
    { heading := "The law"
      nodes := [
        { id := "L1", kind := .law, title := "Gifts of listed securities", citation := "ITA 38(a.1)(i)"
          statement := "The taxable capital gain on a gift of a listed security to a qualified donee is nil."
          lean := [``CapitalGains.Disposition.taxableCapitalGain] },
        { id := "L2", kind := .law, title := "The individual's year and federal tax", citation := "ITA 3; 117(2); 118(1); 118.1(3)"
          statement := "Income, taxable income, tax at the 117(2) rates, less the personal and donation credits."
          lean := [``IndividualYear.income, ``IndividualYear.federalTax, ``IndividualYear.personalCredit,
            ``IndividualYear.donationCredit], uses := ["L1"] } ] },
    { heading := "Facts"
      nodes := [
        { id := "F1", kind := .fact, title := "The individual and the shares"
          statement := "A $200,000 salary in 2025; public-company shares costing $10,000, worth $50,000; a $50,000 gift."
          lean := [``shares, ``year, ``inKind, ``cash] } ] },
    { heading := "Analysis"
      nodes := [
        { id := "A1", kind := .step, title := "In kind: no taxable gain", citation := "ITA 38(a.1)(i)"
          statement := "The $40,000 gain is taxed at nil; income is the $200,000 salary."
          lean := [``in_kind_no_gain], uses := ["F1", "L1", "L2"] },
        { id := "A2", kind := .step, title := "Selling first: $20,000 of taxable gain", citation := "ITA 38(a); 3(b)"
          statement := "Half the $40,000 gain is taxable: income is $220,000."
          lean := [``cash_gain], uses := ["F1", "L1", "L2"] },
        { id := "A3", kind := .step, title := "The same donation credit", citation := "ITA 118.1(3)"
          statement := "$50,000 of gifts is within the limit either way: 14% of $200 and 29% of $49,800, $14,470."
          lean := [``same_donation_credit], uses := ["F1", "L2"] },
        { id := "A4", kind := .step, title := "A smaller personal credit when selling", citation := "ITA 118(1.1)"
          statement := "At $220,000 more of the enhanced basic personal amount is phased out: $1,889.06 against $1,989.22."
          lean := [``personal_credits], uses := ["A1", "A2", "L2"] },
        { id := "A5", kind := .step, title := "Federal tax", citation := "ITA 117(2)"
          statement := "$26,163.69 in kind; $32,063.85 selling first."
          lean := [``federal_tax], uses := ["A1", "A2", "A3", "A4"] } ] },
    { heading := "Conclusion"
      nodes := [
        { id := "K", kind := .conclusion, title := "Donating in kind saves $5,900.16"
          statement := "The difference in federal tax is $5,900.16, all from the gain that selling first makes taxable."
          lean := [``saving], uses := ["A5"] } ] },
    { heading := "What if"
      nodes := [
        { id := "L3", kind := .law, title := "The minimum tax", citation := "ITA 127.5; 127.51; 127.52(1)(d), (d.1); 127.531"
          statement := "At least 20.5% of adjusted taxable income over $177,882, less half the personal credit and 4/5 of the " ++
            "donation credit; for it, capital gains count in full and gains on gifts of listed securities at 3/10."
          lean := [``MinimumTax.adjustedTaxableIncome, ``MinimumTax.minimumAmount, ``MinimumTax.taxPayable], uses := ["L2"] },
        { id := "A6", kind := .step, title := "No minimum tax on this gift", citation := "ITA 127.5"
          statement := "The minimum amount is nil in kind and $213.66 selling first, below regular tax either way."
          lean := [``no_minimum_tax], uses := ["F1", "L3"] },
        { id := "W1", kind := .step, title := "A $1,000,000 gift", citation := "ITA 127.52(1)(d.1)"
          statement := "Shares worth $1,000,000 that cost $200,000: in kind, no regular tax but $17,963.58 of minimum tax; " ++
            "selling first, $52,206.58 of minimum tax. In kind saves $34,243.00. Unclaimed gifts carry forward five years."
          lean := [``bigShares, ``bigYear, ``big_in_kind, ``big_cash, ``big_saving], uses := ["L1", "L2", "L3"] } ] } ]
  diagrams := []
  appendix := [
    ("The year, donating in kind", (IndividualYear.explain inKind).renderWithJudgments []),
    ("The year, selling first", (IndividualYear.explain cash).renderWithJudgments [])]

end Canteen.Blueprints.DonatingShares
