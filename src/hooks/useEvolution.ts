import { useState, useEffect, useCallback } from 'react';
import type {
  EvolutionState,
  EvolutionConfig,
  GenerationHistory,
  KeyboardLayout,
} from '../types/keyboard';
import { OPTIONAL_CHARS } from '../types/keyboard';
import {
  createInitialPopulation,
  evolveNextGeneration,
  DEFAULT_CONFIG,
} from '../lib/evolution';
import { saveState, loadState, clearState } from '../lib/storage';
import { getRandomSentences, resetSentenceHistory } from '../lib/sentences';

// レイアウトから任意文字を取得
function getOptionalCharsFromLayout(layout: KeyboardLayout): string[] {
  const optionalSet = new Set(OPTIONAL_CHARS as readonly string[]);
  const chars: string[] = [];
  for (const key of layout.keys) {
    if (optionalSet.has(key.center)) chars.push(key.center);
    for (const char of Object.values(key.flicks)) {
      if (char && optionalSet.has(char)) chars.push(char);
    }
  }
  return chars;
}

// テスト結果
export interface TestResult {
  layoutId: string;
  timeMs: number;
}

export function useEvolution(customConfig?: Partial<EvolutionConfig>) {
  const config: EvolutionConfig = { ...DEFAULT_CONFIG, ...customConfig };

  const [state, setState] = useState<EvolutionState>(() => {
    const saved = loadState();
    if (saved) {
      return saved;
    }
    return {
      population: createInitialPopulation(config),
      generation: 0,
      config,
      history: [],
    };
  });

  // テストモード状態
  const [isTesting, setIsTesting] = useState(false);
  const [currentTestIndex, setCurrentTestIndex] = useState(0);
  const [testResults, setTestResults] = useState<TestResult[]>([]);
  const [testSentences, setTestSentences] = useState<string[]>([]);

  // 状態変更時に自動保存
  useEffect(() => {
    saveState(state);
  }, [state]);

  // テスト開始
  const startTesting = useCallback(() => {
    // 各キーボードに異なる文章を割り当て
    const sentences = getRandomSentences(state.population.length);
    setTestSentences(sentences);
    setTestResults([]);
    setCurrentTestIndex(0);
    setIsTesting(true);
  }, [state.population.length]);

  // テスト結果を記録
  const recordTestResult = useCallback((timeMs: number) => {
    const currentLayout = state.population[currentTestIndex];

    setTestResults((prev) => [
      ...prev,
      { layoutId: currentLayout.id, timeMs },
    ]);

    // 次のキーボードへ
    if (currentTestIndex < state.population.length - 1) {
      setTimeout(() => {
        setCurrentTestIndex((prev) => prev + 1);
      }, 500);
    } else {
      // 全テスト完了
      setTimeout(() => {
        setIsTesting(false);
      }, 500);
    }
  }, [currentTestIndex, state.population]);

  // テスト完了後に進化を実行
  const evolveWithResults = useCallback(() => {
    if (testResults.length === 0) return;

    setState((prev) => {
      // スキップ（999999ms）を除外して最大時間を計算
      const SKIP_TIME = 999999;
      const normalResults = testResults.filter((r) => r.timeMs < SKIP_TIME);
      const maxTime = normalResults.length > 0
        ? Math.max(...normalResults.map((r) => r.timeMs))
        : 10000; // 全員スキップした場合のデフォルト

      const evaluatedPopulation = prev.population.map((layout) => {
        const result = testResults.find((r) => r.layoutId === layout.id);
        if (!result) return { ...layout, fitness: 0 };

        // スキップした場合は最低スコア（0）
        if (result.timeMs >= SKIP_TIME) {
          return { ...layout, fitness: 0 };
        }

        // 時間を反転してフィットネスに（速い = 高スコア）
        const fitness = 1 + (9 * (maxTime - result.timeMs)) / maxTime;
        return { ...layout, fitness };
      });

      // 履歴を更新
      const sortedPopulation = [...evaluatedPopulation].sort(
        (a, b) => (b.fitness ?? 0) - (a.fitness ?? 0)
      );
      const bestLayout = sortedPopulation[0];
      const allFitness = evaluatedPopulation.map(l => l.fitness ?? 0);
      const avgFitness = allFitness.reduce((sum, f) => sum + f, 0) / allFitness.length;
      const minFitness = Math.min(...allFitness);
      const maxFitness = Math.max(...allFitness);

      // キー数統計
      const keyCounts = evaluatedPopulation.map(l => l.keys.length);
      const keyCountStats = {
        min: Math.min(...keyCounts),
        max: Math.max(...keyCounts),
        avg: keyCounts.reduce((sum, c) => sum + c, 0) / keyCounts.length,
      };

      // 最良個体の任意文字
      const optionalCharsInBest = getOptionalCharsFromLayout(bestLayout);

      // エリートが生存したか（前世代のベストが今世代にも残っているか）
      const prevBest = prev.history.length > 0 ? prev.history[prev.history.length - 1].bestLayout : null;
      const eliteSurvived = prevBest ? sortedPopulation.some(l =>
        l.keys.length === prevBest.keys.length &&
        l.keys[0]?.center === prevBest.keys[0]?.center
      ) : true;

      const historyEntry: GenerationHistory = {
        generation: prev.generation,
        bestLayout,
        averageFitness: avgFitness,
        timestamp: Date.now(),
        allFitness,
        minFitness,
        maxFitness,
        keyCountStats,
        optionalCharsInBest,
        eliteSurvived,
      };

      // 次世代を生成
      const nextPopulation = evolveNextGeneration(evaluatedPopulation, prev.config);

      return {
        ...prev,
        population: nextPopulation,
        generation: prev.generation + 1,
        history: [...prev.history, historyEntry],
      };
    });

    // 結果をリセット
    setTestResults([]);
    setCurrentTestIndex(0);
  }, [testResults]);

  // リセット（最初からやり直し）
  const reset = useCallback(() => {
    clearState();
    resetSentenceHistory();
    setState({
      population: createInitialPopulation(config),
      generation: 0,
      config,
      history: [],
    });
    setTestResults([]);
    setCurrentTestIndex(0);
    setIsTesting(false);
  }, [config]);

  // 状態をインポート
  const importEvolutionState = useCallback((newState: EvolutionState) => {
    setState(newState);
    setTestResults([]);
    setCurrentTestIndex(0);
    setIsTesting(false);
  }, []);

  // 現在のテスト対象
  const currentLayout = isTesting ? state.population[currentTestIndex] : null;
  const currentSentence = isTesting ? testSentences[currentTestIndex] : '';

  return {
    state,
    // テスト関連
    isTesting,
    currentTestIndex,
    currentLayout,
    currentSentence,
    testResults,
    startTesting,
    recordTestResult,
    evolveWithResults,
    // その他
    reset,
    importEvolutionState,
  };
}
