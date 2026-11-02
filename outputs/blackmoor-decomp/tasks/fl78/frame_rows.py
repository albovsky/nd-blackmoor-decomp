"""frame_rows.py ROW: read-only status of a row: scenarios known, kept, coverage, untaken directions (nothing is written)."""
import sys, json
sys.path.insert(0, 'scripts'); sys.path.insert(0, 'tests')
import fl66_tested as T
key = sys.argv[1]
r = T.check_row(key)
print(key, r['status'], r['instructions'], r['directions'], 'ran', r['scenarios_run'], 'skipped', r['scenarios_skipped_original_faults'], 'kept', len(r['kept']))
print('missing', r.get('missing'), 'untaken', r.get('untaken'))
json.dump(r, open('tasks/fl78/frame_%s.json' % key, 'w'))
