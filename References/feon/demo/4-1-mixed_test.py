from feon.sa import *
import numpy as np

class Link1D21(Link1D11):
        
    def calc_T(self):
        self._T = np.array([[1,0,0],
                            [0,1,0],
                            [0,0,1]])

    def calc_ke(self):
        self._ke = _calc_ke_for_link1d21(E = self.E,A = self.A,L = self.length)


def _calc_ke_for_link1d21(E = 1.,A = 1.,L =1.):
    a = E*A/L/3.
    return a*np.array([[7,1,-8],
                       [1,7,-8],
                       [-8,-8,16]])


if __name__ == "__main__":
    E = 70e6
    A = 0.005
    n0 = Node(0,0)
    n1 = Node(1,0)
    n2 = Node(2,0)
    n3 = Node(3,0)
    n4 = Node(4,0)
    e0 = Link1D21((n0,n2,n1),E,A)
    e1 = Link1D11((n2,n3),E,A)
    e2 = Link1D11((n3,n4),E,A)

    s = System()
    s.add_nodes(n0,n1,n2,n3,n4)
    s.add_elements(e0,e1,e2)
    s.add_node_force(1,Fx = -10)
    s.add_node_force(4,Fx = 15)
    s.add_fixed_sup(0)
    
    s.solve()
