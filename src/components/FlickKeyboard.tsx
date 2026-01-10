import { useCallback } from 'react';
import type { KeyboardLayout } from '../types/keyboard';
import { FlickKeyInput } from './FlickKeyInput';

interface FlickKeyboardProps {
  layout: KeyboardLayout;
  onInput: (char: string) => void;
  onBackspace: () => void;
  disabled?: boolean;
}

export function FlickKeyboard({ layout, onInput, onBackspace, disabled }: FlickKeyboardProps) {
  const { keys, cols } = layout;

  const handleInput = useCallback((char: string) => {
    onInput(char);
  }, [onInput]);

  return (
    <div className="inline-block p-4 bg-gray-200 dark:bg-gray-800 rounded-2xl">
      <div
        className="grid gap-2"
        style={{
          gridTemplateColumns: `repeat(${cols}, minmax(0, 1fr))`,
        }}
      >
        {keys.map((key, index) => (
          <FlickKeyInput
            key={index}
            keyConfig={key}
            onInput={handleInput}
            disabled={disabled}
          />
        ))}
      </div>

      {/* 削除ボタン */}
      <div className="mt-3 flex justify-end">
        <button
          onTouchStart={(e) => {
            e.preventDefault();
            if (!disabled) onBackspace();
          }}
          onClick={() => {
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
