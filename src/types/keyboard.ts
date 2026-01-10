// フリック方向
export type FlickDirection = 'center' | 'up' | 'right' | 'down' | 'left';

// フリック方向の順序（中央は常にあり、それ以外は0〜4個）
export const FLICK_DIRECTIONS: FlickDirection[] = ['center', 'up', 'right', 'down', 'left'];
export const OPTIONAL_FLICK_DIRECTIONS: FlickDirection[] = ['up', 'right', 'down', 'left'];

// キー1つの定義
// フリック数は0〜4（中央は常にあり + 上下左右のうち0〜4個）
export interface KeyConfig {
  // 中央の文字（必須）
  center: string;
  // オプションのフリック方向とその文字
  // 存在するキーのみ入力可能
  flicks: Partial<Record<Exclude<FlickDirection, 'center'>, string>>;
  // キーの座標（0-1の正規化座標）
  x: number;
  y: number;
}

// キーボード配置全体（染色体/個体）
export interface KeyboardLayout {
  id: string;
  // キーの配列
  keys: KeyConfig[];
  // グリッド設定（表示用）
  cols: number;
  // 適応度スコア（入力速度から計算）
  fitness?: number;
  // 世代番号
  generation: number;
}

// 日本語の基本文字セット（46文字）
export const HIRAGANA_CHARS = [
  // あ行
  'あ', 'い', 'う', 'え', 'お',
  // か行
  'か', 'き', 'く', 'け', 'こ',
  // さ行
  'さ', 'し', 'す', 'せ', 'そ',
  // た行
  'た', 'ち', 'つ', 'て', 'と',
  // な行
  'な', 'に', 'ぬ', 'ね', 'の',
  // は行
  'は', 'ひ', 'ふ', 'へ', 'ほ',
  // ま行
  'ま', 'み', 'む', 'め', 'も',
  // や行
  'や', 'ゆ', 'よ',
  // ら行
  'ら', 'り', 'る', 'れ', 'ろ',
  // わ行 + ん
  'わ', 'を', 'ん',
] as const;

// 濁点付き文字（20文字）
export const DAKUTEN_CHARS = [
  'が', 'ぎ', 'ぐ', 'げ', 'ご',
  'ざ', 'じ', 'ず', 'ぜ', 'ぞ',
  'だ', 'ぢ', 'づ', 'で', 'ど',
  'ば', 'び', 'ぶ', 'べ', 'ぼ',
] as const;

// 半濁点付き文字（5文字）
export const HANDAKUTEN_CHARS = [
  'ぱ', 'ぴ', 'ぷ', 'ぺ', 'ぽ',
] as const;

// 小文字（9文字）
export const SMALL_CHARS = [
  'ぁ', 'ぃ', 'ぅ', 'ぇ', 'ぉ',
  'ゃ', 'ゅ', 'ょ',
  'っ',
] as const;

// 全ひらがな文字セット（80文字）
export const ALL_HIRAGANA_CHARS = [
  ...HIRAGANA_CHARS,
  ...DAKUTEN_CHARS,
  ...HANDAKUTEN_CHARS,
  ...SMALL_CHARS,
] as const;

// 特殊キー（変換機能）
export const SPECIAL_KEYS = {
  DAKUTEN: '゛',      // 濁点変換
  HANDAKUTEN: '゜',   // 半濁点変換
  SMALL: '小',        // 小文字変換
} as const;

export type SpecialKey = typeof SPECIAL_KEYS[keyof typeof SPECIAL_KEYS];

// 濁点変換マップ
export const DAKUTEN_MAP: Record<string, string> = {
  'か': 'が', 'き': 'ぎ', 'く': 'ぐ', 'け': 'げ', 'こ': 'ご',
  'さ': 'ざ', 'し': 'じ', 'す': 'ず', 'せ': 'ぜ', 'そ': 'ぞ',
  'た': 'だ', 'ち': 'ぢ', 'つ': 'づ', 'て': 'で', 'と': 'ど',
  'は': 'ば', 'ひ': 'び', 'ふ': 'ぶ', 'へ': 'べ', 'ほ': 'ぼ',
  'う': 'ゔ',
  // 逆変換
  'が': 'か', 'ぎ': 'き', 'ぐ': 'く', 'げ': 'け', 'ご': 'こ',
  'ざ': 'さ', 'じ': 'し', 'ず': 'す', 'ぜ': 'せ', 'ぞ': 'そ',
  'だ': 'た', 'ぢ': 'ち', 'づ': 'つ', 'で': 'て', 'ど': 'と',
  'ば': 'は', 'び': 'ひ', 'ぶ': 'ふ', 'べ': 'へ', 'ぼ': 'ほ',
  'ゔ': 'う',
};

// 半濁点変換マップ
export const HANDAKUTEN_MAP: Record<string, string> = {
  'は': 'ぱ', 'ひ': 'ぴ', 'ふ': 'ぷ', 'へ': 'ぺ', 'ほ': 'ぽ',
  // 逆変換
  'ぱ': 'は', 'ぴ': 'ひ', 'ぷ': 'ふ', 'ぺ': 'へ', 'ぽ': 'ほ',
};

// 小文字変換マップ
export const SMALL_MAP: Record<string, string> = {
  'あ': 'ぁ', 'い': 'ぃ', 'う': 'ぅ', 'え': 'ぇ', 'お': 'ぉ',
  'や': 'ゃ', 'ゆ': 'ゅ', 'よ': 'ょ',
  'つ': 'っ',
  // 逆変換
  'ぁ': 'あ', 'ぃ': 'い', 'ぅ': 'う', 'ぇ': 'え', 'ぉ': 'お',
  'ゃ': 'や', 'ゅ': 'ゆ', 'ょ': 'よ',
  'っ': 'つ',
};

// 進化計算の設定
export interface EvolutionConfig {
  populationSize: number;      // 集団サイズ
  mutationRate: number;        // 突然変異率
  crossoverRate: number;       // 交叉率
  eliteCount: number;          // エリート保存数
  // キーボード構造の制約
  minKeys: number;             // 最小キー数
  maxKeys: number;             // 最大キー数
  minFlicksPerKey: number;     // キーあたり最小フリック数（0〜4）
  maxFlicksPerKey: number;     // キーあたり最大フリック数（0〜4）
  cols: number;                // 表示列数
}

// 進化状態
export interface EvolutionState {
  population: KeyboardLayout[];
  generation: number;
  config: EvolutionConfig;
  history: GenerationHistory[];
}

// 世代履歴
export interface GenerationHistory {
  generation: number;
  bestLayout: KeyboardLayout;
  averageFitness: number;
  timestamp: number;
}

// キーボードの統計情報
export function getLayoutStats(layout: KeyboardLayout): {
  keyCount: number;
  totalSlots: number;
  avgFlicksPerKey: number;
} {
  const keyCount = layout.keys.length;
  let totalFlicks = 0;

  for (const key of layout.keys) {
    totalFlicks += Object.keys(key.flicks).length;
  }

  return {
    keyCount,
    totalSlots: keyCount + totalFlicks, // center + flicks
    avgFlicksPerKey: keyCount > 0 ? totalFlicks / keyCount : 0,
  };
}
