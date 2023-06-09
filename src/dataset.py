import os
import sys
import random
import tempfile
from urllib import request
from street_view_params import StreetViewParams
from area import KasugaArea, IshinohirobaArea, SangakuArea, HirasunaArea, AllAreas
import cv2

class MakeDataset:
    _api_key: str
    _api_base_url: str = "https://maps.googleapis.com/maps/api/streetview"

    def join_params(self, params: StreetViewParams) -> str:
        return self._api_base_url + str(params)

    def __init__(self) -> None:
        api_key_name = "GOOGLE_MAPS_PLATFORM_API_KEY"
        
        try:
            self._api_key = os.environ[api_key_name]
        except:
            print(f"Error: not found environment variable: {api_key_name}", file=sys.stderr)
            sys.exit(1)

        for area in AllAreas:
            os.makedirs(f"dataset/{area}", exist_ok=True)

    def fetchImage(self, location: tuple[float, float], dir: str) -> bool:
        params = StreetViewParams(self._api_key, location, (640, 640), random.randint(0, 360), 120, 0)
        url = self.join_params(params)
        with tempfile.TemporaryDirectory() as temp_dir:
            request.urlretrieve(url, f"{temp_dir}/streetview.jpg")
            img = cv2.imread(f"{temp_dir}/streetview.jpg")
            cv2.imwrite(f"{dir}/{location[0]}-{location[1]}.jpg", img[0:610, 0:610])
        return True

    def run(self, n: int) -> None:
        self.fetchImage(KasugaArea.get_random_coord(), "dataset/kasuga")
        self.fetchImage(IshinohirobaArea.get_random_coord(), "dataset/ishinohiroba")
        self.fetchImage(SangakuArea.get_random_coord(), "dataset/daisan")
        self.fetchImage(HirasunaArea.get_random_coord(), "dataset/hirasuna")

m = MakeDataset()
m.run(1)
