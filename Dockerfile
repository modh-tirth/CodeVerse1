# ── Stage 1: Build ──────────────────────────────────────────────────────────
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app
COPY pom.xml .
# Download dependencies first (layer cache)
RUN mvn dependency:go-offline -q

COPY src ./src
RUN mvn clean package -DskipTests

# ── Stage 2: Runtime ─────────────────────────────────────────────────────────
FROM eclipse-temurin:17-jre-alpine

# Non-root user for security
RUN addgroup -S codeverse && adduser -S codeverse -G codeverse

WORKDIR /app

COPY --from=builder /app/target/*.war app.war

RUN chown codeverse:codeverse app.war

USER codeverse

EXPOSE 9797

ENTRYPOINT ["java", "-jar", "app.war"]
