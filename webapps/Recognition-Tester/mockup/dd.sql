
-- 判定結果を保存するテーブル
-- 上位3つだけ保存（拡張する必要はあるか？？）
-- 入力画像は (id).jpgという形式で外部に保存します。
CREATE TABLE results (
id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
-- 判定に使用するシステム、アルゴリズムなど
system VARCHAR(255) NOT NULL DEFAULT '',
algorithm VARCHAR(255) NOT NULL DEFAULT '',
descriptors_id VARCHAR(255) NOT NULL DEFAULT '',
-- ディスクリプタによる投票で得られた候補(最大3つ)
answer1 INTEGER NOT NULL,
answer2 INTEGER,
answer3 INTEGER,
score1 FLOAT NOT NULL,
score2 FLOAT,
score3 FLOAT,
desc1 VARCHAR(255) NOT NULL DEFAULT '',
desc2 VARCHAR(255),
desc3 VARCHAR(255),
-- 人間が設定する正答
correct_answer INTEGER,
correct_desc VARCHAR(255),
corrected_by VARCHAR(255),
corrected_at DATETIME,
-- タイムスタンプ
created_at DATETIME,
modified_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
)ENGINE=InnoDB, CHARACTER SET=utf8;

-- 判定対象となるアイテム
CREATE TABLE items (
id INTEGER NOT NULL PRIMARY KEY,
code BIGINT NOT NULL DEFAULT 0,
name VARCHAR(255) NOT NULL DEFAULT '',
)ENGINE=InnoDB, CHARACTER SET=utf8;
