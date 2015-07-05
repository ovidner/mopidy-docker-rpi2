FROM armbuild/ubuntu-debootstrap:vivid
MAINTAINER Olle Vidner <olle@vidner.se>
ENV PROJECT_NAME mopidy

RUN sed -i 's/mirror.cloud.online.net/ports.ubuntu.com/' /etc/apt/sources.list

RUN apt-get update -y && apt-get install -y \
    build-essential \
    python-dev \
    python-pip \
    python-gst0.10 \
    gstreamer0.10-plugins-good \
    gstreamer0.10-plugins-ugly \
    gstreamer0.10-tools

RUN apt-get install -y \
    pulseaudio

ENV PULSE_SERVER 172.17.42.1

RUN pip install -U mopidy

RUN adduser --disabled-password --gecos "" $PROJECT_NAME

EXPOSE 6600 6680
CMD ["mopidy"]
