import type {
  KeyboardLayout,
  KeyConfig,
  EvolutionConfig,
  FlickDirection,
} from '../types/keyboard';
import { OPTIONAL_FLICK_DIRECTIONS, HIRAGANA_CHARS } from '../types/keyboard';

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

// ランダムなキーボード配置を生成
export function createRandomLayout(config: EvolutionConfig, generation: number): KeyboardLayout {
  const { minKeys, maxKeys, minFlicksPerKey, maxFlicksPerKey, cols } = config;

  // キー数をランダムに決定
  const keyCount = randInt(minKeys, maxKeys);

  // 使用する文字をシャッフル
  const chars = shuffle([...HIRAGANA_CHARS]);
  let charIndex = 0;

  const keys: KeyConfig[] = [];

  for (let i = 0; i < keyCount && charIndex < chars.length; i++) {
    // このキーのフリック数をランダムに決定
    const flickCount = randInt(minFlicksPerKey, maxFlicksPerKey);
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

    keys.push({ center, flicks });
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

// 交叉（構造も考慮した交叉）
export function crossover(
  parent1: KeyboardLayout,
  parent2: KeyboardLayout,
  config: EvolutionConfig,
  generation: number
): KeyboardLayout {
  // キー数を両親の間からランダムに選択
  const keyCount = randInt(
    Math.min(parent1.keys.length, parent2.keys.length),
    Math.max(parent1.keys.length, parent2.keys.length)
  );

  // 両親の文字を集める
  const chars1 = getAllChars(parent1);
  const chars2 = getAllChars(parent2);

  // 両方に含まれる文字をベースに
  const allChars = [...new Set([...chars1, ...chars2])];
  const shuffledChars = shuffle(allChars);
  let charIndex = 0;

  const keys: KeyConfig[] = [];

  for (let i = 0; i < keyCount && charIndex < shuffledChars.length; i++) {
    // どちらかの親のキー構造を参考にする
    const parentKey = Math.random() < 0.5
      ? parent1.keys[i % parent1.keys.length]
      : parent2.keys[i % parent2.keys.length];

    // フリック数は親から継承（少し変動あり）
    const baseFlickCount = Object.keys(parentKey.flicks).length;
    const flickCount = Math.max(
      config.minFlicksPerKey,
      Math.min(config.maxFlicksPerKey, baseFlickCount + randInt(-1, 1))
    );

    const flickDirs = randomFlickDirections(flickCount);

    const center = shuffledChars[charIndex++];
    const flicks: Partial<Record<Exclude<FlickDirection, 'center'>, string>> = {};

    for (const dir of flickDirs) {
      if (charIndex < shuffledChars.length) {
        flicks[dir] = shuffledChars[charIndex++];
      }
    }

    keys.push({ center, flicks });
  }

  return {
    id: generateId(),
    keys,
    cols: config.cols,
    generation,
  };
}

// 突然変異
export function mutate(layout: KeyboardLayout, config: EvolutionConfig): KeyboardLayout {
  const { mutationRate, minFlicksPerKey, maxFlicksPerKey, minKeys, maxKeys } = config;

  // 全文字を収集
  const allChars = getAllChars(layout);

  // キーの追加/削除（低確率）
  let newKeys = layout.keys.map(k => ({
    center: k.center,
    flicks: { ...k.flicks },
  }));

  // キー数の変更（低確率）
  if (Math.random() < mutationRate * 0.5) {
    if (Math.random() < 0.5 && newKeys.length < maxKeys) {
      // キーを追加
      const unusedChars = HIRAGANA_CHARS.filter(c => !allChars.includes(c));
      if (unusedChars.length > 0) {
        const flickCount = randInt(minFlicksPerKey, maxFlicksPerKey);
        const flickDirs = randomFlickDirections(flickCount);
        const flicks: Partial<Record<Exclude<FlickDirection, 'center'>, string>> = {};

        let idx = 0;
        for (const dir of flickDirs) {
          if (idx + 1 < unusedChars.length) {
            flicks[dir] = unusedChars[idx + 1];
            idx++;
          }
        }

        newKeys.push({
          center: unusedChars[0],
          flicks,
        });
      }
    } else if (newKeys.length > minKeys) {
      // キーを削除
      const removeIdx = Math.floor(Math.random() * newKeys.length);
      newKeys.splice(removeIdx, 1);
    }
  }

  // フリック構造の変更
  for (let i = 0; i < newKeys.length; i++) {
    if (Math.random() < mutationRate) {
      const currentFlickCount = Object.keys(newKeys[i].flicks).length;
      const newFlickCount = Math.max(
        minFlicksPerKey,
        Math.min(maxFlicksPerKey, currentFlickCount + randInt(-1, 1))
      );

      if (newFlickCount !== currentFlickCount) {
        const oldFlickChars = Object.values(newKeys[i].flicks).filter(Boolean) as string[];
        const newDirs = randomFlickDirections(newFlickCount);
        const newFlicks: Partial<Record<Exclude<FlickDirection, 'center'>, string>> = {};

        for (let j = 0; j < newDirs.length; j++) {
          newFlicks[newDirs[j]] = oldFlickChars[j] || '';
        }

        newKeys[i].flicks = newFlicks;
      }
    }
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

  // エリート保存
  for (let i = 0; i < eliteCount && i < sorted.length; i++) {
    nextGeneration.push({
      ...sorted[i],
      id: generateId(),
      generation,
      keys: sorted[i].keys.map(k => ({
        center: k.center,
        flicks: { ...k.flicks },
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
