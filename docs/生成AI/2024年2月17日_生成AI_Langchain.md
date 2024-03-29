# 20240217_生成AI_Langchain

## 時間

2/18 11:06-11:34(28m)

## やること

- LlamaIndex：大規模言語モデルを拡張するLangChainの代替
  - Large Language Models（LLMs）の機能を拡張するために特別に設計された高性能インデックス作成ツール
    - 単なるクエリ最適化ツールではなく、応答合成、組み合わせ性、効率的なデータ保存など、高度な機能を提供する包括的なフレームワーク
      - LlamaIndexは、Large Language Models（LLMs）の機能を拡張するために特別に設計された専門ツール
        - 特定のLLMのインタラクションにおける包括的なソリューションとして機能
          - 特に正確なクエリと高品質の応答が求められるシナリオで優れた性能を発揮します。
      - クエリ：データの迅速な取得に最適化されており、速度が重要なアプリケーションに適しています
      - 応答合成：簡潔で文脈に合った応答を生成するために最適化されています。 
      - 組み合わせ性：モジュラーで再利用可能なコンポーネントを使用して、複雑なクエリやワークフローを構築できます。
  - LlamaIndexにおけるインデックスとは
    - クエリ対象の情報を保持するデータ構造として機能
      - LlamaIndexのコア
      - 特定のタスクに最適化された複数の種類のインデックスが提供されています
        - Vector Store Index: 高次元データに最適化されたk-NNアルゴリズムを使用します。
        - Keyword-based Index: テキストベースのクエリにTF-IDFを使用します。
        - Hybrid Index: VectorとKeyword-basedインデックスの組み合わせで、バランスの取れたアプローチを提供します。

- Chainの機能概要を学ぶ（複数のモジュール（言語モデル）をまとめる機能部品） 
  - LLMChainで複数言語モデルをまとめた場合でも、サンプルコードのproduct変数のように入力値は、共通化しなくてはならない?特定の言語モデルだけ特別に入力が増えることは実際あるか。ある場合どうすればよい?
  - Chains
    - 基本的なモジュール
      - Model I/O
        - Language models
          - 各LLMのインターフェース（API）は元々異なるのに対し統一されたインターフェースを提供するために用意されたモジュール
          - 
        - Templatesモジュール
          - 言語モデルのテキスト入力の最適化（プロンプトエンジニアリング）とプロンプトの構築を手助けするモジュール
            - 得られる結果をより良いものにする
            - 単純な命令では難しいタスク、以前は不可能と言われていた高度なタスクの実現
              - 科学論文の要約作成
              - 専門知識を要する文章作成
              - 高度なインタラクション
          - 出力例を含んだプロンプトを作成する

```python
from langchain.llms import OpenAI
from langchain.prompts import PromptTemplate, FewShotPromptTemplate
examples = [

  {
    "input": "",
    "output": ""
  }
]
example_prompt = PromptTemplate(
  template = "入力 : {input}\n出力 : {output}\n",
  input_variables = ["input", "output"],
)
fsp = FewShotPromptTemplate(
  examples = examples,
  example_prompt=prompt,
  prefix = "",
  suffix = "",
  
)
```

        - OutputParsers

```
  - 言語モデルの特徴と制約を理解する
    - 履歴をデータベースに保存して永続化する
    - 知らない情報に基づいた回答ができる仕組み
    - 非常に長い会話履歴
      - 長くなりすぎると、言語モデルを呼び出せないのはどのような制約によるものか？
        - トークン数？
        - 言語モデルとのやりとりも、HTTPリクエストによる実装
          - 言語モデルによって、履歴の交換はセッションか、リクエストかが別れる
            - セッション管理上の制約？
            - リクエストサイズの制約？
        - 長すぎる履歴に対して、言語モデルが応答を返すまでの所要時間が長くなりすぎるとか？
          - だったら呼び出せないのではなく、呼び出しがタイムアウトすると表現するはずなので、多分違う
      - 対策は？

