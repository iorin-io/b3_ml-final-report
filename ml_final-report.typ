#import "@preview/codelst:2.0.0": sourcecode
#import "@preview/codelst:2.0.0": sourcefile

#set text(font: "Hiragino Mincho ProN")

#let mixed(body) = {
  set text(weight: "extrabold")
  show regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]"): set text(font: "Hiragino Kaku Gothic ProN", weight: "bold")
  body
} // 和欧混植のフォント別々指定

#set par(first-line-indent: 1em)
#show heading: mixed // 見出しへ応用
#show heading: it => {
	it
	par(text(size: 0pt, ""))
}

#set list(indent: 0.5em)
#set enum(numbering: "(1)")
//#set math.equation(numbering: "(1)")

#let title(body) = {
  set align(center)
  set text(size: 2em)

  v(1em)
  mixed(body)
}

#let cap = "∩"
#let cup = "∪"
#let varnothing = "∅"

#set heading(numbering: "1.")
#set math.equation(numbering: "(1)")

//============================================================

#title[マークアップ言語　期末レポート]

#v(1em)
#align(center)[#text(size: 1.25em)[202210016 髙𣘺伊織]]
#v(1em)


= 作成したXSLTスタイルシートとその解説
\

これはボタンを押すたびランダムな書籍ページを表示する「書籍ガチャ」である。以下に作成したコードを示す。

`transform_item.xsl`

#sourcecode[```xml
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" encoding="UTF-8" doctype-public="XHTML 1.0 Transitional" />

    <xsl:param name="item_id" />

    <xsl:template match="/">
        <xsl:apply-templates select="/books/item[@no = $item_id]" />
    </xsl:template>

    <xsl:template match="item">
        <html>
            <head>
                <title><xsl:value-of select="title" /></title>
            </head>
            <body>
                <h1><xsl:value-of select="title" /></h1>
                <p><b>Creator:</b> <xsl:value-of select="creator" /></p>
                <p><b>Publisher:</b> <xsl:value-of select="publisher" /></p>
                <p><b>Description:</b> <xsl:value-of select="description" /></p>
                <p><b>Price:</b> <xsl:value-of select="price" /></p>
                <p><b>Date:</b>
                    <xsl:value-of select="date/year" />-<xsl:value-of select="date/month" />-<xsl:value-of select="date/day" />
                </p>
                <p><b>ISBN:</b> <xsl:value-of select="isbn" /></p>
                <p><a href="{url/@resource}">購入する</a></p>
                <p><a href="index.html">ガチャに戻る</a></p>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>

```]


`index.html`

#sourcefile(read("index.html"), file:"index.html")


`generate.sh`

#sourcefile(read("generate.sh"), file:"generate.sh")

`transform_item.xsl`は、`item_id`を受け取り、そのIDに対応する書籍情報を表示するXSLTスタイルシートである。

このxslを用いて書籍ごとのhtmlファイルを生成するため、`generate.sh`を作成した。\
以下のように`data0422.xml`の中から`item`要素の`no`属性の値を取得し、値を整形し、`item_ids`リストに格納する。\

#sourcecode[```sh
item_ids=$(xmllint --xpath "//item/@no" $input_xml | sed 's/no="\([0-9]*\)"/\1/g')
```]

取得した`item_ids`を用いて、それぞれの`item_id`ごとに`transform_item.xsl`を適用し、`book-$id.html`という名前のファイルを生成する。\

#sourcecode[```sh
for id in $item_ids
do
  echo "item_id: $id"
  xsltproc --stringparam item_id "$id" transform_item.xsl $input_xml > "book-$id.html"
done
```]

これによって生成されたhtmlファイルの例を以下に示す。

`book-345216013.html`
#sourcefile(read("book-345216013.html"), file:"book-345216013.html")

`book-$id.html`をランダムに表示するための`index.html`を作成した。\
また、ランダムに選ぶ選択肢を動的に生成するために、`generate.sh`で生成した`book-$id.html`全てを格納するリストを作成する。そのための処理が`generate.sh`にある以下の部分である。

#sourcecode[```sh
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
```]

これによって生成された`generated_pages.js`は以下のようになる。

`generated_pages.js`
#sourcecode[```js
const pages = [
    'book-345216013.html',
    'book-345216014.html',
    'book-345216015.html',
    'book-345216016.html',
						︙
		'book-731975551.html',
		'book-731975552.html',
];

```]

このリストは、`index.html`で以下のように使用される。

#sourcecode[```html
	<script src="generated_pages.js"></script>
	<script>
		function goToRandomPage() {
			const randomIndex = Math.floor(Math.random() * pages.length);
			window.location.href = pages[randomIndex];
		}
	</script>
```]

= CGIを使った場合はプログラムと解説
\

今回CGIは使用していない

= ウェブブラウザで表示した実行画面とその解説
\

以下のリンクからアクセスできる。

https://www.u.tsukuba.ac.jp/~s2210016/ml/b3_ml-final-report/index.html

アクセスすると次の画像のような画面が表示される。
#image("gacha1.png")

「ガチャを引く」ボタンを押すと、ランダムに書籍情報が表示される。\
以下の画像は、ボタンを押した後の画面である。
#image("gacha2.png")

= 授業の感想
\

授業を通して、xslを使用してxmlやhtmlを変換する方法を学ぶことができた。思っていたよりも複雑な処理を行うことができることがわかり、興味深かった。