import OSLog

extension Logger {
    static let capture = Logger(subsystem: "app.sonar.ai", category: "capture")
    static let nlp = Logger(subsystem: "app.sonar.ai", category: "nlp")
    static let purchase = Logger(subsystem: "app.sonar.ai", category: "purchase")
    static let perf = Logger(subsystem: "app.sonar.ai", category: "performance")
    static let data = Logger(subsystem: "app.sonar.ai", category: "data")
    static let sync = Logger(subsystem: "app.sonar.ai", category: "sync")
}
