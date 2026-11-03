"""Finite closed-response regression for Grenny's first inventory opening."""
import importlib.util
from pathlib import Path
from tempfile import TemporaryDirectory
from types import SimpleNamespace
import sys
import unittest
from unittest.mock import patch

TOOLS=Path(__file__).resolve().parents[1]/'recomp/route_tools'
sys.path.insert(0,str(TOOLS))
spec=importlib.util.spec_from_file_location('grenny_inventory_candidate',TOOLS/'grenny_live.py')
g=importlib.util.module_from_spec(spec);spec.loader.exec_module(g)
OPEN=b'  FILE open C:\\GAME\\Ciftree\\UIINVENTORY_OVL.CIF  [virtual 9000 ms]\n'


class InventoryOpening(unittest.TestCase):
    def session(self,directory):
        out=Path(directory);(out/'run.log').write_bytes(b'old scene\n')
        return SimpleNamespace(out=out)

    def responder(self,session,replies,calls):
        def send(s,payload,tag):
            calls.append((payload,tag))
            reply=replies[min(len(calls)-1,len(replies)-1)]
            with(session.out/'run.log').open('ab')as stream:stream.write(reply)
            return {'state':[2463,2463,0,-1]},session.out/'closed.ppm'
        return send

    def test_first_or_later_fresh_open_stops_without_another_toggle(self):
        for replies,count in [([OPEN],1),([b'ordinary ignored press\n',OPEN],2)]:
            with self.subTest(count=count),TemporaryDirectory()as directory:
                s=self.session(directory);calls=[]
                with patch.object(g,'send',side_effect=self.responder(s,replies,calls)):
                    observation,image=g.open_inventory(s)
                self.assertEqual(len(calls),count)
                self.assertEqual(observation['state'],[2463,2463,0,-1])
                self.assertEqual(image,s.out/'closed.ppm')
                self.assertTrue(all('click:212,448,80'in payload for payload,_ in calls))
                self.assertTrue(all('62,100'not in payload for payload,_ in calls))

    def test_stale_open_and_similar_resource_do_not_certify_current_window(self):
        with TemporaryDirectory()as directory:
            s=self.session(directory);(s.out/'run.log').write_bytes(OPEN);calls=[]
            with patch.object(g,'send',side_effect=self.responder(s,[OPEN.replace(b'UIINVENTORY_OVL',b'OTHERINVENTORY_OVL')],calls)):
                with self.assertRaisesRegex(ValueError,'within12'):
                    g.open_inventory(s)
            self.assertEqual(len(calls),12)

    def test_unexpected_scene_refuses_even_with_a_fresh_open_record(self):
        with TemporaryDirectory()as directory:
            s=self.session(directory)
            def unexpected(*args):
                with(s.out/'run.log').open('ab')as stream:stream.write(OPEN)
                return {'state':[2460,2460,0,-1]},s.out/'closed.ppm'
            with patch.object(g,'send',side_effect=unexpected):
                with self.assertRaisesRegex(ValueError,'unknown scene'):
                    g.open_inventory(s)


if __name__=='__main__':unittest.main()
