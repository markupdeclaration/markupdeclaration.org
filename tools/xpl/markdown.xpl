<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                xmlns:h="http://www.w3.org/1999/xhtml"
                exclude-inline-prefixes="c cx h"
                name="main" version="1.0">
  <p:input port="parameters" kind="parameter"/>
  <p:output port="result" primary="true"/>
  <p:serialization port="result" indent="false" omit-xml-declaration="true"
                   method="html" version="5"/>
  <p:option name="markdown" required="true"/>
  <p:option name="id"/>

  <p:import href="pubdate.xpl"/>

  <p:declare-step type="cx:commonmark">
    <p:output port="result"/>
    <p:option name="href" required="true"/>
  </p:declare-step>

  <cx:commonmark name="markdown">
    <p:with-option name="href" select="$markdown"/>
  </cx:commonmark>

  <p:insert name="pubmeta" match="/h:doc" position="first-child">
    <p:input port="source">
      <p:inline><h:doc/></p:inline>
    </p:input>
    <p:input port="insertion" select="(//h:pubmeta)[1]">
      <p:pipe step="markdown" port="result"/>
    </p:input>
  </p:insert>

  <p:delete name="content" match="//h:pubmeta">
    <p:input port="source">
      <p:pipe step="markdown" port="result"/>
    </p:input>
  </p:delete>

  <p:identity name="wrapper">
    <p:input port="source">
      <p:inline><html xmlns="http://www.w3.org/1999/xhtml">
      </html>
      </p:inline>
    </p:input>
  </p:identity>

  <p:choose name="head-include">
    <p:when test="/h:doc/h:pubmeta/h:head">
      <p:xpath-context>
        <p:pipe step="pubmeta" port="result"/>
      </p:xpath-context>
      <p:output port="result"/>
      <p:load>
        <p:with-option name="href"
                       select="concat('../../includes/head/', /h:doc/h:pubmeta/h:head, '.xml')">
          <p:pipe step="pubmeta" port="result"/>
        </p:with-option>
      </p:load>
    </p:when>
    <p:otherwise>
      <p:output port="result"/>
      <p:load href="../../includes/head/default.xml"/>
    </p:otherwise>
  </p:choose>

  <p:choose name="head">
    <p:when test="/h:doc/h:pubmeta/h:title">
      <p:xpath-context>
        <p:pipe step="pubmeta" port="result"/>
      </p:xpath-context>
      <p:output port="result"/>
      <p:insert match="/h:head" position="last-child">
        <p:input port="insertion" select="/h:doc/h:pubmeta/h:title">
          <p:pipe step="pubmeta" port="result"/>
        </p:input>
      </p:insert>
    </p:when>
    <p:when test="//h:h1">
      <p:xpath-context>
        <p:pipe step="content" port="result"/>
      </p:xpath-context>
      <p:output port="result"/>

      <p:rename name="title" 
                match="h:h1" new-name="title" new-namespace="http://www.w3.org/1999/xhtml">
        <p:input port="source">
          <p:pipe step="content" port="result"/>
        </p:input>
      </p:rename>

      <p:insert match="/h:head" position="last-child">
        <p:input port="source">
          <p:pipe step="head-include" port="result"/>
        </p:input>
        <p:input port="insertion" select="(//h:title)[1]">
          <p:pipe step="title" port="result"/>
        </p:input>
      </p:insert>
    </p:when>
    <p:otherwise>
      <p:output port="result"/>
      <p:identity/>
    </p:otherwise>
  </p:choose>

  <p:choose name="header">
    <p:when test="/h:doc/h:pubmeta/h:header">
      <p:xpath-context>
        <p:pipe step="pubmeta" port="result"/>
      </p:xpath-context>
      <p:output port="result"/>
      <p:load>
        <p:with-option name="href"
                       select="concat('../../includes/header/', /h:doc/h:pubmeta/h:header, '.xml')">
          <p:pipe step="pubmeta" port="result"/>
        </p:with-option>
      </p:load>
    </p:when>
    <p:otherwise>
      <p:output port="result"/>
      <p:load href="../../includes/header/default.xml"/>
      <p:insert match="h:header" position="first-child">
        <p:input port="insertion" select="(//h:h1)[1]">
          <p:pipe step="content" port="result"/>
        </p:input>
      </p:insert>
      <p:insert match="h:h1" position="first-child">
        <p:input port="insertion" xmlns="http://www.w3.org/1999/xhtml">
          <p:inline><a href="/"><img src="/img/logo-small.png" alt="[Logo]"/></a> </p:inline>
        </p:input>
      </p:insert>
    </p:otherwise>
  </p:choose>

  <p:choose name="footer">
    <p:when test="/h:doc/h:pubmeta/h:footer">
      <p:xpath-context>
        <p:pipe step="pubmeta" port="result"/>
      </p:xpath-context>
      <p:output port="result"/>
      <p:load>
        <p:with-option name="href"
                       select="concat('../../includes/footer/', /h:doc/h:pubmeta/h:footer, '.xml')">
          <p:pipe step="pubmeta" port="result"/>
        </p:with-option>
      </p:load>
    </p:when>
    <p:otherwise>
      <p:output port="result"/>
      <p:load href="../../includes/footer/default.xml"/>
    </p:otherwise>
  </p:choose>

  <cx:pubdate name="pubdate">
    <p:with-option name="baseuri" select="$markdown"/>
  </cx:pubdate>

  <p:insert match="h:html" position="first-child">
    <p:input port="source">
      <p:pipe step="wrapper" port="result"/>
    </p:input>
    <p:input port="insertion">
      <p:pipe step="head" port="result"/>
    </p:input>
  </p:insert>

  <p:insert match="h:html" position="last-child">
    <p:input port="insertion">
      <p:pipe step="content" port="result"/>
    </p:input>
  </p:insert>

  <p:rename match="h:body" new-name="article" new-namespace="http://www.w3.org/1999/xhtml"/>
  <p:wrap match="h:article" wrapper="main" wrapper-namespace="http://www.w3.org/1999/xhtml"/>
  <p:wrap match="h:main" wrapper="body" wrapper-namespace="http://www.w3.org/1999/xhtml"/>

  <p:choose>
    <p:when test="/h:doc/h:pubmeta/h:id">
      <p:xpath-context>
        <p:pipe step="pubmeta" port="result"/>
      </p:xpath-context>
      <p:add-attribute match="h:article" attribute-name="id">
        <p:with-option name="attribute-value" select="/h:doc/h:pubmeta/h:id">
          <p:pipe step="pubmeta" port="result"/>
        </p:with-option>
      </p:add-attribute>
    </p:when>
    <p:otherwise>
      <p:identity/>
    </p:otherwise>
  </p:choose>

  <p:delete match="(//h:h1)[1]"/>

  <p:insert match="h:main" position="first-child">
    <p:input port="insertion">
      <p:pipe step="header" port="result"/>
    </p:input>
  </p:insert>

  <p:insert match="h:main" position="last-child">
    <p:input port="insertion">
      <p:pipe step="footer" port="result"/>
    </p:input>
  </p:insert>

  <p:insert match="h:footer" position="last-child">
    <p:input port="insertion">
      <p:pipe step="pubdate" port="result"/>
    </p:input>
    <p:log port="result" href="/tmp/last.xml"/>
  </p:insert>

  <p:xslt>
    <p:input port="stylesheet">
      <p:document href="../xsl/post.xsl"/>
    </p:input>
  </p:xslt>
</p:declare-step>
