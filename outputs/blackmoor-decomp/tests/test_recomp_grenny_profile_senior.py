"""Focused synthetic Grenny profile metadata guards; no native process."""
import copy
import json
from pathlib import Path
import struct
import sys
import tempfile
import unittest

TOOLS = Path(__file__).resolve().parents[1] / 'recomp/route_tools'
sys.path.insert(0, str(TOOLS))
import grenny_profile as profile
sys.path.pop(0)


class SeniorGrennyProfileTests(unittest.TestCase):
    def setUp(self):
        self.folder = tempfile.TemporaryDirectory()
        self.addCleanup(self.folder.cleanup)
        self.root = Path(self.folder.name)
        self.bag = [13,10,5,1,2,16,7,11,12,6,19,20,17,21]
        self.flags = {str(f):int(f in profile.ONE) for f in profile.LIVE | {2127}}
        self.flags.update({str(f):1 for f in (1335,1338,1345,1840,2008,2084)})

    def save(self, name, mode, bag, flags):
        data = bytearray(170770)
        struct.pack_into('<h',data,0x110,len(bag))
        struct.pack_into('<'+'h'*len(bag),data,0x116,*bag)
        for item in bag:
            struct.pack_into('<I',data,0x2ba+4*item,1)
        for flag,value in flags.items():
            struct.pack_into('<I',data,0x1ee6+4*int(flag),value)
        for offset,value in ((0x21642,2460),(0x21646,2460),(0x215d2,0),(0x10e,-1),(0x9034,mode)):
            struct.pack_into('<h',data,offset,value)
        struct.pack_into('<IHHH',data,0x2430,626,26,10,4)
        path=self.root/name
        path.write_bytes(data)
        return path

    def bound(self, mode, name):
        path=self.save('source.SAV',mode,self.bag,self.flags)
        state=profile.snapshot(path,self.flags)
        value=dict(name=name,difficulty=mode,native_sha256='a'*64,
                   source_sha256=profile.io.digest(path),source_state=[2460,2460,0,-1],
                   **{k:state[k] for k in ('flags','inventory40','ordered_bag','clock')})
        return path,value,state

    def test_explicit_senior_selection_and_junior_default_remain_distinct(self):
        _,junior,_=self.bound(0,'junior-grenny')
        self.assertEqual(profile.validate(junior),junior)
        _,senior,_=self.bound(2,'senior-grenny')
        self.assertEqual(profile.validate(senior,profile_name='senior-grenny'),senior)
        with self.assertRaises(ValueError):
            profile.validate(senior)
        for selected,changed in (('junior-grenny',senior),('senior-grenny',junior),
                                 ('unknown',senior),('senior-grenny',dict(senior,difficulty=1)),
                                 ('junior-grenny',dict(junior,difficulty=False))):
            with self.subTest(selected=selected,mode=changed['difficulty']):
                with self.assertRaises(ValueError):
                    profile.validate(changed,profile_name=selected)

    def test_senior_JSON_and_saved_mode_must_match_selected_profile(self):
        path,value,state=self.bound(2,'senior-grenny')
        metadata=self.root/'profile.json'
        metadata.write_text(json.dumps(value))
        loaded=profile.read(metadata,profile_name='senior-grenny')
        self.assertEqual(profile.source_state(path,loaded,profile_name='senior-grenny'),state)
        self.assertTrue(all(type(key)is str for key in loaded['flags']))
        other=self.save('other.SAV',0,self.bag,self.flags)
        changed=dict(loaded,source_sha256=profile.io.digest(other))
        with self.assertRaises(ValueError):
            profile.source_state(other,changed,profile_name='senior-grenny')

    def test_senior_output_preserves_mode_all_items_flags_and_dynamic_slots(self):
        _,_,source=self.bound(2,'senior-grenny')
        won=dict(self.flags)
        won.update({str(f):1 for f in profile.WIN})
        output=self.save('output.SAV',2,self.bag+[8],won)
        state=profile.snapshot(output,self.flags)
        self.assertEqual(profile.check_output(state,source),state)
        self.assertEqual(state['ordered_bag'],self.bag+[8])
        self.assertEqual(state['inventory40'][1],1)
        self.assertEqual(profile.item_slot(state,8),profile.first_free_slot(self.bag))
        self.assertNotIn(2127,profile.LIVE)
        for changed in (dict(state,difficulty=0),dict(state,difficulty=1),
                        dict(state,flags={**state['flags'],'1978':0}),
                        dict(state,flags={**state['flags'],'2127':1})):
            with self.assertRaises(ValueError):
                profile.check_output(changed,source)

    def test_senior_does_not_relax_unbound_prerequisite_reward_or_clock_guards(self):
        _,value,_=self.bound(2,'senior-grenny')
        cases=[]
        cases.append(dict(value,source_sha256=None))
        cases.append(dict(value,clock=None))
        cases.append(dict(value,source_state=[2460,2460,0,13]))
        cases.append(dict(value,flags={**value['flags'],'1959':0}))
        cases.append(dict(value,flags={**value['flags'],'1978':1}))
        key_owned=copy.deepcopy(value)
        key_owned['inventory40'][8]=1
        key_owned['ordered_bag'].append(8)
        cases.append(key_owned)
        for changed in cases:
            with self.assertRaises(ValueError):
                profile.validate(changed,profile_name='senior-grenny')


if __name__=='__main__':
    unittest.main()
