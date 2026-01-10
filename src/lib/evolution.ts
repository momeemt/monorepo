import type {
  KeyboardLayout,
  KeyConfig,
  EvolutionConfig,
  FlickDirection,
} from '../types/keyboard';
import { OPTIONAL_FLICK_DIRECTIONS, ALL_HIRAGANA_CHARS, SPECIAL_KEYS } from '../types/keyboard';

// 全文字 + 特殊キー（変換キー）
const ALL_CHARS = [...ALL_HIRAGANA_CHARS, SPECIAL_KEYS.DAKUTEN, SPECIAL_KEYS.HANDAKUTEN, SPECIAL_KEYS.SMALL];

// ユニークIDを生成
function generateId(): string {
  return Math.random().toString(36).substring(2, 15);
}

// 配列をシャッフル（Fisher-Yates）
function shuffle<T>(array: T[]): T[] {
  const result = [...array];
  for (let i = result.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [result[i], result[j]] = [result[j], result[i]];
  }
  return result;
}

// ランダムな整数を生成
function randInt(min: number, max: number): number {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

// ランダムなフリック方向のサブセットを選択
type OptionalFlickDirection = Exclude<FlickDirection, 'center'>;
function randomFlickDirections(count: number): OptionalFlickDirection[] {
  const shuffled = shuffle([...OPTIONAL_FLICK_DIRECTIONS]) as OptionalFlickDirection[];
  return shuffled.slice(0, count);
}

// ランダムな座標を生成（0-1の範囲）
function randomPosition(): { x: number; y: number } {
  return {
    x: Math.random(),
    y: Math.random(),
  };
}

// ランダムなキーボード配置を生成（全文字+特殊キーを必ず使用）
export function createRandomLayout(config: EvolutionConfig, generation: number): KeyboardLayout {
  const { minFlicksPerKey, maxFlicksPerKey, cols } = config;

  // 使用する文字をシャッフル（全ひらがな80文字 + 特殊キー3つ = 83文字）
  const chars = shuffle([...ALL_CHARS]);
  let charIndex = 0;

  const keys: KeyConfig[] = [];

  // 全文字を使い切るまでキーを作成
  while (charIndex < chars.length) {
    // 残り文字数に基づいてフリック数を決定
    const remainingChars = chars.length - charIndex;
    // 最低1文字（center）は必要なので、残りからフリック可能数を計算
    const maxPossibleFlicks = Math.min(maxFlicksPerKey, remainingChars - 1);
    const flickCount = randInt(minFlicksPerKey, Math.max(minFlicksPerKey, maxPossibleFlicks));
    const flickDirs = randomFlickDirections(flickCount);

    // 中央の文字（必須）
    const center = chars[charIndex++];

    // フリック方向の文字
    const flicks: Partial<Record<Exclude<FlickDirection, 'center'>, string>> = {};
    for (const dir of flickDirs) {
      if (charIndex < chars.length) {
        flicks[dir] = chars[charIndex++];
      }
    }

    // ランダムな座標を割り当て
    const pos = randomPosition();
    keys.push({ center, flicks, x: pos.x, y: pos.y });
  }

  return {
    id: generateId(),
    keys,
    cols,
    generation,
  };
}

// 初期集団を生成
export function createInitialPopulation(config: EvolutionConfig): KeyboardLayout[] {
  const population: KeyboardLayout[] = [];

  for (let i = 0; i < config.populationSize; i++) {
    population.push(createRandomLayout(config, 0));
  }

  return population;
}

// レイアウトから全文字を取得
function getAllChars(layout: KeyboardLayout): string[] {
  const chars: string[] = [];
  for (const key of layout.keys) {
    chars.push(key.center);
    for (const char of Object.values(key.flicks)) {
      if (char) chars.push(char);
    }
  }
  return chars;
}

// 交叉（構造も考慮した交叉、全文字+特殊キーを保証）
export function crossover(
  parent1: KeyboardLayout,
  parent2: KeyboardLayout,
  config: EvolutionConfig,
  generation: number
): KeyboardLayout {
  // 全文字を必ず使用
  const shuffledChars = shuffle([...ALL_CHARS]);
  let charIndex = 0;

  const keys: KeyConfig[] = [];

  // 全文字を使い切るまでキーを作成
  while (charIndex < shuffledChars.length) {
    // どちらかの親のキー構造を参考にする
    const parentKeyIdx = keys.length;
    const parentKey = Math.random() < 0.5
      ? parent1.keys[parentKeyIdx % parent1.keys.length]
      : parent2.keys[parentKeyIdx % parent2.keys.length];

    // 残り文字数に基づいてフリック数を決定
    const remainingChars = shuffledChars.length - charIndex;
    const baseFlickCount = Object.keys(parentKey.flicks).length;
    const maxPossibleFlicks = Math.min(config.maxFlicksPerKey, remainingChars - 1);
    const flickCount = Math.max(
      config.minFlicksPerKey,
      Math.min(maxPossibleFlicks, baseFlickCount + randInt(-1, 1))
    );

    const flickDirs = randomFlickDirections(flickCount);

    const center = shuffledChars[charIndex++];
    const flicks: Partial<Record<Exclude<FlickDirection, 'center'>, string>> = {};

    for (const dir of flickDirs) {
      if (charIndex < shuffledChars.length) {
        flicks[dir] = shuffledChars[charIndex++];
      }
    }

    // 座標は親から継承（ブレンドまたは選択）
    let x: number, y: number;
    if (Math.random() < 0.5) {
      // 両親の座標をブレンド
      const p1Key = parent1.keys[parentKeyIdx % parent1.keys.length];
      const p2Key = parent2.keys[parentKeyIdx % parent2.keys.length];
      const t = Math.random();
      x = p1Key.x * t + p2Key.x * (1 - t);
      y = p1Key.y * t + p2Key.y * (1 - t);
    } else {
      // 親から継承
      x = parentKey.x;
      y = parentKey.y;
    }

    keys.push({ center, flicks, x, y });
  }

  return {
    id: generateId(),
    keys,
    cols: config.cols,
    generation,
  };
}

// 突然変異（座標の変異を含む、全文字保証）
export function mutate(layout: KeyboardLayout, config: EvolutionConfig): KeyboardLayout {
  const { mutationRate } = config;

  // キーをコピー（座標も含む）
  let newKeys: KeyConfig[] = layout.keys.map(k => ({
    center: k.center,
    flicks: { ...k.flicks },
    x: k.x,
    y: k.y,
  }));

  // 座標の変異
  for (let i = 0; i < newKeys.length; i++) {
    if (Math.random() < mutationRate) {
      // 座標を少しずらす（正規分布的な変動）
      const dx = (Math.random() - 0.5) * 0.3;
      const dy = (Math.random() - 0.5) * 0.3;
      newKeys[i].x = Math.max(0, Math.min(1, newKeys[i].x + dx));
      newKeys[i].y = Math.max(0, Math.min(1, newKeys[i].y + dy));
    }
  }

  // キーの分割・統合（フリック構造の変更）
  // 全文字を保証するため、分割・統合後に文字を再配分
  if (Math.random() < mutationRate * 0.3) {
    // 全文字を集めて再配分
    const allChars = getAllChars({ ...layout, keys: newKeys });
    const shuffledChars = shuffle(allChars);
    let charIndex = 0;

    // 新しいキー構造を作成（キー数は現在と同じか±1）
    const newKeyCount = Math.max(
      Math.ceil(ALL_CHARS.length / 5), // 最低でも全文字が収まるキー数
      newKeys.length + randInt(-1, 1)
    );

    const rebuiltKeys: KeyConfig[] = [];
    while (charIndex < shuffledChars.length) {
      const remainingChars = shuffledChars.length - charIndex;
      const remainingKeys = Math.max(1, newKeyCount - rebuiltKeys.length);
      const avgCharsPerKey = Math.ceil(remainingChars / remainingKeys);
      const flickCount = Math.min(config.maxFlicksPerKey, Math.max(0, avgCharsPerKey - 1));
      const flickDirs = randomFlickDirections(flickCount);

      const center = shuffledChars[charIndex++];
      const flicks: Partial<Record<Exclude<FlickDirection, 'center'>, string>> = {};
      for (const dir of flickDirs) {
        if (charIndex < shuffledChars.length) {
          flicks[dir] = shuffledChars[charIndex++];
        }
      }

      // 座標は既存のキーから継承するか、ランダム
      const existingKey = newKeys[rebuiltKeys.length % newKeys.length];
      rebuiltKeys.push({
        center,
        flicks,
        x: existingKey?.x ?? Math.random(),
        y: existingKey?.y ?? Math.random(),
      });
    }

    newKeys = rebuiltKeys;
  }

  // 文字のスワップ
  const positions: { keyIdx: number; type: 'center' | FlickDirection }[] = [];
  for (let i = 0; i < newKeys.length; i++) {
    positions.push({ keyIdx: i, type: 'center' });
    for (const dir of Object.keys(newKeys[i].flicks) as FlickDirection[]) {
      positions.push({ keyIdx: i, type: dir });
    }
  }

  for (let i = 0; i < positions.length; i++) {
    if (Math.random() < mutationRate) {
      const j = Math.floor(Math.random() * positions.length);
      if (i !== j) {
        const pos1 = positions[i];
        const pos2 = positions[j];

        // 値を取得
        const val1 = pos1.type === 'center'
          ? newKeys[pos1.keyIdx].center
          : newKeys[pos1.keyIdx].flicks[pos1.type as Exclude<FlickDirection, 'center'>];
        const val2 = pos2.type === 'center'
          ? newKeys[pos2.keyIdx].center
          : newKeys[pos2.keyIdx].flicks[pos2.type as Exclude<FlickDirection, 'center'>];

        // スワップ
        if (pos1.type === 'center') {
          newKeys[pos1.keyIdx].center = val2 || '';
        } else {
          newKeys[pos1.keyIdx].flicks[pos1.type as Exclude<FlickDirection, 'center'>] = val2;
        }

        if (pos2.type === 'center') {
          newKeys[pos2.keyIdx].center = val1 || '';
        } else {
          newKeys[pos2.keyIdx].flicks[pos2.type as Exclude<FlickDirection, 'center'>] = val1;
        }
      }
    }
  }

  return {
    ...layout,
    id: generateId(),
    keys: newKeys,
  };
}

// トーナメント選択
export function tournamentSelect(population: KeyboardLayout[], tournamentSize: number = 2): KeyboardLayout {
  let best: KeyboardLayout | null = null;

  for (let i = 0; i < tournamentSize; i++) {
    const index = Math.floor(Math.random() * population.length);
    const candidate = population[index];

    if (!best || (candidate.fitness ?? 0) > (best.fitness ?? 0)) {
      best = candidate;
    }
  }

  return best!;
}

// 次世代を生成
export function evolveNextGeneration(
  population: KeyboardLayout[],
  config: EvolutionConfig
): KeyboardLayout[] {
  const { populationSize, crossoverRate, eliteCount } = config;
  const nextGeneration: KeyboardLayout[] = [];
  const generation = population[0].generation + 1;

  // 適応度でソート
  const sorted = [...population].sort((a, b) => (b.fitness ?? 0) - (a.fitness ?? 0));

  // エリート保存（座標も含む）
  for (let i = 0; i < eliteCount && i < sorted.length; i++) {
    nextGeneration.push({
      ...sorted[i],
      id: generateId(),
      generation,
      keys: sorted[i].keys.map(k => ({
        center: k.center,
        flicks: { ...k.flicks },
        x: k.x,
        y: k.y,
      })),
    });
  }

  // 残りを交叉・突然変異で生成
  while (nextGeneration.length < populationSize) {
    const parent1 = tournamentSelect(sorted);
    const parent2 = tournamentSelect(sorted);

    let offspring: KeyboardLayout;

    if (Math.random() < crossoverRate) {
      offspring = crossover(parent1, parent2, config, generation);
    } else {
      const better = (parent1.fitness ?? 0) >= (parent2.fitness ?? 0) ? parent1 : parent2;
      offspring = {
        ...better,
        id: generateId(),
        keys: better.keys.map(k => ({
          center: k.center,
          flicks: { ...k.flicks },
          x: k.x,
          y: k.y,
        })),
        generation,
      };
    }

    offspring = mutate(offspring, config);
    nextGeneration.push(offspring);
  }

  return nextGeneration;
}

// デフォルトの進化設定
export const DEFAULT_CONFIG: EvolutionConfig = {
  populationSize: 4,
  mutationRate: 0.15,
  crossoverRate: 0.7,
  eliteCount: 1,
  minKeys: 8,
  maxKeys: 12,
  minFlicksPerKey: 0,
  maxFlicksPerKey: 4,
  cols: 3,
};
