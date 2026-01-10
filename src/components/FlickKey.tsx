import type { KeyConfig } from '../types/keyboard';

interface FlickKeyProps {
  keyConfig: KeyConfig;
  size?: 'sm' | 'md' | 'lg';
}

const sizeClasses = {
  sm: 'w-14 h-14',
  md: 'w-18 h-18',
  lg: 'w-22 h-22',
};

const fontSizeClasses = {
  sm: 'text-[10px]',
  md: 'text-xs',
  lg: 'text-sm',
};

const centerFontSizeClasses = {
  sm: 'text-sm',
  md: 'text-base',
  lg: 'text-lg',
};

export function FlickKey({ keyConfig, size = 'md' }: FlickKeyProps) {
  const { center, flicks } = keyConfig;
  const flickCount = Object.keys(flicks).length;

  return (
    <div
      className={`${sizeClasses[size]} relative bg-gray-100 dark:bg-gray-700 rounded-lg border border-gray-300 dark:border-gray-600 flex items-center justify-center`}
    >
      {/* 中央 */}
      <span className={`${centerFontSizeClasses[size]} font-bold text-gray-800 dark:text-gray-100`}>
        {center}
      </span>

      {/* 上 */}
      {flicks.up && (
        <span
          className={`absolute top-0.5 left-1/2 -translate-x-1/2 ${fontSizeClasses[size]} text-gray-500 dark:text-gray-400`}
        >
          {flicks.up}
        </span>
      )}

      {/* 右上 */}
      {flicks.upRight && (
        <span
          className={`absolute top-0.5 right-0.5 ${fontSizeClasses[size]} text-gray-400 dark:text-gray-500`}
        >
          {flicks.upRight}
        </span>
      )}

      {/* 右 */}
      {flicks.right && (
        <span
          className={`absolute right-0.5 top-1/2 -translate-y-1/2 ${fontSizeClasses[size]} text-gray-500 dark:text-gray-400`}
        >
          {flicks.right}
        </span>
      )}

      {/* 右下 */}
      {flicks.downRight && (
        <span
          className={`absolute bottom-0.5 right-0.5 ${fontSizeClasses[size]} text-gray-400 dark:text-gray-500`}
        >
          {flicks.downRight}
        </span>
      )}

      {/* 下 */}
      {flicks.down && (
        <span
          className={`absolute bottom-0.5 left-1/2 -translate-x-1/2 ${fontSizeClasses[size]} text-gray-500 dark:text-gray-400`}
        >
          {flicks.down}
        </span>
      )}

      {/* 左下 */}
      {flicks.downLeft && (
        <span
          className={`absolute bottom-0.5 left-0.5 ${fontSizeClasses[size]} text-gray-400 dark:text-gray-500`}
        >
          {flicks.downLeft}
        </span>
      )}

      {/* 左 */}
      {flicks.left && (
        <span
          className={`absolute left-0.5 top-1/2 -translate-y-1/2 ${fontSizeClasses[size]} text-gray-500 dark:text-gray-400`}
        >
          {flicks.left}
        </span>
      )}

      {/* 左上 */}
      {flicks.upLeft && (
        <span
          className={`absolute top-0.5 left-0.5 ${fontSizeClasses[size]} text-gray-400 dark:text-gray-500`}
        >
          {flicks.upLeft}
        </span>
      )}

      {/* フリック数バッジ（0の場合のみ表示） */}
      {flickCount === 0 && (
        <span className="absolute -top-1 -right-1 w-4 h-4 bg-gray-400 dark:bg-gray-500 rounded-full text-[8px] text-white flex items-center justify-center">
          1
        </span>
      )}
    </div>
  );
}
