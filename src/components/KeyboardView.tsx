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

// サイズごとのコンテナとキーサイズ
const sizeConfig = {
  sm: { containerWidth: 200, containerHeight: 250, keySize: 56, padding: 8 },
  md: { containerWidth: 240, containerHeight: 300, keySize: 72, padding: 10 },
  lg: { containerWidth: 280, containerHeight: 350, keySize: 88, padding: 12 },
};

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

  // キーの座標を計算
  const keyPositions = useMemo(() => {
    const effectiveWidth = config.containerWidth - config.keySize - config.padding * 2;
    const effectiveHeight = config.containerHeight - config.keySize - config.padding * 2;

    return keys.map(key => ({
      left: config.padding + key.x * effectiveWidth,
      top: config.padding + key.y * effectiveHeight,
    }));
  }, [keys, config]);

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
          width: config.containerWidth,
          height: config.containerHeight,
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
