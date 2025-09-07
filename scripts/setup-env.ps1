# Kairos Designer - Environment Setup Script
# This script sets up the development environment from scratch
# Usage: .\scripts\setup-env.ps1

param(
    [switch]$Force,  # Force reinstall even if dependencies exist
    [switch]$Help    # Show help information
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
    Write-Header "Kairos Designer - Environment Setup" $Magenta
    Write-Host ""
    Write-Host "This script sets up the complete development environment for the Kairos Designer project."
    Write-Host ""
    Write-Host "${Cyan}Usage:${Reset}"
    Write-Host "  .\scripts\setup-env.ps1        # Setup complete environment"
    Write-Host "  .\scripts\setup-env.ps1 -Force # Force reinstall all dependencies"
    Write-Host "  .\scripts\setup-env.ps1 -Help  # Show this help"
    Write-Host ""
    Write-Host "${Cyan}What this script does:${Reset}"
    Write-Host "  • Verifies Python and Node.js installations"
    Write-Host "  • Creates Python virtual environment (backend)"
    Write-Host "  • Installs all Python dependencies (Flask, SQLAlchemy, etc.)"
    Write-Host "  • Installs all Node.js dependencies (React, Vite, etc.)"
    Write-Host "  • Verifies the setup by checking key files"
    Write-Host ""
    Write-Host "${Cyan}Prerequisites (must be installed first):${Reset}"
    Write-Host "  • Python 3.8+ with pip"
    Write-Host "  • Node.js 16+ with npm"
    Write-Host "  • Git (for version control)"
    Write-Host "  • PostgreSQL (for the database - can be installed later)"
    Write-Host ""
    Write-Host "${Yellow}Note: This script may take several minutes to complete.${Reset}"
}

function Setup-Backend {
    Write-Header "Setting Up Backend Environment (Python + Flask)"
    
    if (-not (Test-Path $BackendDir)) {
        Write-Error "Backend directory not found: $BackendDir"
        return $false
    }
    
    Set-Location $BackendDir
    
    # Create or recreate virtual environment
    $venvPath = Join-Path $BackendDir "venv"
    if ((Test-Path $venvPath) -and $Force) {
        Write-Warning "Removing existing virtual environment (force mode)"
        Remove-Item $venvPath -Recurse -Force
    }
    
    if (-not (Test-Path $venvPath)) {
        Write-Step "Creating Python virtual environment..."
        python -m venv venv
        if (-not $?) {
            Write-Error "Failed to create virtual environment"
            return $false
        }
        Write-Success "Virtual environment created at: $venvPath"
    } else {
        Write-Step "Using existing virtual environment"
    }
    
    # Activate virtual environment
    Write-Step "Activating virtual environment..."
    $activateScript = Join-Path $venvPath "Scripts\Activate.ps1"
    if (-not (Test-Path $activateScript)) {
        Write-Error "Virtual environment activation script not found"
        return $false
    }
    
    & $activateScript
    Write-Success "Virtual environment activated"
    
    # Upgrade pip
    Write-Step "Upgrading pip to latest version..."
    python -m pip install --upgrade pip
    
    # Install requirements
    if (Test-Path "requirements.txt") {
        Write-Step "Installing Python dependencies from requirements.txt..."
        pip install -r requirements.txt
        if ($?) {
            Write-Success "All Python dependencies installed successfully"
        } else {
            Write-Error "Some Python dependencies failed to install"
            return $false
        }
    } else {
        Write-Warning "requirements.txt not found - skipping Python dependency installation"
    }
    
    # Verify key backend files
    Write-Step "Verifying backend structure..."
    $requiredFiles = @("run.py", "kairos/app.py")
    $allFilesExist = $true
    
    foreach ($file in $requiredFiles) {
        if (Test-Path $file) {
            Write-Host "  ✓ $file" -ForegroundColor Green
        } else {
            Write-Host "  ✗ $file (missing)" -ForegroundColor Red
            $allFilesExist = $false
        }
    }
    
    if ($allFilesExist) {
        Write-Success "Backend structure verified"
    } else {
        Write-Warning "Some backend files are missing - project may not run correctly"
    }
    
    return $true
}

