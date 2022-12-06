FROM openjdk:11 as base 
WORKDIR /app
COPY . . 
RUN chmod +x gradlew
RUN ./gradlew build 

FROM tomcat:9
WORKDIR webapps
COPY --from=base /app/build/libs/Responsive_website-0.0.1-SNAPSHOT.war .
<<<<<<< HEAD
<<<<<<< HEAD
RUN rm -rf ROOT && mv Responsive_website-0.0.1-SNAPSHOT.war ROOT.war 
=======
RUN rm -rf ROOT && mv Responsive_website-0.0.1-SNAPSHOT.war ROOT.war
>>>>>>> 280c551fd24db493d7e344e2b7e9cb08578b40cc
=======
RUN rm -rf ROOT && mv Responsive_website-0.0.1-SNAPSHOT.war ROOT.war
>>>>>>> 280c551fd24db493d7e344e2b7e9cb08578b40cc
