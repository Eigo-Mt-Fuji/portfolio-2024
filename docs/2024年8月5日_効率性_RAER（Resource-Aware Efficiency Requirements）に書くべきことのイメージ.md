# RAER（Resource-Aware Efficiency Requirements）に書くべきことのイメージ

## まとめると

- RAER を定義することで、期待値を管理し、不愉快な驚きを避ける
    - 後になって、それが物理的に不可能である(あるいは、かなりの労力を要する)ことに気づくのは、前時代的なことです
        - 直感的には、非常に大きいわけではないですが、大きな JSON ファイルを読み込むという単純な操作に、これほど多くの時間とメモリがかかると予想しましたか
            - 私は、計算してベンチマークを実行するまで、そう思っていませんでした
            - 相手に良かれと思って、最初の直感から、大きなJSON ファイルを使って瞬時に起動することをクライアントに約束
- RAER を定義し評価する作業イメージ
    - 最悪のケースを想定します(システムでもっとも遅い部分を見つけ、どのような入力がその引き金になるか)
    - 複雑な RAER を定義し評価することは、ややこしい作業。まず、簡単な理論的仮定に基づいておおまか な計算や見積もりを行う手法を用いる
      - ナプキン計算(napkin math)による計算量解析
        - さらにナプキン計算から JSON デコードのクイックマイクロベンチマーク(その方法は 7 章で学べ ます)に切り替えるかもしれません
    - 計算にもっと自信を持つためには、素朴なアルゴリズ ムをすばやく書き下ろし、たとえば 100 万商品を読み込んでベンチマーク† 16 を取る
- RAERを定義し、リリースしたシステムに対して効率性の問題が報告された場合
    - リリース後、想定外の問題報告に対しては、効率性の課題のトリアージを行うための推奨フローを適用すると良い

- ただ
  - クリティカルパスのためにカスタマイズされた実装を提供することで、簡単に効率を 上げられる可能性があることを認識すべき
  - それでも、標準ライブラリのように、 既知の、実戦でテストされたコードを使うべきでしょう。ほとんどの場合、それで十分です!

## 

https://github.com/efficientgo/examples/blob/main/pkg/json/json.go

- ケース１: SUMの計算時間のRAER
    - Before
        - 最大1CPU使用で低レイテンシーを実現
        - 最小限のメモリ量
        - 実行負荷に使用できる4つのCPUコアでさらに低レイテンシーを実現
    - After ( 「より低い」や「最低限」という言葉は、プロフェッショナルとしてふさわしい表現ではありません )
        - 1CPU使用時、1行あたり最大10ナノ秒(10×Nナノ秒)のレイテンシー
        - ヒープ上に確保されるメモリはどの入力に対しても最大10KBまで
        - 4CPU使用時、1行あたり最大2.5ナノ秒(2.5×Nナノ秒)のレイテンシー
- ケース２: シンプルなインメモリサービスを開発する
  - Background
    - 機能目標は、SSDディスクに保存されている1つの大きなJSONファイルから入力 データをメモリにロード(読み込みとデコード)する関数を作成すること
        - 効率要件はどうでしょうか。RAER を作成してみましょう
            - ナプキン計算(napkin math)による計算量解析
            - 簡単な理論的仮定に基づいておおまか な計算や見積もりを行う手法
            - 特に、レイテ ンシー、メモリ、CPU 使用率などの一般的な効率性要件については、時間をかける価値のある フィードバックを早期に得られます
                - 初期のシステムアイデアが正しいかどうか、常に素晴らしいテストとなります。
    - 効率を入力に対するレイテンシー(またはリソースの使用量)の関数として表現
      - 最悪のケースを想定します(システムでもっとも遅い部分を見つけ、どのような入力がその引き金になるか)
        - ディスクから読み込み、多くの商品をデコードしています。さらに、商品が増えると JSON ファイルのサイズが大きくなり、読み込み処理が遅くなる
            - スループット
                - 1秒あたりy(ここで yは1秒あたりに処理される商品数)
                - 1商品あたりのレイテンシー
            - 最大商品数
                - データベースは、最大でも 1000 万個の要素を扱えるように設計する
        - 読み込み操作に必要なランタイムのレイテンシーと空間
            - 簡単な Go コー ドで 1,000 万商品のテスト JSON を生成し、そのファイルサイズを検証
            - 約 730MB でした。付録 A のデータを使えば、このような入力の読み取りにはおよ そ 93.44 ミリ秒かかる
              - (730MB には 93,440 個の 8KB チャンクがある)。念のため、このレイテンシーを 2 倍で見積もっても良いでしょう。
              - その結果、この部分の処理では、1 秒間に 5,000 万商品という素晴らしいスループットを目指せます
  - Example
    - RAERの例(理論的には 3 秒以内で、最大でも 360MB のメモリを使用する ことが可能であることを示しています)
        - プログラム
            - インメモリデータベース
        - 操作
            - 起動時にすべての商品(のID、名前、サイズ、重量)のメモリへの読み込み
        - データセット
            - X商品ごとに平均88バイト
        - 制限
            - X <= 1,000万
        - 最大レイテンシー
            - P99で3000ナノ秒 * X あるいは少なくとも毎秒33万商品
        - メモリ制限
            - X * 375バイト

