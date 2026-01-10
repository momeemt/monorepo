import { useMemo } from 'react';
import type { GenerationHistory } from '../types/keyboard';
import { DAKUTEN_CHARS, HANDAKUTEN_CHARS, SMALL_CHARS } from '../types/keyboard';
import { KeyboardView } from './KeyboardView';

interface EvolutionAnalysisProps {
  history: GenerationHistory[];
}

// 任意文字をカテゴリ別に分類
function categorizeOptionalChars(chars: string[]): {
  dakuten: string[];
  handakuten: string[];
  small: string[];
} {
  const dakutenSet = new Set<string>(DAKUTEN_CHARS);
  const handakutenSet = new Set<string>(HANDAKUTEN_CHARS);
  const smallSet = new Set<string>(SMALL_CHARS);

  return {
    dakuten: chars.filter(c => dakutenSet.has(c)),
    handakuten: chars.filter(c => handakutenSet.has(c)),
    small: chars.filter(c => smallSet.has(c)),
  };
}

// 簡易ASCII棒グラフ
function renderBar(value: number, max: number, width: number = 20): string {
  const filled = Math.round((value / max) * width);
  return '█'.repeat(filled) + '░'.repeat(width - filled);
}

export function EvolutionAnalysis({ history }: EvolutionAnalysisProps) {
  // 全世代の統計
  const stats = useMemo(() => {
    if (history.length === 0) return null;

    const bestFitnesses = history.map(h => h.maxFitness);
    const avgFitnesses = history.map(h => h.averageFitness);
    const maxOverall = Math.max(...bestFitnesses, 10);

    // フィットネスの改善率
    const fitnessImprovement = history.length > 1
      ? ((bestFitnesses[bestFitnesses.length - 1] - bestFitnesses[0]) / Math.max(bestFitnesses[0], 0.1)) * 100
      : 0;

    // キー数の傾向
    const keyCountTrend = history.length > 1
      ? history[history.length - 1].keyCountStats.avg - history[0].keyCountStats.avg
      : 0;

    return {
      bestFitnesses,
      avgFitnesses,
      maxOverall,
      fitnessImprovement,
      keyCountTrend,
      totalGenerations: history.length,
    };
  }, [history]);

  if (history.length === 0 || !stats) {
    return (
      <div className="p-4 bg-gray-100 dark:bg-gray-800 rounded-lg text-center text-gray-500">
        まだ進化履歴がありません。テストを実行して進化を開始してください。
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* 全体サマリー */}
      <div className="p-4 bg-blue-50 dark:bg-blue-900/30 rounded-lg border border-blue-200 dark:border-blue-800">
        <h3 className="font-semibold mb-3">進化サマリー</h3>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
          <div>
            <div className="text-gray-500 dark:text-gray-400">総世代数</div>
            <div className="text-2xl font-bold">{stats.totalGenerations}</div>
          </div>
          <div>
            <div className="text-gray-500 dark:text-gray-400">最高スコア</div>
            <div className="text-2xl font-bold text-green-600 dark:text-green-400">
              {stats.bestFitnesses[stats.bestFitnesses.length - 1].toFixed(1)}
            </div>
          </div>
          <div>
            <div className="text-gray-500 dark:text-gray-400">スコア改善率</div>
            <div className={`text-2xl font-bold ${stats.fitnessImprovement >= 0 ? 'text-green-600 dark:text-green-400' : 'text-red-600 dark:text-red-400'}`}>
              {stats.fitnessImprovement >= 0 ? '+' : ''}{stats.fitnessImprovement.toFixed(1)}%
            </div>
          </div>
          <div>
            <div className="text-gray-500 dark:text-gray-400">キー数傾向</div>
            <div className="text-2xl font-bold">
              {stats.keyCountTrend >= 0 ? '+' : ''}{stats.keyCountTrend.toFixed(1)}
            </div>
          </div>
        </div>
      </div>

      {/* フィットネス推移グラフ */}
      <div className="p-4 bg-white dark:bg-gray-800 rounded-lg shadow-sm">
        <h3 className="font-semibold mb-3">スコア推移</h3>
        <div className="space-y-2 font-mono text-xs">
          {history.map((entry) => (
            <div key={entry.generation} className="flex items-center gap-2">
              <span className="w-12 text-right text-gray-500">G{entry.generation}</span>
              <span className="text-green-600 dark:text-green-400" title={`最高: ${entry.maxFitness.toFixed(2)}`}>
                {renderBar(entry.maxFitness, stats.maxOverall, 15)}
              </span>
              <span className="w-12 text-right">{entry.maxFitness.toFixed(1)}</span>
              <span className="text-gray-400 text-xs">
                (avg: {entry.averageFitness.toFixed(1)})
              </span>
            </div>
          ))}
        </div>
      </div>

      {/* 世代別詳細分析 */}
      <div className="p-4 bg-white dark:bg-gray-800 rounded-lg shadow-sm">
        <h3 className="font-semibold mb-3">世代別分析</h3>
        <div className="space-y-4">
          {history.slice().reverse().map((entry, reversedIdx) => {
            const idx = history.length - 1 - reversedIdx;
            const prevEntry = idx > 0 ? history[idx - 1] : null;
            const optionalCats = categorizeOptionalChars(entry.optionalCharsInBest || []);

            // 変化の分析
            const fitnessChange = prevEntry
              ? entry.maxFitness - prevEntry.maxFitness
              : 0;
            const keyCountChange = prevEntry
              ? entry.keyCountStats.avg - prevEntry.keyCountStats.avg
              : 0;

            // 選択された特徴の説明
            const features: string[] = [];
            if (entry.bestLayout.keys.length <= 12) {
              features.push('コンパクト配置');
            } else {
              features.push('多キー配置');
            }
            if (optionalCats.dakuten.length > 0) {
              features.push(`濁点個別キー(${optionalCats.dakuten.length})`);
            }
            if (optionalCats.handakuten.length > 0) {
              features.push(`半濁点個別キー(${optionalCats.handakuten.length})`);
            }
            if (optionalCats.small.length > 0) {
              features.push(`小文字個別キー(${optionalCats.small.length})`);
            }
            if (features.length === 1) {
              features.push('変換キー主体');
            }

            return (
              <div key={entry.generation} className="border-l-4 border-blue-500 pl-4 pb-4">
                <div className="flex items-center gap-3 mb-2">
                  <span className="font-bold text-lg">第{entry.generation}世代</span>
                  {fitnessChange !== 0 && (
                    <span className={`text-sm px-2 py-0.5 rounded ${fitnessChange > 0 ? 'bg-green-100 dark:bg-green-900/50 text-green-700 dark:text-green-300' : 'bg-red-100 dark:bg-red-900/50 text-red-700 dark:text-red-300'}`}>
                      スコア {fitnessChange > 0 ? '+' : ''}{fitnessChange.toFixed(2)}
                    </span>
                  )}
                  {entry.eliteSurvived === false && (
                    <span className="text-sm px-2 py-0.5 rounded bg-yellow-100 dark:bg-yellow-900/50 text-yellow-700 dark:text-yellow-300">
                      エリート交代
                    </span>
                  )}
                </div>

                <div className="grid md:grid-cols-2 gap-4">
                  {/* 統計情報 */}
                  <div className="text-sm space-y-1">
                    <div className="text-gray-600 dark:text-gray-400">
                      <span className="font-medium">最高スコア:</span> {entry.maxFitness.toFixed(2)}
                      {prevEntry && (
                        <span className="text-xs ml-2">
                          (前世代: {prevEntry.maxFitness.toFixed(2)})
                        </span>
                      )}
                    </div>
                    <div className="text-gray-600 dark:text-gray-400">
                      <span className="font-medium">平均スコア:</span> {entry.averageFitness.toFixed(2)}
                      <span className="text-xs ml-2">
                        (範囲: {entry.minFitness.toFixed(1)} - {entry.maxFitness.toFixed(1)})
                      </span>
                    </div>
                    <div className="text-gray-600 dark:text-gray-400">
                      <span className="font-medium">キー数:</span> 平均 {entry.keyCountStats.avg.toFixed(1)}
                      <span className="text-xs ml-2">
                        (範囲: {entry.keyCountStats.min} - {entry.keyCountStats.max})
                      </span>
                    </div>

                    {/* 選択された特徴 */}
                    <div className="mt-2">
                      <span className="font-medium text-gray-600 dark:text-gray-400">選択された特徴:</span>
                      <div className="flex flex-wrap gap-1 mt-1">
                        {features.map((f, i) => (
                          <span key={i} className="text-xs px-2 py-0.5 bg-gray-100 dark:bg-gray-700 rounded">
                            {f}
                          </span>
                        ))}
                      </div>
                    </div>

                    {/* 変化の説明 */}
                    {prevEntry && (
                      <div className="mt-2 p-2 bg-gray-50 dark:bg-gray-700/50 rounded text-xs">
                        <span className="font-medium">この世代で起きたこと:</span>
                        <ul className="mt-1 list-disc list-inside text-gray-600 dark:text-gray-400">
                          {fitnessChange > 0.1 && (
                            <li>タイピング速度が向上（より効率的な配置が選択された）</li>
                          )}
                          {fitnessChange < -0.1 && (
                            <li>スコアが低下（新しい配置パターンを探索中）</li>
                          )}
                          {Math.abs(fitnessChange) <= 0.1 && (
                            <li>安定した進化（現在の配置を維持）</li>
                          )}
                          {keyCountChange > 0.5 && (
                            <li>キー数が増加（より多くの個別キーを試行）</li>
                          )}
                          {keyCountChange < -0.5 && (
                            <li>キー数が減少（変換キー主体の配置へ）</li>
                          )}
                          {entry.eliteSurvived === false && (
                            <li>エリートが交代（大きな構造変化）</li>
                          )}
                        </ul>
                      </div>
                    )}
                  </div>

                  {/* キーボードプレビュー */}
                  <div className="flex justify-center">
                    <KeyboardView layout={entry.bestLayout} size="sm" showStats />
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}
