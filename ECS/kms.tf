resource "aws_kms_key" "example" {
  description = "example kms key"
  # キーの変更を有効化
  enable_key_rotation = true
  is_enabled          = true
  # 削除待機期間
  deletion_window_in_days = 30
}

resource "aws_kms_alias" "example-alias" {
  name          = "alias/example"
  target_key_id = aws_kms_key.example.id
}
