# filters

## Gaussian Blur
`Gaussian Blur`とは、ガウス関数を用いて画像をぼかす処理のことを指す。

| | 用語 |
| --- | --- |
| Photoshop | ぼかし (ガウス) |
| OpenCV | `GaussianBlur` |

| params | type | |
| --- | --- | --- |
| radius | `float` | 半径 |

```xml
<gaussian-blur radius="">
</gaussian-blur>
```

メモ: paramsはPSを参考に.