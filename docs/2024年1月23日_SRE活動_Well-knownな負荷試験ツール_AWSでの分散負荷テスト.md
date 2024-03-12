# 2024年1月23日_SRE活動

## 時間

1/23 16:00-18:00(2h)
1/24 18:00-19:48(1h48m)

## やること

- AWS Fargate  ECR ぼんやりしてる用語をおさらい
- AWS での分散負荷テスト
- Well-knownな負荷試験ツール2つ

## 備忘録

- AWS Fargate  ECR おさらい
  - プライベートレジストリ
    - プライベートレジストリ認証 https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/userguide/private-auth.html
        - コンテナの定義内で、作成したシークレットの詳細 で repositoryCredentials オブジェクトを指定
            - ECS シークレットで必須の IAM アクセス許可
            - プライベートレジストリの認証で必須の IAM アクセス許可
    - Fargate でホストされているタスクの場合、この機能にはプラットフォームバージョン 1.2.0 以降が必要

  - パブリックレジストリ https://docs.aws.amazon.com/ja_jp/AmazonECR/latest/public/public-registries.html
    - use your public registry to manage public image repositories consisting of Docker and Open Container Initiative (OCI) images
    - 各AWSアカウントにはデフォルトパブリックレジストリがセットで提供されている
    - パブリックレジストリのコンセプト https://docs.aws.amazon.com/ja_jp/AmazonECR/latest/public/public-registries.html#public-registry-concepts
    - Amazon ECR Public Gallery https://gallery.ecr.aws
      - local
        - codebuild/local-builds
        - aws-stepfunctions/amazon/aws-stepfunctions-local
        - aws-dynamodb-local/aws-dynamodb-local
        - ecs-local/amazon-ecs-local-container-endpoints
      - aws-solutions
      - ecs,eks,sam
      - aws-cli
      - など

  - プライベートリポジトリ
    - リポジトリは、 ユーザーアクセスポリシーと個々のリポジトリポリシーによって制御できます
    - プライベートリポジトリポリシー - https://docs.aws.amazon.com/ja_jp/AmazonECR/latest/userguide/repository-policies.html

  - プルスルーキャッシュルール https://docs.aws.amazon.com/ja_jp/AmazonECR/latest/userguide/pull-through-cache.html
    - プルスルーキャッシュルールを使用すると、アップストリームレジストリの内容を Amazon ECR プライベートレジストリ
      - アップストリームレジストリとは、つまり、DockerHubなど、パブリックなものを含めた、コンテナイメージをサーブするコンテナレジストリのこと
        - 具体的には、Docker Hub、Microsoft Azure コンテナレジストリ、GitHub コンテナレジストリ (認証が必要), Amazon ECR パブリック、Kubernetes コンテナイメージレジストリ、Quay (認証は不要)
      - なぜアップストリームなのかというと、ECRから見て上流にあるから。
        - ECRは、コンテナイメージを使用するクライアント と DockerHubなど、パブリックなレジストリの間に介在し、中間キャッシュ機能付きのレジストリサービスを提供する
          - この時の設定がプルスルーキャッシュルール
      - 認証が必要なアップストリームレジストリでは、認証情報を AWS Secrets Manager シークレットに保存する必要があります
      - AWS Lambda では、プルスルーキャッシュルールを使用した Amazon ECR からのコンテナイメージのプルはサポートされていません

    - 社内の開発者向けにコンテナリポジトリを提供する場合や、企業内セキュリティポリシーによって、インターネット上のパブリックなコンテナリポジトリの利用を制限されている場合など

  - awslogs ログドライバー
    - タスク定義で awslogs ログドライバーの使用を開始する
      - タスクで Fargate 起動タイプを使用すると、コンテナからログを表示できます
        - CloudWatch Logs にコンテナログを送信
      - EC2 起動タイプを使用すると、コンテナからの異なるログを 1 か所で便利に表示できます
        - コンテナインスタンスのディスク容量をコンテナログが占有してしまうことも防止
    - タスクのコンテナによってログ記録される情報のタイプ
      - ENTRYPOINT コマンドによって大きく異なる
        - デフォルト
          - キャプチャされるログには、コンテナをローカルに実行した場合に通常はインタラクティブターミナルに表示されるコマンド出力 (STDOUT および STDERR I/O ストリーム) が表示されます

  - Amazon ECR FIPS サービス
    - FIPS 準拠のエンドポイント (FIPS エンドポイント) 
      - コマンドラインインターフェイス (CLI) を使用して、あるいは API を使用してプログラムにより AWS 米国東部/西部、AWS GovCloud (米国)、AWS カナダ (中部) にアクセスする際に FIPS 140-2 検証済み暗号化モジュールが必要な場合にお世話になるAPIエンドポイント
      - https://aws.amazon.com/jp/compliance/fips/
    - 連邦情報処理標準（FIPS）とは - https://e-words.jp/w/FIPS.html
      
