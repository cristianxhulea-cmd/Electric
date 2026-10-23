# ElectroPlan

Aplicație web pentru proiectarea instalațiilor electrice rezidențiale, gândită pentru tabletă cu pen.

## Ce face

- **Plan**: desenezi camerele trăgând pe grilă, apoi plasezi tabloul, prizele, luminile, întrerupătoarele și consumatorii dedicați (mașină de spălat, aer condiționat, plită, cuptor, boiler). Elementele de perete se lipesc automat de cel mai apropiat perete.
- **Trasee automate**: de la tablou la doza de derivație din fiecare cameră, apoi la fiecare element, pe orizontală și verticală. Traseele orizontale trec la 30 cm sub tavan sau prin pardoseală.
- **Circuite și tablou**: grupează circuitele (iluminat, prize, consumatori dedicați), alege siguranța, secțiunea cablului după curentul admisibil și căderea de tensiune (3 % la iluminat, 5 % în rest, I7-2011), diferențialele de 30 mA, disjunctorul general și dimensiunea tabloului.
- **Materiale**: cablu pe secțiuni, cu rezervă, tub de protecție, doze, cleme, aparataj, corpuri de iluminat, echiparea tabloului și manopera. Introduci prețurile unitare și obții totalul. Tabelul se copiază direct în Excel.
- **Lucrări**: datele clientului, etape generate automat din proiect, cu ore estimate, panou De făcut / În lucru / Finalizat și progres.

Proiectele se salvează în browser. Din „Salvare / import” le copiezi ca text JSON pentru backup sau ca să le muți pe alt dispozitiv.

## Fișiere

- `electroplan.html`: sursa aplicației
- `index.html`: pagina completă, generată cu `./build.sh`
- `build.sh`: generează `index.html` din `electroplan.html`

## Rulare

Deschide `index.html` în browser sau activează GitHub Pages pe ramura principală.

> Rezultatele sunt orientative. Proiectul final se verifică și se semnează de un electrician autorizat ANRE.
