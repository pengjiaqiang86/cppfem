from feon.sa import *
import numpy as np
if __name__ == "__main__":
    E = 200e6
    nu = 0.3
    t = 0.025
    ns = np.loadtxt("nodes")
    es = np.loadtxt("elements")
    x,y = ns[:,0], ns[:,1]

    nds = []
    els = []

    for v,nd in enumerate(ns):
        n = Node((x[v],y[v]))
        nds.append(n)
    
    for v,el in enumerate(es):
        i,j,k = int(el[0]-1),int(el[1]-1),int(el[2]-1)
        n1,n2,n3 = nds[i],nds[j],nds[k]
        e = Tri2D11S((n1,n2,n3),E,nu,0.025)
        els.append(e)

    s = System()
    s.add_nodes(nds)
    s.add_elements(els)
    nids = [nds[i-1].ID for i in [1,22,32,33,34,35,36,37,38,39,40]]      
    s.add_fixed_sup(nids)
    for i in [2]+range(12,22):
        s.add_node_force(nds[i-1].ID,Fx = 2.27)
    s.solve()
