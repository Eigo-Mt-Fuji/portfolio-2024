# 2024年8月12_Langchainコンセプト学習

## 時間

- 8/12 19:00-20:25(1h25m)

## やること

- Langchain conceptual guideチェック https://python.langchain.com/v0.2/docs/concepts/
  - Langchain
  - Vector stores
  - Messages
  - Selectors
  - Output parsers
  - Runnable interface

## Langchain コンセプト学習

- Langgraph https://langchain-ai.github.io/langgraph/tutorials/
  - agent for interacting with a SQL database
    Fetch the available tables from the database
    Decide which tables are relevant to the question
    Fetch the DDL for the relevant tables
    Generate a query based on the question and information from the DDL
    Double-check the query for common mistakes using an LLM
    Execute the query and return the results
    Correct mistakes surfaced by the database engine until the query is successful
    Formulate a response based on the results

- Vector stores https://python.langchain.com/v0.2/docs/tutorials/retrievers/#vector-stores
  - to store and search over unstructured data
  - embed it and store the resulting embedding vectors
  - some database supported by community
    - OpenSearch
      - https://api.python.langchain.com/en/latest/vectorstores/langchain_community.vectorstores.opensearch_vector_search.OpenSearchVectorSearch.html
    - Redis
      - 読む
        - https://api.python.langchain.com/en/latest/vectorstores/langchain_community.vectorstores.redis.base.Redis.html
        - https://github.com/langchain-ai/langchain/blob/master/libs/community/langchain_community/vectorstores/redis/base.py
    - Pgvector
      - https://python.langchain.com/v0.2/docs/integrations/vectorstores/pgvector/

  - Note: Embedding models
    - Embedding models create a vector representation of a piece of text
    - vector as an array of numbers that captures the semantic meaning of the text
    - mathematical operations that allow you to do things like search for other pieces of text that are most similar in meaning

  - Note: Retrievers
    - Retrievers accept a string query as input and return a list of Document's as output
      - interface that returns documents given an unstructured query
      - more general than a vector store
      - only to return (or retrieve)
      - does not need to be able to store documents
      - broad enough to include Wikipedia search and Amazon Kendra

- Key-value stores
  - a form of key-value (KV) storage is helpful.
    - indexing and retrieval with multiple vectors per document
      - https://python.langchain.com/v0.2/docs/how_to/multi_vector/
    - caching embeddings
      - avoid recompute 
        - https://python.langchain.com/v0.2/docs/how_to/caching_embeddings/

- Messages
  - different types of messages. 
    - HumanMessage
    - SystemMessage
    - ToolMessage
    - AIMessage

  - All messages have a role, content, and response_metadata property

    - role
      - WHO is saying the message. LangChain has different message classes for different roles

    - content
      - the content of the message. This can be a few different things:
        - A string (most models deal this type of content)
        - A List of dictionaries (this is used for multimodal input, where the dictionary contains information about that input type and that input location)

    - response_metadata
      - additional metadata about the response
      - specific to each model provider
      - This is where information like log-probs and token usage may be stored

- Selectors
  - prompting technique for achieving better performance is to include examples as part of the prompt
    - https://python.langchain.com/v0.2/docs/how_to/example_selectors/
  - selector that chooses what example to pick based on the length of the word
    - https://python.langchain.com/v0.2/docs/how_to/example_selectors/#custom-example-selector

- Output parsers https://python.langchain.com/v0.2/docs/concepts/#output-parsers
  - transforming output of a model to a more suitable format for downstream tasks
  - LangChain has lots of different types of output parsers
    - Name
    - Supports Streaming
    - Has Format Instructions
    - Calls LLM
    - Input Type
    - Output Type

- Runnable interface https://python.langchain.com/v0.2/docs/concepts/#runnable-interface
  - standard interface, includes:
    - stream: stream back chunks of the response
    - invoke: call the chain on an input
    - batch: call the chain on a list of inputs

  - async methods that should be used with asyncio await syntax for concurrency
    - astream: stream back chunks of the response async
    - ainvoke: call the chain on an input async
    - abatch: call the chain on a list of inputs async
    - astream_log: stream back intermediate steps as they happen, in addition to the final response
    - astream_events: beta stream events as they happen in the chain (introduced in langchain-core 0.1.14)

## 学習済み

- LLMs
- Prompt templates
- Tools
- Toolkits
- Text splitters
- Document loaders
- Documents
- Chat models
- Chat history
