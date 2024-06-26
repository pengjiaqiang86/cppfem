from feon.sa import *
from feon.sa.draw2d import *
from feon.tools import Mesh
import matplotlib.pyplot as plt
import numpy as np


if __name__ == "__main__":
    fig = plt.figure()
    ax = fig.add_subplot(111,aspect = "equal")
    ax.set_xlim([-1,11])
    ax.set_ylim([-1,6])

    E = 210e6
    nu = 0.3
    t = 0.025
    mesh = Mesh()
    mesh.build(mesh_type = "tri_from_rect",x_lim=[0,10],y_lim = [0,5],size = (10,5))
    nds = np.array([Node(p) for p in mesh.points])
    els = [Quad2D11S(nds[c],E,nu,t) for c in mesh.elements]
    
    s = System()
    s.add_nodes(nds)
    s.add_elements(els)

    for el in s.get_elements():
        draw_element(ax,el,marker = "o",ms = 4,color = "g")
    plt.show()

    

