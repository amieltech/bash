#!/bin/bash

# The thought of creating this came out of a discussion on linkedin on November 19, 2013.
# There are probably hosts of canned applications to do this kind of thing, and even more scripts...
# But just for giggles.
#
# Depends: rhash, bash
# Recommends: gedit, sendmail, cron

# Copyright (C) 2013 Amiel Summers
#        This program is free software; you can redistribute it and/or
#        modify it under the terms of the GNU General Public License
#        as published by the Free Software Foundation; either version 2
#        of the License, or (at your option) any later version.

#        This program is distributed in the hope that it will be useful,
#        but WITHOUT ANY WARRANTY; without even the implied warranty of
#        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#        GNU General Public License for more details.

#        You should have received a copy of the GNU General Public License
#        Along with this program; if not, write to the Free Software
#        Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#


TARGET="$1"

# Note: For effective use change STORAGE location to wherever you deem to be appropriate.
STORAGE="/srv/hashtables"

	T1=${STORAGE//[//]/_}
	T2=${TARGET//'/'/'_'}

if [ $# -ne 1 ]; then
	echo $'\n This routine works on directories, creating (and persisting) HASH values in tables'
	echo $' for security validation purposes.\n'
	echo $' NOTE: You must provide the full path here.\n\n'
	echo $' The default sorage locations is' $STORAGE
exit;
fi


if [ ! -d $STORAGE ]; then
	echo "Creating directories $STORAGE"
	mkdir -p $STORAGE
	sleep 1
fi

# start doing something.
# 	1. Check if hashes alread exist.
if [ -f $T1/$T2.list ]
then
	echo "Hash store already exists for $TARGET"
	echo "performing checks."
	echo ""
	
	rhash $TARGET --check $T1/$T2.list

	RES=$(rhash $TARGET --check $T1/$T2.list | grep ERR)
 	if [ -n "$RES" ]; then
		n="The hash for $(echo $RES | sed "s/ERR//") has changed since the hash was created. DO SOMETHING!"
		echo ""		
		echo "$n"
	fi
else

	echo  "create new store for $TARGET.."
	echo  "adding $TARGET hash values to $T1/$T2.list"
	echo  " "
	rhash $TARGET --bsd --recursive --verbose --speed --output $T1/$T2.list
fi



