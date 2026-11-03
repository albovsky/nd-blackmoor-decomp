"""Device-free Grenny policy, inventory and protocol checks."""
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "recomp/route_tools"))
import hashlib
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


if __name__=='__main__':unittest.main()
