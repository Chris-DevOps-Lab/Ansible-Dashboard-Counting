#!/usr/bin/env bash
set -euo pipefail

DASHBOARD_URL="http://192.168.30.11:9002"
COUNTING_URL="http://192.168.30.12:9001"

echo "1) Testing counting health..."
curl -fsS "${COUNTING_URL}/health"
echo

echo "2) Testing counting endpoint..."
curl -fsS "${COUNTING_URL}/count"
echo

echo "3) Testing dashboard..."
curl -fsSI "${DASHBOARD_URL}" | head
echo

echo "4) Testing dashboard reverse proxy..."
curl -fsS "${DASHBOARD_URL}/api/count"
echo

echo "All tests passed."
