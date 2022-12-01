## Intro
Onze app gaat veel communiceren door middel van Bluetooth met sensors. Dit is een belangrijk deel van onze app en het is van belang om een bluetooth library te gebruiken met functionaliteiten die bij onze eisen past. Op deze pagina kunt u meer lezen over wat de bevindingen van ons waren op het vlak van verschillende bluetooth libraries. 

## Eisen

Hieronder staan de eisen waaraan de library moet voldoen. 

|#|Beschrijving|
|-|-|
|1|De library moet Bluetooth Low Enegery (BLE) ondersteunen aangezien de Movesense sensor met BLE werkt.| 
|2|Het moet mogelijk zijn om voor bluetooth devices te zoeken.| 
|3|Het moet mogelijk zijn om te connecten met een bluetooth device.| 
|4|Het moet mogelijk zijn om te communiceren door middel van bluetooth| 


## Opties

Hieronder staan verschillende opties voor de Bluetooth functionaliteiten.

|#|Naam|Beschrijving|
|-|-|-|
|1|flutter_blue|Flutter blue is een library, waar heel veel functionaliteiten inzitten die wij kunnen gebruiken. Het voeldoet aan al onze eisen. Er is echter wel een nadeel. Deze package is al een lange tijd niet meer geupdate. Flutter blue heeft ook een discord pagina voor hulp.|
|2|flutter_blue_plus|Flutter blue plus is een library, waarvan de code is geforked van Flutter Blue. Dit betekent dus dat ze de zelfde code hebben gebruikt en er op verder hebben gebouwd. De eigenaar van deze package is ook meer actief en er worden regelmatig updates uitgebracht.|
|3|Tugberk Akdogan's movesense library|Dit is een library, waarin Akdogan het mogelijk maakt om expliciet met movesense Sensors te verbinden. Hierbij heeft Akdogan ook toegevoegd om data in real time te visualiseren.|
|4|Geen library|Met Flutter kan je zelf ook verbindingen uitlezen met Bluetooth. Dit gaat echter heel diep en zorgt voor veel boiler plate code in het project.|

## Conclusie
Uiteindelijk zijn wij tot een conclusie gekomen om de bluetooth library flutter_blue_plus te gebruiken. Dit is een library die aan al onze eisen voldoet. Het heeft alle functionaliteiten die wij nodig hebben.

Tijdens dit onderzoek hebben wij ook bevindingen kunnen maken op het gebied van data visualisatie. Tugberk Akdogan's library is open source. In zijn code kunnen wij zien hoe hij live data van een MoveSense visualiseerd. Sinds zijn code open source is kunnen we alle code inzien en een idee krijgen over hoe wij live data van een movesense sensor kunnen visualiseren. [Klik hier](https://github.com/petri-lipponen-movesense/mdsflutter) om naar de github pagina te gaan