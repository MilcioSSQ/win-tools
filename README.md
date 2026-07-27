<div align="center">
  <img src="screenshots/banner.png" width="100%" alt="win-tools" />
</div>

<div align="center">

# 🛠️ win-tools

**A personal Windows utility kit — one launcher, ten tools, no bloat.**

![Platform](https://img.shields.io/badge/platform-Windows%2010%20%2F%2011-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)
![Tools](https://img.shields.io/badge/tools-10-FF6B6B?style=for-the-badge)

</div>

---

## ⚡ Quick Start

Paste this into PowerShell — that's it:

```powershell
irm https://raw.githubusercontent.com/MilcioSSQ/win-tools/main/install.ps1 | iex
```

> Downloads the latest version, elevates to admin, and opens the menu. Nothing is installed permanently.

---

## 🧰 Tools

| # | Tool | What it does |
|---|------|-------------|
| 1 | **Bloatware Remover** | Removes pre-installed UWP junk (News, Bing Weather, Skype, TikTok, …) |
| 2 | **Autostart Cleaner** | Lists and disables unnecessary startup entries; protects drivers and audio |
| 3 | **Temp & Cache Cleaner** | Clears `%TEMP%`, Windows Temp, Prefetch, browser cache, pip cache |
| 4 | **Mouse Jiggle** | Moves the mouse ±1 px every 5 min to prevent sleep / screensaver |
| 5 | **Gaming Tweaks** | Mouse acceleration off, Game DVR off, GPU scheduling, MMCSS, power plan |
| 6 | **Defender Scan** | Update signatures + quick / full / offline scan from one menu |
| 7 | **Network Info** | Local IPs, gateway, DNS, MAC, public IP, ping target |
| 8 | **System Info** | OS, CPU, GPU, RAM, disk, uptime, process count |
| 9 | **Power Plan Switcher** | Switch between Balanced, High Performance, and Power Saver |
| 10 | **Dark Mode Toggle** | Switch Windows dark / light mode without opening Settings |

---

## 📸 Screenshots

<details open>
<summary><b>Main Menu</b></summary>
<br/>
<div align="center">
  <img src="screenshots/menu.png" width="600" alt="Menu"/>
</div>
</details>

<details>
<summary><b>System Info</b></summary>
<br/>
<div align="center">
  <img src="screenshots/sysinfo.png" width="600" alt="System Info"/>
</div>
</details>

<details>
<summary><b>Gaming Tweaks</b></summary>
<br/>
<div align="center">
  <img src="screenshots/gaming.png" width="600" alt="Gaming Tweaks"/>
</div>
</details>

<details>
<summary><b>Temp & Cache Cleaner</b></summary>
<br/>
<div align="center">
  <img src="screenshots/cleaner.png" width="600" alt="Cleaner"/>
</div>
</details>

---

## 💻 Manual Usage

If you cloned or downloaded the repo:

```powershell
powershell -ExecutionPolicy Bypass -File .\win-tools.ps1
```

Or run any tool standalone:

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\sysinfo.ps1
powershell -ExecutionPolicy Bypass -File .\tools\cleaner.ps1
```

The launcher elevates itself automatically — just approve the UAC prompt.

---

## 📂 Structure

```
win-tools/
├── install.ps1          # one-line launcher (irm | iex)
├── win-tools.ps1        # main launcher / menu
├── tools/
│   ├── bloatware.ps1
│   ├── autostart.ps1
│   ├── cleaner.ps1
│   ├── jiggle.ps1
│   ├── gaming.ps1
│   ├── defender.ps1
│   ├── network.ps1
│   ├── sysinfo.ps1
│   ├── powerplan.ps1
│   └── darkmode.ps1
├── screenshots/
├── LICENSE
└── README.md
```

---

## 📝 Notes

- All changes made by **Gaming Tweaks** and **Autostart Cleaner** are reversible — backups are stored in `%LOCALAPPDATA%`.
- **Bloatware Remover** only targets known junk. Xbox, Store, and your drivers are never touched.
- **Mouse Jiggle** runs until you close the window or press `Ctrl+C`.

---

<div align="center">

## 🤝 Contributing

Issues and pull requests are welcome!

---

![Made by](https://img.shields.io/badge/Made%20by-MilcioSSQ-FF6B6B?style=flat-square&logo=github&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

[MIT](LICENSE) © MilcioSSQ

</div>
