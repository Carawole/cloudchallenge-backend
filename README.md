# The Cloud Resume Challenge

## Overview

The Cloud Resume Challenge is a project aimed at showcasing your cloud technology skills. It involves creating a personal resume website hosted on a cloud platform. This initiative provides an excellent opportunity to demonstrate your expertise in infrastructure as code, serverless architecture, and deployment practices.

## Project Structure

This project consists of 2 repositories. The current repository is for the backend, and the frontend repository can be found here:

- [cloud-resume-challenge-frontend](https://github.com/carawole/cloudchallenge-frontend)

The project is organized as follows:

- **Infrastructure as Code (IaC):** Use Terraform to define the necessary cloud resources for your project. This involves specifying services such as Amazon S3, AWS Lambda, CloudFront, DynamoDB, and Amazon API Gateway.

- **Static Website:** Develop a static website that functions as your resume. Utilize HTML, CSS, and possibly JavaScript to craft an engaging and informative online resume.

- **Serverless Functions:** Make use of serverless functions, for instance, AWS Lambda, to manage dynamic aspects of your website. This could involve handling form submissions or interacting with APIs.

## Technologies Used

- **Cloud Provider:** AWS
- **Infrastructure as Code:** Terraform
- **Static Website Framework:** HTML, CSS, JavaScript
- **Serverless:** AWS Lambda, Amazon API Gateway, Amazon DynamoDB
- **CI/CD:** GitHub Actions
- **Testing:** Boto3 Unit Test

## Features

- **Dynamic Content:** Incorporate a dynamic visitor counter into the website, updating in real-time using a serverless function and a database.

## Acknowledgments

- [Forrest Brazeal](https://forrestbrazeal.com/) for creating the Cloud Resume Challenge.
