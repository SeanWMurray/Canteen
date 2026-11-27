import Canteen.ITA.S216.RentalElection

/-!
# Tests: a non-resident's rent, Part XIII or the 216(1) election

A non-resident individual rents out a condominium in Toronto in 2025. Constructed examples.
-/

namespace Canteen.Tests.RentalElection

open Canteen Canteen.ITA Canteen.ITA.RentalElection

-- $30,000 of rent; $10,000 net after expenses and capital cost allowance.
def condo : Facts := { taxationYear := 2025, grossRent := 3000000, netIncome := 1000000 }
-- Part XIII: 25% of the gross, $7,500.
example : partXIII condo = 750000 := by decide
-- Electing: 14% of $10,000, $1,400, plus 48%, $672: $2,072; it saves $5,428.
example : basicTax condo = 140000 ∧ surtax condo = 67200 ∧ electedTax condo = 207200 := by decide
example : saving condo = 542800 := by decide
-- Personal credits only if substantially all income is earned in Canada (118.94).
example : electedTax { condo with personalCredits := 203532 } = 207200 := by decide
example : electedTax { condo with personalCredits := 203532, substantiallyAllInCanada := true } = 0 := by decide
-- A large net income: $200,000 net on $220,000 of rent: electing costs more than Part XIII.
def tower : Facts := { taxationYear := 2025, grossRent := 22000000, netIncome := 20000000 }
example : saving tower < 0 := by decide

end Canteen.Tests.RentalElection
