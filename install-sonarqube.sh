#!/bin/bash
# ── SonarQube Installation Script ──────────────────────────────────────────

echo ">>> Step 1: Install Java 17"
sudo apt update -y
sudo apt install -y openjdk-17-jdk
java -version

echo ">>> Step 2: Create sonar user (SonarQube cannot run as root)"
sudo adduser --system --no-create-home --group --disabled-login sonarqube

echo ">>> Step 3: Download SonarQube"
cd /opt
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.4.1.88267.zip
sudo apt install -y unzip
sudo unzip sonarqube-10.4.1.88267.zip
sudo mv sonarqube-10.4.1.88267 sonarqube
sudo rm sonarqube-10.4.1.88267.zip

echo ">>> Step 4: Set ownership"
sudo chown -R sonarqube:sonarqube /opt/sonarqube

echo ">>> Step 5: Set kernel parameters (required by SonarQube/Elasticsearch)"
sudo sysctl -w vm.max_map_count=524288
sudo sysctl -w fs.file-max=131072
echo "vm.max_map_count=524288" | sudo tee -a /etc/sysctl.conf
echo "fs.file-max=131072"      | sudo tee -a /etc/sysctl.conf

echo ">>> Step 6: Set ulimits"
echo "sonarqube   -   nofile   131072" | sudo tee -a /etc/security/limits.conf
echo "sonarqube   -   nproc    8192"   | sudo tee -a /etc/security/limits.conf

echo ">>> Step 7: Create systemd service"
sudo tee /etc/systemd/system/sonarqube.service > /dev/null <<EOF
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=sonarqube
Group=sonarqube
Restart=always
LimitNOFILE=131072
LimitNPROC=8192

[Install]
WantedBy=multi-user.target
EOF

echo ">>> Step 8: Enable and start SonarQube"
sudo systemctl daemon-reload
sudo systemctl enable sonarqube
sudo systemctl start sonarqube

echo ""
echo ">>> SonarQube starting on http://<your-server-ip>:9000"
echo ">>> Default credentials: admin / admin"
echo ">>> Check status: sudo systemctl status sonarqube"
echo ">>> Check logs:   tail -f /opt/sonarqube/logs/sonar.log"
