pipeline {
    agent any

    options {
        disableConcurrentBuilds()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t pdf-navigator-extension:${BUILD_NUMBER} .
                '''
            }
        }

        stage('Validate Manifest') {
            steps {
                sh '''
                    docker run --rm \
                      --entrypoint sh \
                      pdf-navigator-extension:${BUILD_NUMBER} \
                      -c "jq -e '.manifest_version == 3' manifest.json"
                '''
            }
        }

        stage('Package Extension') {
            steps {
                sh '''
                    set -eu

                    IMAGE="pdf-navigator-extension:${BUILD_NUMBER}"
                    CONTAINER="pdf-navigator-package-${BUILD_NUMBER}"

                    mkdir -p dist
                    rm -f dist/pdf-navigator-extension.zip

                    docker rm -f "$CONTAINER" >/dev/null 2>&1 || true
                    docker create --name "$CONTAINER" "$IMAGE"
                    docker start -a "$CONTAINER"
                    docker cp "$CONTAINER:/output/pdf-navigator-extension.zip" dist/
                    docker rm "$CONTAINER"

                    test -s dist/pdf-navigator-extension.zip
                '''
            }
        }

        stage('Archive Artifact') {
            steps {
                archiveArtifacts(
                    artifacts: 'dist/pdf-navigator-extension.zip',
                    fingerprint: true
                )
            }
        }
    }
}
