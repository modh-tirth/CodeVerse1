# ── Stage 1: Build ─────────────────────────────────────────
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline -q

COPY src ./src
RUN mvn clean package -DskipTests

# ── Stage 2: Runtime ──────────────────────────────────────
FROM eclipse-temurin:17-jre-alpine

# Create non-root user
RUN addgroup -S codeverse && adduser -S codeverse -G codeverse

WORKDIR /app

# 🔥 IMPORTANT: copy JAR (not WAR)
COPY --from=builder /app/target/*.jar app.jar

RUN chown codeverse:codeverse app.jar

USER codeverse

# ✅ Correct port
EXPOSE 8080

# ✅ Run JAR
ENTRYPOINT ["java", "-jar", "app.jar"]