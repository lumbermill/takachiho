# Git
```
git diff
git diff HEAD
git diff --staged
git diff -w # 空白の違いを無視
```

## リモートブランチ
```
# 一覧
git branch -r
# 作成
git push -u origin branch_name
# 作業開始
git checkout --track origin/branch_name
# 削除
git branch -r -d origin/branch_name
git push origin :branch_name
```
