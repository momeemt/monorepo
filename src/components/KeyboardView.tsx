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

export function KeyboardView({
  layout,
  selected,
  onClick,
  size = 'md',
  showStats = false,
}: KeyboardViewProps) {
  const { keys, cols } = layout;
  const stats = getLayoutStats(layout);

  const gapClasses = {
    sm: 'gap-1',
    md: 'gap-1.5',
    lg: 'gap-2',
  };

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
        className={`grid ${gapClasses[size]}`}
        style={{
          gridTemplateColumns: `repeat(${cols}, minmax(0, 1fr))`,
        }}
      >
        {keys.map((key, index) => (
          <FlickKey key={index} keyConfig={key} size={size} />
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
