# Dokumentation av data

## Fil: medlemmar_AEA.csv 
Samtliga medlemmar inklusive studenter. Ej fyllda 65 år.

Variabel | Beskrivning |
--- | --- |
```year```  | |
```month```  | |
```Direktaviserade_AEA```	| |
```Forbundsaviserade_AEA```	| |
```Medlemmar_DIK_upp_till_65``` | |

## Fil: medlemmar_AEA_ej_stud.csv
Samtliga medlemmar **exklusive** studenter. Ej fyllda 65 år.

Variabel | Beskrivning |
--- | --- |
```year```  | |
```month```  | |
```Direktaviserade_AEA```	| |
```Forbundsaviserade_AEA```	| |
```Medlemmar_DIK_upp_till_65``` | |

## Fil: ers_ej_stud.csv
Antal ersättningstagare samt i program, < 65 år som ej studerar.

Variabel | Beskrivning |
--- | --- |
```year```  | |
```month```  | |
```ers_tagare```  | Antal ersättningstagare |
```akt_stod```	| Antal medlemmar i aktivitetsstöd (program hos Arbetsförmedlingen) |
```anst_m_stod``` | Anställning med stöd |

## ers_AEA.csv
Genomsnittlig ersättning och aktivitetsstöd i AEA. Hämtas från pdf.

Variabel | Beskrivning |
--- | --- |
```year```  | |
```month```  | |
```AEA_ansl_M```  | AEA anslutna män |
```AEA_ansl_K```  | AEA anslutna kvinnor |
```ers_tagare_M```  | Antal ersättningstagare, män |
```ers_tagare_K```  | Antal ersättningstagare, kvinnor |
```akt_stod_M```  | Antal medlemmar i aktivitetsstöd (program hos Arbetsförmedlingen), män |
```akt_stod_K```  | Antal medlemmar i aktivitetsstöd (program hos Arbetsförmedlingen), kvinnor |
```anst_m_stod_M``` | Anställda män med stöd |
```anst_m_stod_K``` | Anställda kvinnor med stöd |

## ers_by_interest_group.csv
Genomsnittlig ersättning och aktivitetsstöd i AEA. Hämtas från pdf.

Variabel | Beskrivning |
--- | --- |
```year```  | |
```month```  | |
```intressegrupp```  | Intressegrupp |
```antal```  | Antal medlemmar (?) |
```ers_tagare```  | Antal ersättningstagare |
```akt_stod```  | Antal i aktivitetsstöd (program hos Arbetsförmedlingen) |
```anst_m_stod``` | Anställda med stöd |

## ers_by_education.csv
ANDEL ERSÄTTNINGSTAGARE OCH PROGRAMDELTAGARE PER UTBILDNINGSINRIKTNING, <65 år STUDENTER BORTRÄKNADE

Variabel | Beskrivning |
--- | --- |
```year```  | |
```month```  | |
```utb_grupp```  | Utbildninginriktning |
```AEA_ansl```  | Antal AEA-anslutna |
```ers_tagare```  | Antal ersättningstagare |
```akt_stod```  | Antal medlemmar i aktivitetsstöd (program hos Arbetsförmedlingen) |
```anst_m_stod``` | Anställning med stöd |


## ers_by_education_level.csv
ANTAL ERSÄTTNINGSTAGARE OCH PROGRAMDELTAGARE PER UTBILDNINGNIVÅ.

Variabel | Beskrivning |
--- | --- |
```year```  | |
```month```  | |
```utb_niva```  | Utbildningsnivå |
```antal```  | Antal medlemmar (?) |
```ers_tagare```  | Antal ersättningstagare |
```i_prgm```  | Antal i program (?) |

## ers_by_county.csv

Variabel | Beskrivning |
--- | --- |
```year```  | |
```month```  | |
```county```  | Län (boende ?) |
```AEA_ansl```  | Antal AEA-anslutna |
```ers_tagare```  | Antal ersättningstagare |
```akt_stod```  | Antal medlemmar i aktivitetsstöd (program hos Arbetsförmedlingen) |
```anst_m_stod``` | Anställning med stöd |

## ers_by_age.csv

Variabel | Beskrivning |
--- | --- |
```year```  | |
```month```  | |
```age_group```  | Åldersgrupp |
```antal```  | Antal AEA-anslutna (? eller medlemmar ?) |
```ers_tagare```  | Antal ersättningstagare |
```akt_stod```  | Antal medlemmar i aktivitetsstöd (program hos Arbetsförmedlingen) |
```anst_m_stod``` | Anställning med stöd |

## ers_AEA.csv
Genomsnittlig ersättning och aktivitetsstöd i AEA. Hämtas från pdf.

Variabel | Beskrivning |
--- | --- |
```year```  | |
```month```  | |
```ers_tagare_p```  | Andel ersättningstagare AEA (i procent) |
```akt_stod_p```  | Andel i aktivitetsstöd (program hos Arbetsförmedlingen) AEA  (i procent) |


## arb_prgm_b.csv
ANTAL I ARBETSMARKNADSPOLITISKA PROGRAM <65 år.

Variabel | Beskrivning |
--- | --- |
```year```  | |
```month```  | |
```arb_mark_prgm```  | Antal i arbetsmarknadspolitiska program |
```prgm_utan_ers```  | Antal i arbetsmarknadspolitiska program utan ersättning |
```akt_stod```  | Aktivitetsstöd med arbetsmarknadspolitiska program från AF |
```ers_tagare_i_akt_stod```  | Aktivitetsstöd med arbetsmarknadspolitiska program från AF, antal ersättningstagare |
```anst_m_stod``` | Anställning med stöd |
```JUG``` |  |
```FAS3``` |  |
```annat``` | Övrigt |


## arb_prgm_a.csv 
ANTAL I ARBETSMARKNADSPOLITISKA PROGRAM <65 år

Variabel | Beskrivning |
--- | --- |
```year```  | |
```month```  | |
```arb_mark_prgm```  | Arbetsmarknadsprogram |
```antal```  | Antal medlemmar (?) i arbetsmarknadsprogram |

