# ElectroPlan

Aplicație web pentru proiectarea instalațiilor electrice rezidențiale, gândită pentru tabletă cu pen.

## Ce face

- **Plan**: desenezi camerele trăgând pe grilă, apoi plasezi tabloul, prizele, luminile, întrerupătoarele și consumatorii dedicați (mașină de spălat, aer condiționat, plită, cuptor, boiler). Elementele de perete se lipesc automat de cel mai apropiat perete.
- **Editare**: cu „Selectează” atingi o cameră, o ușă sau un element. Bara de sus arată ce ai selectat, cu butoanele „Șterge” și „Închide”. Camerele se redimensionează trăgând de colțuri și de laturi, iar prizele și ușile de pe perete se mută odată cu el. Orice modificare se anulează cu ↶.
- **Uși**: le pui pe perete cu un tap, alegi lățimea, partea balamalelor și sensul de deschidere. Aplicația verifică regulile din I7 pentru zona de lângă uși:
  - niciun aparat în golul ușii sau la mai puțin de 10 cm de toc (zona verticală de instalare are 10–30 cm);
  - întrerupătorul stă pe partea clanței, nu în spatele ușii deschise; când îl pui lângă o ușă, se poziționează singur la 20 cm de toc;
  - fiecare cameră cu lumini are un întrerupător lângă o ușă, iar tabloul nu stă în spatele ușii.
- **Ferestre**: le pui pe perete cu un tap, alegi lățimea, parapetul și înălțimea golului sau le marchezi ca uși de balcon. Aparatele de sub parapet sunt permise. Cele aflate în dreptul golului sau la mai puțin de 10 cm de toc sunt marcate cu roșu.
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
