import os
import sys
import random
import tempfile
from urllib import request
from street_view_params import StreetViewParams
from area import Area, Areas
import cv2
import numpy as np

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

        for area in Areas:
            os.makedirs(f"dataset/{area.get_name()}", exist_ok=True)

    def is_no_imagery(self, img: np.ndarray) -> bool:
        def hist(img: np.ndarray):
            return cv2.calcHist([img], [0], None, [256], [0, 256])

        no_imagery = cv2.imread("assets/no-imagery.jpg")
        return cv2.compareHist(hist(no_imagery), hist(img), 0) >= 0.99999

    def fetchImage(self, area: Area) -> None:
        dir = "dataset/" + area.get_name()
        while True:
            location = area.get_random_coord()
            params = StreetViewParams(self._api_key, location, (640, 640), random.randint(0, 360), 100, 0)
            url = self.join_params(params)
            with tempfile.TemporaryDirectory() as temp_dir:
                request.urlretrieve(url, f"{temp_dir}/streetview.jpg")
                img = cv2.imread(f"{temp_dir}/streetview.jpg")
                img = img[0:610, 0:610]
                if self.is_no_imagery(img):
                    print("got no-imagery")
                else:
                    cv2.imwrite(f"{dir}/{location[0]}-{location[1]}.jpg", img)
                    return
                
    def run(self, n: int) -> None:
        for _ in range(n):
            for area in Areas:
                self.fetchImage(area)

m = MakeDataset()
m.run(10)
