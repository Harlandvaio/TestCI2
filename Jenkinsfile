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
                        
                        sh "echo ${DOCKER_PWD} | docker login -u ${DOCKER_USER} --password-stdin"

                        // ✨ 關鍵步驟：在打包成 Image 前，把版本號寫進 HTML 實體檔案中
                        // 我們把 html/index.html 裡的 VERSION_PLACEHOLDER 換成真正的 GIT_TAG
                        sh "sed -i 's/VERSION_PLACEHOLDER/${GIT_TAG}/g' html/index.html"
                        
                        sh "docker build -t ${MY_REPO}:latest -t ${MY_REPO}:${GIT_TAG} ."
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