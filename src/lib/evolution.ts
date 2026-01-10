import type {
  KeyboardLayout,
  KeyConfig,
  EvolutionConfig,
  FlickDirection,
} from '../types/keyboard';
import { OPTIONAL_FLICK_DIRECTIONS, REQUIRED_CHARS, OPTIONAL_CHARS } from '../types/keyboard';

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

// グリッドベースの座標を生成（完全に重ならないように）
function generateGridPositions(keyCount: number): { x: number; y: number }[] {
  // キー数に応じてグリッドサイズを計算
  const cols = Math.ceil(Math.sqrt(keyCount * 1.2)); // 少し横長に
  const rows = Math.ceil(keyCount / cols);

  // グリッドの全セルを生成
  const allCells: { x: number; y: number }[] = [];
  for (let row = 0; row < rows; row++) {
    for (let col = 0; col < cols; col++) {
      // 各セルの中心座標（0-1に正規化、端のマージンを考慮）
      const x = cols === 1 ? 0.5 : col / (cols - 1);
      const y = rows === 1 ? 0.5 : row / (rows - 1);
      allCells.push({ x, y });
    }
  }

  // セルをシャッフルして必要な数だけ取得
  const shuffledCells = shuffle(allCells);
  return shuffledCells.slice(0, keyCount);
}

// ランダムに任意文字を選択（0〜全部）
function selectOptionalChars(): string[] {
  const selected: string[] = [];
  for (const char of OPTIONAL_CHARS) {
    // 30%の確率で任意文字を追加
    if (Math.random() < 0.3) {
      selected.push(char);
    }
  }
  return selected;
}

// ランダムなキーボード配置を生成（必須文字は必ず、任意文字はランダムに）
export function createRandomLayout(config: EvolutionConfig, generation: number): KeyboardLayout {
  const { minFlicksPerKey, maxFlicksPerKey, cols } = config;

  // 必須文字（基本46 + 変換キー3 = 49）+ ランダムな任意文字
  const optionalSelected = selectOptionalChars();
  const chars = shuffle([...REQUIRED_CHARS, ...optionalSelected]);
  let charIndex = 0;

  // まずキーの数を計算
  const tempKeys: { center: string; flickCount: number }[] = [];
  let tempCharIndex = 0;
  while (tempCharIndex < chars.length) {
    const remainingChars = chars.length - tempCharIndex;
    const maxPossibleFlicks = Math.min(maxFlicksPerKey, remainingChars - 1);
    const flickCount = randInt(minFlicksPerKey, Math.max(minFlicksPerKey, maxPossibleFlicks));
    tempKeys.push({ center: chars[tempCharIndex], flickCount });
    tempCharIndex += 1 + flickCount;
  }

  // 重ならない座標を生成
  const positions = generateGridPositions(tempKeys.length);

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

    // 重ならない座標を割り当て
    const pos = positions[keys.length] || { x: Math.random(), y: Math.random() };
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

// レイアウトから任意文字を抽出
function getOptionalCharsFromLayout(layout: KeyboardLayout): string[] {
  const allChars = getAllChars(layout);
  const optionalSet = new Set(OPTIONAL_CHARS as readonly string[]);
  return allChars.filter(c => optionalSet.has(c));
}

// 交叉（構造も考慮した交叉、必須文字を保証、任意文字は親から継承）
export function crossover(
  parent1: KeyboardLayout,
  parent2: KeyboardLayout,
  config: EvolutionConfig,
  generation: number
): KeyboardLayout {
  // 両親の任意文字を収集し、ランダムに選択
  const p1Optional = getOptionalCharsFromLayout(parent1);
  const p2Optional = getOptionalCharsFromLayout(parent2);
  const combinedOptional = [...new Set([...p1Optional, ...p2Optional])];

  // 両親の任意文字からランダムに継承（50%の確率で各文字を継承）
  const inheritedOptional = combinedOptional.filter(() => Math.random() < 0.5);

  // 必須文字 + 継承した任意文字
  const shuffledChars = shuffle([...REQUIRED_CHARS, ...inheritedOptional]);

  // まずキーの数を計算
  let tempCharIndex = 0;
  let keyCount = 0;
  while (tempCharIndex < shuffledChars.length) {
    const remainingChars = shuffledChars.length - tempCharIndex;
    const parentKey = parent1.keys[keyCount % parent1.keys.length];
    const baseFlickCount = Object.keys(parentKey.flicks).length;
    const maxPossibleFlicks = Math.min(config.maxFlicksPerKey, remainingChars - 1);
    const flickCount = Math.max(
      config.minFlicksPerKey,
      Math.min(maxPossibleFlicks, baseFlickCount + randInt(-1, 1))
    );
    tempCharIndex += 1 + flickCount;
    keyCount++;
  }

  // 重ならない座標を生成
  const positions = generateGridPositions(keyCount);

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

    // 重ならない座標を使用
    const pos = positions[keys.length] || { x: Math.random(), y: Math.random() };
    keys.push({ center, flicks, x: pos.x, y: pos.y });
  }

  return {
    id: generateId(),
    keys,
    cols: config.cols,
    generation,
  };
}

