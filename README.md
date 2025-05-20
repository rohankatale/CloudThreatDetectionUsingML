AWS Cloud Threat Detection Using Machine Learning

This project implements a machine learning-based Intrusion Detection System (IDS) for identifying and mitigating cloud security threats such as DoS, DDoS, and SQL Injection attacks. It leverages PCA for dimensionality reduction and deep learning models—ANN, CNN, and LSTM—for classification. The final deployment utilizes an ANN model optimized for real-time performance on an AWS EC2 free-tier instance.



🧠 Project Overview

The core objective of this project is to build a cost-effective, scalable, and real-time IDS solution for cloud environments using machine learning. We simulate real-world attacks and process live packet captures for detection using ML pipelines trained on the CSE-CIC-IDS2018 dataset.



🚀 Features





Real-time attack simulation (DoS, DDoS, SQLi) using HULK, Metasploit, and SQLMap



Packet capture via tcpdump and flow generation using CICFlowMeter



Dimensionality reduction using Principal Component Analysis (PCA)



Deep learning models: ANN (deployed), CNN, LSTM (evaluated)



Deployed on AWS EC2 (t2.micro, Free Tier)



Automated alerting via SMTP email notifications



🏗️ Architecture





Replace path/to/your/image.png with the actual path to your architecture diagram image inside the repository.



📁 Repository Structure

.
├── ANN.ipynb                 # ANN model training and evaluation
├── CNN.ipynb                 # CNN model experiments
├── LSTM.ipynb                # LSTM model experiments
├── capture_and_process.sh    # Bash script for packet capture and flow generation
├── /packet_captures          # Generated .pcap files (created at runtime)
├── /flow_logs                # Generated .csv flow logs
├── README.md                 # This file



⚙️ Setup Instructions

1. Clone the repository

git clone https://github.com/<your-username>/cloud-threat-detection.git
cd cloud-threat-detection

2. Launch EC2 Instance (Ubuntu 24.04)





Type: t2.micro (Free Tier)



Allow inbound TCP and ICMP traffic in the security group

3. Install Dependencies

sudo apt update && sudo apt install -y tcpdump openjdk-17-jdk python3-venv

4. Set Up CICFlowMeter

Install CICFlowMeter natively using Gradle:

cd ~
git clone https://github.com/ahlashkari/CICFlowMeter.git
cd CICFlowMeter
./gradlew build

Ensure jnetpcap libraries are correctly configured.

5. Run Packet Capture Script

chmod +x capture_and_process.sh
./capture_and_process.sh 300  # Capture for 5 minutes (300 seconds)

6. Deploy ANN Model

Activate your Python environment:

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

Run your ANN model on the generated CSV files (based on ANN.ipynb logic).

7. Configure Email Alerting (Optional)

Use Python’s smtplib to send alert notifications when anomalies are detected.



📊 Results







Model



Accuracy



Inference Time



PCA Used





ANN



98.24%



78 sec



✅





CNN



98.50%



83 sec



✅





LSTM



98.73%



214 sec



✅

ANN was selected for real-time deployment due to optimal trade-off between accuracy and speed on CPU-based infrastructure.



📚 Dataset





Name: CSE-CIC-IDS2018



Source: Canadian Institute for Cybersecurity



Features: 80+ features, 14 attack types including DoS, DDoS, Brute Force, SQLi, etc.



🧪 Attack Tools Used







Attack Type



Tool



Description





DoS



HULK



Floods HTTP GET/POST requests





DDoS



Metasploit



TCP SYN flood using auxiliary module





SQLi



SQLMap



Auto SQL injection detection & exploitation



📩 Alert Mechanism

Upon detection of anomalies:





Sends email alerts to the EC2 instance owner



Details include attack type and timestamp



SMTP client used for notification delivery



👥 Team Members





Rohan Katale



Nikhil Prajapati



Shreyansh Kachhadiya



Nikit Patidar

Under the supervision of Dr. Shivangi Shukla, IIIT Pune



📄 License

This project is developed as part of a B.Tech Final Year Project (2025). Intended for academic use only.
