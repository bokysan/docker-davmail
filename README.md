Yet another Docker container for Davmail
========================================

Many different versions of [DavMail](http://davmail.sourceforge.net/) containers
are floating around the web.

None of them were quite exactly what I needed.

This container is different in the following ways:
- It will *fetch the latest version of DavMail on every build*
- It's built on top of [OpenJDK 12](https://openjdk.java.net/projects/jdk/12/)
- We always use the latest version of JDK 12

So, if you need a new version fo DavMail, just rebuild this package.

Running the container
---------------------

Couldn't be simpler:

    docker run -v /opt/davmail:/etc/davmail -P -it --rm boky/davmail


Make sure you put [davmail.properties](http://davmail.sourceforge.net/serversetup.html)
into your `/opt/davmail` folder.

To get the default properties, simply run:

    docker run --rm boky/davmail cat /etc/davmail/davmail.properties > /opt/davmail/davmail.properties


Enjoy!