// 突然変異（座標の変異、任意文字の追加/削除を含む、必須文字は保証）
export function mutate(layout: KeyboardLayout, config: EvolutionConfig): KeyboardLayout {
  const { mutationRate } = config;

  // 現在の文字を収集
  const currentChars = getAllChars(layout);
  const optionalSet = new Set(OPTIONAL_CHARS as readonly string[]);

  // 現在の任意文字を抽出
  const currentOptional = currentChars.filter(c => optionalSet.has(c));

  // 任意文字の追加/削除（突然変異）
  let newOptional = [...currentOptional];

  // 任意文字の追加（持っていないものから）
  if (Math.random() < mutationRate * 0.5) {
    const notOwned = OPTIONAL_CHARS.filter(c => !currentOptional.includes(c));
    if (notOwned.length > 0) {
      const toAdd = notOwned[Math.floor(Math.random() * notOwned.length)];
      newOptional.push(toAdd);
    }
  }

  // 任意文字の削除
  if (Math.random() < mutationRate * 0.5 && newOptional.length > 0) {
    const removeIdx = Math.floor(Math.random() * newOptional.length);
    newOptional.splice(removeIdx, 1);
  }

  // 必須文字が全て含まれていることを確認し、再構築
  const allChars = shuffle([...REQUIRED_CHARS, ...newOptional]);
  let charIndex = 0;

  // キーの座標を保持するためのマップ
  const oldPositions = layout.keys.map(k => ({ x: k.x, y: k.y }));

  let newKeys: KeyConfig[] = [];

  // 全文字を使い切るまでキーを作成
  while (charIndex < allChars.length) {
    const remainingChars = allChars.length - charIndex;
    const avgCharsPerKey = Math.ceil(remainingChars / Math.max(1, Math.ceil(REQUIRED_CHARS.length / 5) - newKeys.length));
    const flickCount = Math.min(config.maxFlicksPerKey, Math.max(0, avgCharsPerKey - 1));
    const flickDirs = randomFlickDirections(flickCount);

    const center = allChars[charIndex++];
    const flicks: Partial<Record<Exclude<FlickDirection, 'center'>, string>> = {};
    for (const dir of flickDirs) {
      if (charIndex < allChars.length) {
        flicks[dir] = allChars[charIndex++];
      }
    }

    // 座標は既存のキーから継承するか、ランダム
    const oldPos = oldPositions[newKeys.length % oldPositions.length];
    let x = oldPos?.x ?? Math.random();
    let y = oldPos?.y ?? Math.random();

    // 座標の変異
    if (Math.random() < mutationRate) {
      const dx = (Math.random() - 0.5) * 0.3;
      const dy = (Math.random() - 0.5) * 0.3;
      x = Math.max(0, Math.min(1, x + dx));
      y = Math.max(0, Math.min(1, y + dy));
    }

    newKeys.push({ center, flicks, x, y });
  }

  // 文字のスワップ（位置の入れ替え）
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

// トーナメント選択（サイズを大きくすると選択圧が強くなる）
export function tournamentSelect(population: KeyboardLayout[], tournamentSize: number = 3): KeyboardLayout {
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
  maxFlicksPerKey: 8,
  cols: 3,
};
