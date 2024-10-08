import SwiftUI

struct CreateMeetingView: View {
    @State private var topic = ""
    @State private var startDate = Date()
    @State private var startTime = Date()
    @State private var duration = 0
    
    let durations = ["15 minutes", "30 minutes", "45 minutes", "1 hour", "1.5 hours", "2 hours"] // Add more if needed
    
    var body: some View {
        VStack {
            TextField("Meeting Topic", text: $topic)
                .padding()
            
            DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                .padding()
            
            DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                .padding()
            
            Picker(selection: $duration, label: Text("Duration")) {
                ForEach(0..<durations.count) {
                    Text(self.durations[$0])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Button(action: createMeeting) {
                Text("Create Meeting")
            }
            .padding()
        }
        .navigationBarTitle("Create Meeting")
    }
    
    func createMeeting() {
        let meetingURL = generateGoogleMeetURL()
        if let url = URL(string: meetingURL) {
            UIApplication.shared.open(url)
        }
    }
    
    func generateGoogleMeetURL() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss"
        
        let formattedStartDate = dateFormatter.string(from: startDate)
        let formattedStartTime = dateFormatter.string(from: startTime)
        
        let durationMinutes = getSelectedDuration()
        
        // Constructing the Google Meet web URL with parameters
        let url = "https://meet.google.com/new?date=\(formattedStartDate)&time=\(formattedStartTime)&duration=\(durationMinutes)"
        return url
    }
    
    func getSelectedDuration() -> Int {
        // Convert selected duration to minutes (for example purposes)
        switch duration {
        case 0:
            return 15
        case 1:
            return 30
        case 2:
            return 45
        case 3:
            return 60
        case 4:
            return 90
        case 5:
            return 120
        default:
            return 0
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CreateMeetingView()
    }
}
