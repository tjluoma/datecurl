#!/bin/zsh
#Download today's edition of a newspaper in PDF form. Could be adapted for any URL which changes based on the date.

# variable to refer to this script name
NAME="$0:t"

# in case we need to bail out
die ()
{
	echo "$NAME: $@"
	exit 1
}

#########|#########|#########|#########|#########|#########|#########|#########

	# !!! CHANGE THIS to wherever you want the PDFs to be stored
SAVE_DIR="$HOME/Dropbox/Newspaper"

[[ -d "$SAVE_DIR" ]] || mkdir -p "$SAVE_DIR" || die "Failed to create $SAVE_DIR"

#########|#########|#########|#########|#########|#########|#########|#########

	# this loads a module in zsh which lets you deal with dates
	# you could also use
	#	date '+%m/%d/%Y'
	# but zsh has it built-in
zmodload zsh/datetime

	# will output today's date such like 20120319 for March 19 2012
RAW_DATE=$(strftime '%Y%m%d' "$EPOCHSECONDS")

	# Use the $RAW_DATE to name the output file
TODAYS_FILE="$SAVE_DIR/$RAW_DATE.pdf"

	# if we have already downloaded today's file, exit
[[ -e "$TODAYS_FILE" ]] && exit 0

	# will output today's date such like 2012/03/19 for March 19 2012
SLASH_DATE=$(strftime '%Y/%m/%d' "$EPOCHSECONDS")


	# !!! CHANGE THIS if you want to download a different URL
URL="http://epaper.arkansasonline.com/Repository/ArDemocrat/$SLASH_DATE/ADGC${RAW_DATE}Cityall.pdf#OLV0_Page_0001"

#########|#########|#########|#########|#########|#########|#########|#########

# check to make sure the server returned 200 for the URL
# Note: some servers don't support --head so you should check to make sure yours does
# by using
#	curl -sL --head http://your.serv.er/here/

STATUS=$(curl -Ls --head "$URL" | awk -F' ' '/^HTTP/{print $2}' | tail -1)

if [[ "$STATUS" == "200" ]]
then

	echo "$NAME: Downloading $URL to $TODAYS_FILE"

	# Try to download today's file, and if it fails, delete the file so
	# we'll know to try again later

	# IF We are launched via launchd then we want to log the output to a file
	PPID_NAME=$(command ps -cp $PPID | tail -1 | awk '{print $4}')
	LAUNCHD=no

	case "${PPID_NAME}" in
		*launchd)
					# IF we are launched via launchd, then use a file for any errors
					# but otherwise be silent.
					curl --silent --location --stderr "$HOME/Desktop/$NAME.$RAW_DATE.errors.txt" --output "$TODAYS_FILE" "$URL" || rm -f "$TODAYS_FILE"
		;;

		*)
					# if we are NOT launched via launchd use a progress bar and output to stdout
					curl --progress-bar --location --output "$TODAYS_FILE" "$URL" || rm -f "$TODAYS_FILE"
		;;
	esac

else
	die "$URL does not exist"
fi

exit 0
#
##### ---FOOTER --- #####
# From:	Timothy J. Luoma
# Mail:	luomat at gmail dot com
# Date:	2012-03-23
# Link:	http://bin.luo.ma/
# MAKE_PUBLIC:YES
#
#EOF
