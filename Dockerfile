FROM alpine:latest
USER 0
RUN mkdir /app
WORKDIR /app/
RUN chown 1001 /app \
	&& chmod "g+rwX" /app \
	&& chown 1001:root /app
COPY /home/jsilvab/dev-env/apache-tomcat-10.1.18 /app/apache-tomcat-10.1.18
COPY /home/jsilvab/dev-env/jdk-17.0.10 /app/jdk-17.0.10

RUN mv /app/webapps/ROOT /app/webapps/ROOT.BAK
RUN mv /app/DashboardUniredView.war /app/ROOT.war
RUN mv /app/DashboardUniredView /app/ROOT

ENV JAVA_HOME=/app/jdk-17.0.10
ENV PATH=$PATH:$JAVA_HOME/bin

EXPOSE 8080
USER 1001

CMD ["sh", "/app/apache-tomcat-10.1.18/bin/startup.sh"]
