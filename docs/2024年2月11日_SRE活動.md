# 2024年2月11日_SRE活動

## 時間

- 2/11 13:40:13:45(5m)
- 2/11 14:45:19:21(4h36m)

## やること

- ECSの属性復習

- EC2の属性復習
    - Ubuntu distributionの最新、Amazon Linux distributionの最新バージョン・１つ前の世代を確認
    - Ubuntu distributionの最新、Amazon Linux distributionの違いを確認
    - Ubuntu distributionの最新、Amazon Linux distributionの公式ドキュメントを確認

- 負荷試験 K6ツール学ぶぞ

- Datadogクエリの書き方学ぶぞ

## 備忘録

- 負荷試験 k6ツール学ぶぞ
  - オープンソースで提供されている負荷試験ツールで、負荷試験のシナリオをJavaScriptで記述できる
    - ブラウザの操作を記録してテストスクリプトを出力できる
    - OpenAPI（Swagger）の仕様に基づいて記述されたAPI定義ファイルからテストスクリプトを出力することができる
  - 何を押さえればいい?
    - Does not run in NodeJS
      - tool itself is written in Go, embedding a JavaScript runtime allowing for easy test scripting.
    - Make HTTP Requests https://grafana.com/docs/k6/latest/using-k6/http-requests/

```
import http from 'k6/http';

export default function () {
  const url = 'http://test.k6.io/login';
  const payload = JSON.stringify({
    email: 'aaa',
    password: 'bbb',
  });

  const params = {
    headers: {
      'Content-Type': 'application/json',
    },
  };

  http.post(url, payload, params);
}
```

    - Test lifecycle https://grafana.com/docs/k6/latest/using-k6/test-lifecycle/
      - init
      - setup
      - teardown
    - Environment variables https://grafana.com/docs/k6/latest/using-k6/environment-variables/
  - Running k6 https://k6.io/docs/get-started/running-k6/
    - 仮想ユーザー（VU）という概念
      - $ k6 run --vus 10 --duration 30s script.js

  - default metrics https://grafana.com/docs/k6/latest/using-k6/metrics/reference/
  - javascript api
    - https://grafana.com/docs/k6/latest/javascript-api/k6-http/batch/
  - datadog integration
    - k6
      - https://docs.datadoghq.com/ja/integrations/k6/
        - k6 テストのパフォーマンスメトリクスを追跡
        - アプリケーションの性能と負荷試験メトリクスを関連付け
        - 性能試験メトリクスに基づきアラートを作成
        - k6 Datadog ダッシュボードやメトリクスエクスプローラーを使用して、k6 メトリクスを分析および視覚化

  - Datadog Agent サービスを Docker コンテナとして実行

```sh
DOCKER_CONTENT_TRUST=1 \
docker run -d \
    --name datadog \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    -v /proc/:/host/proc/:ro \
    -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro \
    -e DD_SITE="datadoghq.com" \
    -e DD_API_KEY=<YOUR_DATADOG_API_KEY> \
    -e DD_DOGSTATSD_NON_LOCAL_TRAFFIC=1 \
    -p 8125:8125/udp \
    datadog/agent:latest
```

- Datadog Agent サービスを実行したら、k6 試験を実行(メトリクスを Agent に送信)
  - 試験を実行中に k6 はメトリクスを定期的に DataDog 送信します。デフォルトでは、これらのメトリクスには名前のプレフィックスとして k6.が含まれます。

```sh
K6_STATSD_ENABLE_TAGS=true k6 run --out statsd script.js
```

