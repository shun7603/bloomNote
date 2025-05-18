# BloomNote

## 概要（Overview）
親と共有者（祖父母・子どもを預け先）が、ルーティンに沿って育児記録をリアルタイムで共有できるWebアプリです。

- 子どもの情報を登録＆管理
- ミルク／睡眠／排泄／ごはん／体調などの記録
- ルーティン（育児予定）の可視化・共有
- 病院・緊急連絡先の登録
- 共有者ごとに「共有中／終了」ステータスで管理

## 開発の背景
このアプリを作ったきっかけは、去年出産した妹のためでした。
妹が子どもを親や祖父母に預ける際、「うちの子のルーティンや細かな注意点を毎回説明するのが大変」と悩んでいたのが原点です。

また、自分自身が子どもを預かったとき、「ちゃんと記録をつけていることを親にリアルタイムで伝えられたら、もっと安心してもらえるのでは？」と感じました。

一方で、アプリが複雑だと自分や機械が苦手な人には使いこなせない現実もあります。
だからこそ、ボタンを最小限にし、誰でも迷わず直感的に使える**シンプルなUI・UX**にこだわりました。


## 使用技術
- Ruby 3.x
- Rails 7.1
- MySQL / PostgreSQL（本番対応可）
- Devise（ユーザー認証）
- Bootstrap 5
- Turbo
- pry-rails / better_errors / annotate
- Active Storage

## 他アプリと比べてここが違う！

| 比較項目         | 一般的な育児アプリ    | BloomNoteの強み                   |
|-----------------|-------------------|-----------------------------------|
| 共有対象         | 親のみ/家族のみ      | 親＋祖父母＋シッター等“第三者”までOK   |
| ルーティン管理    | シンプルな記録       | 親が設定した予定を共有者に見える化     |
| 通知機能         | アプリ内通知/なし    | 共有者の記録→親にPush通知（予定）     |
| 権限管理         | 弱い               | 役割ごとの細かな操作範囲コントロール   |
| UI/UX           | さまざま           | とことんシンプル・直感設計            |


## メイン機能

| 機能                | 説明                                                     |
|-------------------------------------------------------------------------------|--------------------------------------------------------------------------------|
| User登録・ログイン   | Deviseを利用。ニックネーム・メールで管理                       |
| Child管理           | 子どもの名前・生年月日・性別を登録                            |
| Record管理          | ミルク・睡眠・排泄・ごはん・体調など育児記録を入力・一覧表示       |
| Routine管理         | ルーティン（予定・記録）を登録・可視化                         |
| Hospital管理        | 子どもごとに病院名・電話番号を登録                            |
| CareRelationship管理| 親・共有者の関係を「共有中／終了」で切替・権限管理               |
| Notification管理    | Web Push通知（近日実装予定）                                |

## 今後追加予定の機能
- 子どもの変化を親へ即通知するPush通知

## コンセプト
> 「親も共有者も、お互いに安心して育児経過を共有できる」
> 直感的な操作性と、家族や共有者の“困った”に応える柔軟な情報共有を目指します。

# テーブル設計（BloomNote）

## users テーブル

| Column             | Type    | Options                              |
|--------------------|---------|--------------------------------------|
| nickname           | string  | null: false                          |
| email              | string  | null: false, unique: true            |
| encrypted_password | string  | null: false                          |
| role               | integer | null: false, default: 0              |
| subscription_token | text    |                                      |
| created_at         | datetime|                                      |
| updated_at         | datetime|                                      |

### Association
- has_many :children
- has_many :hospitals
- has_many :care_relationships_as_parent, class_name: 'CareRelationship', foreign_key: 'parent_id'
- has_many :care_relationships_as_caregiver, class_name: 'CareRelationship', foreign_key: 'caregiver_id'
- has_many :subscriptions

## children テーブル

| Column     | Type       | Options                               |
|------------|------------|---------------------------------------|
| user       | references | null: false, foreign_key: true        |
| name       | string     | null: false                           |
| birth_date | date       | null: false                           |
| gender     | integer    | null: false, default: 0               |
| created_at | datetime   |                                       |
| updated_at | datetime   |                                       |

### Association
- belongs_to :user
- has_many :records
- has_many :routines
- has_many :hospitals
- has_many :care_relationships

## records テーブル

| Column      | Type       | Options                               |
|-------------|------------|---------------------------------------|
| child       | references | null: false, foreign_key: true        |
| user_id     | bigint     |                                       |
| record_type | integer    | null: false                           |
| category    | string     |                                       |
| quantity    | integer    |                                       |
| memo        | text       |                                       |
| recorded_at | datetime   | null: false                           |
| created_at  | datetime   |                                       |
| updated_at  | datetime   |                                       |

### Association
- belongs_to :child
- belongs_to :user

## routines テーブル

| Column        | Type       | Options                       |
|---------------|------------|-------------------------------|
| child         | references | null: false, foreign_key: true|
| time          | time       | null: false                   |
| task          | string     | null: false                   |
| category      | string     | null: false                   |
| memo          | text       |                               |
| important     | boolean    | default: false                |
| quantity      | integer    |                               |
| count         | integer    |                               |
| temperature   | float      |                               |
| condition     | string     |                               |
| medicine_name | string     |                               |
| hospital_name | string     |                               |
| event_type    | string     |                               |
| created_at    | datetime   |                               |
| updated_at    | datetime   |                               |

### Association
- belongs_to :child

## hospitals テーブル

| Column        | Type       | Options                               |
|---------------|------------|---------------------------------------|
| user          | references | null: false, foreign_key: true        |
| child         | references | null: false, foreign_key: true        |
| name          | string     | null: false                           |
| phone_number  | string     | null: false                           |
| created_at    | datetime   |                                       |
| updated_at    | datetime   |                                       |

### Association
- belongs_to :user
- belongs_to :child

## care_relationships テーブル

| Column     | Type       | Options                                          |
|------------|------------|--------------------------------------------------|
| parent     | references | null: false, foreign_key: { to_table: :users }   |
| caregiver  | references | null: false, foreign_key: { to_table: :users }   |
| child      | references | null: false, foreign_key: true                   |
| status     | integer    | null: false                                      |
| created_at | datetime   |                                                  |
| updated_at | datetime   |                                                  |

### Association
- belongs_to :parent, class_name: 'User'
- belongs_to :caregiver, class_name: 'User'
- belongs_to :child

## subscriptions テーブル

| Column      | Type       | Options                               |
|-------------|------------|---------------------------------------|
| user        | references | null: false, foreign_key: true        |
| endpoint    | string     | null: false, unique: true             |
| p256dh_key  | string     | null: false                           |
| auth_key    | string     | null: false                           |
| created_at  | datetime   |                                       |
| updated_at  | datetime   |                                       |

### Association
- belongs_to :user

---

## テストアカウント
- メール：test@test
- パスワード：222222

## URL
https://bloomnote.onrender.com

## ご質問・ご要望
フィードバックやバグ報告もお気軽にどうぞ！