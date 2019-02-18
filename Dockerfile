FROM rocker/shiny-verse
MAINTAINER Piotr Oleskiewicz <piotr [at] oleskiewi [dot] cz>

COPY ./PACKAGES /opt/PACKAGES
RUN cat /opt/PACKAGES | xargs install2.r -s

COPY ./app/ /srv/shiny-server/app
