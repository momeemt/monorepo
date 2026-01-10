// 意味のある日本語文章（5〜10文字程度）
// 日常会話、メッセージでよく使われる表現
const SENTENCES = [
  // 挨拶・返事
  'おはようございます',
  'こんにちは',
  'こんばんは',
  'おやすみなさい',
  'ありがとう',
  'ありがとうございます',
  'すみません',
  'ごめんなさい',
  'おつかれさま',
  'よろしくおねがいします',
  'いってきます',
  'いってらっしゃい',
  'ただいま',
  'おかえりなさい',
  // 質問・確認
  'なにしてる',
  'いまどこにいる',
  'いつあいてる',
  'だいじょうぶ',
  'げんきですか',
  'わかりました',
  'りょうかいです',
  'もうすこしまって',
  'いまからいく',
  'もうついた',
  // 予定・連絡
  'あしたあえる',
  'きょうはむり',
  'らいしゅうにしよう',
  'ごはんたべた',
  'おなかすいた',
  'ねむくなってきた',
  'でんわしていい',
  'あとでれんらくする',
  'さきにいってて',
  'まっててね',
  // 感情・感想
  'たのしかった',
  'うれしいな',
  'かなしいね',
  'つかれたよ',
  'おもしろかった',
  'すごいね',
  'かわいいね',
  'おいしそう',
  'きれいだね',
  'やばいかも',
  // 日常動作
  'いまおきた',
  'これからねる',
  'しごとおわった',
  'いまかえってる',
  'ごはんつくる',
  'かいものいく',
  'そろそろでる',
  'ちょっとまって',
  'なんでもない',
  'べつにいいよ',
  // 相槌・反応
  'そうなんだ',
  'まじで',
  'うそでしょ',
  'しんじられない',
  'そうだよね',
  'たしかにね',
  'なるほどね',
  'いいとおもう',
  'それはむり',
  'どうしよう',
] as const;

// 使用済み文章を追跡
let usedSentences = new Set<string>();

// ランダムな文章を取得（重複を避ける）
export function getRandomSentence(): string {
  // 80%使い切ったらリセット
  if (usedSentences.size >= SENTENCES.length * 0.8) {
    usedSentences = new Set();
  }

  const available = SENTENCES.filter(s => !usedSentences.has(s));
  const sentence = available[Math.floor(Math.random() * available.length)];
  usedSentences.add(sentence);

  return sentence;
}

// 複数の文章を取得
export function getRandomSentences(count: number): string[] {
  const sentences: string[] = [];
  for (let i = 0; i < count; i++) {
    sentences.push(getRandomSentence());
  }
  return sentences;
}

// 使用履歴をリセット
export function resetSentenceHistory(): void {
  usedSentences = new Set();
}
