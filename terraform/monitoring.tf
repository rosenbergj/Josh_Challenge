resource "aws_sns_topic" "cloudfront_errors" {
  name = "single-page-static-site-serverless-MySNSTopic-YW8XKSRIMK4M"
}
resource "aws_sns_topic_subscription" "cloudfront_errors_my_phone" {
  topic_arn = aws_sns_topic.cloudfront_errors.arn
  protocol  = "sms"
  endpoint  = var.phonenumber
}

resource "aws_cloudwatch_metric_alarm" "cloudfront_errors" {
  alarm_name                = "SomeDistributionErrors"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 1
  metric_name               = "TotalErrorRate"
  namespace                 = "AWS/CloudFront"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 10
  # alarm_description         = "This metric monitors ec2 cpu utilization"
  dimensions = {
    DistributionId  = aws_cloudfront_distribution.s3_website_distribution.id
    Region = "Global"
  }
  alarm_actions = [ aws_sns_topic.cloudfront_errors.arn ]
  treat_missing_data = "notBreaching"
}
