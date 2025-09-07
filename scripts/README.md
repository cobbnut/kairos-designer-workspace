# Kairos Designer - Development Scripts

This directory contains PowerShell scripts to automate common development tasks for the Kairos Designer project.

## 📜 Available Scripts

### 🚀 `start-dev.ps1` - Development Server Launcher

**Purpose**: Starts the development servers for both frontend and backend

**Usage:**
```powershell
# Start both frontend and backend in separate windows
.\scripts\start-dev.ps1

# Start only the backend server
.\scripts\start-dev.ps1 -BackendOnly

# Start only the frontend server  
.\scripts\start-dev.ps1 -FrontendOnly

# Show help information
.\scripts\start-dev.ps1 -Help
```

**What it does:**
- ✅ Checks for Python and Node.js prerequisites
- ✅ Activates Python virtual environment (backend)
- ✅ Installs missing dependencies automatically
- ✅ Starts Flask server on `https://kairos:5002` (backend)
- ✅ Starts Vite dev server on `http://localhost:3000` (frontend)
- ✅ Runs servers in separate PowerShell windows for parallel development

---

### 🔧 `setup-env.ps1` - Environment Setup

**Purpose**: Sets up the complete development environment from scratch

**Usage:**
```powershell
# Initial setup (recommended for new developers)
.\scripts\setup-env.ps1

# Force reinstall all dependencies
.\scripts\setup-env.ps1 -Force

# Show help information
.\scripts\setup-env.ps1 -Help
```

**What it does:**
- ✅ Verifies Python 3.8+ and Node.js 16+ installations
- ✅ Creates Python virtual environment (`kdes/venv/`)
- ✅ Installs all Python dependencies from `requirements.txt`
- ✅ Installs all Node.js dependencies from `package.json`
- ✅ Verifies project structure and key files
- ✅ Provides detailed status feedback and error reporting

---

## 🎯 Quick Start Guide

### For New Developers

1. **One-time setup:**
   ```powershell
   .\scripts\setup-env.ps1
   ```

2. **Daily development:**
   ```powershell
   .\scripts\start-dev.ps1
   ```

### For Experienced Developers

- **Backend only:** `.\scripts\start-dev.ps1 -BackendOnly`
- **Frontend only:** `.\scripts\start-dev.ps1 -FrontendOnly`
- **Reset environment:** `.\scripts\setup-env.ps1 -Force`

---

## 🛠️ Prerequisites

These must be installed on your system before using the scripts:

### Required
- **Python 3.8+** with pip (for Flask backend)
- **Node.js 16+** with npm (for React frontend)
- **Git** (for version control)

### Optional (for full functionality)
- **PostgreSQL** (database - can be configured later)
- **Redis** (caching - optional)

### Verification
Run these commands to verify your installation:
```powershell
python --version    # Should show 3.8+
node --version      # Should show 16+
npm --version       # Should show latest
git --version       # Should show any recent version
```

---

## 🏗️ Project Architecture

The scripts manage a dual-application structure:

```
103_kairos_designer/
├── kdes-fe/          # 🎨 Frontend (React + Vite)
│   ├── src/          # React components, hooks, contexts
│   ├── public/       # Static assets
│   └── package.json  # Node.js dependencies
├── kdes/             # ⚙️ Backend (Python + Flask)  
│   ├── kairos/       # Main Flask application
│   ├── venv/         # Python virtual environment
│   ├── run.py        # Flask server entry point
│   └── requirements.txt  # Python dependencies
└── scripts/          # 🤖 These automation scripts
```

---

## 🔍 Script Features

### Color-Coded Output
- 🟢 **Green**: Success messages and confirmations
- 🟡 **Yellow**: Warnings and important notices  
- 🔴 **Red**: Errors and failures
- 🔵 **Blue**: Process steps and actions
- 🟣 **Magenta**: Headers and section titles
- 🔵 **Cyan**: Information and tips

### Error Handling
- **Prerequisite checking**: Verifies Python and Node.js before proceeding
- **Graceful failures**: Clear error messages with suggested solutions
- **Force mode**: `-Force` parameter to reset corrupted environments
- **Help system**: `-Help` parameter for detailed usage instructions

### Cross-Platform Considerations
- **Windows PowerShell**: Primary target (matches your development environment)
- **Path handling**: Robust file path resolution across Windows variants
- **Process management**: Proper handling of virtual environment activation

---

## 🚨 Troubleshooting

### Common Issues

1. **"Execution Policy" Error:**
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

2. **Python Not Found:**
   - Install Python from https://python.org
   - Ensure Python is added to PATH during installation
   - Restart PowerShell after installation

3. **Node.js Not Found:**  
   - Install Node.js from https://nodejs.org
   - Choose LTS version (16+)
   - Restart PowerShell after installation

4. **Virtual Environment Issues:**
   - Run `.\scripts\setup-env.ps1 -Force` to recreate
   - Manually delete `kdes\venv\` directory if needed

5. **Permission Errors:**
   - Run PowerShell as Administrator if needed
   - Check antivirus software isn't blocking script execution

### Getting Help

- **Script help**: Add `-Help` to any script command
- **Project documentation**: See `README.md` and `DEVELOPMENT.md` in project root
- **Architecture rules**: See `.warp.md` for detailed development guidelines

---

## 🔄 Development Workflow

### Daily Routine
1. **Start development servers**: `.\scripts\start-dev.ps1`
2. **Code changes**: Edit files in `kdes-fe/` and `kdes/`
3. **Test changes**: Servers automatically reload on file changes
4. **Stop servers**: Close the PowerShell windows or press `Ctrl+C`

### Adding Dependencies

**Frontend (Node.js):**
```powershell
cd kdes-fe
npm install package-name
# Scripts will detect and use new dependencies automatically
```

**Backend (Python):**
```powershell
cd kdes
venv\Scripts\Activate.ps1
pip install package-name
pip freeze > requirements.txt  # Update requirements
# Scripts will detect and install from requirements.txt
```

---

## 💡 Pro Tips

1. **Use separate terminals**: Let scripts open separate windows for easier debugging
2. **Check logs**: Both servers provide detailed console output for troubleshooting
3. **Hot reloading**: Both Vite (frontend) and Flask (backend) support hot reloading
4. **Port conflicts**: Backend uses 5002, frontend uses 3000 - ensure these are available
5. **SSL certificates**: Backend uses HTTPS - accept browser warnings in development

---

*These scripts follow the rich commenting principles outlined in the project's development guidelines. They provide extensive feedback and error handling to ensure a smooth development experience.*
