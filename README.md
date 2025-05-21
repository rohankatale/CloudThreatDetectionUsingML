# AWS Cloud Threat Detection Using Machine Learning

This project implements a machine learning-based Intrusion Detection System (IDS) for identifying and mitigating cloud security threats such as DoS, DDoS, and SQL Injection attacks. It leverages PCA for dimensionality reduction and deep learning models—ANN, CNN, and LSTM—for classification. The final deployment utilizes an ANN model optimized for real-time performance on an AWS EC2 free-tier instance.

## 🧠 Project Overview

The core objective of this project is to build a cost-effective, scalable, and real-time IDS solution for cloud environments using machine learning. We simulate real-world attacks and process live packet captures for detection using ML pipelines trained on the CSE-CIC-IDS2018 dataset.

## 🚀 Features

-   Real-time attack simulation (DoS, DDoS, SQLi) using HULK, Metasploit, and SQLMap
-   Packet capture via `tcpdump` and converted into csv file by generalising with 80 features using CICFlowMeter
-   Dimensionality reduction using Principal Component Analysis (PCA)
-   Deep learning models: ANN (deployed), CNN, LSTM (evaluated)
-   Deployed on AWS EC2 (t2.micro, Free Tier) 
-   Automated alerting via SMTP email notifications

## 🏗️ Architecture

![Architecture Diagram](https://github.com/user-attachments/assets/e8daad14-28cf-4c83-aa8b-b4d2690117c2)


## ⚙️ Setup Instructions

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/rohankatale/CloudThreatDetectionUsingML.git
    cd CloudThreatDetectionUsingML
    ```
    

2.  **Launch EC2 Instance (Ubuntu 24.04):**
    *   **Type:** `t2.micro` (Free Tier eligible)
    *   **Security Group:** Allow inbound TCP (for SSH, web server if any) and ICMP (for ping/testing) traffic. Specifically, allow:
        *   SSH (TCP port 22) from your IP
        *   Any other ports your application might need.

3.  **Install Dependencies:**
    Connect to your EC2 instance via SSH and run:
    ```bash
    sudo apt update && sudo apt install -y tcpdump openjdk-17-jdk python3-venv
    ```

4.  **Set Up CICFlowMeter in your local EC2 instance:**
    Install CICFlowMeter natively using Gradle:
    ```bash
    cd ~
    git clone https://github.com/ahlashkari/CICFlowMeter.git
    cd CICFlowMeter
    ./gradlew build
    ```
    Ensure `jnetpcap` libraries are correctly configured. This might involve setting `LD_LIBRARY_PATH` or ensuring the `.so` files are in a standard library path. Refer to CICFlowMeter documentation for troubleshooting.

5.  **Run Packet Capture Script:**
    Navigate back to your project directory (`cloud-threat-detection`).
    Make the script executable and run it:
    ```bash
    chmod +x capture_and_process.sh
    ./capture_and_process.sh 300  # Capture for 5 minutes (300 seconds)
    ```
    This script will typically:
    *   Use `tcpdump` to capture packets and save them to the `/packet_captures` directory.
    *   Use CICFlowMeter to process the `.pcap` files and generate `.csv` flow logs in the `/flow_logs` directory.

6.  **Deploy ANN Model:**
    Activate your Python environment:
    ```bash
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
    ```
    Run your ANN model on the generated CSV files (based on `ANN.ipynb` logic). This will involve loading the pre-trained model, preprocessing new flow data, and making predictions.

7.  **Configure Email Alerting (Optional):**
    Use Python’s `smtplib` to send alert notifications when anomalies are detected. You'll need to configure SMTP server details (e.g., Gmail, SendGrid) and recipient email addresses within your Python scripts.

## 📊 Results

| Model | Accuracy | Inference Time | PCA Used |
| :---- | :------- | :------------- | :------- |
| ANN   | 98.24%   | 78 sec         | ✅        |
| CNN   | 98.50%   | 83 sec         | ✅        |
| LSTM  | 98.73%   | 214 sec        | ✅        |

*ANN was selected for real-time deployment due to optimal trade-off between accuracy and speed on CPU-based infrastructure.*

## 📚 Dataset

-   **Name:** CSE-CIC-IDS2018
-   **Source:** Canadian Institute for Cybersecurity (CIC)
-   **Features:** 80+ features, 14 attack types including DoS, DDoS, Brute Force, SQLi, etc.

## 🧪 Attack Tools Used

| Attack Type | Tool       | Description                              |
| :---------- | :--------- | :--------------------------------------- |
| DoS         | HULK       | Floods HTTP GET/POST requests            |
| DDoS        | Metasploit | TCP SYN flood using auxiliary module     |
| SQLi        | SQLMap     | Auto SQL injection detection & exploitation |

## 📩 Alert Mechanism

Upon detection of anomalies:
-   Sends email alerts to the EC2 instance owner (or a configured administrator email).
-   Details include potential attack type and timestamp.
-   SMTP client (e.g., Python's `smtplib`) used for notification delivery.



This project is developed as part of a B.Tech Pre-Final Year Project (2025). Intended for academic use only.

