# Build Script for HughPH.Box2D

$ErrorActionPreference = "Stop"

Write-Host "Starting Build Process..." -ForegroundColor Cyan

# 1. Update Submodules
Write-Host "Updating submodules..." -ForegroundColor Yellow
git submodule update --init --recursive

# 2. Build Native Box2D
Write-Host "Building native Box2D..." -ForegroundColor Yellow
$box2dSource = ".\box2d_source"
$buildDir = "$box2dSource\build"

if (-not (Test-Path $buildDir)) {
    New-Item -ItemType Directory -Path $buildDir | Out-Null
}

Push-Location $buildDir

# Check for CMake
if (-not (Get-Command cmake -ErrorAction SilentlyContinue)) {
    Write-Host "CMake not found in PATH. Searching known locations..." -ForegroundColor Yellow
    $cmakePaths = @(
        "C:\Program Files\CMake\bin",
        "C:\Program Files (x86)\CMake\bin",
        "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin",
        "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin",
        "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin"
    )
    
    foreach ($path in $cmakePaths) {
        if (Test-Path "$path\cmake.exe") {
            Write-Host "Found CMake at $path" -ForegroundColor Green
            $env:PATH = "$path;$env:PATH"
            break
        }
    }
}

if (-not (Get-Command cmake -ErrorAction SilentlyContinue)) {
    Write-Error "CMake is not installed or not in PATH. Please install CMake or Visual Studio with C++ CMake tools."
}

# Configure CMake
# -BUILD_SHARED_LIBS=ON is critical for creating a DLL
# -BOX2D_SAMPLES=OFF to speed up build
cmake .. -DBOX2D_SAMPLES=OFF -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release

# Build
cmake --build . --config Release

Pop-Location

# 3. Copy Native Binary
Write-Host "Copying native binary..." -ForegroundColor Yellow
$nativeDest = ".\src\Box2DBindings\native\win-x64"
if (-not (Test-Path $nativeDest)) {
    New-Item -ItemType Directory -Path $nativeDest -Force | Out-Null
}

# Source path might vary slightly depending on cmake generator, checking common locations
$possiblePaths = @(
    "$buildDir\src\Release\box2d.dll",
    "$buildDir\bin\Release\box2d.dll",
    "$buildDir\Release\box2d.dll"
)

$dllFound = $false
foreach ($path in $possiblePaths) {
    if (Test-Path $path) {
        Copy-Item -Path $path -Destination "$nativeDest\libbox2d.dll" -Force
        Write-Host "Copied $path to $nativeDest\libbox2d.dll" -ForegroundColor Green
        $dllFound = $true
        break
    }
}

if (-not $dllFound) {
    Write-Error "Could not find built box2d.dll in expected locations."
}

# 4. Build .NET Solution
Write-Host "Building .NET Solution..." -ForegroundColor Yellow
dotnet build Box2DDotnetBindings.sln -c Release

Write-Host "Build Complete!" -ForegroundColor Green
