#!/bin/bash

input_xml="data0422.xml"

item_ids=$(xmllint --xpath "//item/@no" $input_xml | sed 's/no="\([0-9]*\)"/\1/g')
echo "item_ids: $item_ids"

for id in $item_ids
do
  echo "item_id: $id"
  xsltproc --stringparam item_id "$id" transform_item.xsl $input_xml > "book-$id.html"
done

echo "done"

#####

files=$(ls book-*.html)

cat <<EOL > generated_pages.js

const pages = [
EOL

for file in $files
do
  echo "    '$file'," >> generated_pages.js
done

cat <<EOL >> generated_pages.js
];
EOL

