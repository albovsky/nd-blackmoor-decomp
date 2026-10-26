#!/bin/bash
# FL-62: classify every row that has a finished definitive log (p2, or p3 after boundary scenarios) and print the clean and unexplained rows. usage: fl62_status.sh TAG (from outputs/blackmoor-decomp)
cd "$(dirname "$0")/.."
tag="$1"
rows=$(ls tasks/fl62/ | grep -E "^p2-0x" | sed 's/p2-//;s/.txt//' | while read r; do grep -q " killed " tasks/fl62/p2-$r.txt && echo $r; done | tr '\n' ' ')
python3 -u scripts/fl62_pipe.py $rows > /dev/null 2>&1          # the step-budget reruns of the hang-listed mutants (a step that is done is skipped)
scripts/fl62_classify.sh "$tag" $rows > "tasks/fl62/$tag-classify.log" 2>&1 || { echo "classify failed, see tasks/fl62/$tag-classify.log"; exit 1; }
python3 - "$tag" <<'PY'
import json, sys
d = json.load(open('tasks/fl62/%s-surv.json' % sys.argv[1]))
rows = set(l.split()[0] for l in open('tasks/fl62/%s-merged.txt' % sys.argv[1]) if l.startswith('0x') and ' mutants ' in l)
un = d['unexplained_rows']
clean = sorted(rows - set(un))
print('rows', len(rows), 'clean', len(clean), 'unexplained', len(un))
print('CLEAN', ' '.join(clean))
for k in un:
    print(k, len([x for x in d['rows_with_survivors'][k] if x[1] is None]))
PY
