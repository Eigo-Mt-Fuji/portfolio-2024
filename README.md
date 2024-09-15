# portfolio-2024

## 次のアクションプラン

- 能力開発継続
  - 戦略思考と論点を研ぐ 実践投入 202409
    - ちょうど現場によい機会がある。やってみて答え合わせを11月までに行ってミートアップする
     - [戦略思考12スイッチ](https://github.com/Eigo-Mt-Fuji/portfolio-2024/blob/main/docs%2F%E8%81%B7%E8%83%BD%E9%96%8B%E7%99%BA%2F2024%E5%B9%B42%E6%9C%884%E6%97%A5_%E6%88%A6%E7%95%A5%E6%80%9D%E8%80%83.md)
     - https://jinjibu.jp/spcl/takamatsu/cl/detl/5236/
    - 戦略は置かれた環境と自分ができるすべての技術を踏まえる
  - [生成ai langchain](https://github.com/Eigo-Mt-Fuji/portfolio-2024/blob/main/docs%2F%E7%94%9F%E6%88%90AI%2F2024%E5%B9%B48%E6%9C%8812%E6%97%A5_Langchain%E3%82%B3%E3%83%B3%E3%82%BB%E3%83%95%E3%82%9A%E3%83%88%E5%AD%A6%E7%BF%92.md)
    - https://github.com/Eigo-Mt-Fuji/genai-app/tree/main
  - [SRE活動 AWS ECS編](https://github.com/Eigo-Mt-Fuji/portfolio-2024/blob/main/docs%2F2024%E5%B9%B48%E6%9C%8812%E6%97%A5_AWS_ECS_Exec%E3%81%A8%E4%BB%B2%E8%89%AF%E3%81%8F%E3%81%AA%E3%82%8B.md)
  - [アーキテクチャ設計力改善 - 性能](https://github.com/Eigo-Mt-Fuji/portfolio-2024/blob/main/docs%2F2024%E5%B9%B48%E6%9C%885%E6%97%A5_%E5%8A%B9%E7%8E%87%E6%80%A7_RAER%EF%BC%88Resource-Aware%20Efficiency%20Requirements%EF%BC%89%E3%81%AB%E6%9B%B8%E3%81%8F%E3%81%B8%E3%82%99%E3%81%8D%E3%81%93%E3%81%A8%E3%81%AE%E3%82%A4%E3%83%A1%E3%83%BC%E3%82%B7%E3%82%99.md)


```
認定試験を受験しつつ仕事としての道を一本に絞っていく
    Kubernetes認定 Certified Kubernetes Administrator (CKA)
        k8sのアーキテクチャ全体と各機能の役割を理解
        アウトプットできるようになっていれば合格
        出題範囲に比べて、試験問題は20問程度と少ない
        3時間で20問程度を解く
    AWS認定 DOP
        AWS プラットフォーム上の分散アプリケーションシステムのプロビジョニング、運用、管理に関する技術的専門知識を示し、仲間や関係者、お客様からの信頼と信用を強化するもの
            これらの適格なプロフェッショナルがいる組織は、安全でコンプライアンスに準拠した、高い可用性とスケーラビリティを持つシステムを迅速に提供することができます
AWS実践訓練を続ける:
    NLB x ECS x EC2 x Fluent-bit構成の実践(+ ECS Service Connectを試してみる) https://github.com/Eigo-Mt-Fuji/portfolio-2024/blob/main/terraform/components/logcollector/main.tf
      起動タイプEC2
        Amazon Linux 2023
        Graviton メモリ最適化(r8g)
      Fluent-bitの最新版 と WASM
      Blue/Green Deployment
      その他
        Capacity Provider利用
        ECS Exec
```

- 読書継続。さらなる豊かさを求めて
 
  - 効率的なgo 2024 `読んでいく`
  - ソフトウェアアーキテクチャハードパーツ 2022 `読むぞ`
  - SLO サービスレベル目標 2023 `読むぞ`
  - 大規模データ管理 2024 `ほしい`

## 本は心の栄養(読書候補,予算年間12万円／20冊程度)

### 技術

- **Python Distilled AUTHOR David M. Beazley　著、鈴木 駿　訳**
- **アジャイル・イントロダクション**
- **効率的なgo 2024**
- ソフトウェアアーキテクチャハードパーツ 2022
- SLO サービスレベル目標 2023
- 大規模データ管理 2024
- APIデザインパターン(GoogleのAPI設計ルールに学ぶ- Web API開発のベストプラクティス)
- マイクロサービスパターン(実践的システムデザインのためのコード解説)
- エンジニア時間管理術
- エレガントな問題解決
- 実践keycloak openidconnect oauth2.0を利用したモダンアプリケーションのセキュリティ保護
- efficient linux コマンドライン
- カオスエンジニアリング

### 能力開発

- **「暗記する」戦略思考 高松 智史**
  - 題材は経営コンサル的な話題が中心で解説されているが、システムの課題解決に適用しても効果が高そう。
    - 抽象度高いテーマで課題が振られた時どのように課題解決するかの型として、モノにするため、戦略スイッチは何度か繰り返し復習する。特にリアリティスイッチとフチドリ思考は、その都度思考環境を構築するのにすごく助かる型をもたらしてくれそう。

- ~~データで話す組織~~
  - [なぜこれを読みたいと思ったかを考えてみる](https://github.com/Eigo-Mt-Fuji/portfolio-2024/blob/main/docs/%E8%81%B7%E8%83%BD%E9%96%8B%E7%99%BA/2024%E5%B9%B42%E6%9C%8811%E6%97%A5_%E3%83%87%E3%83%BC%E3%82%BF%E3%81%A7%E8%A9%B1%E3%81%99%E7%B5%84%E7%B9%94%E3%81%A8%E3%81%84%E3%81%86%E6%9B%B8%E7%B1%8D%E3%82%92%E3%81%AA%E3%81%9C%E8%AA%AD%E3%82%80.md) -> 買わないことにした。
    - 「暗記する」戦略思考の復習に集中
    - 代わりの書籍を探す「クリティカルシンキング」、「論点を研ぐ」

- **論点を研ぐ**
  - 読んだ。同質化、前提の自覚、前提を問い直す、再構築。同質化=仕事の現場が変わる度に普段おこなっていたキャッチアップに型をもたらしてくれそう。前提の自覚・問い直し=仮説と主論点から前提を導く必要性が時々発生するので、7つの観点からの推察x3つのといかけ(漏れ、妥当性、あえて)を活用していく。再構築=まだわかってない。抽象度高いので定期復習すべし。
- **思考の整理学**
  - 東大＆京大で1番読まれた本！
（2014年1月~2023年12月　直近10年文庫ランキング　東大生協・京大生協調べ）
  - https://www.flierinc.com/summary/1153?utm_source=google&utm_medium=cpc&utm_campaign=dsa&gad_source=1&gclid=Cj0KCQjw1qO0BhDwARIsANfnkv8mu6zT2SB8DfAsdCZZQQRFNUxYWbgQgm7sJL6XTWK0sh2gbI_8_88aAgdBEALw_wcB

- ~~7つの習慣 ティーンズ~~
  - よい習慣とはなんであったかを考えるきっかけを自分の中に作り出し、牽いてはものにする(習慣化する)ことを目指して

### 生成ai

`https://news.yahoo.co.jp/articles/5678f1f8b17d6e4120fe559be1501c150d7dbe58?page=2%`

- **ChatGPT 120%質問術**
  - 意外と知ってた(1/15)
- **ChatGPT 120%活用術**
  - 意外と知ってた(1/15)
- **AI2041 人工知能が変える20年後の未来**
  - 大転職時代要チェック

- ~~Azure OpenAI Serviceではじめる ChatGPT/LLMシステム構築入門　技術評論社　20240206~~
  - Azureのopenaiは組織に属していないと(個人では)実践できないので中止
- **Google Vertex AIによるアプリケーション開発 20240120**
  - 一読し、Vertex aiを触り、cloud console上で動かすところまでやった。
- **LangChain完全入門 20231021**
  - 一読し、サンプルを実際にかいて動かすところまでやった。

### 新書／ベストセラー

- **行動経済学 室岡健志**
  - 5,6,7章まで読んだ

### 防災・生活・健康維持管理

tbd

### 小説・文学・歴史

- 地面師たち


## 時系列

`当たり前にできることを更新し続けることで、今の自分がある`

- 2024年1月
    - 目標設定: 本は心の栄養(読書候補,予算年間12万円／20冊程度)
    - 投資能力開発
      - 財務諸表分析について
      - 投資プロセス改善
      - EXPO
        - 前日決算短信チェック
        - day1
        - day2
      - 投資アイデア
      - 個別銘柄のファンダメンタル_株価と展望（ベースフード）
    - SRE活動(仕事むけ)
      - 商談内容から振り返る
      - SREワークブック
- 2024年2月
    - SRE活動 Next
        - Amazon Linux https://hub.docker.com/_/amazonlinux/ に移行する場合のマシンイメージ、インスタンスタイプとスペックの候補を考えておく（サンプルがあるか探しておく）
        - Datadogクエリ書き方GPTさんに聞く
        - k6の使い方実例調べて書いてみる
    - 職業能力開発 Next
        - データで話す組織
            - なぜこれを読みたいと思ったかを考えてみる
                - 「暗記する」戦略思考の復習に集中
                - 代わりの書籍を探す「クリティカルシンキング」、「論点を研ぐ」
- 2024年3月
  - SRE
    - 書籍: オブザーバビリティエンジニアリング
        - 目次チェック
    - SLOベースアラートとエラーバジェット
        - 役立つとみなされるアラートの基準
        - 緊急のユーザーインパクトを反映している
        - アクション可能
        - 新規性があること
        - 暗黙のアクションではなく調査を必要とすること
        - SLOベースのアラート v.s 非SLOベースのアラート
        - SLOベースのアラート
            - バーン予想アラート
                - エラーバジェットが枯渇する前にアラートを出す
                - エラーバジェットとは、許容できるシステム停止の最大数
                    - 例えばリクエスト成功率のSLOが99.9%の場合
                        - Requests = 良いイベント（成功 + と悪いイベント（エラー）
                        - ErrorBudgets = 許容できるエラー数の最大(エラーバジェット) = 1 - 0.999 = REQUESTS * 0.001
            - 可用性の目標
            - １ヶ月のシステムが利用できない時間が４３分５０秒
            - 重要な単位
            - ベースライン
            - ルックアヘッドウィンドウ
                - 予測する期間の幅のこと？
            - バーンアラートの種類
            - 短期間バーンアラート
        - 非SLOベースのアラート
            - 既知の未知（事象はわかっており、いつ起きたかだけが問題）
        - TODO: 役立つとみなされるアラートを具体的に
        - TODO: バーンアラートの種類と特徴を追加学習する
        - TODO: リクエスト成功率以外のSLOとエラー数の許容値のイメージをつかむ
        - TODO: 既知の未知（事象はわかっており、いつ起きたかだけが問題）
        - TODO: 非SLOベースのアラートの使いどころ

    - LLM4SRE
        - LLM for SRE“の世界探索 を読む https://github.com/Eigo-Mt-Fuji/portfolio-2024/blob/main/docs/2024%E5%B9%B43%E6%9C%8822%E6%97%A5_SRE%E6%B4%BB%E5%8B%95_LLM4SRE.md
        - クラウド上に展開されるシステムに発生する障害診断をLLMにより自動化するアプローチ
            - ローカルのシステムが保持するデータ（過去のインシデント、テレメトリなど）をLLMのプロンプトに注入する
            - LLM技術
                - Few-Shot
                - Instruction Tuning
                - RAG
                - LLMエージェント
            - タスク
                - 障害の要約テキストの生成
                - 関連する複数のインシデントの要約テキストの生成
                - 根本原因と緩和策の予測
                - 根本原因の予測
                - 根本原因カテゴリの予測
                - 予測された根本原因の信頼性スコアの計算
                - 症状、根本原因、緩和策を含む診断レポートの生成
                - 緩和計画の生成
                - 障害の修復のためのコード生成
                - テレメトリデータ分析用ドメイン固有言語の生成
            - ドメイン固有データとツール
                - インシデントの履歴
                - タイトル
                - 要約（サマリー）
                - 詳細
                    - ディスカッション履歴
                    - その他のインシデントに紐づくメタデータ
                    - クエリ履歴
                    - Runbook相当の文書
                - アラート’トポロジー（≒ アラートおよびアラートが発生したリソースを含むマップ情報）
                - テレメトリ（ ログ・メトリクス（Golden Signal）などシステムの状態を表すデータ）
                - その他
                    - 非構造化データ（ログ/コード）
                    - データベース製品文書、pg_stat_statements、
                    - Auroraのwaitイベント文書と250のDBメトリクス
            - 対象システム
                - クラウド / アプリケーション
                - メールサービス
                - マイクロサービス
                - ネットワーク
                - データベース

    - Opentelemetry理解度向上
  - 生成AI
    - 生成AIとAWSでなんかやりたいを具体化
    - 生成AI_Langchainを使って学びたいこと整理
    - 生成AI_Langchain学習続き_ToolkitとTools
    - 生成AI_LangChain_AgentType学習
- 2024年4月
    - 暗記する戦略思考とわたし
      - https://github.com/Eigo-Mt-Fuji/portfolio-2024/blob/main/docs/%E8%81%B7%E8%83%BD%E9%96%8B%E7%99%BA/2024%E5%B9%B44%E6%9C%8816%E6%97%A5_%E6%9A%97%E8%A8%98%E3%81%99%E3%82%8B%E6%88%A6%E7%95%A5%E6%80%9D%E8%80%83%E3%81%A8%E3%82%8F%E3%81%9F%E3%81%97.md
- 2024年5月
    - 論点思考とわたし
      - https://github.com/Eigo-Mt-Fuji/portfolio-2024/blob/main/docs/%E8%81%B7%E8%83%BD%E9%96%8B%E7%99%BA/2024%E5%B9%B45%E6%9C%8827%E6%97%A5_%E8%AB%96%E7%82%B9%E6%80%9D%E8%80%83%E3%81%A8%E3%82%8F%E3%81%9F%E3%81%97.md
- 2024年6月
    - 能力開発活動振り返り
      - 読書支援と論点とわたし
      - 能力開発活動を振り返る
      - AIとエンジニアとSREとを考える
- 2024年7月
    - AWS認定資格受験に向けた取り組み
        - AWS認定資格(プロ) 300usd
          - https://aws.amazon.com/jp/certification/certified-solutions-architect-professional/
        - AWS AIプラクティショナ 100usd
          - https://aws.amazon.com/jp/certification/certified-ai-practitioner/
        - AWS Certified Machine Learning Engineer - Associate 100usd
          - https://aws.amazon.com/jp/certification/certified-machine-learning-engineer-associate/
    - 読書継続。自己変革とさらなる豊かさを求めて(取り急ぎ、優先順位と読み方を考える。さて何をすべきか)
        - ソフトウェアアーキテクチャハードパーツ 2022
        - 効率的なgo 2024
        - SLO サービスレベル目標 2023
        - 大規模データ管理 2024
        - 生成AIについて、書籍が増えてた印象だった。どんな本が増えてるのかチェックして、読むべきものがないか探ってみる。

## 備考

- 決めたことはやる

