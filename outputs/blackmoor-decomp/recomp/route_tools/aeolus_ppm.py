from pathlib import Path
import re,struct,zlib,sys
def convert(path):
 p=Path(path);a=p.read_bytes();m=re.match(rb'P6\s+(\d+)\s+(\d+)\s+255\s',a);assert m
 w,h=map(int,m.groups());data=a[m.end():];assert len(data)==w*h*3
 chunk=lambda k,d:struct.pack('>I',len(d))+k+d+struct.pack('>I',zlib.crc32(k+d)&0xffffffff)
 pixels=b''.join(b'\0'+data[y*w*3:(y+1)*w*3] for y in range(h))
 out=p.with_suffix('.png');out.write_bytes(b'\x89PNG\r\n\x1a\n'+chunk(b'IHDR',struct.pack('>2I5B',w,h,8,2,0,0,0))+chunk(b'IDAT',zlib.compress(pixels))+chunk(b'IEND',b''));return out
if __name__=='__main__':
 for p in sys.argv[1:]:print(convert(p))
