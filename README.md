# ElectroPlan

Aplicație web pentru proiectarea instalațiilor electrice rezidențiale, gândită pentru tabletă cu pen.

## Ce face

- **Plan**: desenezi camerele trăgând pe grilă, apoi plasezi tabloul, prizele, luminile, întrerupătoarele și consumatorii dedicați (mașină de spălat, aer condiționat, plită, cuptor, boiler). Elementele de perete se lipesc automat de cel mai apropiat perete.
- **Editare**: cu „Selectează” atingi o cameră, o ușă sau un element. Bara de sus arată ce ai selectat, cu butoanele „Șterge” și „Închide”. Camerele se redimensionează trăgând de colțuri și de laturi, iar prizele și ușile de pe perete se mută odată cu el. Orice modificare se anulează cu ↶.
- **Goluri și camere unite**: cu „Gol perete” ștergi o porțiune de perete, trăgând de-a lungul ei. Din Detalii, „Unește cu…” face dintr-un dreptunghi continuarea camerei vecine, de exemplu un hol în formă de L: peretele dintre ele dispare, numele, tipul și suprafața devin comune, iar elementele aparțin aceleiași camere. „Separă” anulează unirea.
- **Uși**: le pui pe perete cu un tap, alegi lățimea, partea balamalelor și sensul de deschidere. Aplicația verifică regulile din I7 pentru zona de lângă uși:
  - niciun aparat în golul ușii sau la mai puțin de 10 cm de toc (zona verticală de instalare are 10–30 cm);
  - întrerupătorul stă pe partea clanței, nu în spatele ușii deschise; când îl pui lângă o ușă, se poziționează singur la 20 cm de toc;
  - fiecare cameră cu lumini are un întrerupător lângă o ușă, iar tabloul nu stă în spatele ușii.
- **Ferestre**: le pui pe perete cu un tap, alegi lățimea, parapetul și înălțimea golului sau le marchezi ca uși de balcon. Aparatele de sub parapet sunt permise. Cele aflate în dreptul golului sau la mai puțin de 10 cm de toc sunt marcate cu roșu.
- **Structură**: marchezi pereții de rezistență (trasezi de-a lungul peretelui) și grinzile (trasezi pe plan). Nu se taie și nu se găuresc fără acordul proiectantului de structură. Aplicația:
  - nu pune doze de derivație pe pereții de rezistență;
  - marchează aparatele de pe acești pereți și traseele care îi străpung sau merg în lungul lor;
  - marchează cu ✕ roșu fiecare loc în care un traseu de sub tavan traversează o grindă.
- **Doze**: dozele de derivație stau pe perete, în zona orizontală de sub tavan, ocolind golurile ușilor și ferestrelor și pereții de rezistență. Sunt numerotate D1, D2…; în „Circuite” găsești tabelul cu camera, peretele, distanța de la colț și înălțimea fiecăreia.
- **Trasee separate**: din lista de jos, din legenda circuitelor sau cu „Vezi traseul” alegi un circuit și vezi doar traseul lui, cu lungimea fiecărei porțiuni.
- **Trasee editabile**: atingi un traseu și tragi de oricare porțiune ca s-o muți; dozele de derivație le tragi pe alt perete al camerei. „Traseu automat” sau „Poziție automată” anulează modificarea.
- **Baia**: are circuite dedicate pentru iluminat, prize și consumatori, toate protejate cu diferențial de 30 mA. Traseele altor camere nu intră în baie și nu merg prin pereții ei. Ocolesc automat, iar dacă un traseu desenat manual trece prin baie, este marcat.
- **Doze puse de tine**: mică (Ø80), medie (100×100) sau mare (160×100), pe orice perete, chiar înainte de tablou. Circuitele din cameră trec prin doza ta. Unde nu pui, aplicația alege singură poziția și mărimea după numărul de cabluri și te avertizează când o doză e prea mică.
- **Doze comune**: implicit, luminile și prizele din aceeași cameră folosesc aceeași doză de derivație, mărită după numărul de cabluri. Se poate dezactiva din „Proiect și circuite”.
- **Priză multiplă**: 1–5 posturi în aceeași ramă, numărul se alege din Detalii. Fiecare post contează ca o priză la limita de prize pe circuit și primește doza lui de aparataj.
- **Priză TV**: priză dublă Schuko și priză TV/SAT în aceeași ramă. Cablul coaxial se socotește separat, în tub propriu, despărțit de cablurile de forță.
- **Trasee automate**: de la tablou la doza de derivație din fiecare cameră, apoi la fiecare element, pe orizontală și verticală. Traseele orizontale trec la 30 cm sub tavan sau prin pardoseală.
- **Circuite și tablou**: grupează circuitele (iluminat, prize, consumatori dedicați), alege siguranța, secțiunea cablului după curentul admisibil și căderea de tensiune (3 % la iluminat, 5 % în rest, I7-2011), diferențialele de 30 mA, disjunctorul general și dimensiunea tabloului.
- **Materiale**: cablu pe secțiuni, cu rezervă, tub de protecție, doze, cleme, aparataj, corpuri de iluminat, echiparea tabloului și manopera. Introduci prețurile unitare și obții totalul. Tabelul se copiază direct în Excel.
- **Lucrări**: datele clientului, etape generate automat din proiect, cu ore estimate, panou De făcut / În lucru / Finalizat și progres.

Deschisă din linkul Claude, aplicația salvează proiectele în contul tău, iar ele apar pe orice dispozitiv pe care deschizi linkul. Indicatorul din colțul de sus arată starea: „Salvat în cont”. Deschisă ca fișier (`index.html`), aplicația salvează doar în browserul respectiv. Din „Salvare / import” copiezi oricând proiectul ca text JSON, pentru backup.

## Fișiere

- `electroplan.html`: sursa aplicației
- `index.html`: pagina completă, generată cu `./build.sh`
- `build.sh`: generează `index.html` din `electroplan.html`

## Rulare

Deschide `index.html` în browser sau activează GitHub Pages pe ramura principală.

> Rezultatele sunt orientative. Proiectul final se verifică și se semnează de un electrician autorizat ANRE.
