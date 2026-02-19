pipeline {
    agent any
    
    environment {
        MY_REPO = "harland2005/testci"
        // 取得時間戳記
        GIT_TAG = sh(script: 'date +%Y%m%d-%H%M', returnStdout: true).trim()
    }

    stages {
        stage('Push Test') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', 
                                                     passwordVariable: 'DOCKER_PWD', 
                                                     usernameVariable: 'DOCKER_USER')]) {
                        
                        // 1. 登入 Docker Hub
                        sh "echo ${DOCKER_PWD} | docker login -u ${DOCKER_USER} --password-stdin"
                        
                        // 2. 建置映像檔 (包含 latest 與 時間戳記標籤)
                        sh "docker build -t ${MY_REPO}:latest -t ${MY_REPO}:${GIT_TAG} ."
                        
                        // 3. 推送
                        sh "docker push ${MY_REPO}:latest"
                        sh "docker push ${MY_REPO}:${GIT_TAG}"
                    }
                }
            }
        }

        stage('K8s Deployment') {
            steps {
                // 4. 更新 K8s 部署 (使用之前架好的 Proxy)
                sh "kubectl set image deployment/my-web-deployment my-web-app=${MY_REPO}:${GIT_TAG}"
            }
        }
    }

    post {
        success {
            echo "部署成功！版本標籤為: ${GIT_TAG}"
        }
        failure {
            echo "部署失敗，請檢查日誌。"
        }
    }
}