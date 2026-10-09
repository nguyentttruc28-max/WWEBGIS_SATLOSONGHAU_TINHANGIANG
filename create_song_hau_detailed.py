import geopandas as gpd
from shapely.geometry import LineString
from pathlib import Path
import json, zipfile, shutil

out=Path('/mnt/data/v64river/public/river')
out.mkdir(parents=True,exist_ok=True)

# Detailed reference geometry for WebGIS visualization.
# Main stem follows published Hau River anchor points plus OSM junctions.
# Branches included are major connected distributaries visible in the An Giang study area.
features=[
    {
        'river_name':'Sông Hậu',
        'feature_type':'Đoạn chính',
        'source':'Tổng hợp điểm tham chiếu công khai: TT 17/2017/TT-BTNMT; Vu et al. (2024); OSM/WaterwayMap 2026',
        'coords':[
            (105.081111,10.957500),(105.0848,10.9400),(105.0895,10.9200),(105.0940,10.9000),
            (105.0990,10.8780),(105.1045,10.8550),(105.1100,10.8320),(105.1160,10.8070),
            (105.1210,10.7830),(105.1245,10.7590),(105.1265,10.7360),(105.1260,10.7160),
            (105.1280,10.6970),(105.1350,10.6780),(105.1470,10.6590),(105.1630,10.6410),
            (105.1820,10.6240),(105.2040,10.6070),(105.2280,10.5900),(105.2520,10.5740),
            (105.2760,10.5590),(105.2970,10.5480),(105.3150,10.5410),(105.3275,10.5386),
            (105.3390,10.5260),(105.3510,10.5130),(105.3630,10.4990),(105.3750,10.4840),
            (105.3870,10.4680),(105.3990,10.4520),(105.4110,10.4350),(105.4230,10.4180),
            (105.4330,10.4020),(105.4371,10.3917),(105.4420,10.3780),(105.4500,10.3640),
            (105.4600,10.3510),(105.4720,10.3390),(105.493333,10.323889)
        ]
    },
    {
        'river_name':'Sông Châu Đốc',
        'feature_type':'Phân lưu kết nối Sông Hậu',
        'source':'OSM/WaterwayMap 2026; điểm nối Sông Châu Đốc–Sông Hậu',
        'coords':[
            (105.0870,10.7440),(105.0940,10.7360),(105.1010,10.7280),(105.1090,10.7200),
            (105.1170,10.7140),(105.1256,10.7094)
        ]
    },
    {
        'river_name':'Sông Vàm Nao',
        'feature_type':'Phân lưu kết nối Sông Hậu',
        'source':'OSM/WaterwayMap 2026; Vu et al. (2024)',
        'coords':[
            (105.2874,10.5541),(105.2960,10.5510),(105.3050,10.5470),(105.3140,10.5430),
            (105.3220,10.5400),(105.3275,10.5386)
        ]
    },
    {
        'river_name':'Rạch Ông Chưởng',
        'feature_type':'Phân lưu kết nối Sông Hậu',
        'source':'OSM/WaterwayMap 2026; điểm nối công khai',
        'coords':[
            (105.4100,10.4580),(105.4190,10.4500),(105.4280,10.4410),(105.4380,10.4320),
            (105.4470,10.4250),(105.4558,10.4242)
        ]
    }
]

records=[]
for f in features:
    records.append({**{k:f[k] for k in ['river_name','feature_type','source']}, 'geometry':LineString(f['coords'])})

gdf=gpd.GeoDataFrame(records, crs='EPSG:4326')

# Remove previous reference files.
for p in out.glob('song_hau_reference.*'):
    p.unlink()

base=out/'song_hau_detailed'
gdf.to_file(base.with_suffix('.shp'), driver='ESRI Shapefile', encoding='UTF-8')
# GeoJSON for Leaflet
gdf.to_file(base.with_suffix('.geojson'), driver='GeoJSON')
(base.with_suffix('.cpg')).write_text('UTF-8', encoding='ascii')

meta=(
'WEBGIS SÔNG HẬU – LỚP ĐƯỜNG SÔNG CHI TIẾT\n'
'Loại dữ liệu: Multi-line reference geometry for WebGIS visualization.\n'
'Hệ tọa độ: WGS 84 / EPSG:4326.\n'
'Nguồn tham chiếu: Thông tư 17/2017/TT-BTNMT (phạm vi điểm đầu/cuối Sông Hậu); Vu et al. (2024) (điểm nghiên cứu trên Sông Hậu); OpenStreetMap/WaterwayMap (2026) (các điểm nối/phân lưu công khai).\n'
'Tình trạng: Đây là hình học tham chiếu được dựng lại từ các điểm công khai để bám sát hướng tuyến thực tế trên nền bản đồ. Không phải đường bờ sông, không phải bản đồ địa hình tỷ lệ lớn và không thay thế dữ liệu đo đạc/đo vẽ thủy văn chính thức.\n'
'Mục đích: làm nổi bật Sông Hậu và một số phân lưu kết nối trong WebGIS quản lý sạt lở.\n'
'Ghi chú: hình học chi tiết hơn bản reference trước; không nên ghi là shapefile khảo sát chính thức trong báo cáo.\n'
)
(out/'song_hau_detailed_sources.txt').write_text(meta,encoding='utf-8')

# Create zip of just the shapefile package.
zip_path=Path('/mnt/data/SONG-HAU-DETAILED-SHAPEFILE-WEBGIS.zip')
if zip_path.exists(): zip_path.unlink()
with zipfile.ZipFile(zip_path,'w',zipfile.ZIP_DEFLATED) as z:
    for ext in ['.shp','.shx','.dbf','.prj','.cpg']:
        z.write(base.with_suffix(ext), arcname='song_hau_detailed'+ext)
    z.write(out/'song_hau_detailed_sources.txt', arcname='song_hau_detailed_sources.txt')

print(gdf[['river_name','feature_type']])
print('files:', [p.name for p in out.glob('song_hau_detailed.*')])
print('zip', zip_path, zip_path.stat().st_size)
