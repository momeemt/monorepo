import { useMemo } from 'react';
import type { KeyboardLayout } from '../types/keyboard';
import { getLayoutStats } from '../types/keyboard';
import { FlickKey } from './FlickKey';

interface KeyboardViewProps {
  layout: KeyboardLayout;
  selected?: boolean;
  onClick?: () => void;
  size?: 'sm' | 'md' | 'lg';
  showStats?: boolean;
}

// サイズごとのキーサイズとパディング
const sizeConfig = {
  sm: { keySize: 40, padding: 6, gap: 2 },
  md: { keySize: 48, padding: 8, gap: 3 },
  lg: { keySize: 56, padding: 10, gap: 4 },
};

// キー数に応じてコンテナサイズを計算
function calculateContainerSize(keyCount: number, keySize: number, padding: number, gap: number): { width: number; height: number } {
  const cols = Math.ceil(Math.sqrt(keyCount * 1.2));
  const rows = Math.ceil(keyCount / cols);

  const width = cols * (keySize + gap) + padding * 2;
  const height = rows * (keySize + gap) + padding * 2;

  return { width, height };
}

export function KeyboardView({
  layout,
  selected,
  onClick,
  size = 'md',
  showStats = false,
}: KeyboardViewProps) {
  const { keys } = layout;
  const stats = getLayoutStats(layout);
  const config = sizeConfig[size];

  // コンテナサイズを動的に計算
  const containerSize = useMemo(
    () => calculateContainerSize(keys.length, config.keySize, config.padding, config.gap),
    [keys.length, config]
  );

  // キーの座標を計算
  const keyPositions = useMemo(() => {
    const effectiveWidth = containerSize.width - config.keySize - config.padding * 2;
    const effectiveHeight = containerSize.height - config.keySize - config.padding * 2;

    return keys.map(key => ({
      left: config.padding + key.x * effectiveWidth,
      top: config.padding + key.y * effectiveHeight,
    }));
  }, [keys, containerSize, config]);

  return (
    <div
      onClick={onClick}
      className={`
        inline-block p-3 rounded-xl transition-all
        ${onClick ? 'cursor-pointer hover:scale-105' : ''}
        ${selected
          ? 'bg-blue-100 dark:bg-blue-900 ring-2 ring-blue-500'
          : 'bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700'
        }
      `}
    >
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
            <FlickKey keyConfig={key} size={size} />
          </div>
        ))}
      </div>

      {showStats && (
        <div className="mt-2 text-center text-xs text-gray-500 dark:text-gray-400 space-x-2">
          <span>{stats.keyCount}キー</span>
          <span>{stats.totalSlots}文字</span>
        </div>
      )}

      {layout.fitness !== undefined && (
        <div className="mt-1 text-center text-sm text-gray-600 dark:text-gray-400">
          スコア: {layout.fitness.toFixed(1)}
        </div>
      )}
    </div>
  );
}
