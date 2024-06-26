from feon.sa import *
from feon.sa.draw2d import *
import matplotlib.pyplot as plt
from feon.tools import Mesh
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
    mesh.build(mesh_type = "rect",x_lim=[0,10],y_lim = [0,5],size = (10,5))
    nds = np.array([Node(p) for p in mesh.points])
    els = [Quad2D11S(nds[c],E,nu,t) for c in mesh.elements]
    s = System()
    s.add_nodes(nds)
    s.add_elements(els)
    
    for el in s.get_elements():
        draw_element(ax,el,marker = "o",color = "g")
        draw_element_ID(ax,el,0,0,fontsize = 12,color = "r")

    for nd in s.get_nodes():
        draw_node_ID(ax,nd,0.05,0.05,fontsize = 12,color = "g")
    plt.show()

    

