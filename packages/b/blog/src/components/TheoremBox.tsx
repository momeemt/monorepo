import type { ReactNode } from 'react';

type TheoremBoxProps = {
  children: ReactNode;
  title?: string;
};

function TheoremBox({
  children,
  title,
  type,
  variant = 'statement'
}: TheoremBoxProps & {
  type: string;
  variant?: 'statement' | 'proof';
}) {
  return (
    <aside className={`theoremBox theoremBox-${variant}`}>
      <p className="theoremBoxHeader">
        <span className="theoremBoxType">{type}</span>
        {title && <span className="theoremBoxTitle">{title}</span>}
      </p>
      <div className="theoremBoxBody">{children}</div>
    </aside>
  );
}

export function Theorem(props: TheoremBoxProps) {
  return <TheoremBox type="定理" {...props} />;
}

export function Definition(props: TheoremBoxProps) {
  return <TheoremBox type="定義" {...props} />;
}

export function Lemma(props: TheoremBoxProps) {
  return <TheoremBox type="補題" {...props} />;
}

export function Proposition(props: TheoremBoxProps) {
  return <TheoremBox type="命題" {...props} />;
}

export function Corollary(props: TheoremBoxProps) {
  return <TheoremBox type="系" {...props} />;
}

export function Proof(props: TheoremBoxProps) {
  return <TheoremBox type="証明" variant="proof" {...props} />;
}
