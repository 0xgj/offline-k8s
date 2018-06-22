pipeline {
  agent any
  stages {
    stage('build') {
      parallel {
        stage('build') {
          steps {
            sh 'echo \'hello\''
            echo 'adasdf'
            waitUntil()
          }
        }
        stage('test') {
          steps {
            sh 'echo hello'
            sh 'echo hello'
          }
        }
        stage('compile') {
          steps {
            sh 'echo hello'
            sh 'echo \'hello\''
          }
        }
      }
    }
    stage('deploy') {
      steps {
        sh 'echo \'hello world\''
      }
    }
  }
}