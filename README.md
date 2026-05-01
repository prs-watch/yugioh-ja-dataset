# yugioh-dataset

遊戯王カードの日本語データセットを生成するパイプラインです。

## ディレクトリ構成

```
yugioh-dataset/
├── build.sh                        # メインビルドスクリプト
├── dataset.parquet                 # build.sh実行後に生成されるデータセット
├── build-resources/
│   ├── consts.sh                   # データソース URL 定数
│   ├── queries/
│   │   ├── export-cards.sql        # YGOPRODeck JSON → Parquet 変換
│   │   ├── export-yaml-yugi.sql    # yaml-yugi YAML → Parquet 変換
│   │   └── export-dataset.sql      # 2ソース結合・日本語データセット生成
│   └── maps/
│       ├── attribute-map.json      # 属性 英語→日本語 マッピング
│       ├── frame-type-map.json     # フレーム種別 英語→日本語 マッピング
│       ├── linkmarker-map.json     # リンクマーカー 英語→日本語 マッピング
│       ├── race-map.json           # 種族 英語→日本語 マッピング
│       └── type-map.json           # カード種別 英語→日本語 マッピング
└── .github/workflows/
    └── main.yml                    # GitHub Actions ワークフロー
```

## データセット仕様

出力ファイル: `dataset.parquet`

| カラム名 | 型 | 説明 |
|---|---|---|
| `id` | INTEGER | カードID |
| `name_en` | VARCHAR | 英語カード名 |
| `text_en` | VARCHAR | 英語カードテキスト |
| `name_ja` | VARCHAR | 日本語カード名 |
| `text_ja` | VARCHAR | 日本語カードテキスト（ペンデュラム効果含む） |
| `type` | VARCHAR | カード種別（例: 効果モンスター、魔法、罠） |
| `frame_type` | VARCHAR | フレーム種別（例: 効果モンスター、融合モンスター） |
| `atk` | INTEGER | 攻撃力 |
| `def` | INTEGER | 守備力 |
| `level` | INTEGER | レベル / ランク |
| `race` | VARCHAR | 種族（例: 戦士族、魔法使い族） |
| `attribute` | VARCHAR | 属性（例: 炎、水、闇） |
| `scale` | INTEGER | ペンデュラムスケール |
| `linkval` | INTEGER | リンク数値 |
| `linkmarkers` | VARCHAR[] | リンクマーカー位置 |

- スキルカードは除外されています。
- `text_ja` はペンデュラムモンスターの場合、`[テキスト]` と `[ペンデュラムテキスト]` の2セクション形式で格納されます。

## データソース

| ソース | 用途 |
|---|---|
| [YGOPRODeck API](https://ygoprodeck.com/api-guide/) | カードステータス（ATK / DEF / レベル / 属性など） |
| [yaml-yugi](https://github.com/DawnbrandBots/yaml-yugi) | 日本語カード名・日本語テキスト |

## 必要環境

- [DuckDB CLI](https://duckdb.org/docs/installation/)
- `bash`, `curl`, `unzip`

## ローカル実行

```bash
# dataset.parquet生成
$ bash build.sh
```