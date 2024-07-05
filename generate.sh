#!/bin/bash

input_xml="data0422.xml"

echo "Extracting item IDs from XML..."
item_ids=$(xmllint --xpath "//item/@no" $input_xml | sed 's/no="\([0-9]*\)"/\1/g')
echo "Item IDs extracted: $item_ids"

for id in $item_ids; do
    echo "Processing item with ID: $id"
    xsltproc --stringparam item_id "$id" transform_item.xsl $input_xml > "book-$id.html"
    echo "Generated HTML for item ID: $id"
done

echo "All items have been processed."

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

