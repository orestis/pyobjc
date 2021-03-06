<?
    $title = "Coding style for PyObjC";
    $cvs_author = '$Author: ronaldoussoren $';
    $cvs_date = '$Date: 2003/07/05 14:59:47 $';

    include "header.inc";
?>
<h1 class="title">Coding style for PyObjC</h1>
<table class="docinfo" frame="void" rules="none">
<col class="docinfo-name" />
<col class="docinfo-content" />
<tbody valign="top">
<tr><th class="docinfo-name">Author:</th>
<td>Ronald Oussoren</td></tr>
<tr><th class="docinfo-name">Author:</th>
<td>Bill Bumgarner</td></tr>
<tr><th class="docinfo-name">Contact:</th>
<td><a class="first last reference" href="mailto:pyobjc-dev&#64;lists.sourceforge.net">pyobjc-dev&#64;lists.sourceforge.net</a></td></tr>
<tr class="field"><th class="docinfo-name">URL:</th><td class="field-body"><a class="reference" href="http://pyobjc.sourceforge.net/">http://pyobjc.sourceforge.net/</a></td>
</tr>
<tr><th class="docinfo-name">Copyright:</th>
<td>2002 The PyObjC Project</td></tr>
</tbody>
</table>
<div class="contents topic" id="contents">
<p class="topic-title first"><a name="contents">Contents</a></p>
<ul class="simple">
<li><a class="reference" href="#introduction" id="id1" name="id1">Introduction</a></li>
<li><a class="reference" href="#python-code" id="id2" name="id2">Python code</a></li>
<li><a class="reference" href="#c-code" id="id3" name="id3">C code</a></li>
<li><a class="reference" href="#documentation" id="id4" name="id4">Documentation</a><ul>
<li><a class="reference" href="#rest-in-docstrings" id="id5" name="id5">ReST in DocStrings</a></li>
</ul>
</li>
</ul>
</div>
<div class="section" id="introduction">
<h3><a class="toc-backref" href="#id1" name="introduction">Introduction</a></h3>
<p>This document describes the coding style for PyObjC.  Please use this style for
new code and try apply this style to existing code while working on it.</p>
<p>The management summary: 4-space indents in Python code, 1-TAB indents in C
code.</p>
</div>
<div class="section" id="python-code">
<h3><a class="toc-backref" href="#id2" name="python-code">Python code</a></h3>
<p>The coding style for core Python is used (see <a class="reference" href="http://www.python.org/peps/pep-0008.txt">PEP 8</a>).  For consistency with
Cocoa we use mixed-case identifiers (like <tt class="docutils literal"><span class="pre">lookUpClass</span></tt>).</p>
<p>PyObjC extensions to Apple frameworks should be clearly marked as such, 
preferably by prefixing names with <tt class="docutils literal"><span class="pre">PyObjC</span></tt> or <tt class="docutils literal"><span class="pre">pyobjc</span></tt>.  This should make
it clear to users where they should look for documentation of an item: The
Apple documentation or ours.</p>
</div>
<div class="section" id="c-code">
<h3><a class="toc-backref" href="#id3" name="c-code">C code</a></h3>
<p>The coding style for core Python is used (see <a class="reference" href="http://www.python.org/peps/pep-0007.txt">PEP 7</a>).  We use <tt class="docutils literal"><span class="pre">PyObjC</span></tt> 
instead of <tt class="docutils literal"><span class="pre">Py</span></tt> as the prefix for globally visible symbols.</p>
<p>All (Objective-)C files in <tt class="docutils literal"><span class="pre">Modules/objc/</span></tt> should include <tt class="docutils literal"><span class="pre">&quot;pyobjc.h&quot;</span></tt> as
their first include.  The (Objective-)C files in the wrappers for frameworks
should include <tt class="docutils literal"><span class="pre">&quot;pyobjc-api.h&quot;</span></tt> and should not use other include-files in
<tt class="docutils literal"><span class="pre">Modules/objc</span></tt> other than <tt class="docutils literal"><span class="pre">pyobjc-api.h</span></tt> and <tt class="docutils literal"><span class="pre">wrapper-const-table.h</span></tt>.</p>
</div>
<div class="section" id="documentation">
<h3><a class="toc-backref" href="#id4" name="documentation">Documentation</a></h3>
<p>All items exported by the objc module and all PyObjC extensions to Apple
frameworks (the AppKit and Foundation modules) should be documented using
docstrings.</p>
<p>All documentation-- both standalone documents and docstrings-- should be
marked up using <a class="reference" href="http://docutils.sourceforge.net/rst.html">reStructuredText</a> [ReST].</p>
<div class="section" id="rest-in-docstrings">
<h4><a class="toc-backref" href="#id5" name="rest-in-docstrings">ReST in DocStrings</a></h4>
<p><a class="reference" href="http://docutils.sourceforge.net/rst.html">reStructuredText</a> can be used in doc strings.   ReST in DocStrings works
exactly like a standalone ReST document, but the ReST is broken up slightly
differently.</p>
<p>To format the DocStrings to be ReST compatible, make the following
changes/additions to the source.  These examples were taken from source found
in the DocUtils source tree.</p>
<ol class="arabic">
<li><p class="first">Add appropriate ReST style fields to the top of the document as comments:</p>
<pre class="literal-block">
# Author: David Goodger
# Contact: goodger&#64;users.sourceforge.net
# Copyright: This module has been placed in the public domain.
</pre>
</li>
<li><p class="first">Add a module level variable that indicates that ReST is used to format
the text contained in the docstrings:</p>
<pre class="literal-block">
__docformat__ = 'reStructuredText'
</pre>
</li>
<li><p class="first">Format all other DocStrings as one normally would in Python.   Use ReST
style markup where appropriate.   For example, bulleted lists and
sections might commonly appear in the module or class docstrings.   The
docstrings for individual methods may use example blocks, hyperlinks, or
any other ReST markup.</p>
</li>
</ol>
</div>
</div>
</div>
<?
    include "footer.inc";
?>