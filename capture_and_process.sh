#!/bin/bash

# Directory setup
CAPTURE_DIR="$HOME/packet_captures"
LOG_DIR="$HOME/flow_logs"

# Create directories if they don’t exist
mkdir -p "$CAPTURE_DIR" || { echo "Failed to create $CAPTURE_DIR"; exit 1; }
mkdir -p "$LOG_DIR" || { echo "Failed to create $LOG_DIR"; exit 1; }

# Determine next file number
LAST_NUM=$(ls "$CAPTURE_DIR"/capture_*.pcap 2>/dev/null | sed -E 's/.*capture_([0-9]+)\.pcap/\1/' | sort -n | tail -n 1)
NEXT_NUM=$((LAST_NUM + 1))
PCAP_FILE="$CAPTURE_DIR/capture_$NEXT_NUM.pcap"
CSV_FILE="$LOG_DIR/flows_$NEXT_NUM.csv"

# Capture packets for specified duration (default 5 minutes)
DURATION=${1:-300}
echo "Starting packet capture for $DURATION seconds..."
sudo tcpdump -i any -s 0 -w "$PCAP_FILE" -G "$DURATION" -W 1 || { echo "Packet capture failed"; exit 1; }

# Check if the file exists (accounting for possible .0 suffix from -G)
if [ ! -f "$PCAP_FILE" ] && [ -f "$PCAP_FILE.0" ]; then
    mv "$PCAP_FILE.0" "$PCAP_FILE"
fi
[ -f "$PCAP_FILE" ] || { echo "PCAP file not found at $PCAP_FILE"; exit 1; }

echo "Packet capture completed. Processing with CICFlowMeter..."

# Run CICFlowMeter with jnetpcap path and positional arguments
JAVA_LIB_PATH="$HOME/CICFlowMeter/jnetpcap/linux/jnetpcap-1.4.r1425"
JAR_PATH="$HOME/CICFlowMeter/build/libs/CICFlowMeter-4.0.jar"
java -Djava.library.path="$JAVA_LIB_PATH" -jar "$JAR_PATH" "$PCAP_FILE" "$LOG_DIR" || { echo "CICFlowMeter processing failed"; exit 1; }

echo "Processing complete. Flow data saved to $CSV_FILE"

