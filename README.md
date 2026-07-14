# Win-Tools Dashboard

A modern, beautiful **Electron + React** dashboard for the Win-Tools PowerShell utility suite. Replace the console with a sleek, neon-themed UI.

![Dashboard Preview](screenshot.png)

---

## Features

✨ **Modern UI**
- Dark theme with neon (#00ff88) accents
- Responsive grid layout
- Smooth animations & transitions
- Real-time system monitoring

🎮 **System Monitoring**
- Live CPU, RAM, and Storage stats
- System uptime tracking
- Progress visualizations
- Auto-refresh every 5 seconds

⚡ **One-Click Tools**
- All 10 Win-Tools integrated
- Run tools directly from UI
- Real-time status feedback
- Tool execution history

🎨 **UI/UX**
- Tab-based navigation (Dashboard, Tools, Settings)
- Quick action buttons
- Visual tool status indicators
- Beautiful card-based layout

---

## Tech Stack

```
Frontend:     React 18 + React Icons
Desktop:      Electron
Styling:      CSS3 with animations
Backend:      Node.js + PowerShell
```

---

## Setup & Installation

### Prerequisites
- Node.js 14+
- npm or yarn
- Windows 10/11
- PowerShell 5.1+

### Installation

1. **Clone/Navigate to project**
```bash
cd win-tools-dashboard
```

2. **Install dependencies**
```bash
npm install
```

3. **Ensure win-tools repo is in parent directory**
```
win-tools-dashboard/
../win-tools-main/
  ├── tools/
  ├── screenshots/
  └── README.md
```

4. **Start development mode**
```bash
npm run electron-dev
```

This opens the Electron app and the React dev server together.

---

## Usage

### Development
```bash
npm run electron-dev      # Start dev mode with hot-reload
```

### Building
```bash
npm run electron-build    # Build standalone executable
```

Output: `dist/` folder with `.exe` installer and portable version

---

## Dashboard Pages

### 1. **Dashboard** 📊
- System stats in card grid
- Memory usage progress bar
- CPU & uptime info
- Quick action buttons (Gaming Mode, Clean, Scan)

### 2. **Tools** 🛠️
- Grid of all 10 tools
- One-click execution
- Status messages
- Visual feedback (running/completed)

### 3. **Settings** ⚙️
- Theme toggle (dark/light)
- Auto-refresh settings
- About section

---

## Integrated Tools

All tools from [Win-Tools](../win-tools-main):

| # | Tool | Function |
|---|------|----------|
| 1 | **Bloatware Remover** | Remove UWP junk apps |
| 2 | **Autostart Cleaner** | Clean startup programs |
| 3 | **Cleaner** | Delete temp/cache files |
| 4 | **Mouse Jiggle** | Prevent sleep/screensaver |
| 5 | **Gaming Tweaks** | Optimize for gaming |
| 6 | **Defender Scan** | Run antivirus scan |
| 7 | **Network Info** | View network stats |
| 8 | **System Info** | Detailed system details |
| 9 | **Power Plan** | Change power settings |
| 10 | **Dark Mode** | Toggle Windows theme |

---

## Architecture

```
win-tools-dashboard/
├── main.js                 # Electron main process
├── preload.js             # IPC bridge
├── index.html             # HTML shell
├── package.json           # Dependencies
└── src/
    ├── index.js           # React entry
    ├── App.js             # Main component
    └── App.css            # Styling
```

### IPC Handlers
- `get-system-info` - Fetch OS, CPU, RAM stats
- `run-tool` - Execute PowerShell script
- `get-disk-info` - Get disk usage

---

## Styling & Theme

### Color Scheme
```css
Primary:      #00ff88 (Neon green)
Dark BG:      #0f0f1e
Card BG:      rgba(30, 30, 50, 0.8)
Text:         #e0e0e0
Accent:       Neon glow effects
```

### Responsive
- Desktop: Full grid layout
- Tablet: 2-column grid
- Mobile: Single column

---

## Performance

- ⚡ System info refreshes every 5 seconds
- 🎨 Smooth 60fps animations
- 💾 Minimal memory footprint
- 🔄 Efficient IPC communication

---

## Known Limitations

- Some tools require **Admin privileges** (auto-elevated via UAC)
- Mouse Jiggle runs in console window (separate process)
- Defender Scan takes time; tab remains responsive

---

## Future Enhancements

- [ ] Tool scheduling/automation
- [ ] Settings persistence
- [ ] Tool logs/history view
- [ ] System tray minimization
- [ ] Custom tool shortcuts
- [ ] Telemetry dashboard
- [ ] Auto-update checker

---

## Credits

Dashboard built for [Win-Tools](../win-tools-main) by **MilcioSSQ**

---

## License

MIT © [MilcioSSQ](https://github.com/MilcioSSQ)
