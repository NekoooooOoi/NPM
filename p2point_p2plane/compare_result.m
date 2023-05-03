function result = compare_result(result1,result2)
result.p2point_MSE = max(result1.p2point_MSE,result2.p2point_MSE);
result.p2point_MSE_PSNR = min(result1.p2point_MSE_PSNR,result2.p2point_MSE_PSNR);
result.p2plane_MSE = max(result1.p2plane_MSE,result2.p2plane_MSE);
result.p2plane_MSE_PSNR = min(result1.p2plane_MSE_PSNR,result2.p2plane_MSE_PSNR);

end