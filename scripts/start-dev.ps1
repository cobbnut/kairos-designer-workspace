# Kairos Designer - Development Server Startup Script
# This PowerShell script starts both frontend and backend development servers
# Usage: .\scripts\start-dev.ps1

param(
    [switch]$BackendOnly,  # Start only backend
    [switch]$FrontendOnly, # Start only frontend
    [switch]$Help          # Show help information
)

# Script configuration
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir = Split-Path -Parent $ScriptDir
$BackendDir = Join-Path $RootDir "kdes"
$FrontendDir = Join-Path $RootDir "kdes-fe"

# ANSI color codes for better output
$Red = [char]27 + "[31m"
$Green = [char]27 + "[32m"
$Yellow = [char]27 + "[33m"
$Blue = [char]27 + "[34m"
$Magenta = [char]27 + "[35m"
$Cyan = [char]27 + "[36m"
$Reset = [char]27 + "[0m"

function Write-Header {
    param([string]$Text, [string]$Color = $Cyan)
    Write-Host ""
    Write-Host "${Color}================================${Reset}"
    Write-Host "${Color}  $Text${Reset}"
    Write-Host "${Color}================================${Reset}"
}

function Write-Step {
    param([string]$Text, [string]$Color = $Blue)
    Write-Host "${Color}▶ $Text${Reset}"
}

function Write-Success {
    param([string]$Text)
    Write-Host "${Green}✓ $Text${Reset}"
}

function Write-Warning {
    param([string]$Text)
    Write-Host "${Yellow}⚠ $Text${Reset}"
}

function Write-Error {
    param([string]$Text)
    Write-Host "${Red}✗ $Text${Reset}"
}

function Show-Help {
    Write-Header "Kairos Designer - Development Server Startup" $Magenta
    Write-Host ""
    Write-Host "This script starts the development environment for the Kairos Designer project."
    Write-Host ""
    Write-Host "${Cyan}Usage:${Reset}"
    Write-Host "  .\scripts\start-dev.ps1                # Start both frontend and backend"
    Write-Host "  .\scripts\start-dev.ps1 -BackendOnly   # Start only backend server"
    Write-Host "  .\scripts\start-dev.ps1 -FrontendOnly  # Start only frontend server"
    Write-Host "  .\scripts\start-dev.ps1 -Help          # Show this help"
    Write-Host ""
    Write-Host "${Cyan}What this script does:${Reset}"
    Write-Host "  • Checks for required dependencies (Python, Node.js)"
    Write-Host "  • Activates Python virtual environment (backend)"
    Write-Host "  • Installs Python dependencies if needed"
    Write-Host "  • Installs Node.js dependencies if needed"
    Write-Host "  • Starts Flask development server (port 5002, HTTPS)"
    Write-Host "  • Starts Vite development server (port 3000)"
    Write-Host ""
    Write-Host "${Cyan}Prerequisites:${Reset}"
    Write-Host "  • Python 3.8+ installed and in PATH"
    Write-Host "  • Node.js installed and in PATH"
    Write-Host "  • PostgreSQL running (for backend database)"
    Write-Host ""
    Write-Host "${Cyan}Project Structure:${Reset}"
    Write-Host "  • Frontend: kdes-fe/ (React + Vite + JavaScript)"
    Write-Host "  • Backend:  kdes/    (Python + Flask + SQLAlchemy)"
    Write-Host ""
}

function Test-Prerequisites {
    Write-Header "Checking Prerequisites"
    
    # Check Python
    Write-Step "Checking Python installation..."
    try {
        $pythonVersion = python --version 2>$null
        if ($pythonVersion) {
            Write-Success "Python found: $pythonVersion"
        } else {
            Write-Error "Python not found in PATH"
            return $false
        }
    } catch {
        Write-Error "Python not found in PATH"
        return $false
    }
    
    # Check Node.js
    Write-Step "Checking Node.js installation..."
    try {
        $nodeVersion = node --version 2>$null
        if ($nodeVersion) {
            Write-Success "Node.js found: $nodeVersion"
        } else {
            Write-Error "Node.js not found in PATH"
            return $false
        }
    } catch {
        Write-Error "Node.js not found in PATH"
        return $false
    }
    
    # Check npm
    Write-Step "Checking npm installation..."
    try {
        $npmVersion = npm --version 2>$null
        if ($npmVersion) {
            Write-Success "npm found: v$npmVersion"
        } else {
            Write-Error "npm not found in PATH"
            return $false
        }
    } catch {
        Write-Error "npm not found in PATH"
        return $false
    }
    
    return $true
}

