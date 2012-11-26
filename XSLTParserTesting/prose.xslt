<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ/\()&lt;&gt;.|,'" />

  <xsl:output method="html" indent="yes" />

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="header" match="h2[1]">
    <h2 class="toc">
        <xsl:value-of select="self::node()" />
    </h2>
  </xsl:template>

    <xsl:template name="header2" match="h2[preceding::h2]">

      <h2>
        <xsl:choose>
          <xsl:when test="contains(., ':')">
            <xsl:variable name="url" select="substring-before(., ':')"></xsl:variable>
            <xsl:attribute name="id">
              <xsl:value-of select="translate($url, $uppercase, $smallcase)"></xsl:value-of>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="url" select="translate(., ' ', '-')"></xsl:variable>
            <xsl:attribute name="id">
              <xsl:value-of select="translate($url, $uppercase, $smallcase)"></xsl:value-of>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
        <a>
            <xsl:attribute name="href">
                <xsl:choose>
                  <xsl:when test="contains(., ':')">
                    <xsl:variable name="url" select="substring-before(., ':')"></xsl:variable>{{replace}}#<xsl:value-of select="translate($url, $uppercase, $smallcase)"></xsl:value-of>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:variable name="url" select="translate(., ' ', '-')"></xsl:variable>{{replace}}#<xsl:value-of select="translate($url, $uppercase, $smallcase)"></xsl:value-of>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </a>
        </h2>
    </xsl:template>

  <xsl:template name="h3" match="h3">
    <h3>
      <xsl:choose>
        <xsl:when test="contains(., ':')">
          <xsl:variable name="url" select="normalize-space(substring-before(., ':'))"></xsl:variable>
          <xsl:attribute name="id">
            <xsl:value-of select="translate($url, $uppercase, $smallcase)"></xsl:value-of>
          </xsl:attribute>
          <a>
            <xsl:attribute name="href">{{replace}}#<xsl:value-of select="translate($url, $uppercase, $smallcase)"/></xsl:attribute>
            <xsl:copy-of select="self::node()/node()"></xsl:copy-of>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="url" select="translate(normalize-space(.), ' ', '-')"></xsl:variable>
          <xsl:attribute name="id">
            <xsl:value-of select="translate($url, $uppercase, $smallcase)"></xsl:value-of>
          </xsl:attribute>
          <a>
            <xsl:attribute name="href">{{replace}}#<xsl:value-of select="translate($url, $uppercase, $smallcase)"/></xsl:attribute>
            <xsl:copy-of select="self::node()/node()"></xsl:copy-of>
          </a>
        </xsl:otherwise>
      </xsl:choose>
    </h3>
  </xsl:template>

  <xsl:template name="divider" match="hr">
    <div class="section-divider">
      <hr />
      <a href="#top"><img src="images/upArrow.png" /> Back to Top</a>
    </div>
  </xsl:template>

  <xsl:template name="code" match="pre">
    <div class="code-sample">
      <pre>
      <xsl:attribute name="class">prettyprint javascript</xsl:attribute>
      <xsl:copy-of select="node()"></xsl:copy-of>
    </pre>
      <!--<a class="copyCode button" href="#">Copy as plain text</a>-->
    </div>
  </xsl:template>

    <xsl:template name="quote" match="blockquote">
        <div class="tip">
            <xsl:copy-of select="self::node()"/>
        </div>
    </xsl:template>

  <xsl:template name="events" match="h4[(following-sibling::*[1][self::h5])]">
    <div class="details-list">
      <h4 class="details-title">
        <xsl:value-of select="node()"/>
      </h4>
      <xsl:for-each select="following-sibling::h5">
        <dl>
          <xsl:variable name="head5" select="."/>
          <dt><xsl:copy-of select="child::node()"></xsl:copy-of></dt>
          <dd>
            <xsl:for-each select="following-sibling::*[preceding-sibling::h5[1] = $head5]">
              <xsl:choose>
                <xsl:when test="self::p">
                  <xsl:copy-of select="self::p"/>
                </xsl:when>
                <xsl:when test="self::pre">
                  <div class="code-sample">
                    <pre>
                  <xsl:attribute name="class">prettyprint javascript</xsl:attribute>
                  <xsl:copy-of select="self::pre/node()"></xsl:copy-of>
                </pre>
                  </div>
                </xsl:when>
              </xsl:choose>
            </xsl:for-each>
          </dd>
        </dl>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template name="datalist" match="h5">
    <!-- H5 Elements are part of the Events structure and aren't processed on their own -->
  </xsl:template>

  <xsl:template name="data-def" match="p[preceding-sibling::*[1][self::h5] or preceding-sibling::*[1][self::p and preceding-sibling::*[1][self::h5]] or preceding-sibling::*[1][self::pre and preceding-sibling::*[1][self::h5]]]">
    <!-- These elements are part of the datalist and should be ignored -->
  </xsl:template>

  <xsl:template name="pre-def" match="pre[preceding-sibling::*[1][self::h5] or preceding-sibling::*[1][preceding-sibling::*[1][self::h5]] or preceding-sibling::*[1][self::pre and preceding-sibling::*[1][self::h5]]]">
    <!-- These elements are part of the datalist and should be ignored -->
  </xsl:template>


</xsl:stylesheet>