<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                xmlns:h="http://www.w3.org/1999/xhtml"
                exclude-inline-prefixes="c cx h"
                name="main" version="1.0">
  <p:input port="source"/>
  <p:input port="parameters" kind="parameter"/>
  <p:output port="result" primary="true"/>
  <p:serialization port="result" indent="false" omit-xml-declaration="true"
                   method="html" version="5"/>

  <p:import href="pubdate.xpl"/>

  <p:insert name="pubmeta" match="/h:doc" position="first-child">
    <p:input port="source">
      <p:inline><h:doc/></p:inline>
    </p:input>
    <p:input port="insertion" select="(//h:pubmeta)[1]">
      <p:pipe step="main" port="source"/>
    </p:input>
  </p:insert>

  <p:delete name="content" match="//h:pubmeta">
    <p:input port="source">
      <p:pipe step="main" port="source"/>
    </p:input>
  </p:delete>

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
    <p:with-option name="baseuri" select="base-uri(/)">
      <p:pipe step="main" port="source"/>
    </p:with-option>
  </cx:pubdate>

  <p:insert match="h:head" position="first-child">
    <p:input port="source">
      <p:pipe step="content" port="result"/>
    </p:input>
    <p:input port="insertion">
      <p:pipe step="head-include" port="result"/>
    </p:input>
  </p:insert>

  <p:unwrap match="h:head/h:head"/>

  <p:rename match="h:body" new-name="article" new-namespace="http://www.w3.org/1999/xhtml"/>
  <p:wrap match="h:article" wrapper="main" wrapper-namespace="http://www.w3.org/1999/xhtml"/>
  <p:wrap match="h:main" wrapper="body" wrapper-namespace="http://www.w3.org/1999/xhtml"/>

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
  </p:insert>

</p:declare-step>
