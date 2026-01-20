# props
DIMLは、propsというインターフェースを介して外部から一方向に通信を受けることができます。

## props
```xml
<props>
</props>
```

## prop
あるデータを、名前付きで受け取ります。

```xml
<prop type="int" name="hoge" />
```

上は、

```javascript
const hoge: int = ""
```

と等価です。
`prop`は不変であり、破壊的代入をすることはできません。