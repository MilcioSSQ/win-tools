import React, { useState, useEffect } from 'react';
import { FiZap, FiSettings, FiTrash2, FiInfo, FiWifi, FiCpu, FiMoon, FiMouse, FiShield, FiRotateCw } from 'react-icons/fi';
import './App.css';

const App = () => {
  const [systemInfo, setSystemInfo] = useState(null);
  const [activePage, setActivePage] = useState('dashboard');
  const [runningTool, setRunningTool] = useState(null);
  const [toolOutput, setToolOutput] = useState({});
  const [theme, setTheme] = useState('dark');

  useEffect(() => {
    refreshSystemInfo();
    const interval = setInterval(refreshSystemInfo, 5000);
    return () => clearInterval(interval);
  }, []);

  const refreshSystemInfo = async () => {
    try {
      const info = await window.api.getSystemInfo();
      setSystemInfo(info);
    } catch (error) {
      console.error('Error fetching system info:', error);
    }
  };

  const runTool = async (toolName, displayName) => {
    setRunningTool(toolName);
    setToolOutput(prev => ({
      ...prev,
      [toolName]: `Running ${displayName}...`
    }));

    try {
      const result = await window.api.runTool(toolName);
      setToolOutput(prev => ({
        ...prev,
        [toolName]: result.success ? `✓ ${displayName} completed` : `✗ Error: ${result.output}`
      }));
    } catch (error) {
      setToolOutput(prev => ({
        ...prev,
        [toolName]: `✗ Error: ${error.message}`
      }));
    } finally {
      setRunningTool(null);
    }
  };

  const tools = [
    { id: 'bloatware', name: 'Bloatware Remover', icon: FiTrash2, desc: 'Remove UWP junk apps' },
    { id: 'autostart', name: 'Autostart Cleaner', icon: FiRotateCw, desc: 'Clean startup programs' },
    { id: 'cleaner', name: 'Temp & Cache Cleaner', icon: FiTrash2, desc: 'Clear temporary files' },
    { id: 'jiggle', name: 'Mouse Jiggle', icon: FiMouse, desc: 'Prevent sleep mode' },
    { id: 'gaming', name: 'Gaming Tweaks', icon: FiZap, desc: 'Optimize for gaming' },
    { id: 'defender', name: 'Defender Scan', icon: FiShield, desc: 'Run antivirus scan' },
    { id: 'network', name: 'Network Info', icon: FiWifi, desc: 'View network settings' },
    { id: 'sysinfo', name: 'System Info', icon: FiCpu, desc: 'Detailed system info' },
    { id: 'powerplan', name: 'Power Plan', icon: FiZap, desc: 'Change power settings' },
    { id: 'darkmode', name: 'Dark Mode', icon: FiMoon, desc: 'Toggle dark theme' }
  ];

  return (
    <div className={`app ${theme}`}>
      <nav className="navbar">
        <div className="logo">
          <FiZap className="logo-icon" />
          <span>Win-Tools</span>
        </div>
        <div className="nav-links">
          <button className={`nav-btn ${activePage === 'dashboard' ? 'active' : ''}`} onClick={() => setActivePage('dashboard')}>
            Dashboard
          </button>
          <button className={`nav-btn ${activePage === 'tools' ? 'active' : ''}`} onClick={() => setActivePage('tools')}>
            Tools
          </button>
          <button className={`nav-btn ${activePage === 'settings' ? 'active' : ''}`} onClick={() => setActivePage('settings')}>
            Settings
          </button>
        </div>
      </nav>

      <div className="container">
        {activePage === 'dashboard' && (
          <div className="page dashboard-page">
            <div className="header">
              <h1>System Dashboard</h1>
              <button className="refresh-btn" onClick={refreshSystemInfo}>
                <FiRotateCw /> Refresh
              </button>
            </div>

            {systemInfo ? (
              <div className="stats-grid">
                <div className="stat-card cpu-card">
                  <div className="stat-icon"><FiCpu /></div>
                  <h3>CPU</h3>
                  <p className="stat-value">{systemInfo.cores} Cores</p>
                  <p className="stat-detail">{systemInfo.cpu.substring(0, 40)}...</p>
                </div>

                <div className="stat-card memory-card">
                  <div className="stat-icon"><FiZap /></div>
                  <h3>Memory</h3>
                  <div className="progress-bar">
                    <div className="progress-fill" style={{ width: `${systemInfo.memPercent}%` }}></div>
                  </div>
                  <p className="stat-value">{systemInfo.usedMemGB} / {systemInfo.totalMemGB} GB</p>
                  <p className="stat-percent">{systemInfo.memPercent}% Used</p>
                </div>

                <div className="stat-card os-card">
                  <div className="stat-icon"><FiInfo /></div>
                  <h3>Operating System</h3>
                  <p className="stat-value">{systemInfo.os}</p>
                  <p className="stat-detail">Uptime: {systemInfo.uptime}h</p>
                </div>

                <div className="stat-card storage-card">
                  <div className="stat-icon"><FiSettings /></div>
                  <h3>Storage</h3>
                  <p className="stat-value">Disk Usage</p>
                  <p className="stat-detail">Click Tools to manage</p>
                </div>
              </div>
            ) : (
              <div className="loading">Loading system info...</div>
            )}

            <div className="quick-actions">
              <h2>Quick Actions</h2>
              <div className="action-buttons">
                <button className="action-btn gaming-btn" onClick={() => runTool('gaming', 'Gaming Tweaks')}>
                  <FiZap /> Gaming Mode
                </button>
                <button className="action-btn clean-btn" onClick={() => runTool('cleaner', 'Cleaner')}>
                  <FiTrash2 /> Clean Now
                </button>
                <button className="action-btn scan-btn" onClick={() => runTool('defender', 'Defender')}>
                  <FiShield /> Quick Scan
                </button>
              </div>
            </div>
          </div>
        )}

        {activePage === 'tools' && (
          <div className="page tools-page">
            <h1>Windows Tools</h1>
            <div className="tools-grid">
              {tools.map(tool => {
                const IconComponent = tool.icon;
                const isRunning = runningTool === tool.id;
                const status = toolOutput[tool.id];

                return (
                  <div key={tool.id} className={`tool-card ${isRunning ? 'running' : ''} ${status ? 'executed' : ''}`}>
                    <div className="tool-icon">
                      <IconComponent />
                    </div>
                    <h3>{tool.name}</h3>
                    <p>{tool.desc}</p>
                    <button
                      className="run-btn"
                      onClick={() => runTool(tool.id, tool.name)}
                      disabled={isRunning}
                    >
                      {isRunning ? 'Running...' : 'Run'}
                    </button>
                    {status && <div className="status-msg">{status}</div>}
                  </div>
                );
              })}
            </div>
          </div>
        )}

        {activePage === 'settings' && (
          <div className="page settings-page">
            <h1>Settings</h1>
            <div className="settings-card">
              <div className="setting-group">
                <label>Theme</label>
                <select value={theme} onChange={(e) => setTheme(e.target.value)}>
                  <option value="dark">Dark</option>
                  <option value="light">Light</option>
                </select>
              </div>

              <div className="setting-group">
                <label>Auto-refresh System Info</label>
                <input type="checkbox" defaultChecked={true} />
              </div>

              <div className="setting-group">
                <h3>About</h3>
                <p>Win-Tools Dashboard v1.0.0</p>
                <p>A modern Windows utility toolkit</p>
                <p>© 2024 MilcioSSQ</p>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default App;
