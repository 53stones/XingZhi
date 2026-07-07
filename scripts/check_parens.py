import sys
from pathlib import Path
p = Path(r'e:\SwiftXingZhi\app-flutter\lib\main.dart')
if not p.exists():
    print('file not found', p)
    sys.exit(2)
stack = []
pairs = {'(':')','{':'}','[':']'}
openings = set(pairs.keys())
closings = {v:k for k,v in pairs.items()}
with p.open('r', encoding='utf-8') as f:
    for lineno, line in enumerate(f, start=1):
        for col, ch in enumerate(line, start=1):
            if ch in openings:
                stack.append((ch, lineno, col))
            elif ch in closings:
                if not stack:
                    print(f'Unmatched closing {ch} at {lineno}:{col}')
                    sys.exit(1)
                last, lno, lcol = stack.pop()
                if closings[ch] != last:
                    print(f'Mismatch: {last} opened at {lno}:{lcol} but closed by {ch} at {lineno}:{col}')
                    sys.exit(1)
if stack:
    last, lno, lcol = stack[-1]
    print(f'Unclosed opening {last} at {lno}:{lcol}')
    sys.exit(1)
print('All brackets matched')
sys.exit(0)
