
A. Docker Installation

	1) Download docker for windows

	ref : https://docs.docker.com/desktop/windows/install/

	2) After installation, Start the docker engine.

	3) Open powershell and check docker version 
			command : docker version



B. Download and run Tomcat conatiner.

	1) Download tomcat image
			command	: docker pull tomcat:jdk8  (to pull tomcat image with jdk8)
			docker images (to check available docker images)

	2) Run the Docker docker image.
			command : docker run -it -d --name tomcatwar -p 9292:8080 tomcat:jdk8 (this will create a docker container named tomcatwar and it will bind port 9292 of physcial machine to port 8080 of conatiner as default port for tomcat is 8080)

	3) Check if tomcat server is running in browser.
			link : localhost:9292

	4)Download sample.war file and copy it to 'tomcatwar' conatiner.
			command	: docker cp 'D:\DevOps_Practice_Dec21\Devops_Codes\JAVAwar01\sample.war' '9e2ce9c3bee8:/usr/local/tomcat/webapps'  (9e2ce9c3bee8 is the conatiner id)
	          
	5) Check if sample.war is accessible in the browser.
			link	: localhost:9292/sample
	
	
	
C. Enabling self sign cert(SSL configuration)

	1) Go inside the 'tomcatwar' conatiner.
			commands :	docker container ls (to list all the containers)
						docker container exec -it -d 9e2ce9c3bee8 bash  (to get inside the container with bash shell)

	2) 	Create keystore
			command inside the conatiner:  $JAVA_HOME/bin/keytool -genkey -alias tomcat -keyalg RSA  (to generate self signed cert)
			
	3) Edit /usr/local/tomcat/conf/server.xml to apply SSL settings.
		Add below lines in the file.
		
				<Connector
				protocol="org.apache.coyote.http11.Http11NioProtocol"
				port="8443" maxThreads="200"
				scheme="https" secure="true" SSLEnabled="true"
				keystoreFile="${user.home}/.keystore" keystorePass="changeit"
				clientAuth="false" sslProtocol="TLS"/>
		   
	4) exit the conatiner using exit command.

D. Create a docker image using this container

				command :	docker container ls (to list docker containers)
				command	:	docker commit a5d22e8ec795 amolbhawari/sampletomcatwar:latest  (to commit docker container and create docker image)
							
				*Create sample repository in dockerhub*
				
				commands :	docker push amolbhawari/sampletomcatwar:latest  (push the docker image to dockerhub)
				command :	docker pull amolbhawari/sampletomcatwar:latest 	(to pull the above created image)
				
E. 	Create Dockerfile

				From amolbhawari/sampletomcatwar:latest  
				ADD . /usr/local/tomcat/webapps/		 
				EXPOSE 8080
				EXPOSE 8443
				CMD ["catalina.sh", "run"]
			
			
F. Create Docker-compose.yml


				version: "3.9"
				services:
					my-jenkins:
				build:
				context: .
				dockerfile: Dockerfile
				restart: unless-stopped
    
  
				ports:
				- "9998:8080"
				- "9999:8443"

				volumes:
				- ./logs/:/usr/local/tomcat/logs


				container_name: jenkinstomcat02
				

G. Create CICD using jenkins and build.	
			
		git repo	: https://github.com/amolbhawari/samplejavawar01
		got to Github repo -> settings -> webhook
		webhook url	: http://ip-address-of-jenkins:8080/github-webhook/
			add poll scm  : 15 * * * * 
		build using shell: docker-compose up -d
		

H.  Browse the sample application.

		http url: http://localhost:9998/sample/
		https url: https://localhost:9999/sample/
	

	