<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:dbp="http://docbook.github.com/ns/pipeline"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                xmlns:h="http://www.w3.org/1999/xhtml"
                exclude-inline-prefixes="dbp cx h"
                name="main" version="1.0">

<!-- This is currently tailored towards the output from formatting a single db:article -->

  <p:input port="source"/>
  <p:input port="parameters" kind="parameter"/>
  <p:output port="result"/>
  <p:serialization port="result" indent="false" omit-xml-declaration="true"
                   method="html" version="5"/>

  <p:option name="style" required="true"/>

  <p:import href="https://cdn.docbook.org/release/latest/xslt/base/pipelines/docbook.xpl"/>
  <p:import href="pubdate.xpl"/>

  <p:insert name="pubmeta" match="/h:doc" position="first-child">
    <p:input port="source">
      <p:inline><h:doc/></p:inline>
    </p:input>
    <p:input port="insertion" select="(/*/db:info/db:pubmeta)[1]">
      <p:pipe step="main" port="source"/>
    </p:input>
  </p:insert>

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

  <p:delete name="content" match="/*/db:info/db:pubmeta">
    <p:input port="source">
      <p:pipe step="main" port="source"/>
    </p:input>
  </p:delete>

  <dbp:docbook name="format-docbook" format="html" return-secondary="true">
    <p:input port="source">
      <p:pipe step="content" port="result"/>
    </p:input>
    <p:with-option name="style" select="resolve-uri($style)"/>
  </dbp:docbook>

  <p:identity name="title">
    <p:input port="source" select="/h:html/h:head/h:title"/>
  </p:identity>

  <p:delete match="h:head">
    <p:input port="source">
      <p:pipe step="format-docbook" port="result"/>
    </p:input>
  </p:delete>

  <p:delete match="h:script"/>

  <p:insert match="h:html" position="first-child">
    <p:input port="insertion">
      <p:pipe step="head-include" port="result"/>
    </p:input>
  </p:insert>

  <p:insert match="h:head" position="last-child">
    <p:input port="insertion">
      <p:pipe step="title" port="result"/>
    </p:input>
  </p:insert>

  <p:rename match="h:article" new-name="main"
            new-namespace="http://www.w3.org/1999/xhtml"/>

  <p:rename match="h:div[@class='content']" new-name="article"
            new-namespace="http://www.w3.org/1999/xhtml"/>

  <p:rename match="h:header[@class='article-titlepage']/h:h2" new-name="h1"
            new-namespace="http://www.w3.org/1999/xhtml"/>

  <!-- I am not convinced that the next three steps are the most efficient solution -->

  <p:insert name="logo-link"
            match="h:header[@class='article-titlepage']/h:h1" position="first-child">
    <p:input port="insertion" xmlns="http://www.w3.org/1999/xhtml">
      <p:inline><a href="/"><img src="/img/logo-small.png" alt="[Logo]"/></a> </p:inline>
    </p:input>
  </p:insert>

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
          <p:pipe step="logo-link" port="result"/>
        </p:input>
      </p:insert>
    </p:otherwise>
  </p:choose>

  <p:viewport match="h:header[@class='article-titlepage']">
    <p:viewport-source>
      <p:pipe step="logo-link" port="result"/>
    </p:viewport-source>
    <p:identity>
      <p:input port="source">
        <p:pipe step="header" port="result"/>
      </p:input>
    </p:identity>
  </p:viewport>

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
