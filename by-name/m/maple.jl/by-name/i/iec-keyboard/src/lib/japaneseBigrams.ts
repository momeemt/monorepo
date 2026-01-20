// 日本語のひらがなバイグラム（2文字連続）の頻度データ
// 頻度は相対的な重み（高いほど頻出）

// 頻出バイグラム（日本語コーパスに基づく上位パターン）
export const BIGRAM_FREQUENCY: Record<string, number> = {
  // 助詞関連（非常に頻出）
  'のは': 10, 'には': 10, 'では': 10, 'とは': 9,
  'をし': 9, 'がある': 9, 'である': 9, 'ている': 10,
  'ました': 10, 'ません': 9, 'ですが': 9, 'ですか': 9,

  // 動詞活用（頻出）
  'した': 10, 'して': 10, 'する': 10, 'される': 9,
  'なる': 9, 'なった': 9, 'なって': 9, 'ない': 10,
  'ある': 10, 'あり': 9, 'あった': 9, 'いる': 10,
  'いた': 9, 'いて': 9, 'いない': 9, 'きた': 8,
  'くる': 8, 'きて': 8, 'った': 9, 'って': 9,

  // 形容詞・副詞
  'なく': 8, 'よう': 9, 'ような': 9,
  'ように': 9, 'こと': 10, 'ことが': 9, 'ことを': 9,
  'もの': 9, 'ものが': 8, 'ものを': 8, 'とき': 8,
  'ときに': 8, 'ため': 9, 'ために': 9,

  // 接続・文末
  'です': 10, 'ます': 10, 'でした': 9,
  'から': 9, 'まで': 8, 'より': 7, 'ほど': 7,
  'だけ': 8, 'ばかり': 6, 'しか': 7, 'でも': 8,

  // 一般的な2文字
  'これ': 9, 'それ': 9, 'あれ': 7, 'どれ': 6,
  'ここ': 8, 'そこ': 7, 'あそこ': 5, 'どこ': 7,
  'この': 9, 'その': 9, 'あの': 7, 'どの': 6,
  'わたし': 8, 'あなた': 7, 'かれ': 6, 'かのじょ': 5,

  // 動作・状態
  'おも': 8, 'おもう': 8, 'かんが': 7, 'みる': 8,
  'きく': 7, 'はな': 8, 'はなす': 7, 'いう': 9,
  'いえ': 7, 'かく': 7, 'よむ': 7, 'たべ': 6,
  'のむ': 6, 'ねる': 6, 'おき': 6, 'あるく': 6,
  'はし': 6, 'はしる': 6, 'とぶ': 5, 'およ': 5,

  // て形接続
  'ていた': 9, 'ていて': 8, 'てから': 8,
  'てくる': 8, 'ていく': 8, 'てみる': 7, 'ておく': 7,
  'てある': 7, 'てしま': 8, 'てしまう': 8,

  // ない形
  'なかった': 8, 'なくて': 7, 'ないで': 7,
  'なければ': 6, 'なくても': 6,

  // 可能・受身・使役
  'れる': 8, 'られる': 8, 'せる': 6, 'させる': 6,
  'できる': 9, 'できた': 8, 'できない': 8,

  // 時間表現
  'いま': 8, 'きょう': 7, 'あした': 6, 'きのう': 6,
  'あさ': 6, 'ひる': 5, 'よる': 6, 'まえ': 7,
  'あと': 7, 'なか': 8, 'うえ': 6,

  // 場所・方向
  'そと': 5, 'うしろ': 5, 'みぎ': 5, 'ひだり': 5,
  'ちか': 6, 'とお': 5,
};

// 単一文字の頻度（文字が使われる相対的な頻度）
export const CHAR_FREQUENCY: Record<string, number> = {
  // 非常に頻出
  'い': 10, 'う': 10, 'の': 10, 'た': 10, 'し': 10,
  'て': 10, 'に': 10, 'を': 7, 'は': 10, 'が': 8,
  'る': 10, 'と': 10, 'で': 9, 'か': 9, 'ま': 9,
  'な': 9, 'も': 9, 'あ': 9, 'り': 9, 'す': 9,

  // 頻出
  'こ': 8, 'れ': 8, 'ら': 8, 'き': 8, 'っ': 8,
  'く': 8, 'ん': 8, 'だ': 8, 'よ': 8, 'お': 8,
  'え': 7, 'わ': 7, 'つ': 7, 'せ': 7, 'さ': 7,
  'ど': 7, 'め': 7, 'そ': 7, 'ち': 7, 'ね': 6,

  // 中程度
  'け': 6, 'み': 6, 'や': 6, 'ほ': 6, 'ひ': 6,
  'じ': 6, 'ば': 6, 'ぶ': 5, 'び': 5, 'べ': 5,
  'ぼ': 5, 'ぱ': 4, 'ぴ': 4, 'ぷ': 4, 'ぺ': 4,
  'ぽ': 4, 'ゆ': 5, 'ふ': 5, 'へ': 5, 'む': 5,

  // 低頻度
  'ぬ': 3, 'ろ': 4, 'ゃ': 5, 'ゅ': 5, 'ょ': 5,
  'ぁ': 2, 'ぃ': 2, 'ぅ': 2, 'ぇ': 2, 'ぉ': 2,
  'ゔ': 1,

  // 濁点
  'ぎ': 5, 'ぐ': 5, 'げ': 5, 'ご': 6,
  'ざ': 5, 'ず': 4, 'ぜ': 4, 'ぞ': 4,
  'ぢ': 2, 'づ': 3,
};

// バイグラムの頻度を取得（見つからない場合はデフォルト値）
export function getBigramWeight(char1: string, char2: string): number {
  const bigram = char1 + char2;
  return BIGRAM_FREQUENCY[bigram] ?? 1;
}

// 文字の頻度を取得
export function getCharWeight(char: string): number {
  return CHAR_FREQUENCY[char] ?? 1;
}

// 文字列全体の重み付きスコアを計算
export function calculateWeightedScore(
  text: string,
  intervals: number[]
): { totalScore: number; weightedAvgInterval: number; details: Array<{ bigram: string; interval: number; weight: number }> } {
  if (text.length < 2 || intervals.length < 1) {
    return { totalScore: 0, weightedAvgInterval: 0, details: [] };
  }

  const details: Array<{ bigram: string; interval: number; weight: number }> = [];
  let totalWeight = 0;
  let weightedIntervalSum = 0;

  for (let i = 0; i < text.length - 1 && i < intervals.length; i++) {
    const char1 = text[i];
    const char2 = text[i + 1];
    const interval = intervals[i];
    const bigramWeight = getBigramWeight(char1, char2);
    const charWeight = (getCharWeight(char1) + getCharWeight(char2)) / 2;
    const weight = (bigramWeight + charWeight) / 2;

    details.push({ bigram: char1 + char2, interval, weight });
    totalWeight += weight;
    weightedIntervalSum += interval * weight;
  }

  const weightedAvgInterval = totalWeight > 0 ? weightedIntervalSum / totalWeight : 0;

  // スコア計算: 重み付き平均間隔が短いほど高スコア
  // 間隔は通常100-1000ms程度を想定
  // 300ms以下なら高速、500ms以上なら低速と判断
  const speedScore = Math.max(0, 10 - (weightedAvgInterval / 100));

  return {
    totalScore: speedScore * (totalWeight / details.length),
    weightedAvgInterval,
    details,
  };
}
