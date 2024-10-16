FROM ubuntu:latest

ENV NONINTERACTIVE_FRONTEND=noninteractive
ENV JDK_VERSION=11
ENV JDK_HOME=/usr/lib/jvm/java-$JDK_VERSION-openjdk-amd64

RUN apt-get update -qq && \
    apt-get install -y -qq ant curl openjdk-11-jdk && \
    mkdir -p /project/dependencies && \
    curl -L --output /project/dependencies/ivy-2.5.2.jar https://repo1.maven.org/maven2/org/apache/ivy/ivy/2.5.2/ivy-2.5.2.jar

WORKDIR /project

COPY . .

RUN ant -lib dependencies compile

RUN ant -lib dependencies test