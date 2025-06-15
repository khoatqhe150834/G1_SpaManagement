@echo off

echo Building Spa Management System...

REM Clean and build with Maven
mvn clean package -DskipTests

REM Check if build was successful
if %ERRORLEVEL% EQU 0 (
    echo Build successful! JAR file created at target/spa-management-1.0.0.jar
    dir target\*.jar
) else (
    echo Build failed!
    exit /b 1
) 