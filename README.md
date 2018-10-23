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
devtools::install_github(repo = "DIK_analys", username = "MansMeg", subdir = "Package")
library(DIK)
```


# Att hantera DIK:s arbetslöshetsstatistik

Statistikhanteringen består av två delar. Updatera filerna och göra analyser. För att uppdatera filerna med data från AEA körs koden i `unemployment_stat.R`.

För att göra analyser körs de Rmd-filer som finns i Reports. 


# API to AEA
AEA levererar filer för beräkning på följande format (csv) med variablerna:
```
manad [char](6),
forbund [char](2),
postnr [char](5),
alder [smallint],
kon [char](1),
lan [varchar](35),
ers [char](1),
utbprogram [varchar](35),
infopost [char](1),
avisering [varchar](10),
stat1 [varchar](50),
stat2 [varchar](50),
stat3 [varchar](50),
stat4 [varchar](50),
stat5 [varchar](50)
```

Detaljerad information om filen:
```
månad=månad statistiken gäller ÅÅÅÅMM
alder= faktisk ålder. Gränsen går vid slutet av statistikmånaden. Om statistikmånaden är 201506 räknas alla som fyller 20150630 eller tidigare som att ha fyllt. De som fyller 20160701 och senare har inte fyllt.
kon = M eller K
ers = X om personen fått ersättning under månaden
utbprogram=Det program som personen ev går på
infopost = X eller tom
avisering = Förbund eller Annat eller tom
stat1-stat5 = de fält som ni själva skickar med i utgångsfilen.
```
För information kontakta:
[bengt.astrom@aea.se](mailto:bengt.astrom@aea.se)
