# BloomNote

## 【概要（Overview）】
育児を与える側と預かる側の双方が、育児経過をリアルタイムで共有できるWebアプリです！

- 子どもの情報を登録＆管理
- ミルク／睡眠／排泄／昼寝／ごはんの記録
- 行きつけ病院の登録＆管理
- 預かる側との経過を「預かり中／終了ステータス」で管理

---

## 【使用技術】

- Ruby 3.x
- Rails 7.1
- MySQL
- Devise（ユーザー認証）
- pry-rails（デバッグツール）
- annotate（モデル情報支援）
- better_errors & binding_of_caller（デバッグ強化ツール）

---

## 【メイン機能】

| 機能 | 説明 |
|:---|:---|
| User登録・ログイン | Deviseを利用 |
| Child管理 | 子どもの名前、生年月日を登録 |
| Record管理 | ミルク、睡眠、排泄、ごはん、体調メモを記録 |
| Hospital管理 | 病院名、電話番号を登録 |
| CareRelationship管理 | 親と預かる側の関係を管理。預かり中／終了を切り替え |

---

## 【今後追加予定の機能】

- 子どもの素早い変化を通知するPush通知
- 預かり期間を管理できるカレンダー機能
- 育児経過をPDFレポートで出力

---

## 【コンセプト】

> 「親と預かる側という双方の立場の不安を減らし、リアルタイムで育児経過を共有できる」ことを目指した育児アプリです！

---

# テーブル設計（BloomNote）

---

## users テーブル

| Column             | Type    | Options                         |
| ------------------ | ------- | ------------------------------- |
| nickname           | string  | null: false                     |
| email              | string  | null: false, unique: true       |
| encrypted_password | string  | null: false                     |
| role               | integer | null: false, default: 0         |

### Association

- has_many :children
- has_many :hospitals
- has_many :care_relationships_as_parent, class_name: 'CareRelationship', foreign_key: 'parent_id'
- has_many :care_relationships_as_caregiver, class_name: 'CareRelationship', foreign_key: 'caregiver_id'

---

## children テーブル

| Column     | Type       | Options                       |
| ---------- | ---------- | ----------------------------- |
| user       | references | null: false, foreign_key: true |
| name       | string     | null: false                   |
| birth_date | date       | null: false                   |

### Association

- belongs_to :user
- has_many :records
- has_many :care_relationships

---

## records テーブル

| Column      | Type       | Options                       |
| ----------- | ---------- | ----------------------------- |
| child       | references | null: false, foreign_key: true |
| record_type | integer    | null: false                   |
| quantity    | integer    |                               |
| memo        | text       |                               |
| recorded_at | datetime   | null: false                   |

### Association

- belongs_to :child

---

## hospitals テーブル

| Column        | Type       | Options                       |
| ------------- | ---------- | ----------------------------- |
| user          | references | null: false, foreign_key: true |
| name          | string     | null: false                   |
| phone_number  | string     | null: false                   |

### Association

- belongs_to :user

---

## care_relationships テーブル

| Column     | Type       | Options                                          |
| ---------- | ---------- | ------------------------------------------------ |
| parent     | references | null: false, foreign_key: { to_table: :users }   |
| caregiver  | references | null: false, foreign_key: { to_table: :users }   |
| child      | references | null: false, foreign_key: true                  |
| status     | integer    | null: false                                      |

### Association

- belongs_to :parent, class_name: 'User'
- belongs_to :caregiver, class_name: 'User'
- belongs_to :child

---