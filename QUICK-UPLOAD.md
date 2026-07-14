# 🚀 QUICK UPLOAD zu GitHub

## 3 Minuten Upload-Guide

### Step 1: GitHub Repo erstellen (1 Minute)

1. Gehe zu: https://github.com/new
2. **Repository name:** `win-tools-dashboard`
3. **Description:** "Modern Electron Dashboard for Windows System Tools"
4. **Public** ✅
5. Klick "Create repository"

Kopiere die URL:
```
https://github.com/DEIN-USERNAME/win-tools-dashboard.git
```

---

### Step 2: Terminal-Befehle (2 Minuten)

**Öffne Terminal/PowerShell im `win-tools-dashboard` Ordner:**

```bash
# Git initialisieren
git init

# Alle Dateien hinzufügen
git add .

# Erster Commit
git commit -m "Initial commit: Win-Tools Dashboard - Electron + React UI"

# Main Branch
git branch -M main

# Remote URL EINFÜGEN (ersetze USERNAME!)
git remote add origin https://github.com/USERNAME/win-tools-dashboard.git

# Hochpushen
git push -u origin main
```

---

### Fertig! ✅

Jetzt auf GitHub:
- https://github.com/USERNAME/win-tools-dashboard

---

## Danach testen

```bash
# Dependencies installieren
npm install

# Starten
npm run electron-dev
```

---

## Falls du Git nicht hast

Download: https://git-scm.com/

Nach Installation terminal neustarten!

---

**Fragen?** Siehe README.md oder SETUP.md
