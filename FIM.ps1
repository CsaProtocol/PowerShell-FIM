# Telegram API access token
$API_TOKEN = 'YOUR_TELEGRAM_BOT_API_TOKEN'
# Telegram chat ID
$CHAT_ID = 'YOUR_CHAT_ID'

# Function to send a Telegram message through a bot
function SendTelegramMessage($message) {
  # Send request to Telegram API
  Invoke-WebRequest -Uri "https://api.telegram.org/bot$API_TOKEN/sendMessage?chat_id=$CHAT_ID&text=$message"
}

# Directory to audit for changes
$baseDirectory = 'C:\MyFiles'

# Hash algorithm to use (SHA-512 in this case)
$hashAlgorithm = 'SHA512'

# Build baseline of target files/folders
$baseline = @{}
Get-ChildItem -Recurse $baseDirectory | ForEach-Object {
  $baseline[$_.FullName] = (Get-FileHash -Path $_.FullName -Algorithm $hashAlgorithm).Hash
}

# Monitor for changes
while ($true) {
  # Check actual files against baseline
  $changesDetected = $false
  Get-ChildItem -Recurse $baseDirectory | ForEach-Object {
    $currentHash = (Get-FileHash -Path $_.FullName -Algorithm $hashAlgorithm).Hash
    if ($baseline[$_.FullName] -ne $currentHash) {
      # Changes from the baseline detected
      $changesDetected = $true
      # Update baseline
      $baseline[$_.FullName] = $currentHash
    }
  }

  if ($changesDetected) {
    # Send alert message via Telegram
    SendTelegramMessage "Possible compromise detected in $baseDirectory. Please investigate."
  }

  # Sleep for a minute before checking again
  Start-Sleep -Seconds 60
}
