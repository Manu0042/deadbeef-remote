# DeaDBeeF Remote (PWA Android)

Télécommande web installable pour piloter [DeaDBeeF](https://deadbeef.sourceforge.io/) depuis ton smartphone via le plugin [beefweb](https://github.com/hyperblast/beefweb).

## Fonctionnalités

- Lecture / pause / stop / précédent / suivant
- Volume + mute, seek dans le morceau
- Liste des playlists, clic sur une piste pour la jouer
- Pochette + métadonnées (titre, artiste, album)
- Installable en PWA sur Android (icône d'appli, plein écran)

## Côté PC — installer beefweb

1. Télécharge le plugin pour ton OS depuis https://github.com/hyperblast/beefweb/releases
2. Dans DeaDBeeF : **Édition → Préférences → Plugins → Beefweb Remote Control**
3. Coche **Allow remote connections**
4. Note le port (par défaut **8880**)
5. Vérifie depuis le PC : http://localhost:8880/ doit afficher l'UI beefweb
6. Vérifie depuis le tél : http://IP_DU_PC:8880/ doit fonctionner aussi
   (autoriser le port dans le pare-feu Windows si besoin)

## Côté téléphone — installer la PWA

1. Sers ce dossier en HTTP. Le plus simple :
   ```bash
   cd C:\SAPDevelop\DeaDBeafWebUI
   python -m http.server 8000
   ```
2. Sur le téléphone, ouvre Chrome → `http://IP_DU_PC:8000/`
3. Menu **⋮** → **Ajouter à l'écran d'accueil**
4. Lance l'app — elle se connecte automatiquement à `http://192.168.1.21:8880`
   (adresse codée en dur dans `index.html`, modifiable via la constante `SERVER_URL`)

## Notes techniques

- Polling à 1 Hz pour l'état (transport + position)
- Pas de cache pour les appels `/api/*` (toujours frais)
- Le service worker met en cache la coquille (HTML/JS/icônes) pour démarrer hors ligne
- Service worker requis : la page doit être servie en HTTPS **ou** via `localhost`/IP locale
  (Chrome Android accepte les IP du réseau local pour les service workers)

## Fichiers

- `index.html` — toute l'UI + le client JS
- `manifest.json` — métadonnées PWA
- `sw.js` — service worker (cache de la coquille)
- `icons/` — icônes 192/512 + script PowerShell de génération
