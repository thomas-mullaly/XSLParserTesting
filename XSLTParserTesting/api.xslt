<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ/\()&lt;&gt;.|,'" />
    <xsl:variable name="idCharactersToReplace"  >'" :=</xsl:variable>
    <xsl:variable name="idReplacementCharacters">-----</xsl:variable>

    <xsl:output method="html" indent="yes" />

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template name="header" match="h2[1]">
        <xsl:variable name="contentItemCountSpan" select="' (&lt;span class=&quot;contentItemCount&quot;>...&lt;/span>)'" />
        <xsl:if test="following::h2[text() = 'Description' or text() = 'Configuration' or text() = 'Methods' or text() = 'Fields' or text() = 'Properties' or text() = 'Events' or text() = 'Members'] or self::node()[text() = 'Description' or text() = 'Configuration' or text() = 'Methods' or text() = 'Fields' or text() = 'Properties' or text() = 'Events' or text() = 'Members']">
            <h2 class="toc">Contents</h2>
                <ul class="nav">
                <xsl:choose>
                    <xsl:when test="self::node()[text() = 'Description']">
                        <xsl:if test="following::h2[text() = 'Configuration']">
                            <li>
                                <a href="#configuration">Configuration</a>
                                <xsl:value-of select="$contentItemCountSpan" />
                            </li>
                        </xsl:if>
                        <xsl:if test="following::h2[text() = 'Methods']">
                            <li>
                                <a href="#methods">Methods</a>
                                <xsl:value-of select="$contentItemCountSpan" />
                            </li>
                        </xsl:if>
                        <xsl:if test="following::h2[text() = 'Fields']">
                            <li>
                                <a href="#fields">Fields</a>
                                <xsl:value-of select="$contentItemCountSpan" />
                            </li>
                        </xsl:if>
                        <xsl:if test="following::h2[text() = 'Members']">
                            <li>
                                <a href="#members">Members</a>
                                <xsl:value-of select="$contentItemCountSpan" />
                            </li>
                        </xsl:if>
                        <xsl:if test="following::h2[text() = 'Properties']">
                            <li>
                                <a href="#properties">Properties</a>
                                <xsl:value-of select="$contentItemCountSpan" />
                            </li>
                        </xsl:if>
                        <xsl:if test="following::h2[text() = 'Events']">
                            <li>
                                <a href="#events">Events</a>
                                <xsl:value-of select="$contentItemCountSpan" />
                            </li>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="following::h2[text() = 'Configuration'] or self::node()[text() = 'Configuration']">
                            <li>
                                <a href="#configuration">Configuration</a>
                                <xsl:value-of select="$contentItemCountSpan" />
                            </li>
                        </xsl:if>
                        <xsl:if test="following::h2[text() = 'Methods']  or self::node()[text() = 'Methods']">
                            <li>
                                <a href="#methods">Methods</a>
                                <xsl:value-of select="$contentItemCountSpan" />
                            </li>
                        </xsl:if>
                        <xsl:if test="following::h2[text() = 'Fields']  or self::node()[text() = 'Fields']">
                            <li>
                                <a href="#fields">Fields</a>
                                <xsl:value-of select="$contentItemCountSpan" />
                            </li>
                        </xsl:if>
                        <xsl:if test="following::h2[text() = 'Members']  or self::node()[text() = 'Members']">
                            <li>
                                <a href="#members">Members</a>
                                <xsl:value-of select="$contentItemCountSpan" />
                            </li>
                        </xsl:if>
                        <xsl:if test="following::h2[text() = 'Properties']  or self::node()[text() = 'Properties']">
                            <li>
                                <a href="#properties">Properties</a>
                                <xsl:value-of select="$contentItemCountSpan" />
                            </li>
                        </xsl:if>
                        <xsl:if test="following::h2[text() = 'Events']  or self::node()[text() = 'Events']">
                            <li>
                                <a href="#events">Events</a>
                                <xsl:value-of select="$contentItemCountSpan" />
                            </li>
                        </xsl:if>
                </xsl:otherwise>
                </xsl:choose>
                </ul>
            <div class="allContentFilteredMessage">No results. Try clearing the filter.</div>
        </xsl:if>

        <h2 class="toc">
            <xsl:attribute name="id">
                <xsl:value-of select="translate(., $uppercase, $smallcase)"></xsl:value-of>
            </xsl:attribute>
            <xsl:value-of select="." />
        </h2>
    </xsl:template>

    <xsl:template name="header2" match="h2[preceding::h2]">
        <h2>
            <xsl:variable name="url" select="translate(translate(., ' ', '-'), $uppercase, $smallcase)"></xsl:variable>
            <xsl:attribute name="id">
                <xsl:value-of select="$url"/>
            </xsl:attribute>
            <a>
                <xsl:attribute name="href">{{replace}}#<xsl:value-of select="$url"/></xsl:attribute>
                <xsl:value-of select="."/>
            </a>
        </h2>
    </xsl:template>

    <xsl:template name="h3" match="h3">
        <h3>
            <xsl:choose>
                <xsl:when test="contains(., ':')">
                    <xsl:variable name="url" select="translate(normalize-space(substring-before(., ':')), $idCharactersToReplace, $idReplacementCharacters)"></xsl:variable>
                    <xsl:attribute name="id">
                        <xsl:value-of select="translate($url, $uppercase, $smallcase)"></xsl:value-of>
                    </xsl:attribute>
                    <a>
                        <xsl:attribute name="href">{{replace}}#<xsl:value-of select="translate($url, $uppercase, $smallcase)"/></xsl:attribute>
                        <xsl:copy-of select="self::node()/node()"></xsl:copy-of>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="url" select="translate(normalize-space(.), $idCharactersToReplace, $idReplacementCharacters)"></xsl:variable>
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
            <a href="#top">
                <img src="images/upArrow.png" /> Back to Top
            </a>
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

    <xsl:template name="events" match="h4[(following-sibling::*[1][self::h5])]">
        <div class="details-list">
            <h4 class="details-title">
                <xsl:value-of select="node()"/>
            </h4>
            <xsl:for-each select="following-sibling::h5">
                <dl>
                    <xsl:variable name="head5" select="."/>
                    <dt>
                        <xsl:copy-of select="child::node()"></xsl:copy-of>
                    </dt>
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

    <xsl:template name="quote" match="blockquote">
        <div class="tip">
            <xsl:copy-of select="self::node()"/>
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
