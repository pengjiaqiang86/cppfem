from feon.sa.draw2d import *
from feon.sa import *
import matplotlib.pyplot as plt
if __name__ == "__main__":
    n0 = Node(1,1)
    fig = plt.figure()
    ax = fig.add_subplot(111)
    ax.set_xlim([0,2])
    ax.set_ylim([0,2])
    ax.plot(n0.x,n0.y,"ks")
    draw_right_arrow(ax,n0,0.5,color = "r",head_length = 0.03,head_width = 0.03)
    draw_left_arrow(ax,n0,0.5,color = "r",head_length = 0.03,head_width = 0.03)
    draw_up_arrow(ax,n0,0.5,color = "r",head_length = 0.03,head_width = 0.03)
    draw_down_arrow(ax,n0,0.5,color = "r",head_length = 0.03,head_width = 0.03)
    plt.show()

    

