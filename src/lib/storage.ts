import type { EvolutionState } from '../types/keyboard';

const STORAGE_KEY = 'iec-keyboard-state';

// 状態をLocalStorageに保存
export function saveState(state: EvolutionState): void {
  try {
    const json = JSON.stringify(state);
    localStorage.setItem(STORAGE_KEY, json);
  } catch (error) {
    console.error('Failed to save state:', error);
  }
}

// LocalStorageから状態を読み込み
export function loadState(): EvolutionState | null {
  try {
    const json = localStorage.getItem(STORAGE_KEY);
    if (!json) return null;
    return JSON.parse(json) as EvolutionState;
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

// JSONファイルから状態をインポート
export function importState(file: File): Promise<EvolutionState> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();

    reader.onload = (event) => {
      try {
        const json = event.target?.result as string;
        const state = JSON.parse(json) as EvolutionState;
        resolve(state);
      } catch (error) {
        reject(new Error('Invalid file format'));
      }
    };

    reader.onerror = () => reject(new Error('Failed to read file'));
    reader.readAsText(file);
  });
}
