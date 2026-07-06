# TechLog

学習した内容や開発の記録を投稿できる、シンプルな学習ログ管理アプリです。

以下のUdemy講座を参考に、Ruby on Rails・RSpecを学習しながら作成しました。

- [Ruby on Rails×RSpecで学ぶ実践的なテスト駆動開発](https://www.udemy.com/course/ruby-on-rails-rspec/)

講座の内容をベースにしつつ、一部は講座の範囲を超えて自分で機能追加・実装しています(詳細は下記「自分で追加した機能」を参照)。

## 使用言語・技術

- Ruby 3.3.3
- Ruby on Rails 8.1.3
- Devise(認証)
- Tailwind CSS
- SQLite3(開発・テスト環境) / PostgreSQL(本番環境)
- RSpec / FactoryBot / Capybara(テスト)
- RuboCop / Brakeman / bundler-audit(静的解析)
- GitHub Actions(CI)
- Render(デプロイ)

## 機能一覧

### 講座で学んだ機能

- ユーザー登録・ログイン・ログアウト(Devise)
- 学習ログ(投稿)の新規作成・一覧表示・詳細表示
- 学習ログの削除(投稿した本人のみ)
- ユーザーマイページ(自分が投稿した学習ログの一覧表示)
- ナビゲーションバー、フラッシュメッセージ表示
- バリデーション、エラーメッセージの日本語化
- RSpecによるモデル・リクエスト・システムスペックの作成

### 自分で追加した機能

- 学習ログの編集・更新機能(`edit`/`update`アクション)の実装
- 編集・更新機能に対応するテストの追加(リクエストスペック・システムスペック)
  - ログインしていない場合/本人の場合/別のユーザーの場合、それぞれのアクセス制御の検証
  - 更新成功時・失敗時それぞれの挙動の検証
- 削除機能について、「別のユーザーがログインしている場合」の権限チェックのテストを自作で追加
- 詳細ページの編集・削除ボタンなど、細かいUI調整
- GitHub ActionsのCI設定修正(RSpecが正しく実行されるように)、RuboCop指摘対応など、開発環境まわりの改善

## テスト

RSpecを使用しています。

```bash
bin/rspec
```

## セットアップ

```bash
bundle install
bin/rails db:setup
bin/rails s
```