function Start-Backend {
    Write-Header "Starting Backend (Flask + Python)"
    
    # Check if backend directory exists
    if (-not (Test-Path $BackendDir)) {
        Write-Error "Backend directory not found: $BackendDir"
        return $false
    }
    
    Set-Location $BackendDir
    
    # Check for virtual environment
    $venvPath = Join-Path $BackendDir "venv"
    if (-not (Test-Path $venvPath)) {
        Write-Warning "Python virtual environment not found at $venvPath"
        Write-Step "Creating virtual environment..."
        python -m venv venv
        if (-not $?) {
            Write-Error "Failed to create virtual environment"
            return $false
        }
        Write-Success "Virtual environment created"
    }
    
    # Activate virtual environment
    Write-Step "Activating Python virtual environment..."
    $activateScript = Join-Path $venvPath "Scripts\Activate.ps1"
    if (Test-Path $activateScript) {
        & $activateScript
        Write-Success "Virtual environment activated"
    } else {
        Write-Error "Virtual environment activation script not found"
        return $false
    }
    
    # Install requirements if needed
    if (Test-Path "requirements.txt") {
        Write-Step "Installing Python dependencies..."
        pip install -r requirements.txt
        if ($?) {
            Write-Success "Python dependencies installed"
        } else {
            Write-Warning "Some Python dependencies may not have installed correctly"
        }
    } else {
        Write-Warning "requirements.txt not found in backend directory"
    }
    
    # Start Flask server
    Write-Step "Starting Flask development server..."
    Write-Host "${Green}Backend will start at: https://kairos:5002${Reset}"
    Write-Host "${Yellow}Press Ctrl+C to stop the server${Reset}"
    Write-Host ""
    
    python run.py
    
    return $true
}

function Start-Frontend {
    Write-Header "Starting Frontend (React + Vite)"
    
    # Check if frontend directory exists
    if (-not (Test-Path $FrontendDir)) {
        Write-Error "Frontend directory not found: $FrontendDir"
        return $false
    }
    
    Set-Location $FrontendDir
    
    # Install npm dependencies if needed
    if (-not (Test-Path "node_modules")) {
        Write-Step "Installing Node.js dependencies..."
        npm install
        if ($?) {
            Write-Success "Node.js dependencies installed"
        } else {
            Write-Error "Failed to install Node.js dependencies"
            return $false
        }
    } else {
        Write-Step "Checking for updated Node.js dependencies..."
        npm install
    }
    
    # Start Vite development server
    Write-Step "Starting Vite development server..."
    Write-Host "${Green}Frontend will start at: http://localhost:3000${Reset}"
    Write-Host "${Yellow}Press Ctrl+C to stop the server${Reset}"
    Write-Host ""
    
    npm run dev
    
    return $true
}

function Start-Both {
    Write-Header "Starting Full Development Environment" $Magenta
    Write-Host "${Cyan}This will start both frontend and backend servers in parallel${Reset}"
    Write-Host "${Yellow}Each server will run in its own PowerShell window${Reset}"
    Write-Host ""
    
    # Start backend in new window
    Write-Step "Launching backend server in new window..."
    $backendScript = Join-Path $ScriptDir "start-dev.ps1"
    Start-Process powershell.exe -ArgumentList "-NoExit", "-Command", "& '$backendScript' -BackendOnly"
    
    # Wait a moment for backend to start
    Start-Sleep -Seconds 3
    
    # Start frontend in new window
    Write-Step "Launching frontend server in new window..."
    Start-Process powershell.exe -ArgumentList "-NoExit", "-Command", "& '$backendScript' -FrontendOnly"
    
    Write-Success "Both servers launched in separate windows"
    Write-Host ""
    Write-Host "${Cyan}Development servers:${Reset}"
    Write-Host "  • Backend:  https://kairos:5002"
    Write-Host "  • Frontend: http://localhost:3000"
    Write-Host ""
    Write-Host "${Yellow}To stop servers: Close the respective PowerShell windows${Reset}"
}

# Main execution
if ($Help) {
    Show-Help
    exit 0
}

# Change to project root directory
Set-Location $RootDir

# Check prerequisites
if (-not (Test-Prerequisites)) {
    Write-Error "Prerequisites not met. Please install missing dependencies."
    exit 1
}

# Execute based on parameters
if ($BackendOnly) {
    if (Start-Backend) {
        exit 0
    } else {
        exit 1
    }
} elseif ($FrontendOnly) {
    if (Start-Frontend) {
        exit 0
    } else {
        exit 1
    }
} else {
    Start-Both
    exit 0
}
