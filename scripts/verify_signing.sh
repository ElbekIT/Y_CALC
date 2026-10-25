#!/usr/bin/env bash
set -e

KEYSTORE="android/app/upload-keystore.jks"
PROPERTIES="android/key.properties"

echo "=== 1. Checking files ==="
if [ ! -f "$KEYSTORE" ]; then
    echo "ERROR: $KEYSTORE not found!"
    exit 1
fi
echo "[OK] Keystore found: $KEYSTORE"

if [ ! -f "$PROPERTIES" ]; then
    echo "ERROR: $PROPERTIES not found!"
    exit 1
fi
echo "[OK] Properties found: $PROPERTIES"

echo "=== 2. Verifying Keystore Integrity ==="
keytool -list -v -keystore "$KEYSTORE" -storepass "YCalcUploadPass2026!" | grep -E "Alias name|Valid from|Owner|SHA256"

echo "=== ALL CHECKS PASSED ==="
