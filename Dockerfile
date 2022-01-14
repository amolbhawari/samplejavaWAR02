FROM tomcat:8.0.47-jre7

COPY ca.pem ca.pem

RUN openssl x509 -in ca.pem -inform pem -out ca.der -outform der

RUN echo yes | keytool -importcert -alias startssl -keystore \
    /docker-java-home/jre/lib/security/cacerts -storepass changeit -file ca.der 

COPY . /usr/local/tomcat/webapps/
EXPOSE 8080
EXPOSE 8443
CMD ["catalina.sh", "run"]