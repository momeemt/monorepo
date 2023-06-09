import numpy as np
from shapely.geometry import Polygon
from shapely.ops import triangulate

class Area:
    _points: list[tuple[float, float]]

    def __init__(self, *points: tuple[float, float]) -> None:
        self._points = list(points)

    def get_random_coord(self) -> tuple[float, float]:
        polygon = Polygon(self._points)
        triangles = triangulate(polygon)
        areas = np.array([triangle.area for triangle in triangles])
        triangle = np.random.choice(triangles, p=areas/areas.sum())
        vertices = np.array(triangle.exterior.coords[:3]) 
        weights = np.random.dirichlet(np.ones(3))
        point = weights @ vertices
        return point

KasugaArea = Area(
    (36.087248, 140.103515),
    (36.084353, 140.105566),
    (36.085190, 140.107963),
    (36.086248, 140.108271),
    (36.088668, 140.106547)
)

HirasunaArea = Area(
    (36.0996388, 140.1020336),
    (36.0954847, 140.1030948),
    (36.0959022, 140.1041209),
    (36.0959035, 140.1050384),
    (36.0961024, 140.1062487),
    (36.0987410, 140.1055902),
    (36.0995358, 140.1052788),
)

IshinohirobaArea = Area(
    (36.1099104, 140.1012397),
    (36.1095396, 140.1014375),
    (36.1094797, 140.1018247),
    (36.1100203, 140.1017444)
)

SangakuArea = Area(
    (36.1093592, 140.0993526),
    (36.1101263, 140.1010720),
    (36.1104714, 140.1011049),
    (36.1110028, 140.1008357),
    (36.1114456, 140.1002013),
    (36.1122261, 140.1001199),
    (36.1113784, 140.0983643),
)

AllAreas = [
    "ichinoya",
    "daiichi",
    "daini",
    "daisan",
    "ishinohiroba",
    "hirasuna",
    "oikoshi",
    "igaku",
    "kasuga"
]
