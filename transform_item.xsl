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
