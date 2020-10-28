# Akimoto
- 2020.10 プロジェクトを削除しました。base.lmlab.netに類似の(商品管理)データベースがあります。
  - db/seedsにamway,beerの商品が幾つか登録されています。使えたかもしれませんが古いので一旦捨てます。

  Four eyes see more than two.

## Objective
Shares EAN/JAN based item information. Every users can add/edit any information.
Every information is stored in the database.
We provide algorithms to extract the master data from it. i.e. items_for_public, items_for_a_company

## How it works
- web application(on phase 1) and iOS app(on phase 2)
- tagging on items
- Users can download any data

# ToDo
たくさんありすぎるのでまずここで。GitHubのIssuesもおいおい使います。

- items/editを動作させる。写真をアップロード、リサイズできるように。
- pages/rootでも商品の一覧が見えるようにする。ページめくりは？
- 画像の実体は/var/www/akimoto/picturesに置いて、public/picturesはシンボリックリンクに
  こうしないとリリースのたびに消えてしまうので…。

# Done
完了したタスクはこちらに移動します。
