#!/usr/bin/bash

# Replace obsolete Zonbook tags in all XML files in the current folder

echo To tranform the obsolete Zonbook tags 
echo in the XML files in this directory
echo press enter
echo otherwise hit Ctrl-C to quit
echo -n

read line

tmpfile=$$

# Use these to replace the obsolete tags
# any empty placeholders
#   SOMETHING=
# are replaced by empty string in sed call

# acronym=
action=code
alt=textobject
# answer=
# appendix=
# arg=
# author=
# authorinitials=
# blockquote=
bridgehead=formalpara

# caption Special case:
# <caption> -> <textobject><phrase>
# </caption> -> </phrase></textobject>

citation=emphasis
citetitle=emphasis
classname=code
computeroutput=code
# contractnum=

# copyright Special case:
# <copyright> -> &copyright;
# </copyright> -> ""

# coref=
# date=
envar=code
errorname=code
figure=mediaobject
firstterm=glossterm
function=code
graphic=mediaobject
# group=
guibutton=guilabel
guiicon=guilabel
guimenu=guilabel

# highlights Special case:
# <highlights> -> <para role="topiclist/>
# </highlights> -> nil

# holder Special case:
# <holder> -> &copyright;
# </holder> -> ""

# index=
# indexterm=
informalexample=example
informalfigure=mediaobject

# informaltable Special case:
# <informaltable> -> <table><title/>
# </informaltable> -. </table

inlineequation=inlinemediaobject
inlinegraphic=inlinemediaobject
keycap=guilabel

# legalnotice Special case:
# <legalnotice> -> &copyright;
# </legalnotice> -> ""

literal=code
# or progamlisting for literallayout?
literallayout=code
member=code
methodname=code
# option=
package=code
parameter=code
# primary=
# productname=
property=code
pubdate=date
# qandaentry=
# qandaset=
# question=
# revdescription=
# revhistory=
# revision=
# revnumber=
# revremark=
# secondary=
# see=
# seealso=
seg=para
seglistitem=listitem
segmentedlist=itemizedlist
# segtitle=
simpara=para
# or variablelist for simplelist?
simplelist=itemizedlist
simplesect=section
state=code
# superscript=
task=procedure
# tertiary=
tip=note
# tocchap=
# tocentry=
# toclevel1=
# toclevel2=
# token=
type=code
# varname=
# year Special case:
# <year> -> &copyright;
# </year> -> ""


