*Import der Event-Daten*
import excel "C:\Users\Felix\OneDrive - studium.uni-hamburg.de\Studium VWL UHH\Semester 5\Empirische Stadt- und Immobilienökonomik\Eigene Inhalte\Daten\Event_737.xlsx", sheet("Event") firstrow

*Anpassung des Datums an das Masterformat*
gen int Dat = date(Datum, "DMY")
format Dat %tdnn/dd/CCYY
drop Datum
rename Dat Datum
