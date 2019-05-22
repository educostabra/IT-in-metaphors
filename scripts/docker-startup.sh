#!/bin/sh
book_folder=book
output_folder=book-output
release_folder=book-output
image_url=https://raw.githubusercontent.com/educostabra/IT-in-metaphors/master/book/

# put the name of your ebook here
book_name=it-in-metaphor-ebook

book_name_asc=$book_name.asc
logs=$output_folder/ebook.log

# you can also personalize your ebook version, if your want
# or remove this parameter if it is too much for you ;)
version=0.1.0

revdate=$(date '+%Y-%m-%d')
params="--attribute revnumber=$version --attribute revdate=$revdate -D $release_folder"

mkdir -p $output_folder
mkdir -p $release_folder

printf "\n--------------------------------------------------------\n" >> $logs
printf "$(date '+%Y-%m-%d %H:%M:%S') ---------- Exporting book formats...\n" >> $logs

printf "Converting to HTML...\n"
asciidoctor $params $book_name_asc >> $logs
printf " -- HTML output at $book_name.html\n"

printf "Converting to EPub...\n"
asciidoctor-epub3 $params $book_name_asc >> $logs
printf " -- Epub output at $book_name.epub\n"

printf "Converting to Mobi (kf8)...\n"
asciidoctor-epub3 $params -a ebook-format=kf8 $book_name_asc >> $logs
printf " -- Mobi output at $book_name.mobi\n"

printf "Converting to PDF... (this one takes a while)\n"
asciidoctor-pdf $params $book_name_asc 2>/dev/null >> $logs
printf " -- PDF  output at $book_name.pdf\n"

# Deal with the images into the html page. 
# Option #1 - It´s possible embed imagens directy in the html
# - Reference https://asciidoctor.org/docs/convert-documents/#managing-images
# Option #2 - Copy the images folder for the same place where the html is located
# Option #3 - Replace the image source by the image URL
printf "Replacing HTML source by the image URL...\n"
sed 's+book/+'$image_url'+g' $release_folder/$book_name.html  > $release_folder/$book_name.html.tmp
rm -f $release_folder/$book_name.html
mv $release_folder/$book_name.html.tmp $release_folder/$book_name.html

printf " Done!\n"
 
