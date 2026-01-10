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
