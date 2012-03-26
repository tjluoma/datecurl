
# README for datecurl #

A [TUAW][] reader wrote in asking for help downloading his local newspaper's PDF every day.

He had been trying to use Automator, but wasn't able to get it to work.

Instead of using Automator, I solved this problem using `curl` and `launchd`

The `datecurl.sh` script should be easily adaptable to other scenarios.

## launchd

The launchd plist file tells the script to run every day at 6:00 A.M. This assumes that the PDF will always be available at that time, and that the computer will be on at that time, and a network connection will be available at that time.

If any of those things are unsure, I would recommend changing the plist file to run more than once each day. The script is smart enough to exit if the current day's file has already been downloaded.


Also, the plist assumes that the script has been installed to `/usr/local/bin/datecurl.sh`

If that is not where it has been installed, edit the plist to point to the full path:

	<string>/usr/local/bin/datecurl.sh</string>

## Installation

The .plist file has to be located at ~/Library/LaunchAgents/ in order to be automatically loaded by the system.

If you want to load it without rebooting first, copy the file to ~/Library/LaunchAgents/ and then do this in Terminal:

	cd ~/Library/LaunchAgents/

	launchctl load com.tjluoma.datecurl.plist

[TUAW]:	http://tuaw.com
