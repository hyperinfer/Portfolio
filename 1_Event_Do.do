*1. Event: Absturz der Boeing 737-Max-8 am 29. Oktober 2018*
*Die erste Eventstudy soll den aktuellen Fall der Boeing-737-Max8 Maschinen behandeln*
*Folgende User-Writte-Commands wurden installiert:
*<< asdoc >> Quelle: https://www.statalist.org/forums/forum/general-stata-discussion/general/1435798-asdoc-an-easy-way-of-creating-publication-quality-tables-from-stata-commands 
ssc install asdoc

*Import der Kursdaten*
import excel "C:\Users\Felix\OneDrive - studium.uni-hamburg.de\Studium VWL UHH\Semester 5\Empirische Stadt- und Immobilienökonomik\Eigene Inhalte\Daten\Event_737.xlsx", sheet("Kurse") firstrow

*Merge mit dem Event-Datensatz*
merge 1:1 Datum using "C:\Users\Felix\OneDrive - studium.uni-hamburg.de\Studium VWL UHH\Semester 5\Empirische Stadt- und Immobilienökonomik\Eigene Inhalte\STATA\1.Event\20181029_SET.dta", force
drop _merge

*Terminierung der Daten*
*Um in unserem festgelegten Eventwindow Arbeiten zu können, werden die einzelen Datum damit gekennzeichnet, wie viele Markttage sie vor bzw. nach eintreten des Events liegen.*
*Für spätere Regressionen wird auch ein quad. und cub. Term definiert*
gen Termin = 0
replace Termin = _n-101
gen Termin² = Termin^2
gen Termin³ = Termin^3

*Crash-Indikator*
*Zur Verwendung in einer späteren Regressionen definieren wir eine Dummy, die am Tag des Events den Wert Eins annimmt!"
gen Crash = 0
replace Crash = 1 if Termin == 0

*Korrektur der Toten-Variable*
*Für die spätere Regression muss allen Beobachtungen von Toten ein Wert zugewiesen werden*
replace Tote = 0 if Tote ==.

*Berechnung der Aktienpreisrendite der Boeing-Aktie*
gen Rendite_Boeing = (SchlusskursBoeing[_n] - SchlusskursBoeing[_n-1])/SchlusskursBoeing[_n-1]

*Berechnung der Aktienpreisrendite der Airbus-Aktie*
gen Rendite_Airbus = (SchlusskursAirbus[_n]-SchlusskursAirbus[_n-1])/SchlusskursAirbus[_n-1]

*Berechnung der Index-Rendite des Index*
gen Rendite_Index = (SchlusskursIndex[_n]-SchlusskursIndex[_n-1])/SchlusskursIndex[_n-1]

*Schätzung der erwarteten normalen Rendite*
*Um den Effekt unseres Events auf die Kurs- / Renditenentwicklung zu erkennen, muss eine Erwartung über die normale Entwicklung, ohne Eintritt des Events, gebildet werden.*
gen Renditeerwartung_Boeing =.
asdoc reg Rendite_Boeing Rendite_Index if Termin < 0, nest replace dec(7) save(ereg.doc)
predict p
replace Renditeerwartung_Boeing = p
drop p
gen Renditeerwartung_Airbus =.
asdoc reg Rendite_Airbus Rendite_Index if Termin < 0, nest append dec(7) save(ereg.doc)
predict p
replace Renditeerwartung_Airbus = p
drop p

*Bestimmung der abnormalen Renditen*
*Aus der Differenz von tatsächlicher und erwarteter Rendite können nun die abnormalen Renditen berechnet werden.*
gen Abnormal_Boeing = Rendite_Boeing - Renditeerwartung_Boeing
gen Abnormal_Airbus = Rendite_Airbus - Renditeerwartung_Airbus

*Bestimmung der durschnittlichen abnormalen Renditen*
*Um die Entwicklung der abnormalen Renditen besser in Relation zum Zeitraum vor und nach Eintritt des Events bestimmen zu können, werden die dursch. Werte pro Tag berechnet*
gen avg_Abnormal_Boeing = (sum(Abnormal_Boeing))/_n
gen avg_Abnormal_Airbus = (sum(Abnormal_Airbus))/_n

