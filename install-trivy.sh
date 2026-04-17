#!/bin/bash
# ── Trivy Installation Script ───────────────────────────────────────────────

echo ">>> Step 1: Add Trivy repository"
sudo apt install -y wget apt-transport-https gnupg lsb-release

wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key \
    | gpg --dearmor \
    | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" \
    | sudo tee /etc/apt/sources.list.d/trivy.list

echo ">>> Step 2: Install Trivy"
sudo apt update -y
sudo apt install -y trivy

echo ">>> Step 3: Verify installation"
trivy --version

echo ">>> Step 4: Update Trivy vulnerability database"
trivy image --download-db-only

echo ""
echo ">>> Trivy installed successfully"
echo ">>> Usage examples:"
echo "    trivy fs .                          # scan filesystem"
echo "    trivy image <image-name>            # scan docker image"
echo "    trivy fs --severity HIGH,CRITICAL . # scan only high/critical"
