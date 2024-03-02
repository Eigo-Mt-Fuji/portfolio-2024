# 2024-03-02_生成AI_Langchainを使って学びたいこと（やってみたいこと）

## 時間

- 3/2 19:00-20:28(1h28m)
- 3/2 20:28-21:40(1h12m)

## やること

- Langchainを使って学びたいこと（やってみたいこと）を箇条書きにしておく

## 備忘録

```
・Output parsers - 出力を構造化する P82
・言語モデルを使ってテキストをベクトル化する　→ ベクトルデータベースを使って検索する
    ・手元のPDFやExcelファイルを情報源とした検索を行うには？（WikipediaやGoogle検索を使う場合と比べて、検索が難しい）情報源の中身に対応するテキストをベクトル化し、検索可能にしていく　P92
    ・SpaceyTextSplitterで日本語として適切な位置で分割する P104
    ・言語モデルのAPI（OpenAIEmbeddingsやLlamaCppEmbeddingsなど）を使って、テキストのベクトル化する P93
　　    OpenAIの例で言うと、text-embedding-ada-002という言語モデルをAPI経由で使用できる。このAPIを使うと意味を考慮したテキストのベクトル化が行える。
    ・テキストと関連づけてベクトルデータベース（Vector storesといえば、Pinecone,ChromaDBなど）に保存する P107
    ・検索: ユーザからの入力をベクトル化し、事前準備したデータベース（Pinecone,ChromaDBなど）でベクトルを検索して、文章を取得する P110
    ・プロンプト構築: 取得した類似文章を質問と組み合わせてプロンプトを作成（P59 Model I/OモジュールのPromptTemplateを使う）
・chainlinライブラリを使って、チャット画面を実装し、質問を入力できるようにする P119
・LLMChainを使って複数モジュールの組み合わせ。特にLLMRequestsChainを使って特定のURLにアクセスし情報を取得させ、その情報をもとに回答を生成させる P189
・用意されたRetriever(WikipediaRetriever)をつかってWikipediaを情報源にする P135
・Memoryモジュールで会話履歴をもとにした返答をさせる処理を具体的に確認する P154
・複数の会話履歴を持てるチャットbotを作成する P170 
・非常に長い会話履歴に対応する P176
・AgentモジュールのToolを自作する（Agentができることを増やす）P217
```

## 次のアクション

- Langchain使ってみる。以下の各項目について、対応するページを見ながら実際にコードを書いてみる。

```
・Output parsers - 出力を構造化する P82
・言語モデルを使ってテキストをベクトル化する　→ ベクトルデータベースを使って検索する
    ・手元のPDFやExcelファイルを情報源とした検索を行うには？（WikipediaやGoogle検索を使う場合と比べて、検索が難しい）情報源の中身に対応するテキストをベクトル化し、検索可能にしていく　P92
    ・SpaceyTextSplitterで日本語として適切な位置で分割する P104
    ・言語モデルのAPI（OpenAIEmbeddingsやLlamaCppEmbeddingsなど）を使って、テキストのベクトル化する P93
　　    OpenAIの例で言うと、text-embedding-ada-002という言語モデルをAPI経由で使用できる。このAPIを使うと意味を考慮したテキストのベクトル化が行える。
    ・テキストと関連づけてベクトルデータベース（Vector storesといえば、Pinecone,ChromaDBなど）に保存する P107
    ・検索: ユーザからの入力をベクトル化し、事前準備したデータベース（Pinecone,ChromaDBなど）でベクトルを検索して、文章を取得する P110
    ・プロンプト構築: 取得した類似文章を質問と組み合わせてプロンプトを作成（P59 Model I/OモジュールのPromptTemplateを使う）
・chainlinライブラリを使って、チャット画面を実装し、質問を入力できるようにする P119
・LLMChainを使って複数モジュールの組み合わせ。特にLLMRequestsChainを使って特定のURLにアクセスし情報を取得させ、その情報をもとに回答を生成させる P189
・用意されたRetriever(WikipediaRetriever)をつかってWikipediaを情報源にする P135
・Memoryモジュールで会話履歴をもとにした返答をさせる処理を具体的に確認する P154
・複数の会話履歴を持てるチャットbotを作成する P170 
・非常に長い会話履歴に対応する P176
・AgentモジュールのToolを自作する（Agentができることを増やす）P217
```

- Langchainの以下の点を理解しておく（コード書いた後と前どちらでもOK）

```
・テキストのベクトル化と類似度計算をすることで、大量の文章から特定の質問に対する最も関連性の高い解答を探し出すことが可能になりますとは？
　・大量の文章から
　　　大量の文章とは？
　・最も関連性の高い解答を探し出す（何と何の関連性？、おそらく片方はユーザが入力した文章、もう片方は、照合したいデータベース
　　・類似度計算
　　　コサイン類似度
　　　　・テキストのベクトル化

・RetriversはAgentモジュールのToolに変換できるらしい。どういうことかを理解する P223 に説明があるみたい。
・AgentモジュールのAgentTypeを理解する（意味がわからなかったので、それぞれの定義をもう一度確認。あとAgentType型が非推奨されたのってほんと? https://api.python.langchain.com/en/latest/agents/langchain.agents.agent_types.AgentType.html） Deprecated since version langchain==0.1.0: Use Use new agent constructor methods like create_react_agent, create_json_agent, create_structured_chat_agent, etc. instead.
    ・AgentType.CHAT_ZERO_SHOT_REACT_DESCRIPTION
        Chat modelsモジュールとReAct手法を使って動作するエージェントタイプ
    ・AgentType.ZERO_SHOT_REACT_DESCRIPTION
        LLMモジュールの利用を前提とするエージェントタイプ
    ・AgentType.STRUCTURED_CHAT_ZERO_SHOT_REACT_DESCRIPTION
        ・複数の入力を持ったToolを扱えるエージェントタイプ
    ・AgentType,CHAT_CONVENTIONAL_REACT_DESCRIPTION

    ・GPT3.5,GPT4専用AgentType
        ・AgentType.OPENAI_MULTI_FUNCTIONS
            ・複数の入力を持ったToolを扱える。
    　        ・AgentType.STRUCTURED_CHAT_ZERO_SHOT_REACT_DESCRIPTION と差し替え可能
        ・AgentType.OPENAI_FUNCTIONS
            ・単一の入力を持ったToolのみを扱える。
            ・AgentType.CHAT_ZERO_SHOT_REACT_DESCRIPTION と差し替え可能
・Agentモジュールの定義済みToolにどんなものがあり、どれがよく使われていそうか調べる
  AWS Lambda関数呼び出し
    https://python.langchain.com/docs/integrations/tools/awslambda

・AgentモジュールのToolkitとは？Toolとの違い。そもそもToolkitの実態は一体なんなのか？
  JiraToolkit
    Jiraを操作    
  SQLDatabaseToolkit
    データベースからデータを取得したり、更新したり、削除したりできる

  PlayWrightBrowserToolkit
    Cromeなどプログラムから操作できるアプリケーションPlayWrightを使ってAgentからブラウザでURLを開いたり、内容を取得したり、り

  GmailToolkit
    Gmailを操作するToolが用意されてる、メールの送信、検索、下書き作成、Agentを使ってGmailを操作できる
```

