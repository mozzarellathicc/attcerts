#!/bin/bash

# Get attroot2031.der
curl --ignore-content-length -X"GET a/etc/rootcert/attroot2031.der" http://192.168.1.254:80 -o attroot2031.der

# Get attsubca2021.der
curl --ignore-content-length -X"GET a/etc/rootcert/attsubca2021.der" http://192.168.1.254:80 -o attsubca2021.der

# Get attsubca2030.der
curl --ignore-content-length -X"GET a/etc/rootcert/attsubca2030.der" http://192.168.1.254:80 -o attsubca2030.der
