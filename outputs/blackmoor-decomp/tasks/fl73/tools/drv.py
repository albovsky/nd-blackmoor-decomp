import sys,json,gc
sys.dont_write_bytecode=True
P='/home/user/nd-blackmoor-decomp/outputs/blackmoor-decomp'
sys.path[:0]=[P+'/tests',P+'/scripts']
import fl66_tested as F
def setup(key):
    pool=F.pool_of(key); p=F.POOLS[pool]
    W,G=F.world(p['world']); row=F.row_info(pool,key)
    return pool,W,G,row
def run(W,row,seed,ov=(),observe=False):
    return W.run_original(row,seed,[tuple(o) for o in ov],observe=observe)
def cov(G,row,ex,ed):
    got,total,taken,dirs,missing,untaken=G.covers(row,ex,ed)
    return got,total,taken,dirs,missing,untaken
