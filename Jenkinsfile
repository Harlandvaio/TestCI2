pipeline {
    agent any
    environment {
        MY_REPO = "harland2005/testci"
        // 取得時間戳記
        GIT_TAG = sh(script: 'date +%Y%m%d-%H%M', returnStdout: true).trim()
    }
    stages {
        // 第一步：Jenkins 會自動執行 Checkout SCM，所以不需要手動寫 git clone
        
        stage('Push Test') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', 
                                                     passwordVariable: 'DOCKER_PWD', 
                                                     usernameVariable: 'DOCKER_USER')]) {
                        
                        sh "echo ${env.DOCKER_PWD} | docker login -u ${env.DOCKER_USER} --password-stdin"
                        
                        // 編譯時會自動抓取當前目錄（GitHub 下載下來的內容）
                        sh "docker build -t ${env.MY_REPO}:latest -t ${env.MY_REPO}:${env.GIT_TAG} ."
                        sh "docker push ${env.MY_REPO}:latest"
                        sh "docker push ${env.MY_REPO}:${env.GIT_TAG}"
                    }
                }
            }
        }
        stage('K8s Deployment') {
            steps {
                // 使用我們之前架好的 Proxy 通道
                sh "kubectl set image deployment/my-web-deployment my-web-app=${env.MY_REPO}:${env.GIT_TAG}"
            }
        }
    }
}