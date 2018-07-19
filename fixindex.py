# -*- coding: utf-8 -*-
import re
from initd import INITD, REPLACEMENTS

  
orig = ''
trans = ''

for k in INITD:
  s = INITD[k]
  for c in s:
    orig+=c
    trans+=k
     
transtable = str.maketrans(orig, trans)

  
p = re.compile(r"\\indexentry \{(.*)@") 
    
def process(s): 
  if s.strip()=='':
    return s
  m = p.match(s) 
  o = ''
  try:
    o = m.groups(1)[0]
  except AttributeError:
    print(repr(s))
  t = o.translate(transtable)
  
  for r in REPLACEMENTS:
    t = t.replace(r[0],r[1])
  if t == o:
    return s
  else:
    return s.replace("%s@"%o,"%s@"%t)
  
  

if __name__ == '__main__':
  fn = 'phrasal-lfg-langsci.adx'
  lines = open(fn).readlines()
  print(len(lines))
  lines2 = list(map(process, lines))
  out = open('phrasal-lfg-langscimod.adx','w')
  out.write(''.join(lines2))
  out.close()
  
