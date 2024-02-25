# 2024年2月25日_HuggingFace_Transformeris何.md
## 時間

- 2/25 11:00-12:38(1h38m)

## やること

- HuggingFaceとは?ユーザ登録しつつ概要を理解しよう
  - HuggingFace_Transformeris何

## 備忘録

`読んだ記事とわかったことをまとめておく`

- https://huggingface.co/docs/hub/models-libraries

`The Hub has support for dozens of libraries in the Open Source ecosystem. Thanks to the huggingface_hub Python library,  it’s easy to enable sharing your models on the Hub.  The Hub supports many libraries, and we’re working on expanding this support.  We’re happy to welcome to the Hub a set of Open Source libraries that are pushing Machine Learning forward. The table below summarizes the supported libraries and their level of integration.  Find all our supported libraries in the model-libraries.ts file.`

- うん。..どういう意味ですか？

```
Adapters	A unified Transformers add-on for parameter-efficient and modular fine-tuning.	✅	✅	✅	✅
AllenNLP	An open-source NLP research library, built on PyTorch.	✅	✅	✅	❌
Asteroid	PyTorch-based audio source separation toolkit	✅	✅	✅	❌
BERTopic	BERTopic is a topic modeling library for text and images	✅	✅	✅	✅
Diffusers	A modular toolbox for inference and training of diffusion models	✅	✅	✅	✅
docTR	Models and datasets for OCR-related tasks in PyTorch & TensorFlow	✅	✅	✅	❌
ESPnet	End-to-end speech processing toolkit (e.g. TTS)	✅	✅	✅	❌
fastai	Library to train fast and accurate models with state-of-the-art outputs.	✅	✅	✅	✅
Keras	Library that uses a consistent and simple API to build models leveraging TensorFlow and its ecosystem.	❌	❌	✅	✅
Flair	Very simple framework for state-of-the-art NLP.	✅	✅	✅	✅
MBRL-Lib	PyTorch implementations of MBRL Algorithms.	❌	❌	✅	✅
MidiTok	Tokenizers for symbolic music / MIDI files.	❌	❌	✅	✅
ML-Agents	Enables games and simulations made with Unity to serve as environments for training intelligent agents.	❌	❌	✅	✅
MLX	Model training and serving framework on Apple silicon made by Apple.	❌	❌	✅	✅
NeMo	Conversational AI toolkit built for researchers	✅	✅	✅	❌
OpenCLIP	Library for open-source implementation of OpenAI’s CLIP	❌	❌	✅	✅
PaddleNLP	Easy-to-use and powerful NLP library built on PaddlePaddle	✅	✅	✅	✅
PEFT	Cutting-edge Parameter Efficient Fine-tuning Library	✅	✅	✅	✅
Pyannote	Neural building blocks for speaker diarization.	❌	❌	✅	❌
PyCTCDecode	Language model supported CTC decoding for speech recognition	❌	❌	✅	❌
Pythae	Unified framework for Generative Autoencoders in Python	❌	❌	✅	✅
RL-Baselines3-Zoo	Training framework for Reinforcement Learning, using Stable Baselines3.	❌	✅	✅	✅
Sample Factory	Codebase for high throughput asynchronous reinforcement learning.	❌	✅	✅	✅
Sentence Transformers	Compute dense vector representations for sentences, paragraphs, and images.	✅	✅	✅	✅
SetFit	Efficient few-shot text classification with Sentence Transformers	✅	✅	✅	✅
spaCy	Advanced Natural Language Processing in Python and Cython.	✅	✅	✅	✅
SpanMarker	Familiar, simple and state-of-the-art Named Entity Recognition.	✅	✅	✅	✅
Scikit Learn (using skops)	Machine Learning in Python.	✅	✅	✅	✅
Speechbrain	A PyTorch Powered Speech Toolkit.	✅	✅	✅	❌
Stable-Baselines3	Set of reliable implementations of deep reinforcement learning algorithms in PyTorch	❌	✅	✅	✅
TensorFlowTTS	Real-time state-of-the-art speech synthesis architectures.	❌	❌	✅	❌
Timm	Collection of image models, scripts, pretrained weights, etc.	✅	✅	✅	✅
Transformers	State-of-the-art Natural Language Processing for PyTorch, TensorFlow, and JAX	✅	✅	✅	✅
Transformers.js	State-of-the-art Machine Learning for the web. Run 🤗 Transformers directly in your browser, with no need for a server!	❌	❌	✅	❌
Unity Sentis	Inference engine for the Unity 3D game engine	
```

- https://huggingface.co/docs/hub/models-adding-libraries
  - huggingface_hub Python libraryには推論のためのInference API、GUIからの操作をサポートするWidgetsが含まれているのか？それをサードパーティのモデルプロバイダがインターフェース実装してHubに公開してる？

- 一番上のAdaptersで調べてみる
  - https://github.com/adapter-hub/adapters
    - adapters is an add-on to HuggingFaces Transformers library, integrating adapters into state-of-the-art language models by incorporating AdapterHub, a central repository for pre-trained adapter modules.
    - AdaptersはHuggingfaceのTransformersのAdd-on。推論APIでサポートされているタスクに対応するAPI実装をAdaptersが開発してHagging face hubに公開している。

- https://github.com/huggingface/api-inference-community/tree/main
  - ソースコードを少し覗いてみた。
    - サポートされてるタスク: text-generation, text-classification, token-classification, translation, summarization, automatic-speech-recognition
      - 三つのタスクに対応するパイプラインがmain.pyで設定されてた

```
    "question-answering": QuestionAnsweringPipeline,
    "text-classification": TextClassificationPipeline,
    "token-classification": TokenClassificationPipeline,
```

- https://huggingface.co/docs/hub/transformers
  - text-generationはパイプラインをTransformer APIで呼んでるのを見かけた。
  - 公開された推論APIをTransformerのライブラリで呼べるってこと?
    - pipelineとAutoTokenizer, AutoModelForCausalLMの違いは?
        - どっちも特定のモデルを呼び出してるようだけど。パイプラインの方がもしかしてワークフロー的な複合的な何か？

```
from transformers import pipeline
pipe = pipeline("text-generation", model="distilgpt2")

# If you want more control, you will need to define the tokenizer and model.
from transformers import AutoTokenizer, AutoModelForCausalLM
tokenizer = AutoTokenizer.from_pretrained("distilgpt2")
model = AutoModelForCausalLM.from_pretrained("distilgpt2")
```


- https://github.com/huggingface/transformers
  - 次はこれ

## 次のアクション

- Huggingface Transformer理解する(つづき) https://github.com/huggingface/transformers
  - パイプラインとは？
  - pipelineとAutoTokenizer, AutoModelForCausalLMの違いは?
  - どんな使われ方をしてる?
  
ワークフローってzappierとかslack,github + 生成ai か？だとするとどこで動かすかはほどほどにして、何と何をフローにのせてどう組み立てるか、乗せたときの制約などの特徴にフォーカス