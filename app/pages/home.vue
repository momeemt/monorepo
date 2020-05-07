<template>
  <section class="page-home">
    <el-card class="box-card">
      <h1>ホーム</h1>
      <p>こんにちは、{{ "test" }}さん！</p>
      <el-divider />
      <h2>統計</h2>
      <el-row :gutter="20">
        <el-col :span="4">
          <p><b>暗記単語数</b></p>
          <p>120語</p>
        </el-col>
        <el-col :span="4">
          <p><b>レーティング</b></p>
          <p>225</p>
        </el-col>
        <el-col :span="4">
          <p><b>継続学習日数</b></p>
          <p>22日</p>
        </el-col>
        <el-col :span="4">
          <p><b>現在の継続学習日数</b></p>
          <p>0日</p>
        </el-col>
      </el-row>
      <el-divider />
      <h2>Beginners Words</h2>
      <p>中学生レベルの単語です</p>
      <el-row :gutter="20">
        <el-col :span="4">
          <el-progress :percentage="percent" type="circle" />
          <p>名詞</p>
        </el-col>
        <el-col :span="4">
          <el-progress :percentage="percent" type="circle" />
          <p>動詞</p>
        </el-col>
        <el-col :span="4">
          <el-progress :percentage="percent" type="circle" />
          <p>形容詞</p>
        </el-col>
        <el-col :span="4">
          <el-progress :percentage="percent" type="circle" />
          <p>副詞・前置詞・接続詞</p>
        </el-col>
        <el-col :span="4">
          <el-progress :percentage="percent" type="circle" />
          <p>熟語</p>
        </el-col>
      </el-row>
      <el-divider />
      <h2>Regular Words</h2>
      <p>高校生、センター試験レベルの単語です</p>
      <el-row :gutter="20">
        <el-col :span="4">
          <el-progress :percentage="percent" type="circle" />
          <p>名詞</p>
        </el-col>
        <el-col :span="4">
          <el-progress :percentage="percent" type="circle" />
          <p>動詞</p>
        </el-col>
        <el-col :span="4">
          <el-progress :percentage="percent" type="circle" />
          <p>形容詞</p>
        </el-col>
        <el-col :span="4">
          <el-progress :percentage="percent" type="circle" />
          <p>副詞・前置詞・接続詞</p>
        </el-col>
        <el-col :span="4">
          <el-progress :percentage="percent" type="circle" />
          <p>熟語</p>
        </el-col>
      </el-row>
      <el-divider />
      <h2>Grand Words</h2>
      <p>難関大学レベルの単語です</p>
      <el-row :gutter="20">
        <el-col :span="4">
          <el-progress :percentage="percent" type="circle" />
          <p>名詞</p>
        </el-col>
        <el-col :span="4">
          <el-progress :percentage="percent" type="circle" />
          <p>動詞</p>
        </el-col>
        <el-col :span="4">
          <el-progress :percentage="percent" type="circle" />
          <p>形容詞</p>
        </el-col>
        <el-col :span="4">
          <el-progress :percentage="percent" type="circle" />
          <p>副詞・前置詞・接続詞</p>
        </el-col>
        <el-col :span="4">
          <el-progress :percentage="percent" type="circle" />
          <p>熟語</p>
        </el-col>
      </el-row>
    </el-card>
  </section>
</template>

<script>
export default {
  data () {
    return {
      percent: 0
    }
  }
}
</script>

<style scoped>
  .page-home {
    display: flex;
    justify-content: center;
  }
.box-card {
  width: 90%;
}
</style>
