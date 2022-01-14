FROM tomcat:8.0.47-jre7

COPY ca.pem ca.pem


COPY . /usr/local/tomcat/webapps/
EXPOSE 8080
EXPOSE 8443
CMD ["catalina.sh", "run"]