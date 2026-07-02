FROM eclipse-temurin:21-jre

WORKDIR /app

COPY build/libs/project-devops-deploy-0.0.1-SNAPSHOT.jar app.jar

# Never run the application as root
RUN addgroup --system appgroup && \
    adduser --system --ingroup appgroup appuser && \
    mkdir -p /app/uploads && \
    chown -R appuser:appgroup /app

USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
