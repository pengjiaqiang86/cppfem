#! /usr/bin/env python
# -*- coding: utf-8 -*-
#
import meshpy.triangle
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon
from matplotlib.collections import PatchCollection

def create_mesh(max_area=1.0):
    cc_radius = 4.0  
    lx = np.sqrt(2.0) * cc_radius
    l = [lx, lx]
    h_radius = 1
    boundary_points = [
            (0.5*l[0],  0.0),
            (0.5*l[0],  0.5*l[1]),
            (-0.5*l[0],  0.5*l[1]),
            (-0.5*l[0], -0.5*l[1]),
            (0.5*l[0], -0.5*l[1]),
            (0.5*l[0],  0.0)
            ]
    segments = 100
    for k in range(segments+1):
        angle = k * 2.0 * np.pi / segments
        boundary_points.append(
                (h_radius * np.cos(angle), h_radius * np.sin(angle))
                )
    holes = [(0, 0)]

    info = meshpy.triangle.MeshInfo()
    info.set_points(boundary_points)
    info.set_holes(holes)

    def _round_trip_connect(start, end):
        result = []
        for i in range(start, end):
            result.append((i, i+1))
        result.append((end, start))
        return result
    info.set_facets(_round_trip_connect(0, len(boundary_points)-1))

    def _needs_refinement(vertices, area):
        return bool(area > max_area)

    meshpy_mesh = meshpy.triangle.build(info,
                                        refinement_func=_needs_refinement
                                        )

    pts = np.array(meshpy_mesh.points)
    points = np.c_[pts[:, 0], pts[:, 1], np.zeros(len(pts))]

    return points, np.array(meshpy_mesh.elements)


if __name__ == '__main__':
    points, cells = create_mesh()
    fig = plt.figure()
    ax = fig.add_subplot(111,aspect = "equal")
    x,y = points[:,0],points[:,1]
    patches = []
    for c in cells:
        polygon = Polygon(zip(x[c],y[c]),True)
        patches.append(polygon)
    pc = PatchCollection(patches, color="k", edgecolor="w")
    ax.add_collection(pc)
    ax.set_xlim(-4,4)
    ax.set_ylim(-4,4)
    plt.show()