- AWS での分散負荷テスト - https://aws.amazon.com/jp/solutions/implementations/distributed-load-testing-on-aws/
  - 大規模な負荷時のソフトウェアアプリケーションテストを自動化して、潜在的な性能上の問題をより容易に特定する
    - aws-solutions/distributed-load-testing-on-aws-load-tester
  - 一定のペースでトランザクションレコードを生成する数多くの接続ユーザーを作成およびシミュレート
  - サーバーをプロビジョニングする必要はありません
  - 複数の AWS リージョンにまたがってテストを実行することができます
  - メリット
    - AWS Fargate コンテナで独立した Amazon ECS を使用して、ソフトウェアの負荷機能をテスト
    - 指定日または定期日に負荷テストが自動的に開始されるようにスケジュールを組みます
    - カスタム JMeter スクリプトを作成して、アプリケーションのテストをカスタマイズします
    - ソリューションのウェブコンソールには、実行中のテストのライブデータを表示するためのオプションが含まれます
  - ソリューションの実装ガイドと、付属の AWS CloudFormation テンプレートを使用して自動的にデプロイ
    - ステップ 1 Amazon API Gateway API を使用して、ソリューションのマイクロサービス (AWS Lambda 関数) を呼び出します。
    - ステップ 2 マイクロサービスでは、テストデータを管理しテストを実行するためのビジネスロジックを提供しています。
    - ステップ 3 これらのマイクロサービスは、Amazon Simple Storage Service (Amazon S3)、Amazon DynamoDB、AWS Step Functions と連動し、テストシナリオを実行して、そのテストシナリオの詳細とテストシナリオを実行するためのストレージを提供します。
    - ステップ 4 Amazon Virtual Private Cloud (Amazon VPC) のネットワークトポロジには、AWS Fargate で実行中のソリューションの Amazon Elastic Container Service (Amazon ECS) コンテナが含まれています。
    - ステップ 5 このコンテナには、アプリケーションのパフォーマンステスト用の負荷を生成する Taurus 負荷テスト Open Container Initiative (OCI) に準拠しているコンテナイメージが含まれています。Taurus はオープンソースのテスト自動化フレームワークです。コンテナイメージは、Amazon Elastic Container Registry (Amazon ECR) のパブリックリポジトリで AWS によってホストされています。
    - ステップ 6 AWS Amplify によるウェブコンソールは、静的ウェブホスティング用に設定した Amazon S3 バケットにデプロイされます。
    - ステップ 7 Amazon CloudFront はソリューションのウェブサイトバケットのコンテンツに対して、セキュアなパブリックアクセスを提供します。
    - ステップ 8 ソリューションは初期設定時にデフォルトのソリューション管理者ロールを作成し、顧客が指定したユーザーの E メールアドレスにアクセス招待を送信します。
    - ステップ 9 Amazon Cognito ユーザープールは、コンソールと Amazon API Gateway API へのユーザーアクセスを管理します。
    - ステップ 10 ソリューションをデプロイした後、ウェブコンソールを使って、一連のタスクを定義するテストシナリオを作成できます。
    - ステップ 11 マイクロサービスはこのテストシナリオを使用して、指定された AWS リージョンで AWS Fargate タスク上で Amazon ECS を実行します。
    - ステップ 12 結果を Amazon S3 と DynamoDB に保存するだけでなく、テストが完了すると、出力が Amazon CloudWatch にログ記録されます。
    - ステップ 13 ライブデータオプションを選択すると、ソリューションでは、テストが実行された各リージョンについて、テスト中に AWS Fargate タスクの Amazon CloudWatch ログが Lambda 関数に送信されます。
    - ステップ 14 Lambda 関数は、主要なスタックがデプロイされたリージョンで、AWS IoT Core の対応するトピックにデータを発行します。ウェブコンソールはそのトピックを購読し、ウェブコンソールでテスト実行中にデータを確認することができます。
- Well-knownな負荷試験ツール2つ
  - BlazeMeter/Taurus 
    - Codename: Taurus Automation-friendly framework for Continuous Testing
    - BlazeMeterはもともとロード、機能、回帰テストなど、さまざまな種類のソフトウェア開発テストを実行するように設計されたオープンソースのJavaアプリケーションであるApache JMeterの周りに構築された
    - その後、他のオープンソースのテストツールをサポートするために拡張されました
    - BlazeMeterはオンデマンドのSaaSベースのパフォーマンステストソリューションであり、パブリックまたはプライベートな場所を含むどこからでもテストできます
      - 開発者が優先エディタでテストを作成する機能 (YAML または JSON 構文を使用)
      - 他のツールを開かずにコードと並んでテストを作成/変更する
      - マウスをクリックしてAPI機能テストを行い、コーディングは不要
      - クラウドまたはオンプレミスでの API テスト
      - 簡単な YAML または JSON 構文を使用して、テストを作成するか、既存のオープン ソース スクリプトをお気に入りのエディタで利用します。
      - モバイルおよび Web アプリケーションをサポート
      - 優先バージョン管理リポジトリでのテストの管理による変更の追跡
    - BlazeMeterはChrome拡張機能を使用(ブレイズメータークロームの拡張機能)
      - ユーザーは、Chrome拡張機能のレコード機能を利用するためにBlazeMeterアカウントを持っている必要がありますが、有料アカウントである必要はありません
      - JMeter スクリプトを記録するには
        - 欠点の1つは、JavaScriptを実行できないこと
    - サンプル
      - https://github.com/Blazemeter/taurus/tree/master/examples/docker

  - LoadView 
    - LoadViewはオンデマンドのパフォーマンステストプラットフォーム
    - Webページ、アプリケーション、およびWebサービシーにストレスを与え、ロードテストすることができます
    - 使いやすく、ユーザーは簡単かつ迅速に、数分以内に負荷/ストレス テストを構成できます。 さまざまな機能、15 の地理的位置、および複数の負荷曲線オプションを備えた LoadView を使用すると、実際のブラウザー ベースのロード テストを実行して実際のパフォーマンスを確認できます
    - LoadView曰く
      - BlazeMeter をロード テスト オプションとして確認する際に、考慮すべき点はたくさんあります。専門知識、知識、ニーズのレベルによっては、急な学習曲線が必要になる場合があります。