for i in `grep -irIl '<acronym\|<action\|<alt\|<answer\|<appendix\|<arg\|<author\|<authorinitials\|<blockquote\|<bridgehead\|<caption\|<citation\|<citetitle\|<classname\|<computeroutput\|<contractnum\|<copyright\|<coref\|<date\|<envar\|<errorname\|<figure\|<firstterm\|<function\|<graphic\|<group\|<guibutton\|<guiicon\|<guimenu\|<highlights\|<holder\|<index\|<indexterm\|<informalexample\|<informalfigure\|<informaltable\|<inlineequation\|<inlinegraphic\|<keycap\|<legalnotice\|<literal\|<literallayout\|<member\|<methodname\|<option\|<package\|<parameter\|<primary\|<productname\|<property\|<pubdate\|<qandaentry\|<qandaset\|<question\|<revdescription\|<revhistory\|<revision\|<revnumber\|<revremark\|<secondary\|<see\|<seealso\|<seg\|<seglistitem\|<segmentedlist\|<segtitle\|<simpara\|<simplelist\|<simplesect\|<state\|<superscript\|<task\|<tertiary\|<tip\|<tocchap\|<tocentry\|<toclevel1\|<toclevel2\|<token\|<type\|<varname\|<year' *.xml --exclude="build.xml"`
do
   cat $i | \
      sed s/\<acronym\>// | \
      sed "s/<\/acronym>//" | \
      sed s/\<action\>/\<${action}\>/ | \
      sed "s/<\/action>/<\/${action}>/" | \
      sed s/\<alt\>/\<${alt}\>/ | \
      sed "s/<\/alt>/<\/${alt}>/" | \
      sed s/\<answer\>// | \
      sed "s/<\/answer>//" | \
      sed s/\<appendix\>// | \
      sed "s/<\/appendix>//" | \
      sed s/\<arg\>// | \
      sed "s/<\/arg>//" | \
      sed s/\<author\>// | \
      sed "s/<\/author>//" | \
      sed s/\<authorinitials\>// | \
      sed "s/<\/authorinitials>//" | \
      sed s/\<blockquote\>// | \
      sed "s/<\/blockquote>//" | \
      sed s/\<bridgehead\>/\<${bridgehead}\>/ | \
      sed "s/<\/bridgehead>/<\/${bridgehead}>/" | \
      sed s/\<caption\>/\<textobject\>\<phrase\>/ | \
      sed "s/<\/caption>/<\/phrase><\/textobject>/" | \
      sed s/\<citation\>/\<${citation}\>/ | \
      sed "s/<\/citation>/<\/${citation}>/" | \
      sed s/\<citetitle\>/\<${citetitle}\>/ | \
      sed "s/<\/citetitle>/<\/${citetitle}>/" | \
      sed s/\<classname\>/\<${classname}\>/ | \
      sed "s/<\/classname>/<\/${classname}>/" | \
      sed s/\<computeroutput\>/\<${computeroutput}\>/ | \
      sed "s/<\/computeroutput>/<\/${computeroutput}>/" | \
      sed s/\<contractnum\>// | \
      sed "s/<\/contractnum>//" | \
      sed s/\<copyright\>/'\&copyright\;'/ | \
      sed "s/<\/copyright>//" | \
      sed s/\<coref\>// | \
      sed "s/<\/coref>//" | \
      sed s/\<date\>// | \
      sed "s/<\/date>//" | \
      sed s/\<envar\>/\<${envar}\>/ | \
      sed "s/<\/envar>/<\/${envar}>/" | \
      sed s/\<errorname\>/\<${errorname}\>/ | \
      sed "s/<\/errorname>/<\/${errorname}>/" | \
      sed s/\<figure\>/\<${figure}\>/ | \
      sed "s/<\/figure>/<\/${figure}>/" | \
      sed s/\<firstterm\>/\<${firstterm}\>/ | \
      sed "s/<\/firstterm>/<\/${firstterm}>/" | \
      sed s/\<function\>/\<${function}\>/ | \
      sed "s/<\/function>/<\/${function}>/" | \
      sed s/\<graphic\>/\<${graphic}\>/ | \
      sed "s/<\/graphic>/<\/${graphic}>/" | \
      sed s/\<group\>// | \
      sed "s/<\/group>//" | \
      sed s/\<guibutton\>/\<${guibutton}\>/ | \
      sed "s/<\/guibutton>/<\/${guibutton}>/" | \
      sed s/\<guiicon\>/\<${guiicon}\>/ | \
      sed "s/<\/guiicon>/<\/${guiicon}>/" | \
      sed s/\<guimenu\>/\<${guimenu}\>/ | \
      sed "s/<\/guimenu>/<\/${guimenu}>/" | \
      sed s/\<highlights\>/'\&copyright\;'/ | \
      sed "s/<\/highlights>//" | \
      sed s/\<holder\>/'\&copyright\;'/ | \
      sed "s/<\/holder>//" | \
      sed s/\<index\>// | \
      sed "s/<\/index>//" | \
      sed s/\<indexterm\>// | \
      sed "s/<\/indexterm>//" | \
      sed s/\<informalexample\>/\<${informalexample}\>/ | \
      sed "s/<\/informalexample>/<\/${informalexample}>/" | \
      sed s/\<informalfigure\>/\<${informalfigure}\>/ | \
      sed "s/<\/informalfigure>/<\/${informalfigure}>/" | \
      sed s/\<informaltable\>/'<table><title\/>'/ | \
      sed "s/<\/informaltable>/<\/table>/" | \
      sed s/\<inlineequation\>/\<${inlineequation}\>/ | \
      sed "s/<\/inlineequation>/<\/${inlineequation}>/" | \
      sed s/\<inlinegraphic\>/\<${inlinegraphic}\>/ | \
      sed "s/<\/inlinegraphic>/<\/${inlinegraphic}>/" | \
      sed s/\<keycap\>/\<${keycap}\>/ | \
      sed "s/<\/keycap>/<\/${keycap}>/" | \
      sed s/\<legalnotice\>/'\&copyright\;'/ | \
      sed "s/<\/legalnotice>//" | \
      sed s/\<literal\>/\<${literal}\>/ | \
      sed "s/<\/literal>/<\/${literal}>/" | \
      sed s/\<literallayout\>/\<${literallayout}\>/ | \
      sed "s/<\/literallayout>/<\/${literallayout}>/" | \
      sed s/\<member\>/\<${member}\>/ | \
      sed "s/<\/member>/<\/${member}>/" | \
      sed s/\<methodname\>/\<${methodname}\>/ | \
      sed "s/<\/methodname>/<\/${methodname}>/" | \
      sed s/\<option\>// | \
      sed "s/<\/option>//" | \
      sed s/\<package\>/\<${package}\>/ | \
      sed "s/<\/package>/<\/${package}>/" | \
      sed s/\<parameter\>/\<${parameter}\>/ | \
      sed "s/<\/parameter>/<\/${parameter}>/" | \
      sed s/\<primary\>// | \
      sed "s/<\/primary>//" | \
      sed s/\<productname\>// | \
      sed "s/<\/productname>//" | \
      sed s/\<property\>/\<${property}\>/ | \
      sed "s/<\/property>/<\/${property}>/" | \
      sed s/\<pubdate\>/\<${pubdate}\>/ | \
      sed "s/<\/pubdate>/<\/${pubdate}>/" | \
      sed s/\<qandaentry\>// | \
      sed "s/<\/qandaentry>//" | \
      sed s/\<qandaset\>// | \
      sed "s/<\/qandaset>//" | \
      sed s/\<question\>// | \
      sed "s/<\/question>//" | \
      sed s/\<revdescription\>// | \
      sed "s/<\/revdescription>//" | \
      sed s/\<revhistory\>// | \
      sed "s/<\/revhistory>//" | \
      sed s/\<revision\>// | \
      sed "s/<\/revision>//" | \
      sed s/\<revnumber\>// | \
      sed "s/<\/revnumber>//" | \
      sed s/\<revremark\>// | \
      sed "s/<\/revremark>//" | \
      sed s/\<secondary\>// | \
      sed "s/<\/secondary>//" | \
      sed s/\<see\>// | \
      sed "s/<\/see>//" | \
      sed s/\<seealso\>// | \
      sed "s/<\/seealso>//" | \
      sed s/\<seg\>/\<${seg}\>/ | \
      sed "s/<\/seg>/<\/${seg}>/" | \
      sed s/\<seglistitem\>/\<${seglistitem}\>/ | \
      sed "s/<\/seglistitem>/<\/${seglistitem}>/" | \
      sed s/\<segmentedlist\>/\<${segmentedlist}\>/ | \
      sed "s/<\/segmentedlist>/<\/${segmentedlist}>/" | \
      sed s/\<segtitle\>// | \
      sed "s/<\/segtitle>//" | \
      sed s/\<simpara\>/\<${simpara}\>/ | \
      sed "s/<\/simpara>/<\/${simpara}>/" | \
      sed s/\<simplelist\>/\<${simplelist}\>/ | \
      sed "s/<\/simplelist>/<\/${simplelist}>/" | \
      sed s/\<simplesect\>/\<${simplesect}\>/ | \
      sed "s/<\/simplesect>/<\/${simplesect}>/" | \
      sed s/\<state\>/\<${state}\>/ | \
      sed "s/<\/state>/<\/${state}>/" | \
      sed s/\<superscript\>// | \
      sed "s/<\/superscript>//" | \
      sed s/\<task\>/\<${task}\>/ | \
      sed "s/<\/task>/<\/${task}>/" | \
      sed s/\<tertiary\>// | \
      sed "s/<\/tertiary>//" | \
      sed s/\<tip\>/\<${tip}\>/ | \
      sed "s/<\/tip>/<\/${tip}>/" | \
      sed s/\<tocchap\>// | \
      sed "s/<\/tocchap>//" | \
      sed s/\<tocentry\>// | \
      sed "s/<\/tocentry>//" | \
      sed s/\<toclevel1\>// | \
      sed "s/<\/toclevel1>//" | \
      sed s/\<toclevel2\>// | \
      sed "s/<\/toclevel2>//" | \
      sed s/\<token\>// | \
      sed "s/<\/token>//" | \
      sed s/\<type\>/\<${type}\>/ | \
      sed "s/<\/type>/<\/${type}>/" | \
      sed s/\<varname\>// | \
      sed "s/<\/varname>//" | \
      sed s/\<year\>/'\&copyright\;'/ | \
      sed "s/<\/year>//" > $tmpfile

   # Replace original file
   mv $tmpfile $i
done
