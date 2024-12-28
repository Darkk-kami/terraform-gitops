resource "aws_iam_role" "ec2_route53_role" {
  name = "ec2-route53-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "route53_policy" {
  name        = "route53-policy"
  description = "Policy for EC2 to interact with Route 53"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:ListHostedZones",
                "route53:GetChange"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect" : "Allow",
            "Action" : [
                "route53:ChangeResourceRecordSets"
            ],
            "Resource" : [
                "${data.aws_route53_zone.selected_zone.arn}"
            ]
        }
    ]
})
}

resource "aws_iam_role_policy_attachment" "route53_policy_attachment" {
  policy_arn = aws_iam_policy.route53_policy.arn
  role       = aws_iam_role.ec2_route53_role.name
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_route53_role.name
}
