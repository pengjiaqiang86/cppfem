from feon.sa import *

if __name__ == "__main__":
    E = 210e6
    A = 1e-4
    n0 = Node(0,0)
    n1 = Node(4,0)
    n2 = Node(3,3)
    e0 = Link2D11((n0,n1),E,A)
    e1 = Link2D11((n1,n2),E,A)
    e2 = Link2D11((n2,n0),E,A)

    s = System()
    s.add_nodes(n0,n1,n2)
    s.add_elements(e0,e1,e2)
    s.add_node_force(2,Fx = 5,Fy = -10)
    s.add_fixed_sup(0)
    s.add_rolled_sup(1,"y")
    s.solve()
