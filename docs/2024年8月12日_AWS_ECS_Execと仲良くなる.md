# AWS_ECS_Execと仲良くなる

## 時間

- 8/12 12:45-13:53(1h8m)

## やること

- ECS Execの読解
  - https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/ecs-exec.html

## 備忘録

### アーキテクチャ

- ECS Exec は、AWS Systems Manager (SSM) セッションマネージャーを使用して実行中のコンテナとの接続を確立し、AWS Identity and Access Management (IAM) ポリシーを使用して実行中のコンテナで実行中のコマンドへのアクセスを制御

### 要件
- IAMアクセス許可要件
- バージョン要件
- ファイルアクセス要件
- ネットワーク要件

```
  IAMアクセス許可要件
    https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-iam-roles.html#ecs-exec-required-iam-permissions
      {
        "Effect": "Allow",
        "Action": [
            "ssmmessages:CreateControlChannel",
            "ssmmessages:CreateDataChannel",
            "ssmmessages:OpenControlChannel",
            "ssmmessages:OpenDataChannel"
        ],
        "Resource": "*"
      }
  バージョン要件
    EC2
      AMI
        2021 年 1 月 20 日以降にリリースされた Amazon ECS 最適化 AMI
      ECSエージェントバージョン 
        1.50.2 以上
    Fargate
      プラットフォームバージョン 
        1.4.0 以上 (Linux) 
        1.0.0 (Windows) 
  ファイルアクセス要件
    ファイル書き込み権限が必要
      SSM エージェントは、必要なディレクトリやファイルを作成する
      コンテナのファイルシステムに書き込みができる必要があります
      ルートファイルシステムを読み取り専用にすることは、サポートされません
        readonlyRootFilesystem=false https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html
  ネットワーク要件
    Systems Manager Session Manager へのネットワークアクセス経路が必要
      推奨されているawsvpcネットワークの場合
        インターネットアクセス可能なネットワークである場合
          問題なし
        インターネットアクセス可能なネットワークではない場合
          Interface VPCエンドポイント作成
            VPC endpoints for the Systems Manager Session Manager (ssmmessages)
　　　　　　　　　　上記以外のEC2 起動タイプの Amazon ECS タスクネットワークオプション(Linuxの場合)　https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/task-networking.html
      　　awsvpc: ECS では、別のネットワークモードを使用する特別の必要性がある場合を除き、awsvpc ネットワークモードの使用を推奨
       bridge: タスク定義でネットワークモードが指定されていない場合の、Linux のデフォルトのネットワークモード. Linux の組み込み仮想ネットワークでは、bridge Docker ネットワークドライバーが使用されます. タスクをホストする各 Amazon EC2 インスタンス内で実行される、Linux 上の Docker の組み込み仮想ネットワークを使用
       host: タスクをホストする Amazon EC2 インスタンスの ENI にコンテナポートを直接マッピングすることで Docker の組み込み仮想ネットワークをバイパスする、ホストのネットワークを使用. ダイナミックポートマッピングは、このネットワークモードでは使用できません
       none: noneは、外部ネットワーク接続しないタイプのタスクに使用するオプション
       default(Windows専用)
```

### 推奨事項・注意事項

- IAM ポリシーを使用した ssm:start-session操作制限の推奨
  - https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-exec.html
    ```
    {
      "Version": "2012-10-17",
      "Statement": [
        {
            "Effect": "Deny",
            "Action": "ssm:StartSession",
            "Resource": [
                "arn:aws:ecs:region:aws-account-id:task/cluster-name/*",
                "arn:aws:ecs:region:aws-account-id:cluster/*"
            ]
        }
      ]
    }
    ```

    ```
    {
      "Version": "2012-10-17",
      "Statement": [
        {
            "Effect": "Deny",
            "Action": "ssm:StartSession",
            "Resource": "arn:aws:ecs:*:*:task/*",
            "Condition": {
                "StringEquals": {
                    "aws:ResourceTag/Task-Tag-Key": "Exec-Task"
                }
            }
        }
      ]
    }
    ```

- ECS ExecによるCPU・メモリリソース使用への留意
  - ECS Exec uses some CPU and memory.
  - You'll want to accommodate for that when specifying the CPU and memory resource allocations in your task definition.

