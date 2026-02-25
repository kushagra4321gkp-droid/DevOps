# Ì∫Ä JobApp - CI Pipeline with Jenkins

This project demonstrates a complete Continuous Integration (CI) workflow using **Jenkins** to build and test a Spring Boot application.

---

## Ì≥ñ Project Overview

This repository contains:

- ‚úÖ Spring Boot application
- ‚úÖ Jenkins Declarative Pipeline
- ‚úÖ Automated build process
- ‚úÖ Automated test execution
- ‚úÖ CI pipeline monitoring

The pipeline ensures that every code change is automatically built and tested.

---

## Ìª†Ô∏è Tech Stack

- Java 21
- Maven
- Spring Boot
- Jenkins
- Git & GitHub

---

# Ì¥Ñ CI Pipeline Workflow

The Jenkins pipeline follows this workflow:

1. **Trigger**
   - Manual trigger or GitHub webhook

2. **Workspace Cleanup**
   - Old files removed using `deleteDir()`

3. **Source Code Checkout**
   - Jenkins pulls latest code from GitHub

4. **Build Stage**
   - Maven compiles the project
   - Dependencies resolved
   - JAR file generated

5. **Test Stage**
   - Unit tests executed
   - Spring context loads
   - Build fails if tests fail

6. **Build Result**
   - SUCCESS / FAILURE reported in Jenkins dashboard

---

# Ì≥ä Pipeline Architecture

---

# Ì∑æ Jenkinsfile (Pipeline as Code)

The project uses Declarative Pipeline:

```groovy
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'mvn clean install'
            }
        }
    }
}

