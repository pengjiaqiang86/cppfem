from feon.sa import Node
from feon.tools import pair_wise
import numpy as np
def quad_mesh(start_x,end_x,start_y,end_y,m,n):
    assert start_x < end_x and start_y<end_y
    assert m > 1 and n > 1
    X = np.linspace(start_x,end_x,m+1)
    Y = np.linspace(start_y,end_y,n+1)
    nds = [Node(i,j) for i in X for j in Y]
    n_nds = np.array(nds).reshape((m+1,n+1))
    el_nds = [(n_nds[I[0],J[0]],n_nds[I[1],J[0]],n_nds[I[1],J[1]],n_nds[I[0],J[1]]) for I in pair_wise(range(m+1)) for J in pair_wise(range(n+1))]    
    return nds, el_nds

if __name__ == "__main__":
    nds,el_nds = quad_mesh(0,2,0,2,2,2)
