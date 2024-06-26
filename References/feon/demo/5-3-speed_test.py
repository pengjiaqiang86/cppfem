from feon.sa import *
from feon.tools import pair_wise
import scipy.sparse as sp
import scipy.sparse.linalg as sl
import time
import matplotlib.pyplot as plt
if __name__ == "__main__":
    E = 70e6
    I = 40e-6
    A  = 0.005

    nds = [Node(i*0.1,0) for i in xrange(101)]
    el_nds = [nd for nd in pair_wise(nds)]
    els = [Beam1D11(nd,E,A,I) for nd in el_nds]
    
    s = System()
    s.add_nodes(nds)
    s.add_elements(els)
    s.add_fixed_sup(0)
    s.add_rolled_sup(nds[-1].ID,"y")
    s.add_node_force(49,Fy = -10)
    s.calc_deleted_KG_matrix()
    KG,Force = s.KG_keeped,s.Force_keeped
    t1 = []
    t2 = []
    for i in xrange(10):
        start1 = time.clock()
        a = np.linalg.solve(KG,Force)
        end1 = time.clock()
        t1.append(end1-start1)
        
    KG = sp.csc_matrix(s.KG_keeped)
    for i in xrange(10):
        start2 = time.clock()
        b = sl.spsolve(KG,Force)
        end2 = time.clock()
        t2.append(end2-start2)

    fig = plt.figure()
    ax = fig.add_subplot(111)
    x = range(10)
    ax.plot(x,t1,"r+-",label = "$numpy$")
    ax.plot(x,t2,"k*-",label = "$scipy.sparse$")
    ax.set_xlabel("$No.$",fontsize = 15)
    ax.set_ylabel("$time/s$",fontsize = 15)
    plt.legend()
    plt.show()

    

