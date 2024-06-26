from feon.sa import *
from feon.sa.draw2d import *
from mesh_def_test import quad_mesh
import matplotlib.pyplot as plt
if __name__ == "__main__":
    fig = plt.figure()
    ax1 = fig.add_subplot(211,aspect = "equal")
    ax1.set_xlim([-1,7])
    ax1.set_ylim([-2,2])

    ax2 = fig.add_subplot(212,aspect = "equal")
    ax2.set_xlim([-1,7])
    ax2.set_ylim([-2,2])

    
    E = 210e6
    A = 0.005
    I = 10e-6
    n0 = Node(0,0)
    n1 = Node(3,0)
    n2 = Node(6,0)
    e0 = Beam1D11((n0,n1),E,A,I)
    e1 = Beam1D11((n1,n2),E,A,I)
    s = System()
    s.add_nodes(n0,n1,n2)
    s.add_elements(e0,e1)
    
    for el in s.get_elements():
        draw_element(ax1,el,marker = "s",markersize = 3,color = "k")
        draw_element_ID(ax1,el,0,0.1,fontsize = 10,color = "r")
        draw_element(ax2,el,marker = "s",markersize = 3,color = "k")
        draw_element_ID(ax2,el,0,0.1,fontsize = 10,color = "r")


    for nd in s.get_nodes():
        draw_node_ID(ax1,nd,0.1,0.1,fontsize = 10,color = "g")
        draw_node_ID(ax2,nd,0.1,0.1,fontsize = 10,color = "g")

    draw_fixed_sup(ax1,n0,factor = (2,2),color = "k")
    draw_rolled_sup(ax1,n2,factor = 2,color = "k")

    draw_hinged_sup(ax2,n0,factor = 1.5,color = "k")
    draw_rolled_sup(ax2,n2,factor = 2,color = "k")
    
    plt.show()

    

