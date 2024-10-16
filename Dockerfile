FROM ubuntu:latest

# Variables d'environnement
ENV NONINTERACTIVE_FRONTEND=noninteractive
ENV JDK_VERSION=11
ENV JDK_HOME=/usr/lib/jvm/java-$JDK_VERSION-openjdk-amd64

# Mise à jour des paquets et installation des dépendances
RUN apt-get update -qq && \
    apt-get install -y -qq ant curl openjdk-11-jdk ssmtp mailutils && \
    mkdir -p /project/dependencies && \
    curl -L --output /project/dependencies/ivy-2.5.2.jar https://repo1.maven.org/maven2/org/apache/ivy/ivy/2.5.2/ivy-2.5.2.jar

# Configuration de ssmtp
RUN echo "root=postmaster" > /etc/ssmtp/ssmtp.conf && \
    echo "mailhub=smtp.gmail.com:587" >> /etc/ssmtp/ssmtp.conf && \
    echo "AuthUser=houda.ezzarzouri@gmail.com" >> /etc/ssmtp/ssmtp.conf && \
    echo "AuthPass=houda" >> /etc/ssmtp/ssmtp.conf && \
    echo "UseSTARTTLS=YES" >> /etc/ssmtp/ssmtp.conf && \
    echo "UseTLS=YES" >> /etc/ssmtp/ssmtp.conf

# Création du répertoire de travail
WORKDIR /project

# Copier tous les fichiers dans l'image
COPY . .

# Exécuter la compilation et les tests
RUN ant -lib dependencies compile
RUN ant -lib dependencies test

# Script pour envoyer une notification par e-mail
COPY send_email.sh /usr/local/bin/send_email.sh
RUN chmod +x /usr/local/bin/send_email.sh

# Commande par défaut pour exécuter l'envoi d'e-mail (ajustez selon vos besoins)
CMD ["/usr/local/bin/send_email.sh"]
