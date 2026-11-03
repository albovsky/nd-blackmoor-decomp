"""Device-free Grenny policy, inventory and protocol checks."""
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "recomp/route_tools"))
import hashlib
import struct
import tempfile
import unittest
import grenny_live as live
import grenny_profile as profile


class GrennyPolicyTests(unittest.TestCase):
    def test_exercised_v4_actions_and_bounds(self):
        # Hashes are from the actually exercised ordinary v4 request payloads.
        self.assertEqual(hashlib.sha256(live.crossing_payload().encode()).hexdigest(),'1baf59cc2d30334d820169fb75991cc1aee70c519ff5bcce7337858d48f21d89')
        self.assertEqual(hashlib.sha256(live.pickup_payload().encode()).hexdigest(),'45a73c68cd9857ea1a1d111974b5b904d2e2e30b45aaf76eccc85d08ff61bd7f')
        self.assertEqual((live.MAX_ATTEMPTS,live.PICKUP_CLICKS,live.EXIT_ATTEMPTS),(20,24,12))

    def test_cake_bag_preserved_and_slots_from_current_order(self):
        bag=[1,13,10,5,2,16,7,11,12,6,19,20,17,21]
        source={'flags':{str(f):0 for f in profile.LIVE},'inventory40':[int(i in bag)for i in range(40)],'ordered_bag':bag}
        source['flags']['2127']=0  # Internal readiness latch: durable checks only.
        self.assertNotIn(2127,profile.LIVE)
        result=profile.expected_output(source)
        self.assertEqual(result['ordered_bag'],bag+[8]);self.assertEqual(result['inventory40'][1],1)
        self.assertEqual(result['flags']['2127'],0)
        self.assertEqual(profile.first_free_slot(bag),(206,310))
        self.assertEqual(profile.item_slot(result,8),(206,310))
        self.assertEqual(bag,[1,13,10,5,2,16,7,11,12,6,19,20,17,21])

    def test_full_bag_refuses_and_unbound_profile_does_not_launch(self):
        with self.assertRaises(ValueError):profile.first_free_slot(list(range(16)))
        with self.assertRaises(ValueError):profile.validate({'name':'junior-grenny','difficulty':0,'native_sha256':None})

    def test_protocol_requires_complete_acked_finish(self):
        summary='  CONTROL SUMMARY complete=1 finish_id=2 acked=1 requests=2 steps=3/3 shots=1 bytes=99 pending=0 clock_ms=1000 failed=0 reason='
        self.assertEqual(live.io.completed(summary,2,[3,1]),summary.strip())
        with self.assertRaises(ValueError):live.io.completed(summary.replace('complete=1','complete=0'),2,[3,1])
        with self.assertRaises(ValueError):live.io.completed(summary,2,[4,1])


class GrennySavedGuardTests(unittest.TestCase):
    """Synthetic saves are parsed here only, never supplied to a game process."""
    def write_save(self,path,bag,flags,*,held=-1):
        data=bytearray(170770)
        struct.pack_into('<h',data,0x110,len(bag))
        struct.pack_into('<'+'h'*len(bag),data,0x116,*bag)
        for item in bag:struct.pack_into('<I',data,0x2ba+4*item,1)
        for flag,value in flags.items():struct.pack_into('<I',data,0x1ee6+4*int(flag),value)
        for offset,value in ((0x21642,2460),(0x21646,2460),(0x215d2,0),(0x10e,held),(0x9034,0)):
            struct.pack_into('<h',data,offset,value)
        struct.pack_into('<IHHH',data,0x2430,626,26,10,4)
        path.write_bytes(data)

    def test_real_parser_and_output_guard_preserve_cake_and_reject_bad_rewards(self):
        with tempfile.TemporaryDirectory()as folder:
            source_path=Path(folder)/'m64.SAV';output_path=Path(folder)/'m65.SAV'
            bag=[13,10,5,1,2,16,7,11,12,6,19,20,17,21]
            flags={str(f):int(f in profile.ONE)for f in profile.LIVE|{2127}}
            self.write_save(source_path,bag,flags)
            source=profile.snapshot(source_path,flags)
            bound=dict(name='junior-grenny',difficulty=0,native_sha256='a'*64,
                       source_sha256=live.io.digest(source_path),source_state=[2460,2460,0,-1],
                       **{k:source[k]for k in('flags','inventory40','ordered_bag','clock')})
            self.assertEqual(profile.source_state(source_path,bound),source)
            won=dict(flags);won.update({str(f):1 for f in profile.WIN})
            self.write_save(output_path,bag+[8],won)
            self.assertEqual(profile.check_output(profile.snapshot(output_path,flags),source)['inventory40'][1],1)
            wrong_flag=dict(won);wrong_flag['1999']=1
            cases=(('missing cake',[i for i in bag if i!=1]+[8],won,-1),
                   ('reordered',[10,13]+bag[2:]+[8],won,-1),
                   ('missing key',bag,won,-1),('held key',bag+[8],won,8),
                   ('changed prior event',bag+[8],wrong_flag,-1))
            for name,items,events,held in cases:
                with self.subTest(name=name):
                    self.write_save(output_path,items,events,held=held)
                    with self.assertRaises(ValueError):
                        profile.check_output(profile.snapshot(output_path,flags),source)

    def test_complete_asset_inventory_and_save_directory_exception(self):
        with tempfile.TemporaryDirectory()as folder:
            root=Path(folder);(root/'CDVideo').mkdir()
            (root/'Game.ini').write_bytes(b'fixture settings')
            (root/'CDVideo'/'fixture.bik').write_bytes(b'fixture media')
            pins={str(p.relative_to(root)):live.io.digest(p)for p in root.rglob('*')if p.is_file()}
            profile.check_data(root,pins)
            with self.assertRaises(ValueError):profile.check_data(root,{k:v for k,v in pins.items()if k!='Game.ini'})
            (root/'Documents5').mkdir();(root/'Documents5'/'fixture.SAV').write_bytes(b'fixture save')
            profile.check_data(root,pins,runtime_saves=True)
            with self.assertRaises(ValueError):profile.check_data(root,pins)
            (root/'Game.ini').write_bytes(b'changed fixture settings')
            with self.assertRaises(ValueError):profile.check_data(root,pins,runtime_saves=True)


if __name__=='__main__':unittest.main()
