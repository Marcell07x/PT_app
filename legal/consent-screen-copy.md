# Elfogadó képernyő – szövegek

Ez a rövid szöveg jelenik meg az appban (`lib/onboarding/consent_page.dart`).
A teljes dokumentumokra innen mutatnak a linkek.

**Miért csak három pont?** Mert egy fal szöveg, amit senki nem olvas el,
gyengébb bizonyíték a tájékozott beleegyezésre, mint négy sor, amit tényleg
elolvasnak. Ez a három viszont maradjon a képernyőn:

1. **saját felelősség / kockázatvállalás** és
2. **nem szakmai tanács** – a Ptk. 6:78. § (2) szerint a szokásos gyakorlattól
   lényegesen eltérő kikötés csak akkor válik a szerződés részévé, ha külön
   felhívtad rá a figyelmet és a felhasználó kifejezetten elfogadta. Linkbe
   rejtve ez nem teljesül;
3. **orvos / azonnal hagyd abba** – ez az egyetlen pont, ami ténylegesen
   megelőzhet egy bajt.

Minden más (részletes állapotlista, tünetek, korhatár, táplálkozás) az
Egészségügyi tájékoztatóban van, és linkről elérhető.

Tervezési szabályok:

- A checkbox **ne legyen előre bepipálva** – az érvényes elfogadáshoz aktív
  felhasználói cselekvés kell.
- A gomb csak bepipált checkbox mellett legyen aktív.
- A három link **valóban nyíljon meg** – ha a felhasználó nem tudja elolvasni,
  amit elfogad, az elfogadás gyengébben áll.
- Az elfogadás rögzítése: `gaveConsent` + `consentAcceptedAt` + `consentVersion`.

---

## Magyar

**Cím:** Mielőtt belevágsz

**Bevezető:**
A GetShap célja, hogy megszeresd a rendszeres mozgást, és ezen keresztül haladj
a saját testi céljaid felé. Három dolog, mielőtt belevágsz:

**Pontok:**

1. Az edzéseket saját felelősségedre végzed – a mozgás sérüléssel járó
   kockázatot hordoz.
2. A nehézséget a válaszaid alapján állítja be az app – ez automatikus
   besorolás, nem szakmai állapotfelmérés, és nem veszi figyelembe az
   egészségi állapotodat. A tartalmat nem egészségügyi szakember állította
   össze.
3. Ha egészségügyi problémád van, előbb kérdezd meg az orvosod. Fájdalom,
   szédülés vagy mellkasi panasz esetén azonnal hagyd abba.

**Linkek:** Felhasználási feltételek · Egészségügyi tájékoztató · Adatvédelem

**Checkbox:**
Elolvastam és elfogadom a Felhasználási feltételeket és az Egészségügyi
tájékoztatót, és tudomásul veszem, hogy az edzéseket saját felelősségemre
végzem.

**Gomb:** Elfogadom, kezdjük

---

## English

**Title:** Before you start

**Intro:**
GetShap is here to help you come to enjoy regular exercise, and through that
move towards your own physical goals. Three things before you begin:

**Points:**

1. You train at your own risk – exercise carries a risk of injury.
2. The app sets the difficulty from your answers – that is an automatic
   classification, not a professional assessment, and it does not account for
   your health. The content was not prepared by a healthcare professional.
3. If you have any health condition, ask your doctor first. Stop immediately if
   you feel pain, dizziness or chest discomfort.

**Links:** Terms of Use · Health Disclaimer · Privacy

**Checkbox:**
I have read and accept the Terms of Use and the Health Disclaimer, and I
understand that I train at my own risk.

**Button:** Accept and start

---

## ARB kulcsok

Ezek már bent vannak mindkét `.arb` fájlban. Ha a szövegen módosítasz, ott tedd,
és utána futtasd a `flutter gen-l10n`-t.

`consentTitle` · `consentIntro` · `consentPoint1-3` · `consentCheckbox` ·
`consentAccept` · `consentTermsLink` · `consentHealthLink` ·
`consentPrivacyLink`

---

## Kiegészítő egészségügyi szűrő kérdés (ajánlott)

A kérdőívbe érdemes felvenni egy 8. kérdést – ez ér a legtöbbet, ha valaha
vitára kerül sor, mert dokumentálja, hogy rákérdeztél:

**Kérdés:** „Van olyan egészségügyi problémád, sérülésed vagy panaszod, ami miatt
orvos eltiltott a sporttól, vagy amiről tudod, hogy edzés közben gondot
okozhat?"

**Válaszok:** Nincs · Igen / nem vagyok biztos benne

Az „Igen / nem vagyok biztos benne" válasz után egy figyelmeztető képernyő:

> **Beszélj előbb az orvosoddal**
>
> A GetShap általános edzéstartalmat ad, és nem tudja figyelembe venni az
> egészségi állapotodat. Kérjük, egyeztess orvosoddal, mielőtt belekezdesz, és
> csak az ő jóváhagyásával edz. Ha bármilyen panaszt érzel edzés közben, azonnal
> hagyd abba.
>
> *(Gombok: „Megértettem, folytatom" · „Vissza")*

Angolul:

> **Talk to your doctor first**
>
> GetShap provides general exercise content and cannot take your health status
> into account. Please consult your doctor before you start, and train only with
> their approval. If you feel unwell during a workout, stop immediately.
>
> *(Buttons: "I understand, continue" · "Back")*
