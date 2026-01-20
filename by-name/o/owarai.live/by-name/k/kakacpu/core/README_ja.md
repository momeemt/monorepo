# core
kakacpuのプロセッサ実装。このプロセッサはRISC-Vの仕様の実装を目標にしています。

## 開発

開発にはIntel Quartus Primeが必要です。

### FPGAへの書き込み

```sh
cd core
quartus_pgm -m jtag -o "p;output_files/kakacpu.sof"
```

## テスト

DE2-115 (Altera Cyclone IV EP4CE115F29C7N)でのみテストされています。

## TODO

- [ ] UART回路の実装

## ライセンス
MIT or Apache-2.0

