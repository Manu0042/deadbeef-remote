# DeaDBeeF Remote (Android PWA)

Installable web remote to control [DeaDBeeF](https://deadbeef.sourceforge.io/) from your smartphone via the [beefweb](https://github.com/hyperblast/beefweb) plugin.

## Features

- Play / pause / stop / next / previous
- Seek within the current track
- Browse playlists, tap a track to play it
- Album artwork + metadata (title, artist, album)
- Web artwork fallback (iTunes → Cover Art Archive) when the file has no embedded cover, cached locally
- Installable as a PWA on Android (home-screen icon, fullscreen mode)
- Dark UI, locked

## Server side — install beefweb

1. Get the plugin for your OS from https://github.com/hyperblast/beefweb/releases
2. In DeaDBeeF: **Edit → Preferences → Plugins → Beefweb Remote Control**
3. Tick **Allow remote connections**
4. Note the port (default **8880**)
5. From the host: http://localhost:8880/ should show the beefweb UI
6. From another machine: http://HOST_IP:8880/ should also work
   (open the port in your firewall if needed)

> **CORS note** — by default beefweb does not send CORS headers, which means
> a browser-loaded PWA from a different origin will be blocked. Either serve
> this PWA from the same origin as beefweb, or add to its config file
> (`~/.config/deadbeef/beefweb.config.json` on Linux,
> `%APPDATA%\deadbeef\beefweb_config.json` on Windows):
>
> ```json
> { "responseHeaders": { "Access-Control-Allow-Origin": "*" } }
> ```
>
> Then restart DeaDBeeF.

## Phone side — install the PWA

The simplest way to install the app on your phone is via **GitHub Pages**:
GitHub serves the repo as a static site over HTTPS, and Chrome can install
that page as a PWA in one tap.

### One-time: enable GitHub Pages on your fork

1. Go to your repo on github.com → **Settings** → **Pages**
2. Under **Build and deployment**, set:
   - **Source**: `Deploy from a branch`
   - **Branch**: `main`, folder `/ (root)`
3. Click **Save**. After ~1 minute, the page shows your URL, typically
   `https://<your-user>.github.io/<repo-name>/`
   (for this repo: https://manu0042.github.io/deadbeef-remote/)

### On the phone

1. Open Chrome on your Android phone
2. Go to your GitHub Pages URL
3. Menu **⋮** → **Add to Home screen** (or **Install app** if Chrome offers it)
4. Launch the app from your home screen — it now works fullscreen and
   connects to the `SERVER_URL` configured in `index.html`

> **Important** — your phone must be on the **same Wi-Fi as the host PC**
> for the app to reach `192.168.1.21:8880`. The HTML page is loaded from
> GitHub (public HTTPS), but every API call goes to your local network.

### Alternative: testing locally

If you're modifying the code and want to test before pushing, serve the
folder over HTTP from your dev machine (browsers refuse service workers
from `file://`):

```bash
python -m http.server 8000
```

Then open `http://localhost:8000/` (desktop) or `http://<dev-pc-ip>:8000/`
(phone, same Wi-Fi).

## Configuration

Open `index.html` and edit the top of the inline `<script>`:

```js
const SERVER_URL = 'http://192.168.1.21:8880';
```

That's it — no settings UI, no localStorage server config.

## Technical notes

- 1 Hz polling for player state (transport + position)
- No caching for `/api/*` calls (always live)
- The service worker caches the app shell (HTML/JS/icons) so it boots offline
- Service worker requirements: the page must be served over HTTPS **or** via
  `localhost` / a local IP (Chrome Android accepts LAN IPs for service workers)
- Web cover-art lookup hits two public APIs without keys; results are cached in
  `localStorage` under `beefweb.webart.v1`. Clear with
  `localStorage.removeItem('beefweb.webart.v1')` to retry.

## Files

- `index.html` — full UI + JS client
- `manifest.json` — PWA metadata
- `sw.js` — service worker (app-shell cache)
- `icons/` — 192/512 icons + a PowerShell script to regenerate them

## License

MIT — do whatever you want with it.
