# Testcase LaoOne

Công cụ theo dõi test case (Test Case Tracker) dạng single-file HTML — nhập dữ liệu trực tiếp từ Google Sheet, cập nhật Pass/Fail/Chưa test ngay trên web, và ghi ngược kết quả về đúng ô Status trên Sheet.

## Nội dung repo

| File | Vai trò |
|---|---|
| `NewTC2.html` | Ứng dụng web chính (mở bằng trình duyệt) |
| `Code.gs` | Apps Script Web App — ghi ngược Status về Google Sheet (tùy chọn) |
| `start_server.bat` | Chạy local server trên Windows để tránh lỗi `file://` bị chặn |

## Tính năng

- Nhập test case từ 1 tab hoặc toàn bộ các tab của 1 Google Sheet (không cần API Key).
- Hỗ trợ đọc các cột tiếng Việt: `Mã test case`, `Mục đích kiểm thử`, `Các bước thực hiện`, `Kết quả mong muốn`, `Status`/`Trạng thái`.
- Tự động dò đúng dòng tiêu đề cột dù phía trên có dòng thừa/trống.
- Lọc theo trạng thái, mức độ ưu tiên, tìm kiếm theo ID/tiêu đề.
- Đổi trạng thái Pass/Fail/Chưa test ngay trên bảng — tự động ghi ngược về đúng tab/đúng dòng trên Google Sheet qua Apps Script Web App.
- ID trùng nhau giữa nhiều tab (VD: `TC_1` xuất hiện ở cả tab Login và tab Trang chủ) được xử lý tách biệt — không bị lẫn trạng thái.
- Nút **"🔄 Lấy tên tab thật"** — lấy đúng tên tab từ Apps Script, tránh lỗi lệch tên tab (khoảng trắng ẩn, sai chính tả).
- Giao diện Dark / Light mode, ghi nhớ lựa chọn giữa các lần mở lại.
- Font Noto Sans, hỗ trợ tốt tiếng Việt.

## 1. Cách chạy web

Trình duyệt chặn một số tính năng (JSONP, đọc Google Sheet) nếu mở file trực tiếp kiểu `file:///...`. Cần chạy qua local server:

**Cách nhanh nhất (Windows):** đặt `start_server.bat` cùng thư mục với `NewTC2.html`, double-click file `.bat`. Trình duyệt sẽ tự mở `http://localhost:8080/NewTC2.html`.

Yêu cầu máy đã cài Python (`python --version` để kiểm tra). Nếu không có Python, có thể dùng:
- VS Code + extension **Live Server**, hoặc
- `npx serve .` (yêu cầu Node.js)

## 2. Chuẩn bị Google Sheet

- Sheet phải để chế độ chia sẻ: **Anyone with the link** (ít nhất quyền Viewer).
- Dòng đầu tiên của mỗi tab là dòng tiêu đề cột, gồm các cột (tên có thể khác thứ tự, không bắt buộc đủ hết):

  | Cột | Bắt buộc |
  |---|---|
  | Mã test case / Test Case ID / ID | ✅ |
  | Mục đích kiểm thử / Title | |
  | Các bước thực hiện / Test Steps | |
  | Kết quả mong muốn / Kết quả mong đợi / Expected Result | |
  | Priority / Mức độ ưu tiên | |
  | Status / Trạng thái | (nếu chưa có cột này, Apps Script sẽ tự thêm khi đồng bộ lần đầu) |

## 3. Nhập dữ liệu vào web

1. Dán link hoặc ID Google Sheet vào ô đầu tiên.
2. Chọn 1 tab cụ thể, hoặc chọn **"-- Tải tất cả các tab --"** để gộp toàn bộ 15 tab.
3. Bấm **Nhập dữ liệu**. Kết quả hiển thị kèm số lượng Pass/Fail/Chưa test đọc được, để đối chiếu nhanh với Sheet.

## 4. (Tùy chọn) Ghi ngược Status về Sheet

Nếu chỉ muốn xem/lọc test case, có thể bỏ qua phần này — web vẫn hoạt động, chỉ là đổi trạng thái sẽ không lưu lại khi tải lại trang.

Để đổi trạng thái trên web **tự động cập nhật luôn vào Google Sheet**:

1. Mở Google Sheet → **Extensions → Apps Script** (phải mở từ chính Sheet này, không tạo project rời).
2. Dán toàn bộ nội dung `Code.gs` vào, Lưu.
3. **Deploy → New deployment**:
   - Type: **Web app**
   - Execute as: **Me**
   - Who has access: **Anyone**
4. Deploy, cấp quyền khi được hỏi, copy URL dạng `.../exec`.
5. Dán URL đó vào ô **"Apps Script Web App URL"** trên web.
6. Bấm **"🔄 Lấy tên tab thật"** để đồng bộ đúng tên các tab (khuyến nghị làm bước này trước khi nhập dữ liệu, tránh lệch tên tab).

Sau khi cấu hình xong, mỗi lần đổi Pass/Fail/Chưa test trên web, thanh trạng thái phía dưới toolbar sẽ báo kết quả đồng bộ thật (thành công/lỗi cụ thể), không phải thông báo giả định.

**Mỗi khi sửa `Code.gs`:** phải tạo **New version** trong Manage deployments rồi Deploy lại — nếu không URL `/exec` vẫn chạy code cũ.

## 5. Debug nhanh

| Vấn đề | Cách kiểm tra |
|---|---|
| Web báo `(blocked:origin)` / không nhập được dữ liệu | Đang mở bằng `file://` — chạy qua `start_server.bat` hoặc Live Server |
| Đồng bộ báo "Không tìm thấy tab" | Bấm "🔄 Lấy tên tab thật" để lấy đúng tên tab thay vì gõ tay |
| Status luôn hiện "Chưa test" dù Sheet có Pass/Fail | Mở F12 → Console, xem log `[Import debug]` để biết giá trị Status thực tế đọc được; kiểm tra tên cột Status trên Sheet có khớp `Status`/`Trạng thái` không |
| Đồng bộ báo lỗi kết nối | Kiểm tra deployment Apps Script: Execute as = Me, Access = Anyone, và đã Deploy bản mới nhất |
| Muốn xem Apps Script thấy được những tab nào | Mở `YOUR_EXEC_URL?action=listSheets&callback=x` trực tiếp trên trình duyệt |

## 6. Giới hạn hiện tại

- Không hỗ trợ upload file Excel trực tiếp — chỉ đọc từ Google Sheet đã public link.
- Không có xác thực đăng nhập — ai có file HTML + biết link Sheet đều xem/sửa được, phù hợp dùng nội bộ.
- Dữ liệu trên web chỉ tồn tại trong phiên làm việc hiện tại (không lưu localStorage) — cần Nhập lại dữ liệu mỗi khi mở web mới, trạng thái Pass/Fail thực tế luôn lấy từ Google Sheet làm nguồn chính xác.
