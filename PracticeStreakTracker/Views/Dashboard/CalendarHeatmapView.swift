import SwiftUI

// MARK: - Calendar Heatmap View
/// Displays a visual calendar/heatmap showing practice history.
/// Each day is color-coded: practiced (teal), frozen (ice blue), missed (gray), future (empty).
struct CalendarHeatmapView: View {
    
    @EnvironmentObject var viewModel: StreakViewModel
    @State private var displayedMonth = Date()
    
    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Practice History")
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.horizontal, 4)
            
            VStack(spacing: 12) {
                // Month navigation (< January 2025 >)
                monthNavigator
                
                // S M T W T F S headers
                weekdayHeaders
                
                // Day grid
                calendarGrid
                
                // Color legend
                legend
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.tsBackground)
                    .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
            )
        }
    }
    
    // MARK: - Month Navigator
    /// Arrows to go back/forward between months
    private var monthNavigator: some View {
        HStack {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    displayedMonth = displayedMonth.addingMonths(-1)
                }
                HapticService.shared.selectionChanged()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.body.weight(.semibold))
                    .foregroundColor(.tsSecondaryFallback)
                    .frame(width: 36, height: 36)
            }
            .accessibilityLabel("Previous month")
            
            Spacer()
            
            Text(displayedMonth.monthYearString)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.primary)
            
            Spacer()
            
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    displayedMonth = displayedMonth.addingMonths(1)
                }
                HapticService.shared.selectionChanged()
            } label: {
                Image(systemName: "chevron.right")
                    .font(.body.weight(.semibold))
                    .foregroundColor(canGoForward ? .tsSecondaryFallback : .secondary.opacity(0.3))
                    .frame(width: 36, height: 36)
            }
            .disabled(!canGoForward)
            .accessibilityLabel("Next month")
        }
    }
    
    /// Don't allow navigating past the current month
    private var canGoForward: Bool {
        let now = Date()
        return displayedMonth.month < now.month || displayedMonth.year < now.year
    }
    
    // MARK: - Weekday Headers
    private var weekdayHeaders: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(calendar.veryShortWeekdaySymbols, id: \.self) { symbol in
                Text(symbol)
                    .font(.caption2.weight(.medium))
                    .foregroundColor(.secondary)
                    .frame(height: 20)
            }
        }
    }
    
    // MARK: - Calendar Grid
    /// Shows every day of the displayed month in a 7-column grid.
    /// Empty slots are added before the first day to align with the correct weekday.
    private var calendarGrid: some View {
        let days = daysInMonth()
        let firstWeekday = firstWeekdayOffset()
        
        return LazyVGrid(columns: columns, spacing: 6) {
            // Empty spacers for offset (e.g., if month starts on Wednesday)
            ForEach(0..<firstWeekday, id: \.self) { _ in
                Color.clear
                    .frame(height: 36)
            }
            
            // Actual days
            ForEach(days, id: \.self) { date in
                dayCell(for: date)
            }
        }
    }
    
    // MARK: - Day Cell
    /// A single day square in the calendar grid.
    private func dayCell(for date: Date) -> some View {
        let today = calendar.startOfDay(for: Date())
        let cellDate = calendar.startOfDay(for: date)
        let isToday = calendar.isDate(date, inSameDayAs: today)
        let isFuture = cellDate > today
        let recordType = viewModel.recordType(for: date)
        
        return ZStack {
            // Background color based on status
            RoundedRectangle(cornerRadius: 8)
                .fill(cellColor(recordType: recordType, isFuture: isFuture, isToday: isToday))
                .frame(height: 36)
            
            // Day number
            Text("\(date.dayOfMonth)")
                .font(.caption.weight(isToday ? .bold : .regular))
                .foregroundColor(cellTextColor(recordType: recordType, isFuture: isFuture, isToday: isToday))
            
            // Today indicator ring
            if isToday {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color.tsPrimaryFallback, lineWidth: 2)
                    .frame(height: 36)
            }
        }
        .accessibilityLabel(accessibilityLabel(for: date, recordType: recordType))
    }
    
    // MARK: - Cell Colors
    
    private func cellColor(recordType: PracticeRecord.RecordType?, isFuture: Bool, isToday: Bool) -> Color {
        if isFuture { return Color.heatmapNone.opacity(0.3) }
        guard let type = recordType else { return Color.heatmapNone }
        switch type {
        case .practiced: return Color.heatmapDark
        case .frozen: return Color.streakFreeze.opacity(0.4)
        }
    }
    
    private func cellTextColor(recordType: PracticeRecord.RecordType?, isFuture: Bool, isToday: Bool) -> Color {
        if isFuture { return .secondary.opacity(0.4) }
        if recordType == .practiced { return .white }
        if isToday { return .primary }
        return .primary
    }
    
    // MARK: - Legend
    private var legend: some View {
        HStack(spacing: 16) {
            legendItem(color: .heatmapDark, label: "Practiced")
            legendItem(color: .streakFreeze.opacity(0.4), label: "Frozen")
            legendItem(color: .heatmapNone, label: "Missed")
        }
        .font(.caption2)
        .foregroundColor(.secondary)
        .frame(maxWidth: .infinity)
        .padding(.top, 4)
    }
    
    private func legendItem(color: Color, label: String) -> some View {
        HStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 3)
                .fill(color)
                .frame(width: 12, height: 12)
            Text(label)
        }
    }
    
    // MARK: - Helpers
    
    /// Returns all dates in the currently displayed month
    private func daysInMonth() -> [Date] {
        displayedMonth.datesInMonth()
    }
    
    /// Returns the weekday offset (0 = Sunday start) for the first day of the displayed month
    private func firstWeekdayOffset() -> Int {
        let firstDay = displayedMonth.firstDayOfMonth
        return calendar.component(.weekday, from: firstDay) - 1
    }
    
    /// Accessibility label for a calendar cell
    private func accessibilityLabel(for date: Date, recordType: PracticeRecord.RecordType?) -> String {
        let dateStr = date.fullDateString
        switch recordType {
        case .practiced: return "\(dateStr), practiced"
        case .frozen: return "\(dateStr), streak frozen"
        case .none: return "\(dateStr), no practice"
        }
    }
}