*Bestimmung der kumulierten abnormalen Renditen*
*Um schließlich spezifischere Rückschlüsse auf die Auswirkung des Events in unserem Eventwindow erkennen zu können, werden die dursch. abnormalen Rendite in diesem Zeitraum kumuliert*
gen cum_avg_Abnormal_Boeing =.
replace cum_avg_Abnormal_Boeing = avg_Abnormal_Boeing[_n] if Termin == 0
replace cum_avg_Abnormal_Boeing = cum_avg_Abnormal_Boeing[_n-1]+avg_Abnormal_Boeing[_n] if Termin > 0
gen cum_avg_Abnormal_Airbus =.
replace cum_avg_Abnormal_Airbus = avg_Abnormal_Airbus[_n] if Termin == 0
replace cum_avg_Abnormal_Airbus = cum_avg_Abnormal_Airbus[_n-1]+avg_Abnormal_Airbus[_n] if Termin > 0

*Signifikanztest*
*Die jeweiligen Testergebnisse werden mit dem asdoc-Befehl zur weiteren Verwendung exportiert*
*Die für unsere Analyse relevanten Abnormalen Renditen müssen nun auf Signifikanz getestet werden, um sicher zu stellen, dass diese überhaupt vorliegen, also verschieden von Null sind*
asdoc ttest avg_Abnormal_Boeing == 0, replace dec(3) save(Test.doc)
asdoc ttest avg_Abnormal_Airbus == 0, rowappend dec(3) save(Test.doc)
asdoc ttest cum_avg_Abnormal_Boeing == 0, rowappend dec(3) save(Test.doc)
asdoc ttest cum_avg_Abnormal_Airbus == 0, rowappend dec(3) save(Test.doc)

*Schätzung der kummulierten Effekte*
*Der Gesamteffekt des Ereignisses im betrachteten Eventwindow wird mithilfe einiger Einflussgrößen geschätzt*
*Die Ergebnisse der Regressionen werden zur weiteren Verwendung exportiert*
asdoc reg cum_avg_Abnormal_Boeing Termin Termin² Termin³ Tote, replace wide stars dec(7) save(CAAreg.doc)
asdoc reg cum_avg_Abnormal_Airbus Termin Termin² Termin³ Tote, wide stars dec(7) save(CAAreg.doc)

*Ereignisbasierte Regression*
*Neben der Analyse innerhalb des Eventwindows führen wir eine Regression mit den tatsächlichen Größen durch, die direktere quantitative Effekte des Events liefert*
*Die Ergebnisse der Regressionen werden zur weiteren Verwendung exportiert*
asdoc reg Rendite_Boeing Rendite_Index Rendite_Airbus Crash, nest replace dec(7) save(Rreg_Bi.doc)
asdoc reg Rendite_Airbus Rendite_Index Rendite_Boeing Crash, nest append dec(7) save(Rreg_Bi.doc)

asdoc reg Rendite_Boeing Rendite_Index Rendite_Airbus Tote, nest replace dec(7) save(Rreg_Qu.doc)
asdoc reg Rendite_Airbus Rendite_Index Rendite_Boeing Tote, nest append dec(7) save(Rreg_Qu.doc)

*Graph plotten*
*Zur besseren Visualisierung von tatsächlichen und geschätzten Kursen werden die Werte geplottet.*
*Änderungen an der Beschriftung des Graphen wurden der Einfachheit halber im Stata internen Grafikeditor vorgenommen*
graph twoway (lpoly Rendite_Boeing Termin, degree(20)) (lpoly Renditeerwartung_Boeing Termin, degree(20))

*Export der Ergebnisse*
*Zur Weiterverwendung werden die Ergebnisse der berechneten Größen in Excel exportiert*
export excel Termin Abnormal_Boeing avg_Abnormal_Boeing cum_avg_Abnormal_Boeing Abnormal_Airbus avg_Abnormal_Airbus cum_avg_Abnormal_Airbus using "Results" in 101/151, firstrow(variables) replace
