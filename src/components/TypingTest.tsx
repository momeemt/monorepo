import { useState, useEffect, useCallback } from 'react';
import type { KeyboardLayout } from '../types/keyboard';
import { FlickKeyboard } from './FlickKeyboard';
import { getLayoutStats, SPECIAL_KEYS, DAKUTEN_MAP, HANDAKUTEN_MAP, SMALL_MAP } from '../types/keyboard';

interface TypingTestProps {
  layout: KeyboardLayout;
  targetSentence: string;
  onComplete: (timeMs: number) => void;
  layoutIndex: number;
  totalLayouts: number;
}

export function TypingTest({
  layout,
  targetSentence,
  onComplete,
  layoutIndex,
  totalLayouts,
}: TypingTestProps) {
  const [input, setInput] = useState('');
  const [startTime, setStartTime] = useState<number | null>(null);
  const [isComplete, setIsComplete] = useState(false);

  const stats = getLayoutStats(layout);

  // 入力リセット（新しいレイアウト/文章時）
  useEffect(() => {
    setInput('');
    setStartTime(null);
    setIsComplete(false);
  }, [layout.id, targetSentence]);

  // 文字入力
  const handleInput = useCallback((char: string) => {
    if (isComplete) return;

    // 最初の入力で計測開始
    if (startTime === null) {
      setStartTime(Date.now());
    }

    let newInput = input;

    // 特殊キー（変換キー）の処理
    if (char === SPECIAL_KEYS.DAKUTEN) {
      // 濁点変換：最後の文字を濁点付きに変換
      if (input.length > 0) {
        const lastChar = input[input.length - 1];
        const converted = DAKUTEN_MAP[lastChar];
        if (converted) {
          newInput = input.slice(0, -1) + converted;
        }
      }
    } else if (char === SPECIAL_KEYS.HANDAKUTEN) {
      // 半濁点変換：最後の文字を半濁点付きに変換
      if (input.length > 0) {
        const lastChar = input[input.length - 1];
        const converted = HANDAKUTEN_MAP[lastChar];
        if (converted) {
          newInput = input.slice(0, -1) + converted;
        }
      }
    } else if (char === SPECIAL_KEYS.SMALL) {
      // 小文字変換：最後の文字を小文字に変換
      if (input.length > 0) {
        const lastChar = input[input.length - 1];
        const converted = SMALL_MAP[lastChar];
        if (converted) {
          newInput = input.slice(0, -1) + converted;
        }
      }
    } else {
      // 通常の文字入力
      newInput = input + char;
    }

    setInput(newInput);

    // 完了チェック
    if (newInput === targetSentence) {
      const endTime = Date.now();
      const elapsed = endTime - (startTime ?? endTime);
      setIsComplete(true);
      onComplete(elapsed);
    }
  }, [input, startTime, targetSentence, onComplete, isComplete]);

  // 削除
  const handleBackspace = useCallback(() => {
    if (isComplete) return;
    setInput(prev => prev.slice(0, -1));
  }, [isComplete]);

  // 入力文字の正誤を判定
  const renderTargetSentence = () => {
    return targetSentence.split('').map((char, index) => {
      let className = 'text-gray-400 dark:text-gray-500'; // 未入力

      if (index < input.length) {
        if (input[index] === char) {
          className = 'text-green-600 dark:text-green-400'; // 正解
        } else {
          className = 'text-red-600 dark:text-red-400 bg-red-100 dark:bg-red-900/30 rounded'; // 間違い
        }
      } else if (index === input.length) {
        // 次に入力する文字
        className = 'text-blue-600 dark:text-blue-400 underline';
      }

      return (
        <span key={index} className={className}>
          {char}
        </span>
      );
    });
  };

  return (
    <div className="flex flex-col items-center gap-4 p-4">
      {/* 進捗 */}
      <div className="text-sm text-gray-500 dark:text-gray-400">
        キーボード {layoutIndex + 1} / {totalLayouts}
        <span className="ml-2">({stats.keyCount}キー / {stats.totalSlots}文字)</span>
      </div>

      {/* ターゲット文章 */}
      <div className="text-center p-4 bg-white dark:bg-gray-800 rounded-xl shadow-sm w-full max-w-md">
        <div className="text-2xl font-bold tracking-wide leading-relaxed">
          {renderTargetSentence()}
        </div>
      </div>

      {/* 入力済み表示 */}
      <div className="h-8 text-xl font-mono text-gray-600 dark:text-gray-300">
        {input || <span className="text-gray-400">（ここに表示されます）</span>}
      </div>

      {/* 完了メッセージ */}
      {isComplete && (
        <div className="text-green-600 dark:text-green-400 font-semibold text-lg animate-pulse">
          完了！次のキーボードへ...
        </div>
      )}

      {/* フリックキーボード */}
      <FlickKeyboard
        layout={layout}
        onInput={handleInput}
        onBackspace={handleBackspace}
        disabled={isComplete}
      />

      {/* ヒント */}
      <div className="text-xs text-gray-400 dark:text-gray-500 text-center max-w-xs">
        キーをタップで中央の文字、スワイプで周囲の文字を入力
      </div>
    </div>
  );
}
