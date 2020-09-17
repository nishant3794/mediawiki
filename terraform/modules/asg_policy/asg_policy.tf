variable "type" { default = "asg-policy" }
variable "cooldown" { default = "300" }
variable "autoscaling_group_name" { }
variable "adjustment_type" { default = "ChangeInCapacity" }
variable "scaling_adjustment" { default = "0" }
variable "metric_aggregation_type" { default = "Average" }
variable "estimated_instance_warmup" { default = 90 }
variable "comparison_operator" { default = "LessThanOrEqualToThreshold"}
variable "evaluation_periods" { default = "2" }
variable "metric_name" { default = "CPUUtilization" }
variable "period" { default = "300" }
variable "treat_missing_data" { default = "breaching" }
variable "name" { }
variable "name_space" { default = "AWS/EC2" }
variable "threshold" { description = "The value against which the specified statistic is compared." }
variable "statistic" {
  description = "The statistic to apply to the alarm's associated metric. Valid values are 'SampleCount', 'Average', 'Sum', 'Minimum' and 'Maximum'"
  default     = "Average"
}
variable "valid_statistics" {
    default = {
    Average     = "Average"
    Maximum     = "Maximum"
    Minimum     = "Minimum"
    SampleCount = "SampleCount"
    Sum         = "Sum"
  }
}
variable "valid_missing_data" {

  default = {
    missing      = "missing"
    ignore       = "ignore"
    breaching    = "breaching"
    notBreaching = "notBreaching"
  }
}


resource "aws_autoscaling_policy" "asg-policy" {
  name			                = var.name
  scaling_adjustment        = var.scaling_adjustment
  adjustment_type           = var.adjustment_type
  cooldown                  = var.cooldown
  autoscaling_group_name    = var.autoscaling_group_name
}

resource "aws_cloudwatch_metric_alarm" "monitor-asg" {
  actions_enabled     = true
  alarm_actions       = [aws_autoscaling_policy.asg-policy.arn]
  alarm_description   = "${aws_autoscaling_policy.asg-policy.name} ASG Monitor"
  alarm_name          = aws_autoscaling_policy.asg-policy.name
  comparison_operator = var.comparison_operator

  dimensions = {
    "AutoScalingGroupName" = var.autoscaling_group_name
  }

  evaluation_periods = var.evaluation_periods
  metric_name        = var.metric_name
  namespace          = var.name_space
  period             = var.period
  statistic          = lookup(var.valid_statistics, var.statistic)
  threshold          = var.threshold
  treat_missing_data = lookup(var.valid_missing_data, var.treat_missing_data)
}

output "asg-policy-id" { value = "${aws_autoscaling_policy.asg-policy.id}" }
output "asg-policy-arn" { value = "${aws_autoscaling_policy.asg-policy.arn}" }
output "asg-policy-name" { value = "${aws_autoscaling_policy.asg-policy.name}" }