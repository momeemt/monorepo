import { useRef } from 'react';
import { useEvolution } from './hooks/useEvolution';
import { KeyboardView } from './components/KeyboardView';
import { TypingTest } from './components/TypingTest';
import { EvolutionAnalysis } from './components/EvolutionAnalysis';
import { exportState, importState } from './lib/storage';
import { getLayoutStats } from './types/keyboard';

function App() {
  const {
    state,
    isTesting,
    currentTestIndex,
    currentLayout,
    currentSentence,
    testResults,
    startTesting,
    recordTestResult,
    evolveWithResults,
    reset,
    importEvolutionState,
  } = useEvolution();

  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleExport = () => {
    exportState(state);
  };

  const handleImport = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (!file) return;

    try {
      const importedState = await importState(file);
      importEvolutionState(importedState);
    } catch {
      alert('ファイルの読み込みに失敗しました');
    }

    if (fileInputRef.current) {
      fileInputRef.current.value = '';
    }
  };

  // テスト完了後の結果表示
  const showResults = !isTesting && testResults.length > 0;

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-gray-100">
      <div className="container mx-auto px-4 py-8 max-w-6xl">
        {/* ヘッダー */}
        <header className="mb-8">
          <h1 className="text-3xl font-bold mb-2">
            日本語キーボード進化計算
          </h1>
          <p className="text-gray-600 dark:text-gray-400">
            タイピング速度でキーボード配置を進化させましょう
          </p>
        </header>

        {/* 情報バー */}
        <div className="flex flex-wrap items-center gap-4 mb-6 p-4 bg-white dark:bg-gray-800 rounded-lg shadow-sm">
          <div className="flex items-center gap-2">
            <span className="text-sm text-gray-500 dark:text-gray-400">世代:</span>
            <span className="font-mono text-lg font-bold">{state.generation}</span>
          </div>
          <div className="flex-grow" />
          <div className="flex gap-2">
            <button
              onClick={handleExport}
              disabled={isTesting}
              className="px-3 py-1.5 text-sm bg-gray-200 dark:bg-gray-700 hover:bg-gray-300 dark:hover:bg-gray-600 rounded-lg transition-colors disabled:opacity-50"
            >
              エクスポート
            </button>
            <button
              onClick={() => fileInputRef.current?.click()}
              disabled={isTesting}
              className="px-3 py-1.5 text-sm bg-gray-200 dark:bg-gray-700 hover:bg-gray-300 dark:hover:bg-gray-600 rounded-lg transition-colors disabled:opacity-50"
            >
              インポート
            </button>
            <input
              ref={fileInputRef}
              type="file"
              accept=".json"
              onChange={handleImport}
              className="hidden"
            />
            <button
              onClick={reset}
              disabled={isTesting}
              className="px-3 py-1.5 text-sm bg-red-100 dark:bg-red-900 text-red-700 dark:text-red-300 hover:bg-red-200 dark:hover:bg-red-800 rounded-lg transition-colors disabled:opacity-50"
            >
              リセット
            </button>
          </div>
        </div>

        {/* テスト中 */}
        {isTesting && currentLayout && (
          <TypingTest
            layout={currentLayout}
            targetSentence={currentSentence}
            onComplete={recordTestResult}
            layoutIndex={currentTestIndex}
            totalLayouts={state.population.length}
          />
        )}

        {/* テスト結果 */}
        {showResults && (
          <div className="mb-8 p-6 bg-white dark:bg-gray-800 rounded-xl shadow-lg">
            <h2 className="text-xl font-semibold mb-4">テスト結果</h2>
            <div className="space-y-2 mb-6">
              {testResults.map((result, index) => {
                const layout = state.population.find(l => l.id === result.layoutId);
                const stats = layout ? getLayoutStats(layout) : null;
                return (
                  <div
                    key={result.layoutId}
                    className="flex items-center justify-between p-3 bg-gray-50 dark:bg-gray-700 rounded-lg"
                  >
                    <div className="flex items-center gap-3">
                      <span>キーボード {index + 1}</span>
                      {stats && (
                        <span className="text-xs text-gray-500 dark:text-gray-400">
                          ({stats.keyCount}キー / {stats.totalSlots}文字)
                        </span>
                      )}
                    </div>
                    <span className="font-mono">
                      {(result.timeMs / 1000).toFixed(2)}秒
                    </span>
                  </div>
                );
              })}
            </div>
            <div className="flex justify-center">
              <button
                onClick={evolveWithResults}
                className="px-8 py-4 text-lg font-semibold rounded-xl bg-blue-600 hover:bg-blue-700 text-white shadow-lg hover:shadow-xl transition-all"
              >
                この結果で次世代へ進化
              </button>
            </div>
          </div>
        )}

        {/* 待機中（テスト開始前） */}
        {!isTesting && !showResults && (
          <>
            {/* 説明 */}
            <div className="mb-6 p-4 bg-blue-50 dark:bg-blue-900/30 rounded-lg border border-blue-200 dark:border-blue-800">
              <h2 className="font-semibold mb-2">使い方</h2>
              <ol className="list-decimal list-inside text-sm text-gray-700 dark:text-gray-300 space-y-1">
                <li>「テスト開始」を押すと、各キーボード配置でタイピングテストが始まります</li>
                <li>表示されるキーボードを見て、その配置でフリック入力するイメージで文章を入力してください</li>
                <li>入力速度が速い配置ほど高評価となり、次世代に引き継がれやすくなります</li>
                <li>キー数やフリック数も進化し、あなたに最適な構造が見つかります</li>
              </ol>
            </div>

            {/* キーボード一覧 */}
            <h2 className="text-xl font-semibold mb-4">現在の配置候補</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
              {state.population.map((layout, index) => (
                <div key={layout.id} className="flex flex-col items-center">
                  <div className="text-sm text-gray-500 dark:text-gray-400 mb-2">
                    #{index + 1}
                  </div>
                  <KeyboardView layout={layout} size="sm" showStats />
                </div>
              ))}
            </div>

            {/* テスト開始ボタン */}
            <div className="flex justify-center">
              <button
                onClick={startTesting}
                className="px-8 py-4 text-lg font-semibold rounded-xl bg-green-600 hover:bg-green-700 text-white shadow-lg hover:shadow-xl transition-all"
              >
                テスト開始
              </button>
            </div>
          </>
        )}

        {/* 進化分析 */}
        {state.history.length > 0 && !isTesting && (
          <div className="mt-12">
            <h2 className="text-xl font-semibold mb-4">進化の履歴と分析</h2>
            <EvolutionAnalysis history={state.history} />
          </div>
        )}
      </div>
    </div>
  );
}

export default App;
