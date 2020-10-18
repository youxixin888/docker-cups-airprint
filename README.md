# About

Modified copy of source code at: https://github.com/quadportnick/docker-cups-airprint

# Intro

Add avahi,dbus support and foo2zjs printer driver.

# Getting Started

Using docker Built and Run it!

## Build

```
git clone https://...
cd docker-cups-airprint
docker build . -t cups-avahi

```

## Run

```
docker run \
--name=cups-avahi \
--restart=always \
--net=host \
-v /var/run/dbus:/var/run/dbus \
-v ~/airprint_data/config:/config \
-v ~/airprint_data/services:/services \
--device /dev/bus \
--device /dev/usb \
-e CUPSADMIN="admin" \
-e CUPSPASSWORD="password" \
-e NOAVAHI=0 \
--privileged=true \
cups-avahi
```

## Parameters 
* `--name`: gives the container a name making it easier to work with/on (e.g. cups)
* `--restart`: restart policy for how to handle restarts (e.g. always restart)
* `--net`: network to join (e.g. the host network)
* `-v ~/airprint_data/config:/config`: where the persistent printer configs will be stored
* `-v ~/airprint_data/services:/services`: where the Avahi service files will be generated
* `-e CUPSADMIN`: the CUPS admin user you want created
* `-e CUPSPASSWORD`: the password for the CUPS admin user
* `-e NOAVAHI`: set to 1 if you using localsystem avahi and dbus
* `--device /dev/bus`: device mounted for interacting with USB printers
* `--device /dev/usb`: device mounted for interacting with USB printers

### Volumes:
* `/config`: where the persistent printer configs will be stored
* `/services`: where the Avahi service files will be generated

### Variables:
* `CUPSADMIN`: the CUPS admin user you want created
* `CUPSPASSWORD`: the password for the CUPS admin user
* `NOAVAHI`: set to 1 if you using localsystem avahi and dbus

### Ports:
* `631`: the TCP port for CUPS must be exposed

## Using
CUPS will be configurable at http://[diskstation]:631 using the CUPSADMIN/CUPSPASSWORD when you do something administrative.

If `NOAVAHI=1` and the `/services` volume isn't mapping to `/etc/avahi/services` then you will have to manually copy the .service files to that path at the command line.

## Notes
* CUPS doesn't write out `printers.conf` immediately when making changes even though they're live in CUPS. Therefore it will take a few moments before the services files update
* Don't stop the container immediately if you intend to have a persistent configuration for this same reason
 
