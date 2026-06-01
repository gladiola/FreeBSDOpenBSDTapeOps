#!/usr/bin/env sh
clear
echo "scriptedDemo"
echo "Press ENTER to continue."
read INPUT
## Check tape
echo "Check if tape is staged in machine."
echo "Press ENTER to continue."
read INPUT
clear
## Load the tape into the machine
echo "Here we go."
echo
echo "Rewinding tape to beginning (OpenBSD: no 'mt load'; assumes tape is present)."
echo "mt -f /dev/nrst0 rewind"
mt -f /dev/nrst0 rewind
## Rewind tape
echo "Rewinding tape"
echo "mt -f /dev/nrst0 rewind"
mt -f /dev/nrst0 rewind
echo "Press ENTER to continue."
read INPUT
clear
echo "Reading status from tape."
echo "mt -f /dev/nrst0 status"
mt -f /dev/nrst0 status
echo
echo "Press ENTER to continue."
read INPUT
clear
echo "Looking for file 0 on the tape."
echo "We should be at the beginning."
echo "So, no mt commands this time."
echo "tar t -f /dev/nrst0"
tar t -f /dev/nrst0
echo
echo "Press ENTER to continue."
read INPUT
clear
echo "Looking for file 1 on tape."
echo "Rewind to the beginning."
mt -f /dev/nrst0 rewind
echo "Go forward space count 1 file."
echo "mt -f /dev/nrst0 fsf 1"
mt -f /dev/nrst0 fsf 1
echo "tar t -f /dev/nrst0"
tar t -f /dev/nrst0
echo "Press ENTER to continue."
read INPUT
clear
echo "Looking for file 2 on tape."
echo "Back up to 0 and go forward space count 2 files."
echo "mt -f /dev/nrst0 rewind"
mt -f /dev/nrst0 rewind
echo "mt -f /dev/nrst0 fsf 2"
mt -f /dev/nrst0 fsf 2
echo "Show where we are with status."
echo "mt -f /dev/nrst0 status"
mt -f /dev/nrst0 status
echo
echo "Look in that spot with tar."
echo "tar t -f /dev/nrst0"
tar t -f /dev/nrst0
echo "Press ENTER to continue."
read INPUT
clear
echo "Looking for third archive on tape."
echo "Back up to 0 and go forward space count 3 files."
echo "mt -f /dev/nrst0 rewind"
mt -f /dev/nrst0 rewind
echo "mt -f /dev/nrst0 fsf 3"
mt -f /dev/nrst0 fsf 3
echo "See where we are with status."
echo "mt -f /dev/nrst0 status"
mt -f /dev/nrst0 status
echo
echo "See what is here with tar."
echo "tar t -f /dev/nrst0"
tar t -f /dev/nrst0
echo "Press ENTER to continue."
read INPUT
clear
echo "Take the tape offline."
echo "Rewind tape."
echo "mt -f /dev/nrst0 rewind"
mt -f /dev/nrst0 rewind
echo "mt -f /dev/nrst0 offline"
mt -f /dev/nrst0 offline
exit 0
