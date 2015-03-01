DIK analys
==========

R-paket och kod för statistik och analys vid DIK, akademikerfacket för kultur och kommunikation.

# Att hantera DIK:s arbetslöshetsstatistik

## Programvara som behöver vara installerad
- [R](http://www.r-project.org/)
- [R-Studio](http://www.rstudio.com/)
- [Git](http://git-scm.com/)

Om PDF:er ska kunna produceras direkt behöver också [MikTeX](http://git-scm.com/) vara installerat.


# Installera R-paketet DIK

I paketet `DIK` finns en hel del funktionalitet för att hantera AEA-filer och smmanställa dessa. Använd `devtools` (kan behöva installeras med `install.package()`) för att installera paketet:

```r
devtools::install_github(repo = "DIK_analys", username = "MansMeg")
library(DIK)
```

# Att hantera DIK:s arbetslöshetsstatistik

Statistikhanteringen består av två delar. Updatera filerna och göra analyser. För att uppdatera filerna med data från AEA körs koden i `unemployment_stat.R`.

För att göra analyser körs de Rmd-filer som finns i Reports. 



