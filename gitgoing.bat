@echo off
echo =========================================
echo Setting up Git for ArmyShooter project
echo =========================================

cd /d C:\Users\hoffe\GameMakerProjects\ArmyShooter

echo Initializing repository...
git init

echo Setting branch to main...
git branch -M main

echo Adding files...
git add .

echo Creating initial commit...
git commit -m "Initial commit"

echo Adding GitHub remote...
git remote add origin https://github.com/JohnNWFS/ArmyShooter.git

echo Pushing to GitHub...
git push -u origin main

echo =========================================
echo Done.
echo =========================================
pause