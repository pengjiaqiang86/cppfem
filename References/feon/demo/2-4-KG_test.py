from feon.sa import *
import numpy as np



if __name__ == "__main__":
    E = 210e6
    A = 0.005
    I = 10e-5
    n1 = Node(0,0)
    n2 = Node(2,0)
    n3 = Node(1,1)
    e1 = Beam2D11((n1,n2),E,A,I)
    e2 = Link2D11((n2,n3),E,A)
    e3 = Link2D11((n3,n1),E,A)
    s = System()
    s.add_nodes(n1,n2,n3)
    s.add_elements(e1,e2,e3)
    s.add_node_force(n3.ID,Fx = 15,Fy = -10)
    s.add_hinged_sup(n1.ID)
    s.add_rolled_sup(n2.ID,"y")
