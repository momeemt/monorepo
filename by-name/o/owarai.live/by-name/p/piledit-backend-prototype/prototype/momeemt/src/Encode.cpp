#include <fstream>
#include <opencv2/opencv.hpp>
#include "picojson.h"

class Encode {
    cv::VideoCapture loadVideoFile(std::string videoPath) {
        cv::VideoCapture cap;
        cap.open(videoPath);
        if(!cap.isOpened()) {
            throw "MovieEdit cannot load this file.";
        }
        return cap;
    }

    cv::VideoCapture outputMp4(/* jsonが渡される */) {

    }
};