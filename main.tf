terraform {
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 4.61.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
#S3 bucket for cloud resume lambda function
resource "aws_s3_bucket" "cazador" {
  bucket      = "pw-lambda"
}

resource "aws_s3_bucket_acl" "pw-private" {
  bucket = aws_s3_bucket.cazador.id
  acl    = "private"
}

 #DynamoDB table
resource "aws_dynamodb_table" "visitors" {
  name         = "VisitorCount"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ClicksOnResume"

  attribute {
    name = "ClicksOnResume"
    type = "N"
  }
}
#Zipped lambda function code in S3 bucket
data "archive_file" "lambda_visitor" {
  type = "zip"

  source_dir  = "${path.module}/visitor-call"
  output_path = "${path.module}/visitor-call.zip"
}

resource "aws_s3_object" "lambda_visitor" {
  bucket = aws_s3_bucket.cazador.id

  key = "visitor-call.zip"
  source = data.archive_file.lambda_visitor.output_path

  etag = filemd5(data.archive_file.lambda_visitor.output_path)
}
#lambda function
resource "aws_lambda_function" "pw_backend" {
  function_name = "Visitors"

  s3_bucket = aws_s3_bucket.cazador.id
  s3_key    = aws_s3_object.lambda_visitor.key

  runtime = "python3.9"
  handler = "function.handler"

  source_code_hash = data.archive_file.lambda_visitor.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_resume_role"

  assume_role_policy = jsonencode ({
    Version = "2012-10-17"
    Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Sid    = ""
            Principal = {
                Service = "lambda.amazonaws.com"
            }
        }
    ]
  })
}

resource "aws_iam_role_policy" "policy" {
  name = "lambda_visitor_policy"
  role = aws_iam_role.lambda_exec.id
  
  policy = jsonencode({
   Version   =  "2012-10-17"
   Statement = [
    {
      Sid    =  "Stmt1680556920448"
      Action =  [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem"
      ]
      Effect   = "Allow"
      Resource = "arn:aws:dynamodb:us-east-1:470858495090:table/VisitorCount"
    }
  ]

  })
  
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
#API gateway
resource "aws_apigatewayv2_api" "lambda" {
  name          = "serverless_lambda_pw"
  protocol_type = "HTTP"

cors_configuration {
  allow_origins = ["*"]
}
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.lambda.id


  name        =  "serverless_lambda_stage"
  auto_deploy = true


  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_pw.arn


    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "visitor_count" {
  api_id = aws_apigatewayv2_api.lambda.id


  integration_uri    = aws_lambda_function.pw_backend.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "visitor_count" {
  api_id = aws_apigatewayv2_api.lambda.id


  route_key = "$default"
  target = "integrations/${aws_apigatewayv2_integration.visitor_count.id}"
}

resource "aws_cloudwatch_log_group" "api_pw" {
  name =  "/aws/api_pw/${aws_apigatewayv2_api.lambda.name}"


  retention_in_days = 30
}

resource "aws_lambda_permission" "api_pw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.pw_backend.function_name
  principal     = "apigateway.amazonaws.com"


  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*" 
}