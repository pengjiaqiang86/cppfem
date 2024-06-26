
from feon.sa import *
from feon.sa.draw2d import *
from feon.tools import Mesh
import numpy as np

if __name__ == "__main__":
    fig = plt.figure()
    ax = fig.add_subplot(111,aspect = "equal")
    ax.set_xlim([-0.1,0.6])
    ax.set_ylim([-0.1,0.35])

    E = 210e6
    nu = 0.3
    t = 0.025
    mesh = Mesh()
    mesh.build(mesh_type = "rect",x_lim=[0,0.5],y_lim = [0,0.25],size = (10,5))
    nds = np.array([Node(p) for p in mesh.points])
    els = [Quad2D11S(nds[c],E,nu,t) for c in mesh.elements]
    s = System()
    s.add_nodes(nds)
    s.add_elements(els)

    s.add_fixed_sup(range(6))
    for nd in nds[60:]:
        s.add_node_force(nd.ID,Fx = 3.125)

    s.solve()
    
    for el in s.get_elements():
        draw_element(ax,el,marker = "o",ms = 4,color = "g")
        draw_element_disp(ax,el,factor = 5,color = "r")
    plt.show()

    