```
k6.data_sent(count)	The amount of data sent Shown as byte
k6.data_received(count)	The amount of received data Shown as byte
k6.http_req_blocked.avg(gauge)	Average time spent blocked before initiating the request Shown as millisecond
k6.http_req_blocked.max(gauge)	Max time spent blocked before initiating the request Shown as millisecond
k6.http_req_blocked.median(gauge)	Median time spent blocked before initiating the request Shown as millisecond
k6.http_req_blocked.95percentile(gauge)	95th time spent blocked before initiating the request Shown as millisecond
k6.http_req_blocked.99percentile(gauge)	99th time spent blocked before initiating the request Shown as millisecond
k6.http_req_blocked.count(rate)	The number of httpreqblocked values submitted during the interval Shown as unit
k6.http_req_connecting.avg(gauge)	Average time spent establishing TCP connection Shown as millisecond
k6.http_req_connecting.max(gauge)	Max time spent establishing TCP connection Shown as millisecond
k6.http_req_connecting.median(gauge)	Median time spent establishing TCP connection Shown as millisecond
k6.http_req_connecting.95percentile(gauge)	95th time spent blocked before initiating the request Shown as millisecond
k6.http_req_connecting.99percentile(gauge)	99th time spent blocked before initiating the request Shown as millisecond
k6.http_req_connecting.count(rate)	The number of httpreqconnecting values submitted during the interval Shown as unit
k6.http_req_duration.avg(gauge)	Average request time Shown as millisecond
k6.http_req_duration.max(gauge)	Max request time Shown as millisecond
k6.http_req_duration.median(gauge)	Median request time Shown as millisecond
k6.http_req_duration.95percentile(gauge)	95th request time Shown as millisecond
k6.http_req_duration.99percentile(gauge)	99th request time Shown as millisecond
k6.http_req_duration.count(rate)	The number of httpreqduration values submitted during the interval Shown as unit
k6.http_reqs(count)	Total number of HTTP requests Shown as request
k6.http_req_receiving.avg(gauge)	Average time spent receiving response data Shown as millisecond
k6.http_req_receiving.max(gauge)	Max time spent receiving response data Shown as millisecond
k6.http_req_receiving.median(gauge)	Median time spent receiving response data Shown as millisecond
k6.http_req_receiving.95percentile(gauge)	95th time spent receiving response data Shown as millisecond
k6.http_req_receiving.99percentile(gauge)	99th time spent receiving response data Shown as millisecond
k6.http_req_receiving.count(rate)	The number of httpreqreceiving values submitted during the interval Shown as unit
k6.http_req_sending.avg(gauge)	Average time spent sending data Shown as millisecond
k6.http_req_sending.max(gauge)	Max time spent sending data Shown as millisecond
k6.http_req_sending.median(gauge)	Median time spent sending data Shown as millisecond
k6.http_req_sending.95percentile(gauge)	95th time spent sending data Shown as millisecond
k6.http_req_sending.99percentile(gauge)	99th time spent sending data Shown as millisecond
k6.http_req_sending.count(rate)	The number of httpreqsending values submitted during the interval Shown as unit
k6.http_req_tls_handshaking.avg(gauge)	Average time spent handshaking TLS session Shown as millisecond
k6.http_req_tls_handshaking.max(gauge)	Max time spent handshaking TLS session Shown as millisecond
k6.http_req_tls_handshaking.median(gauge)	Median time spent handshaking TLS session Shown as millisecond
k6.http_req_tls_handshaking.95percentile(gauge)	95th time spent handshaking TLS session Shown as millisecond
k6.http_req_tls_handshaking.99percentile(gauge)	99th time spent handshaking TLS session Shown as millisecond
k6.http_req_tls_handshaking.count(rate)	The number of httpreqtls_handshaking values submitted during the interval Shown as unit
k6.http_req_waiting.avg(gauge)	Average time spent waiting for response (TTFB) Shown as millisecond
k6.http_req_waiting.max(gauge)	Max time spent waiting for response (TTFB) Shown as millisecond
k6.http_req_waiting.median(gauge)	Median time spent waiting for response (TTFB) Shown as millisecond
k6.http_req_waiting.95percentile(gauge)	95th time spent waiting for response (TTFB) Shown as millisecond
k6.http_req_waiting.99percentile(gauge)	99th time spent waiting for response (TTFB) Shown as millisecond
k6.http_req_waiting.count(rate)	The number of httpreqwaiting values submitted during the interval Shown as unit
k6.iteration_duration.avg(gauge)	Average time spent for a VU iteration Shown as millisecond
k6.iteration_duration.max(gauge)	Max time spent for a VU iteration Shown as millisecond
k6.iteration_duration.median(gauge)	Median time spent for a VU iteration Shown as millisecond
k6.iteration_duration.95percentile(gauge)	95th time spent for a VU iteration Shown as millisecond
k6.iteration_duration.99percentile(gauge)	99th time spent for a VU iteration Shown as millisecond
k6.iteration_duration.count(rate)	The number of iteration_duration values submitted during the intervalShown as unit
k6.iterations(count)	Aggregated number of VU iterationsShown as unit
k6.vus(gauge)	Current number of active virtual users Shown as user
k6.vus_max(gauge)
```
- EC2の属性復習
    - Ubuntu distributionの最新、Amazon Linux distributionの最新バージョン・１つ前の世代を確認
      - Ubuntu 22.04.3 LTS
        - EOL: April 2032
        - EOSS: June 2027
      - Ubuntu 24.04 LTS(feature freeze)
        - 2月末のFeature Freezeに向けて、いろいろな新機能のプロトタイプが投入される時期
    - Amazon Linux https://hub.docker.com/_/amazonlinux/
      - Amazon Linux 2023.3.20240131.0
        - https://docs.aws.amazon.com/ja_jp/linux/al2023/release-notes/relnotes-2023.3.20240131.html
          - AL2023 is the next generation of Amazon Linux
          - 512 MB が最小要件 https://docs.aws.amazon.com/ja_jp/linux/al2023/ug/system-requirements.html
          - AL2023 には 32 ビットユーザースペースパッケージは含まれなくなりました。64 ビットコードへの移行を完了する必要がある
          - AL2023 で 32 ビットバイナリを実行する必要がある場合は、AL2023 上で動作する AL2 コンテナ内の AL2 の 32 ビットユーザースペースを使用できます
          - https://docs.aws.amazon.com/ja_jp/linux/al2023/ug/compare-with-al2.html#package-manager
        - 32 ビットユーザースペースバイナリの実行
    - Ubuntu distributionの最新、Amazon Linux distributionの公式ドキュメントを確認
      - Ubuntu
        - https://help.ubuntu.com/
        - https://ubuntu.com/server/docs/tutorials
      - Amazon Linux
        - https://docs.aws.amazon.com/ja_jp/linux/      
