const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('api', {
  getSystemInfo: () => ipcRenderer.invoke('get-system-info'),
  runTool: (toolName) => ipcRenderer.invoke('run-tool', toolName),
  getDiskInfo: () => ipcRenderer.invoke('get-disk-info'),
});
