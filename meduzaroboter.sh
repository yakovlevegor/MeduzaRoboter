#!/bin/sh

curl -L -o "meduza_rss_latest.txt" "https://meduza.io/rss/en/all"

novoice=0

for argum in $@; do
    if [ "$argum" == "--novoice" ]; then
        novoice=1;
    fi
done;

if [ ! -d "meduza_articles_text" ]; then
    mkdir "meduza_articles_text";
fi

if [[ $novoice -eq 0 ]]; then
    if [ ! -d "meduza_articles_voice" ]; then
        mkdir "meduza_articles_voice";
    fi
fi

articlescount=$(xml sel -N atom="http://www.w3.org/2005/Atom" -N content="http://purl.org/rss/1.0/modules/content/" -t -v "count(/rss/channel/item)" meduza_rss_latest.txt);

articlesdone=1;

while [[ $articlesdone -le $articlescount ]]; do
    articleurlname=$(xml sel -N atom="http://www.w3.org/2005/Atom" -N content="http://purl.org/rss/1.0/modules/content/" -t -v "/rss/channel/item[$articlesdone]/link" meduza_rss_latest.txt | sed -E "s/https:\/\/meduza.io\/en\///" | sed -E "s/\//-/g");
    articlepubdate=$(date -u --date="$(xml sel -N atom="http://www.w3.org/2005/Atom" -N content="http://purl.org/rss/1.0/modules/content/" -t -v "/rss/channel/item[$articlesdone]/pubDate" meduza_rss_latest.txt)" +%d_%m_%y);
    articlename=$articlepubdate"_"$articleurlname;
    if [ ! -f "meduza_articles_text/"$articlename".txt" ]; then
        xml sel -N atom="http://www.w3.org/2005/Atom" -N content="http://purl.org/rss/1.0/modules/content/" -t -v "/rss/channel/item[$articlesdone]/title" meduza_rss_latest.txt > "meduza_articles_text/"$articlename".txt";
        echo "" >> "meduza_articles_text/"$articlename".txt";
        echo "" >> "meduza_articles_text/"$articlename".txt";
        xml sel -N atom="http://www.w3.org/2005/Atom" -N content="http://purl.org/rss/1.0/modules/content/" -t -v "/rss/channel/item[$articlesdone]/content:encoded" meduza_rss_latest.txt | sed -E "s/&lt;p&gt;Save Meduza\!&lt;br&gt;&lt;a href='https:\/\/support.meduza.io\/en'&gt;https:\/\/support.meduza.io\/en&lt;\/a&gt;&lt;\/p&gt;//" | html2text --body-width=0 | html2text --images-to-alt --ignore-emphasis --ignore-links --body-width=0 >> "meduza_articles_text/"$articlename".txt";
    fi
    if [[ $novoice -eq 0 ]]; then
        if [ ! -f "meduza_articles_voice/"$articlename".wav" ]; then
            espeak -f "meduza_articles_text/"$articlename".txt" -s 260 -a 50 -g 6 -p 30 -w "meduza_articles_voice/"$articlename".wav";
        fi
    fi
    articlesdone=($articlesdone+1);
done
