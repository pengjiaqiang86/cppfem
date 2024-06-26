import matplotlib.pyplot as plt
from matplotlib.patches import FancyArrowPatch,FancyArrow,Rectangle,Circle
from mpl_toolkits.mplot3d import Axes3D
from mpl_toolkits.mplot3d.art3d import Line3D,pathpatch_2d_to_3d
from mpl_toolkits.mplot3d import proj3d

class Arrow3D(FancyArrowPatch):
    def __init__(self,xs,ys,zs,*args,**kwargs):
        FancyArrowPatch.__init__(self,(0,0),(0,0),*args,**kwargs)
        self._verts3d = xs,ys,zs
    def draw(self,renderer):
        xs3d,ys3d,zs3d = self._verts3d
        xs,ys,zs = proj3d.proj_transform(xs3d,ys3d,zs3d,renderer.M)
        self.set_positions((xs[0],ys[0]),(xs[1],ys[1]))
        FancyArrowPatch.draw(self,renderer)
        
def test():
    n1 = (0,0,0)
    n2 = (0,4,0)
    n3 = (4,4,0)
    n4 = (4,0,0)
    n5 = (0,0,5)
    n6 = (0,4,5)
    n7 = (4,4,5)
    n8 = (4,0,5)
    nds1 = [n1,n2,n3,n4]
    nds2 = [n5,n6,n7,n8]
    fig = plt.figure()
    ax = fig.add_subplot(111,projection = "3d")
    ax.set_xlabel("$X$")
    ax.set_ylabel("$Y$")
    ax.set_zlabel("$Z$")
    d = 0.2
    dx = 1.0
    for i in xrange(4):
        x,y,z = [nds1[i][0],nds2[i][0]],[nds1[i][1],nds2[i][1]],[nds1[i][2],nds2[i][2]]
        line = Line3D(x,y,z,color = "k",linewidth = 1.5,
                      marker = "o",ms = 6)
        ax.add_line(line)
        ax.bar3d(nds1[i][0]-d/2.,nds1[i][1]-d/2.,nds1[i][2]-d/2.,d,d,d,color = "k",zsort = "average")
    for i in xrange(4):
        x,y,z = [nds2[i-1][0],nds2[i][0]],[nds2[i-1][1],nds2[i][1]],[nds2[i-1][2],nds2[i][2]]
        line = Line3D(x,y,z,color = "k",linewidth = 1.5,
                      marker = "o",ms = 6)
        ax.add_line(line)
    arrow = Arrow3D([n7[0]+dx,n7[0]],[n7[0],n7[1]],[n7[2],n7[2]],arrowstyle = "-|>",color = "r",lw = 2,
                                mutation_scale= 10)
    ax.add_artist(arrow)
    ax.set_xlim(-1,6)
    ax.set_ylim(-1,6)
    ax.set_zlim(-1,8)
    plt.show()

if __name__ == "__main__":
    test()
