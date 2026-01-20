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
import { calculateWeightedScore } from '../lib/japaneseBigrams';
import type { TypingTestResult } from '../components/TypingTest';

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

// テスト結果（拡張版）
export interface TestResult {
  layoutId: string;
  timeMs: number;
  intervals: number[];      // 文字間の入力間隔
  inputText: string;        // 入力されたテキスト
  bigramScore: number;      // バイグラム重み付きスコア
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
  const recordTestResult = useCallback((result: TypingTestResult) => {
    const currentLayout = state.population[currentTestIndex];

    // バイグラム重み付きスコアを計算
    const bigramResult = calculateWeightedScore(result.inputText, result.intervals);

    setTestResults((prev) => [
      ...prev,
      {
        layoutId: currentLayout.id,
        timeMs: result.timeMs,
        intervals: result.intervals,
        inputText: result.inputText,
        bigramScore: bigramResult.totalScore,
      },
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
      // スキップ（999999ms）を除外して統計を計算
      const SKIP_TIME = 999999;
      const normalResults = testResults.filter((r) => r.timeMs < SKIP_TIME);

      if (normalResults.length === 0) {
        // 全員スキップした場合は全員同じ低スコア
        const evaluatedPopulation = prev.population.map((layout) => ({
          ...layout,
          fitness: 0,
        }));
        return {
          ...prev,
          population: evaluatedPopulation,
        };
      }

      const times = normalResults.map((r) => r.timeMs);
      const minTime = Math.min(...times);
      const maxTime = Math.max(...times);
      const timeRange = maxTime - minTime;

      // バイグラムスコアの統計
      const bigramScores = normalResults.map((r) => r.bigramScore);
      const maxBigramScore = Math.max(...bigramScores, 1);

      // 時間でソートしてランキングを作成
      const sortedResults = [...normalResults].sort((a, b) => a.timeMs - b.timeMs);
      const rankMap = new Map<string, number>();
      sortedResults.forEach((r, idx) => {
        rankMap.set(r.layoutId, idx + 1);
      });

      const evaluatedPopulation = prev.population.map((layout) => {
        const result = testResults.find((r) => r.layoutId === layout.id);
        if (!result) return { ...layout, fitness: 0 };

        // スキップした場合は最低スコア（0）
        if (result.timeMs >= SKIP_TIME) {
          return { ...layout, fitness: 0 };
        }

        // === 速度重視のフィットネス計算 ===
        // 1. 時間差を強調（指数関数的に速いものを優遇）
        // 2. ランキングベースのボーナス
        // 3. バイグラム重み付きスコア（頻出パターンの入力速度）

        // 正規化された速度スコア（0-1、速い=1）
        const normalizedSpeed = timeRange > 0
          ? (maxTime - result.timeMs) / timeRange
          : 0.5;

        // 指数関数で差を強調（速いものをより高く評価）
        const exponentialScore = Math.exp(2 * normalizedSpeed) - 1;

        // ランキングボーナス（1位: +3, 2位: +2, 3位: +1, 4位以降: +0）
        const rank = rankMap.get(result.layoutId) || normalResults.length;
        const rankBonus = Math.max(0, 4 - rank);

        // バイグラムスコア（頻出パターンを速く入力できるほど高評価）
        // 0-3の範囲に正規化
        const normalizedBigramScore = (result.bigramScore / maxBigramScore) * 3;

        // 最終スコア計算:
        // - 速度の指数スコア（0-6.4）: 40%
        // - ランキングボーナス（0-3）: 30%
        // - バイグラムスコア（0-3）: 30%
        // 合計 0-12.4 を 1-10 に正規化
        const rawFitness = exponentialScore + rankBonus + normalizedBigramScore;
        const fitness = 1 + (rawFitness / 12.4) * 9;

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
