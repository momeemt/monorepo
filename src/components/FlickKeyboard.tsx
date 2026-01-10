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
const PADDING = 16;
const GAP = 4; // キー間の最小間隔

// キー数に応じてコンテナサイズを計算
function calculateContainerSize(keyCount: number): { width: number; height: number } {
  const cols = Math.ceil(Math.sqrt(keyCount * 1.2));
  const rows = Math.ceil(keyCount / cols);

  const width = cols * (KEY_SIZE + GAP) + PADDING * 2;
  const height = rows * (KEY_SIZE + GAP) + PADDING * 2;

  return { width, height };
}

export function FlickKeyboard({ layout, onInput, onBackspace, disabled }: FlickKeyboardProps) {
  const { keys } = layout;

  const handleInput = useCallback((char: string) => {
    onInput(char);
  }, [onInput]);

  // コンテナサイズを動的に計算
  const containerSize = useMemo(() => calculateContainerSize(keys.length), [keys.length]);

  // キーの座標を計算（重なりを考慮してスケール調整）
  const keyPositions = useMemo(() => {
    const effectiveWidth = containerSize.width - KEY_SIZE - PADDING * 2;
    const effectiveHeight = containerSize.height - KEY_SIZE - PADDING * 2;

    return keys.map(key => ({
      left: PADDING + key.x * effectiveWidth,
      top: PADDING + key.y * effectiveHeight,
    }));
  }, [keys, containerSize]);

  return (
    <div className="inline-block p-4 bg-gray-200 dark:bg-gray-800 rounded-2xl">
      <div
        className="relative"
        style={{
          width: containerSize.width,
          height: containerSize.height,
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
