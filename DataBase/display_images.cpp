#include<opencv2/highgui/highgui.hpp>
using namespace cv;

int main()
{
    Mat img = imread("images.jpeg");
    imshow("opencvtest", img);
    waitKey(0);

    return 0;
}
