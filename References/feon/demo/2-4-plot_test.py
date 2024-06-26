import numpy as np
import matplotlib.pyplot as plt
from matplotlib.lines import Line2D
def test():
    n1 = (0,0)
    n2 = (0,3)
    n3 = (4,3)
    n4 = (4,0)
    nds = [n1,n2,n3,n4]
    fig = plt.figure()
    ax = fig.add_subplot(111,aspect= "equal")
    ax.set_xlim(-1,5)
    ax.set_ylim(-1,4)
    ax.set_xticks([])
    ax.set_yticks([])
    for i in xrange(3):
        x,y = [nds[i][0],nds[i+1][0]],[nds[i][1],nds[i+1][1]]
        line = Line2D(x,y,color = "k",linewidth = 1.5,
                          marker = "o",markeredgecolor = "w",ms = 6)
        ax.add_line(line)
    ax.plot(n1[0],n1[1],"gs",ms = 10)
    ax.plot(n4[0],n4[1],"go",ms = 10)
    ax.arrow(2,3.5,0,-0.5,length_includes_head = True,
             head_length = 0.1,head_width = 0.05,color = 'r')
    plt.show()

if __name__ == "__main__":
    test()