- ECS Task initProcessEnabledフラグの推奨
  - The following actions might result in orphaned and zombie processes
    - terminating the main process of the container
    - terminating the command agent
    - deleting dependencies
  - To cleanup zombie processes, we recommend adding the initProcessEnabled flag to your task definition
  - Users can run all of the commands that are available within the container context.

- コンテナ上の実行ユーザ仕様への留意
  - ECS Exec を使用してコンテナ上でコマンドを実行すると、これらのコマンドは root ユーザーとして実行されます
  - コンテナにユーザー ID を指定しても、SSM エージェントとその子プロセスは root として実行されます


- ECS Execを支える２つの特徴的な機能 Runtime Monitoringと Service Connect
  - following features run as a sidecar container. Therefore, you must specify the container name to run the command on.
    - Runtime Monitoring  https://docs.aws.amazon.com/guardduty/latest/ug/runtime-monitoring-after-configuration.html
      - ECS Runtime Monitoring = GuardDutyの1機能
        - OSレベルのモニタリング。潜在的脅威検出。ファイルアクセス、プロセス実行、ネットワーク接続
          - Runtime Monitoring uses a GuardDuty security agent that adds visibility into runtime behavior, such as file access, process execution, command line arguments, and network connections
            - EC2 runtime monitoring 
              - expands threat detection coverage for EC2 instances at runtime and complement the anomaly detection that Amazon GuardDuty already provides by continuously monitoring VPC flow logs DNS logs and AWS cloud trail management events
            - Fargate (Amazon ECS only)
            - EKS runtime monitoring
    - Service Connect
      - ECS サービス相互接続の３つの方法 https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/interconnecting-services.html
        - Elastic Load Balancing の使用(インターネットからの外部接続が必要な場合)
        - Amazon ECS Service Connect https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/service-connect.html
          - 短縮名と標準ポートを使用して、Amazon ECS サービスに接続
            - 同じクラスターや他のクラスター (同じ AWS リージョン の VPC を含む) 内の Amazon ECS サービスに接続
          - ECS Service Connect

            ```
              ・できること
                    ECS 設定としてサービス間通信を管理
                        サービス検出
                        サービスメッシュ
              ・機能
                        各サービス内の完全な設定
                            サービスデプロイごとに管理
                        名前空間内の統一されたサービス参照方法
                            VPC DNS 設定に依存しない
                        標準化されたメトリクスとログ提供（すべてのアプリケーション監視）
              ・例
                    　・Service Connect ネットワークの例    
                        VPC
                        2 つのサブネット
                        2 つのサービス
                            WordPress を実行するクライアントサービス
                                各サブネットに 1タスク
                            MySQL を実行するサーバーサービス
                                各サブネットに 1タスク
                        WordPress から MySQL への接続
                            IP アドレス 172.31.16.1 が設定されたタスク内の WordPress コンテナ内からmysql --host=mysql CLI コマンド実行
                                同じタスク内で Service Connect プロキシ(WordPress タスクのプロキシ)に接続
                                WordPress タスクのプロキシ
                                    接続する MySQL タスクを選択
                                        ラウンドロビン負荷分散と異常値検出に対する以前の障害情報を使用
              ```

        - Amazon ECS との AWS Cloud Map サービス検出の統合 https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/service-discovery.html

```
              サービス検出のコンポーネント
                    サービス検出名前空間
                        同じドメイン名 (example.com など) を共有するサービスの論理グループ
                            aws servicediscovery create-private-dns-namespace コマンドを使用して名前空間を作成できます
                    サービス検出サービス
                        サービス検出名前空間に存在するサービス。
                            名前空間のサービス名および DNS 設定から構成されます
                    サービスレジストリ
                        1 つ以上の利用可能なエンドポイントを返すことができるレジストリ機能
                            DNS あるいは AWS Cloud Map API アクションを介してサービスを検索し、サービスに接続するために使用できる 1 つ以上の利用可能なエンドポイントを返すことができます
                    サービスディスカバリインスタンス
                        サービスディスカバリサービス
                        サービスディレクトリ
                        内の各 Amazon ECS サービスに関連付けられた属性で構成されます
                        インスタンスの属性: 次のメタデータは、サービスディスカバリ を使用するように設定された各 Amazon ECS サービスのカスタム属性として追加されます

```
