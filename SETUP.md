# Win-Tools Dashboard - Setup Guide

Kompletter Guide um das Dashboard zum Laufen zu bringen.

---

## Step 1: Prerequisites installieren

### Node.js & npm
1. Download: https://nodejs.org/ (LTS Version)
2. Installieren
3. Terminal öffnen und checken:
```bash
node --version
npm --version
```

### Git (optional, aber empfohlen)
Download: https://git-scm.com/

---

## Step 2: Projekt strukturieren

```
Dein Ordner:
├── win-tools-main/          ← Dein bestehendes Win-Tools Repo
│   ├── tools/
│   ├── screenshots/
│   └── README.md
└── win-tools-dashboard/     ← Das neue Dashboard
    ├── main.js
    ├── package.json
    └── src/
```

**Wichtig:** Beide Ordner müssen nebeneinander sein!

---

## Step 3: Dashboard aufsetzen

1. **Terminal im win-tools-dashboard Ordner öffnen**

2. **Dependencies installieren**
```bash
npm install
```

Das dauert 2-3 Minuten. Nicht abbrechen!

3. **React Icons installieren (falls nicht automatisch)**
```bash
npm install react-icons
```

---

## Step 4: Starten

### Development Mode (mit Hot-Reload)
```bash
npm run electron-dev
```

Das öffnet:
- React Dev Server auf `http://localhost:3000`
- Electron Fenster mit Dashboard
- DevTools für Debugging

### Nur App starten (ohne Dev-Tools)
Ändere `main.js` und kommentiere diese Zeile aus:
```javascript
// mainWindow.webContents.openDevTools(); // Zeile auskommentieren
```

---

## Step 5: Bauen

### Als ausführbare EXE bauen
```bash
npm run electron-build
```

Das erstellt:
- `dist/Win-Tools Dashboard Setup 1.0.0.exe` (Installer)
- `dist/Win-Tools Dashboard 1.0.0.exe` (Portable)

### EXE testen
Doppelklick auf die .exe und los geht's!

---

## Fehlerbehandlung

### Error: "Cannot find module 'react'"
```bash
npm install
```

### Error: "PowerShell script not found"
- Stelle sicher, dass `win-tools-main/tools/` im richtigen Pfad ist
- Pfad in `main.js` checken

### Error: "Port 3000 already in use"
Andere App läuft auf Port 3000:
```bash
npx kill-port 3000
npm run electron-dev
```

### Das UI sieht zerstört aus
- Cache löschen: `npm start` neu starten
- React DevTools checken (sollte keine Fehler anzeigen)

---

## Struktur verstehen

### main.js (Electron Backend)
- Verwaltet App-Fenster
- Führt PowerShell Scripts aus
- Sammelt System-Info

### preload.js (Sicherheits-Bridge)
- Erlaubt Frontend nur sichere API-Funktionen
- Verbindung zwischen React und Node.js

### App.js (React Frontend)
- UI & Komponenten
- Tabs (Dashboard, Tools, Settings)
- IPC Calls zu main.js

### App.css (Styling)
- Neon-Theme (#00ff88)
- Responsive Layout
- Animations

---

## Customization

### Farben ändern
In `App.css`:
```css
/* Ändere #00ff88 zu deiner Farbe */
.logo { color: #00ff88; }     /* Neon Green */
/* Zu: */
.logo { color: #00ffff; }     /* Neon Cyan */
```

### Neue Tools hinzufügen
In `App.js`, `tools` Array erweitern:
```javascript
{ id: 'dein-tool', name: 'Dein Tool Name', icon: FiZap, desc: 'Beschreibung' }
```

### Aktualisierungsrate ändern
In `App.js`:
```javascript
const interval = setInterval(refreshSystemInfo, 5000); // 5 Sekunden
// Zu 10 Sekunden:
const interval = setInterval(refreshSystemInfo, 10000);
```

---

## GitHub hochladen

Wenn du das hochladen möchtest:

1. **Neues Repo erstellen** auf GitHub
2. **Terminal im win-tools-dashboard**
```bash
git init
git add .
git commit -m "Initial commit: Win-Tools Dashboard UI"
git branch -M main
git remote add origin https://github.com/DEIN-USERNAME/win-tools-dashboard.git
git push -u origin main
```

3. **README anpassen** (deine Infos)

---

## Production Checklist

Bevor du es veröffentlichst:

- [ ] DevTools auskommentieren in `main.js`
- [ ] Version in `package.json` erhöhen
- [ ] Screenshots hinzufügen
- [ ] README vervollständigen
- [ ] `npm run electron-build` testen
- [ ] EXE testen auf sauberem Windows System

---

## Support & Tipps

**DevTools öffnen (Debugging):**
Beim Start: Automatisch
Danach: F12 im Electron Fenster

**Logs checken:**
Terminal zeigt alle Fehler
Electron DevTools zeigt React Fehler

**Performance:**
- System-Info Refresh nur bei Bedarf
- Tool-Outputs begrenzen
- Alte Messages clearen

---

Viel Spaß beim Aufbauen! 🚀
