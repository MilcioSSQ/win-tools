const { app, BrowserWindow, ipcMain } = require('electron');
const path = require('path');
const { execSync, spawn } = require('child_process');
const os = require('os');

let mainWindow;

const createWindow = () => {
  mainWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    minWidth: 800,
    minHeight: 600,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      contextIsolation: true,
      enableRemoteModule: false,
    },
    icon: path.join(__dirname, 'assets/icon.ico'),
  });

  mainWindow.loadFile('index.html');
  mainWindow.webContents.openDevTools(); // Remove in production
};

// System Info
ipcMain.handle('get-system-info', async () => {
  try {
    const totalMem = os.totalmem();
    const freeMem = os.freemem();
    const usedMem = totalMem - freeMem;

    return {
      os: `${os.platform()} ${os.release()}`,
      cpu: os.cpus()[0].model,
      cores: os.cpus().length,
      totalMemGB: (totalMem / (1024 ** 3)).toFixed(2),
      usedMemGB: (usedMem / (1024 ** 3)).toFixed(2),
      memPercent: ((usedMem / totalMem) * 100).toFixed(0),
      uptime: (os.uptime() / 3600).toFixed(1),
    };
  } catch (error) {
    return null;
  }
});

// Run PowerShell Script
ipcMain.handle('run-tool', async (event, toolName) => {
  return new Promise((resolve) => {
    const scriptPath = path.join(__dirname, `../win-tools-main/tools/${toolName}.ps1`);

    const ps = spawn('powershell.exe', [
      '-ExecutionPolicy',
      'Bypass',
      '-File',
      scriptPath,
    ]);

    let output = '';
    let error = '';

    ps.stdout.on('data', (data) => {
      output += data.toString();
    });

    ps.stderr.on('data', (data) => {
      error += data.toString();
    });

    ps.on('close', (code) => {
      resolve({
        success: code === 0,
        output: output || error,
        code,
      });
    });

    setTimeout(() => {
      resolve({
        success: true,
        output: `${toolName} executed`,
        code: 0,
      });
    }, 60000); // 60s timeout
  });
});

// Get Disk Space
ipcMain.handle('get-disk-info', async () => {
  try {
    const driveInfo = execSync('Get-PSDrive -Name C | Select-Object Used,Free', {
      encoding: 'utf-8',
      shell: 'powershell',
    });
    return driveInfo;
  } catch (error) {
    return null;
  }
});

app.on('ready', createWindow);

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('activate', () => {
  if (mainWindow === null) {
    createWindow();
  }
});
