pipeline {
    agent any

    environment {
        JAVA_HOME = '/usr/local/jdk1.8.0_202'
        PATH = "${JAVA_HOME}/bin:${PATH}"
        WL_HOME = '/home/shanmukha/Oracle/Middleware/Oracle_Home/wlserver'
        DOMAIN_HOME = '/home/shanmukha/Oracle/Middleware/Oracle_Home/user_projects/domains/base_domain'
        APP_NAME = 'login-app'
        WAR_FILE = "${WORKSPACE}/target/login-app.war"
        WL_ADMIN_URL = 'http://localhost:7001'
        WL_USER = 'weblogic'
        WL_PASSWORD = 'Shan@1998'
        WL_TARGET = 'MS1'
        WL_PORT = '8001'
    }

    stages {

        stage('Checkout') {
            steps {
                echo '========== Pulling code from GitHub =========='
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo '========== Building WAR with Maven =========='
                sh 'mvn clean package'
                echo 'Build completed successfully!'
            }
        }

        stage('Verify WAR') {
            steps {
                echo '========== Verifying WAR file =========='
                sh 'ls -lh target/login-app.war'
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
                        echo "✅ Application is UP and running!"
                    else
                        echo "❌ Application health check failed! Status: \$STATUS"
                        exit 1
                    fi
                """
            }
        }

    }

    post {
        success {
            echo '=========================================='
            echo '✅ PIPELINE SUCCESS - App deployed!'
            echo '=========================================='
        }
        failure {
            echo '=========================================='
            echo '❌ PIPELINE FAILED - Check logs above!'
            echo '=========================================='
        }
    }
}
