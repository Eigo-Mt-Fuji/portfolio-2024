# 20240309_生成AI_LangChain_AgentType学習

## 時間

- 3/9 19:30-21:52(2h22m)

## やること

- Langchainの全てのAgentTypeを知る

## 備忘録

```
from langchain.agents import create_openai_functions_agent
from langchain_community.utilities.sql_database import SQLDatabase
from langchain_community.agent_toolkits import create_sql_agent
from langchain_openai import ChatOpenAI

db = SQLDatabase.from_uri("sqlite:///Chinook.db")

llm = ChatOpenAI(
    openai_api_key=os.environ["OPENAI_API_KEY"], 
    model="gpt-4-0613"
)

agent_executor = create_sql_agent(
    llm, 
    db=db, 
    agent_type="openai-tools 
    verbose=True
)
```

### create_react_agent

- llm: BaseLanguageModel,
- tools: Sequence[BaseTool],
  - tools: Tools this agent has access to.
- prompt: BasePromptTemplate,
  - prompt: The prompt to use. See Prompt section below for more.
- output_parser: Optional[AgentOutputParser] = None,
  - 言語モデルの応答をパースするパーサー
- tools_renderer: ToolsRenderer = render_text_description,
  - controls how the tools are converted into a string and then passed into the LLM. Default is `render_text_description`.

### create_openai_tools_agent

- llm: BaseLanguageModel,
- tools: Sequence[BaseTool],
- prompt: ChatPromptTemplate

### create_self_ask_with_search_agent
- llm: BaseLanguageModel,
- tools: Sequence[BaseTool], 
- prompt: BasePromptTemplate
- そもそも self ask with search とは何か？
  - Self-Ask Prompting
    - is a progression from Chain Of Thought Prompting
      - which is better A or B, A is X, B is Y, so A
    - 中間質問、自問自答
  - Self-Ask Prompting is a progression from Chain Of Thought Prompting
    - create_self_ask_with_search_agent
      - create
      - self_ask_with_search
        - Self-Ask Promptingとは?
        - with_searchとは？
        - Chain of Thought Promptingとは?
      - agent

### create_structured_chat_agent

- llm: BaseLanguageModel,
- tools: Sequence[BaseTool],
- prompt: ChatPromptTemplate,
- tools_renderer: ToolsRenderer = render_text_description_and_args,

### create_openai_functions_agent

- llm: BaseLanguageModel,
- tools: Sequence[BaseTool],
- prompt: ChatPromptTemplate

### create_json_chat_agent

- llm: BaseLanguageModel,
- tools: Sequence[BaseTool],
- prompt: ChatPromptTemplate,
- stop_sequence: bool = True,
- tools_renderer: ToolsRenderer = render_text_description,

### create_sql_agent

- llm: BaseLanguageModel,
- db: Optional[SQLDatabase] = None,
- prompt: Optional[BasePromptTemplate] = None,
- extra_tools: Sequence[BaseTool] = (),
- toolkit: Optional[SQLDatabaseToolkit] = None,
- agent_type: Optional[Union[AgentType, Literal["openai-tools"]]] = None,
- callback_manager: Optional[BaseCallbackManager] = None,
- prefix: Optional[str] = None,
- suffix: Optional[str] = None,
- format_instructions: Optional[str] = None,
- input_variables: Optional[List[str]] = None,
- top_k: int = 10,
- max_iterations: Optional[int] = 15,
- max_execution_time: Optional[float] = None,
- early_stopping_method: str = "force
- verbose: bool = False,
- agent_executor_kwargs: Optional[Dict[str, Any]] = None,
- *,
- **kwargs: Any,

### create_json_agent

- llm: BaseLanguageModel,
- toolkit: JsonToolkit,
- callback_manager: Optional[BaseCallbackManager] = None,
- prefix: str = JSON_PREFIX,
- suffix: str = JSON_SUFFIX,
- format_instructions: Optional[str] = None,
- input_variables: Optional[List[str]] = None,
- verbose: bool = False,
- agent_executor_kwargs: Optional[Dict[str, Any]] = None,
- **kwargs: Any,

### create_openapi_agent

- llm: BaseLanguageModel,
- toolkit: OpenAPIToolkit,
- callback_manager: Optional[BaseCallbackManager] = None,
- prefix: str = OPENAPI_PREFIX,
- suffix: str = OPENAPI_SUFFIX,
- format_instructions: Optional[str] = None,
- input_variables: Optional[List[str]] = None,
- max_iterations: Optional[int] = 15,
- max_execution_time: Optional[float] = None,
- early_stopping_method: str = "force
- verbose: bool = False,
- return_intermediate_steps: bool = False,
- agent_executor_kwargs: Optional[Dict[str, Any]] = None,
- **kwargs: Any,

### create_pbi_agent

- llm: BaseLanguageModel,
- toolkit: Optional[PowerBIToolkit] = None,
- powerbi: Optional[PowerBIDataset] = None,
- callback_manager: Optional[BaseCallbackManager] = None,
- prefix: str = POWERBI_PREFIX,
- suffix: str = POWERBI_SUFFIX,
- format_instructions: Optional[str] = None,
- examples: Optional[str] = None,
- input_variables: Optional[List[str]] = None,
- top_k: int = 10,
- verbose: bool = False,
- agent_executor_kwargs: Optional[Dict[str, Any]] = None,
- **kwargs: Any,

### create_pbi_chat_agent

- llm: BaseChatModel,
- toolkit: Optional[PowerBIToolkit] = None,
- powerbi: Optional[PowerBIDataset] = None,
- callback_manager: Optional[BaseCallbackManager] = None,
- output_parser: Optional[AgentOutputParser] = None,
- prefix: str = POWERBI_CHAT_PREFIX,
- suffix: str = POWERBI_CHAT_SUFFIX,
- examples: Optional[str] = None,
- input_variables: Optional[List[str]] = None,
- memory: Optional[BaseChatMemory] = None,
- top_k: int = 10,
- verbose: bool = False,
- agent_executor_kwargs: Optional[Dict[str, Any]] = None,
- **kwargs: Any,

### create_spark_sql_agent

- llm: BaseLanguageModel,
- toolkit: SparkSQLToolkit,
- callback_manager: Optional[BaseCallbackManager] = None,
- callbacks: Callbacks = None,
- prefix: str = SQL_PREFIX,
- suffix: str = SQL_SUFFIX,
- format_instructions: Optional[str] = None,
- input_variables: Optional[List[str]] = None,
- top_k: int = 10,
- max_iterations: Optional[int] = 15,
- max_execution_time: Optional[float] = None,
- early_stopping_method: str = "force
- verbose: bool = False,
- agent_executor_kwargs: Optional[Dict[str, Any]] = None,
- **kwargs: Any,

### create_vectorstore_agent

- llm: BaseLanguageModel,
- toolkit: VectorStoreToolkit,
- callback_manager: Optional[BaseCallbackManager] = None,
- prefix: str = PREFIX,
- verbose: bool = False,
- agent_executor_kwargs: Optional[Dict[str, Any]] = None,
- **kwargs: Any,

### create_vectorstore_router_agent

- llm: BaseLanguageModel,
- toolkit: VectorStoreRouterToolkit,
- callback_manager: Optional[BaseCallbackManager] = None,
- prefix: str = ROUTER_PREFIX,
- verbose: bool = False,
- agent_executor_kwargs: Optional[Dict[str, Any]] = None,
- **kwargs: Any,

### create_xml_agent

- llm: BaseLanguageModel,
- tools: Sequence[BaseTool],
- prompt: BasePromptTemplate,
- tools_renderer: ToolsRenderer = render_text_description,
