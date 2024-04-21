


## 時間

4/20 14:05-14-11(5m)
4/21 19:00-19:21(21m)

## やること

- groqとは？を知る

## 備忘録

https://github.com/e2b-dev/e2b-cookbook/blob/main/examples%2Fllama-3-code-interpreter%2Fllama_3_code_interpreter.ipynb

Llama3試したけど、出力速すぎてやばい
この文量が一瞬で出力されるのはレベチ (倍速してない)
脅威の「秒速800トークン」を記録...さすがGroq

https://python.langchain.com/docs/integrations/chat/groq/

langchainとllamaindex
llamaindexといえばRAG

RAGってなんだっけ？LLMの外部データソース拡張

RAG具体的に
https://github.com/NVIDIA/GenerativeAIExamples/tree/main/RetrievalAugmentedGeneration%2Fexamples

groqを使うときに必要なコンピューティングリソース
言語モデルを自らホスティングしてweb apiなどで提供する時に計算資源が必要。graqのrest apiを呼ぶだけならllm自体を動かすための計算資源を考える必要はない。

呼び出す方は計算負荷が
httpリクエストを送信する付帯的な処理の分しか発生しない。メモリも受け取ったレスポンスを展開できる容量しか要らない。ネットワーク帯域は通信先との物理的な距離と並列呼び出し数やllmに送信する自然言語のクエリ長に依存する。llm自体を動かすための計算資源を考える必要はない

