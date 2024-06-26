from feon.sa import *
if __name__ == "__main__":
    E = 70e6
    E1 = 9999e6
    A = 0.004
    A1 = 1
    n0 = Node(0,0)
    n1 = Node(4,0)
    n2 = Node(4,3.5)
    n3 = Node(0,3.5)
    n4 = Node(5,-1)

    e0 = Link2D11((n0,n1),E,A)
    e1 = Link2D11((n1,n2),E,A)
    e2 = Link2D11((n2,n3),E,A)
    e3 = Link2D11((n3,n0),E,A)
    e4 = Link2D11((n0,n2),E,A)
    e5 = Link2D11((n3,n1),E,A)
    e6 = Link2D11((n1,n4),E1,A1)
    s = System()
    s.add_nodes(n0,n1,n2,n3,n4)
    s.add_elements(e0,e1,e2,e3,e4,e5,e6)
    s.add_node_force(n2,Fx = 30)
    s.add_fixed_sup(n0,n4)
    s.solve()

