import { useCallback, useMemo } from 'react';
import type { KeyboardLayout } from '../types/keyboard';
import { FlickKeyInput } from './FlickKeyInput';

interface FlickKeyboardProps {
  layout: KeyboardLayout;
  onInput: (char: string) => void;
  onBackspace: () => void;
  disabled?: boolean;
}

const KEY_SIZE = 64; // w-16 h-16 = 64px
const PADDING = 8;
const CELL_SIZE = KEY_SIZE + 8; // キーサイズ + マージン

// キー数に応じてグリッドサイズとコンテナサイズを計算
function calculateGridInfo(keyCount: number): { cols: number; rows: number; width: number; height: number } {
  const cols = Math.ceil(Math.sqrt(keyCount * 1.2));
  const rows = Math.ceil(keyCount / cols);

  const width = cols * CELL_SIZE + PADDING * 2;
  const height = rows * CELL_SIZE + PADDING * 2;

  return { cols, rows, width, height };
}

export function FlickKeyboard({ layout, onInput, onBackspace, disabled }: FlickKeyboardProps) {
  const { keys } = layout;

  const handleInput = useCallback((char: string) => {
    onInput(char);
  }, [onInput]);

  // グリッド情報を計算
  const gridInfo = useMemo(() => calculateGridInfo(keys.length), [keys.length]);

  // キーの座標を計算（グリッドセルの中心に配置）
  const keyPositions = useMemo(() => {
    return keys.map(key => {
      // 正規化座標（0-1）からグリッドセルのインデックスを計算
      const col = Math.round(key.x * (gridInfo.cols - 1));
      const row = Math.round(key.y * (gridInfo.rows - 1));

      // セルの中心座標
      const left = PADDING + col * CELL_SIZE + (CELL_SIZE - KEY_SIZE) / 2;
      const top = PADDING + row * CELL_SIZE + (CELL_SIZE - KEY_SIZE) / 2;

      return { left, top };
    });
  }, [keys, gridInfo]);

  return (
    <div className="inline-block p-4 bg-gray-200 dark:bg-gray-800 rounded-2xl">
      <div
        className="relative"
        style={{
          width: gridInfo.width,
          height: gridInfo.height,
        }}
      >
        {keys.map((key, index) => (
          <div
            key={index}
            className="absolute"
            style={{
              left: keyPositions[index].left,
              top: keyPositions[index].top,
            }}
          >
            <FlickKeyInput
              keyConfig={key}
              onInput={handleInput}
              disabled={disabled}
            />
          </div>
        ))}
      </div>

      {/* 削除ボタン */}
      <div className="mt-3 flex justify-end">
        <button
          onPointerDown={(e) => {
            e.preventDefault();
            if (!disabled) onBackspace();
          }}
          disabled={disabled}
          className={`
            px-6 py-3 rounded-xl text-sm font-semibold
            bg-red-100 dark:bg-red-900/50 text-red-700 dark:text-red-300
            active:bg-red-200 dark:active:bg-red-800
            disabled:opacity-50 select-none touch-none
          `}
        >
          削除
        </button>
      </div>
    </div>
  );
}
