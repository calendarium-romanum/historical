<?xml version="1.0" encoding="UTF-8"?>

<!-- Produces data file representing initial state of the calendar
(no changes applied, no celebrations introduced later) -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" omit-xml-declaration="yes" indent="no"/>

  <!-- WARNING: indentation of the closing tag of this xsl:text element matters -->
  <xsl:variable name="newline"><xsl:text>
</xsl:text></xsl:variable>

  <xsl:template match="/calendar">
    <xsl:apply-templates select="meta"/>
    <xsl:apply-templates select="body/celebration[not(./@introduced)]"/>
  </xsl:template>

  <xsl:template match="meta">
    <xsl:text>---</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:apply-templates select="title|locale"/>
    <xsl:text>---</xsl:text>
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <xsl:template match="title|locale">
    <xsl:value-of select="name(.)"/>: <xsl:value-of select="."/>
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <xsl:template match="celebration">
    <xsl:value-of select="date/@month"/>
    <xsl:text>/</xsl:text>
    <xsl:value-of select="date/@day"/>

    <xsl:apply-templates select="rank"/>
    <xsl:apply-templates select="colour"/>

    <xsl:text> </xsl:text>
    <xsl:value-of select="@symbol"/>

    <xsl:text> : </xsl:text>
    <xsl:value-of select="title"/>
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <xsl:template match="rank">
    <xsl:text> </xsl:text>
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="colour">
    <xsl:text> </xsl:text>
    <xsl:value-of select="translate(substring(., 1, 1), 'rw', 'RW')"/>
  </xsl:template>
</xsl:stylesheet>
