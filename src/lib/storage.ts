import type { EvolutionState, KeyboardLayout, KeyConfig } from '../types/keyboard';

const STORAGE_KEY = 'iec-keyboard-state';

// 古いKeyConfig（座標なし）を新しい形式にマイグレーション
function migrateKeyConfig(key: Partial<KeyConfig>): KeyConfig {
  // 座標がない場合はランダムに配置
  const x = key.x ?? Math.random();
  const y = key.y ?? Math.random();

  return {
    center: key.center || '',
    flicks: key.flicks || {},
    x,
    y,
  };
}

// レイアウトをマイグレーション
function migrateLayout(layout: Partial<KeyboardLayout>): KeyboardLayout {
  const keys = (layout.keys || []).map(key => migrateKeyConfig(key));

  return {
    id: layout.id || Math.random().toString(36).substring(2, 15),
    keys,
    cols: layout.cols || 3,
    generation: layout.generation || 0,
    fitness: layout.fitness,
  };
}

// 状態をマイグレーション
function migrateState(state: Partial<EvolutionState>): EvolutionState {
  return {
    population: (state.population || []).map(migrateLayout),
    generation: state.generation || 0,
    config: state.config || {
      populationSize: 4,
      mutationRate: 0.15,
      crossoverRate: 0.7,
      eliteCount: 1,
      minKeys: 8,
      maxKeys: 12,
      minFlicksPerKey: 0,
      maxFlicksPerKey: 4,
      cols: 3,
    },
    history: (state.history || []).map(h => {
      const bestLayout = migrateLayout(h.bestLayout);
      return {
        generation: h.generation ?? 0,
        bestLayout,
        averageFitness: h.averageFitness ?? 0,
        timestamp: h.timestamp ?? Date.now(),
        // 新しいフィールドにデフォルト値を設定
        allFitness: h.allFitness ?? [h.averageFitness ?? 0],
        minFitness: h.minFitness ?? 0,
        maxFitness: h.maxFitness ?? (bestLayout.fitness ?? 0),
        keyCountStats: h.keyCountStats ?? {
          min: bestLayout.keys.length,
          max: bestLayout.keys.length,
          avg: bestLayout.keys.length,
        },
        optionalCharsInBest: h.optionalCharsInBest ?? [],
        eliteSurvived: h.eliteSurvived ?? true,
      };
    }),
  };
}

// 状態をLocalStorageに保存
export function saveState(state: EvolutionState): void {
  try {
    const json = JSON.stringify(state);
    localStorage.setItem(STORAGE_KEY, json);
  } catch (error) {
    console.error('Failed to save state:', error);
  }
}

// LocalStorageから状態を読み込み（マイグレーション付き）
export function loadState(): EvolutionState | null {
  try {
    const json = localStorage.getItem(STORAGE_KEY);
    if (!json) return null;
    const rawState = JSON.parse(json);
    // 古いデータ形式をマイグレーション
    return migrateState(rawState);
  } catch (error) {
    console.error('Failed to load state:', error);
    return null;
  }
}

// 状態をクリア
export function clearState(): void {
  try {
    localStorage.removeItem(STORAGE_KEY);
  } catch (error) {
    console.error('Failed to clear state:', error);
  }
}

// 状態をJSONファイルとしてエクスポート
export function exportState(state: EvolutionState): void {
  const json = JSON.stringify(state, null, 2);
  const blob = new Blob([json], { type: 'application/json' });
  const url = URL.createObjectURL(blob);

  const a = document.createElement('a');
  a.href = url;
  a.download = `keyboard-evolution-gen${state.generation}.json`;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);
}

// JSONファイルから状態をインポート（マイグレーション付き）
export function importState(file: File): Promise<EvolutionState> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();

    reader.onload = (event) => {
      try {
        const json = event.target?.result as string;
        const rawState = JSON.parse(json);
        // 古いデータ形式をマイグレーション
        resolve(migrateState(rawState));
      } catch (error) {
        reject(new Error('Invalid file format'));
      }
    };

    reader.onerror = () => reject(new Error('Failed to read file'));
    reader.readAsText(file);
  });
}
