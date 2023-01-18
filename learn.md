Telegram API is used to send a message through a Telegram bot to a specified chat when any changes are detected. To use the code, you must supply your Telegram API access token and chat ID. The code also allows you to specify the hash algorithm to use when generating the baseline and checking for changes. By default, it uses SHA-512.

To create the baseline, the code uses the Get-ChildItem cmdlet to recursively scan the specified base directory and generate hashes for all files using the Get-FileHash cmdlet. It stores these hashes in a dictionary object, with the full file paths as keys.

The code then enters a loop that checks for changes to the files in the base directory. It does this by using Get-ChildItem to scan the directory again and recomputing the hashes for all files using Get-FileHash. It then compares these hashes to the values stored in the baseline dictionary. If any differences are detected, it updates the baseline and sets a flag to indicate that changes have been detected.

If the flag is set, the code uses the Invoke-WebRequest cmdlet to send a message through the Telegram API to the specified chat, alerting the user to the detected changes. The code then sleeps for a minute before beginning the next iteration of the loop.
