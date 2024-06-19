// Flow:
// 1. Start stream -> filter point get face (50 -> 200) (60 frame/s) -> cập nhật isDetected (Còn lại 1 frame xử lý) -> firebase face detection.
// 2. Check độ sáng(Chuyển ảnh sang grayscale > 80) -> Check distance(kích thước khuôn mặt)
// 3. Check quay trái quay phải (thông qua mắt trái và mắt phải).