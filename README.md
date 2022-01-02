開始學習Swift的第一個 Side Project，會想實作 Habit Tracker 主要靈感來自看了『原子習慣』一書，讓我對能幫助自己有效率且能持之以恆培養好習慣的方法感興趣，也在 APP Store 參考了許多類似的作品

## 設計方向

1. 新增習慣有三種模式可以選擇分別是 Count、ML、Mins，Count 模式紀錄一天習慣的次數，像是一天冥想一次，ML 則主要是紀錄一天喝水的量，Mins 則是時間為單位，像是一天運動30分鐘等
2. 習慣紀錄提供快速新增的按鈕、自行輸入或是一鍵完成，讓紀錄習慣是輕鬆且方便的
3. 將每個習慣數據分別用月曆視覺化，可以一目瞭然得知是否已達標以及長期的追蹤習慣養成
4. 加入「尚未有資料」的圖片引導，讓使用者知道要怎麼新增

## 使用技術

在這個作品裡我想練習的部分有以下：

1. 透過 Storyboard 拉 UI 以及 Auto Layout
2. CoreData 來存放永久紀錄
3. 使用 MVC 架構
4. Strategy pattern 實現新增/修改 共用頁面
5. 使用 delegate 在 ViewController 之間傳遞資訊
6. 使用 CocoaPods 管理 Third-Party
7. 使用 Third-Party(Calendar、RingProgress)
    
    [JTAppleCalendar](https://github.com/patchthecode/JTAppleCalendar)
    
    [MKRingProgressView](https://github.com/maxkonovalov/MKRingProgressView)
