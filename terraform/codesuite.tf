# First IAM, then codepipeline bucket, then the pipeline itself

data "aws_iam_policy_document" "codepipeline_inline_policy" {
  statement {
    actions = [
      "codecommit:CancelUploadArchive",
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:GetUploadArchiveStatus",
      "codecommit:UploadArchive",
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "codedeploy:CreateDeployment",
      "codedeploy:GetApplicationRevision",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision",
    ]
    resources = ["*"]
  }
  statement {
    actions   = ["iam:PassRole"]
    resources = ["*"]
  }
  statement {
    actions   = ["cloudwatch:*", "s3:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "codepipeline_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "single-page-static-site-serverle-MyIAMPipelineRole-JRNKFO3ICWAM" # ew, leftover from original CF deploy
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role_policy.json

  inline_policy {
    name   = "AWS-CodePipeline-Service-3"
    policy = data.aws_iam_policy_document.codepipeline_inline_policy.json
  }
}

resource "aws_s3_bucket" "codepipeline" {
  bucket = "single-page-static-site-serverle-mypipelinebucket-d2u1z649olx3" # also a name leftover from CF deploy
}

data "aws_iam_policy_document" "codepipeline_bucket_policy" {
  statement {
    sid = "DenyUnEncryptedObjectUploads"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "s3:PutObject",
    ]
    effect = "Deny"
    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["aws:kms"]
    }
    resources = [
      "${aws_s3_bucket.codepipeline.arn}/*",
    ]
  }
  statement {
    sid = "DenyInsecureConnections"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "s3:*",
    ]
    effect = "Deny"
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
    resources = [
      "${aws_s3_bucket.codepipeline.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "codepipeline" {
  bucket = aws_s3_bucket.codepipeline.id
  policy = data.aws_iam_policy_document.codepipeline_bucket_policy.json
}

resource "aws_codepipeline" "website_deploy" {
  name     = "HelloPipeline"
  role_arn = aws_iam_role.codepipeline_role.arn
  artifact_store {
    location = aws_s3_bucket.codepipeline.bucket
    type     = "S3"
  }
  stage {
    name = "Source"
    action {
      name             = "CodeCommitSource"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["HelloZip"]
      configuration = {
        RepositoryName = "helloworld"
        BranchName     = "master" # FIXME main is better
      }
    }
  }
  stage {
    name = "Deploy"
    action {
      name            = "DeployToS3"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      input_artifacts = ["HelloZip"]
      version         = "1"
      configuration = {
        BucketName = var.fqdn
        Extract    = true
      }
    }
  }
}