function Setup-Frontend {
    Write-Header "Setting Up Frontend Environment (React + Vite)"
    
    if (-not (Test-Path $FrontendDir)) {
        Write-Error "Frontend directory not found: $FrontendDir"
        return $false
    }
    
    Set-Location $FrontendDir
    
    # Remove node_modules if force mode
    if ((Test-Path "node_modules") -and $Force) {
        Write-Warning "Removing existing node_modules (force mode)"
        Remove-Item "node_modules" -Recurse -Force
    }
    
    # Check for package.json
    if (-not (Test-Path "package.json")) {
        Write-Error "package.json not found in frontend directory"
        return $false
    }
    
    # Install npm dependencies
    Write-Step "Installing Node.js dependencies..."
    Write-Host "  ${Yellow}This may take several minutes...${Reset}"
    
    npm install
    if ($?) {
        Write-Success "All Node.js dependencies installed successfully"
    } else {
        Write-Error "Failed to install Node.js dependencies"
        return $false
    }
    
    # Verify key frontend files
    Write-Step "Verifying frontend structure..."
    $requiredFiles = @(
        "package.json",
        "vite.config.js",
        "index.html",
        "src/main.jsx",
        "src/api/apiBroker.js"
    )
    
    $allFilesExist = $true
    foreach ($file in $requiredFiles) {
        if (Test-Path $file) {
            Write-Host "  ✓ $file" -ForegroundColor Green
        } else {
            Write-Host "  ✗ $file (missing)" -ForegroundColor Red
            $allFilesExist = $false
        }
    }
    
    if ($allFilesExist) {
        Write-Success "Frontend structure verified"
    } else {
        Write-Warning "Some frontend files are missing - project may not run correctly"
    }
    
    return $true
}

function Verify-Setup {
    Write-Header "Verifying Complete Setup"
    
    # Check Python virtual environment
    Set-Location $BackendDir
    $venvPython = Join-Path (Join-Path $BackendDir "venv") "Scripts\python.exe"
    if (Test-Path $venvPython) {
        Write-Success "Python virtual environment: OK"
    } else {
        Write-Error "Python virtual environment: MISSING"
        return $false
    }
    
    # Check key Python packages
    Write-Step "Checking key Python packages..."
    & (Join-Path (Join-Path $BackendDir "venv") "Scripts\Activate.ps1")
    
    $pythonPackages = @("flask", "sqlalchemy", "flask-socketio")
    foreach ($package in $pythonPackages) {
        $result = pip show $package 2>$null
        if ($result) {
            Write-Host "  ✓ $package" -ForegroundColor Green
        } else {
            Write-Host "  ✗ $package" -ForegroundColor Red
        }
    }
    
    # Check Node.js modules
    Set-Location $FrontendDir
    Write-Step "Checking key Node.js packages..."
    
    $nodeModulesPath = Join-Path $FrontendDir "node_modules"
    if (Test-Path $nodeModulesPath) {
        $nodePackages = @("react", "vite", "@vitejs/plugin-react")
        foreach ($package in $nodePackages) {
            $packagePath = Join-Path $nodeModulesPath $package
            if (Test-Path $packagePath) {
                Write-Host "  ✓ $package" -ForegroundColor Green
            } else {
                Write-Host "  ✗ $package" -ForegroundColor Red
            }
        }
    } else {
        Write-Error "node_modules directory not found"
        return $false
    }
    
    return $true
}

# Main execution
Set-Location $RootDir

if ($Help) {
    Show-Help
    exit 0
}

Write-Header "Kairos Designer - Environment Setup" $Magenta
Write-Host "${Cyan}Setting up complete development environment...${Reset}"

# Check prerequisites
Write-Header "Checking Prerequisites"

try {
    $pythonVersion = python --version 2>$null
    if ($pythonVersion) {
        Write-Success "Python: $pythonVersion"
    } else {
        Write-Error "Python not found - please install Python 3.8+ first"
        exit 1
    }
} catch {
    Write-Error "Python not found - please install Python 3.8+ first"
    exit 1
}

try {
    $nodeVersion = node --version 2>$null
    if ($nodeVersion) {
        Write-Success "Node.js: $nodeVersion"
    } else {
        Write-Error "Node.js not found - please install Node.js 16+ first"
        exit 1
    }
} catch {
    Write-Error "Node.js not found - please install Node.js 16+ first"
    exit 1
}

# Setup backend
if (-not (Setup-Backend)) {
    Write-Error "Backend setup failed"
    exit 1
}

# Setup frontend
if (-not (Setup-Frontend)) {
    Write-Error "Frontend setup failed"
    exit 1
}

# Verify complete setup
if (Verify-Setup) {
    Write-Header "Setup Complete!" $Green
    Write-Host ""
    Write-Host "${Green}✓ Development environment is ready!${Reset}"
    Write-Host ""
    Write-Host "${Cyan}Next steps:${Reset}"
    Write-Host "  1. Start development servers: ${Yellow}.\scripts\start-dev.ps1${Reset}"
    Write-Host "  2. Access frontend at: ${Yellow}http://localhost:3000${Reset}"
    Write-Host "  3. Access backend API at: ${Yellow}https://kairos:5002${Reset}"
    Write-Host ""
    Write-Host "${Cyan}Additional setup (if needed):${Reset}"
    Write-Host "  • Configure PostgreSQL database connection"
    Write-Host "  • Set up SSL certificates for HTTPS (if not present)"
    Write-Host "  • Configure environment variables in .env files"
    Write-Host ""
} else {
    Write-Error "Setup verification failed - please check the errors above"
    exit 1
}
