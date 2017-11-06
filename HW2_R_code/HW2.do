

import excel "/Users/malooney/Google Drive/digitalLibrary/*Econometrics3/Econometrics3/HW2_R_code/CreditScoring.xlsx", sheet("CreditScoring") firstrow

destring LOGSPEND, replace
destring SPENDING, replace

gen Ln_income= log(INCOME)

reg LOGSPEND Ln_income AGE ADEPCNT OWNRENT

tobit LOGSPEND Ln_income AGE ADEPCNT OWNRENT, ll(0)

mfx compute, predict(pr(0,.))

mfx compute, predict(e(0,.))

heckman LOGSPEND Ln_income AGE ADEPCNT OWNRENT, select(CARDHLDR Ln_income AGE ADEPCNT OWNRENT)

heckman LOGSPEND Ln_income AGE ADEPCNT OWNRENT, select(CARDHLDR Ln_income AGE ADEPCNT OWNRENT) twostep

mfx compute, predict(pr(0,.))

mfx compute, predict(e(0,.))
