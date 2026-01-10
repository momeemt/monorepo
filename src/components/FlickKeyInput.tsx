import { useState, useRef, useCallback } from 'react';
import type { KeyConfig, FlickDirection } from '../types/keyboard';

interface FlickKeyInputProps {
  keyConfig: KeyConfig;
  onInput: (char: string) => void;
  disabled?: boolean;
}

const FLICK_THRESHOLD = 30; // スワイプと判定する最小距離（px）

export function FlickKeyInput({ keyConfig, onInput, disabled }: FlickKeyInputProps) {
  const { center, flicks } = keyConfig;
  const [activeDirection, setActiveDirection] = useState<FlickDirection | null>(null);
  const touchStartRef = useRef<{ x: number; y: number } | null>(null);

  // 方向を判定
  const getDirection = (dx: number, dy: number): FlickDirection => {
    const distance = Math.sqrt(dx * dx + dy * dy);

    if (distance < FLICK_THRESHOLD) {
      return 'center';
    }

    // 角度から方向を判定
    const angle = Math.atan2(dy, dx) * (180 / Math.PI);

    if (angle >= -45 && angle < 45) {
      return 'right';
    } else if (angle >= 45 && angle < 135) {
      return 'down';
    } else if (angle >= -135 && angle < -45) {
      return 'up';
    } else {
      return 'left';
    }
  };

  // その方向の文字を取得
  const getCharForDirection = (dir: FlickDirection): string | null => {
    if (dir === 'center') {
      return center;
    }
    return flicks[dir] || null;
  };

  const handleTouchStart = useCallback((e: React.TouchEvent) => {
    if (disabled) return;
    e.preventDefault();
    const touch = e.touches[0];
    touchStartRef.current = { x: touch.clientX, y: touch.clientY };
    setActiveDirection('center');
  }, [disabled]);

  const handleTouchMove = useCallback((e: React.TouchEvent) => {
    if (disabled || !touchStartRef.current) return;
    e.preventDefault();
    const touch = e.touches[0];
    const dx = touch.clientX - touchStartRef.current.x;
    const dy = touch.clientY - touchStartRef.current.y;
    const dir = getDirection(dx, dy);
    setActiveDirection(dir);
  }, [disabled]);

  const handleTouchEnd = useCallback((e: React.TouchEvent) => {
    if (disabled || !touchStartRef.current) return;
    e.preventDefault();

    if (activeDirection) {
      const char = getCharForDirection(activeDirection);
      if (char) {
        onInput(char);
      }
    }

    touchStartRef.current = null;
    setActiveDirection(null);
  }, [disabled, activeDirection, onInput, center, flicks]);

  // アクティブな方向の文字をハイライト
  const activeChar = activeDirection ? getCharForDirection(activeDirection) : null;

  return (
    <div
      onTouchStart={handleTouchStart}
      onTouchMove={handleTouchMove}
      onTouchEnd={handleTouchEnd}
      className={`
        w-16 h-16 relative select-none touch-none
        bg-gray-100 dark:bg-gray-700 rounded-xl
        border-2 transition-all duration-75
        ${activeDirection
          ? 'border-blue-500 bg-blue-50 dark:bg-blue-900/30 scale-110'
          : 'border-gray-300 dark:border-gray-600'
        }
        ${disabled ? 'opacity-50' : 'active:scale-95'}
      `}
    >
      {/* 中央 */}
      <span
        className={`
          absolute inset-0 flex items-center justify-center
          text-lg font-bold transition-all
          ${activeDirection === 'center' ? 'text-blue-600 dark:text-blue-400 scale-125' : 'text-gray-800 dark:text-gray-100'}
        `}
      >
        {center}
      </span>

      {/* 上 */}
      {flicks.up && (
        <span
          className={`
            absolute top-0.5 left-1/2 -translate-x-1/2
            text-xs transition-all
            ${activeDirection === 'up' ? 'text-blue-600 dark:text-blue-400 scale-125 font-bold' : 'text-gray-500 dark:text-gray-400'}
          `}
        >
          {flicks.up}
        </span>
      )}

      {/* 右 */}
      {flicks.right && (
        <span
          className={`
            absolute right-0.5 top-1/2 -translate-y-1/2
            text-xs transition-all
            ${activeDirection === 'right' ? 'text-blue-600 dark:text-blue-400 scale-125 font-bold' : 'text-gray-500 dark:text-gray-400'}
          `}
        >
          {flicks.right}
        </span>
      )}

      {/* 下 */}
      {flicks.down && (
        <span
          className={`
            absolute bottom-0.5 left-1/2 -translate-x-1/2
            text-xs transition-all
            ${activeDirection === 'down' ? 'text-blue-600 dark:text-blue-400 scale-125 font-bold' : 'text-gray-500 dark:text-gray-400'}
          `}
        >
          {flicks.down}
        </span>
      )}

      {/* 左 */}
      {flicks.left && (
        <span
          className={`
            absolute left-0.5 top-1/2 -translate-y-1/2
            text-xs transition-all
            ${activeDirection === 'left' ? 'text-blue-600 dark:text-blue-400 scale-125 font-bold' : 'text-gray-500 dark:text-gray-400'}
          `}
        >
          {flicks.left}
        </span>
      )}

      {/* フィードバック表示 */}
      {activeDirection && activeChar && (
        <div className="absolute -top-10 left-1/2 -translate-x-1/2 px-3 py-1 bg-blue-600 text-white rounded-lg text-lg font-bold shadow-lg">
          {activeChar}
        </div>
      )}
    </div>
  );
}
