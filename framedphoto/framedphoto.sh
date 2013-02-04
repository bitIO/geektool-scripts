#!/bin/bash
function die(){
    echo $@
    exit 1
}

function moveOnePhoto(){
    echo "Moving one photo from $1 to $2"
    SAVEIFS=$IFS
    IFS=$'\n'

    # Clean previous framed photo
    rm -f $2/framedphoto.jpg

    cd $1
    files=($1/*)
    mv "${files[RANDOM % ${#files[@]}]}" $2/framedphoto.jpg

    IFS=$SAVEIFS
}

# Select 25 random files of the given year and copy them to a new folder. This is
# done in order to not to remove/destroy something it wasn't ment to. In order to
# prevent problems with whitespaces in filenames, the Internal Field Separator is
# is changed to "newline"
# arg 1: soucer folder + selected year
function findAndCopyPhotos() {
    echo "looking 4 photos in $1 "
    SAVEIFS=$IFS
    IFS=$'\n'

    # since I have all the folders named year-month, i need to search in all the
    # folders which name starts with the year, that is, 2012-01 to 2012-12 (i.e.)
    find $1-* -type f -name "*.jpg" -o -name "*.JPG" |
    while read x; do echo "`expr $RANDOM % 1000`:$x"; done | sort -n |
    sed 's/[0-9]*://' | head -25 | while read result; do cp $result $2; done

    IFS=$SAVEIFS
}

function applyFrame() {
	echo "appling frame in directory $1"
	SAVEIFS=$IFS
	IFS=$'\n'

	cd $1
	for image in `ls .`
	do
		echo "processing file $image ..."
		# create the appropriated thumbnail to fit into the frame
		$($CONVERT $image -thumbnail '240x300^' -gravity center -extent 240x300 thumbnail_$image)
		# combine the frame and the thumbnail
		$($CONVERT $FRAMEPATH thumbnail_$image -gravity center -compose DstOver -composite border_overlaid_$image.png)
		rm thumbnail_$image
		rm $image
	done
	cd -
	IFS=$SAVEIFS
}

CONVERT=$(which convert)
[ $? -eq 1 ] && die "Command convert not found. Install imagemagick package" || :

# program setup
FRAMEPATH=~/Development/geektool/framedphoto/frames/polaroid-000.png
SOURCEPHOTOSPATH=~/Pictures/Picasa-pruebas

FRAMEDPHOTOPATH=/tmp/geektool/framedphoto
TEMPPHOTOSPATH=/tmp/geektool/framedphoto/tmp
YEARFILE=/tmp/geektool/framedphoto/year

if [[ ! -d $FRAMEDPHOTOPATH ]]; then
	mkdir -p $FRAMEDPHOTOPATH
fi

if [[ ! -d $TEMPPHOTOSPATH ]]; then
	mkdir -p $TEMPPHOTOSPATH
fi


# Check if there are any photo remaining to be shown. If so, move one photo to the
# designated folder (the one is used to display de photos) and them exit.
remaining=`ls $TEMPPHOTOSPATH| wc -l | sed "s/\ //g"`
if [[ $remaining -ne "0" ]]; then
    echo "$TEMPPHOTOSPATH has photos to be used"
    moveOnePhoto "$TEMPPHOTOSPATH" "$FRAMEDPHOTOPATH"
    exit 0
fi

YEARS=("2003" "2004" "2005" "2006" "2007" "2008" "2009" "2010" "2011" "2012" "2013")
RAND=$$$(date +%s)
SELECTEDYEAR=${YEARS[$RAND % ${#YEARS[@]} ]}

echo $SELECTEDYEAR > $YEARFILE

findAndCopyPhotos "$SOURCEPHOTOSPATH/$SELECTEDYEAR" "$TEMPPHOTOSPATH"
applyFrame "$TEMPPHOTOSPATH"
moveOnePhoto "$TEMPPHOTOSPATH" "$FRAMEDPHOTOPATH"