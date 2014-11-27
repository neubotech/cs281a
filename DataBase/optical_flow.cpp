
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/video/tracking.hpp>
#include <opencv2/core/core.hpp>

#include <stdio.h>
#include <vector>
#include <iostream>
#include <fstream>

using namespace cv;
using namespace std;

static void substract_mean_CV(Mat& flow){

    Scalar m = mean( flow );
    for (int y = 0; y < flow.rows; y++){
      for (int x = 0; x < flow.cols; x++) {
        flow.at<uchar>(y, x) = saturate_cast<uchar> (flow.at<uchar>(y, x) - m[0]);
      }
    }
}

int main()
{
    const int64 start = getTickCount();

    Mat imgA = imread("Pictures/v_ApplyEyeMakeup_g01_c01_1_1.jpg");
    Mat imgB = imread("Pictures/v_ApplyEyeMakeup_g01_c01_6_11.jpg");

    cvtColor(imgA, imgA, COLOR_BGR2GRAY);
    cvtColor(imgB, imgB, COLOR_BGR2GRAY);

   // cout << "imgA" <<endl << " " << imgA << endl << endl;

    Mat flow;
    vector<Mat> imgC;
    
    // DenseOpticalFlow::calc(imgA, imgB, imgC);
    calcOpticalFlowFarneback(imgA, imgB, flow, 0.5, 3, 15, 3, 5, 1.2, OPTFLOW_FARNEBACK_GAUSSIAN);

    // normalize( flow, flow, 0, 255, NORM_MINMAX, CV_8UC2);
    flow.convertTo(flow, CV_8U, 255);
    split(flow, imgC);
    substract_mean_CV(imgC[0]);
    substract_mean_CV(imgC[1]);


  // flow.convertTo(flow, CV_8UC2);  
    imwrite("flowX.jpg", imgC[0]);
    imwrite("flowY.jpg", imgC[1]);

    const double timeSec = (getTickCount() - start) / getTickFrequency();
    cout << "Time for FarneBack Optical Flow:\t" << timeSec  
      << " sec" << endl;
   // imshow("prev", imgA);
   // imshow("next", imgB);
   // imshow("flowX", imgC[0]);
   // imshow("flowY", imgC[1]);
   // waitKey(0);

    return 0;
}
