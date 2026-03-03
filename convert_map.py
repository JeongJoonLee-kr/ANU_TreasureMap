import json
import numpy as np
import geopandas as gpd
from rasterio.features import rasterize
from affine import Affine

CELL = 4  # meters per tile

# 1) QGIS에서 export한 파일들
buildings = gpd.read_file("buildings.geojson").to_crs(epsg=32755)
roads     = gpd.read_file("roads.geojson").to_crs(epsg=32755)
parks     = gpd.read_file("parks.geojson").to_crs(epsg=32755)

# 2) 전체 bounds (원하는 경우, parks/roads/buildings 중 일부만으로 bounds 잡아도 됨)
minx = min(buildings.total_bounds[0], roads.total_bounds[0], parks.total_bounds[0])
miny = min(buildings.total_bounds[1], roads.total_bounds[1], parks.total_bounds[1])
maxx = max(buildings.total_bounds[2], roads.total_bounds[2], parks.total_bounds[2])
maxy = max(buildings.total_bounds[3], roads.total_bounds[3], parks.total_bounds[3])

# 3) 타일 그리드 크기
width  = int(np.ceil((maxx - minx) / CELL))
height = int(np.ceil((maxy - miny) / CELL))

# rasterio는 "위에서 아래로" 내려가는 래스터 좌표를 쓰므로 transform 구성
transform = Affine.translation(minx, maxy) * Affine.scale(CELL, -CELL)

# 4) 각 레이어를 래스터로 변환 (값: 1)
parks_r = rasterize(
    [(geom, 1) for geom in parks.geometry if geom is not None],
    out_shape=(height, width),
    transform=transform,
    fill=0,
    all_touched=True
)
roads_r = rasterize(
    [(geom, 1) for geom in roads.geometry if geom is not None],
    out_shape=(height, width),
    transform=transform,
    fill=0,
    all_touched=True
)
bldg_r = rasterize(
    [(geom, 1) for geom in buildings.geometry if geom is not None],
    out_shape=(height, width),
    transform=transform,
    fill=0,
    all_touched=True
)

# 5) 최종 타입 맵 (우선순위: building > road > grass > empty)
grid = np.full((height, width), "empty", dtype=object)
grid[parks_r == 1] = "grass"
grid[roads_r == 1] = "road"
grid[bldg_r == 1]  = "building"

out = {
    "cell_size_m": CELL,
    "origin_utm": [float(minx), float(miny)],
    "width": int(width),
    "height": int(height),
    "grid": grid.tolist()
}

with open("anu_map.json", "w", encoding="utf-8") as f:
    json.dump(out, f, ensure_ascii=False)
print("wrote anu_map.json", width, height)