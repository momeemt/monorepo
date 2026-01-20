# DIML
Dynamic Image-processing Markup Language (*DIML*) は、画像処理を行う、動的キューに耐え得るマークアップ言語です。  

## DIMLとは何か

```xml
<?diml version="0.1"?>
<root type="image" src="./sample.png">
  <props>
    <prop type="float" name="grayscale-value">
    <prop type="string" name="text-value">
  </props>
  <main>
    <gray-scale :value="grayscale-value">
      <rect x1="10" y1="15" x2="20" y2="25" color="red" />
      <text :value="text-value" x="30" y="20" color="black" />
    </gray-scale>
  </main>
</root>
```

## 目次

1. [DIML](/)
1. [props](/props)
1. [shapes](/shapes)
1. [filters](/filters)