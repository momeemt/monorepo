import { useCallback, useMemo } from 'react';
import type { KeyboardLayout } from '../types/keyboard';
import { FlickKeyInput } from './FlickKeyInput';

interface FlickKeyboardProps {
  layout: KeyboardLayout;
  onInput: (char: string) => void;
  onBackspace: () => void;
  disabled?: boolean;
}

// キーボードコンテナのサイズ（ピクセル）
const CONTAINER_WIDTH = 320;
const CONTAINER_HEIGHT = 400;
const KEY_SIZE = 64; // w-16 h-16 = 64px
const PADDING = 16;

export function FlickKeyboard({ layout, onInput, onBackspace, disabled }: FlickKeyboardProps) {
  const { keys } = layout;

  const handleInput = useCallback((char: string) => {
    onInput(char);
  }, [onInput]);

  // キーの座標を計算（重なりを考慮してスケール調整）
  const keyPositions = useMemo(() => {
    const effectiveWidth = CONTAINER_WIDTH - KEY_SIZE - PADDING * 2;
    const effectiveHeight = CONTAINER_HEIGHT - KEY_SIZE - PADDING * 2;

    return keys.map(key => ({
      left: PADDING + key.x * effectiveWidth,
      top: PADDING + key.y * effectiveHeight,
    }));
  }, [keys]);

  return (
    <div className="inline-block p-4 bg-gray-200 dark:bg-gray-800 rounded-2xl">
      <div
        className="relative"
        style={{
          width: CONTAINER_WIDTH,
          height: CONTAINER_HEIGHT,
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
