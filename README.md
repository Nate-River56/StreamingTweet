# StreamingTweet
Keywordに引っかかるTweetをStreaming API経由で持ってくるRubyコードです

## 使い方

* 初回はマイグレーションを行いSQLiteデータベースを作成してください
```bash
rake db:migrate
```

* いったんテーブルを消す場合はロールバック

```bash
rake db:rollback
```

* 設定したキーワードでTwitter Streaming APIを叩き, 返ってきたJSONを加工しSQLiteに保存します

```bash
KETWORD="HOGE FUGA" foreman start
```

* ログはscreen上で流れるので, screenに入ることでリアルタイムに確認する事ができます

```bash
screen -r twitter
# detachするときは以下を
^A^D
```

* db以下に保存されるので, ご確認ください

```bash
rlwrap sqlite db/tweet.sqlite
```

```sql
-- 件数を確認
SELECT COUNT(*) FROM tweets;

COUNT(*)
----------
2537694
Run Time: real 3.061 user 0.549640 sys 1.845601

-- ランダムにTweetを表示する
SELECT screen_name,posted_at,text FROM tweets ORDER BY RANDOM() LIMIT 1;

screen_name       posted_at      text
----------------  -------------  ----
@xxxx         XXXX-XX-XX XX:XX:XX +0000  XXXXXXXXXXXX
(*p´д`q)゜。
Run Time: real 8.106 user 5.276989 sys 2.697523
```

