<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns:git='http://nwalsh.com/ns/git-repo-info'
                exclude-result-prefixes="xs html git"
                version="2.0">

<xsl:param name="filename" required="true"/>

<xsl:template match="/">
  <xsl:choose>
    <xsl:when test="/*/git:commit[git:file[. = $filename]]">
      <xsl:apply-templates select="(/*/git:commit[git:file[. = $filename]])[1]/git:date"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>Did not find git log for <xsl:value-of select="$filename"/></xsl:message>
      <div class="iblock">
        <xsl:text>Published </xsl:text>
        <xsl:value-of select="format-date(current-date(), '[D01] [MNn,*-3] [Y0001]')"/>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="git:date">
  <div class="iblock">
    <xsl:text>Published </xsl:text>
    <xsl:value-of select="format-dateTime(xs:dateTime(.), '[D01] [MNn,*-3] [Y0001]')"/>
  </div>
</xsl:template>

<xsl:template match="element()">
  <xsl:copy>
    <xsl:apply-templates select="@*,node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="attribute()|text()|comment()|processing-instruction()">
  <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