- ECSの属性復習
  - タスクセット
    - 単一の ECS サービス内でアプリケーションのリビジョン管理を制御可能にする新しいプリミティブ
      - 新しい API で、アプリケーションの複数のリビジョンと、あるリビジョンから他のリビジョンへの移行を管理できるようになりました
      - タスクセットを利用してできること
        - アプリケーションの複数のリビジョンを単一のサービス範囲内で設定可能
        - アプリケーションの新しいバージョンをデプロイする場合
            - 独自のタスク定義を持つ既存のサービス内で、新しいタスクセットを作成
            - 個々のタスクセットは、サービスで必要なタスク全体を特定の割合で実行するよう、スケールパラメータを提供
        - サービス
          - タスク定義
          - アプリケーションのリビジョンごとのタスクセット
            - タスクセットのスケールパラメータに応じた割合だけタスクを実行(サービスで必要なタスク全体のうち、タスクセット)
         
      - サービスの新しいバージョンをデプロイする場合、現行の運用ワークロードを完全に変更する前に、すべてスムーズに機能するよう段階的なデプロイ手順を踏むのが一般的
        - 以前は
            - ECS 上でアプリケーションの新しいリビジョンを完全に管理するために
            - 新しい ECS サービスを立ち上げて
            - サービスから他のサービスへとトラフィックを移行する必要がありました
    
  - クラスタとキャパシティプロバイダ戦略 https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/clusters.html
    - キャパシティープロバイダー戦略は、1 つ以上のキャパシティープロバイダーで構成されます
        - クラスターの複数のキャパシティープロバイダー間にタスクを分散する方法を決定
        - キャパシティプロバイダー戦略は、クラスター、サービス、またはタスクの構成の一部
        - 再利用可能なキャパシティプロバイダー戦略を作成することはできません
        - キャパシティープロバイダーによってキャパシティーが管理されているクラスター内のタスクに、キャパシティープロバイダー戦略の代わりに起動タイプを設定すると
            - それらのタスクはキャパシティープロバイダーのスケーリングアクションにはカウントされません
        - キャパシティプロバイダー戦略を指定する場合、指定できるキャパシティプロバイダーの数は 6 に制限されます。
    - オプションでベース値とウェイト値を指定して、より細かく制御できます
        - オプションのベース値は、指定されたキャパシティプロバイダーで実行されるタスクの最小限の数を指定
        - キャパシティプロバイダー戦略では、1 つのキャパシティプロバイダーのみが定義されたベース値を持つことができます
        - ウェイト値は、指定したキャパシティプロバイダーを使用する起動済みタスクの総数に対する相対的な割合を決定
        - 2 つのキャパシティプロバイダーを含む戦略
            - 例1) 両方の重みが 1 である場合
            - ベースの割合が達すると、タスクは 2 つのキャパシティプロバイダー間で均等に分割されます
            - 例2) 一方(capacityProviderA) に 1 の重み(weight)を指定し、もう一方(capacityProviderB) に 4 の重み(weight)を指定した場合
            - ベースの割合が達すると、タスクは 2 つのキャパシティプロバイダー間で均等に分割されるのではなく、capacityProviderA を使うタスクが 1 つ実行されるごとに、capacityProviderB を使うタスクが 4 つ実行されることになります
        - weightのデフォルト値
            - コンソールでキャパシティプロバイダーに weight 値が指定されていない場合、1 のデフォルト値
            - API または AWS CLI を使用する場合は、0 のデフォルト値
        - 複数のキャパシティプロバイダーを指定する場合は少なくとも 1 つのキャパシティプロバイダーのウェイト値が 0 より大きい必要があります
            - 戦略に複数のキャパシティプロバイダーを指定し、すべて同じウェイトを 0 にした場合、キャパシティプロバイダー戦略を使用する RunTask または CreateService のアクションは失敗
            - ウェイトが 0 のキャパシティプロバイダーはタスクの配置に使用されません
    - キャパシティプロバイダー戦略に Auto Scaling グループプロバイダ または Fargate キャパシティプロバイダーの 両方を含めることはできません
        - Auto Scaling グループプロバイダ または Fargate キャパシティプロバイダー いずれか片方のみを含めることができる

  - タスク定義
    - タスク定義とは、ECSクラスタ内で、実行するコンテナをグループ化するための単位(設定項目)
      - タスク定義を用いて、共通の目的で使用されるコンテナをまとめてグループ化する
      - 異なるコンポーネントは、複数の個別なタスク定義に分割
         - 3 つのコンテナインスタンスにより、3 つのフロントエンドサービスコンテナ、2 つのバックエンドサービスコンテナ、さらに 1 つのデータストアサービスコンテナを実行
           - https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/launch_types.html
    - ネットワークモード
      - awsvpc ネットワークモードを使用するタスク定義の場合はネットワーク設定が必要

  - サービス
    - 定義からサービスを作成
        - タスク定義とサービスの関係
            - タスク定義を作成したら、それらの定義からサービスを作成
    - 定義からサービスを作成
    - コンテナを Elastic Load Balancing ロードバランサーに関連付けることができます
    - タスクに新しいバージョンのコンテナをデプロイすることも可能(サービスを更新)
    - タスクの必要数を増減できます
    - Auto Scaling グループキャパシティプロバイダーを使用するサービスは、Fargate キャパシティプロバイダーを使用するように更新することはできません。逆の場合も同様です。
    - 起動タイプを指定できます
      - Fargate 起動タイプ
        - 次のワークロードに適しています
          - 運用上で低いオーバーヘッドを必要とする大規模なワークロード
          - 時折バーストが発生する小さなワークロード
          - 小さなワークロード
          - バッチワークロード
     - EC2 起動タイプ
       - 料金を最適化する必要がある大規模なワークロードに適しています
         - ウェブページに情報を表示するフロントエンドサービス
         - フロントエンドサービスに API を提供するバックエンドサービス
         - データストア
    - デフォルトのタスク配置戦略は、アベイラビリティーゾーン間でタスクを均等に分散
    - デフォルトではクラスター VPC のサブネットでサービスが開始されます
    - クラスターにデフォルトのキャパシティープロバイダー戦略が定義されておらず、クラスターにキャパシティープロバイダーが追加されていない場合は、Fargate起動タイプが選択されます。
    - デプロイの失敗が検出された場合のデフォルトのオプション https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/deployment-circuit-breaker.html
      - [Amazon ECS デプロイサーキットブレーカー] オプション
        - タスクが定常状態に到達したかどうかを判断する、ローリング更新メカニズム
        - デプロイが失敗した場合に、 COMPLETED 状態のデプロイに自動的にロールバックするオプションがあります
      - [失敗時のロールバック] オプションを使用
    - サービスを作成するとき
      - クラスターのデフォルトのキャパシティプロバイダー戦略か、クラスターのデフォルト戦略をオーバーライドするキャパシティプロバイダー戦略のいずれかを使用
      - サービスで起動タイプではなくキャパシティプロバイダー戦略をする

  - スタンドアロンタスク
    - スタンドアロンタスクは RunTaskまたは StartTask APIsで実行されるタスクの通称
      - 何らかの作業を実行してから停止するバッチジョブなどの 1 回限りのプロセスに適しています
      - 通常、長時間実行されるアプリケーションには使用されません
      - タスク定義リビジョン
        - タスク定義ファミリーを選択して、そのファミリーのリビジョンを表示
      - （オプション) コンピューティング設定 (アドバンスト）
        - タスクの分散方法を選択
          - キャパシティープロバイダー戦略または起動タイプ のいずれかを使用できます
            - キャパシティープロバイダー戦略を使用するケース
              - クラスターレベルでキャパシティープロバイダーを設定する必要があります
            - 起動タイプを使用するケース
              - キャパシティープロバイダーを使用するようにクラスターを設定していない場合
      - Application type(アプリケーションの種類)
        - Task(タスク)
      - [Desired tasks] (必要なタスク) 
        - 起動するタスクの数
      - [Networking] (ネットワーク)カスタム設定
      - [Task Placement] (タスクの配置)  https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/task-placement.html
        - コンテナインスタンス
        - タスク定義の CPU、GPU、メモリ、およびポートの要件
        - タスク配置の制約 https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/task-placement-constraints.html
        - タスク配置戦略 https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/task-placement-strategies.html
          - 設定項目
            - 戦略タイプ
              - binpack: タスクはコンテナインスタンスに配置され、未使用の CPU またはメモリを最小にします。
                - この戦略は、使用中のコンテナインスタンスの数を最小限に抑えます。
                - この戦略が使用されてスケールインアクションが実行されると、Amazon ECS はタスクを終了します。
                  - タスクが終了した後にコンテナインスタンスに残されたリソース量に基づいてこれが実行されます。
                  - タスクの終了後に利用可能なリソースが最も多く残るコンテナインスタンスが、そのタスクを終了されます。
              - random: タスクはランダムに配置されます。
              - spread: タスクは指定された値に基づいて均等に配置されます
                - 有効な値
                  - instanceId (または同じ効果を持つ host)
                  - attribute:ecs.availability-zone などのコンテナインスタンスに適用される任意のプラットフォームまたはカスタム属性
            - タスクグループ https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/task-groups.html
              - スタンドアロンタスクは、同じタスクグループからのタスクに基づいて分散されます(サービスタスクはそのサービスからのタスクに基づいて分散されます)
                - 一連の関連するタスクをタスクグループとして識別できます
                - spreadタスクの配置戦略の使用時に、セットとして見なされます
                - 例えば、データベースおよびウェブサーバーなど、1 つのクラスターで異なるアプリケーションを実行していることを想定します
              - デフォルトでは、スタンドアロンタスクはタスク定義ファミリ名 (例えば family:my-task-definition) をタスクグループ名として使用
              - タスクグループはタスク配置の制約にも使用できます https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/task-placement-constraints.html#constraint-examples
          - タスク配置戦略と制約は併用できます
            - タスク配置戦略とタスク配置制約を使用してできることの例（G2 インスタンスのみ）
                - アベイラビリティーゾーン間でタスクを分散
                - 各アベイラビリティーゾーン内のメモリに基づいてビンパックタスクを分散できます。

## まとめると

- ECSクラスタとその仲間たち

    - タスク定義（関連するコンテナのセット）
        - タスク定義とは、ECSクラスタ内で、実行するコンテナをグループ化するための単位(設定項目)
            - タスク定義を用いて、共通の目的で使用されるコンテナをまとめてグループ化する
                - 異なるコンポーネントは、複数の個別なタスク定義に分割
                    - https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/launch_types.html
            - クォータ - https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/service-quotas.html
                - タスク定義あたりのコンテナ数: 10
                - タスク定義サイズ: 64KB

    - サービス
        - タスク定義からサービスを作成
            - Elastic Load Balancing ロードバランサーに関連付ける https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/service-load-balancing.html
            - タスクに新しいバージョンのコンテナをデプロイすることも可能(サービスを更新)
            - タスクの必要数を増減
            - Auto Scaling グループキャパシティプロバイダーを使用するサービスは、Fargate キャパシティプロバイダーを使用するように更新することはできません。逆の場合も同様です。
            - キャパシティプロバイダ戦略 または 起動タイプ
                - Fargate 起動タイプ
                    - 次のワークロードに適しています
                    - 運用上で低いオーバーヘッドを必要とする大規模なワークロード
                    - 時折バーストが発生する小さなワークロード
                    - 小さなワークロード
                    - バッチワークロード
                - EC2 起動タイプ
                    - 料金を最適化する必要がある大規模なワークロードに適しています
                        - ウェブページに情報を表示するフロントエンドサービス
                        - フロントエンドサービスに API を提供するバックエンドサービス
                        - データストア
                    - タスク配置の制約 と タスク配置戦略 (EC2起動タイプの場合のみ) https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/task-placement.html
                        - https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/task-placement-constraints.html
                        - https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/task-placement-strategies.html
        - クォータ https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/service-quotas.html
            - ECS サービススケジューラによって、1 分あたりのサービスごとに Fargate でプロビジョニングできるタスクの最大数
            - サービスあたりのタスクの最大数 (必要な数) 5,000

    - タスクセット
        - タスクセット = 同一サービス・タスク定義内に作成されるアプリケーションのリビジョンに対応する単位

    - ブルー/グリーンデプロイタイプを使用する Fargate タスクを含む、Amazon ECS サービスを作成する方法
        - https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/create-blue-green.html

    - デプロイサーキットブレーカー https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/deployment-circuit-breaker.html

## 次のアクション

- Datadog クエリ書き方練習
  - というか読み方? それこそChatGPTに聞こう。
   - avg:system.load.1{*}
   - avg:container.cpu.user{*}

    - anomalies() 関数
      - 異常検知は、傾向や、季節的な曜日や時間帯のパターンを考慮しながらメトリクスの挙動が過去のものとは異なる期間を認識するアルゴリズム機能
      - しきい値ベースのアラート設定では監視することが困難な強い傾向や反復パターンを持つメトリクスに適しています
      - anomalies 関数は過去のデータを使用して今後の予想を立てる
        - 新しいメトリクスで使用するとあまり正確な結果が得られないことがあります
      - 異常検知(anomalies) 4時間平均

```
avg(last_4h):
anomalies(
    avg:container.cpu.user{*}, 
    'basic', 
    2,
    direction='both', 
    interval=60, 
    alert_window='last_15m', 
    count_default_zero='true'
) >= 1
```
```
{
	"name": "",
	"type": "query alert",
	"query": "avg(last_4h):anomalies(avg:container.cpu.user{*}, 'basic', 2, direction='both', interval=60, alert_window='last_15m', count_default_zero='true') >= 1",
	"message": "",
	"tags": [],
	"options": {
		"thresholds": {
			"critical": 1,
			"critical_recovery": 0
		},
		"notify_audit": false,
		"require_full_window": false,
		"notify_no_data": false,
		"no_data_timeframe": 10,
		"renotify_interval": 0,
		"threshold_windows": {
			"trigger_window": "last_15m",
			"recovery_window": "last_15m"
		},
		"include_tags": false
	}
}
```

- k6の実例を探してみる
  - 2000req/sec程度のapiの負荷試験用の攻撃サーバをどのように構成するか
    - 1台のマシンから攻撃することは可能か
    - 可能な場合VU(virtual user)と必要スペックはどの程度になるか
    - 複数マシンから攻撃する場合、k6のどの仕様を使えば効果的にテストできるか
      - executor?
        - https://k6.io/docs/using-k6/scenarios/executors/
          - Executors control how k6 schedules VUs and iterations. 
          - The executor that you choose 
            - depends on the goals of your test and the type of traffic you want to model.
          - Define the executor in executor key of the scenario object. The value is the executor name separated by hyphens.
            - The following table lists all k6 executors and links to their documentation.
                - Shared iterations
                - Per VU iterations
                - Constant VUs
                - Ramping VUs
                - Constant arrival rate
                - Ramping arrival rate
                - Externally controlled
    - 実行環境自体は提供されてるdocker imageを使えば良さそう
        - https://hub.docker.com/r/grafana/xk6/
    - 問題は、複数のサーバから実行する場合、かつ、それぞれの結合度が高い場合、どう連携とれるのか、ということ
  - extensionを見て学んでおく
    - extensions - https://k6.io/docs/extensions/get-started/explore/


- ChatGPTに Datadog queryの構文の初歩的な解説を頼む

  - あなたはDatadogを使用したシステムモニタリング設定のスペシャリストです。以下のMonitoring JSONで使用されているqueryの構文について、基礎的な仕様が理解できていない人向けに解説してください。

```
{
	"name": "",
	"type": "query alert",
	"query": "avg(last_4h):anomalies(avg:container.cpu.user{*}, 'basic', 2, direction='both', interval=60, alert_window='last_15m', count_default_zero='true') >= 1",
	"message": "",
	"tags": [],
	"options": {
		"thresholds": {
			"critical": 1,
			"critical_recovery": 0
		},
		"notify_audit": false,
		"require_full_window": false,
		"notify_no_data": false,
		"no_data_timeframe": 10,
		"renotify_interval": 0,
		"threshold_windows": {
			"trigger_window": "last_15m",
			"recovery_window": "last_15m"
		},
		"include_tags": false
	}
}
```

- Amazon Linux https://hub.docker.com/_/amazonlinux/ に移行する場合のマシンイメージ、インスタンスタイプとスペックの候補を考えておく（サンプルがあるか探しておく）
  - Amazon Linux 2023.3.20240131.0 - https://docs.aws.amazon.com/ja_jp/linux/al2023/release-notes/relnotes-2023.3.20240131.html
    - 512 MB が最小要件 https://docs.aws.amazon.com/ja_jp/linux/al2023/ug/system-requirements.html
        - AL2023 には 32 ビットユーザースペースパッケージは含まれなくなりました。64 ビットコードへの移行を完了する必要がある
        - AL2023 で 32 ビットバイナリを実行する必要がある場合は、AL2023 上で動作する AL2 コンテナ内の AL2 の 32 ビットユーザースペースを使用できます
          - https://docs.aws.amazon.com/ja_jp/linux/al2023/ug/compare-with-al2.html#package-manager
- Ubuntu distributionの最新(Ubuntu 22.04.3 LTS)を使う場合の、マシンイメージを探しておく
