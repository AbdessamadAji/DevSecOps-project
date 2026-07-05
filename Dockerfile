FROM eclipse-temurin:21-jre

WORKDIR /app

COPY build/libs/project-devops-deploy-0.0.1-SNAPSHOT.jar app.jar

# Never run the application as root
RUN addgroup --system --gid 1001 appgroup && \
    adduser --system --uid 1001 --ingroup appgroup appuser && \
    mkdir -p /app/uploads && \
    chown -R 1001:1001 /app

USER 1001



EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
