class StreetViewParams:
    _location: tuple[float, float]
    _size: tuple[int, int]
    _key: str
    _heading: int
    _fov: int
    _pitch: int

    def __init__(self, key: str, location: tuple[float, float], size: tuple[int, int], heading: int, fov: int, pitch: int) -> None:
        self._key = key
        self._location = location
        
        if 0 <= size[0] <= 640 and 0 <= size[1] <= 640:
            self._size = size
        else:
            raise ValueError(f"The values passed are as follows height: {size[0]}, width: {size[1]} but both must satisfy 0 <= x <= 640.")
        
        if 0 <= heading <= 360:
            self._heading = heading
        else:
            raise ValueError(f"The values passed are as follows heading: {heading} but both must satisfy 0 <= x <= 360.")
        
        if 0 <= fov <= 120:
            self._fov = fov
        else:
            raise ValueError(f"The values passed are as follows fov: {fov} but both must satisfy 0 <= x <= 120.")
        
        if -90 <= pitch <= 90:
            self._pitch = pitch
        else:
            raise ValueError(f"The values passed are as follows pitch: {pitch} but both must satisfy -90 <= x <= 90.")
    
    def __str__(self) -> str:
        return f"?location={self._location[0]},{self._location[1]}&size={self._size[0]}x{self._size[1]}&heading={self._heading}&fov={self._fov}&pitch={self._pitch}&key={self._key}"
