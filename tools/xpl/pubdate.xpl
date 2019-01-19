<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:git='http://nwalsh.com/ns/git-repo-info'
                exclude-inline-prefixes="c cx h"
                type="cx:pubdate" name="main" version="1.0">
  <p:output port="result"/>
  <p:option name="baseuri"/>

  <!-- Deal with the file:/, file://, file:/// variability in base URIs... -->
  <p:variable xmlns:exf="http://exproc.org/standard/functions"
              name="pathpart" select="replace(exf:cwd(), '^file:/+', '')"/>

  <p:variable name="filename" xmlns:exf="http://exproc.org/standard/functions"
              select="substring-after($baseuri, $pathpart)"/>

  <p:xslt>
    <p:input port="parameters"><p:empty/></p:input>
    <p:input port="source">
      <p:document href="../../build/git-log-summary.xml"/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="../xsl/pubdate.xsl"/>
    </p:input>
    <p:with-param name="filename" select="$filename"/>
  </p:xslt>

</p:declare-step>
