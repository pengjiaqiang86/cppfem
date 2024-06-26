from feon.sa import *
import numpy as np
import matplotlib.pyplot as plt
if __name__ == "__main__":

   E = 210e6
   G = 84e6
   A = 0.02
   I =[5e-5,10e-5,20e-5]
   n0 = Node(0,0,0)
   n1 = Node(0,-3,0)
   n2 = Node(0,0,-4)
   n3 = Node(3,0,0)

   e0 = Beam3D11((n0,n1),E,G,A,I)
   e1 = Beam3D11((n0,n2),E,G,A,I)
   e2 = Beam3D11((n0,n3),E,G,A,I)

   s=System()

   s.add_nodes(n0,n1,n2,n3)
   s.add_elements(e0,e1,e2)
   s.add_fixed_sup(1,2,3)
   s.add_node_force(0,Fx = -10,Fy = 20)
   s.solve()
   
   

##   N = np.array([abs(el.force["N"][0][0]) for el in [e0,e1,e2]])
##   Ty = np.array([el.force["Ty"] for el in [e0,e1,e2]])
##   Mz = [el.force["Mz"] for el in [e0,e1,e2]]
##

##   plt.rcdefaults()
##   fig,ax = plt.subplots()
####   draw N
####   Y = ("$beam 0$","$beam 1$","$beam 2$")
####   y_pos = np.arange(3)
####   ax.barh(y_pos,N,0.2,align = "center",color = ("g","r","k"),ecolor = "b")
####   ax.set_yticks(y_pos)
####   ax.set_yticklabels(Y)
####   ax.invert_yaxis()
####   ax.set_xlabel("$N/kN$")
####   plt.show()
##
#### draw Ty
##   Ty = np.abs(Ty)
##   Ty1 = Ty[:,0]
##   Ty2 = Ty[:,1]
##   Mz = np.abs(Mz)
##   Mz1 = Mz[:,0]
##   Mz2 = Mz[:,1]
##   index = np.arange(3)
##   bar_width = 0.2
##
##   res1 = plt.bar(index,Ty1,bar_width,color = "r")
##   res2 = plt.bar(index+bar_width,Ty2,bar_width,color = "g")
####   res3 = plt.bar(index,Mz1,bar_width,color = "g")
####   res4 = plt.bar(index+bar_width,Mz2,bar_width,color = "y")
##   ax.set_xlim([-0.5,3])
##   plt.ylabel("$Ty/kN$")
##   plt.xticks(index+bar_width,("$Beam 0$","$Beam 1$","$Beam 2$"))
##   plt.show()
   
   
   

   
   
   
   
      

