//
//  ContentView.swift
//  LargeFileDownloader
//
//  Created by Dmitrii Pogonia on 27.03.2026.
//

import SwiftUI

struct ContentView: View {
    // 1. Состояние для показа уведомления
    @State private var showAlert = false
    private var manager = DownloadManager()
    
    var body: some View {
        VStack(spacing: 20) {
            // В SwiftUI используем стандартный ProgressView
            ProgressView(value: manager.progress, total: 4.0)
                .progressViewStyle(.linear)
            
            Button("Загрузить файл") {
                // Вызываем функцию
                downloadLargeFile()
            }
            
            Text("Прогресс: \(Int((manager.progress / 4.0) * 100))%")
        }
        .padding()
        // 2. SwiftUI-способ показа алертов
        .alert("Готово!", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Файл успешно загружен")
        }
    }
    
    // 3. Функция вынесена за пределы body
    func downloadLargeFile() {
        // Используем современный Swift Concurrency вместо DispatchQueue
        Task {
            await manager.startDownload()
            showAlert = true
            manager.progress = 0
        }
        
    }
}

@Observable // Для iOS 17+ (или class + ObservableObject для старых версий)
class DownloadManager {
    var progress: Double = 0.0
    var isFinished = false
    
    func startDownload() async {
        for i in 1...4 {
            try? await Task.sleep(for: .seconds(1))
            progress = Double(i)
        }
        isFinished = true
    }
}

#Preview {
    ContentView()
}
