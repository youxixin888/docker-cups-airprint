FROM ubuntu:xenial

# Install the packages we need. Avahi will be included
RUN apt-get update && apt-get install -y \
    cups \
    cups-pdf \
    hplip \
    inotify-tools \
    python-cups \
    avahi-daemon dbus wget build-essential make ghostscript dc cups-filters \
&& rm -rf /var/lib/apt/lists/*

# This will use port 631
EXPOSE 631

# We want a mount for these
VOLUME /config
VOLUME /services

# Add scripts
ADD root /
RUN chmod +x /root/*
CMD ["/root/run_cups.sh"]

# Baked-in config file changes
RUN sed -i 's/Listen localhost:631/Listen 0.0.0.0:631/' /etc/cups/cupsd.conf && \
    sed -i 's/Browsing Off/Browsing On/' /etc/cups/cupsd.conf && \
    sed -i 's/<Location \/>/<Location \/>\n    Allow All/' /etc/cups/cupsd.conf && \
    sed -i 's/<Location \/admin>/<Location \/admin>\n    Allow All\n    Require user @SYSTEM/' /etc/cups/cupsd.conf && \
    sed -i 's/<Location \/admin\/conf>/<Location \/admin\/conf>\n    Allow All/' /etc/cups/cupsd.conf && \
    echo "ServerAlias *" >> /etc/cups/cupsd.conf && \
    echo "DefaultEncryption Never" >> /etc/cups/cupsd.conf
    
# foo2zjs printer driver
RUN wget -O foo2zjs.tar.gz http://foo2zjs.rkkda.com/foo2zjs.tar.gz && tar zxf foo2zjs.tar.gz && cd foo2zjs && make && make install
