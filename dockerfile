FROM tomcat:8-jre8-alpine
MAINTAINER ritesh

COPY sample.war /usr/local/tomcat/webapps/

RUN mkdir /var/log/sample \
 && addgroup -g 1000 -S ritesh \ 
 && adduser -u 1000 -S ritesh -G ritesh
 
USER ritesh

CMD ["catalina.sh", "run"]