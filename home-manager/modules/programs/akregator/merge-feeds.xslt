<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>

  <xsl:param name="sourceFile" as="xs:string"/>

  <xsl:template match="/opml">
    <opml>
      <xsl:copy-of select="@* | head"/>

      <body>
        <!-- Concatenate outlines from both files and merge by @htmlUrl -->
        <xsl:for-each-group
          select="body/outline | document($sourceFile)/opml/body/outline"
          group-by="@htmlUrl">

          <outline>
            <xsl:variable name="group" select="current-group()"/>

            <!-- Dynamically merge all attributes from the group -->
            <xsl:for-each select="distinct-values($group/@*/name())">
              <xsl:variable name="attr" select="."/>
              <xsl:attribute name="{$attr}">
                <!-- Scan from last to first, return first non-empty -->
                <xsl:variable name="non-empty-group" select="$group[@*[name() = $attr] != '']"/>
                <xsl:value-of select="$non-empty-group[last()]/@*[name() = $attr]"/>
              </xsl:attribute>
            </xsl:for-each>
          </outline>
        </xsl:for-each-group>
      </body>
    </opml>
  </xsl:template>

</xsl:stylesheet>
