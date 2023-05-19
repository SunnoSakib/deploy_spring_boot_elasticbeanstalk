# Define the provider (AWS in this example)
provider "aws" {
  region = "us-east-1"
}

# Create an Elastic Beanstalk application
resource "aws_elastic_beanstalk_application" "my_app" {
  name        = "my-app"
  description = "My Spring Boot Application"
}

# Create an Elastic Beanstalk environment
resource "aws_elastic_beanstalk_environment" "staging_env" {
  name                = "staging-env"
  application         = aws_elastic_beanstalk_application.my_app.name
  solution_stack_name = "64bit Amazon Linux 2 v5.4.1 running Java 11"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  setting {
    namespace = "aws:elasticbeanstalk:container:java"
    name      = "JVMOptions"
    value     = "-Xms256m -Xmx512m"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SPRING_PROFILES_ACTIVE"
    value     = "production"
  }
}

# Deploy the Spring Boot application to the Elastic Beanstalk environment
resource "aws_elastic_beanstalk_application_version" "my_app_version" {
  name        = "my-app-version"
  application = aws_elastic_beanstalk_application.my_app.name
  description = "Example Spring Boot Application Version"
  bucket      = "my-app-deployment-bucket"
  key         = "my-app.jar"
}

# Create an Elastic Beanstalk environment deployment
resource "aws_elastic_beanstalk_environment" "staging_env_deployment" {
  name          = "staging-env-deployment"
  application   = aws_elastic_beanstalk_application.my_app.name
  version_label = aws_elastic_beanstalk_application_version.my_app_version.name
}

