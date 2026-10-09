pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Validate Manifest') {
            steps {
                sh '''
                    python -c "import json; m=json.load(open('manifest.json')); assert m.get('manifest_version') == 3; print('Manifest V3 is valid')"
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t pdf-navigator-extension:latest .'
            }
        }

        stage('Package Extension') {
            steps {
                sh '''
                    mkdir -p dist
                    docker run --rm \
                      -v "$(pwd)/dist:/output" \
                      pdf-navigator-extension:latest
                    unzip -t dist/pdf-navigator-extension.zip
                '''
            }
        }

        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: 'dist/pdf-navigator-extension.zip',
                                 fingerprint: true
            }
        }
    }
}
