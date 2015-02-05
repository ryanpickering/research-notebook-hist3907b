#! /bin/bash
 
pages=$(curl 'http://search.canadiana.ca/search?q=ottawa&field=&df=1800&dt=1900&fmt=json' | jq '.pages')
 
# this goes into the results and reads the value of 'pages' in each one of them.
# it then tells us how many pages we're going to have.
 
echo "Pages:"$pages
 
# this says 'for each one of these pages, download the 'key' value on each page'
 
for i in $(seq 1 $pages)
do
        curl ‘http://search.canadiana.ca/search/‘${i}'?q=ottawa&field=&df=1800&dt=1900&fmt=json’ | jq '.docs[] | {key}' >> results.txt
done
 
sed -e 's/\"key\": \"//g' results.txt | tr -d "\" | tr -d "{" | tr -d "}" | tr -s " " | sed '/^\s*$/d' | tr -d ' ' > cleanlist.txt
# this adds a prefix and a suffix.
 
awk '$0="eco.canadiana.ca/view/"$0' cleanlist.txt| awk '{print $0 "/1?r=0&s=1&fmt=json&api_text=1"}' > urlstograb.txt
 
# then if we want we can take those URLs and output them all to a big text file for analysis.
 
wget -i urlstograb.txt -O output.txt
