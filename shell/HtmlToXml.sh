#!/usr/bin/bash

# Convert tags in XML files in current folder to XML/Zonbook tags
# It takes one arg, the programming language
# If we don't have an arg, bail with error message
if [ "$1" == "" ]
then
    echo "You must specify the programming language"
    exit
fi

#echo To convert the tags in the XML
#echo files in this directory
#echo to XML/Zonbook
#echo press enter
#echo otherwise hit Ctrl-C to quit
#echo -n

#read line

# <strong>               -> <emphasis role="bold">
# </strong>              -> </emphasis>
# <em>                   -> <emphasis>
# </em>                  -> </emphasis>
# <p>                    -> <para>
# </p>                   -> </para>
# <ol>                   -> <orderedlist>
# <ol type="1">          -> <orderedlist>
# </ol>                  -> </orderedlist>
# <ul>                   -> <itemizedlist
# </ul>                  -> </itemizedlist
# <li>                   -> <listitem>
# </li>                  -> </listitem>
# <pre><code> -> <programlisting language="typescript">
# </code></pre>          -> </programlisting>
# <a href                -> <ulink url
# </a>                   -> </ulink>
# <span>                 -> <code>
# </span>                -> </code>
# <pre>                 -> <code>
# </pre>                -> </code>

for i in `echo *.xml`
do
    # If the filename is examples.xml, skip it
    if [ "$i" != "examples.xml" ]
    then
        tmpfile=$$.tmp
    
        cat $i | \
            sed "s/<strong>/<emphasis role=\"bold\">/g" | \
            sed "s/<\/strong>/\<\/emphasis\>/g" | \
            sed s/\<em\>/\<emphasis\>/g | \
            sed "s/<\/em>/\<\/emphasis\>/g" | \
            sed s/\<p\>/\<para\>/g | \
            sed "s/<\/p>/\<\/para\>/g" | \
            sed s/\<span\>/\<code\>/g | \
            sed "s/<\/span>/\<\/code\>/g" | \
            sed s/\<pre\>/\<para\>\<code\>/g | \
            sed "s/<\/pre>/\<\/code\>\<\/pre\>/g" | \
            sed "s/\<ol\>/\<orderedlist\>/g" | \
            sed "s/\<\/ol\>/\<\/orderedlist\>/g" | \
            sed "s/\<ul\>/\<itemizedlist\>/g" | \
            sed "s/<\/ul>/\<\/itemizedlist\>/g" | \
            sed s/\<li\>/\<listitem\>/g | \
            sed "s/<\/li>/\<\/listitem\>/g" | \
            sed "s/<pre><code>/\<programlisting language=\"$1\"\>/g" | \
            sed "s/<\/code><\/pre>/\<\/programlisting\>/g" | \
            sed "s/<a href/\<ulink url/g" | \
            sed "s/<\/a>/\<\/ulink\>/g" > $tmpfile

#            echo "Copying $tmpfile to $i"

            mv $tmpfile $i
    fi
done
