from feon.sa import *
if __name__ == "__main__":
    E = 70e6
    A = 0.005
    n0 = Node(0,0)
    n1 = Node(1,0)
    n2 = Node(2,0)
    n3 = Node(3,0)
    n4 = Node(4,0)
    e0 = Link1D11((n0,n1),E,A)
    e1 = Link1D11((n1,n2),E,A)
    e2 = Link1D11((n2,n3),E,A)
    e3 = Link1D11((n3,n4),E,A)
    s = System()
    s.add_nodes(n0,n1,n2,n3,n4)
    s.add_elements(e0,e1,e2,e3)
    s.add_node_force(n4.ID,Fx = 15)
    s.add_node_force(1,Fx = -10)
    s.add_fixed_sup(n0.ID)
    s.solve()
