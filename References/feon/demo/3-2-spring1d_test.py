from feon.sa import *
import matplotlib.pyplot as plt
if __name__ == "__main__":
    k = 120
    n0 = Node(0,0)
    n1 = Node(1,0)
    n2 = Node(2,0)
    n3 = Node(3,0)
    n4 = Node(4,0)
    e0 = Spring1D11((n0,n1),k)
    e1 = Spring1D11((n1,n3),k)
    e2 = Spring1D11((n1,n2),k)
    e3 = Spring1D11((n1,n2),k)
    e4 = Spring1D11((n2,n3),k)
    e5 = Spring1D11((n3,n4),k)
    s = System()
    s.add_nodes(n0,n1,n2,n3,n4)
    s.add_elements(e0,e1,e2,e3,e4,e5)
    s.add_node_force(2,Fx = 20)
    s.add_fixed_sup((0,4))
    s.solve()

    disp = [nd.disp["Ux"] for nd in [n0,n1,n2,n3,n4]]

    eforce = [e.force["N"][0][0] for e in [e0,e1,e2,e3,e4,e5]]

    fig = plt.figure()
    ax = fig.add_subplot(211)
    ax2 = fig.add_subplot(212)
    ax.set_xlabel(r"$Node ID$")
    ax.set_ylabel(r"$Ux/m$")
    ax.set_ylim([-0.3,0.3])
    ax.set_xlim([-1,5])
    ax.plot(range(5),disp,"r*-")
    ax2.set_xlabel(r"$Element ID$")
    ax2.set_xlim([-1,7])
    ax2.set_ylabel(r"$N/kN$")
    ax2.set_ylim(-20,20)
    for i in xrange(6):
        ax2.plot([i-0.5,i+0.5],[eforce[i],eforce[i]],"g+-")
    plt.show()
    
