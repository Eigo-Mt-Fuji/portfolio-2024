# AWS_ECS_Execと仲良くなる

## 時間

- 8/12 12:45-13:00(15m)

## やること

- ECS Execの読解
  - https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/ecs-exec.html

## 備忘録

- ECS Exec は、AWS Systems Manager (SSM) セッションマネージャーを使用して実行中のコンテナとの接続を確立し、AWS Identity and Access Management (IAM) ポリシーを使用して実行中のコンテナで実行中のコマンドへのアクセスを制御
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

- IAM ポリシーを使用した ssm:start-session操作制限
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

- ECS Execのリソース使用
  - ECS Exec uses some CPU and memory.
  - You'll want to accommodate for that when specifying the CPU and memory resource allocations in your task definition.
  - following features run as a sidecar container. Therefore, you must specify the container name to run the command on.
    - Runtime Monitoring
    - Service Connect

- ECS Task initProcessEnabledフラグの推奨
  - The following actions might result in orphaned and zombie processes
    - terminating the main process of the container
    - terminating the command agent
    - deleting dependencies
  - To cleanup zombie processes, we recommend adding the initProcessEnabled flag to your task definition
  - Users can run all of the commands that are available within the container context.

- コンテナ上の実行ユーザ仕様
  - ECS Exec を使用してコンテナ上でコマンドを実行すると、これらのコマンドは root ユーザーとして実行されます
  - コンテナにユーザー ID を指定しても、SSM エージェントとその子プロセスは root として実行されます
