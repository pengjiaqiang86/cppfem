from feon.sa import *
import matplotlib.tri as tri
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon
from matplotlib.collections import PatchCollection
import numpy as np
if __name__ == "__main__":
    E = 210e6
    nu = 0.3
    t = 0.025
    n0 = Node(0,0)
    n1 = Node(0.5,0)
    n2 = Node(0.5,0.25)
    n3 = Node(0,0.25)

    e0 = Tri2D11S((n0,n1,n2),E,nu,t)
    e1 = Tri2D11S((n0,n2,n3),E,nu,t)

    s = System()
    s.add_nodes(n0,n1,n2,n3)
    s.add_elements(e0,e1)

    s.add_node_force(1,Fx = 9.375)
    s.add_node_force(2,Fx = 9.375)

    s.add_fixed_sup(0,3)

    s.solve()


    nx = [nd.x for nd in s.get_nodes()]
    ny = [nd.y for nd in s.get_nodes()]
    nID = [[nd.ID for nd in el] for el in s.get_elements()]
    tr = tri.Triangulation(nx,ny,nID)

    ux = [nd.disp["Ux"] for nd in s.get_nodes()]
    uy = [nd.disp["Uy"] for nd in s.get_nodes()]
    
    sx = np.array([el.stress["sx"][0][0] for el in s.get_elements()])
    sy = np.array([el.stress["sy"][0][0] for el in s.get_elements()])
    sxy = np.array([el.stress["sxy"][0][0] for el in s.get_elements()])

    fig = plt.figure()
    ax = fig.add_subplot(111)
##    ncb = ax.tricontourf(tr,uy,color = "k",cmap = "jet")
##
##    fig.colorbar(ncb)

    patches = []
    ex,ey = [],[]
    for el in s.get_elements():
        for nd in el.nodes:
            ex.append(nd.x)
            ey.append(nd.y)
        polygon = Polygon(zip(ex,ey),True)
        patches.append(polygon)
    pc = PatchCollection(patches, color="k", edgecolor="w", alpha=0.4)
    pc.set_array(sxy)
    ax.add_collection(pc)
    ax.set_xlim([0,0.5])
    ax.set_ylim([0,0.25])
    ax.set_aspect("equal")
    plt.colorbar(pc)
    plt.show()
    
