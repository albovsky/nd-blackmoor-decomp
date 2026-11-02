"""triage13.py ROW...: run the window prover with VERBOSE on the untaken directions of the scenario-complete rows and print the verdict per window"""
import sys, json
from pathlib import Path
PROJ = str(Path(__file__).resolve().parents[2])
sys.path.insert(0, PROJ + '/scripts')
import fl67_infeasible as P, fl71_window as Wn
Wn.VERBOSE = True
T = {'0x510375': [['0x5103b7', 'taken']], '0x512d28': [['0x512d9c', 'taken']], '0x5145fe': [['0x514634', 'taken']], '0x514893': [['0x5148c6', 'fall-through']],
     '0x516530': [['0x516578', 'taken']], '0x518b98': [['0x518bce', 'fall-through']], '0x51aa23': [['0x51aabc', 'taken']], '0x51ee80': [['0x51ee92', 'taken']],
     '0x51ef5c': [['0x51ef88', 'taken']], '0x51ff98': [['0x520000', 'taken']], '0x522135': [['0x522202', 'fall-through']], '0x5236ae': [['0x5236f1', 'taken']],
     '0x52401f': [['0x524065', 'fall-through']]}


def main():
    img = P.load_image()
    for key in sys.argv[1:]:
        print('==', key, flush=True)
        try:
            an, dom = Wn.prepare(key, img)
            print(Wn.prove_row_windows(an, dom, {'missing': [], 'untaken': T[key]}), flush=True)
        except Exception as e:
            print('error', type(e).__name__, e, flush=True)


if __name__ == '__main__':
    main()
