FROM tomcat:jdk21-temurin-jammy
COPY dist/DashboardUniredView.war /usr/local/tomcat/webapps/ROOT.war
RUN rm -rf /usr/local/tomcat/webapps/ROOT
RUN rm -rf /usr/local/tomcat/webapps.dist/ROOT
RUN chmod -R 777 /usr/local/tomcat

EXPOSE 8080
USER 1001

CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]
