pipeline {
    agent any

    environment {
        APP_NAME        = 'codeverse'
        IMAGE_NAME      = "codeverse/app:${BUILD_NUMBER}"
        SONAR_HOST_URL  = 'http://localhost:9000'
        SONAR_TOKEN     = credentials('sonar-token')       // Jenkins credential ID
        DOCKER_REGISTRY = 'docker.io'                      // change to your registry
    }

    tools {
        maven 'Maven-3.9'   // must match the name configured in Jenkins Global Tools
        jdk   'JDK-17'      // must match the name configured in Jenkins Global Tools
    }

    stages {

        // ─────────────────────────────────────────────
        stage('Checkout') {
        // ─────────────────────────────────────────────
            steps {
                checkout scm
                echo "Branch: ${env.GIT_BRANCH} | Commit: ${env.GIT_COMMIT}"
            }
        }

        // ─────────────────────────────────────────────
        stage('Build') {
        // ─────────────────────────────────────────────
            steps {
                sh 'mvn clean package -DskipTests'
            }
            post {
                success { echo 'Build successful — WAR created.' }
                failure { error  'Build failed. Stopping pipeline.' }
            }
        }

        // ─────────────────────────────────────────────
        stage('Unit Tests') {
        // ─────────────────────────────────────────────
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit allowEmptyResults: true,
                          testResults: '**/target/surefire-reports/*.xml'
                }
            }
        }

        // ─────────────────────────────────────────────
        stage('SonarQube Analysis') {
        // ─────────────────────────────────────────────
            steps {
                withSonarQubeEnv('SonarQube') {   // must match Jenkins SonarQube server name
                    sh """
                        mvn sonar:sonar \
                            -Dsonar.projectKey=${APP_NAME} \
                            -Dsonar.host.url=${SONAR_HOST_URL} \
                            -Dsonar.token=${SONAR_TOKEN}
                    """
                }
            }
        }

        // ─────────────────────────────────────────────
        stage('SonarQube Quality Gate') {
        // ─────────────────────────────────────────────
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        // ─────────────────────────────────────────────
        stage('Docker Build') {
        // ─────────────────────────────────────────────
            steps {
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        // ─────────────────────────────────────────────
        stage('Trivy — Filesystem Scan') {
        // ─────────────────────────────────────────────
            steps {
                sh """
                    trivy fs \
                        --exit-code 0 \
                        --severity HIGH,CRITICAL \
                        --format table \
                        --output trivy-fs-report.txt \
                        .
                """
            }
            post {
                always {
                    archiveArtifacts artifacts: 'trivy-fs-report.txt', allowEmptyArchive: true
                }
            }
        }

        // ─────────────────────────────────────────────
        stage('Trivy — Docker Image Scan') {
        // ─────────────────────────────────────────────
            steps {
                sh """
                    trivy image \
                        --exit-code 1 \
                        --severity CRITICAL \
                        --format table \
                        --output trivy-image-report.txt \
                        ${IMAGE_NAME}
                """
            }
            post {
                always {
                    archiveArtifacts artifacts: 'trivy-image-report.txt', allowEmptyArchive: true
                }
                failure {
                    echo 'CRITICAL vulnerabilities found in Docker image. Review trivy-image-report.txt'
                }
            }
        }

        // ─────────────────────────────────────────────
        stage('Push to Registry') {
        // ─────────────────────────────────────────────
            when {
                branch 'main'   // only push on main branch
            }
            steps {
                withCredentials([usernamePassword(
                        credentialsId: 'docker-registry-creds',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo ${DOCKER_PASS} | docker login ${DOCKER_REGISTRY} -u ${DOCKER_USER} --password-stdin
                        docker push ${IMAGE_NAME}
                        docker logout
                    """
                }
            }
        }

        // ─────────────────────────────────────────────
        stage('Deploy') {
        // ─────────────────────────────────────────────
            when {
                branch 'main'
            }
            steps {
                sh """
                    docker stop ${APP_NAME} || true
                    docker rm   ${APP_NAME} || true
                    docker run -d \
                        --name ${APP_NAME} \
                        -p 9797:9797 \
                        --restart unless-stopped \
                        ${IMAGE_NAME}
                """
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo "Pipeline completed successfully for build #${BUILD_NUMBER}"
        }
        failure {
            echo "Pipeline FAILED for build #${BUILD_NUMBER}. Check logs."
        }
    }
}
