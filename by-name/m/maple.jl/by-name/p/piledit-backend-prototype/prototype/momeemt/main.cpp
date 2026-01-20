#include <string>
#include <fstream>
#include <opencv2/opencv.hpp>
#include "src/preview.cpp"
#include "src/picojson.h"

int main(int argc, char* argv[]) {
    cv::VideoCapture cap;

    //std::cout << "Input json file which is about editing movie tasks." << std::endl;
    std::ifstream fs;
    fs.open("tasks.json", std::ios::binary);
    // assert(fs);

    //std::cout << "Input a path of the target video." << std::endl;
    //std::string video_path;
    //std::cin >> video_path;
    //cap.open(video_path);

//    if(cap.isOpened() == false) {
//        std::cout << "This file is broken." << std::endl;
//        return -1;
//    }

    picojson::value val;
    fs >> val;
    fs.close();

    val.get<picojson::object>()
            ["info"].get<picojson::object>()
            ["tasks_count"].get<double>();

    std::cout << val << std::endl;

    return 0;
}
