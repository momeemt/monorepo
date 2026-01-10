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
  sm: { keySize: 40, cellSize: 46, padding: 4 },
  md: { keySize: 48, cellSize: 54, padding: 6 },
  lg: { keySize: 56, cellSize: 64, padding: 8 },
};

// キー数に応じてグリッドサイズとコンテナサイズを計算
function calculateGridInfo(keyCount: number, cellSize: number, padding: number): { cols: number; rows: number; width: number; height: number } {
  const cols = Math.ceil(Math.sqrt(keyCount * 1.2));
  const rows = Math.ceil(keyCount / cols);

  const width = cols * cellSize + padding * 2;
  const height = rows * cellSize + padding * 2;

  return { cols, rows, width, height };
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

  // グリッド情報を計算
  const gridInfo = useMemo(
    () => calculateGridInfo(keys.length, config.cellSize, config.padding),
    [keys.length, config]
  );

  // キーの座標を計算（グリッドセルの中心に配置）
  const keyPositions = useMemo(() => {
    return keys.map(key => {
      // 正規化座標（0-1）からグリッドセルのインデックスを計算
      const col = Math.round(key.x * (gridInfo.cols - 1));
      const row = Math.round(key.y * (gridInfo.rows - 1));

      // セルの中心座標
      const left = config.padding + col * config.cellSize + (config.cellSize - config.keySize) / 2;
      const top = config.padding + row * config.cellSize + (config.cellSize - config.keySize) / 2;

      return { left, top };
    });
  }, [keys, gridInfo, config]);

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
