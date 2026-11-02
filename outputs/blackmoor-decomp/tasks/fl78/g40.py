import itertools
SETS=[]
O=lambda k,v:(W.STUB_OVR+16*k,4,v)
# path A
for ca in (0,1,2):
    for k0,k1 in itertools.product((0,1),(0,1)):
        for a3 in (0,5):
            SETS.append([(0x63caa0,4,ca),O(0,k0),O(1,k1),O(2,1),O(3,1),(arg(3),4,a3),(arg(2),4,P1),(P1,1,0)])
# path B
for a1 in (0,0x400):
    for a5 in (0,2,10):
        for esi in (3,12):
            for k0,k1,k2,k3,k4 in itertools.product((5,),(0,7),(0,esi),(0,1),(0,1)):
                SETS.append([(0x63caa0,4,1),(arg(3),4,0),(arg(1),4,a1),(arg(5),4,a5),O(0,k0),O(1,k1),O(2,k2),O(3,k3),O(4,k4),(arg(6),4,1)])
