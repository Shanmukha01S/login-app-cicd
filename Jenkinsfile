pipeline {
    agent any

    environment {
        JAVA_HOME = '/usr/local/jdk1.8.0_202'
        PATH = "${JAVA_HOME}/bin:${PATH}"
        WL_HOME = '/home/shanmukha/Oracle/Middleware/Oracle_Home/wlserver'
        DOMAIN_HOME = '/home/shanmukha/Oracle/Middleware/Oracle_Home/user_projects/domains/base_domain'
        APP_NAME = 'login-app'
        WAR_FILE = "${WORKSPACE}/target/login-app.war"
        WL_ADMIN_URL = 't3://127.0.0.1:7001'
        WL_USER = 'weblogic'
        WL_PASSWORD = 'Shan@1998'
        WL_TARGET = 'MS1'
        WL_PORT = '8001'
    }

    stages {

        stage('Checkout') {
            steps {
                echo '========== Pulling Code from GitHub =========='
                checkout scm
                echo "Branch: ${env.GIT_BRANCH}"
                echo "Commit: ${env.GIT_COMMIT}"
            }
        }

        stage('Maven Compile') {
            steps {
                echo '========== Compiling Source Code =========='
                sh 'mvn compile'
                echo 'Compilation successful!'
            }
        }

        stage('Maven Test') {
            steps {
                echo '========== Running Unit Tests =========='
                sh 'mvn test'
                echo 'Tests passed!'
            }
        }

        stage('Maven Package') {
            steps {
                echo '========== Packaging WAR file =========='
                sh 'mvn package -DskipTests'
                echo 'WAR file created successfully!'
            }
        }

        stage('Verify WAR') {
            steps {
                echo '========== Verifying WAR file =========='
                sh 'ls -lh target/login-app.war'
                sh 'echo "WAR size: $(du -sh target/login-app.war | cut -f1)"'
            }
        }

        stage('Deploy to WebLogic') {
            steps {
                echo '========== Deploying to WebLogic MS1 =========='
                sh """
                    ${JAVA_HOME}/bin/java \
                    -cp ${WL_HOME}/server/lib/weblogic.jar \
                    weblogic.Deployer \
                    -adminurl ${WL_ADMIN_URL} \
                    -username ${WL_USER} \
                    -password ${WL_PASSWORD} \
                    -redeploy \
                    -name ${APP_NAME} \
                    -targets ${WL_TARGET} \
                    ${WAR_FILE} || \
                    ${JAVA_HOME}/bin/java \
                    -cp ${WL_HOME}/server/lib/weblogic.jar \
                    weblogic.Deployer \
                    -adminurl ${WL_ADMIN_URL} \
                    -username ${WL_USER} \
                    -password ${WL_PASSWORD} \
                    -deploy \
                    -name ${APP_NAME} \
                    -targets ${WL_TARGET} \
                    ${WAR_FILE}
                """
                echo 'Deployment completed!'
            }
        }

        stage('Health Check') {
            steps {
                echo '========== Verifying App is Running =========='
                sh """
                    sleep 10
                    STATUS=\$(curl -s -o /dev/null -w "%{http_code}" http://localhost:${WL_PORT}/${APP_NAME}/)
                    echo "HTTP Status: \$STATUS"
                    if [ "\$STATUS" = "200" ] || [ "\$STATUS" = "302" ]; then
                        echo "Application is UP and running!"
                        echo "URL: http://localhost:${WL_PORT}/${APP_NAME}/"
                    else
                        echo "Application health check failed! Status: \$STATUS"
                        exit 1
                    fi
                """
            }
        }

    }

    post {
        success {
            echo '=========================================='
            echo 'PIPELINE SUCCESS'
            echo "App deployed at: http://localhost:${WL_PORT}/${APP_NAME}/"
            echo '=========================================='
        }
        failure {
            echo '=========================================='
            echo 'PIPELINE FAILED - Check logs above!'
            echo '=========================================='
        }
        always {
            echo "Pipeline finished at: ${new Date()}"
            echo "Job: ${env.JOB_NAME} | Build: ${env.BUILD_NUMBER}"
        }
    }
}
